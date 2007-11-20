Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbXKTB2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbXKTB2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbXKTBOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:24 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49888 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756342AbXKTBNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:43 -0500
Message-Id: <20071120011342.188333766@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:16 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 44/45] Remove local_t support
Content-Disposition: inline; filename=remove_local_t
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no user of local_t remaining after the cpu ops patchset. local_t
always suffered from the problem that the operations it generated were not
able to perform the relocation of a pointer to the target processor and the
atomic update at the same time. There was a need to disable preemption
and/or interrupts which made it awkward to use.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 Documentation/local_ops.txt   |  209 -------------------------------------
 arch/frv/kernel/local.h       |   59 ----------
 include/asm-alpha/local.h     |  118 ---------------------
 include/asm-arm/local.h       |    1 
 include/asm-avr32/local.h     |    6 -
 include/asm-blackfin/local.h  |    6 -
 include/asm-cris/local.h      |    1 
 include/asm-frv/local.h       |    6 -
 include/asm-generic/local.h   |   75 -------------
 include/asm-h8300/local.h     |    6 -
 include/asm-ia64/local.h      |    1 
 include/asm-m32r/local.h      |    6 -
 include/asm-m68k/local.h      |    6 -
 include/asm-m68knommu/local.h |    6 -
 include/asm-mips/local.h      |  221 ---------------------------------------
 include/asm-parisc/local.h    |    1 
 include/asm-powerpc/local.h   |  200 ------------------------------------
 include/asm-s390/local.h      |    1 
 include/asm-sh/local.h        |    7 -
 include/asm-sh64/local.h      |    7 -
 include/asm-sparc/local.h     |    6 -
 include/asm-sparc64/local.h   |    1 
 include/asm-um/local.h        |    6 -
 include/asm-v850/local.h      |    6 -
 include/asm-x86/local.h       |    5 
 include/asm-x86/local_32.h    |  233 ------------------------------------------
 include/asm-x86/local_64.h    |  222 ----------------------------------------
 include/asm-xtensa/local.h    |   16 --
 include/linux/module.h        |    2 
 29 files changed, 1 insertion(+), 1439 deletions(-)

