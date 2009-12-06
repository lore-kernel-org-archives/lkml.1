Return-Path: <linux-kernel-owner+w=401wt.eu-S934297AbZLFSEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297AbZLFSEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934260AbZLFSEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:10 -0500
Received: from www.tglx.de ([62.245.132.106]:33273 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934164AbZLFSDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:44 -0500
Message-Id: <20091206111957.993628311@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 18/23] rtmutes: Convert rtmutex.lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=rtmutex-convert-wait-lock-to-core-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rtmutex.h |    6 +++---
 kernel/futex.c          |    6 +++---
 kernel/rtmutex.c        |   48 ++++++++++++++++++++++++------------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

Index: linux-2.6-tip/include/linux/rtmutex.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rtmutex.h
+++ linux-2.6-tip/include/linux/rtmutex.h
@@ -24,7 +24,7 @@
  * @owner:	the mutex owner
  */
 struct rt_mutex {
-	spinlock_t		wait_lock;
+	raw_spinlock_t		wait_lock;
 	struct plist_head	wait_list;
 	struct task_struct	*owner;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
@@ -63,8 +63,8 @@ struct hrtimer_sleeper;
 #endif
 
 #define __RT_MUTEX_INITIALIZER(mutexname) \
-	{ .wait_lock = __SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
-	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list, mutexname.wait_lock) \
+	{ .wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
+	, .wait_list = PLIST_HEAD_INIT_RAW(mutexname.wait_list, mutexname.wait_lock) \
 	, .owner = NULL \
 	__DEBUG_RT_MUTEX_INITIALIZER(mutexname)}
 
Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -754,7 +754,7 @@ static int wake_futex_pi(u32 __user *uad
 	if (!pi_state)
 		return -EINVAL;
 
-	spin_lock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -783,7 +783,7 @@ static int wake_futex_pi(u32 __user *uad
 		else if (curval != uval)
 			ret = -EINVAL;
 		if (ret) {
-			spin_unlock(&pi_state->pi_mutex.wait_lock);
+			raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 			return ret;
 		}
 	}
@@ -799,7 +799,7 @@ static int wake_futex_pi(u32 __user *uad
 	pi_state->owner = new_owner;
 	raw_spin_unlock_irq(&new_owner->pi_lock);
 
-	spin_unlock(&pi_state->pi_mutex.wait_lock);
+	raw_spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
 
 	return 0;
Index: linux-2.6-tip/kernel/rtmutex.c
===================================================================
--- linux-2.6-tip.orig/kernel/rtmutex.c
+++ linux-2.6-tip/kernel/rtmutex.c
@@ -231,7 +231,7 @@ static int rt_mutex_adjust_prio_chain(st
 		goto out_unlock_pi;
 
 	lock = waiter->lock;
-	if (!spin_trylock(&lock->wait_lock)) {
+	if (!raw_spin_trylock(&lock->wait_lock)) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		cpu_relax();
 		goto retry;
@@ -240,7 +240,7 @@ static int rt_mutex_adjust_prio_chain(st
 	/* Deadlock detection */
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
-		spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		ret = deadlock_detect ? -EDEADLK : 0;
 		goto out_unlock_pi;
 	}
@@ -280,7 +280,7 @@ static int rt_mutex_adjust_prio_chain(st
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	top_waiter = rt_mutex_top_waiter(lock);
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
@@ -459,12 +459,12 @@ static int task_blocks_on_rt_mutex(struc
 	 */
 	get_task_struct(owner);
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
 					 task);
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	return res;
 }
@@ -575,11 +575,11 @@ static void remove_waiter(struct rt_mute
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(owner);
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 }
 
 /*
@@ -672,14 +672,14 @@ __rt_mutex_slowlock(struct rt_mutex *loc
 				break;
 		}
 
-		spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
 		if (waiter->task)
 			schedule_rt_mutex(lock);
 
-		spin_lock(&lock->wait_lock);
+		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
 
@@ -700,11 +700,11 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	/* Try to acquire the lock again: */
 	if (try_to_take_rt_mutex(lock)) {
-		spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		return 0;
 	}
 
@@ -731,7 +731,7 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/* Remove pending timer: */
 	if (unlikely(timeout))
@@ -758,7 +758,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 {
 	int ret = 0;
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
 
@@ -770,7 +770,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 		fixup_rt_mutex_waiters(lock);
 	}
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	return ret;
 }
@@ -781,7 +781,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lo
 static void __sched
 rt_mutex_slowunlock(struct rt_mutex *lock)
 {
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -789,13 +789,13 @@ rt_mutex_slowunlock(struct rt_mutex *loc
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/* Undo pi boosting if necessary: */
 	rt_mutex_adjust_prio(current);
@@ -970,8 +970,8 @@ EXPORT_SYMBOL_GPL(rt_mutex_destroy);
 void __rt_mutex_init(struct rt_mutex *lock, const char *name)
 {
 	lock->owner = NULL;
-	spin_lock_init(&lock->wait_lock);
-	plist_head_init(&lock->wait_list, &lock->wait_lock);
+	raw_spin_lock_init(&lock->wait_lock);
+	plist_head_init_raw(&lock->wait_list, &lock->wait_lock);
 
 	debug_rt_mutex_init(lock, name);
 }
@@ -1032,7 +1032,7 @@ int rt_mutex_start_proxy_lock(struct rt_
 {
 	int ret;
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	mark_rt_mutex_waiters(lock);
 
@@ -1040,7 +1040,7 @@ int rt_mutex_start_proxy_lock(struct rt_
 		/* We got the lock for task. */
 		debug_rt_mutex_lock(lock);
 		rt_mutex_set_owner(lock, task, 0);
-		spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock);
 		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
@@ -1056,7 +1056,7 @@ int rt_mutex_start_proxy_lock(struct rt_
 		 */
 		ret = 0;
 	}
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
 
@@ -1106,7 +1106,7 @@ int rt_mutex_finish_proxy_lock(struct rt
 {
 	int ret;
 
-	spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
@@ -1124,7 +1124,7 @@ int rt_mutex_finish_proxy_lock(struct rt
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock);
 
 	/*
 	 * Readjust priority, when we did not get the lock. We might have been


