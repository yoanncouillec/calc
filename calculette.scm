(module calculette)

(define (evaluate expression)
   (match-case expression
      ((? number?)
       expression)
      ((+ ?a1 ?a2)
       (+ (evaluate a1) (evaluate a2)))
      ((- ?a1 ?a2)
       (- (evaluate a1) (evaluate a2)))
      ((* ?a1 ?a2)
       (* (evaluate a1) (evaluate a2)))
      ((= ?a1 ?a2)
       (if (= (evaluate a1) (evaluate a2)) 1 0))))

(define (compile expression next)
   (match-case expression
      ((? number?)
       (cons `(LOADCTE ,expression) next))
      ((+ ?a1 ?a2)
       (compile a1
	  (compile a2
	     (cons 'ADD next))))
      ((- ?a1 ?a2)
       (compile a1
	  (compile a2
	     (cons 'SUB next))))
      ((* ?a1 ?a2)
       (compile a1
	  (compile a2
	     (cons 'MUL next))))
      ((= ?a1 ?a2)
       (compile a1
	  (compile a2
	     (cons 'CMP next))))))

(define (exec code stack)
   (match-case (car code)
      ((LOADCTE ?n)
       (exec (cdr code) (cons n stack)))
      (ADD
       (exec (cdr code) (cons (+ (cadr stack) (car stack)) (cddr stack))))
      (SUB
       (exec (cdr code) (cons (- (cadr stack) (car stack)) (cddr stack))))
      (MUL
       (exec (cdr code) (cons (* (cadr stack) (car stack)) (cddr stack))))
      (CMP
       (exec (cdr code) (cons (if (= (cadr stack) (car stack)) 1 0) (cddr stack))))
      (STOP
       (car stack))))

(define e '(- (* (+ 10 97) 72) 13))
(print "Evaluate = "(evaluate e))
(print "Execute = " (exec (print "Compile = " (compile '(- (* (+ 10 97) 72) 13) '(STOP))) '()))
