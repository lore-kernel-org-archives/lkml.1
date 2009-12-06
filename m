Return-Path: <linux-kernel-owner+w=401wt.eu-S934159AbZLFSD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbZLFSD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934129AbZLFSD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:26 -0500
Received: from www.tglx.de ([62.245.132.106]:33117 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934082AbZLFSCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:49 -0500
Message-Id: <20091206111957.530224983@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 06/23] locking: Convert __raw_spin* functions to arch_spin*
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-convert-arch-raw-lock-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name space cleanup. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/spinlock.h          |   18 +++++------
 arch/arm/include/asm/spinlock.h            |   20 ++++++------
 arch/blackfin/include/asm/spinlock.h       |   20 ++++++------
 arch/cris/include/arch-v32/arch/spinlock.h |   46 ++++++++++++++---------------
 arch/ia64/include/asm/bitops.h             |    2 -
 arch/ia64/include/asm/spinlock.h           |   26 ++++++++--------
 arch/m32r/include/asm/spinlock.h           |   28 ++++++++---------
 arch/mips/include/asm/spinlock.h           |   36 +++++++++++-----------
 arch/parisc/include/asm/atomic.h           |    4 +-
 arch/parisc/include/asm/spinlock.h         |   44 +++++++++++++--------------
 arch/powerpc/include/asm/spinlock.h        |   32 ++++++++++----------
 arch/powerpc/kernel/rtas.c                 |   12 +++----
 arch/powerpc/lib/locks.c                   |    4 +-
 arch/powerpc/platforms/pasemi/setup.c      |    8 ++---
 arch/s390/include/asm/spinlock.h           |   36 +++++++++++-----------
 arch/s390/lib/spinlock.c                   |   22 ++++++-------
 arch/sh/include/asm/spinlock.h             |   26 ++++++++--------
 arch/sparc/include/asm/spinlock_32.h       |   20 ++++++------
 arch/sparc/include/asm/spinlock_64.h       |   18 +++++------
 arch/x86/include/asm/paravirt.h            |   14 ++++----
 arch/x86/include/asm/spinlock.h            |   26 ++++++++--------
 arch/x86/kernel/dumpstack.c                |    6 +--
 arch/x86/kernel/paravirt-spinlocks.c       |    2 -
 arch/x86/kernel/tsc_sync.c                 |    8 ++---
 include/asm-generic/bitops/atomic.h        |    4 +-
 include/linux/spinlock.h                   |   22 ++++++-------
 include/linux/spinlock_up.h                |   26 ++++++++--------
 kernel/lockdep.c                           |   18 +++++------
 kernel/mutex-debug.h                       |    4 +-
 kernel/spinlock.c                          |    4 +-
 kernel/trace/ring_buffer.c                 |   12 +++----
 kernel/trace/trace.c                       |   32 ++++++++++----------
 kernel/trace/trace_clock.c                 |    4 +-
 kernel/trace/trace_sched_wakeup.c          |   12 +++----
 kernel/trace/trace_selftest.c              |    4 +-
 kernel/trace/trace_stack.c                 |   12 +++----
 lib/spinlock_debug.c                       |    8 ++---
 37 files changed, 320 insertions(+), 320 deletions(-)

Index: linux-2.6-tip/arch/alpha/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock.h
@@ -12,18 +12,18 @@
  * We make no fairness assumptions. They have a cost.
  */
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-#define __raw_spin_is_locked(x)	((x)->lock != 0)
-#define __raw_spin_unlock_wait(x) \
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+#define arch_spin_is_locked(x)	((x)->lock != 0)
+#define arch_spin_unlock_wait(x) \
 		do { cpu_relax(); } while ((x)->lock)
 
-static inline void __raw_spin_unlock(arch_spinlock_t * lock)
+static inline void arch_spin_unlock(arch_spinlock_t * lock)
 {
 	mb();
 	lock->lock = 0;
 }
 
-static inline void __raw_spin_lock(arch_spinlock_t * lock)
+static inline void arch_spin_lock(arch_spinlock_t * lock)
 {
 	long tmp;
 
@@ -43,7 +43,7 @@ static inline void __raw_spin_lock(arch_
 	: "m"(lock->lock) : "memory");
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return !test_and_set_bit(0, &lock->lock);
 }
@@ -169,8 +169,8 @@ static inline void __raw_write_unlock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* _ALPHA_SPINLOCK_H */
Index: linux-2.6-tip/arch/arm/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock.h
@@ -17,13 +17,13 @@
  * Locked value: 1
  */
 
-#define __raw_spin_is_locked(x)		((x)->lock != 0)
-#define __raw_spin_unlock_wait(lock) \
-	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
+#define arch_spin_is_locked(x)		((x)->lock != 0)
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -43,7 +43,7 @@ static inline void __raw_spin_lock(arch_
 	smp_mb();
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -63,7 +63,7 @@ static inline int __raw_spin_trylock(arc
 	}
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	smp_mb();
 
@@ -220,8 +220,8 @@ static inline int __raw_read_trylock(raw
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* __ASM_SPINLOCK_H */
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
@@ -24,31 +24,31 @@ asmlinkage void __raw_write_lock_asm(vol
 asmlinkage int __raw_write_trylock_asm(volatile int *ptr);
 asmlinkage void __raw_write_unlock_asm(volatile int *ptr);
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __raw_spin_is_locked_asm(&lock->lock);
 }
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	__raw_spin_lock_asm(&lock->lock);
 }
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return __raw_spin_trylock_asm(&lock->lock);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__raw_spin_unlock_asm(&lock->lock);
 }
 
-static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (__raw_spin_is_locked(lock))
+	while (arch_spin_is_locked(lock))
 		cpu_relax();
 }
 
@@ -92,9 +92,9 @@ static inline void __raw_write_unlock(ra
 	__raw_write_unlock_asm(&rw->lock);
 }
 
-#define _raw_spin_relax(lock)  	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)  	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif
 
Index: linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/cris/include/arch-v32/arch/spinlock.h
+++ linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
@@ -9,12 +9,12 @@ extern void cris_spin_unlock(void *l, in
 extern void cris_spin_lock(void *l);
 extern int cris_spin_trylock(void *l);
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *x)
+static inline int arch_spin_is_locked(arch_spinlock_t *x)
 {
 	return *(volatile signed char *)(&(x)->slock) <= 0;
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ volatile ("move.d %1,%0" \
 			  : "=m" (lock->slock) \
@@ -22,26 +22,26 @@ static inline void __raw_spin_unlock(arc
 			  : "memory");
 }
 
-static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (__raw_spin_is_locked(lock))
+	while (arch_spin_is_locked(lock))
 		cpu_relax();
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return cris_spin_trylock((void *)&lock->slock);
 }
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	cris_spin_lock((void *)&lock->slock);
 }
 
 static inline void
-__raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
+arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
-	__raw_spin_lock(lock);
+	arch_spin_lock(lock);
 }
 
 /*
@@ -68,64 +68,64 @@ static inline int __raw_write_can_lock(r
 
 static  inline void __raw_read_lock(raw_rwlock_t *rw)
 {
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	while (rw->lock == 0);
 	rw->lock--;
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 }
 
 static  inline void __raw_write_lock(raw_rwlock_t *rw)
 {
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
 	rw->lock = 0;
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 }
 
 static  inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	rw->lock++;
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 }
 
 static  inline void __raw_write_unlock(raw_rwlock_t *rw)
 {
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
 	rw->lock = RW_LOCK_BIAS;
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 }
 
 static  inline int __raw_read_trylock(raw_rwlock_t *rw)
 {
 	int ret = 0;
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	if (rw->lock != 0) {
 		rw->lock--;
 		ret = 1;
 	}
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 	return ret;
 }
 
 static  inline int __raw_write_trylock(raw_rwlock_t *rw)
 {
 	int ret = 0;
-	__raw_spin_lock(&rw->slock);
+	arch_spin_lock(&rw->slock);
 	if (rw->lock == RW_LOCK_BIAS) {
 		rw->lock = 0;
 		ret = 1;
 	}
-	__raw_spin_unlock(&rw->slock);
+	arch_spin_unlock(&rw->slock);
 	return 1;
 }
 
 #define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
 #define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* __ASM_ARCH_SPINLOCK_H */
