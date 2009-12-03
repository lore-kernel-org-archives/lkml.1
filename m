Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZLCS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZLCS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbZLCS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:27:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55758 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbZLCS1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:27:18 -0500
Date: Thu, 3 Dec 2009 19:27:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v2.6.33
Message-ID: <20091203182708.GA19236@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (2):
      mutex: Better control mutex adaptive spinning config
      mutex: Fix missing conditions to build mutex_spin_on_owner()

Hiroshi Shimamoto (1):
      locking, task_struct: Reduce size on TRACE_IRQFLAGS and 64bit

Thomas Gleixner (4):
      locking: Make inlining decision Kconfig based
      locking: Reduce ifdefs in kernel/spinlock.c
      locking: Remove unused prototype
      locking: Use __[SPIN|RW]_LOCK_UNLOCKED in [spin|rw]_lock_init()


 arch/s390/Kconfig                |   28 ++++
 arch/s390/include/asm/spinlock.h |   29 ----
 include/linux/sched.h            |   10 +-
 include/linux/spinlock.h         |    6 +-
 include/linux/spinlock_api_smp.h |   75 ++++------
 init/Kconfig                     |    1 +
 kernel/Kconfig.locks             |  202 +++++++++++++++++++++++++
 kernel/mutex.c                   |    4 +-
 kernel/sched.c                   |    2 +-
 kernel/spinlock.c                |  310 +++++++++++++++++++-------------------
 10 files changed, 422 insertions(+), 245 deletions(-)
 create mode 100644 kernel/Kconfig.locks

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 43c0aca..16c6730 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -95,6 +95,34 @@ config S390
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
 	select HAVE_PERF_EVENTS
+	select ARCH_INLINE_SPIN_TRYLOCK
+	select ARCH_INLINE_SPIN_TRYLOCK_BH
+	select ARCH_INLINE_SPIN_LOCK
+	select ARCH_INLINE_SPIN_LOCK_BH
+	select ARCH_INLINE_SPIN_LOCK_IRQ
+	select ARCH_INLINE_SPIN_LOCK_IRQSAVE
+	select ARCH_INLINE_SPIN_UNLOCK
+	select ARCH_INLINE_SPIN_UNLOCK_BH
+	select ARCH_INLINE_SPIN_UNLOCK_IRQ
+	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	select ARCH_INLINE_READ_TRYLOCK
+	select ARCH_INLINE_READ_LOCK
+	select ARCH_INLINE_READ_LOCK_BH
+	select ARCH_INLINE_READ_LOCK_IRQ
+	select ARCH_INLINE_READ_LOCK_IRQSAVE
+	select ARCH_INLINE_READ_UNLOCK
+	select ARCH_INLINE_READ_UNLOCK_BH
+	select ARCH_INLINE_READ_UNLOCK_IRQ
+	select ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	select ARCH_INLINE_WRITE_TRYLOCK
+	select ARCH_INLINE_WRITE_LOCK
+	select ARCH_INLINE_WRITE_LOCK_BH
+	select ARCH_INLINE_WRITE_LOCK_IRQ
+	select ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	select ARCH_INLINE_WRITE_UNLOCK
+	select ARCH_INLINE_WRITE_UNLOCK_BH
+	select ARCH_INLINE_WRITE_UNLOCK_IRQ
+	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 
 config SCHED_OMIT_FRAME_POINTER
 	bool
diff --git a/arch/s390/include/asm/spinlock.h b/arch/s390/include/asm/spinlock.h
index 41ce686..c9af0d1 100644
--- a/arch/s390/include/asm/spinlock.h
+++ b/arch/s390/include/asm/spinlock.h
@@ -191,33 +191,4 @@ static inline int __raw_write_trylock(raw_rwlock_t *rw)
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
-#define __always_inline__spin_lock
-#define __always_inline__read_lock
-#define __always_inline__write_lock
-#define __always_inline__spin_lock_bh
-#define __always_inline__read_lock_bh
-#define __always_inline__write_lock_bh
-#define __always_inline__spin_lock_irq
-#define __always_inline__read_lock_irq
-#define __always_inline__write_lock_irq
-#define __always_inline__spin_lock_irqsave
-#define __always_inline__read_lock_irqsave
-#define __always_inline__write_lock_irqsave
-#define __always_inline__spin_trylock
-#define __always_inline__read_trylock
-#define __always_inline__write_trylock
-#define __always_inline__spin_trylock_bh
-#define __always_inline__spin_unlock
-#define __always_inline__read_unlock
-#define __always_inline__write_unlock
-#define __always_inline__spin_unlock_bh
-#define __always_inline__read_unlock_bh
-#define __always_inline__write_unlock_bh
-#define __always_inline__spin_unlock_irq
-#define __always_inline__read_unlock_irq
-#define __always_inline__write_unlock_irq
-#define __always_inline__spin_unlock_irqrestore
-#define __always_inline__read_unlock_irqrestore
-#define __always_inline__write_unlock_irqrestore
-
 #endif /* __ASM_SPINLOCK_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..49be8f7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1421,17 +1421,17 @@ struct task_struct {
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	unsigned int irq_events;
-	int hardirqs_enabled;
 	unsigned long hardirq_enable_ip;
