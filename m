Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbZCCAST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbZCCAST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760130AbZCCAQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:16:53 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:59107 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbZCCAQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:16:51 -0500
Message-ID: <49AC76EF.4030402@us.ibm.com>
Date: Mon, 02 Mar 2009 16:16:47 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 5/7] rt_mutex: add proxy lock routines
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhltc@us.ibm.com>

This patch is required for the first half of requeue_pi to function.  It
basically splits rt_mutex_slowlock() right down the middle, just before the
first call to schedule().

This patch uses a new futex_q field, rt_waiter, for now.  I think
I should be able to use task->pi_blocked_on in a future versino of this patch.

NOTE: I believe this patch creates a race condition that the final patch hits
      when trying to do requeue_pi with nr_wake=1 and nr_requeue=0.  See
      that patch header (6/7) for a complete discription.

V5: -remove EXPORT_SYMBOL_GPL from the new routines
    -minor cleanups
V4: -made detect_deadlock a parameter to rt_mutex_enqueue_task
    -refactored rt_mutex_slowlock to share code with new functions
    -renamed rt_mutex_enqueue_task and rt_mutex_handle_wakeup to
     rt_mutex_start_proxy_lock and rt_mutex_finish_proxy_lock, respectively

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---

 kernel/rtmutex.c        |  192 +++++++++++++++++++++++++++++++++++++----------
 kernel/rtmutex_common.h |    8 ++
 2 files changed, 160 insertions(+), 40 deletions(-)


diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 69d9cb9..a96842e 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -411,6 +411,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
  */
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
+				   struct task_struct *task,
 				   int detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
@@ -418,21 +419,21 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	unsigned long flags;
 	int chain_walk = 0, res;
 
-	spin_lock_irqsave(&current->pi_lock, flags);
-	__rt_mutex_adjust_prio(current);
-	waiter->task = current;
+	spin_lock_irqsave(&task->pi_lock, flags);
+	__rt_mutex_adjust_prio(task);
+	waiter->task = task;
 	waiter->lock = lock;
-	plist_node_init(&waiter->list_entry, current->prio);
-	plist_node_init(&waiter->pi_list_entry, current->prio);
+	plist_node_init(&waiter->list_entry, task->prio);
+	plist_node_init(&waiter->pi_list_entry, task->prio);
 
 	/* Get the top priority waiter on the lock */
 	if (rt_mutex_has_waiters(lock))
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
-	current->pi_blocked_on = waiter;
+	task->pi_blocked_on = waiter;
 
-	spin_unlock_irqrestore(&current->pi_lock, flags);
+	spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		spin_lock_irqsave(&owner->pi_lock, flags);
@@ -460,7 +461,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 current);
+					 task);
 
 	spin_lock(&lock->wait_lock);
 
@@ -605,37 +606,25 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
 }
 
-/*
- * Slow path lock function:
+/**
+ * __rt_mutex_slowlock - perform the wait-wake-try-to-take loop
+ * @lock		 the rt_mutex to take
+ * @state:		 the state the task should block in (TASK_INTERRUPTIBLE
+ * 			 or TASK_UNINTERRUPTIBLE)
+ * @timeout:		 the pre-initialized and started timer, or NULL for none
+ * @waiter:		 the pre-initialized rt_mutex_waiter
+ * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
+ *
+ * lock->wait_lock must be held by the caller.
  */
 static int __sched
-rt_mutex_slowlock(struct rt_mutex *lock, int state,
-		  struct hrtimer_sleeper *timeout,
-		  int detect_deadlock)
+__rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		    struct hrtimer_sleeper *timeout,
+		    struct rt_mutex_waiter *waiter,
+		    int detect_deadlock)
 {
-	struct rt_mutex_waiter waiter;
 	int ret = 0;
 
-	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
-
-	spin_lock(&lock->wait_lock);
-
-	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
-		spin_unlock(&lock->wait_lock);
-		return 0;
-	}
-
-	set_current_state(state);
-
-	/* Setup the timer, when timeout != NULL */
-	if (unlikely(timeout)) {
-		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
-		if (!hrtimer_active(&timeout->timer))
-			timeout->task = NULL;
-	}
-
 	for (;;) {
 		/* Try to acquire the lock: */
 		if (try_to_take_rt_mutex(lock))
@@ -656,19 +645,19 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		}
 
 		/*
-		 * waiter.task is NULL the first time we come here and
+		 * waiter->task is NULL the first time we come here and
 		 * when we have been woken up by the previous owner
 		 * but the lock got stolen by a higher prio task.
 		 */