Index: linux-2.6-tip/arch/ia64/include/asm/bitops.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/bitops.h
+++ linux-2.6-tip/arch/ia64/include/asm/bitops.h
@@ -127,7 +127,7 @@ clear_bit_unlock (int nr, volatile void 
  * @addr: Address to start counting from
  *
  * Similarly to clear_bit_unlock, the implementation uses a store
- * with release semantics. See also __raw_spin_unlock().
+ * with release semantics. See also arch_spin_unlock().
  */
 static __inline__ void
 __clear_bit_unlock(int nr, void *addr)
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock.h
@@ -17,7 +17,7 @@
 #include <asm/intrinsics.h>
 #include <asm/system.h>
 
-#define __raw_spin_lock_init(x)			((x)->lock = 0)
+#define arch_spin_lock_init(x)			((x)->lock = 0)
 
 /*
  * Ticket locks are conceptually two parts, one indicating the current head of
@@ -103,39 +103,39 @@ static inline int __ticket_spin_is_conte
 	return ((tmp - (tmp >> TICKET_SHIFT)) & TICKET_MASK) > 1;
 }
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
 }
 
-static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_contended(lock);
 }
-#define __raw_spin_is_contended	__raw_spin_is_contended
+#define arch_spin_is_contended	arch_spin_is_contended
 
-static __always_inline void __raw_spin_lock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
 
-static __always_inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock(lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(arch_spinlock_t *lock,
+static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
-	__raw_spin_lock(lock);
+	arch_spin_lock(lock);
 }
 
-static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock_wait(lock);
 }
@@ -285,8 +285,8 @@ static inline int __raw_read_trylock(raw
 	return (u32)ia64_cmpxchg4_acq((__u32 *)(x), new.word, old.word) == old.word;
 }
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /*  _ASM_IA64_SPINLOCK_H */
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock.h
@@ -24,19 +24,19 @@
  * We make no fairness assumptions. They have a cost.
  */
 
-#define __raw_spin_is_locked(x)		(*(volatile int *)(&(x)->slock) <= 0)
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-#define __raw_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (__raw_spin_is_locked(x))
+#define arch_spin_is_locked(x)		(*(volatile int *)(&(x)->slock) <= 0)
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+#define arch_spin_unlock_wait(x) \
+		do { cpu_relax(); } while (arch_spin_is_locked(x))
 
 /**
- * __raw_spin_trylock - Try spin lock and return a result
+ * arch_spin_trylock - Try spin lock and return a result
  * @lock: Pointer to the lock variable
  *
- * __raw_spin_trylock() tries to get the lock and returns a result.
+ * arch_spin_trylock() tries to get the lock and returns a result.
  * On the m32r, the result value is 1 (= Success) or 0 (= Failure).
  */
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	int oldval;
 	unsigned long tmp1, tmp2;
@@ -50,7 +50,7 @@ static inline int __raw_spin_trylock(arc
 	 * }
 	 */
 	__asm__ __volatile__ (
-		"# __raw_spin_trylock		\n\t"
+		"# arch_spin_trylock		\n\t"
 		"ldi	%1, #0;			\n\t"
 		"mvfc	%2, psw;		\n\t"
 		"clrpsw	#0x40 -> nop;		\n\t"
@@ -69,7 +69,7 @@ static inline int __raw_spin_trylock(arc
 	return (oldval > 0);
 }
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp0, tmp1;
 
@@ -84,7 +84,7 @@ static inline void __raw_spin_lock(arch_
 	 * }
 	 */
 	__asm__ __volatile__ (
-		"# __raw_spin_lock		\n\t"
+		"# arch_spin_lock		\n\t"
 		".fillinsn			\n"
 		"1:				\n\t"
 		"mvfc	%1, psw;		\n\t"
@@ -111,7 +111,7 @@ static inline void __raw_spin_lock(arch_
 	);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	mb();
 	lock->slock = 1;
@@ -319,8 +319,8 @@ static inline int __raw_write_trylock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif	/* _ASM_M32R_SPINLOCK_H */
Index: linux-2.6-tip/arch/mips/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock.h
@@ -34,33 +34,33 @@
  * becomes equal to the the initial value of the tail.
  */
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	unsigned int counters = ACCESS_ONCE(lock->lock);
 
 	return ((counters >> 14) ^ counters) & 0x1fff;
 }
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-#define __raw_spin_unlock_wait(x) \
-	while (__raw_spin_is_locked(x)) { cpu_relax(); }
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+#define arch_spin_unlock_wait(x) \
+	while (arch_spin_is_locked(x)) { cpu_relax(); }
 
-static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	unsigned int counters = ACCESS_ONCE(lock->lock);
 
 	return (((counters >> 14) - counters) & 0x1fff) > 1;
 }
-#define __raw_spin_is_contended	__raw_spin_is_contended
+#define arch_spin_is_contended	arch_spin_is_contended
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	int my_ticket;
 	int tmp;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__ (
-		"	.set push		# __raw_spin_lock	\n"
+		"	.set push		# arch_spin_lock	\n"
 		"	.set noreorder					\n"
 		"							\n"
 		"1:	ll	%[ticket], %[ticket_ptr]		\n"
@@ -94,7 +94,7 @@ static inline void __raw_spin_lock(arch_
 		  [my_ticket] "=&r" (my_ticket));
 	} else {
 		__asm__ __volatile__ (
-		"	.set push		# __raw_spin_lock	\n"
+		"	.set push		# arch_spin_lock	\n"
 		"	.set noreorder					\n"
 		"							\n"
 		"	ll	%[ticket], %[ticket_ptr]		\n"
@@ -134,7 +134,7 @@ static inline void __raw_spin_lock(arch_
 	smp_llsc_mb();
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	int tmp;
 
@@ -142,7 +142,7 @@ static inline void __raw_spin_unlock(arc
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__ (
-		"				# __raw_spin_unlock	\n"
+		"				# arch_spin_unlock	\n"
 		"1:	ll	%[ticket], %[ticket_ptr]		\n"
 		"	addiu	%[ticket], %[ticket], 1			\n"
 		"	ori	%[ticket], %[ticket], 0x2000		\n"
@@ -153,7 +153,7 @@ static inline void __raw_spin_unlock(arc
 		  [ticket] "=&r" (tmp));
 	} else {
 		__asm__ __volatile__ (
-		"	.set push		# __raw_spin_unlock	\n"
+		"	.set push		# arch_spin_unlock	\n"
 		"	.set noreorder					\n"
 		"							\n"
 		"	ll	%[ticket], %[ticket_ptr]		\n"
@@ -174,13 +174,13 @@ static inline void __raw_spin_unlock(arc
 	}
 }
 
-static inline unsigned int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline unsigned int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp, tmp2, tmp3;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__ (
-		"	.set push		# __raw_spin_trylock	\n"
+		"	.set push		# arch_spin_trylock	\n"
 		"	.set noreorder					\n"
 		"							\n"
 		"1:	ll	%[ticket], %[ticket_ptr]		\n"
@@ -204,7 +204,7 @@ static inline unsigned int __raw_spin_tr
 		  [now_serving] "=&r" (tmp3));
 	} else {
 		__asm__ __volatile__ (
-		"	.set push		# __raw_spin_trylock	\n"
+		"	.set push		# arch_spin_trylock	\n"
 		"	.set noreorder					\n"
 		"							\n"
 		"	ll	%[ticket], %[ticket_ptr]		\n"
@@ -483,8 +483,8 @@ static inline int __raw_write_trylock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* _ASM_SPINLOCK_H */
Index: linux-2.6-tip/arch/parisc/include/asm/atomic.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/atomic.h
+++ linux-2.6-tip/arch/parisc/include/asm/atomic.h
@@ -34,12 +34,12 @@ extern arch_spinlock_t __atomic_hash[ATO
 #define _atomic_spin_lock_irqsave(l,f) do {	\
 	arch_spinlock_t *s = ATOMIC_HASH(l);		\
 	local_irq_save(f);			\
-	__raw_spin_lock(s);			\
+	arch_spin_lock(s);			\
 } while(0)
 
 #define _atomic_spin_unlock_irqrestore(l,f) do {	\
 	arch_spinlock_t *s = ATOMIC_HASH(l);			\
-	__raw_spin_unlock(s);				\
+	arch_spin_unlock(s);				\
 	local_irq_restore(f);				\
 } while(0)
 
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock.h
@@ -5,17 +5,17 @@
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *x)
+static inline int arch_spin_is_locked(arch_spinlock_t *x)
 {
 	volatile unsigned int *a = __ldcw_align(x);
 	return *a == 0;
 }
 
-#define __raw_spin_lock(lock) __raw_spin_lock_flags(lock, 0)
-#define __raw_spin_unlock_wait(x) \
-		do { cpu_relax(); } while (__raw_spin_is_locked(x))
+#define arch_spin_lock(lock) arch_spin_lock_flags(lock, 0)
+#define arch_spin_unlock_wait(x) \
+		do { cpu_relax(); } while (arch_spin_is_locked(x))
 
-static inline void __raw_spin_lock_flags(arch_spinlock_t *x,
+static inline void arch_spin_lock_flags(arch_spinlock_t *x,
 					 unsigned long flags)
 {
 	volatile unsigned int *a;
@@ -33,7 +33,7 @@ static inline void __raw_spin_lock_flags
 	mb();
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *x)
+static inline void arch_spin_unlock(arch_spinlock_t *x)
 {
 	volatile unsigned int *a;
 	mb();
@@ -42,7 +42,7 @@ static inline void __raw_spin_unlock(arc
 	mb();
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *x)
+static inline int arch_spin_trylock(arch_spinlock_t *x)
 {
 	volatile unsigned int *a;
 	int ret;
@@ -73,9 +73,9 @@ static  __inline__ void __raw_read_lock(
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	__raw_spin_lock_flags(&rw->lock, flags);
+	arch_spin_lock_flags(&rw->lock, flags);
 	rw->counter++;
-	__raw_spin_unlock(&rw->lock);
+	arch_spin_unlock(&rw->lock);
 	local_irq_restore(flags);
 }
 
@@ -85,9 +85,9 @@ static  __inline__ void __raw_read_unloc
 {
 	unsigned long flags;
 	local_irq_save(flags);
-	__raw_spin_lock_flags(&rw->lock, flags);
+	arch_spin_lock_flags(&rw->lock, flags);
 	rw->counter--;
-	__raw_spin_unlock(&rw->lock);
+	arch_spin_unlock(&rw->lock);
 	local_irq_restore(flags);
 }
 
@@ -98,9 +98,9 @@ static __inline__ int __raw_read_trylock
 	unsigned long flags;
  retry:
 	local_irq_save(flags);
-	if (__raw_spin_trylock(&rw->lock)) {
+	if (arch_spin_trylock(&rw->lock)) {
 		rw->counter++;
-		__raw_spin_unlock(&rw->lock);
+		arch_spin_unlock(&rw->lock);
 		local_irq_restore(flags);
 		return 1;
 	}
@@ -111,7 +111,7 @@ static __inline__ int __raw_read_trylock
 		return 0;
 
 	/* Wait until we have a realistic chance at the lock */
-	while (__raw_spin_is_locked(&rw->lock) && rw->counter >= 0)
+	while (arch_spin_is_locked(&rw->lock) && rw->counter >= 0)
 		cpu_relax();
 
 	goto retry;
@@ -124,10 +124,10 @@ static __inline__ void __raw_write_lock(
 	unsigned long flags;
 retry:
 	local_irq_save(flags);
-	__raw_spin_lock_flags(&rw->lock, flags);
+	arch_spin_lock_flags(&rw->lock, flags);
 
 	if (rw->counter != 0) {
-		__raw_spin_unlock(&rw->lock);
+		arch_spin_unlock(&rw->lock);
 		local_irq_restore(flags);
 
 		while (rw->counter != 0)
@@ -144,7 +144,7 @@ retry:
 static __inline__ void __raw_write_unlock(raw_rwlock_t *rw)
 {
 	rw->counter = 0;
-	__raw_spin_unlock(&rw->lock);
+	arch_spin_unlock(&rw->lock);
 }
 
 /* Note that we have to ensure interrupts are disabled in case we're
@@ -155,13 +155,13 @@ static __inline__ int __raw_write_tryloc
 	int result = 0;
 
 	local_irq_save(flags);
-	if (__raw_spin_trylock(&rw->lock)) {
+	if (arch_spin_trylock(&rw->lock)) {
 		if (rw->counter == 0) {
 			rw->counter = -1;
 			result = 1;
 		} else {
 			/* Read-locked.  Oh well. */
-			__raw_spin_unlock(&rw->lock);
+			arch_spin_unlock(&rw->lock);
 		}
 	}
 	local_irq_restore(flags);
@@ -190,8 +190,8 @@ static __inline__ int __raw_write_can_lo
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* __ASM_SPINLOCK_H */
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
@@ -28,7 +28,7 @@
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
 
-#define __raw_spin_is_locked(x)		((x)->slock != 0)
+#define arch_spin_is_locked(x)		((x)->slock != 0)
 
 #ifdef CONFIG_PPC64
 /* use 0x800000yy when locked, where yy == CPU number */
@@ -54,7 +54,7 @@
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
  */
-static inline unsigned long arch_spin_trylock(arch_spinlock_t *lock)
+static inline unsigned long __arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp, token;
 
@@ -73,10 +73,10 @@ static inline unsigned long arch_spin_tr
 	return tmp;
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
-	return arch_spin_trylock(lock) == 0;
+	return __arch_spin_trylock(lock) == 0;
 }
 
 /*
@@ -104,11 +104,11 @@ extern void __rw_yield(raw_rwlock_t *loc
 #define SHARED_PROCESSOR	0
 #endif
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(arch_spin_trylock(lock) == 0))
+		if (likely(__arch_spin_trylock(lock) == 0))
 			break;
 		do {
 			HMT_low();
@@ -120,13 +120,13 @@ static inline void __raw_spin_lock(arch_
 }
 
 static inline
-void __raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
+void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	unsigned long flags_dis;
 
 	CLEAR_IO_SYNC;
 	while (1) {
-		if (likely(arch_spin_trylock(lock) == 0))
+		if (likely(__arch_spin_trylock(lock) == 0))
 			break;
 		local_save_flags(flags_dis);
 		local_irq_restore(flags);
@@ -140,19 +140,19 @@ void __raw_spin_lock_flags(arch_spinlock
 	}
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	SYNC_IO;
-	__asm__ __volatile__("# __raw_spin_unlock\n\t"
+	__asm__ __volatile__("# arch_spin_unlock\n\t"
 				LWSYNC_ON_SMP: : :"memory");
 	lock->slock = 0;
 }
 
 #ifdef CONFIG_PPC64
-extern void __raw_spin_unlock_wait(arch_spinlock_t *lock);
+extern void arch_spin_unlock_wait(arch_spinlock_t *lock);
 #else
-#define __raw_spin_unlock_wait(lock) \
-	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
 #endif
 
 /*
@@ -290,9 +290,9 @@ static inline void __raw_write_unlock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	__spin_yield(lock)
-#define _raw_read_relax(lock)	__rw_yield(lock)
-#define _raw_write_relax(lock)	__rw_yield(lock)
+#define arch_spin_relax(lock)	__spin_yield(lock)
+#define arch_read_relax(lock)	__rw_yield(lock)
+#define arch_write_relax(lock)	__rw_yield(lock)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_SPINLOCK_H */
Index: linux-2.6-tip/arch/powerpc/kernel/rtas.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/rtas.c
+++ linux-2.6-tip/arch/powerpc/kernel/rtas.c
@@ -80,13 +80,13 @@ static unsigned long lock_rtas(void)
 
 	local_irq_save(flags);
 	preempt_disable();
-	__raw_spin_lock_flags(&rtas.lock, flags);
+	arch_spin_lock_flags(&rtas.lock, flags);
 	return flags;
 }
 
 static void unlock_rtas(unsigned long flags)
 {
-	__raw_spin_unlock(&rtas.lock);
+	arch_spin_unlock(&rtas.lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
@@ -987,10 +987,10 @@ void __cpuinit rtas_give_timebase(void)
 
 	local_irq_save(flags);
 	hard_irq_disable();
-	__raw_spin_lock(&timebase_lock);
+	arch_spin_lock(&timebase_lock);
 	rtas_call(rtas_token("freeze-time-base"), 0, 1, NULL);
 	timebase = get_tb();
-	__raw_spin_unlock(&timebase_lock);
+	arch_spin_unlock(&timebase_lock);
 
 	while (timebase)
 		barrier();
@@ -1002,8 +1002,8 @@ void __cpuinit rtas_take_timebase(void)
 {
 	while (!timebase)
 		barrier();
-	__raw_spin_lock(&timebase_lock);
+	arch_spin_lock(&timebase_lock);
 	set_tb(timebase >> 32, timebase & 0xffffffff);
 	timebase = 0;
-	__raw_spin_unlock(&timebase_lock);
+	arch_spin_unlock(&timebase_lock);
 }
Index: linux-2.6-tip/arch/powerpc/lib/locks.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/lib/locks.c
+++ linux-2.6-tip/arch/powerpc/lib/locks.c
@@ -82,7 +82,7 @@ void __rw_yield(raw_rwlock_t *rw)
 }
 #endif
 
-void __raw_spin_unlock_wait(arch_spinlock_t *lock)
+void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (lock->slock) {
 		HMT_low();
@@ -92,4 +92,4 @@ void __raw_spin_unlock_wait(arch_spinloc
 	HMT_medium();
 }
 
-EXPORT_SYMBOL(__raw_spin_unlock_wait);
+EXPORT_SYMBOL(arch_spin_unlock_wait);
Index: linux-2.6-tip/arch/powerpc/platforms/pasemi/setup.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pasemi/setup.c
+++ linux-2.6-tip/arch/powerpc/platforms/pasemi/setup.c
@@ -80,11 +80,11 @@ static void __devinit pas_give_timebase(
 
 	local_irq_save(flags);
 	hard_irq_disable();
-	__raw_spin_lock(&timebase_lock);
+	arch_spin_lock(&timebase_lock);
 	mtspr(SPRN_TBCTL, TBCTL_FREEZE);
 	isync();
 	timebase = get_tb();
-	__raw_spin_unlock(&timebase_lock);
+	arch_spin_unlock(&timebase_lock);
 
 	while (timebase)
 		barrier();
@@ -97,10 +97,10 @@ static void __devinit pas_take_timebase(
 	while (!timebase)
 		smp_rmb();
 
-	__raw_spin_lock(&timebase_lock);
+	arch_spin_lock(&timebase_lock);
 	set_tb(timebase >> 32, timebase & 0xffffffff);
 	timebase = 0;
-	__raw_spin_unlock(&timebase_lock);
+	arch_spin_unlock(&timebase_lock);
 }
 
 struct smp_ops_t pas_smp_ops = {
Index: linux-2.6-tip/arch/s390/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock.h
@@ -52,27 +52,27 @@ _raw_compare_and_swap(volatile unsigned 
  * (the type definitions are in asm/spinlock_types.h)
  */
 
-#define __raw_spin_is_locked(x) ((x)->owner_cpu != 0)
-#define __raw_spin_unlock_wait(lock) \
-	do { while (__raw_spin_is_locked(lock)) \
-		 _raw_spin_relax(lock); } while (0)
-
-extern void _raw_spin_lock_wait(arch_spinlock_t *);
-extern void _raw_spin_lock_wait_flags(arch_spinlock_t *, unsigned long flags);
-extern int _raw_spin_trylock_retry(arch_spinlock_t *);
-extern void _raw_spin_relax(arch_spinlock_t *lock);
+#define arch_spin_is_locked(x) ((x)->owner_cpu != 0)
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) \
+		 arch_spin_relax(lock); } while (0)
+
+extern void arch_spin_lock_wait(arch_spinlock_t *);
+extern void arch_spin_lock_wait_flags(arch_spinlock_t *, unsigned long flags);
+extern int arch_spin_trylock_retry(arch_spinlock_t *);
+extern void arch_spin_relax(arch_spinlock_t *lock);
 
-static inline void __raw_spin_lock(arch_spinlock_t *lp)
+static inline void arch_spin_lock(arch_spinlock_t *lp)
 {
 	int old;
 
 	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
 	if (likely(old == 0))
 		return;
-	_raw_spin_lock_wait(lp);
+	arch_spin_lock_wait(lp);
 }
 
-static inline void __raw_spin_lock_flags(arch_spinlock_t *lp,
+static inline void arch_spin_lock_flags(arch_spinlock_t *lp,
 					 unsigned long flags)
 {
 	int old;
@@ -80,20 +80,20 @@ static inline void __raw_spin_lock_flags
 	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
 	if (likely(old == 0))
 		return;
-	_raw_spin_lock_wait_flags(lp, flags);
+	arch_spin_lock_wait_flags(lp, flags);
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lp)
+static inline int arch_spin_trylock(arch_spinlock_t *lp)
 {
 	int old;
 
 	old = _raw_compare_and_swap(&lp->owner_cpu, 0, ~smp_processor_id());
 	if (likely(old == 0))
 		return 1;
-	return _raw_spin_trylock_retry(lp);
+	return arch_spin_trylock_retry(lp);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lp)
+static inline void arch_spin_unlock(arch_spinlock_t *lp)
 {
 	_raw_compare_and_swap(&lp->owner_cpu, lp->owner_cpu, 0);
 }
@@ -188,7 +188,7 @@ static inline int __raw_write_trylock(ra
 	return _raw_write_trylock_retry(rw);
 }
 
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* __ASM_SPINLOCK_H */
Index: linux-2.6-tip/arch/s390/lib/spinlock.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/lib/spinlock.c
+++ linux-2.6-tip/arch/s390/lib/spinlock.c
@@ -39,7 +39,7 @@ static inline void _raw_yield_cpu(int cp
 		_raw_yield();
 }
 
-void _raw_spin_lock_wait(arch_spinlock_t *lp)
+void arch_spin_lock_wait(arch_spinlock_t *lp)
 {
 	int count = spin_retry;
 	unsigned int cpu = ~smp_processor_id();
@@ -51,15 +51,15 @@ void _raw_spin_lock_wait(arch_spinlock_t
 				_raw_yield_cpu(~owner);
 			count = spin_retry;
 		}
-		if (__raw_spin_is_locked(lp))
+		if (arch_spin_is_locked(lp))
 			continue;
 		if (_raw_compare_and_swap(&lp->owner_cpu, 0, cpu) == 0)
 			return;
 	}
 }
-EXPORT_SYMBOL(_raw_spin_lock_wait);
+EXPORT_SYMBOL(arch_spin_lock_wait);
 
-void _raw_spin_lock_wait_flags(arch_spinlock_t *lp, unsigned long flags)
+void arch_spin_lock_wait_flags(arch_spinlock_t *lp, unsigned long flags)
 {
 	int count = spin_retry;
 	unsigned int cpu = ~smp_processor_id();
@@ -72,7 +72,7 @@ void _raw_spin_lock_wait_flags(arch_spin
 				_raw_yield_cpu(~owner);
 			count = spin_retry;
 		}
-		if (__raw_spin_is_locked(lp))
+		if (arch_spin_is_locked(lp))
 			continue;
 		local_irq_disable();
 		if (_raw_compare_and_swap(&lp->owner_cpu, 0, cpu) == 0)
@@ -80,30 +80,30 @@ void _raw_spin_lock_wait_flags(arch_spin
 		local_irq_restore(flags);
 	}
 }
-EXPORT_SYMBOL(_raw_spin_lock_wait_flags);
+EXPORT_SYMBOL(arch_spin_lock_wait_flags);
 
-int _raw_spin_trylock_retry(arch_spinlock_t *lp)
+int arch_spin_trylock_retry(arch_spinlock_t *lp)
 {
 	unsigned int cpu = ~smp_processor_id();
 	int count;
 
 	for (count = spin_retry; count > 0; count--) {
-		if (__raw_spin_is_locked(lp))
+		if (arch_spin_is_locked(lp))
 			continue;
 		if (_raw_compare_and_swap(&lp->owner_cpu, 0, cpu) == 0)
 			return 1;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(_raw_spin_trylock_retry);
+EXPORT_SYMBOL(arch_spin_trylock_retry);
 
-void _raw_spin_relax(arch_spinlock_t *lock)
+void arch_spin_relax(arch_spinlock_t *lock)
 {
 	unsigned int cpu = lock->owner_cpu;
 	if (cpu != 0)
 		_raw_yield_cpu(~cpu);
 }
-EXPORT_SYMBOL(_raw_spin_relax);
+EXPORT_SYMBOL(arch_spin_relax);
 
 void _raw_read_lock_wait(raw_rwlock_t *rw)
 {
Index: linux-2.6-tip/arch/sh/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock.h
@@ -23,10 +23,10 @@
  * Your basic SMP spinlocks, allowing only a single CPU anywhere
  */
 
-#define __raw_spin_is_locked(x)		((x)->lock <= 0)
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
-#define __raw_spin_unlock_wait(x) \
-	do { while (__raw_spin_is_locked(x)) cpu_relax(); } while (0)
+#define arch_spin_is_locked(x)		((x)->lock <= 0)
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
+#define arch_spin_unlock_wait(x) \
+	do { while (arch_spin_is_locked(x)) cpu_relax(); } while (0)
 
 /*
  * Simple spin lock operations.  There are two variants, one clears IRQ's
@@ -34,14 +34,14 @@
  *
  * We make no fairness assumptions.  They have a cost.
  */
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 	unsigned long oldval;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%2, %0	! __raw_spin_lock	\n\t"
+		"movli.l	@%2, %0	! arch_spin_lock	\n\t"
 		"mov		%0, %1				\n\t"
 		"mov		#0, %0				\n\t"
 		"movco.l	%0, @%2				\n\t"
@@ -54,12 +54,12 @@ static inline void __raw_spin_lock(arch_
 	);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
 	__asm__ __volatile__ (
-		"mov		#1, %0 ! __raw_spin_unlock	\n\t"
+		"mov		#1, %0 ! arch_spin_unlock	\n\t"
 		"mov.l		%0, @%1				\n\t"
 		: "=&z" (tmp)
 		: "r" (&lock->lock)
@@ -67,13 +67,13 @@ static inline void __raw_spin_unlock(arc
 	);
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp, oldval;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%2, %0	! __raw_spin_trylock	\n\t"
+		"movli.l	@%2, %0	! arch_spin_trylock	\n\t"
 		"mov		%0, %1				\n\t"
 		"mov		#0, %0				\n\t"
 		"movco.l	%0, @%2				\n\t"
@@ -219,8 +219,8 @@ static inline int __raw_write_trylock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* __ASM_SH_SPINLOCK_H */
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_32.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
@@ -10,12 +10,12 @@
 
 #include <asm/psr.h>
 
-#define __raw_spin_is_locked(lock) (*((volatile unsigned char *)(lock)) != 0)
+#define arch_spin_is_locked(lock) (*((volatile unsigned char *)(lock)) != 0)
 
-#define __raw_spin_unlock_wait(lock) \
-	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
+#define arch_spin_unlock_wait(lock) \
+	do { while (arch_spin_is_locked(lock)) cpu_relax(); } while (0)
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__(
 	"\n1:\n\t"
@@ -35,7 +35,7 @@ static inline void __raw_spin_lock(arch_
 	: "g2", "memory", "cc");
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int result;
 	__asm__ __volatile__("ldstub [%1], %0"
@@ -45,7 +45,7 @@ static inline int __raw_spin_trylock(arc
 	return (result == 0);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__("stb %%g0, [%0]" : : "r" (lock) : "memory");
 }
@@ -176,13 +176,13 @@ static inline int arch_read_trylock(raw_
 
 #define __raw_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
 
-#define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
+#define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
 #define __raw_read_lock_flags(rw, flags)   __raw_read_lock(rw)
 #define __raw_write_lock_flags(rw, flags)  __raw_write_lock(rw)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #define __raw_read_can_lock(rw) (!((rw)->lock & 0xff))
 #define __raw_write_can_lock(rw) (!(rw)->lock)
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_64.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
@@ -21,13 +21,13 @@
  * the spinner sections must be pre-V9 branches.
  */
 
-#define __raw_spin_is_locked(lp)	((lp)->lock != 0)
+#define arch_spin_is_locked(lp)	((lp)->lock != 0)
 
-#define __raw_spin_unlock_wait(lp)	\
+#define arch_spin_unlock_wait(lp)	\
 	do {	rmb();			\
 	} while((lp)->lock)
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -46,7 +46,7 @@ static inline void __raw_spin_lock(arch_
 	: "memory");
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long result;
 
@@ -59,7 +59,7 @@ static inline int __raw_spin_trylock(arc
 	return (result == 0UL);
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stb		%%g0, [%0]"
@@ -68,7 +68,7 @@ static inline void __raw_spin_unlock(arc
 	: "memory");
 }
 
-static inline void __raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
+static inline void arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	unsigned long tmp1, tmp2;
 
@@ -222,9 +222,9 @@ static int inline arch_write_trylock(raw
 #define __raw_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
 #define __raw_write_can_lock(rw)	(!(rw)->lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 #endif /* !(__ASSEMBLY__) */
 
Index: linux-2.6-tip/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6-tip/arch/x86/include/asm/paravirt.h
@@ -731,34 +731,34 @@ static inline void __set_fixmap(unsigned
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int __raw_spin_is_locked(struct arch_spinlock *lock)
+static inline int arch_spin_is_locked(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
 }
 
-static inline int __raw_spin_is_contended(struct arch_spinlock *lock)
+static inline int arch_spin_is_contended(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
 }
-#define __raw_spin_is_contended	__raw_spin_is_contended
+#define arch_spin_is_contended	arch_spin_is_contended
 
-static __always_inline void __raw_spin_lock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_lock(struct arch_spinlock *lock)
 {
 	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(struct arch_spinlock *lock,
+static __always_inline void arch_spin_lock_flags(struct arch_spinlock *lock,
 						  unsigned long flags)
 {
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int __raw_spin_trylock(struct arch_spinlock *lock)
+static __always_inline int arch_spin_trylock(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
 }
 
-static __always_inline void __raw_spin_unlock(struct arch_spinlock *lock)
+static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
 {
 	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
 }
Index: linux-2.6-tip/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock.h
@@ -174,43 +174,43 @@ static inline int __ticket_spin_is_conte
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
 
-static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
+static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
 }
 
-static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
+static inline int arch_spin_is_contended(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_contended(lock);
 }
-#define __raw_spin_is_contended	__raw_spin_is_contended
+#define arch_spin_is_contended	arch_spin_is_contended
 
-static __always_inline void __raw_spin_lock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static __always_inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
 
-static __always_inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock(lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(arch_spinlock_t *lock,
+static __always_inline void arch_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
-	__raw_spin_lock(lock);
+	arch_spin_lock(lock);
 }
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
-static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
+static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
 {
-	while (__raw_spin_is_locked(lock))
+	while (arch_spin_is_locked(lock))
 		cpu_relax();
 }
 
@@ -298,9 +298,9 @@ static inline void __raw_write_unlock(ra
 #define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
 #define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
 
-#define _raw_spin_relax(lock)	cpu_relax()
-#define _raw_read_relax(lock)	cpu_relax()
-#define _raw_write_relax(lock)	cpu_relax()
+#define arch_spin_relax(lock)	cpu_relax()
+#define arch_read_relax(lock)	cpu_relax()
+#define arch_write_relax(lock)	cpu_relax()
 
 /* The {read|write|spin}_lock() on x86 are full memory barriers. */
 static inline void smp_mb__after_lock(void) { }
Index: linux-2.6-tip/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6-tip/arch/x86/kernel/dumpstack.c
@@ -207,11 +207,11 @@ unsigned __kprobes long oops_begin(void)
 	/* racy, but better than risking deadlock. */
 	raw_local_irq_save(flags);
 	cpu = smp_processor_id();
-	if (!__raw_spin_trylock(&die_lock)) {
+	if (!arch_spin_trylock(&die_lock)) {
 		if (cpu == die_owner)
 			/* nested oops. should stop eventually */;
 		else
-			__raw_spin_lock(&die_lock);
+			arch_spin_lock(&die_lock);
 	}
 	die_nest_count++;
 	die_owner = cpu;
@@ -231,7 +231,7 @@ void __kprobes oops_end(unsigned long fl
 	die_nest_count--;
 	if (!die_nest_count)
 		/* Nest count reaches zero, release the lock. */
-		__raw_spin_unlock(&die_lock);
+		arch_spin_unlock(&die_lock);
 	raw_local_irq_restore(flags);
 	oops_exit();
 
Index: linux-2.6-tip/arch/x86/kernel/paravirt-spinlocks.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/paravirt-spinlocks.c
+++ linux-2.6-tip/arch/x86/kernel/paravirt-spinlocks.c
@@ -10,7 +10,7 @@
 static inline void
 default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
-	__raw_spin_lock(lock);
+	arch_spin_lock(lock);
 }
 
 struct pv_lock_ops pv_lock_ops = {
Index: linux-2.6-tip/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/tsc_sync.c
+++ linux-2.6-tip/arch/x86/kernel/tsc_sync.c
@@ -62,13 +62,13 @@ static __cpuinit void check_tsc_warp(voi
 		 * previous TSC that was measured (possibly on
 		 * another CPU) and update the previous TSC timestamp.
 		 */
-		__raw_spin_lock(&sync_lock);
+		arch_spin_lock(&sync_lock);
 		prev = last_tsc;
 		rdtsc_barrier();
 		now = get_cycles();
 		rdtsc_barrier();
 		last_tsc = now;
-		__raw_spin_unlock(&sync_lock);
+		arch_spin_unlock(&sync_lock);
 
 		/*
 		 * Be nice every now and then (and also check whether
@@ -87,10 +87,10 @@ static __cpuinit void check_tsc_warp(voi
 		 * we saw a time-warp of the TSC going backwards:
 		 */
 		if (unlikely(prev > now)) {
-			__raw_spin_lock(&sync_lock);
+			arch_spin_lock(&sync_lock);
 			max_warp = max(max_warp, prev - now);
 			nr_warps++;
-			__raw_spin_unlock(&sync_lock);
+			arch_spin_unlock(&sync_lock);
 		}
 	}
 	WARN(!(now-start),
Index: linux-2.6-tip/include/asm-generic/bitops/atomic.h
===================================================================
--- linux-2.6-tip.orig/include/asm-generic/bitops/atomic.h
+++ linux-2.6-tip/include/asm-generic/bitops/atomic.h
@@ -22,12 +22,12 @@ extern arch_spinlock_t __atomic_hash[ATO
 #define _atomic_spin_lock_irqsave(l,f) do {	\
 	arch_spinlock_t *s = ATOMIC_HASH(l);	\
 	local_irq_save(f);			\
-	__raw_spin_lock(s);			\
+	arch_spin_lock(s);			\
 } while(0)
 
 #define _atomic_spin_unlock_irqrestore(l,f) do {	\
 	arch_spinlock_t *s = ATOMIC_HASH(l);		\
-	__raw_spin_unlock(s);				\
+	arch_spin_unlock(s);				\
 	local_irq_restore(f);				\
 } while(0)
 
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -14,7 +14,7 @@
  *  linux/spinlock_types.h:
  *                        defines the generic type and initializers
  *
- *  asm/spinlock.h:       contains the __raw_spin_*()/etc. lowlevel
+ *  asm/spinlock.h:       contains the arch_spin_*()/etc. lowlevel
  *                        implementations, mostly inline assembly code
  *
  *   (also included on UP-debug builds:)
@@ -34,7 +34,7 @@
  *                        defines the generic type and initializers
  *
  *  linux/spinlock_up.h:
- *                        contains the __raw_spin_*()/etc. version of UP
+ *                        contains the arch_spin_*()/etc. version of UP
  *                        builds. (which are NOPs on non-debug, non-preempt
  *                        builds)
  *
@@ -103,17 +103,17 @@ do {								\
 	do { *(lock) = __SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
-#define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
+#define spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
 
 #ifdef CONFIG_GENERIC_LOCKBREAK
 #define spin_is_contended(lock) ((lock)->break_lock)
 #else
 
-#ifdef __raw_spin_is_contended
-#define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
+#ifdef arch_spin_is_contended
+#define spin_is_contended(lock)	arch_spin_is_contended(&(lock)->raw_lock)
 #else
 #define spin_is_contended(lock)	(((void)(lock), 0))
-#endif /*__raw_spin_is_contended*/
+#endif /*arch_spin_is_contended*/
 #endif
 
 /* The lock does not imply full memory barrier. */
@@ -125,7 +125,7 @@ static inline void smp_mb__after_lock(vo
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
  */
-#define spin_unlock_wait(lock)	__raw_spin_unlock_wait(&(lock)->raw_lock)
+#define spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
@@ -133,11 +133,11 @@ static inline void smp_mb__after_lock(vo
  extern int _raw_spin_trylock(spinlock_t *lock);
  extern void _raw_spin_unlock(spinlock_t *lock);
 #else
-# define _raw_spin_lock(lock)		__raw_spin_lock(&(lock)->raw_lock)
+# define _raw_spin_lock(lock)		arch_spin_lock(&(lock)->raw_lock)
 # define _raw_spin_lock_flags(lock, flags) \
-		__raw_spin_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_spin_trylock(lock)	__raw_spin_trylock(&(lock)->raw_lock)
-# define _raw_spin_unlock(lock)		__raw_spin_unlock(&(lock)->raw_lock)
+		arch_spin_lock_flags(&(lock)->raw_lock, *(flags))
+# define _raw_spin_trylock(lock)	arch_spin_trylock(&(lock)->raw_lock)
+# define _raw_spin_unlock(lock)		arch_spin_unlock(&(lock)->raw_lock)
 #endif
 
 /*
Index: linux-2.6-tip/include/linux/spinlock_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_up.h
+++ linux-2.6-tip/include/linux/spinlock_up.h
@@ -18,21 +18,21 @@
  */
 
 #ifdef CONFIG_DEBUG_SPINLOCK
-#define __raw_spin_is_locked(x)		((x)->slock == 0)
+#define arch_spin_is_locked(x)		((x)->slock == 0)
 
-static inline void __raw_spin_lock(arch_spinlock_t *lock)
+static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	lock->slock = 0;
 }
 
 static inline void
-__raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
+arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	local_irq_save(flags);
 	lock->slock = 0;
 }
 
-static inline int __raw_spin_trylock(arch_spinlock_t *lock)
+static inline int arch_spin_trylock(arch_spinlock_t *lock)
 {
 	char oldval = lock->slock;
 
@@ -41,7 +41,7 @@ static inline int __raw_spin_trylock(arc
 	return oldval > 0;
 }
 
-static inline void __raw_spin_unlock(arch_spinlock_t *lock)
+static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	lock->slock = 1;
 }
@@ -57,20 +57,20 @@ static inline void __raw_spin_unlock(arc
 #define __raw_write_unlock(lock)	do { (void)(lock); } while (0)
 
 #else /* DEBUG_SPINLOCK */
-#define __raw_spin_is_locked(lock)	((void)(lock), 0)
+#define arch_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched.c and kernel_lock.c: */
-# define __raw_spin_lock(lock)		do { (void)(lock); } while (0)
-# define __raw_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
-# define __raw_spin_unlock(lock)	do { (void)(lock); } while (0)
-# define __raw_spin_trylock(lock)	({ (void)(lock); 1; })
+# define arch_spin_lock(lock)		do { (void)(lock); } while (0)
+# define arch_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
+# define arch_spin_unlock(lock)	do { (void)(lock); } while (0)
+# define arch_spin_trylock(lock)	({ (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
 
-#define __raw_spin_is_contended(lock)	(((void)(lock), 0))
+#define arch_spin_is_contended(lock)	(((void)(lock), 0))
 
 #define __raw_read_can_lock(lock)	(((void)(lock), 1))
 #define __raw_write_can_lock(lock)	(((void)(lock), 1))
 
-#define __raw_spin_unlock_wait(lock) \
-		do { cpu_relax(); } while (__raw_spin_is_locked(lock))
+#define arch_spin_unlock_wait(lock) \
+		do { cpu_relax(); } while (arch_spin_is_locked(lock))
 
 #endif /* __LINUX_SPINLOCK_UP_H */
Index: linux-2.6-tip/kernel/lockdep.c
===================================================================
--- linux-2.6-tip.orig/kernel/lockdep.c
+++ linux-2.6-tip/kernel/lockdep.c
@@ -77,7 +77,7 @@ static arch_spinlock_t lockdep_lock = (a
 
 static int graph_lock(void)
 {
-	__raw_spin_lock(&lockdep_lock);
+	arch_spin_lock(&lockdep_lock);
 	/*
 	 * Make sure that if another CPU detected a bug while
 	 * walking the graph we dont change it (while the other
@@ -85,7 +85,7 @@ static int graph_lock(void)
 	 * dropped already)
 	 */
 	if (!debug_locks) {
-		__raw_spin_unlock(&lockdep_lock);
+		arch_spin_unlock(&lockdep_lock);
 		return 0;
 	}
 	/* prevent any recursions within lockdep from causing deadlocks */
@@ -95,11 +95,11 @@ static int graph_lock(void)
 
 static inline int graph_unlock(void)
 {
-	if (debug_locks && !__raw_spin_is_locked(&lockdep_lock))
+	if (debug_locks && !arch_spin_is_locked(&lockdep_lock))
 		return DEBUG_LOCKS_WARN_ON(1);
 
 	current->lockdep_recursion--;
-	__raw_spin_unlock(&lockdep_lock);
+	arch_spin_unlock(&lockdep_lock);
 	return 0;
 }
 
@@ -111,7 +111,7 @@ static inline int debug_locks_off_graph_
 {
 	int ret = debug_locks_off();
 
-	__raw_spin_unlock(&lockdep_lock);
+	arch_spin_unlock(&lockdep_lock);
 
 	return ret;
 }
@@ -1161,9 +1161,9 @@ unsigned long lockdep_count_forward_deps
 	this.class = class;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&lockdep_lock);
+	arch_spin_lock(&lockdep_lock);
 	ret = __lockdep_count_forward_deps(&this);
-	__raw_spin_unlock(&lockdep_lock);
+	arch_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
 	return ret;
@@ -1188,9 +1188,9 @@ unsigned long lockdep_count_backward_dep
 	this.class = class;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&lockdep_lock);
+	arch_spin_lock(&lockdep_lock);
 	ret = __lockdep_count_backward_deps(&this);
-	__raw_spin_unlock(&lockdep_lock);
+	arch_spin_unlock(&lockdep_lock);
 	local_irq_restore(flags);
 
 	return ret;
Index: linux-2.6-tip/kernel/mutex-debug.h
===================================================================
--- linux-2.6-tip.orig/kernel/mutex-debug.h
+++ linux-2.6-tip/kernel/mutex-debug.h
@@ -43,13 +43,13 @@ static inline void mutex_clear_owner(str
 							\
 		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
 		local_irq_save(flags);			\
-		__raw_spin_lock(&(lock)->raw_lock);	\
+		arch_spin_lock(&(lock)->raw_lock);	\
 		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
 	} while (0)
 
 #define spin_unlock_mutex(lock, flags)			\
 	do {						\
-		__raw_spin_unlock(&(lock)->raw_lock);	\
+		arch_spin_unlock(&(lock)->raw_lock);	\
 		local_irq_restore(flags);		\
 		preempt_check_resched();		\
 	} while (0)
Index: linux-2.6-tip/kernel/spinlock.c
===================================================================
--- linux-2.6-tip.orig/kernel/spinlock.c
+++ linux-2.6-tip/kernel/spinlock.c
@@ -53,7 +53,7 @@ void __lockfunc __##op##_lock(locktype##
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
 		while (!op##_can_lock(lock) && (lock)->break_lock)	\
-			_raw_##op##_relax(&lock->raw_lock);		\
+			arch_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
 }									\
@@ -73,7 +73,7 @@ unsigned long __lockfunc __##op##_lock_i
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
 		while (!op##_can_lock(lock) && (lock)->break_lock)	\
-			_raw_##op##_relax(&lock->raw_lock);		\
+			arch_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
 	return flags;							\
Index: linux-2.6-tip/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/ring_buffer.c
+++ linux-2.6-tip/kernel/trace/ring_buffer.c
@@ -2834,7 +2834,7 @@ rb_get_reader_page(struct ring_buffer_pe
 	int ret;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&cpu_buffer->lock);
+	arch_spin_lock(&cpu_buffer->lock);
 
  again:
 	/*
@@ -2923,7 +2923,7 @@ rb_get_reader_page(struct ring_buffer_pe
 	goto again;
 
  out:
-	__raw_spin_unlock(&cpu_buffer->lock);
+	arch_spin_unlock(&cpu_buffer->lock);
 	local_irq_restore(flags);
 
 	return reader;
@@ -3286,9 +3286,9 @@ ring_buffer_read_start(struct ring_buffe
 	synchronize_sched();
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
-	__raw_spin_lock(&cpu_buffer->lock);
+	arch_spin_lock(&cpu_buffer->lock);
 	rb_iter_reset(iter);
-	__raw_spin_unlock(&cpu_buffer->lock);
+	arch_spin_unlock(&cpu_buffer->lock);
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
 
 	return iter;
@@ -3408,11 +3408,11 @@ void ring_buffer_reset_cpu(struct ring_b
 	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
 		goto out;
 
-	__raw_spin_lock(&cpu_buffer->lock);
+	arch_spin_lock(&cpu_buffer->lock);
 
 	rb_reset_cpu(cpu_buffer);
 
-	__raw_spin_unlock(&cpu_buffer->lock);
+	arch_spin_unlock(&cpu_buffer->lock);
 
  out:
 	spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
Index: linux-2.6-tip/kernel/trace/trace.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace.c
+++ linux-2.6-tip/kernel/trace/trace.c
@@ -555,13 +555,13 @@ update_max_tr(struct trace_array *tr, st
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	__raw_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&ftrace_max_lock);
 
 	tr->buffer = max_tr.buffer;
 	max_tr.buffer = buf;
 
 	__update_max_tr(tr, tsk, cpu);
-	__raw_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&ftrace_max_lock);
 }
 
 /**
@@ -581,7 +581,7 @@ update_max_tr_single(struct trace_array 
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	__raw_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&ftrace_max_lock);
 
 	ftrace_disable_cpu();
 
@@ -603,7 +603,7 @@ update_max_tr_single(struct trace_array 
 	WARN_ON_ONCE(ret && ret != -EAGAIN && ret != -EBUSY);
 
 	__update_max_tr(tr, tsk, cpu);
-	__raw_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&ftrace_max_lock);
 }
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
@@ -915,7 +915,7 @@ static void trace_save_cmdline(struct ta
 	 * nor do we want to disable interrupts,
 	 * so if we miss here, then better luck next time.
 	 */
-	if (!__raw_spin_trylock(&trace_cmdline_lock))
+	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return;
 
 	idx = map_pid_to_cmdline[tsk->pid];
@@ -940,7 +940,7 @@ static void trace_save_cmdline(struct ta
 
 	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
 
-	__raw_spin_unlock(&trace_cmdline_lock);
+	arch_spin_unlock(&trace_cmdline_lock);
 }
 
 void trace_find_cmdline(int pid, char comm[])
@@ -958,14 +958,14 @@ void trace_find_cmdline(int pid, char co
 	}
 
 	preempt_disable();
-	__raw_spin_lock(&trace_cmdline_lock);
+	arch_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
 		strcpy(comm, saved_cmdlines[map]);
 	else
 		strcpy(comm, "<...>");
 
-	__raw_spin_unlock(&trace_cmdline_lock);
+	arch_spin_unlock(&trace_cmdline_lock);
 	preempt_enable();
 }
 
@@ -1283,7 +1283,7 @@ int trace_vbprintk(unsigned long ip, con
 
 	/* Lockdep uses trace_printk for lock tracing */
 	local_irq_save(flags);
-	__raw_spin_lock(&trace_buf_lock);
+	arch_spin_lock(&trace_buf_lock);
 	len = vbin_printf(trace_buf, TRACE_BUF_SIZE, fmt, args);
 
 	if (len > TRACE_BUF_SIZE || len < 0)
@@ -1304,7 +1304,7 @@ int trace_vbprintk(unsigned long ip, con
 		ring_buffer_unlock_commit(buffer, event);
 
 out_unlock:
-	__raw_spin_unlock(&trace_buf_lock);
+	arch_spin_unlock(&trace_buf_lock);
 	local_irq_restore(flags);
 
 out:
@@ -1360,7 +1360,7 @@ int trace_array_vprintk(struct trace_arr
 
 	pause_graph_tracing();
 	raw_local_irq_save(irq_flags);
-	__raw_spin_lock(&trace_buf_lock);
+	arch_spin_lock(&trace_buf_lock);
 	if (args == NULL) {
 		strncpy(trace_buf, fmt, TRACE_BUF_SIZE);
 		len = strlen(trace_buf);
@@ -1382,7 +1382,7 @@ int trace_array_vprintk(struct trace_arr
 		ring_buffer_unlock_commit(buffer, event);
 
  out_unlock:
-	__raw_spin_unlock(&trace_buf_lock);
+	arch_spin_unlock(&trace_buf_lock);
 	raw_local_irq_restore(irq_flags);
 	unpause_graph_tracing();
  out:
@@ -2254,7 +2254,7 @@ tracing_cpumask_write(struct file *filp,
 	mutex_lock(&tracing_cpumask_update_lock);
 
 	local_irq_disable();
-	__raw_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&ftrace_max_lock);
 	for_each_tracing_cpu(cpu) {
 		/*
 		 * Increase/decrease the disabled counter if we are
@@ -2269,7 +2269,7 @@ tracing_cpumask_write(struct file *filp,
 			atomic_dec(&global_trace.data[cpu]->disabled);
 		}
 	}
-	__raw_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&ftrace_max_lock);
 	local_irq_enable();
 
 	cpumask_copy(tracing_cpumask, tracing_cpumask_new);
@@ -4279,7 +4279,7 @@ static void __ftrace_dump(bool disable_t
 
 	/* only one dump */
 	local_irq_save(flags);
-	__raw_spin_lock(&ftrace_dump_lock);
+	arch_spin_lock(&ftrace_dump_lock);
 	if (dump_ran)
 		goto out;
 
@@ -4354,7 +4354,7 @@ static void __ftrace_dump(bool disable_t
 	}
 
  out:
-	__raw_spin_unlock(&ftrace_dump_lock);
+	arch_spin_unlock(&ftrace_dump_lock);
 	local_irq_restore(flags);
 }
 
Index: linux-2.6-tip/kernel/trace/trace_clock.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_clock.c
+++ linux-2.6-tip/kernel/trace/trace_clock.c
@@ -94,7 +94,7 @@ u64 notrace trace_clock_global(void)
 	if (unlikely(in_nmi()))
 		goto out;
 
-	__raw_spin_lock(&trace_clock_struct.lock);
+	arch_spin_lock(&trace_clock_struct.lock);
 
 	/*
 	 * TODO: if this happens often then maybe we should reset
@@ -106,7 +106,7 @@ u64 notrace trace_clock_global(void)
 
 	trace_clock_struct.prev_time = now;
 
-	__raw_spin_unlock(&trace_clock_struct.lock);
+	arch_spin_unlock(&trace_clock_struct.lock);
 
  out:
 	raw_local_irq_restore(flags);
Index: linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_sched_wakeup.c
+++ linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
@@ -143,7 +143,7 @@ probe_wakeup_sched_switch(struct rq *rq,
 		goto out;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&wakeup_lock);
+	arch_spin_lock(&wakeup_lock);
 
 	/* We could race with grabbing wakeup_lock */
 	if (unlikely(!tracer_enabled || next != wakeup_task))
@@ -169,7 +169,7 @@ probe_wakeup_sched_switch(struct rq *rq,
 
 out_unlock:
 	__wakeup_reset(wakeup_trace);
-	__raw_spin_unlock(&wakeup_lock);
+	arch_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 out:
 	atomic_dec(&wakeup_trace->data[cpu]->disabled);
@@ -193,9 +193,9 @@ static void wakeup_reset(struct trace_ar
 	tracing_reset_online_cpus(tr);
 
 	local_irq_save(flags);
-	__raw_spin_lock(&wakeup_lock);
+	arch_spin_lock(&wakeup_lock);
 	__wakeup_reset(tr);
-	__raw_spin_unlock(&wakeup_lock);
+	arch_spin_unlock(&wakeup_lock);
 	local_irq_restore(flags);
 }
 
@@ -225,7 +225,7 @@ probe_wakeup(struct rq *rq, struct task_
 		goto out;
 
 	/* interrupts should be off from try_to_wake_up */
-	__raw_spin_lock(&wakeup_lock);
+	arch_spin_lock(&wakeup_lock);
 
 	/* check for races. */
 	if (!tracer_enabled || p->prio >= wakeup_prio)
@@ -255,7 +255,7 @@ probe_wakeup(struct rq *rq, struct task_
 	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
-	__raw_spin_unlock(&wakeup_lock);
+	arch_spin_unlock(&wakeup_lock);
 out:
 	atomic_dec(&wakeup_trace->data[cpu]->disabled);
 }
Index: linux-2.6-tip/kernel/trace/trace_selftest.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_selftest.c
+++ linux-2.6-tip/kernel/trace/trace_selftest.c
@@ -67,7 +67,7 @@ static int trace_test_buffer(struct trac
 
 	/* Don't allow flipping of max traces now */
 	local_irq_save(flags);
-	__raw_spin_lock(&ftrace_max_lock);
+	arch_spin_lock(&ftrace_max_lock);
 
 	cnt = ring_buffer_entries(tr->buffer);
 
@@ -85,7 +85,7 @@ static int trace_test_buffer(struct trac
 			break;
 	}
 	tracing_on();
-	__raw_spin_unlock(&ftrace_max_lock);
+	arch_spin_unlock(&ftrace_max_lock);
 	local_irq_restore(flags);
 
 	if (count)
Index: linux-2.6-tip/kernel/trace/trace_stack.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_stack.c
+++ linux-2.6-tip/kernel/trace/trace_stack.c
@@ -54,7 +54,7 @@ static inline void check_stack(void)
 		return;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&max_stack_lock);
+	arch_spin_lock(&max_stack_lock);
 
 	/* a race could have already updated it */
 	if (this_size <= max_stack_size)
@@ -103,7 +103,7 @@ static inline void check_stack(void)
 	}
 
  out:
-	__raw_spin_unlock(&max_stack_lock);
+	arch_spin_unlock(&max_stack_lock);
 	local_irq_restore(flags);
 }
 
@@ -171,9 +171,9 @@ stack_max_size_write(struct file *filp, 
 		return ret;
 
 	local_irq_save(flags);
-	__raw_spin_lock(&max_stack_lock);
+	arch_spin_lock(&max_stack_lock);
 	*ptr = val;
-	__raw_spin_unlock(&max_stack_lock);
+	arch_spin_unlock(&max_stack_lock);
 	local_irq_restore(flags);
 
 	return count;
@@ -207,7 +207,7 @@ t_next(struct seq_file *m, void *v, loff
 static void *t_start(struct seq_file *m, loff_t *pos)
 {
 	local_irq_disable();
-	__raw_spin_lock(&max_stack_lock);
+	arch_spin_lock(&max_stack_lock);
 
 	if (*pos == 0)
 		return SEQ_START_TOKEN;
@@ -217,7 +217,7 @@ static void *t_start(struct seq_file *m,
 
 static void t_stop(struct seq_file *m, void *p)
 {
-	__raw_spin_unlock(&max_stack_lock);
+	arch_spin_unlock(&max_stack_lock);
 	local_irq_enable();
 }
 
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -106,7 +106,7 @@ static void __spin_lock_debug(spinlock_t
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
-			if (__raw_spin_trylock(&lock->raw_lock))
+			if (arch_spin_trylock(&lock->raw_lock))
 				return;
 			__delay(1);
 		}
@@ -128,14 +128,14 @@ static void __spin_lock_debug(spinlock_t
 void _raw_spin_lock(spinlock_t *lock)
 {
 	debug_spin_lock_before(lock);
-	if (unlikely(!__raw_spin_trylock(&lock->raw_lock)))
+	if (unlikely(!arch_spin_trylock(&lock->raw_lock)))
 		__spin_lock_debug(lock);
 	debug_spin_lock_after(lock);
 }
 
 int _raw_spin_trylock(spinlock_t *lock)
 {
-	int ret = __raw_spin_trylock(&lock->raw_lock);
+	int ret = arch_spin_trylock(&lock->raw_lock);
 
 	if (ret)
 		debug_spin_lock_after(lock);
@@ -151,7 +151,7 @@ int _raw_spin_trylock(spinlock_t *lock)
 void _raw_spin_unlock(spinlock_t *lock)
 {
 	debug_spin_unlock(lock);
-	__raw_spin_unlock(&lock->raw_lock);
+	arch_spin_unlock(&lock->raw_lock);
 }
 
 static void rwlock_bug(rwlock_t *lock, const char *msg)