-	unsigned int hardirq_enable_event;
 	unsigned long hardirq_disable_ip;
+	unsigned int hardirq_enable_event;
 	unsigned int hardirq_disable_event;
-	int softirqs_enabled;
+	int hardirqs_enabled;
+	int hardirq_context;
 	unsigned long softirq_disable_ip;
-	unsigned int softirq_disable_event;
 	unsigned long softirq_enable_ip;
+	unsigned int softirq_disable_event;
 	unsigned int softirq_enable_event;
-	int hardirq_context;
+	int softirqs_enabled;
 	int softirq_context;
 #endif
 #ifdef CONFIG_LOCKDEP
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index f0ca7a7..71dccfe 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -79,8 +79,6 @@
  */
 #include <linux/spinlock_types.h>
 
-extern int __lockfunc generic__raw_read_trylock(raw_rwlock_t *lock);
-
 /*
  * Pull the __raw*() functions/declarations (UP-nondebug doesnt need them):
  */
@@ -102,7 +100,7 @@ do {								\
 
 #else
 # define spin_lock_init(lock)					\
-	do { *(lock) = SPIN_LOCK_UNLOCKED; } while (0)
+	do { *(lock) = __SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -116,7 +114,7 @@ do {								\
 } while (0)
 #else
 # define rwlock_init(lock)					\
-	do { *(lock) = RW_LOCK_UNLOCKED; } while (0)
+	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
 #define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 7a7e18f..8264a7f 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -60,137 +60,118 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
-/*
- * We inline the unlock functions in the nondebug case:
- */
-#if !defined(CONFIG_DEBUG_SPINLOCK) && !defined(CONFIG_PREEMPT)
-#define __always_inline__spin_unlock
-#define __always_inline__read_unlock
-#define __always_inline__write_unlock
-#define __always_inline__spin_unlock_irq
-#define __always_inline__read_unlock_irq
-#define __always_inline__write_unlock_irq
-#endif
-
-#ifndef CONFIG_DEBUG_SPINLOCK
-#ifndef CONFIG_GENERIC_LOCKBREAK
-
-#ifdef __always_inline__spin_lock
+#ifdef CONFIG_INLINE_SPIN_LOCK
 #define _spin_lock(lock) __spin_lock(lock)
 #endif
 
-#ifdef __always_inline__read_lock
+#ifdef CONFIG_INLINE_READ_LOCK
 #define _read_lock(lock) __read_lock(lock)
 #endif
 
-#ifdef __always_inline__write_lock
+#ifdef CONFIG_INLINE_WRITE_LOCK
 #define _write_lock(lock) __write_lock(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_bh
+#ifdef CONFIG_INLINE_SPIN_LOCK_BH
 #define _spin_lock_bh(lock) __spin_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__read_lock_bh
+#ifdef CONFIG_INLINE_READ_LOCK_BH
 #define _read_lock_bh(lock) __read_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__write_lock_bh
+#ifdef CONFIG_INLINE_WRITE_LOCK_BH
 #define _write_lock_bh(lock) __write_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_irq
+#ifdef CONFIG_INLINE_SPIN_LOCK_IRQ
 #define _spin_lock_irq(lock) __spin_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__read_lock_irq
+#ifdef CONFIG_INLINE_READ_LOCK_IRQ
 #define _read_lock_irq(lock) __read_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__write_lock_irq
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
 #define _write_lock_irq(lock) __write_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_irqsave
+#ifdef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
 #define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
 #endif
 
-#ifdef __always_inline__read_lock_irqsave
+#ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
 #define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
 #endif
 
-#ifdef __always_inline__write_lock_irqsave
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
 #define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
 #endif
 
-#endif /* !CONFIG_GENERIC_LOCKBREAK */
-
-#ifdef __always_inline__spin_trylock
+#ifdef CONFIG_INLINE_SPIN_TRYLOCK
 #define _spin_trylock(lock) __spin_trylock(lock)
 #endif
 
-#ifdef __always_inline__read_trylock
+#ifdef CONFIG_INLINE_READ_TRYLOCK
 #define _read_trylock(lock) __read_trylock(lock)
 #endif
 
-#ifdef __always_inline__write_trylock
+#ifdef CONFIG_INLINE_WRITE_TRYLOCK
 #define _write_trylock(lock) __write_trylock(lock)
 #endif
 
-#ifdef __always_inline__spin_trylock_bh
+#ifdef CONFIG_INLINE_SPIN_TRYLOCK_BH
 #define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock
+#ifdef CONFIG_INLINE_SPIN_UNLOCK
 #define _spin_unlock(lock) __spin_unlock(lock)
 #endif
 
-#ifdef __always_inline__read_unlock
+#ifdef CONFIG_INLINE_READ_UNLOCK
 #define _read_unlock(lock) __read_unlock(lock)
 #endif
 
-#ifdef __always_inline__write_unlock
+#ifdef CONFIG_INLINE_WRITE_UNLOCK
 #define _write_unlock(lock) __write_unlock(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_bh
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
 #define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__read_unlock_bh
+#ifdef CONFIG_INLINE_READ_UNLOCK_BH
 #define _read_unlock_bh(lock) __read_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__write_unlock_bh
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
 #define _write_unlock_bh(lock) __write_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_irq
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 #define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__read_unlock_irq
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
 #define _read_unlock_irq(lock) __read_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__write_unlock_irq
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
 #define _write_unlock_irq(lock) __write_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_irqrestore
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 #define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
 #endif
 
-#ifdef __always_inline__read_unlock_irqrestore
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
 #define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
 #endif
 
-#ifdef __always_inline__write_unlock_irqrestore
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
 #define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
 #endif
 
-#endif /* CONFIG_DEBUG_SPINLOCK */
-
 static inline int __spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
diff --git a/init/Kconfig b/init/Kconfig
index 9e03ef8..06863dd 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1210,3 +1210,4 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+source "kernel/Kconfig.locks"
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
new file mode 100644
index 0000000..88c92fb
--- /dev/null
+++ b/kernel/Kconfig.locks
@@ -0,0 +1,202 @@
+#
+# The ARCH_INLINE foo is necessary because select ignores "depends on"
+#
+config ARCH_INLINE_SPIN_TRYLOCK
+	bool
+
+config ARCH_INLINE_SPIN_TRYLOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_LOCK
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	bool
+
+
+config ARCH_INLINE_READ_TRYLOCK
+	bool
+
+config ARCH_INLINE_READ_LOCK
+	bool
+
+config ARCH_INLINE_READ_LOCK_BH
+	bool
+
+config ARCH_INLINE_READ_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_READ_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_READ_UNLOCK
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	bool
+
+
+config ARCH_INLINE_WRITE_TRYLOCK
+	bool
+
+config ARCH_INLINE_WRITE_LOCK
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_BH
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	bool
+
+#
+# lock_* functions are inlined when:
+#   - DEBUG_SPINLOCK=n and GENERIC_LOCKBREAK=n and ARCH_INLINE_*LOCK=y
+#
+# trylock_* functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#
+# unlock and unlock_irq functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#  or
+#   - DEBUG_SPINLOCK=n and PREEMPT=n
+#
+# unlock_bh and unlock_irqrestore functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#
+
+config INLINE_SPIN_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK
+
+config INLINE_SPIN_TRYLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK_BH
+
+config INLINE_SPIN_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
+
+config INLINE_SPIN_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_SPIN_LOCK_BH
+
+config INLINE_SPIN_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_SPIN_LOCK_IRQ
+
+config INLINE_SPIN_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
+
+config INLINE_SPIN_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
+
+config INLINE_SPIN_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
+
+config INLINE_SPIN_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH)
+
+config INLINE_SPIN_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+
+
+config INLINE_READ_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_TRYLOCK
+
+config INLINE_READ_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
+
+config INLINE_READ_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_READ_LOCK_BH
+
+config INLINE_READ_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_READ_LOCK_IRQ
+
+config INLINE_READ_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_READ_LOCK_IRQSAVE
+
+config INLINE_READ_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK)
+
+config INLINE_READ_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_BH
+
+config INLINE_READ_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK_BH)
+
+config INLINE_READ_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+
+
+config INLINE_WRITE_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_TRYLOCK
+
+config INLINE_WRITE_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
+
+config INLINE_WRITE_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_WRITE_LOCK_BH
+
+config INLINE_WRITE_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_WRITE_LOCK_IRQ
+
+config INLINE_WRITE_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+		 ARCH_INLINE_WRITE_LOCK_IRQSAVE
+
+config INLINE_WRITE_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK)
+
+config INLINE_WRITE_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_BH
+
+config INLINE_WRITE_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH)
+
+config INLINE_WRITE_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+
+config MUTEX_SPIN_ON_OWNER
+	def_bool SMP && !DEBUG_MUTEXES && !HAVE_DEFAULT_NO_SPIN_MUTEXES
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 947b3ad..632f04c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -148,8 +148,8 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES) && \
-    !defined(CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES)
+
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 	/*
 	 * Optimistic spinning.
 	 *
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..ec0af1f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5481,7 +5481,7 @@ need_resched_nonpreemptible:
 }
 EXPORT_SYMBOL(schedule);
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_MUTEX_SPIN_ON_OWNER
 /*
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 5ddab73..41e0422 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -21,145 +21,28 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
-#ifndef _spin_trylock
-int __lockfunc _spin_trylock(spinlock_t *lock)
-{
-	return __spin_trylock(lock);
-}
-EXPORT_SYMBOL(_spin_trylock);
-#endif
-
-#ifndef _read_trylock
-int __lockfunc _read_trylock(rwlock_t *lock)
-{
-	return __read_trylock(lock);
-}
-EXPORT_SYMBOL(_read_trylock);
-#endif
-
-#ifndef _write_trylock
-int __lockfunc _write_trylock(rwlock_t *lock)
-{
-	return __write_trylock(lock);
-}
-EXPORT_SYMBOL(_write_trylock);
-#endif
-
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
  * not re-enabled during lock-acquire (which the preempt-spin-ops do):
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
-
-#ifndef _read_lock
-void __lockfunc _read_lock(rwlock_t *lock)
-{
-	__read_lock(lock);
-}
-EXPORT_SYMBOL(_read_lock);
-#endif
-
-#ifndef _spin_lock_irqsave
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
-{
-	return __spin_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_spin_lock_irqsave);
-#endif
-
-#ifndef _spin_lock_irq
-void __lockfunc _spin_lock_irq(spinlock_t *lock)
-{
-	__spin_lock_irq(lock);
-}
-EXPORT_SYMBOL(_spin_lock_irq);
-#endif
-
-#ifndef _spin_lock_bh
-void __lockfunc _spin_lock_bh(spinlock_t *lock)
-{
-	__spin_lock_bh(lock);
-}
-EXPORT_SYMBOL(_spin_lock_bh);
-#endif
-
-#ifndef _read_lock_irqsave
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
-{
-	return __read_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_read_lock_irqsave);
-#endif
-
-#ifndef _read_lock_irq
-void __lockfunc _read_lock_irq(rwlock_t *lock)
-{
-	__read_lock_irq(lock);
-}
-EXPORT_SYMBOL(_read_lock_irq);
-#endif
-
-#ifndef _read_lock_bh
-void __lockfunc _read_lock_bh(rwlock_t *lock)
-{
-	__read_lock_bh(lock);
-}
-EXPORT_SYMBOL(_read_lock_bh);
-#endif
-
-#ifndef _write_lock_irqsave
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
-{
-	return __write_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_write_lock_irqsave);
-#endif
-
-#ifndef _write_lock_irq
-void __lockfunc _write_lock_irq(rwlock_t *lock)
-{
-	__write_lock_irq(lock);
-}
-EXPORT_SYMBOL(_write_lock_irq);
-#endif
-
-#ifndef _write_lock_bh
-void __lockfunc _write_lock_bh(rwlock_t *lock)
-{
-	__write_lock_bh(lock);
-}
-EXPORT_SYMBOL(_write_lock_bh);
-#endif
-
-#ifndef _spin_lock
-void __lockfunc _spin_lock(spinlock_t *lock)
-{
-	__spin_lock(lock);
-}
-EXPORT_SYMBOL(_spin_lock);
-#endif
-
-#ifndef _write_lock
-void __lockfunc _write_lock(rwlock_t *lock)
-{
-	__write_lock(lock);
-}
-EXPORT_SYMBOL(_write_lock);
-#endif
-
-#else /* CONFIG_PREEMPT: */
-
 /*
+ * The __lock_function inlines are taken from
+ * include/linux/spinlock_api_smp.h
+ */
+#else
+/*
+ * We build the __lock_function inlines here. They are too large for
+ * inlining all over the place, but here is only one user per function
+ * which embedds them into the calling _lock_function below.
+ *
  * This could be a long-held lock. We both prepare to spin for a long
  * time (making _this_ CPU preemptable if possible), and we also signal
  * towards that other CPU that it should break the lock ASAP.
- *
- * (We do this in a function because inlining it would be excessive.)
  */