-		if (!waiter.task) {
-			ret = task_blocks_on_rt_mutex(lock, &waiter,
+		if (!waiter->task) {
+			ret = task_blocks_on_rt_mutex(lock, waiter, current,
 						      detect_deadlock);
 			/*
 			 * If we got woken up by the owner then start loop
 			 * all over without going into schedule to try
 			 * to get the lock now:
 			 */
-			if (unlikely(!waiter.task)) {
+			if (unlikely(!waiter->task)) {
 				/*
 				 * Reset the return value. We might
 				 * have returned with -EDEADLK and the
@@ -684,15 +673,52 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
 		spin_unlock(&lock->wait_lock);
 
-		debug_rt_mutex_print_deadlock(&waiter);
+		debug_rt_mutex_print_deadlock(waiter);
 
-		if (waiter.task)
+		if (waiter->task)
 			schedule_rt_mutex(lock);
 
 		spin_lock(&lock->wait_lock);
 		set_current_state(state);
 	}
 
+	return ret;
+}
+
+/*
+ * Slow path lock function:
+ */
+static int __sched
+rt_mutex_slowlock(struct rt_mutex *lock, int state,
+		  struct hrtimer_sleeper *timeout,
+		  int detect_deadlock)
+{
+	struct rt_mutex_waiter waiter;
+	int ret = 0;
+
+	debug_rt_mutex_init_waiter(&waiter);
+	waiter.task = NULL;
+
+	spin_lock(&lock->wait_lock);
+
+	/* Try to acquire the lock again: */
+	if (try_to_take_rt_mutex(lock)) {
+		spin_unlock(&lock->wait_lock);
+		return 0;
+	}
+
+	set_current_state(state);
+
+	/* Setup the timer, when timeout != NULL */
+	if (unlikely(timeout)) {
+		hrtimer_start_expires(&timeout->timer, HRTIMER_MODE_ABS);
+		if (!hrtimer_active(&timeout->timer))
+			timeout->task = NULL;
+	}
+
+	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
+				  detect_deadlock);
+
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(waiter.task))
@@ -986,6 +1012,41 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 }
 
 /**
+ * rt_mutex_start_proxy_lock - prepare another task to take the lock
+ *
+ * @lock:		the rt_mutex to take
+ * @waiter:		the rt_mutex_waiter initialized by the waiter
+ * @task:		the task to prepare
+ * @detext_deadlock:	passed to task_blocks_on_rt_mutex
+ *
+ * The lock should have an owner, and it should not be task.
+ * Special API call for FUTEX_REQUEUE_PI support.
+ */
+int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+			      struct rt_mutex_waiter *waiter,
+			      struct task_struct *task, int detect_deadlock)
+{
+	int ret;
+
+	spin_lock(&lock->wait_lock);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	if (ret && !waiter->task) {
+		/*
+		 * Reset the return value. We might have
+		 * returned with -EDEADLK and the owner
+		 * released the lock while we were walking the
+		 * pi chain.  Let the waiter sort it out.
+		 */
+		ret = 0;
+	}
+	spin_unlock(&lock->wait_lock);
+
+	debug_rt_mutex_print_deadlock(waiter);
+
+	return ret;
+}
+
+/**
  * rt_mutex_next_owner - return the next owner of the lock
  *
  * @lock: the rt lock query
@@ -1004,3 +1065,54 @@ struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
 
 	return rt_mutex_top_waiter(lock)->task;
 }
+
+/**
+ * rt_mutex_finish_proxy_lock - Complete the taking of the lock initialized on
+ *                              our behalf by another thread.
+ * @lock: the rt_mutex we were woken on
+ * @to: the timeout, null if none. hrtimer should already have been started.
+ * @waiter: the pre-initialized rt_mutex_waiter
+ * @detect_deadlock: for use by __rt_mutex_slowlock
+ *
+ * Special API call for PI-futex requeue support
+ */
+int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+			       struct hrtimer_sleeper *to,
+			       struct rt_mutex_waiter *waiter,
+			       int detect_deadlock)
+{
+	int ret;
+
+	if (waiter->task)
+		schedule_rt_mutex(lock);
+
+	spin_lock(&lock->wait_lock);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
+				  detect_deadlock);
+
+	set_current_state(TASK_RUNNING);
+
+	if (unlikely(waiter->task))
+		remove_waiter(lock, waiter);
+
+	/*
+	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
+	 * have to fix that up.
+	 */
+	fixup_rt_mutex_waiters(lock);
+
+	spin_unlock(&lock->wait_lock);
+
+	/*
+	 * Readjust priority, when we did not get the lock. We might have been
+	 * the pending owner and boosted. Since we did not take the lock, the
+	 * PI boost has to go.
+	 */
+	if (unlikely(ret))
+		rt_mutex_adjust_prio(current);
+
+	return ret;
+}
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index e124bf5..97a2f81 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -120,6 +120,14 @@ extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
 extern void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 				  struct task_struct *proxy_owner);
+extern int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+				     struct rt_mutex_waiter *waiter,
+				     struct task_struct *task,
+				     int detect_deadlock);
+extern int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
+				      struct hrtimer_sleeper *to,
+				      struct rt_mutex_waiter *waiter,
+				      int detect_deadlock);
 
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # include "rtmutex-debug.h"

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
