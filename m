Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405Ab0AGWhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0AGWhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326Ab0AGWgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:36:35 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46421 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab0AGWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:36:34 -0500
Message-Id: <20100107223547.679172327@quilx.com>
References: <20100107223524.760517016@quilx.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 Jan 2010 16:35:25 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC local_t removal V2 1/3] Remove unused local.h functions
Content-Disposition: inline; filename=remove_unused_local.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ringbuffer logic is the last user of local.h and it uses only the
following functions and types:

local_t

local_set()
local_read()

local_add_return()
local_add()
local_sub()
local_inc()
local_dec()

local_cmpxchg()

Keep those and remove all other local.h functions

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/alpha/include/asm/local.h   |   61 -------------
 arch/m32r/include/asm/local.h    |  181 ---------------------------------------
 arch/mips/include/asm/local.h    |  120 -------------------------
 arch/powerpc/include/asm/local.h |  133 ----------------------------
 arch/x86/include/asm/local.h     |  118 -------------------------
 include/asm-generic/local.h      |   16 ---
 6 files changed, 3 insertions(+), 626 deletions(-)

Index: linux-2.6/arch/powerpc/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/local.h	2010-01-07 16:05:53.000000000 -0600
+++ linux-2.6/arch/powerpc/include/asm/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -36,140 +36,7 @@ static __inline__ long local_add_return(
 	return t;
 }
 
-#define local_add_negative(a, l)	(local_add_return((a), (l)) < 0)
-
-static __inline__ long local_sub_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:"	PPC_LLARX	"%0,0,%2		# local_sub_return\n\
-	subf	%0,%1,%0\n"
-	PPC405_ERR77(0,%2)
-	PPC_STLCX	"%0,0,%2 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (a), "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-static __inline__ long local_inc_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:"	PPC_LLARX	"%0,0,%1		# local_inc_return\n\
-	addic	%0,%0,1\n"
-	PPC405_ERR77(0,%1)
-	PPC_STLCX	"%0,0,%1 \n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "xer", "memory");
-
-	return t;
-}
-
-/*
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define local_inc_and_test(l) (local_inc_return(l) == 0)
-
-static __inline__ long local_dec_return(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:"	PPC_LLARX	"%0,0,%1		# local_dec_return\n\
-	addic	%0,%0,-1\n"
-	PPC405_ERR77(0,%1)
-	PPC_STLCX	"%0,0,%1\n\
-	bne-	1b"
-	: "=&r" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "xer", "memory");
-
-	return t;
-}
-
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, n) (xchg_local(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-static __inline__ int local_add_unless(local_t *l, long a, long u)
-{
-	long t;
-
-	__asm__ __volatile__ (
-"1:"	PPC_LLARX	"%0,0,%1		# local_add_unless\n\
-	cmpw	0,%0,%3 \n\
-	beq-	2f \n\
-	add	%0,%2,%0 \n"
-	PPC405_ERR77(0,%2)
-	PPC_STLCX	"%0,0,%1 \n\
-	bne-	1b \n"
-"	subf	%0,%2,%0 \n\
-2:"
-	: "=&r" (t)
-	: "r" (&(l->a.counter)), "r" (a), "r" (u)
-	: "cc", "memory");
-
-	return t != u;
-}
-
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
-#define local_dec_and_test(l)		(local_dec_return((l)) == 0)
-
-/*
- * Atomically test *l and decrement if it is greater than 0.
- * The function returns the old value of *l minus 1.
- */
-static __inline__ long local_dec_if_positive(local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:"	PPC_LLARX	"%0,0,%1		# local_dec_if_positive\n\
-	cmpwi	%0,1\n\
-	addi	%0,%0,-1\n\
-	blt-	2f\n"
-	PPC405_ERR77(0,%1)
-	PPC_STLCX	"%0,0,%1\n\
-	bne-	1b"
-	"\n\
-2:"	: "=&b" (t)
-	: "r" (&(l->a.counter))
-	: "cc", "memory");
-
-	return t;
-}
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-
-#define __local_inc(l)		((l)->a.counter++)
-#define __local_dec(l)		((l)->a.counter++)
-#define __local_add(i,l)	((l)->a.counter+=(i))
-#define __local_sub(i,l)	((l)->a.counter-=(i))
 
 #endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/arch/x86/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/local.h	2010-01-07 16:05:53.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -43,80 +43,6 @@ static inline void local_sub(long i, loc
 }
 
 /**
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer to type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_sub_and_test(long i, local_t *l)
-{
-	unsigned char c;
-
-	asm volatile(_ASM_SUB "%2,%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_dec_and_test - decrement and test
- * @l: pointer to type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int local_dec_and_test(local_t *l)
-{
-	unsigned char c;
-
-	asm volatile(_ASM_DEC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * local_inc_and_test - increment and test
- * @l: pointer to type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int local_inc_and_test(local_t *l)
-{
-	unsigned char c;
-
-	asm volatile(_ASM_INC "%0; sete %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * local_add_negative - add and test if negative
- * @i: integer value to add
- * @l: pointer to type local_t
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int local_add_negative(long i, local_t *l)
-{
-	unsigned char c;
-
-	asm volatile(_ASM_ADD "%2,%0; sets %1"
-		     : "+m" (l->a.counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
  * local_add_return - add and return
  * @i: integer value to add
  * @l: pointer to type local_t
@@ -148,51 +74,7 @@ no_xadd: /* Legacy 386 processor */
 #endif
 }
 
