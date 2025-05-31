matrix_multiply:
    # store values of all used registers into the stack
    addi sp, sp, -4
    sw a2, 0(sp)
    addi sp, sp, -4
    sw s0, 0(sp)
    addi sp, sp, -4
    sw s1, 0(sp)
    addi sp, sp, -4
    sw s2, 0(sp)
    addi sp, sp, -4
    sw s3, 0(sp)
    addi sp, sp, -4
    sw s4, 0(sp)
    addi sp, sp, -4
    sw s5, 0(sp)
    addi sp, sp, -4
    sw s6, 0(sp)
    addi sp, sp, -4
    sw s7, 0(sp)
    addi sp, sp, -4
    sw t0, 0(sp)
    addi sp, sp, -4
    sw t1, 0(sp)
    addi sp, sp, -4
    sw t2, 0(sp)
    addi sp, sp, -4
    sw t3, 0(sp)
    addi sp, sp, -4
    sw t4, 0(sp)
    addi sp, sp, -4
    sw t5, 0(sp)
    addi sp, sp, -4
    sw t6, 0(sp)

    li s0, 1
    lw s1, 0(a0)    # a rows
    lw s2, 4(a0)    # a columns
    lw s3, 0(a1)    # b rows
    lw s4, 4(a1)    # b columns
    blt s1, s0, invalid_dim
    blt s2, s0, invalid_dim
    blt s3, s0, invalid_dim
    blt s4, s0, invalid_dim
    bne s2, s3, incompatible

    addi sp, sp, -4
    sw ra, 0(sp)

    # initialize registers to be used
    li, s0, 4
    add t0, x0, x0  # loop1 counter
    add t1, x0, x0  # loop2 counter
    add t2, x0, x0  # loop3 counter
    add t4, x0, x0  # sum

    add s7, x0, sp
    add sp, x0, s1
    sw sp, 0(a2)        # store row dimensions
    addi a2, a2, 4
    add sp, x0, s4
    sw sp, 0(a2)        # store column dimensions
    addi a2, a2, 4
    add sp, x0, s7

    jal loop1

    lw ra, 0(sp)
    addi sp, sp, 4

registers:
    # reset all used registers
    lw t6, 0(sp)
    addi sp, sp, 4
    lw t5, 0(sp)
    addi sp, sp, 4
    lw t4, 0(sp)
    addi sp, sp, 4
    lw t3, 0(sp)
    addi sp, sp, 4
    lw t2, 0(sp)
    addi sp, sp, 4
    lw t1, 0(sp)
    addi sp, sp, 4
    lw t0, 0(sp)
    addi sp, sp, 4
    lw s7, 0(sp)
    addi sp, sp, 4
    lw s6, 0(sp)
    addi sp, sp, 4
    lw s5, 0(sp)
    addi sp, sp, 4
    lw s4, 0(sp)
    addi sp, sp, 4
    lw s3, 0(sp)
    addi sp, sp, 4
    lw s2, 0(sp)
    addi sp, sp, 4
    lw s1, 0(sp)
    addi sp, sp, 4
    lw s0, 0(sp)
    addi sp, sp, 4
    lw a2, 0(sp)
    addi sp, sp, 4

    jr ra

loop1:
    addi sp, sp, -4
    sw ra, 0(sp)
    
    jal loop2

    addi t0, t0, 1      # loop1 counter +1

    lw ra, 0(sp)
    addi sp, sp, 4

    add t1, x0, x0      # reset loop2 counter

    bne t0, s1, loop1   # while loop1 counter <= a rows

    jr ra

loop2:
    addi sp, sp, -4
    sw ra, 0(sp)

    jal loop3

    add s7, x0, sp
    add sp, x0, t4
    sw sp, 0(a2)
    add sp, x0, s7
    addi a2, a2, 4
    
    add t2, x0, x0      # reset loop3 counter
    add t4, x0, x0      # reset sum

    addi t1, t1, 1      # loop2 counter +1
    
    lw ra, 0(sp)
    addi sp, sp, 4

    bne t1, s4, loop2   # while loop2 counter <= b columns

    jr ra

loop3:
    addi sp, sp, -4
    sw ra, 0(sp)

    # load matrix a index
    mul s5, t0, s2
    add s5, s5, t2
    mul s5, s5, s0
    addi s5, s5, 8      # disregard row and column words
    add s5, a0, s5      # address of index
    lw t5, 0(s5)        # load value at index into t5

    # load matrix b index
    mul s6, t2, s4
    add s6, s6, t1
    mul s6, s6, s0
    addi s6, s6, 8      # disregard row and column words
    add s6, a1, s6      # address of index
    lw t6, 0(s6)        # load value at index into t6

    mul t3, t5, t6
    add t4, t4, t3

    addi t2, t2, 1      # loop3 counter +1

    lw ra, 0(sp)
    addi sp, sp, 4

    bne t2, s2, loop3   # while loop3 counter <= a columns or b rows

    jr ra

invalid_dim:
    li s0, -1

    add s7, x0, sp
    add sp, x0, s0
    sw sp, 0(a2)
    add sp, x0, s7
    
    j registers

incompatible:
    li s0, -2
    
    add s7, x0, sp
    add sp, x0, s0
    sw sp, 0(a2)
    add sp, x0, s7

    j registers