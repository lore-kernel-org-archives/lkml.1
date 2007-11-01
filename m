Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbXKAODc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbXKAODc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXKAODY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:03:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbXKAODW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:03:22 -0400
Date: Thu, 1 Nov 2007 15:03:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071101140320.GC26879@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101140146.GA26879@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce ticket lock spinlocks for x86 which are FIFO. The implementation
is described in the comments. The straight-line lock/unlock instruction
sequence is slightly slower than the dec based locks on modern x86 CPUs,
however the difference is quite small on Core2 and Opteron when working out of
cache, and becomes almost insignificant even on P4 when the lock misses cache.
trylock is more significantly slower, but they are relatively rare.

On an 8 core (2 socket) Opteron, spinlock unfairness is extremely noticable,
with a userspace test having a difference of up to 2x runtime per thread, and
some threads are starved or "unfairly" granted the lock up to 1 000 000 (!)
times. After this patch, all threads appear to finish at exactly the same
time.

The memory ordering of the lock does conform to x86 standards, and the
implementation has been reviewed by Intel and AMD engineers.

The algorithm also tells us how many CPUs are contending the lock, so
lockbreak becomes trivial and we no longer have to waste 4 bytes per
spinlock for it.

After this, we can no longer spin on any locks with preempt enabled
and cannot reenable interrupts when spinning on an irq safe lock, because
at that point we have already taken a ticket and the would deadlock if
the same CPU tries to take the lock again.  These are questionable anyway:
if the lock happens to be called under a preempt or interrupt disabled section,
then it will just have the same latency problems. The real fix is to keep
critical sections short, and ensure locks are reasonably fair (which this
patch does).

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/include/asm-x86/spinlock_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/spinlock_64.h
+++ linux-2.6/include/asm-x86/spinlock_64.h
@@ -12,74 +12,98 @@
  * Simple spin lock operations.  There are two variants, one clears IRQ's
  * on the local processor, one does not.
  *
- * We make no fairness assumptions. They have a cost.
+ * These are fair FIFO ticket locks, which are currently limited to 256
+ * CPUs.
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
 
+#if (NR_CPUS > 256)
+#error spinlock supports a maximum of 256 CPUs
+#endif
+
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
+		/* don't need lfence here, because loads are in-order */
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
+	short prev;
+	short new;
+	int ret = 0;
 
 	asm volatile(
-		"xchgl %0,%1"
-		:"=q" (oldval), "=m" (lock->slock)
-		:"0" (0) : "memory");
+		"movw %2,%w0\n\t"
+		"cmpb %h0,%b0\n\t"
+		"jne 1f\n\t"
+		"movw %w0,%w1\n\t"
+		"incb %h1\n\t"
+		"lock ; cmpxchgw %w1,%2\n\t"
+		"decb %h1\n\t"
+		"cmpw %w0,%w1\n\t"
+		"jne 1f\n\t"
+		"movl $1,%3\n\t"
+		"1:"
+		:"=a" (prev), "=Q" (new), "+m" (lock->slock), "+m" (ret)
+		:
+		: "memory", "cc");
 
-	return oldval > 0;
+	return ret;
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
Index: linux-2.6/include/asm-x86/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/asm-x86/spinlock_types.h
+++ linux-2.6/include/asm-x86/spinlock_types.h
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
@@ -80,8 +80,7 @@ config SBUS
 
 config GENERIC_LOCKBREAK
 	bool
-	default y
-	depends on SMP && PREEMPT
+	default n
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
Index: linux-2.6/include/asm-x86/paravirt.h
===================================================================
--- linux-2.6.orig/include/asm-x86/paravirt.h
+++ linux-2.6/include/asm-x86/paravirt.h
@@ -1071,27 +1071,6 @@ static inline unsigned long __raw_local_
 	return f;
 }
 
