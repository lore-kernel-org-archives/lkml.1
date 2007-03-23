Return-Path: <linux-kernel-owner+w=401wt.eu-S1422734AbXCWI7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422734AbXCWI7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422743AbXCWI7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:59:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:36718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422734AbXCWI7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:59:16 -0400
Date: Fri, 23 Mar 2007 09:59:11 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, Ingo Molnar <mingo@elte.hu>
Subject: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323085910.GA11577@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Implement queued spinlocks for i386. This shouldn't increase the size of
the spinlock structure, while still able to handle 2^16 CPUs.

Not completely implemented with assembly yet, to make the algorithm a bit
clearer.

The queued spinlock has 2 fields, a head and a tail, which are indexes
into a FIFO of waiting CPUs. To take a spinlock, a CPU performs an
"atomic_inc_return" on the head index, and keeps the returned value as
a ticket. The CPU then spins until the tail index is equal to that
ticket.

To unlock a spinlock, the tail index is incremented (this can be non
atomic, because only the lock owner will modify tail).

Implementation inefficiencies aside, this change should have little
effect on performance for uncontended locks, but will have quite a
large cost for highly contended locks [O(N) cacheline transfers vs
O(1) per lock aquisition, where N is the number of CPUs contending].
The benefit is is that contended locks will not cause any starvation.

Just an idea. Big NUMA hardware seems to have fairness logic that
prevents starvation for the regular spinlock logic. But it might be
interesting for -rt kernel or systems with starvation issues. 


Index: linux-2.6/include/asm-i386/spinlock.h
===================================================================
--- linux-2.6.orig/include/asm-i386/spinlock.h
+++ linux-2.6/include/asm-i386/spinlock.h
@@ -29,69 +29,23 @@
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *x)
 {
-	return *(volatile signed char *)(&(x)->slock) <= 0;
+	return unlikely(x->qhead != x->qtail);
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
-	asm volatile("\n1:\t"
-		     LOCK_PREFIX " ; decb %0\n\t"
-		     "jns 3f\n"
-		     "2:\t"
-		     "rep;nop\n\t"
-		     "cmpb $0,%0\n\t"
-		     "jle 2b\n\t"
-		     "jmp 1b\n"
-		     "3:\n\t"
-		     : "+m" (lock->slock) : : "memory");
-}
+	unsigned short pos = 1;
 
-/*
- * It is easier for the lock validator if interrupts are not re-enabled
- * in the middle of a lock-acquire. This is a performance feature anyway
- * so we turn it off:
- *
- * NOTE: there's an irqs-on section here, which normally would have to be
- * irq-traced, but on CONFIG_TRACE_IRQFLAGS we never use this variant.
- */
-#ifndef CONFIG_PROVE_LOCKING
-static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
-{
-	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decb %[slock]\n\t"
-		"jns 5f\n"
-		"2:\t"
-		"testl $0x200, %[flags]\n\t"
-		"jz 4f\n\t"
-		STI_STRING "\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jle 3b\n\t"
-		CLI_STRING "\n\t"
-		"jmp 1b\n"
-		"4:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jg 1b\n\t"
-		"jmp 4b\n"
-		"5:\n\t"
-		: [slock] "+m" (lock->slock)
-		: [flags] "r" (flags)
-	 	  CLI_STI_INPUT_ARGS
-		: "memory" CLI_STI_CLOBBERS);
+	asm volatile(LOCK_PREFIX "xaddw %0, %1\n\t"
+		     : "+r" (pos), "+m" (lock->qhead) : : "memory");
+	while (unlikely(pos != lock->qtail))
+		cpu_relax();
 }
-#endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
-	char oldval;
-	asm volatile(
-		"xchgb %b0,%1"
-		:"=q" (oldval), "+m" (lock->slock)
-		:"0" (0) : "memory");
-	return oldval > 0;
+	unsigned short qtail = lock->qtail;
+	return likely(cmpxchg(&lock->qhead, qtail, qtail+1) == qtail);
 }
 
 /*
@@ -105,18 +59,14 @@ static inline int __raw_spin_trylock(raw
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile("movb $1,%0" : "+m" (lock->slock) :: "memory");
+	asm volatile("addw $1,%0" : "+m" (lock->qtail) :: "memory");
 }
 
 #else
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	char oldval = 1;
-
-	asm volatile("xchgb %b0, %1"
-		     : "=q" (oldval), "+m" (lock->slock)
-		     : "0" (oldval) : "memory");
+	asm volatile(LOCK_PREFIX "addw $1,%0" : "+m" (lock->qtail) :: "memory");
 }
 
 #endif
Index: linux-2.6/include/asm-i386/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/asm-i386/spinlock_types.h
+++ linux-2.6/include/asm-i386/spinlock_types.h
@@ -6,10 +6,11 @@
 #endif
 
 typedef struct {
-	unsigned int slock;
+	unsigned short qhead;
+	unsigned short qtail;
 } raw_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 1 }
+#define __RAW_SPIN_LOCK_UNLOCKED	{ 0, 0 }
 
 typedef struct {
 	unsigned int lock;