Index: linux-2.6/Documentation/local_ops.txt
===================================================================
--- linux-2.6.orig/Documentation/local_ops.txt	2007-11-19 15:45:01.989139706 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,209 +0,0 @@
-	     Semantics and Behavior of Local Atomic Operations
-
-			    Mathieu Desnoyers
-
-
-	This document explains the purpose of the local atomic operations, how
-to implement them for any given architecture and shows how they can be used
-properly. It also stresses on the precautions that must be taken when reading
-those local variables across CPUs when the order of memory writes matters.
-
-
-
-* Purpose of local atomic operations
-
-Local atomic operations are meant to provide fast and highly reentrant per CPU
-counters. They minimize the performance cost of standard atomic operations by
-removing the LOCK prefix and memory barriers normally required to synchronize
-across CPUs.
-
-Having fast per CPU atomic counters is interesting in many cases : it does not
-require disabling interrupts to protect from interrupt handlers and it permits
-coherent counters in NMI handlers. It is especially useful for tracing purposes
-and for various performance monitoring counters.
-
-Local atomic operations only guarantee variable modification atomicity wrt the
-CPU which owns the data. Therefore, care must taken to make sure that only one
-CPU writes to the local_t data. This is done by using per cpu data and making
-sure that we modify it from within a preemption safe context. It is however
-permitted to read local_t data from any CPU : it will then appear to be written
-out of order wrt other memory writes by the owner CPU.
-
-
-* Implementation for a given architecture
-
-It can be done by slightly modifying the standard atomic operations : only
-their UP variant must be kept. It typically means removing LOCK prefix (on
-i386 and x86_64) and any SMP sychronization barrier. If the architecture does
-not have a different behavior between SMP and UP, including asm-generic/local.h
-in your archtecture's local.h is sufficient.
-
-The local_t type is defined as an opaque signed long by embedding an
-atomic_long_t inside a structure. This is made so a cast from this type to a
-long fails. The definition looks like :
-
-typedef struct { atomic_long_t a; } local_t;
-
-
-* Rules to follow when using local atomic operations
-
-- Variables touched by local ops must be per cpu variables.
-- _Only_ the CPU owner of these variables must write to them.
-- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
-  to update its local_t variables.
-- Preemption (or interrupts) must be disabled when using local ops in
-  process context to   make sure the process won't be migrated to a
-  different CPU between getting the per-cpu variable and doing the
-  actual local op.
-- When using local ops in interrupt context, no special care must be
-  taken on a mainline kernel, since they will run on the local CPU with
-  preemption already disabled. I suggest, however, to explicitly
-  disable preemption anyway to make sure it will still work correctly on
-  -rt kernels.
-- Reading the local cpu variable will provide the current copy of the
-  variable.
-- Reads of these variables can be done from any CPU, because updates to
-  "long", aligned, variables are always atomic. Since no memory
-  synchronization is done by the writer CPU, an outdated copy of the
-  variable can be read when reading some _other_ cpu's variables.
-
-
-* Rules to follow when using local atomic operations
-
-- Variables touched by local ops must be per cpu variables.
-- _Only_ the CPU owner of these variables must write to them.
-- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
-  to update its local_t variables.
-- Preemption (or interrupts) must be disabled when using local ops in
-  process context to   make sure the process won't be migrated to a
-  different CPU between getting the per-cpu variable and doing the
-  actual local op.
-- When using local ops in interrupt context, no special care must be
-  taken on a mainline kernel, since they will run on the local CPU with
-  preemption already disabled. I suggest, however, to explicitly
-  disable preemption anyway to make sure it will still work correctly on
-  -rt kernels.
-- Reading the local cpu variable will provide the current copy of the
-  variable.
-- Reads of these variables can be done from any CPU, because updates to
-  "long", aligned, variables are always atomic. Since no memory
-  synchronization is done by the writer CPU, an outdated copy of the
-  variable can be read when reading some _other_ cpu's variables.
-
-
-* How to use local atomic operations
-
-#include <linux/percpu.h>
-#include <asm/local.h>
-
-static DEFINE_PER_CPU(local_t, counters) = LOCAL_INIT(0);
-
-
-* Counting
-
-Counting is done on all the bits of a signed long.
-
-In preemptible context, use get_cpu_var() and put_cpu_var() around local atomic
-operations : it makes sure that preemption is disabled around write access to
-the per cpu variable. For instance :
-
-	local_inc(&get_cpu_var(counters));
-	put_cpu_var(counters);
-
-If you are already in a preemption-safe context, you can directly use
-__get_cpu_var() instead.
-
-	local_inc(&__get_cpu_var(counters));
-
-
-
-* Reading the counters
-
-Those local counters can be read from foreign CPUs to sum the count. Note that
-the data seen by local_read across CPUs must be considered to be out of order
-relatively to other memory writes happening on the CPU that owns the data.
-
-	long sum = 0;
-	for_each_online_cpu(cpu)
-		sum += local_read(&per_cpu(counters, cpu));
-
-If you want to use a remote local_read to synchronize access to a resource
-between CPUs, explicit smp_wmb() and smp_rmb() memory barriers must be used
-respectively on the writer and the reader CPUs. It would be the case if you use
-the local_t variable as a counter of bytes written in a buffer : there should
-be a smp_wmb() between the buffer write and the counter increment and also a
-smp_rmb() between the counter read and the buffer read.
-
-
-Here is a sample module which implements a basic per cpu counter using local.h.
-
---- BEGIN ---
-/* test-local.c
- *
- * Sample module for local.h usage.
- */
-
-
-#include <asm/local.h>
-#include <linux/module.h>
-#include <linux/timer.h>
-
-static DEFINE_PER_CPU(local_t, counters) = LOCAL_INIT(0);
-
-static struct timer_list test_timer;
-
-/* IPI called on each CPU. */
-static void test_each(void *info)
-{
-	/* Increment the counter from a non preemptible context */
-	printk("Increment on cpu %d\n", smp_processor_id());
-	local_inc(&__get_cpu_var(counters));
-
-	/* This is what incrementing the variable would look like within a
-	 * preemptible context (it disables preemption) :
-	 *
-	 * local_inc(&get_cpu_var(counters));
-	 * put_cpu_var(counters);
-	 */
-}
-
-static void do_test_timer(unsigned long data)
-{
-	int cpu;
-
-	/* Increment the counters */
-	on_each_cpu(test_each, NULL, 0, 1);
-	/* Read all the counters */
-	printk("Counters read from CPU %d\n", smp_processor_id());
-	for_each_online_cpu(cpu) {
-		printk("Read : CPU %d, count %ld\n", cpu,
-			local_read(&per_cpu(counters, cpu)));
-	}
-	del_timer(&test_timer);
-	test_timer.expires = jiffies + 1000;
-	add_timer(&test_timer);
-}
-
-static int __init test_init(void)
-{
-	/* initialize the timer that will increment the counter */
-	init_timer(&test_timer);
-	test_timer.function = do_test_timer;
-	test_timer.expires = jiffies + 1;
-	add_timer(&test_timer);
-
-	return 0;
-}
-
-static void __exit test_exit(void)
-{
-	del_timer_sync(&test_timer);
-}
-
-module_init(test_init);
-module_exit(test_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mathieu Desnoyers");
-MODULE_DESCRIPTION("Local Atomic Ops");
---- END ---
Index: linux-2.6/include/asm-x86/local.h
===================================================================
--- linux-2.6.orig/include/asm-x86/local.h	2007-11-19 15:45:02.002639906 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,5 +0,0 @@
-#ifdef CONFIG_X86_32
-# include "local_32.h"
-#else
-# include "local_64.h"
-#endif
Index: linux-2.6/include/asm-x86/local_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/local_32.h	2007-11-19 15:45:02.006640289 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,233 +0,0 @@
-#ifndef _ARCH_I386_LOCAL_H
-#define _ARCH_I386_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/system.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
-static __inline__ void local_inc(local_t *l)
-{
-	__asm__ __volatile__(
-		"incl %0"
-		:"+m" (l->a.counter));
-}
-
-static __inline__ void local_dec(local_t *l)
-{
-	__asm__ __volatile__(
-		"decl %0"
-		:"+m" (l->a.counter));
-}
-
-static __inline__ void local_add(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		"addl %1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
-
-static __inline__ void local_sub(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		"subl %1,%0"
-		:"+m" (l->a.counter)
-		:"ir" (i));
-}
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
-static __inline__ int local_sub_and_test(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"subl %2,%0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_dec_and_test - decrement and test
- * @l: pointer of type local_t
- *
- * Atomically decrements @l by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static __inline__ int local_dec_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"decl %0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
-
-/**
- * local_inc_and_test - increment and test
- * @l: pointer of type local_t
- *
- * Atomically increments @l by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static __inline__ int local_inc_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"incl %0; sete %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		: : "memory");
-	return c != 0;
-}
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
-static __inline__ int local_add_negative(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"addl %2,%0; sets %1"
-		:"+m" (l->a.counter), "=qm" (c)
-		:"ir" (i) : "memory");
-	return c;
-}
-
-/**
- * local_add_return - add and return
- * @l: pointer of type local_t
- * @i: integer value to add
- *
- * Atomically adds @i to @l and returns @i + @l
- */
-static __inline__ long local_add_return(long i, local_t *l)
-{
-	long __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if(unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
-	__asm__ __volatile__(
-		"xaddl %0, %1;"
-		:"+r" (i), "+m" (l->a.counter)
-		: : "memory");
-	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = local_read(l);
-	local_set(l, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
-}
-
-static __inline__ long local_sub_return(long i, local_t *l)
-{
-	return local_add_return(-i,l);
-}
-
-#define local_inc_return(l)  (local_add_return(1,l))
-#define local_dec_return(l)  (local_sub_return(1,l))
-
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
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
-/* On x86, these are no better than the atomic variants. */
-#define __local_inc(l)		local_inc(l)
-#define __local_dec(l)		local_dec(l)
-#define __local_add(i,l)	local_add((i),(l))
-#define __local_sub(i,l)	local_sub((i),(l))
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
-#endif /* _ARCH_I386_LOCAL_H */
Index: linux-2.6/include/asm-x86/local_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/local_64.h	2007-11-19 15:45:02.026640148 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,222 +0,0 @@
-#ifndef _ARCH_X8664_LOCAL_H
-#define _ARCH_X8664_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
-static inline void local_inc(local_t *l)
-{
-	__asm__ __volatile__(
-		"incq %0"
-		:"=m" (l->a.counter)
-		:"m" (l->a.counter));
-}
-
-static inline void local_dec(local_t *l)
-{
-	__asm__ __volatile__(
-		"decq %0"
-		:"=m" (l->a.counter)
-		:"m" (l->a.counter));
-}
-
-static inline void local_add(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		"addq %1,%0"
-		:"=m" (l->a.counter)
-		:"ir" (i), "m" (l->a.counter));
-}
-
-static inline void local_sub(long i, local_t *l)
-{
-	__asm__ __volatile__(
-		"subq %1,%0"
-		:"=m" (l->a.counter)
-		:"ir" (i), "m" (l->a.counter));
-}
-
-/**
- * local_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @l: pointer to type local_t
- *
- * Atomically subtracts @i from @l and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static __inline__ int local_sub_and_test(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"subq %2,%0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"ir" (i), "m" (l->a.counter) : "memory");
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
-static __inline__ int local_dec_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"decq %0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"m" (l->a.counter) : "memory");
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
-static __inline__ int local_inc_and_test(local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"incq %0; sete %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"m" (l->a.counter) : "memory");
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
-static __inline__ int local_add_negative(long i, local_t *l)
-{
-	unsigned char c;
-
-	__asm__ __volatile__(
-		"addq %2,%0; sets %1"
-		:"=m" (l->a.counter), "=qm" (c)
-		:"ir" (i), "m" (l->a.counter) : "memory");
-	return c;
-}
-
-/**
- * local_add_return - add and return
- * @i: integer value to add
- * @l: pointer to type local_t
- *
- * Atomically adds @i to @l and returns @i + @l
- */
-static __inline__ long local_add_return(long i, local_t *l)
-{
-	long __i = i;
-	__asm__ __volatile__(
-		"xaddq %0, %1;"
-		:"+r" (i), "+m" (l->a.counter)
-		: : "memory");
-	return i + __i;
-}
-
-static __inline__ long local_sub_return(long i, local_t *l)
-{
-	return local_add_return(-i,l);
-}
-
-#define local_inc_return(l)  (local_add_return(1,l))
-#define local_dec_return(l)  (local_sub_return(1,l))
-
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
-/* Always has a lock prefix */
-#define local_xchg(l, n) (xchg(&((l)->a.counter), (n)))
-
-/**
- * atomic_up_add_unless - add unless the number is a given value
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
-/* On x86-64 these are better than the atomic variants on SMP kernels
-   because they dont use a lock prefix. */
-#define __local_inc(l)		local_inc(l)
-#define __local_dec(l)		local_dec(l)
-#define __local_add(i,l)	local_add((i),(l))
-#define __local_sub(i,l)	local_sub((i),(l))
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- *
- * This could be done better if we moved the per cpu data directly
- * after GS.
- */
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
-#endif /* _ARCH_X8664_LOCAL_H */
Index: linux-2.6/arch/frv/kernel/local.h
===================================================================
--- linux-2.6.orig/arch/frv/kernel/local.h	2007-11-19 15:45:02.509640199 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,59 +0,0 @@
-/* local.h: local definitions
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _FRV_LOCAL_H
-#define _FRV_LOCAL_H
-
-#include <asm/sections.h>
-
-#ifndef __ASSEMBLY__
-
-/* dma.c */
-extern unsigned long frv_dma_inprogress;
-
-extern void frv_dma_pause_all(void);
-extern void frv_dma_resume_all(void);
-
-/* sleep.S */
-extern asmlinkage void frv_cpu_suspend(unsigned long);
-extern asmlinkage void frv_cpu_core_sleep(void);
-
-/* setup.c */
-extern unsigned long __nongprelbss pdm_suspend_mode;
-extern void determine_clocks(int verbose);
-extern int __nongprelbss clock_p0_current;
-extern int __nongprelbss clock_cm_current;
-extern int __nongprelbss clock_cmode_current;
-
-#ifdef CONFIG_PM
-extern int __nongprelbss clock_cmodes_permitted;
-extern unsigned long __nongprelbss clock_bits_settable;
-#define CLOCK_BIT_CM		0x0000000f
-#define CLOCK_BIT_CM_H		0x00000001	/* CLKC.CM can be set to 0 */
-#define CLOCK_BIT_CM_M		0x00000002	/* CLKC.CM can be set to 1 */
-#define CLOCK_BIT_CM_L		0x00000004	/* CLKC.CM can be set to 2 */
-#define CLOCK_BIT_P0		0x00000010	/* CLKC.P0 can be changed */
-#define CLOCK_BIT_CMODE		0x00000020	/* CLKC.CMODE can be changed */
-
-extern void (*__power_switch_wake_setup)(void);
-extern int  (*__power_switch_wake_check)(void);
-extern void (*__power_switch_wake_cleanup)(void);
-#endif
-
-/* time.c */
-extern void time_divisor_init(void);
-
-/* cmode.S */
-extern asmlinkage void frv_change_cmode(int);
-
-
-#endif /* __ASSEMBLY__ */
-#endif /* _FRV_LOCAL_H */
Index: linux-2.6/include/asm-alpha/local.h
===================================================================
--- linux-2.6.orig/include/asm-alpha/local.h	2007-11-19 15:45:02.062094005 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,118 +0,0 @@
-#ifndef _ALPHA_LOCAL_H
-#define _ALPHA_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
-
-static __inline__ long local_add_return(long i, local_t * l)
-{
-	long temp, result;
-	__asm__ __volatile__(
-	"1:	ldq_l %0,%1\n"
-	"	addq %0,%3,%2\n"
-	"	addq %0,%3,%0\n"
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
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
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
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
-#endif /* _ALPHA_LOCAL_H */
Index: linux-2.6/include/asm-arm/local.h
===================================================================
--- linux-2.6.orig/include/asm-arm/local.h	2007-11-19 15:45:02.102329901 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-avr32/local.h
===================================================================
--- linux-2.6.orig/include/asm-avr32/local.h	2007-11-19 15:45:02.126639967 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __ASM_AVR32_LOCAL_H
-#define __ASM_AVR32_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __ASM_AVR32_LOCAL_H */
Index: linux-2.6/include/asm-blackfin/local.h
===================================================================
--- linux-2.6.orig/include/asm-blackfin/local.h	2007-11-19 15:45:02.161234863 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __BLACKFIN_LOCAL_H
-#define __BLACKFIN_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif				/* __BLACKFIN_LOCAL_H */
Index: linux-2.6/include/asm-cris/local.h
===================================================================
--- linux-2.6.orig/include/asm-cris/local.h	2007-11-19 15:45:02.182639948 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-frv/local.h
===================================================================
--- linux-2.6.orig/include/asm-frv/local.h	2007-11-19 15:45:02.190640206 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef _ASM_LOCAL_H
-#define _ASM_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_LOCAL_H */
Index: linux-2.6/include/asm-generic/local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/local.h	2007-11-19 15:45:02.198640216 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,75 +0,0 @@
-#ifndef _ASM_GENERIC_LOCAL_H
-#define _ASM_GENERIC_LOCAL_H
-
-#include <linux/percpu.h>
-#include <linux/hardirq.h>
-#include <asm/atomic.h>
-#include <asm/types.h>
-
-/*
- * A signed long type for operations which are atomic for a single CPU.
- * Usually used in combination with per-cpu variables.
- *
- * This is the default implementation, which uses atomic_long_t.  Which is
- * rather pointless.  The whole point behind local_t is that some processors
- * can perform atomic adds and subtracts in a manner which is atomic wrt IRQs
- * running on this CPU.  local_t allows exploitation of such capabilities.
- */
-
-/* Implement in terms of atomics. */
-
-/* Don't use typedef: don't want them to be mixed with atomic_t's. */
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set((&(l)->a),(i))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
-
-#define local_sub_and_test(i, l) atomic_long_sub_and_test((i), (&(l)->a))
-#define local_dec_and_test(l) atomic_long_dec_and_test(&(l)->a)
-#define local_inc_and_test(l) atomic_long_inc_and_test(&(l)->a)
-#define local_add_negative(i, l) atomic_long_add_negative((i), (&(l)->a))
-#define local_add_return(i, l) atomic_long_add_return((i), (&(l)->a))
-#define local_sub_return(i, l) atomic_long_sub_return((i), (&(l)->a))
-#define local_inc_return(l) atomic_long_inc_return(&(l)->a)
-
-#define local_cmpxchg(l, o, n) atomic_long_cmpxchg((&(l)->a), (o), (n))
-#define local_xchg(l, n) atomic_long_xchg((&(l)->a), (n))
-#define local_add_unless(l, a, u) atomic_long_add_unless((&(l)->a), (a), (u))
-#define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
-
-/* Non-atomic variants, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well. */
-#define __local_inc(l)		local_set((l), local_read(l) + 1)
-#define __local_dec(l)		local_set((l), local_read(l) - 1)
-#define __local_add(i,l)	local_set((l), local_read(l) + (i))
-#define __local_sub(i,l)	local_set((l), local_read(l) - (i))
-
-/* Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable (eg. mystruct.foo), not an address.
- */
-#define cpu_local_read(l)	local_read(&__get_cpu_var(l))
-#define cpu_local_set(l, i)	local_set(&__get_cpu_var(l), (i))
-#define cpu_local_inc(l)	local_inc(&__get_cpu_var(l))
-#define cpu_local_dec(l)	local_dec(&__get_cpu_var(l))
-#define cpu_local_add(i, l)	local_add((i), &__get_cpu_var(l))
-#define cpu_local_sub(i, l)	local_sub((i), &__get_cpu_var(l))
-
-/* Non-atomic increments, ie. preemption disabled and won't be touched
- * in interrupt, etc.  Some archs can optimize this case well.
- */
-#define __cpu_local_inc(l)	__local_inc(&__get_cpu_var(l))
-#define __cpu_local_dec(l)	__local_dec(&__get_cpu_var(l))
-#define __cpu_local_add(i, l)	__local_add((i), &__get_cpu_var(l))
-#define __cpu_local_sub(i, l)	__local_sub((i), &__get_cpu_var(l))
-
-#endif /* _ASM_GENERIC_LOCAL_H */
Index: linux-2.6/include/asm-h8300/local.h
===================================================================
--- linux-2.6.orig/include/asm-h8300/local.h	2007-11-19 15:45:02.245140408 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef _H8300_LOCAL_H_
-#define _H8300_LOCAL_H_
-
-#include <asm-generic/local.h>
-
-#endif
Index: linux-2.6/include/asm-ia64/local.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/local.h	2007-11-19 15:45:02.277139840 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-m32r/local.h
===================================================================
--- linux-2.6.orig/include/asm-m32r/local.h	2007-11-19 15:45:02.285140737 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __M32R_LOCAL_H
-#define __M32R_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __M32R_LOCAL_H */
Index: linux-2.6/include/asm-m68k/local.h
===================================================================
--- linux-2.6.orig/include/asm-m68k/local.h	2007-11-19 15:45:02.305140224 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef _ASM_M68K_LOCAL_H
-#define _ASM_M68K_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_M68K_LOCAL_H */
Index: linux-2.6/include/asm-m68knommu/local.h
===================================================================
--- linux-2.6.orig/include/asm-m68knommu/local.h	2007-11-19 15:45:02.321139891 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __M68KNOMMU_LOCAL_H
-#define __M68KNOMMU_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __M68KNOMMU_LOCAL_H */
Index: linux-2.6/include/asm-mips/local.h
===================================================================
--- linux-2.6.orig/include/asm-mips/local.h	2007-11-19 15:45:02.333140816 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,221 +0,0 @@
-#ifndef _ARCH_MIPS_LOCAL_H
-#define _ARCH_MIPS_LOCAL_H
-
-#include <linux/percpu.h>
-#include <linux/bitops.h>
-#include <asm/atomic.h>
-#include <asm/cmpxchg.h>
-#include <asm/war.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l, i)	atomic_long_set(&(l)->a, (i))
-
-#define local_add(i, l)	atomic_long_add((i), (&(l)->a))
-#define local_sub(i, l)	atomic_long_sub((i), (&(l)->a))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-
-/*
- * Same as above, but return the result value
- */
-static __inline__ long local_add_return(long i, local_t * l)
-{
-	unsigned long result;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqzl	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else if (cpu_has_llsc) {
-		unsigned long temp;
-
-		__asm__ __volatile__(
-		"	.set	mips3					\n"
-		"1:"	__LL	"%1, %2		# local_add_return	\n"
-		"	addu	%0, %1, %3				\n"
-			__SC	"%0, %2					\n"
-		"	beqz	%0, 1b					\n"
-		"	addu	%0, %1, %3				\n"
-		"	.set	mips0					\n"
-		: "=&r" (result), "=&r" (temp), "=m" (l->a.counter)
-		: "Ir" (i), "m" (l->a.counter)
-		: "memory");
-	} else {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		result = l->a.counter;
-		result += i;
-		l->a.counter = result;
-		local_irq_restore(flags);
-	}
-
-	return result;
-}
-
-static __inline__ long local_sub_return(long i, local_t * l)
-{
-	unsigned long result;
-
-	if (cpu_has_llsc && R10000_LLSC_WAR) {
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
-	} else if (cpu_has_llsc) {
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
-#define local_cmpxchg(l, o, n) \
-	((long)cmpxchg_local(&((l)->a.counter), (o), (n)))
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
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
-#endif /* _ARCH_MIPS_LOCAL_H */
Index: linux-2.6/include/asm-parisc/local.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/local.h	2007-11-19 15:45:02.341140171 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-powerpc/local.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/local.h	2007-11-19 15:45:02.365140002 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,200 +0,0 @@
-#ifndef _ARCH_POWERPC_LOCAL_H
-#define _ARCH_POWERPC_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-typedef struct
-{
-	atomic_long_t a;
-} local_t;
-
-#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
-
-#define local_read(l)	atomic_long_read(&(l)->a)
-#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
-
-#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
-#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
-#define local_inc(l)	atomic_long_inc(&(l)->a)
-#define local_dec(l)	atomic_long_dec(&(l)->a)
-
-static __inline__ long local_add_return(long a, local_t *l)
-{
-	long t;
-
-	__asm__ __volatile__(
-"1:"	PPC_LLARX	"%0,0,%2		# local_add_return\n\
-	add	%0,%1,%0\n"
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
-	: "cc", "memory");
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
-	: "cc", "memory");
-
-	return t;
-}
-
-#define local_cmpxchg(l, o, n) \
-	(cmpxchg_local(&((l)->a.counter), (o), (n)))
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
-
-/* Need to disable preemption for the cpu local counters otherwise we could
-   still access a variable of a previous CPU in a non atomic way. */
-#define cpu_local_wrap_v(l)	 	\
-	({ local_t res__;		\
-	   preempt_disable(); 		\
-	   res__ = (l);			\
-	   preempt_enable();		\
-	   res__; })
-#define cpu_local_wrap(l)		\
-	({ preempt_disable();		\
-	   l;				\
-	   preempt_enable(); })		\
-
-#define cpu_local_read(l)    cpu_local_wrap_v(local_read(&__get_cpu_var(l)))
-#define cpu_local_set(l, i)  cpu_local_wrap(local_set(&__get_cpu_var(l), (i)))
-#define cpu_local_inc(l)     cpu_local_wrap(local_inc(&__get_cpu_var(l)))
-#define cpu_local_dec(l)     cpu_local_wrap(local_dec(&__get_cpu_var(l)))
-#define cpu_local_add(i, l)  cpu_local_wrap(local_add((i), &__get_cpu_var(l)))
-#define cpu_local_sub(i, l)  cpu_local_wrap(local_sub((i), &__get_cpu_var(l)))
-
-#define __cpu_local_inc(l)	cpu_local_inc(l)
-#define __cpu_local_dec(l)	cpu_local_dec(l)
-#define __cpu_local_add(i, l)	cpu_local_add((i), (l))
-#define __cpu_local_sub(i, l)	cpu_local_sub((i), (l))
-
-#endif /* _ARCH_POWERPC_LOCAL_H */
Index: linux-2.6/include/asm-s390/local.h
===================================================================
--- linux-2.6.orig/include/asm-s390/local.h	2007-11-19 15:45:02.373140085 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-sh/local.h
===================================================================
--- linux-2.6.orig/include/asm-sh/local.h	2007-11-19 15:45:02.405389823 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,7 +0,0 @@
-#ifndef __ASM_SH_LOCAL_H
-#define __ASM_SH_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __ASM_SH_LOCAL_H */
-
Index: linux-2.6/include/asm-sh64/local.h
===================================================================
--- linux-2.6.orig/include/asm-sh64/local.h	2007-11-19 15:45:02.413640013 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,7 +0,0 @@
-#ifndef __ASM_SH64_LOCAL_H
-#define __ASM_SH64_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* __ASM_SH64_LOCAL_H */
-
Index: linux-2.6/include/asm-sparc/local.h
===================================================================
--- linux-2.6.orig/include/asm-sparc/local.h	2007-11-19 15:45:02.429640001 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef _SPARC_LOCAL_H
-#define _SPARC_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif
Index: linux-2.6/include/asm-sparc64/local.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/local.h	2007-11-19 15:45:02.437640328 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-#include <asm-generic/local.h>
Index: linux-2.6/include/asm-um/local.h
===================================================================
--- linux-2.6.orig/include/asm-um/local.h	2007-11-19 15:45:02.457639838 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __UM_LOCAL_H
-#define __UM_LOCAL_H
-
-#include "asm/arch/local.h"
-
-#endif
Index: linux-2.6/include/asm-v850/local.h
===================================================================
--- linux-2.6.orig/include/asm-v850/local.h	2007-11-19 15:45:02.465640304 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __V850_LOCAL_H__
-#define __V850_LOCAL_H__
-
-#include <asm-generic/local.h>
-
-#endif /* __V850_LOCAL_H__ */
Index: linux-2.6/include/asm-xtensa/local.h
===================================================================
--- linux-2.6.orig/include/asm-xtensa/local.h	2007-11-19 15:45:02.469640160 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,16 +0,0 @@
-/*
- * include/asm-xtensa/local.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_LOCAL_H
-#define _XTENSA_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _XTENSA_LOCAL_H */
Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2007-11-19 16:00:49.421639813 -0800
+++ linux-2.6/include/linux/module.h	2007-11-19 16:25:42.314191640 -0800
@@ -16,7 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
-#include <asm/local.h>
+#include <linux/percpu.h>
 
 #include <asm/module.h>
 

-- 