-
 #define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc _##op##_lock(locktype##_t *lock)			\
+void __lockfunc __##op##_lock(locktype##_t *lock)			\
 {									\
 	for (;;) {							\
 		preempt_disable();					\
@@ -175,9 +58,7 @@ void __lockfunc _##op##_lock(locktype##_t *lock)			\
 	(lock)->break_lock = 0;						\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock);						\
-									\
-unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
+unsigned long __lockfunc __##op##_lock_irqsave(locktype##_t *lock)	\
 {									\
 	unsigned long flags;						\
 									\
@@ -198,16 +79,12 @@ unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
 	return flags;							\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock_irqsave);					\
-									\
-void __lockfunc _##op##_lock_irq(locktype##_t *lock)			\
+void __lockfunc __##op##_lock_irq(locktype##_t *lock)			\
 {									\
 	_##op##_lock_irqsave(lock);					\
 }									\
 									\
-EXPORT_SYMBOL(_##op##_lock_irq);					\
-									\
-void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
+void __lockfunc __##op##_lock_bh(locktype##_t *lock)			\
 {									\
 	unsigned long flags;						\
 									\
@@ -220,23 +97,21 @@ void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
 	local_bh_disable();						\
 	local_irq_restore(flags);					\
 }									\
-									\
-EXPORT_SYMBOL(_##op##_lock_bh)
 
 /*
  * Build preemption-friendly versions of the following
  * lock-spinning functions:
  *
- *         _[spin|read|write]_lock()
- *         _[spin|read|write]_lock_irq()
- *         _[spin|read|write]_lock_irqsave()
- *         _[spin|read|write]_lock_bh()
+ *         __[spin|read|write]_lock()
+ *         __[spin|read|write]_lock_irq()
+ *         __[spin|read|write]_lock_irqsave()
+ *         __[spin|read|write]_lock_bh()
  */
 BUILD_LOCK_OPS(spin, spinlock);
 BUILD_LOCK_OPS(read, rwlock);
 BUILD_LOCK_OPS(write, rwlock);
 
-#endif /* CONFIG_PREEMPT */
+#endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -248,7 +123,8 @@ void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 }
 EXPORT_SYMBOL(_spin_lock_nested);
 
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
+unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock,
+						   int subclass)
 {
 	unsigned long flags;
 
@@ -272,7 +148,127 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
-#ifndef _spin_unlock
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK
+int __lockfunc _spin_trylock(spinlock_t *lock)
+{
+	return __spin_trylock(lock);
+}
+EXPORT_SYMBOL(_spin_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_READ_TRYLOCK
+int __lockfunc _read_trylock(rwlock_t *lock)
+{
+	return __read_trylock(lock);
+}
+EXPORT_SYMBOL(_read_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_TRYLOCK
+int __lockfunc _write_trylock(rwlock_t *lock)
+{
+	return __write_trylock(lock);
+}
+EXPORT_SYMBOL(_write_trylock);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK
+void __lockfunc _read_lock(rwlock_t *lock)
+{
+	__read_lock(lock);
+}
+EXPORT_SYMBOL(_read_lock);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
+unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+{
+	return __spin_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_spin_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
+void __lockfunc _spin_lock_irq(spinlock_t *lock)
+{
+	__spin_lock_irq(lock);
+}
+EXPORT_SYMBOL(_spin_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK_BH
+void __lockfunc _spin_lock_bh(spinlock_t *lock)
+{
+	__spin_lock_bh(lock);
+}
+EXPORT_SYMBOL(_spin_lock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
+unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+{
+	return __read_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_read_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_IRQ
+void __lockfunc _read_lock_irq(rwlock_t *lock)
+{
+	__read_lock_irq(lock);
+}
+EXPORT_SYMBOL(_read_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_READ_LOCK_BH
+void __lockfunc _read_lock_bh(rwlock_t *lock)
+{
+	__read_lock_bh(lock);
+}
+EXPORT_SYMBOL(_read_lock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
+unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+{
+	return __write_lock_irqsave(lock);
+}
+EXPORT_SYMBOL(_write_lock_irqsave);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
+void __lockfunc _write_lock_irq(rwlock_t *lock)
+{
+	__write_lock_irq(lock);
+}
+EXPORT_SYMBOL(_write_lock_irq);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK_BH
+void __lockfunc _write_lock_bh(rwlock_t *lock)
+{
+	__write_lock_bh(lock);
+}
+EXPORT_SYMBOL(_write_lock_bh);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_LOCK
+void __lockfunc _spin_lock(spinlock_t *lock)
+{
+	__spin_lock(lock);
+}
+EXPORT_SYMBOL(_spin_lock);
+#endif
+
+#ifndef CONFIG_INLINE_WRITE_LOCK
+void __lockfunc _write_lock(rwlock_t *lock)
+{
+	__write_lock(lock);
+}
+EXPORT_SYMBOL(_write_lock);
+#endif
+
+#ifndef CONFIG_INLINE_SPIN_UNLOCK
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
 	__spin_unlock(lock);
@@ -280,7 +276,7 @@ void __lockfunc _spin_unlock(spinlock_t *lock)
 EXPORT_SYMBOL(_spin_unlock);
 #endif
 
-#ifndef _write_unlock
+#ifndef CONFIG_INLINE_WRITE_UNLOCK
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
 	__write_unlock(lock);
@@ -288,7 +284,7 @@ void __lockfunc _write_unlock(rwlock_t *lock)
 EXPORT_SYMBOL(_write_unlock);
 #endif
 
-#ifndef _read_unlock
+#ifndef CONFIG_INLINE_READ_UNLOCK
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
 	__read_unlock(lock);
@@ -296,7 +292,7 @@ void __lockfunc _read_unlock(rwlock_t *lock)
 EXPORT_SYMBOL(_read_unlock);
 #endif
 
-#ifndef _spin_unlock_irqrestore
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	__spin_unlock_irqrestore(lock, flags);
@@ -304,7 +300,7 @@ void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
 #endif
 
-#ifndef _spin_unlock_irq
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
 	__spin_unlock_irq(lock);
@@ -312,7 +308,7 @@ void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 EXPORT_SYMBOL(_spin_unlock_irq);
 #endif
 
-#ifndef _spin_unlock_bh
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
 	__spin_unlock_bh(lock);
@@ -320,7 +316,7 @@ void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 EXPORT_SYMBOL(_spin_unlock_bh);
 #endif
 
-#ifndef _read_unlock_irqrestore
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__read_unlock_irqrestore(lock, flags);
@@ -328,7 +324,7 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 EXPORT_SYMBOL(_read_unlock_irqrestore);
 #endif
 
-#ifndef _read_unlock_irq
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
 	__read_unlock_irq(lock);
@@ -336,7 +332,7 @@ void __lockfunc _read_unlock_irq(rwlock_t *lock)
 EXPORT_SYMBOL(_read_unlock_irq);
 #endif
 
-#ifndef _read_unlock_bh
+#ifndef CONFIG_INLINE_READ_UNLOCK_BH
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
 	__read_unlock_bh(lock);
@@ -344,7 +340,7 @@ void __lockfunc _read_unlock_bh(rwlock_t *lock)
 EXPORT_SYMBOL(_read_unlock_bh);
 #endif
 
-#ifndef _write_unlock_irqrestore
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__write_unlock_irqrestore(lock, flags);
@@ -352,7 +348,7 @@ void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 EXPORT_SYMBOL(_write_unlock_irqrestore);
 #endif
 
-#ifndef _write_unlock_irq
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
 	__write_unlock_irq(lock);
@@ -360,7 +356,7 @@ void __lockfunc _write_unlock_irq(rwlock_t *lock)
 EXPORT_SYMBOL(_write_unlock_irq);
 #endif
 
-#ifndef _write_unlock_bh
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
 	__write_unlock_bh(lock);
@@ -368,7 +364,7 @@ void __lockfunc _write_unlock_bh(rwlock_t *lock)
 EXPORT_SYMBOL(_write_unlock_bh);
 #endif
 
-#ifndef _spin_trylock_bh
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
 	return __spin_trylock_bh(lock);
