.data
m: .space 30
n: .space 30
p: .space 30
k: .space 30
evolutie: .space 30
matrice: .space 3600
matrice_auxiliara: .space 3600
indexlinie: .space 30
indexcoloana: .space 30
celula_vie: .space 30
formatScanf: .asciz "%d"
formatPrintf: .asciz "%d "
newline: .asciz "\n"

.text

.global main
main:
    pusha
	pushl $m
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa

    pusha
    pushl $n
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa

    pusha
    pushl $p
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa 

incl m 
incl m 
// m = 5
incl n 
incl n 
// n = 6

movl $0, celula_vie
et_for:
    movl celula_vie, %ecx
    cmp %ecx, p 
    je citire_k


    pusha
    pushl $indexlinie
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa

    pusha
    pushl $indexcoloana
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa 



    // celula_vie = indexlinie * n (nr coloane) + indexcoloana
    xor %ebx, %ebx
    xor %edx, %edx
    movl indexlinie, %eax
    incl %eax
    movl n, %ebx 
    mull %ebx
    addl indexcoloana, %eax
    incl %eax
    lea matrice, %edi
    movl $1, (%edi, %eax, 4)
    
    incl celula_vie
    jmp et_for



citire_k:
    pusha
    pushl $k
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    popa

movl $0, evolutie

parcurgere_elemente:   
movl evolutie, %ecx
cmp %ecx, k 
je afisare_matrice
movl $1, indexlinie
movl $1, indexcoloana
    for_linii:
    movl m, %ebx
    decl %ebx
    cmp indexlinie, %ebx 
    je copiere_matrice

        for_coloane:
        movl n, %ecx
        decl %ecx
        cmp indexcoloana, %ecx
        je urmatoarea_linie

            parcurgere_vecini:
            movl $0, %ebx
            lea matrice, %edi
            movl indexlinie, %eax
            decl %eax
            mull n 
            addl indexcoloana, %eax
            decl %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i-1][j-1]


            movl indexlinie, %eax
            decl %eax 
            mull n 
            addl indexcoloana, %eax 
            addl (%edi, %eax, 4), %ebx 
            #a[i-1][j]


            movl indexlinie, %eax
            decl %eax
            mull n 
            addl indexcoloana, %eax 
            incl %eax 
            addl (%edi, %eax, 4), %ebx 
            #a[i-1][j+1]


            movl indexlinie, %eax
            mull n 
            addl indexcoloana, %eax
            decl %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i][j-1]

	

            movl indexlinie, %eax
            mull n 
            addl indexcoloana, %eax
            incl %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i][j+1]



            movl indexlinie, %eax
            incl %eax 
            mull n 
            addl indexcoloana, %eax
            decl %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i+1][j-1]
                        

            movl indexlinie, %eax
            incl %eax
            mull n 
            addl indexcoloana, %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i+1][j]

            movl indexlinie, %eax
            incl %eax
            mull n 
            addl indexcoloana, %eax 
            incl %eax
            addl (%edi, %eax, 4), %ebx 
            #a[i+1][j+1]

			
            movl indexlinie, %eax
            mull n 
            addl indexcoloana, %eax
            movl (%edi, %eax, 4), %edx #a11


            cmp $1, %edx
            je verificare_vecini_celula_vie
            jl verificare_vecini_celula_moarta

                    verificare_vecini_celula_vie:
                        cmp $2, %ebx
                        je viata
						jl moarte
                        cmp $3, %ebx
                        je viata
						jg moarte
                        

                    verificare_vecini_celula_moarta:
                        cmp $3, %ebx 
                        je viata
                        jmp moarte


                            viata:
                            movl indexlinie, %eax
                            mull n 
                            addl indexcoloana, %eax 
                            lea matrice_auxiliara, %edi
                            movl $1, (%edi, %eax, 4)
                            jmp urmatoarea_coloana

                            moarte:
                            movl indexlinie, %eax
                            mull n 
                            addl indexcoloana, %eax 
                            lea matrice_auxiliara, %edi
                            movl $0, (%edi, %eax, 4)
                            jmp urmatoarea_coloana

urmatoarea_coloana:
    incl indexcoloana
    jmp for_coloane


urmatoarea_linie:
    movl $1, indexcoloana
    incl indexlinie         # Treci la următoarea linie 
    jmp for_linii  # Altfel, continuă cu următoarea linie și coloana 1


copiere_matrice:
	movl $0, indexlinie
	for_linie_copiere:
		movl indexlinie, %ecx
		cmp %ecx, m
		je creste_k
		
		movl $0, indexcoloana
		for_coloana_copiere:
			movl indexcoloana, %ecx
			cmp %ecx, n
			je resetare_linie_copiere
			
			movl indexlinie, %eax
			movl $0, %edx
			mull n
			addl indexcoloana, %eax
	
			lea matrice_auxiliara, %edi                 
            movl (%edi, %eax, 4), %ebx          
            lea matrice, %edi
            movl %ebx, (%edi, %eax, 4)          

			incl indexcoloana
			jmp for_coloana_copiere

		resetare_linie_copiere:
        incl indexlinie
		movl $0, %edx
		movl %edx, indexcoloana
		jmp for_linie_copiere


creste_k:
incl evolutie
jmp parcurgere_elemente


afisare_matrice:
	movl $1, indexlinie
	for_linie:
		movl m, %ecx
		decl %ecx
        cmp indexlinie, %ecx
		je et_exit
		
		movl $1, indexcoloana
		for_coloana:
			movl n, %ecx
			decl %ecx
            cmp indexcoloana, %ecx
			je cont
			
			movl indexlinie, %eax
			movl $0, %edx
			mull n
			addl indexcoloana, %eax
			
			
			lea matrice, %edi
			movl (%edi, %eax, 4), %ebx

			pushl %ebx
			pushl $formatPrintf
			call printf
			popl %ebx
			popl %ebx
			
			pushl $0
			call fflush
			popl %ebx
			
			incl indexcoloana
			jmp for_coloana
		
	cont:
		movl $4, %eax
		movl $1, %ebx
		movl $newline, %ecx
		movl $2, %edx
		int $0x80
		
		incl indexlinie
		jmp for_linie

et_exit:
movl $1, %eax
xor %ebx, %ebx
int $0x80

        