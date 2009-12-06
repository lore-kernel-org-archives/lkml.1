Return-Path: <linux-kernel-owner+w=401wt.eu-S934111AbZLFSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbZLFSCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934028AbZLFSCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:02:31 -0500
Received: from www.tglx.de ([62.245.132.106]:33047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934090AbZLFSCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:25 -0500
Message-Id: <20091206111957.418057255@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 03/23] locking: Separate rwlock api from spinlock api
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-split-rwlock-api-from-spinlock-api.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the rwlock smp api defines and functions into a separate header
file. Makes the -rt selection simpler and less intrusive.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwlock_api_smp.h   |  277 +++++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_api_smp.h |  252 -----------------------------------
 2 files changed, 280 insertions(+), 249 deletions(-)

Index: linux-2.6-tip/include/linux/rwlock_api_smp.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/include/linux/rwlock_api_smp.h
@@ -0,0 +1,277 @@
+#ifndef __LINUX_RWLOCK_API_SMP_H
+#define __LINUX_RWLOCK_API_SMP_H
+
+#ifndef __LINUX_SPINLOCK_API_SMP_H
+# error "please don't include this file directly"
+#endif
+
+/*
+ * include/linux/rwlock_api_smp.h
+ *
+ * spinlock API declarations on SMP (and debug)
+ * (implemented in kernel/spinlock.c)
+ *
+ * portions Copyright 2005, Red Hat, Inc., Ingo Molnar
+ * Released under the General Public License (GPL).
+ */
+
+void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _read_lock_bh(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _write_lock_bh(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _read_lock_irq(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _write_lock_irq(rwlock_t *lock)		__acquires(lock);
+unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+							__acquires(lock);
+unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+							__acquires(lock);
+int __lockfunc _read_trylock(rwlock_t *lock);
+int __lockfunc _write_trylock(rwlock_t *lock);
+void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
+void __lockfunc _write_unlock(rwlock_t *lock)		__releases(lock);
+void __lockfunc _read_unlock_bh(rwlock_t *lock)		__releases(lock);
+void __lockfunc _write_unlock_bh(rwlock_t *lock)	__releases(lock);
+void __lockfunc _read_unlock_irq(rwlock_t *lock)	__releases(lock);
+void __lockfunc _write_unlock_irq(rwlock_t *lock)	__releases(lock);
+void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+							__releases(lock);
+void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+							__releases(lock);
+
+#ifdef CONFIG_INLINE_READ_LOCK
+#define _read_lock(lock) __read_lock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_LOCK
+#define _write_lock(lock) __write_lock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_LOCK_BH
+#define _read_lock_bh(lock) __read_lock_bh(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_LOCK_BH
+#define _write_lock_bh(lock) __write_lock_bh(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_LOCK_IRQ
+#define _read_lock_irq(lock) __read_lock_irq(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
+#define _write_lock_irq(lock) __write_lock_irq(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
+#define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
+#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_TRYLOCK
+#define _read_trylock(lock) __read_trylock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_TRYLOCK
+#define _write_trylock(lock) __write_trylock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_UNLOCK
+#define _read_unlock(lock) __read_unlock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_UNLOCK
+#define _write_unlock(lock) __write_unlock(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_UNLOCK_BH
+#define _read_unlock_bh(lock) __read_unlock_bh(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
+#define _write_unlock_bh(lock) __write_unlock_bh(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
+#define _read_unlock_irq(lock) __read_unlock_irq(lock)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
+#define _write_unlock_irq(lock) __write_unlock_irq(lock)
+#endif
+
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
+#define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
+#endif
+
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
+#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
+#endif
+
+static inline int __read_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_read_trylock(lock)) {
+		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __write_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_write_trylock(lock)) {
+		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+
+static inline void __read_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
+			     _raw_read_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __read_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline void __read_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
+			     _raw_write_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __write_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __write_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __write_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+#endif /* CONFIG_PREEMPT */
+
+static inline void __write_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __read_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __read_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __read_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __write_unlock_irqrestore(rwlock_t *lock,
+					     unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __write_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __write_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+#endif /* __LINUX_RWLOCK_API_SMP_H */
Index: linux-2.6-tip/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6-tip/include/linux/spinlock_api_smp.h
@@ -24,102 +24,41 @@ void __lockfunc _spin_lock_nested(spinlo
 							__acquires(lock);
 void __lockfunc _spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *map)
 							__acquires(lock);
-void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_bh(spinlock_t *lock)		__acquires(lock);
-void __lockfunc _read_lock_bh(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock_bh(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_irq(spinlock_t *lock)	__acquires(lock);
-void __lockfunc _read_lock_irq(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock_irq(rwlock_t *lock)		__acquires(lock);
+
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 							__acquires(lock);
 unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
-							__acquires(lock);
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
-							__acquires(lock);
 int __lockfunc _spin_trylock(spinlock_t *lock);
-int __lockfunc _read_trylock(rwlock_t *lock);
-int __lockfunc _write_trylock(rwlock_t *lock);
 int __lockfunc _spin_trylock_bh(spinlock_t *lock);
 void __lockfunc _spin_unlock(spinlock_t *lock)		__releases(lock);
-void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
-void __lockfunc _write_unlock(rwlock_t *lock)		__releases(lock);
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)	__releases(lock);
-void __lockfunc _read_unlock_bh(rwlock_t *lock)		__releases(lock);
-void __lockfunc _write_unlock_bh(rwlock_t *lock)	__releases(lock);
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)	__releases(lock);
-void __lockfunc _read_unlock_irq(rwlock_t *lock)	__releases(lock);
-void __lockfunc _write_unlock_irq(rwlock_t *lock)	__releases(lock);
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 							__releases(lock);
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-							__releases(lock);
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-							__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
 #define _spin_lock(lock) __spin_lock(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_LOCK
-#define _read_lock(lock) __read_lock(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_LOCK
-#define _write_lock(lock) __write_lock(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_LOCK_BH
 #define _spin_lock_bh(lock) __spin_lock_bh(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_LOCK_BH
-#define _read_lock_bh(lock) __read_lock_bh(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_LOCK_BH
-#define _write_lock_bh(lock) __write_lock_bh(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQ
 #define _spin_lock_irq(lock) __spin_lock_irq(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_LOCK_IRQ
-#define _read_lock_irq(lock) __read_lock_irq(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
-#define _write_lock_irq(lock) __write_lock_irq(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
 #define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
-#define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_TRYLOCK
 #define _spin_trylock(lock) __spin_trylock(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_TRYLOCK
-#define _read_trylock(lock) __read_trylock(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_TRYLOCK
-#define _write_trylock(lock) __write_trylock(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_TRYLOCK_BH
 #define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
 #endif
@@ -128,50 +67,18 @@ void __lockfunc _write_unlock_irqrestore
 #define _spin_unlock(lock) __spin_unlock(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_UNLOCK
-#define _read_unlock(lock) __read_unlock(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_UNLOCK
-#define _write_unlock(lock) __write_unlock(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
 #define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_UNLOCK_BH
-#define _read_unlock_bh(lock) __read_unlock_bh(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
-#define _write_unlock_bh(lock) __write_unlock_bh(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 #define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
 #endif
 
-#ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
-#define _read_unlock_irq(lock) __read_unlock_irq(lock)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-#define _write_unlock_irq(lock) __write_unlock_irq(lock)
-#endif
-
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 #define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
 #endif
 
-#ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-#define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
-#endif
-
-#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
-#endif
-
 static inline int __spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
@@ -183,28 +90,6 @@ static inline int __spin_trylock(spinloc
 	return 0;
 }
 
-static inline int __read_trylock(rwlock_t *lock)
-{
-	preempt_disable();
-	if (_raw_read_trylock(lock)) {
-		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	preempt_enable();
-	return 0;
-}
-
-static inline int __write_trylock(rwlock_t *lock)
-{
-	preempt_disable();
-	if (_raw_write_trylock(lock)) {
-		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	preempt_enable();
-	return 0;
-}
-
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
@@ -212,13 +97,6 @@ static inline int __write_trylock(rwlock
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-static inline void __read_lock(rwlock_t *lock)
-{
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
-}
-
 static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
 {
 	unsigned long flags;
@@ -255,62 +133,6 @@ static inline void __spin_lock_bh(spinlo
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
-			     _raw_read_lock_flags, &flags);
-	return flags;
-}
-
-static inline void __read_lock_irq(rwlock_t *lock)
-{
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
-}
-
-static inline void __read_lock_bh(rwlock_t *lock)
-{
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
-}
-
-static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
-			     _raw_write_lock_flags, &flags);
-	return flags;
-}
-
-static inline void __write_lock_irq(rwlock_t *lock)
-{
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
-}
-
-static inline void __write_lock_bh(rwlock_t *lock)
-{
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
-}
-
 static inline void __spin_lock(spinlock_t *lock)
 {
 	preempt_disable();
@@ -318,13 +140,6 @@ static inline void __spin_lock(spinlock_
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-static inline void __write_lock(rwlock_t *lock)
-{
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
-}
-
 #endif /* CONFIG_PREEMPT */
 
 static inline void __spin_unlock(spinlock_t *lock)
@@ -334,20 +149,6 @@ static inline void __spin_unlock(spinloc
 	preempt_enable();
 }
 
-static inline void __write_unlock(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable();
-}
-
-static inline void __read_unlock(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable();
-}
-
 static inline void __spin_unlock_irqrestore(spinlock_t *lock,
 					    unsigned long flags)
 {
@@ -373,55 +174,6 @@ static inline void __spin_unlock_bh(spin
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 
-static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
-}
-
-static inline void __read_unlock_irq(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
-}
-
-static inline void __read_unlock_bh(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
-}
-
-static inline void __write_unlock_irqrestore(rwlock_t *lock,
-					     unsigned long flags)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
-}
-
-static inline void __write_unlock_irq(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
-}
-
-static inline void __write_unlock_bh(rwlock_t *lock)
-{
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
-}
-
 static inline int __spin_trylock_bh(spinlock_t *lock)
 {
 	local_bh_disable();
@@ -435,4 +187,6 @@ static inline int __spin_trylock_bh(spin
 	return 0;
 }
 
+#include <linux/rwlock_api_smp.h>
+
 #endif /* __LINUX_SPINLOCK_API_SMP_H */


