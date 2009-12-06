Return-Path: <linux-kernel-owner+w=401wt.eu-S934086AbZLFSCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086AbZLFSCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934078AbZLFSCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:02:11 -0500
Received: from www.tglx.de ([62.245.132.106]:33001 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934028AbZLFSCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:06 -0500
Message-Id: <20091206111957.323401374@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:01:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 01/23] locking: Reorder functions in spinlock.c
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-reorder-functions-in-spinlock-c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate spin_lock and rw_lock functions. Preempt-RT needs to exclude
the rw_lock functions from being compiled. The reordering allows to do
that with a single #ifdef.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/spinlock.c |  246 +++++++++++++++++++++++++++---------------------------
 1 file changed, 123 insertions(+), 123 deletions(-)

Index: linux-2.6-tip/kernel/spinlock.c
===================================================================
--- linux-2.6-tip.orig/kernel/spinlock.c
+++ linux-2.6-tip/kernel/spinlock.c
@@ -113,41 +113,6 @@ BUILD_LOCK_OPS(write, rwlock);
 
 #endif
 
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
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock,
-						   int subclass)
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
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
@@ -156,28 +121,20 @@ int __lockfunc _spin_trylock(spinlock_t 
 EXPORT_SYMBOL(_spin_trylock);
 #endif
 
-#ifndef CONFIG_INLINE_READ_TRYLOCK
-int __lockfunc _read_trylock(rwlock_t *lock)
-{
-	return __read_trylock(lock);
-}
-EXPORT_SYMBOL(_read_trylock);
-#endif
-
-#ifndef CONFIG_INLINE_WRITE_TRYLOCK
-int __lockfunc _write_trylock(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
+int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
-	return __write_trylock(lock);
+	return __spin_trylock_bh(lock);
 }
-EXPORT_SYMBOL(_write_trylock);
+EXPORT_SYMBOL(_spin_trylock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_READ_LOCK
-void __lockfunc _read_lock(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_LOCK
+void __lockfunc _spin_lock(spinlock_t *lock)
 {
-	__read_lock(lock);
+	__spin_lock(lock);
 }
-EXPORT_SYMBOL(_read_lock);
+EXPORT_SYMBOL(_spin_lock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
@@ -204,84 +161,76 @@ void __lockfunc _spin_lock_bh(spinlock_t
 EXPORT_SYMBOL(_spin_lock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
-{
-	return __read_lock_irqsave(lock);
-}
-EXPORT_SYMBOL(_read_lock_irqsave);
-#endif
-
-#ifndef CONFIG_INLINE_READ_LOCK_IRQ
-void __lockfunc _read_lock_irq(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_UNLOCK
+void __lockfunc _spin_unlock(spinlock_t *lock)
 {
-	__read_lock_irq(lock);
+	__spin_unlock(lock);
 }
-EXPORT_SYMBOL(_read_lock_irq);
+EXPORT_SYMBOL(_spin_unlock);
 #endif
 
-#ifndef CONFIG_INLINE_READ_LOCK_BH
-void __lockfunc _read_lock_bh(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
+void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
-	__read_lock_bh(lock);
+	__spin_unlock_irqrestore(lock, flags);
 }
-EXPORT_SYMBOL(_read_lock_bh);
+EXPORT_SYMBOL(_spin_unlock_irqrestore);
 #endif
 
-#ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
+void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
-	return __write_lock_irqsave(lock);
+	__spin_unlock_irq(lock);
 }
-EXPORT_SYMBOL(_write_lock_irqsave);
+EXPORT_SYMBOL(_spin_unlock_irq);
 #endif
 
-#ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
-void __lockfunc _write_lock_irq(rwlock_t *lock)
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
+void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
-	__write_lock_irq(lock);
+	__spin_unlock_bh(lock);
 }
-EXPORT_SYMBOL(_write_lock_irq);
+EXPORT_SYMBOL(_spin_unlock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_WRITE_LOCK_BH
-void __lockfunc _write_lock_bh(rwlock_t *lock)
+#ifndef CONFIG_INLINE_READ_TRYLOCK
+int __lockfunc _read_trylock(rwlock_t *lock)
 {
-	__write_lock_bh(lock);
+	return __read_trylock(lock);
 }
-EXPORT_SYMBOL(_write_lock_bh);
+EXPORT_SYMBOL(_read_trylock);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _spin_lock(spinlock_t *lock)
+#ifndef CONFIG_INLINE_READ_LOCK
+void __lockfunc _read_lock(rwlock_t *lock)
 {
-	__spin_lock(lock);
+	__read_lock(lock);
 }
-EXPORT_SYMBOL(_spin_lock);
+EXPORT_SYMBOL(_read_lock);
 #endif
 
-#ifndef CONFIG_INLINE_WRITE_LOCK
-void __lockfunc _write_lock(rwlock_t *lock)
+#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
+unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
-	__write_lock(lock);
+	return __read_lock_irqsave(lock);
 }
-EXPORT_SYMBOL(_write_lock);
+EXPORT_SYMBOL(_read_lock_irqsave);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_UNLOCK
-void __lockfunc _spin_unlock(spinlock_t *lock)
+#ifndef CONFIG_INLINE_READ_LOCK_IRQ
+void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
-	__spin_unlock(lock);
+	__read_lock_irq(lock);
 }
-EXPORT_SYMBOL(_spin_unlock);
+EXPORT_SYMBOL(_read_lock_irq);
 #endif
 
-#ifndef CONFIG_INLINE_WRITE_UNLOCK
-void __lockfunc _write_unlock(rwlock_t *lock)
+#ifndef CONFIG_INLINE_READ_LOCK_BH
+void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
-	__write_unlock(lock);
+	__read_lock_bh(lock);
 }
-EXPORT_SYMBOL(_write_unlock);
+EXPORT_SYMBOL(_read_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK
@@ -292,30 +241,6 @@ void __lockfunc _read_unlock(rwlock_t *l
 EXPORT_SYMBOL(_read_unlock);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
-{
-	__spin_unlock_irqrestore(lock, flags);
-}
-EXPORT_SYMBOL(_spin_unlock_irqrestore);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _spin_unlock_irq(spinlock_t *lock)
-{
-	__spin_unlock_irq(lock);
-}
-EXPORT_SYMBOL(_spin_unlock_irq);
-#endif
-
-#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _spin_unlock_bh(spinlock_t *lock)
-{
-	__spin_unlock_bh(lock);
-}
-EXPORT_SYMBOL(_spin_unlock_bh);
-#endif
-
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
@@ -340,6 +265,54 @@ void __lockfunc _read_unlock_bh(rwlock_t
 EXPORT_SYMBOL(_read_unlock_bh);
 #endif
 
+#ifndef CONFIG_INLINE_WRITE_TRYLOCK
+int __lockfunc _write_trylock(rwlock_t *lock)
+{
+	return __write_trylock(lock);
+}
+EXPORT_SYMBOL(_write_trylock);
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
+#ifndef CONFIG_INLINE_WRITE_UNLOCK
+void __lockfunc _write_unlock(rwlock_t *lock)
+{
+	__write_unlock(lock);
+}
+EXPORT_SYMBOL(_write_unlock);
+#endif
+
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
@@ -364,12 +337,39 @@ void __lockfunc _write_unlock_bh(rwlock_
 EXPORT_SYMBOL(_write_unlock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _spin_trylock_bh(spinlock_t *lock)
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 {
-	return __spin_trylock_bh(lock);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_trylock_bh);
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
 #endif
 
 notrace int in_lock_functions(unsigned long addr)


