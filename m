Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbZKMT6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbZKMT6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386AbZKMT6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:58:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:48725 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbZKMT6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:58:20 -0500
Date: Fri, 13 Nov 2009 19:57:54 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20091109151428.548614772@linutronix.de>
References: <20091109151428.548614772@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Reduce ifdefs in kernel/spinlock.c
Message-ID: <tip-8e13c7b772387f55dc05c6a0e5b30010c3c46ff9@git.kernel.org>
Git-Commit-ID: 8e13c7b772387f55dc05c6a0e5b30010c3c46ff9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e13c7b772387f55dc05c6a0e5b30010c3c46ff9
Gitweb:     http://git.kernel.org/tip/8e13c7b772387f55dc05c6a0e5b30010c3c46ff9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 9 Nov 2009 15:21:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 13 Nov 2009 20:53:28 +0100

locking: Reduce ifdefs in kernel/spinlock.c

With the Kconfig based inline decisions we can remove extra ifdefs in
kernel/spinlock.c by creating the complex lockbreak functions as
inlines which are inserted into the non inlined lock functions.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091109151428.548614772@linutronix.de>
Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/spinlock.c |  258 ++++++++++++++++++++++++++---------------------------
 1 files changed, 127 insertions(+), 131 deletions(-)

diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 235a957..41e0422 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -21,6 +21,133 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+/*
+ * The __lock_function inlines are taken from
+ * include/linux/spinlock_api_smp.h
+ */
+#else
+/*
+ * We build the __lock_function inlines here. They are too large for
+ * inlining all over the place, but here is only one user per function
+ * which embedds them into the calling _lock_function below.
+ *
+ * This could be a long-held lock. We both prepare to spin for a long
+ * time (making _this_ CPU preemptable if possible), and we also signal
+ * towards that other CPU that it should break the lock ASAP.
+ */
+#define BUILD_LOCK_OPS(op, locktype)					\
+void __lockfunc __##op##_lock(locktype##_t *lock)			\
+{									\
+	for (;;) {							\
+		preempt_disable();					\
+		if (likely(_raw_##op##_trylock(lock)))			\
+			break;						\
+		preempt_enable();					\
+									\
+		if (!(lock)->break_lock)				\
+			(lock)->break_lock = 1;				\
+		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+			_raw_##op##_relax(&lock->raw_lock);		\
+	}								\
+	(lock)->break_lock = 0;						\
+}									\
+									\
+unsigned long __lockfunc __##op##_lock_irqsave(locktype##_t *lock)	\
+{									\
+	unsigned long flags;						\
+									\
+	for (;;) {							\
+		preempt_disable();					\
+		local_irq_save(flags);					\
+		if (likely(_raw_##op##_trylock(lock)))			\
+			break;						\
+		local_irq_restore(flags);				\
+		preempt_enable();					\
+									\
+		if (!(lock)->break_lock)				\
+			(lock)->break_lock = 1;				\
+		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+			_raw_##op##_relax(&lock->raw_lock);		\
+	}								\
+	(lock)->break_lock = 0;						\
+	return flags;							\
+}									\
+									\
+void __lockfunc __##op##_lock_irq(locktype##_t *lock)			\
+{									\
+	_##op##_lock_irqsave(lock);					\
+}									\
+									\
+void __lockfunc __##op##_lock_bh(locktype##_t *lock)			\
+{									\
+	unsigned long flags;						\
+									\
+	/*							*/	\
+	/* Careful: we must exclude softirqs too, hence the	*/	\
+	/* irq-disabling. We use the generic preemption-aware	*/	\
+	/* function:						*/	\
+	/**/								\
+	flags = _##op##_lock_irqsave(lock);				\
+	local_bh_disable();						\
+	local_irq_restore(flags);					\
+}									\
+
+/*
+ * Build preemption-friendly versions of the following
+ * lock-spinning functions:
+ *
+ *         __[spin|read|write]_lock()
+ *         __[spin|read|write]_lock_irq()
+ *         __[spin|read|write]_lock_irqsave()
+ *         __[spin|read|write]_lock_bh()
+ */
+BUILD_LOCK_OPS(spin, spinlock);
+BUILD_LOCK_OPS(read, rwlock);
+BUILD_LOCK_OPS(write, rwlock);
+
+#endif
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
+{
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+EXPORT_SYMBOL(_spin_lock_nested);
+
+unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock,
+						   int subclass)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_spin_trylock, _raw_spin_lock,
+				_raw_spin_lock_flags, &flags);
+	return flags;
+}
+EXPORT_SYMBOL(_spin_lock_irqsave_nested);
+
+void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
+				     struct lockdep_map *nest_lock)
+{
+	preempt_disable();
+	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+EXPORT_SYMBOL(_spin_lock_nest_lock);
+
+#endif
+
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
@@ -45,13 +172,6 @@ int __lockfunc _write_trylock(rwlock_t *lock)
 EXPORT_SYMBOL(_write_trylock);
 #endif
 
-/*
- * If lockdep is enabled then we use the non-preemption spin-ops
- * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
- * not re-enabled during lock-acquire (which the preempt-spin-ops do):
- */
-#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
-
 #ifndef CONFIG_INLINE_READ_LOCK
 void __lockfunc _read_lock(rwlock_t *lock)
 {
@@ -148,130 +268,6 @@ void __lockfunc _write_lock(rwlock_t *lock)
 EXPORT_SYMBOL(_write_lock);
 #endif
 
-#else /* CONFIG_PREEMPT: */
-
-/*
- * This could be a long-held lock. We both prepare to spin for a long
- * time (making _this_ CPU preemptable if possible), and we also signal
- * towards that other CPU that it should break the lock ASAP.
- *
- * (We do this in a function because inlining it would be excessive.)
- */
-
-#define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc _##op##_lock(locktype##_t *lock)			\
-{									\
-	for (;;) {							\
-		preempt_disable();					\
-		if (likely(_raw_##op##_trylock(lock)))			\
-			break;						\
-		preempt_enable();					\
-									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
-			_raw_##op##_relax(&lock->raw_lock);		\
-	}								\
-	(lock)->break_lock = 0;						\
-}									\
-									\
-EXPORT_SYMBOL(_##op##_lock);						\
-									\
-unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
-{									\
-	unsigned long flags;						\
-									\
-	for (;;) {							\
-		preempt_disable();					\
-		local_irq_save(flags);					\
-		if (likely(_raw_##op##_trylock(lock)))			\
-			break;						\
-		local_irq_restore(flags);				\
-		preempt_enable();					\
-									\
-		if (!(lock)->break_lock)				\
-			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
-			_raw_##op##_relax(&lock->raw_lock);		\
-	}								\
-	(lock)->break_lock = 0;						\
-	return flags;							\
-}									\
-									\
-EXPORT_SYMBOL(_##op##_lock_irqsave);					\
-									\
-void __lockfunc _##op##_lock_irq(locktype##_t *lock)			\
-{									\
-	_##op##_lock_irqsave(lock);					\
-}									\
-									\
-EXPORT_SYMBOL(_##op##_lock_irq);					\
-									\
-void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
-{									\
-	unsigned long flags;						\
-									\
-	/*							*/	\
-	/* Careful: we must exclude softirqs too, hence the	*/	\
-	/* irq-disabling. We use the generic preemption-aware	*/	\
-	/* function:						*/	\
-	/**/								\
-	flags = _##op##_lock_irqsave(lock);				\
-	local_bh_disable();						\
-	local_irq_restore(flags);					\
-}									\
-									\
-EXPORT_SYMBOL(_##op##_lock_bh)
-
-/*
- * Build preemption-friendly versions of the following
- * lock-spinning functions:
- *
- *         _[spin|read|write]_lock()
- *         _[spin|read|write]_lock_irq()
- *         _[spin|read|write]_lock_irqsave()
- *         _[spin|read|write]_lock_bh()
- */
-BUILD_LOCK_OPS(spin, spinlock);
-BUILD_LOCK_OPS(read, rwlock);
-BUILD_LOCK_OPS(write, rwlock);
-
-#endif /* CONFIG_PREEMPT */
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-
-void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
-{
-	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-}
-EXPORT_SYMBOL(_spin_lock_nested);
-
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_spin_trylock, _raw_spin_lock,
-				_raw_spin_lock_flags, &flags);
-	return flags;
-}
-EXPORT_SYMBOL(_spin_lock_irqsave_nested);
-
-void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
-				     struct lockdep_map *nest_lock)
-{
-	preempt_disable();
-	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-}
-EXPORT_SYMBOL(_spin_lock_nest_lock);
-
-#endif
-
 #ifndef CONFIG_INLINE_SPIN_UNLOCK
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
