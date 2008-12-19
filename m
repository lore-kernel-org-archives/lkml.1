Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYLSQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYLSQTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYLSQS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:18:59 -0500
Received: from www.tglx.de ([62.245.132.106]:48525 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbYLSQSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:18:55 -0500
Message-Id: <20081219155556.103531550@linutronix.de>
References: <20081219155504.735865178@linutronix.de>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 16:03:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>,
       Linux-rt <linux-rt-users@vger.kernel.org>
Subject: [patch 4/7] rtmutex: unify state manipulation
Content-Disposition: inline; filename=rtmutex-unify-state-manipulation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The manipulation of the waiter task state is copied all over the place
with slightly different details. Use one set of functions to reduce
duplicated code and make the handling consistent for all instances.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/rtmutex.c |  104 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 47 deletions(-)

Index: linux-2.6.24/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.orig/kernel/rtmutex.c
+++ linux-2.6.24/kernel/rtmutex.c
@@ -765,13 +765,6 @@ rt_spin_lock_fastunlock(struct rt_mutex 
 		slowfn(lock);
 }
 
-static inline void
-update_current(unsigned long new_state, unsigned long *saved_state)
-{
-	unsigned long state = xchg(&current->state, new_state);
-	if (unlikely(state == TASK_RUNNING))
-		*saved_state = TASK_RUNNING;
-}
 
 #ifdef CONFIG_SMP
 static int adaptive_wait(struct rt_mutex_waiter *waiter,
@@ -803,6 +796,43 @@ static int adaptive_wait(struct rt_mutex
 #endif
 
 /*
+ * The state setting needs to preserve the original state and needs to
+ * take care of non rtmutex wakeups.
+ *
+ * The special case here is TASK_INTERRUPTIBLE: We cannot set the
+ * blocked state to TASK_UNINTERRUPTIBLE as we would miss wakeups from
+ * wake_up_interruptible().
+ */
+static inline unsigned long
+rt_set_current_blocked_state(unsigned long saved_state)
+{
+	unsigned long state, block_state;
+
+	do {
+		state = current->state;
+		/*
+		 * Take care of non rtmutex wakeups. rtmutex wakeups
+		 * set the state to TASK_RUNNING_MUTEX.
+		 */
+		if (state == TASK_RUNNING)
+			saved_state = TASK_RUNNING;
+
+		block_state = TASK_UNINTERRUPTIBLE;
+
+	} while (cmpxchg(&current->state, state, block_state) != state);
+
+	return saved_state;
+}
+
+static inline void rt_restore_current_state(unsigned long saved_state)
+{
+	unsigned long state = xchg(&current->state, saved_state);
+
+	if (state == TASK_RUNNING)
+		current->state = TASK_RUNNING;
+}
+
+/*
  * Slow path lock function spin_lock style: this variant is very
  * careful not to miss any non-lock wakeups.
  *
@@ -816,7 +846,7 @@ static void fastcall noinline __sched
 rt_spin_lock_slowlock(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter waiter;
-	unsigned long saved_state, state, flags;
+	unsigned long saved_state, flags;
 	struct task_struct *orig_owner;
 	int missed = 0;
 
@@ -836,7 +866,9 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 	 * of the lock sleep/wakeup mechanism. When we get a real
 	 * wakeup the task->state is TASK_RUNNING and we change
 	 * saved_state accordingly. If we did not get a real wakeup
-	 * then we return with the saved state.
+	 * then we return with the saved state. We need to be careful
+	 * about original state TASK_INTERRUPTIBLE as well, as we
+	 * could miss a wakeup_interruptible()
 	 */
 	saved_state = current->state;
 
@@ -880,7 +912,8 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 
 		if (adaptive_wait(&waiter, orig_owner)) {
 			put_task_struct(orig_owner);
-			update_current(TASK_UNINTERRUPTIBLE, &saved_state);
+
+			saved_state = rt_set_current_blocked_state(saved_state);
 			/*
 			 * The xchg() in update_current() is an implicit
 			 * barrier which we rely upon to ensure current->state
@@ -896,9 +929,7 @@ rt_spin_lock_slowlock(struct rt_mutex *l
 		current->lock_depth = saved_lock_depth;
 	}
 
-	state = xchg(&current->state, saved_state);
-	if (unlikely(state == TASK_RUNNING))
-		current->state = TASK_RUNNING;
+	rt_restore_current_state(saved_state);
 
 	/*
 	 * Extremely rare case, if we got woken up by a non-mutex wakeup,
@@ -1333,7 +1364,7 @@ rt_read_slowlock(struct rw_mutex *rwm, i
 	struct rt_mutex_waiter waiter;
 	struct rt_mutex *mutex = &rwm->mutex;
 	int saved_lock_depth = -1;
-	unsigned long saved_state = -1, state, flags;
+	unsigned long saved_state, flags;
 
 	spin_lock_irqsave(&mutex->wait_lock, flags);
 	init_rw_lists(rwm);
@@ -1357,13 +1388,13 @@ rt_read_slowlock(struct rw_mutex *rwm, i
 		 */
 		if (unlikely(current->lock_depth >= 0))
 			saved_lock_depth = rt_release_bkl(mutex, flags);
-		set_current_state(TASK_UNINTERRUPTIBLE);
 	} else {
 		/* Spin lock must preserve BKL */
-		saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
 		saved_lock_depth = current->lock_depth;
 	}
 
+	saved_state = rt_set_current_blocked_state(current->state);
+
 	for (;;) {
 		unsigned long saved_flags;
 
@@ -1398,23 +1429,12 @@ rt_read_slowlock(struct rw_mutex *rwm, i
 		spin_lock_irqsave(&mutex->wait_lock, flags);
 
 		current->flags |= saved_flags;
-		if (mtx)
-			set_current_state(TASK_UNINTERRUPTIBLE);
-		else {
+		if (!mtx)
 			current->lock_depth = saved_lock_depth;
-			state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
-			if (unlikely(state == TASK_RUNNING))
-				saved_state = TASK_RUNNING;
-		}
+		saved_state = rt_set_current_blocked_state(saved_state);
 	}
 
-	if (mtx)
-		set_current_state(TASK_RUNNING);
-	else {
-		state = xchg(&current->state, saved_state);
-		if (unlikely(state == TASK_RUNNING))
-			current->state = TASK_RUNNING;
-	}
+	rt_restore_current_state(saved_state);
 
 	if (unlikely(waiter.task))
 		remove_waiter(mutex, &waiter, flags);
@@ -1490,7 +1510,7 @@ rt_write_slowlock(struct rw_mutex *rwm, 
 	struct rt_mutex *mutex = &rwm->mutex;
 	struct rt_mutex_waiter waiter;
 	int saved_lock_depth = -1;
-	unsigned long flags, saved_state = -1, state;
+	unsigned long flags, saved_state;
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -1514,13 +1534,13 @@ rt_write_slowlock(struct rw_mutex *rwm, 
 		 */
 		if (unlikely(current->lock_depth >= 0))
 			saved_lock_depth = rt_release_bkl(mutex, flags);
-		set_current_state(TASK_UNINTERRUPTIBLE);
 	} else {
 		/* Spin locks must preserve the BKL */
 		saved_lock_depth = current->lock_depth;
-		saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
 	}
 
+	saved_state = rt_set_current_blocked_state(current->state);
+
 	for (;;) {
 		unsigned long saved_flags;
 
@@ -1555,24 +1575,14 @@ rt_write_slowlock(struct rw_mutex *rwm, 
 		spin_lock_irqsave(&mutex->wait_lock, flags);
 
 		current->flags |= saved_flags;
-		if (mtx)
-			set_current_state(TASK_UNINTERRUPTIBLE);
-		else {
+		if (!mtx)
 			current->lock_depth = saved_lock_depth;
-			state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
-			if (unlikely(state == TASK_RUNNING))
-				saved_state = TASK_RUNNING;
-		}
-	}
 
-	if (mtx)
-		set_current_state(TASK_RUNNING);
-	else {
-		state = xchg(&current->state, saved_state);
-		if (unlikely(state == TASK_RUNNING))
-			current->state = TASK_RUNNING;
+		saved_state = rt_set_current_blocked_state(saved_state);
 	}
 
+	rt_restore_current_state(saved_state);
+
 	if (unlikely(waiter.task))
 		remove_waiter(mutex, &waiter, flags);
 

-- 

