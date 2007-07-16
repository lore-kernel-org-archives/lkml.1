Return-Path: <linux-kernel-owner+w=401wt.eu-S1759841AbXGPFBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbXGPFBn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 01:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbXGPFBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 01:01:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:45096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXGPFBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 01:01:35 -0400
Date: Mon, 16 Jul 2007 07:01:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [rfc][patch 2/2] x86_64: FIFO ticket spinlocks
Message-ID: <20070716050134.GB19914@wotan.suse.de>
References: <20070716045932.GA19914@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716045932.GA19914@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce ticket lock spinlocks for x86-64 which are FIFO. The implementation
is described in the comments. The straight-line lock/unlock instruction
sequence is slightly slower than the dec based locks on modern x86 CPUs,
however the difference is quite small on Core2 and Opteron when working out of
cache, and becomes almost insignificant even on P4 when the lock misses cache.
trylock is more significantly slower, but they are relatively rare.

The memory ordering of the lock does conform to Intel's standards, and the
implementation has been reviewed by an Intel engineer.

XXX: numbers here

The algorithm also tells us how many CPUs are contending the lock, so
lockbreak becomes trivial and we no longer waste 4 bytes per spinlock for it.

---
Index: linux-2.6/include/asm-x86_64/spinlock.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/spinlock.h
+++ linux-2.6/include/asm-x86_64/spinlock.h
@@ -19,67 +19,81 @@
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
-	return *(volatile signed int *)(&(lock)->slock) <= 0;
+	int tmp = *(volatile signed int *)(&(lock)->slock);
+
+	return (((tmp >> 8) & 0xff) != (tmp & 0xff));
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
 {
-	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
-		"jns 2f\n"
-		"3:\n"
-		"rep;nop\n\t"
-		"cmpl $0,%0\n\t"
-		"jle 3b\n\t"
-		"jmp 1b\n"
-		"2:\t" : "=m" (lock->slock) : : "memory");
+	int tmp = *(volatile signed int *)(&(lock)->slock);
+
+	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
 }
 
-/*
- * Same as __raw_spin_lock, but reenable interrupts during spinning.
- */
-#ifndef CONFIG_PROVE_LOCKING
-static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
-	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
-		"jns 5f\n"
-		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
-		"jz 4f\n\t"
-	        "sti\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jle 3b\n\t"
-		"cli\n\t"
+	short inc = 0x0100;
+
+	/*
+	 * Ticket locks are conceptually two bytes, one indicating the current
+	 * head of the queue, and the other indicating the current tail. The
+	 * lock is acquired by atomically noting the tail and incrementing it
+	 * by one (thus adding ourself to the queue and noting our position),
+	 * then waiting until the head becomes equal to the the initial value
+	 * of the tail.
+	 *
+	 * This uses a 16-bit xadd to increment the tail and also load the
+	 * position of the head, which takes care of memory ordering issues
+	 * and should be optimal for the uncontended case. Note the tail must
+	 * be in the high byte, otherwise the 16-bit wide increment of the low
+	 * byte would carry up and contaminate the high byte.
+	 */
+
+	__asm__ __volatile__ (
+		LOCK_PREFIX "xaddw %w0, %1\n"
+		"1:\t"
+		"cmpb %h0, %b0\n\t"
+		"je 2f\n\t"
+		"rep ; nop\n\t"
+		"movb %1, %b0\n\t"
+		"lfence\n\t"
 		"jmp 1b\n"
-		"4:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jg 1b\n\t"
-		"jmp 4b\n"
-		"5:\n\t"
-		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
+		"2:"
+		:"+Q" (inc), "+m" (lock->slock)
+		:
+		:"memory", "cc");
 }
-#endif
+
+#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
-	int oldval;
+	short tmp;
+        short oldval;
 
 	asm volatile(
-		"xchgl %0,%1"
-		:"=q" (oldval), "=m" (lock->slock)
-		:"0" (0) : "memory");
+                "movw %2,%w0\n\t"
+                "cmpb %h0, %b0\n\t"
+                "jne 1f\n\t"
+                "movw %w0,%w1\n\t"
+                "incb %h1\n\t"
+                LOCK_PREFIX "cmpxchgw %w1,%2\n\t"
+                "1:"
+                :"=a" (oldval), "=Q" (tmp), "+m" (lock->slock)
+                :
+		: "memory", "cc");
 
-	return oldval > 0;
+	return ((oldval & 0xff) == ((oldval >> 8) & 0xff));
 }
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile("movl $1,%0" :"=m" (lock->slock) :: "memory");
+	__asm__ __volatile__(
+		"incb %0"
+		:"+m" (lock->slock)
+		:
+		:"memory", "cc");
 }
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
Index: linux-2.6/include/asm-x86_64/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/spinlock_types.h
+++ linux-2.6/include/asm-x86_64/spinlock_types.h
@@ -9,7 +9,7 @@ typedef struct {
 	unsigned int slock;
 } raw_spinlock_t;
 
-#define __RAW_SPIN_LOCK_UNLOCKED	{ 1 }
+#define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
 typedef struct {
 	unsigned int lock;
Index: linux-2.6/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86_64/Kconfig
+++ linux-2.6/arch/x86_64/Kconfig
@@ -34,8 +34,7 @@ config GENERIC_TIME_VSYSCALL
 
 config GENERIC_LOCKBREAK
 	bool
-	default y
-	depends on SMP && PREEMPT
+	default n
 
 config ZONE_DMA32
 	bool