-#define CLI_STRING							\
-	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
-		      "call *%[paravirt_cli_opptr];"			\
-		      "popl %%edx; popl %%ecx",				\
-		      "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
-
-#define STI_STRING							\
-	_paravirt_alt("pushl %%ecx; pushl %%edx;"			\
-		      "call *%[paravirt_sti_opptr];"			\
-		      "popl %%edx; popl %%ecx",				\
-		      "%c[paravirt_sti_type]", "%c[paravirt_clobber]")
-
-#define CLI_STI_CLOBBERS , "%eax"
-#define CLI_STI_INPUT_ARGS						\
-	,								\
-	[paravirt_cli_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_disable)),		\
-	[paravirt_cli_opptr] "m" (pv_irq_ops.irq_disable),		\
-	[paravirt_sti_type] "i" (PARAVIRT_PATCH(pv_irq_ops.irq_enable)),		\
-	[paravirt_sti_opptr] "m" (pv_irq_ops.irq_enable),		\
-	paravirt_clobber(CLBR_EAX)
-
 /* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
 #undef __PVOP_CALL
Index: linux-2.6/include/asm-x86/spinlock_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/spinlock_32.h
+++ linux-2.6/include/asm-x86/spinlock_32.h
@@ -7,120 +7,116 @@
 #include <asm/processor.h>
 #include <linux/compiler.h>
 
-#ifdef CONFIG_PARAVIRT
-#include <asm/paravirt.h>
-#else
-#define CLI_STRING	"cli"
-#define STI_STRING	"sti"
-#define CLI_STI_CLOBBERS
-#define CLI_STI_INPUT_ARGS
-#endif /* CONFIG_PARAVIRT */
-
 /*
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  *
  * Simple spin lock operations.  There are two variants, one clears IRQ's
  * on the local processor, one does not.
  *
- * We make no fairness assumptions. They have a cost.
+ * These are fair FIFO ticket locks, which are currently limited to 256
+ * CPUs.
  *
  * (the type definitions are in asm/spinlock_types.h)
  */
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *x)
+#if (NR_CPUS > 256)
+#error spinlock supports a maximum of 256 CPUs
+#endif
+
+static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
-	return *(volatile signed char *)(&(x)->slock) <= 0;
+	int tmp = *(volatile signed int *)(&(lock)->slock);
+
+	return (((tmp >> 8) & 0xff) != (tmp & 0xff));
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
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
+	int tmp = *(volatile signed int *)(&(lock)->slock);
+
+	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
 }
 
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
+static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
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
+		/* don't need lfence here, because loads are in-order */
 		"jmp 1b\n"
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
-	char oldval;
+	short prev;
+	short new;
+	int ret = 0;
+
 	asm volatile(
-		"xchgb %b0,%1"
-		:"=q" (oldval), "+m" (lock->slock)
-		:"0" (0) : "memory");
-	return oldval > 0;
+		"movw %2,%w0\n\t"
+		"cmpb %h0,%b0\n\t"
+		"jne 1f\n\t"
+		"movw %w0,%w1\n\t"
+		"incb %h1\n\t"
+		"lock ; cmpxchgw %w1,%2\n\t"
+		"decb %h1\n\t"
+		"cmpw %w0,%w1\n\t"
+		"jne 1f\n\t"
+		"movl $1,%3\n\t"
+		"1:"
+		:"=a" (prev), "=Q" (new), "+m" (lock->slock), "+m" (ret)
+		:
+		: "memory", "cc");
+
+	return ret;
 }
 
+#if defined(CONFIG_X86_OOSTORE) || defined(CONFIG_X86_PPRO_FENCE)
 /*
- * __raw_spin_unlock based on writing $1 to the low byte.
- * This method works. Despite all the confusion.
- * (except on PPro SMP or if we are using OOSTORE, so we use xchgb there)
+ * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
  * (PPro errata 66, 92)
  */
-
-#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
-
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
-{
-	asm volatile("movb $1,%0" : "+m" (lock->slock) :: "memory");
-}
-
+#define UNLOCK_LOCK_PREFIX LOCK_PREFIX
 #else
+#define UNLOCK_LOCK_PREFIX
+#endif
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	char oldval = 1;
-
-	asm volatile("xchgb %b0, %1"
-		     : "=q" (oldval), "+m" (lock->slock)
-		     : "0" (oldval) : "memory");
+	__asm__ __volatile__(
+		UNLOCK_LOCK_PREFIX "incb %0"
+		:"+m" (lock->slock)
+		:
+		:"memory", "cc");
 }
 
-#endif
-
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
 	while (__raw_spin_is_locked(lock))
