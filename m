Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbXE2NS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbXE2NS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbXE2NSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:18:39 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65098 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbXE2NSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:18:38 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:18:35 EDT
Message-Id: <20070529130107.586807989@chello.nl>
References: <20070529125248.877196281@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 29 May 2007 14:52:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] lockstat: hook into spinlock_t, rwlock_t, rwsem and mutex
Content-Disposition: inline; filename=lockstat-hooks.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Call the new lockstat tracking functions from the various lock primitives.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 kernel/mutex.c    |    8 ++++++++
 kernel/rwsem.c    |    8 ++++----
 kernel/spinlock.c |   28 ++++++++++++++--------------
 3 files changed, 26 insertions(+), 18 deletions(-)

Index: linux-2.6-git/kernel/mutex.c
===================================================================
--- linux-2.6-git.orig/kernel/mutex.c
+++ linux-2.6-git/kernel/mutex.c
@@ -139,6 +139,12 @@ __mutex_lock_common(struct mutex *lock, 
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
+	old_val = atomic_xchg(&lock->count, -1);
+	if (old_val == 1)
+		goto done;
+
+	lock_contended(&lock->dep_map, _RET_IP_);
+
 	for (;;) {
 		/*
 		 * Lets try to take the lock again - this is needed even if
@@ -174,6 +180,8 @@ __mutex_lock_common(struct mutex *lock, 
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
+	lock_acquired(&lock->dep_map);
+done:
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));
Index: linux-2.6-git/kernel/rwsem.c
===================================================================
--- linux-2.6-git.orig/kernel/rwsem.c
+++ linux-2.6-git/kernel/rwsem.c
@@ -20,7 +20,7 @@ void down_read(struct rw_semaphore *sem)
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read);
@@ -47,7 +47,7 @@ void down_write(struct rw_semaphore *sem
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, 0, 0, _RET_IP_);
 
-	__down_write(sem);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write);
@@ -111,7 +111,7 @@ void down_read_nested(struct rw_semaphor
 	might_sleep();
 	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_read(sem);
+	LOCK_CONTENDED(sem, __down_read_trylock, __down_read);
 }
 
 EXPORT_SYMBOL(down_read_nested);
@@ -130,7 +130,7 @@ void down_write_nested(struct rw_semapho
 	might_sleep();
 	rwsem_acquire(&sem->dep_map, subclass, 0, _RET_IP_);
 
-	__down_write_nested(sem, subclass);
+	LOCK_CONTENDED(sem, __down_write_trylock, __down_write);
 }
 
 EXPORT_SYMBOL(down_write_nested);
Index: linux-2.6-git/kernel/spinlock.c
===================================================================
--- linux-2.6-git.orig/kernel/spinlock.c
+++ linux-2.6-git/kernel/spinlock.c
@@ -72,7 +72,7 @@ void __lockfunc _read_lock(rwlock_t *loc
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock);
 
@@ -89,7 +89,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif
@@ -102,7 +102,7 @@ void __lockfunc _spin_lock_irq(spinlock_
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
@@ -111,7 +111,7 @@ void __lockfunc _spin_lock_bh(spinlock_t
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
@@ -122,7 +122,7 @@ unsigned long __lockfunc _read_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
@@ -132,7 +132,7 @@ void __lockfunc _read_lock_irq(rwlock_t 
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
 
@@ -141,7 +141,7 @@ void __lockfunc _read_lock_bh(rwlock_t *
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_read_lock(lock);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
@@ -152,7 +152,7 @@ unsigned long __lockfunc _write_lock_irq
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 	return flags;
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
@@ -162,7 +162,7 @@ void __lockfunc _write_lock_irq(rwlock_t
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
 
@@ -171,7 +171,7 @@ void __lockfunc _write_lock_bh(rwlock_t 
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
 
@@ -179,7 +179,7 @@ void __lockfunc _spin_lock(spinlock_t *l
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock);
@@ -188,7 +188,7 @@ void __lockfunc _write_lock(rwlock_t *lo
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	_raw_write_lock(lock);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 
 EXPORT_SYMBOL(_write_lock);
@@ -289,7 +289,7 @@ void __lockfunc _spin_lock_nested(spinlo
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
 EXPORT_SYMBOL(_spin_lock_nested);
@@ -306,7 +306,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	_raw_spin_lock(lock);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 #else
 	_raw_spin_lock_flags(lock, &flags);
 #endif

--