-static inline long local_sub_return(long i, local_t *l)
-{
-	return local_add_return(-i, l);
-}
-
-#define local_inc_return(l)  (local_add_return(1, l))
-#define local_dec_return(l)  (local_sub_return(1, l))
-
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
-/* Always has a lock prefix */
-#define local_xchg(l, n) (xchg(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-#define local_add_unless(l, a, u)				\
-({								\
-	long c, old;						\
-	c = local_read((l));					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = local_cmpxchg((l), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-/* On x86_32, these are no better than the atomic variants.
- * On x86-64 these are better than the atomic variants on SMP kernels
- * because they dont use a lock prefix.
- */
-#define __local_inc(l)		local_inc(l)
-#define __local_dec(l)		local_dec(l)
-#define __local_add(i, l)	local_add((i), (l))
-#define __local_sub(i, l)	local_sub((i), (l))
 
 #endif /* _ASM_X86_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2010-01-07 16:05:53.000000000 -0600
+++ linux-2.6/include/asm-generic/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -32,24 +32,8 @@ typedef struct
 #define local_add(i,l)	atomic_long_add((i),(&(l)->a))
 #define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
 
-#define local_sub_and_test(i, l) atomic_long_sub_and_test((i), (&(l)->a))
-#define local_dec_and_test(l) atomic_long_dec_and_test(&(l)->a)
-#define local_inc_and_test(l) atomic_long_inc_and_test(&(l)->a)
-#define local_add_negative(i, l) atomic_long_add_negative((i), (&(l)->a))
 #define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
-#define local_sub_return(i, l) atomic_long_sub_return((i), (&(l)->a))
-#define local_inc_return(l) atomic_long_inc_return(&(l)->a)
 
 #define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
-#define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
-#define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
-#define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
-
-/* Non-atomic variants, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well. */
-#define __local_inc(l)		local_set((l), local_read(l) + 1)
-#define __local_dec(l)		local_set((l), local_read(l) - 1)
-#define __local_add(i,l)	local_set((l), local_read(l) + (i))
-#define __local_sub(i,l)	local_set((l), local_read(l) - (i))
 
 #endif /* _ASM_GENERIC_LOCAL_H */
Index: linux-2.6/arch/alpha/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/local.h	2010-01-07 16:05:53.000000000 -0600
+++ linux-2.6/arch/alpha/include/asm/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -34,68 +34,7 @@ static __inline__ long local_add_return(
 	return result;
 }
 
-static __inline__ long local_sub_return(long i, local_t * l)
-{
-	long temp, result;
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	subq %0,%3,%2\n"
-	"	subq %0,%3,%0\n"
-	"	stq_c %0,%1\n"
-	"	beq %0,2f\n"
-	".subsection 2\n"
-	"2:	br 1b\n"
-	".previous"
-	:"=&r" (temp), "=m" (l->a.counter), "=&r" (result)
-	:"Ir" (i), "m" (l->a.counter) : "memory");
-	return result;
-}
-
 #define local_cmpxchg(l, o, n) \
 	(cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, n) (xchg_local(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-#define local_add_unless(l, a, u)				\
-({								\
-	long c, old;						\
-	c = local_read(l);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = local_cmpxchg((l), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#define local_add_negative(a, l) (local_add_return((a), (l)) < 0)
-
-#define local_dec_return(l) local_sub_return(1,(l))
-
-#define local_inc_return(l) local_add_return(1,(l))
-
-#define local_sub_and_test(i,l) (local_sub_return((i), (l)) == 0)
-
-#define local_inc_and_test(l) (local_add_return(1, (l)) == 0)
-
-#define local_dec_and_test(l) (local_sub_return(1, (l)) == 0)
-
-/* Verify if faster than atomic ops */
-#define __local_inc(l)		((l)->a.counter++)
-#define __local_dec(l)		((l)->a.counter++)
-#define __local_add(i,l)	((l)->a.counter+=(i))
-#define __local_sub(i,l)	((l)->a.counter-=(i))
 
 #endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/arch/m32r/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/m32r/include/asm/local.h	2010-01-07 16:05:53.000000000 -0600
+++ linux-2.6/arch/m32r/include/asm/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -78,37 +78,6 @@ static inline long local_add_return(long
 }
 
 /**
- * local_sub_return - subtract long from local variable and return it
- * @i: long value to subtract
- * @l: pointer of type local_t
- *
- * Atomically subtracts @i from @l and return (@l - @i).
- */
-static inline long local_sub_return(long i, local_t *l)
-{
-	unsigned long flags;
-	long result;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# local_sub_return		\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		"ld %0, @%1;			\n\t"
-		"sub	%0, %2;			\n\t"
-		"st %0, @%1;			\n\t"
-		: "=&r" (result)
-		: "r" (&l->counter), "r" (i)
-		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	return result;
-}
-
-/**
  * local_add - add long to local variable
  * @i: long value to add
  * @l: pointer of type local_t
@@ -124,78 +93,7 @@ static inline long local_sub_return(long
  *
  * Atomically subtracts @i from @l.
  */
-#define local_sub(i, l) ((void) local_sub_return((i), (l)))
-
-/**
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer of type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-#define local_sub_and_test(i, l) (local_sub_return((i), (l)) == 0)
-
-/**
- * local_inc_return - increment local variable and return it
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1 and returns the result.
- */
-static inline long local_inc_return(local_t *l)
-{
-	unsigned long flags;
-	long result;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# local_inc_return		\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		"ld %0, @%1;			\n\t"
-		"addi	%0, #1;			\n\t"
-		"st %0, @%1;			\n\t"
-		: "=&r" (result)
-		: "r" (&l->counter)
-		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	return result;
-}
-
-/**
- * local_dec_return - decrement local variable and return it
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and returns the result.
- */
-static inline long local_dec_return(local_t *l)
-{
-	unsigned long flags;
-	long result;
-
-	local_irq_save(flags);
-	__asm__ __volatile__ (
-		"# local_dec_return		\n\t"
-		DCACHE_CLEAR("%0", "r4", "%1")
-		"ld %0, @%1;			\n\t"
-		"addi	%0, #-1;		\n\t"
-		"st %0, @%1;			\n\t"
-		: "=&r" (result)
-		: "r" (&l->counter)
-		: "memory"
-#ifdef CONFIG_CHIP_M32700_TS1
-		, "r4"
-#endif	/* CONFIG_CHIP_M32700_TS1 */
-	);
-	local_irq_restore(flags);
-
-	return result;
-}
+#define local_sub(i, l) ((void) local_add_return(-(i), (l)))
 
 /**
  * local_inc - increment local variable
@@ -203,7 +101,7 @@ static inline long local_dec_return(loca
  *
  * Atomically increments @l by 1.
  */
-#define local_inc(l) ((void)local_inc_return(l))
+#define local_inc(l) local_add(1, (l))
 
 /**
  * local_dec - decrement local variable
@@ -211,67 +109,9 @@ static inline long local_dec_return(loca
  *
  * Atomically decrements @l by 1.
  */
-#define local_dec(l) ((void)local_dec_return(l))
-
-/**
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define local_inc_and_test(l) (local_inc_return(l) == 0)
-
-/**
- * local_dec_and_test - decrement and test
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all
- * other cases.
- */
-#define local_dec_and_test(l) (local_dec_return(l) == 0)
-
-/**
- * local_add_negative - add and test if negative
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-#define local_add_negative(i, l) (local_add_return((i), (l)) < 0)
+#define local_dec(l) local_sub(1, (l))
 
 #define local_cmpxchg(l, o, n) (cmpxchg_local(&((l)->counter), (o), (n)))
-#define local_xchg(v, new) (xchg_local(&((l)->counter), new))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-static inline int local_add_unless(local_t *l, long a, long u)
-{
-	long c, old;
-	c = local_read(l);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = local_cmpxchg((l), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
 
 static inline void local_clear_mask(unsigned long  mask, local_t *addr)
 {
@@ -323,19 +163,4 @@ static inline void local_set_mask(unsign
 #define smp_mb__before_local_inc()	barrier()
 #define smp_mb__after_local_inc()	barrier()
 
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-
-#define __local_inc(l)		((l)->a.counter++)
-#define __local_dec(l)		((l)->a.counter++)
-#define __local_add(i, l)	((l)->a.counter += (i))
-#define __local_sub(i, l)	((l)->a.counter -= (i))
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-
 #endif /* __M32R_LOCAL_H */
Index: linux-2.6/arch/mips/include/asm/local.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/local.h	2010-01-07 16:06:42.000000000 -0600
+++ linux-2.6/arch/mips/include/asm/local.h	2010-01-07 16:26:26.000000000 -0600
@@ -70,127 +70,7 @@ static __inline__ long local_add_return(
 	return result;
 }
 
-static __inline__ long local_sub_return(long i, local_t * l)
-{
-	unsigned long result;
-
-	if (kernel_uses_llsc && R10000_LLSC_WAR) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (kernel_uses_llsc) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:"	__LL	"%1, %2		# local_sub_return	\n"
-		"	subu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	subu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		result = l->a.counter;
-		result -= i;
-		l->a.counter = result;
-		local_irq_restore(flags);
-	}
-
-	return result;
-}
-
 #define local_cmpxchg(l, o, n) \
 	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
-#define local_xchg(l, n) (xchg_local(&((l)->a.counter), (n)))
-
-/**
- * local_add_unless - add unless the number is a given value
- * @l: pointer of type local_t
- * @a: the amount to add to l...
- * @u: ...unless l is equal to u.
- *
- * Atomically adds @a to @l, so long as it was not @u.
- * Returns non-zero if @l was not @u, and zero otherwise.
- */
-#define local_add_unless(l, a, u)				\
-({								\
-	long c, old;						\
-	c = local_read(l);					\
-	while (c != (u) && (old = local_cmpxchg((l), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-#define local_inc_not_zero(l) local_add_unless((l), 1, 0)
-
-#define local_dec_return(l) local_sub_return(1, (l))
-#define local_inc_return(l) local_add_return(1, (l))
-
-/*
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer of type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-#define local_sub_and_test(i, l) (local_sub_return((i), (l)) == 0)
-
-/*
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-#define local_inc_and_test(l) (local_inc_return(l) == 0)
-
-/*
- * local_dec_and_test - decrement by 1 and test
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-#define local_dec_and_test(l) (local_sub_return(1, (l)) == 0)
-
-/*
- * local_add_negative - add and test if negative
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-#define local_add_negative(i, l) (local_add_return(i, (l)) < 0)
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-
-#define __local_inc(l)		((l)->a.counter++)
-#define __local_dec(l)		((l)->a.counter++)
-#define __local_add(i, l)	((l)->a.counter+=(i))
-#define __local_sub(i, l)	((l)->a.counter-=(i))
 
 #endif /* _ARCH_MIPS_LOCAL_H */

-- 
