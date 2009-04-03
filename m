Return-Path: <linux-kernel-owner+w=401wt.eu-S937106AbZDCUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937106AbZDCUmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936950AbZDCUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:40:38 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57713 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936942AbZDCUkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:40:36 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [tip PATCH v7 5/9] RFC: rt_mutex: add proxy lock routines
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Date: Fri, 03 Apr 2009 13:40:12 -0700
Message-ID: <20090403204012.9772.72630.stgit@Aeon>
In-Reply-To: <20090403203832.9772.21410.stgit@Aeon>
References: <20090403203832.9772.21410.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is required for the first half of requeue_pi to function.  It
basically splits rt_mutex_slowlock() right down the middle, just before the
first call to schedule().

This patch uses a new futex_q field, rt_waiter, for now.  I think
I should be able to use task->pi_blocked_on in a future version of this patch.

Changelog:
V6: -add mark_rt_mutex_waiters() to rt_mutex_start_procy_lock() to avoid
     the race condition evident in previous versions
    -cleanup kernel-docs formatting and comments
    -try to take the lock in rt_mutex_start_proxy_lock() rather than assume
     the lock is held
    -remove initial schedule in finish_proxy_lock to allow for signal and
     timeout detection.
V5: -remove EXPORT_SYMBOL_GPL from the new routines
    -minor cleanups
V4: -made detect_deadlock a parameter to rt_mutex_enqueue_task
    -refactored rt_mutex_slowlock to share code with new functions
    -renamed rt_mutex_enqueue_task and rt_mutex_handle_wakeup to
     rt_mutex_start_proxy_lock and rt_mutex_finish_proxy_lock, respectively

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
---

 kernel/rtmutex.c        |  240 +++++++++++++++++++++++++++++++++++++----------
 kernel/rtmutex_common.h |    8 ++
 2 files changed, 195 insertions(+), 53 deletions(-)

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 69d9cb9..fec77e7 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -300,7 +300,8 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
  * assigned pending owner [which might not have taken the
  * lock yet]:
  */
-static inline int try_to_steal_lock(struct rt_mutex *lock)
+static inline int try_to_steal_lock(struct rt_mutex *lock,
+				    struct task_struct *task)
 {
 	struct task_struct *pendowner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *next;
@@ -309,11 +310,11 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 	if (!rt_mutex_owner_pending(lock))
 		return 0;
 
-	if (pendowner == current)
+	if (pendowner == task)
 		return 1;
 
 	spin_lock_irqsave(&pendowner->pi_lock, flags);
-	if (current->prio >= pendowner->prio) {
+	if (task->prio >= pendowner->prio) {
 		spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 		return 0;
 	}
@@ -338,21 +339,21 @@ static inline int try_to_steal_lock(struct rt_mutex *lock)
 	 * We are going to steal the lock and a waiter was
 	 * enqueued on the pending owners pi_waiters queue. So
 	 * we have to enqueue this waiter into
-	 * current->pi_waiters list. This covers the case,
-	 * where current is boosted because it holds another
+	 * task->pi_waiters list. This covers the case,
+	 * where task is boosted because it holds another
 	 * lock and gets unboosted because the booster is
 	 * interrupted, so we would delay a waiter with higher
-	 * priority as current->normal_prio.
+	 * priority as task->normal_prio.
 	 *
 	 * Note: in the rare case of a SCHED_OTHER task changing
 	 * its priority and thus stealing the lock, next->task
-	 * might be current:
+	 * might be task:
 	 */
-	if (likely(next->task != current)) {
-		spin_lock_irqsave(&current->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &current->pi_waiters);
-		__rt_mutex_adjust_prio(current);
-		spin_unlock_irqrestore(&current->pi_lock, flags);
+	if (likely(next->task != task)) {
+		spin_lock_irqsave(&task->pi_lock, flags);
+		plist_add(&next->pi_list_entry, &task->pi_waiters);
+		__rt_mutex_adjust_prio(task);
+		spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
 	return 1;
 }
@@ -389,7 +390,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock))
+	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
 		return 0;
 
 	/* We got the lock. */
@@ -411,6 +412,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
  */
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
+				   struct task_struct *task,
 				   int detect_deadlock)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
@@ -418,21 +420,21 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
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
@@ -460,7 +462,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	spin_unlock(&lock->wait_lock);
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
-					 current);
+					 task);
 
 	spin_lock(&lock->wait_lock);
 
@@ -605,37 +607,25 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	rt_mutex_adjust_prio_chain(task, 0, NULL, NULL, task);
 }
 
-/*
- * Slow path lock function:
+/**
+ * __rt_mutex_slowlock() - Perform the wait-wake-try-to-take loop
+ * @lock:		 the rt_mutex to take
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
@@ -656,19 +646,19 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
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
@@ -684,15 +674,52 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 
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
@@ -986,6 +1013,59 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 }
 
 /**
+ * rt_mutex_start_proxy_lock() - Start lock acquisition for another task
+ * @lock:		the rt_mutex to take
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @task:		the task to prepare
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Returns:
+ *  0 - task blocked on lock
+ *  1 - acquired the lock for task, caller should wake it up
+ * <0 - error
+ *
+ * Special API call for FUTEX_REQUEUE_PI support.
+ */
+int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
+			      struct rt_mutex_waiter *waiter,
+			      struct task_struct *task, int detect_deadlock)
+{
+	int ret;
+
+	spin_lock(&lock->wait_lock);
+
+	mark_rt_mutex_waiters(lock);
+
+	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
+		/* We got the lock for task. */
+		debug_rt_mutex_lock(lock);
+
+		rt_mutex_set_owner(lock, task, 0);
+
+		rt_mutex_deadlock_account_lock(lock, task);
+		return 1;
+	}
+
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+
+
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
@@ -1004,3 +1084,57 @@ struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock)
 
 	return rt_mutex_top_waiter(lock)->task;
 }
+
+/**
+ * rt_mutex_finish_proxy_lock() - Complete lock acquisition
+ * @lock:		the rt_mutex we were woken on
+ * @to:			the timeout, null if none. hrtimer should already have
+ * 			been started.
+ * @waiter:		the pre-initialized rt_mutex_waiter
+ * @detect_deadlock:	perform deadlock detection (1) or not (0)
+ *
+ * Complete the lock acquisition started our behalf by another thread.
+ *
+ * Returns:
+ *  0 - success
+ * <0 - error, one of -EINTR, -ETIMEDOUT, or -EDEADLK
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

