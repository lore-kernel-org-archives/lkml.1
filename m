Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbZBPUSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbZBPUSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 15:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBPUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 15:18:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:39743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZBPUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 15:18:35 -0500
Subject: [PATCH] mutex: enable spinning for DEBUG_MUTEX
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 21:18:30 +0100
Message-Id: <1234815510.30178.357.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mutex: enable spinning for DEBUG_MUTEX
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 15 Jan 2009 15:57:38 +0100

Spinning with CONFIG_DEBUG_MUTEX is possible but care must be taken
with the debug checks vs. racy access to the lock owner field.

In the case where the lock owner gets rescheduled after acquisition
and therefor unlocks on another CPU, that second CPU might not see the
write of the owner field from the first CPU and we warn about owner
mismatch.  Thus the memory barriers for the debug case.

Also remove the redundant mutex_set_owner()s in __mutex_lock_common()
and __mutex_trylock_slowpath(), it's taken care of in mutex_lock() and
mutex_trylock().

[a.p.zijlstra@chello.nl: fix _nested variants]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/mutex-debug.c |    6 ++++++
 kernel/mutex-debug.h |    6 ++++++
 kernel/mutex.c       |   27 +++++++++++++++------------
 3 files changed, 27 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -148,7 +148,7 @@ __mutex_lock_common(struct mutex *lock, 
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#if defined(CONFIG_SMP)
 	/*
 	 * Optimistic spinning.
 	 *
@@ -162,9 +162,6 @@ __mutex_lock_common(struct mutex *lock, 
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
 	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
 	 */
 
 	for (;;) {
@@ -180,7 +177,6 @@ __mutex_lock_common(struct mutex *lock, 
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
 			lock_acquired(&lock->dep_map, ip);
-			mutex_set_owner(lock);
 			preempt_enable();
 			return 0;
 		}
@@ -256,7 +252,6 @@ done:
 	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, current_thread_info());
-	mutex_set_owner(lock);
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
@@ -276,6 +271,7 @@ mutex_lock_nested(struct mutex *lock, un
 {
 	might_sleep();
 	__mutex_lock_common(lock, TASK_UNINTERRUPTIBLE, subclass, _RET_IP_);
+	mutex_set_owner(lock);
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_nested);
@@ -283,17 +279,26 @@ EXPORT_SYMBOL_GPL(mutex_lock_nested);
 int __sched
 mutex_lock_killable_nested(struct mutex *lock, unsigned int subclass)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	ret = __mutex_lock_common(lock, TASK_KILLABLE, subclass, _RET_IP_);
+	mutex_set_owner(lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(mutex_lock_killable_nested);
 
 int __sched
 mutex_lock_interruptible_nested(struct mutex *lock, unsigned int subclass)
 {
+	int ret;
+
 	might_sleep();
-	return __mutex_lock_common(lock, TASK_INTERRUPTIBLE,
-				   subclass, _RET_IP_);
+	ret = __mutex_lock_common(lock, TASK_INTERRUPTIBLE, subclass, _RET_IP_);
+	mutex_set_owner(lock);
+
+	return ret;
 }
 
 EXPORT_SYMBOL_GPL(mutex_lock_interruptible_nested);
@@ -432,10 +437,8 @@ static inline int __mutex_trylock_slowpa
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	prev = atomic_xchg(&lock->count, -1);
-	if (likely(prev == 1)) {
-		mutex_set_owner(lock);
+	if (likely(prev == 1))
 		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-	}
 
 	/* Set it back to 0 if there are no waiters: */
 	if (likely(list_empty(&lock->wait_list)))
Index: linux-2.6/kernel/mutex-debug.c
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.c
+++ linux-2.6/kernel/mutex-debug.c
@@ -74,6 +74,12 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+	/*
+	 * We might have been rescheduled after taking the lock.  Make sure
+	 * the new CPU sees the setting of the owner field.  Corresponding
+	 * write side is mutex_set_owner().
+	 */
+	smp_rmb();
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
Index: linux-2.6/kernel/mutex-debug.h
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.h
+++ linux-2.6/kernel/mutex-debug.h
@@ -30,6 +30,12 @@ extern void debug_mutex_init(struct mute
 static inline void mutex_set_owner(struct mutex *lock)
 {
 	lock->owner = current_thread_info();
+	/*
+	 * When the acquirer gets rescheduled after taking the
+	 * lock, make sure the owner setting is visible to
+	 * debug_mutex_unlock() on the new CPU.
+	 */
+	smp_wmb();
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)


