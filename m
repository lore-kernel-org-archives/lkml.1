Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbYHOUdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbYHOUdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761400AbYHOUbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:31:18 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:36057
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761379AbYHOUbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:31:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT RFC v4 8/8] rtmutex: pi-boost locks as late as possible
To: mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org,
       tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       gregory.haskins@gmail.com, David.Holmes@sun.com, jkacur@gmail.com
Date: Fri, 15 Aug 2008 16:29:00 -0400
Message-ID: <20080815202900.668.62054.stgit@dev.haskins.net>
In-Reply-To: <20080815202408.668.23736.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RT replaces most spinlock_t instances with a preemptible
real-time lock that supports priority inheritance.  An uncontended
(fastpath) acquisition of this lock has no more overhead than
its non-rt spinlock_t counterpart.  However, the contended case
has considerably more overhead so that the lock can maintain
proper priority queue order and support pi-boosting of the lock
owner, yet remaining fully preemptible.

Instrumentation shows that the majority of acquisitions under most
workloads falls either into the fastpath category, or the adaptive
spin category within the slowpath.  The necessity to pi-boost a
lock-owner should be sufficiently rare, yet the slow-path path
blindly incurs this overhead in 100% of contentions.

Therefore, this patch intends to capitalize on this observation
in order to reduce overhead and improve acquisition throughput.
It is important to note that real-time latency is still treated
as a higher order constraint than throughput, so the full
pi-protocol is observed using new carefully constructed rules
around the old concepts.

1) We check the priority of the owner relative to the waiter on
   each spin of the lock (if we are not boosted already).  If the
   owner's effective priority is logically less than the waiters
   priority, we must boost them.

2) We check the priority of ourselves against our current queue
   position on the waiters-list (if we are not boosted already).
   If our priority was changed, we need to re-queue ourselves to
   update our position.

3) We break out of the adaptive-spin if either of the above
   conditions (1), (2) change so that we can re-evaluate the
   lock conditions.

4) We must enter pi-boost mode if, at any time, we decide to
   voluntarily preempt since we are losing our ability to
   dynamically process the conditions above.

Note: We still fully support priority inheritance with this
protocol, even if we defer the low-level calls to adjust priority.
The difference is really in terms of being a pro-active protocol
(boost on entry), verses a reactive protocol (boost when
necessary).  The upside to the latter is that we don't take a
penalty for pi when it is not necessary (which is most of the time)
The downside is that we technically leave the owner exposed to
getting preempted (should it get asynchronously deprioritized), even
if our waiter is the highest priority task in the system.  When this
happens, the owner would be immediately boosted (because we would
hit the "oncpu" condition, and subsequently follow the voluntary
preempt path which boosts the owner).  Therefore, inversion is
correctly prevented, but we have the extra latency of the
preempt/boost/wakeup that could have been avoided in the proactive
model.

However, the design of the algorithm described above constrains the
probability of this phenomenon occurring to setscheduler()
operations. Since rt-locks do not support being interrupted by
signals or timeouts, waiters only depart via the acquisition path.
And while acquisitions do deboost the owner, the owner also
changes simultaneously, rending the deboost moot relative to the
other waiters.

What this all means is that the downside to this implementation is
that a high-priority waiter *may* see an extra latency (equivalent
to roughly two wake-ups) if the owner has its priority reduced via
setscheduler() while it holds the lock.  The penalty is
deterministic, arguably small enough, and sufficiently rare that I
do not believe it should be an issue.

Note: If the concept of other exit paths are ever introduced in the
future, simply adapting the condition to look at owner->normal_prio
instead of owner->prio should once again constrain the limitation
to setscheduler().

Special thanks to Peter Morreale for suggesting the optimization to
only consider skipping the boost if the owner is >= to current.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Peter Morreale <pmorreale@novell.com>
---

 include/linux/rtmutex.h |    1 
 kernel/rtmutex.c        |  195 ++++++++++++++++++++++++++++++++++++-----------
 kernel/rtmutex_common.h |    1 
 3 files changed, 153 insertions(+), 44 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index e069182..656610b 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -33,6 +33,7 @@ struct rt_mutex {
 		struct pi_node   node;
 		struct pi_sink   sink;
 		int              prio;
+		int              boosters;
 	} pi;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	int			save_state;
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 8acbf23..ef2b508 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -76,14 +76,15 @@ rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
 {
 	unsigned long val = (unsigned long)owner | mask;
 
-	if (rt_mutex_has_waiters(lock)) {
+	if (lock->pi.boosters) {
 		struct task_struct *prev_owner = rt_mutex_owner(lock);
 
 		rtmutex_pi_owner(lock, prev_owner, 0);
 		rtmutex_pi_owner(lock, owner, 1);
+	}
 
+	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
-	}
 
 	lock->owner = (struct task_struct *)val;
 }
@@ -177,7 +178,7 @@ static inline int rtmutex_pi_update(struct pi_sink *sink,
 
 	spin_lock_irqsave(&lock->wait_lock, iflags);
 
-	if (rt_mutex_has_waiters(lock)) {
+	if (lock->pi.boosters) {
 		owner = rt_mutex_owner(lock);
 
 		if (owner && owner != RT_RW_READER) {
@@ -206,6 +207,7 @@ static void init_pi(struct rt_mutex *lock)
 	pi_node_init(&lock->pi.node);
 
 	lock->pi.prio = MAX_PRIO;
+	lock->pi.boosters = 0;
 	pi_source_init(&lock->pi.src, &lock->pi.prio);
 	pi_sink_init(&lock->pi.sink, &rtmutex_pi_sink);
 
@@ -303,6 +305,16 @@ static inline int try_to_take_rt_mutex(struct rt_mutex *lock)
 	return do_try_to_take_rt_mutex(lock, STEAL_NORMAL);
 }
 
+static inline void requeue_waiter(struct rt_mutex *lock,
+				  struct rt_mutex_waiter *waiter)
+{
+	BUG_ON(!waiter->task);
+
+	plist_del(&waiter->list_entry, &lock->wait_list);
+	plist_node_init(&waiter->list_entry, waiter->pi.prio);
+	plist_add(&waiter->list_entry, &lock->wait_list);
+}
+
 /*
  * These callbacks are invoked whenever a waiter has changed priority.
  * So we should requeue it within the lock->wait_list
@@ -343,11 +355,8 @@ static inline int rtmutex_waiter_pi_update(struct pi_sink *sink,
 	 * pi list.  Therefore, if waiter->pi.prio has changed since we
 	 * queued ourselves, requeue it.
 	 */
-	if (waiter->task && waiter->list_entry.prio != waiter->pi.prio) {
-		plist_del(&waiter->list_entry, &lock->wait_list);
-		plist_node_init(&waiter->list_entry, waiter->pi.prio);
-		plist_add(&waiter->list_entry, &lock->wait_list);
-	}
+	if (waiter->task && waiter->list_entry.prio != waiter->pi.prio)
+		requeue_waiter(lock, waiter);
 
 	spin_unlock_irqrestore(&lock->wait_lock, iflags);
 
@@ -359,20 +368,9 @@ static struct pi_sink_ops rtmutex_waiter_pi_sink = {
     .update = rtmutex_waiter_pi_update,
 };
 
-/*
- * This must be called with lock->wait_lock held.
- */
-static int add_waiter(struct rt_mutex *lock,
-		      struct rt_mutex_waiter *waiter,
-		      unsigned long *flags)
+static void boost_lock(struct rt_mutex *lock,
+		       struct rt_mutex_waiter *waiter)
 {
-	int has_waiters = rt_mutex_has_waiters(lock);
-
-	waiter->task = current;
-	waiter->lock = lock;
-	waiter->pi.prio = current->prio;
-	plist_node_init(&waiter->list_entry, waiter->pi.prio);
-	plist_add(&waiter->list_entry, &lock->wait_list);
 	pi_sink_init(&waiter->pi.sink, &rtmutex_waiter_pi_sink);
 
 	/*
@@ -397,35 +395,28 @@ static int add_waiter(struct rt_mutex *lock,
 	 * If we previously had no waiters, we are transitioning to
 	 * a mode where we need to boost the owner
 	 */
-	if (!has_waiters) {
+	if (!lock->pi.boosters) {
 		struct task_struct *owner = rt_mutex_owner(lock);
 		rtmutex_pi_owner(lock, owner, 1);
 	}
 
-	spin_unlock_irqrestore(&lock->wait_lock, *flags);
-	task_pi_update(current, 0);
-	spin_lock_irqsave(&lock->wait_lock, *flags);
-
-	return 0;
+	lock->pi.boosters++;
+	waiter->pi.boosted = 1;
 }
 
-/*
- * Remove a waiter from a lock
- *
- * Must be called with lock->wait_lock held
- */
-static void remove_waiter(struct rt_mutex *lock,
-			  struct rt_mutex_waiter *waiter)
+static void deboost_lock(struct rt_mutex *lock,
+			 struct rt_mutex_waiter *waiter,
+			 struct task_struct *p)
 {
-	struct task_struct *p = waiter->task;
+	BUG_ON(!waiter->pi.boosted);
 
-	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->task = NULL;
+	waiter->pi.boosted = 0;
+	lock->pi.boosters--;
 
 	/*
 	 * We can stop boosting the owner if there are no more waiters
 	 */
-	if (!rt_mutex_has_waiters(lock)) {
+	if (!lock->pi.boosters) {
 		struct task_struct *owner = rt_mutex_owner(lock);
 		rtmutex_pi_owner(lock, owner, 0);
 	}
@@ -446,6 +437,51 @@ static void remove_waiter(struct rt_mutex *lock,
 }
 
 /*
+ * This must be called with lock->wait_lock held.
+ */
+static void _add_waiter(struct rt_mutex *lock,
+			struct rt_mutex_waiter *waiter)
+{
+	waiter->task = current;
+	waiter->lock = lock;
+	waiter->pi.prio = current->prio;
+	plist_node_init(&waiter->list_entry, waiter->pi.prio);
+	plist_add(&waiter->list_entry, &lock->wait_list);
+}
+
+static int add_waiter(struct rt_mutex *lock,
+		      struct rt_mutex_waiter *waiter,
+		      unsigned long *flags)
+{
+	_add_waiter(lock, waiter);
+
+	boost_lock(lock, waiter);
+
+	spin_unlock_irqrestore(&lock->wait_lock, *flags);
+	task_pi_update(current, 0);
+	spin_lock_irqsave(&lock->wait_lock, *flags);
+
+	return 0;
+}
+
+/*
+ * Remove a waiter from a lock
+ *
+ * Must be called with lock->wait_lock held
+ */
+static void remove_waiter(struct rt_mutex *lock,
+			   struct rt_mutex_waiter *waiter)
+{
+	struct task_struct *p = waiter->task;
+
+	plist_del(&waiter->list_entry, &lock->wait_list);
+	waiter->task = NULL;
+
+	if (waiter->pi.boosted)
+		deboost_lock(lock, waiter, p);
+}
+
+/*
  * Wake up the next waiter on the lock.
  *
  * Remove the top waiter from the current tasks waiter list and from
@@ -558,6 +594,24 @@ static int adaptive_wait(struct rt_mutex_waiter *waiter,
 		if (orig_owner != rt_mutex_owner(waiter->lock))
 			return 0;
 
+		/* Special handling for when we are not in pi-boost mode */
+		if (!waiter->pi.boosted) {
+			/*
+			 * Are we higher priority than the owner?  If so
+			 * we should bail out immediately so that we can
+			 * pi boost them.
+			 */
+			if (current->prio < orig_owner->prio)
+				return 0;
+
+			/*
+			 * Did our priority change? If so, we need to
+			 * requeue our position in the list
+			 */
+			if (waiter->pi.prio != current->prio)
+				return 0;
+		}
+
 		/* Owner went to bed, so should we */
 		if (!task_is_current(orig_owner))
 			return 1;
@@ -599,6 +653,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	unsigned long saved_state, state, flags;
 	struct task_struct *orig_owner;
 	int missed = 0;
+	int boosted = 0;
 
 	init_waiter(&waiter);
 
@@ -631,26 +686,54 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 		}
 		missed = 1;
 
+		orig_owner = rt_mutex_owner(lock);
+
 		/*
 		 * waiter.task is NULL the first time we come here and
 		 * when we have been woken up by the previous owner
 		 * but the lock got stolen by an higher prio task.
 		 */
-		if (!waiter.task) {
-			add_waiter(lock, &waiter, &flags);
+		if (!waiter.task)
+			_add_waiter(lock, &waiter);
+
+		/*
+		 * We only need to pi-boost the owner if they are lower
+		 * priority than us.  We dont care if this is racy
+		 * against priority changes as we will break out of
+		 * the adaptive spin anytime any priority changes occur
+		 * without boosting enabled.
+		 */
+		if (!waiter.pi.boosted && current->prio < orig_owner->prio) {
+			boost_lock(lock, &waiter);
+			boosted = 1;
+
+			spin_unlock_irqrestore(&lock->wait_lock, flags);
+			task_pi_update(current, 0);
+			spin_lock_irqsave(&lock->wait_lock, flags);
+
 			/* Wakeup during boost ? */
 			if (unlikely(!waiter.task))
 				continue;
 		}
 
 		/*
+		 * If we are not currently pi-boosting the lock, we have to
+		 * monitor whether our priority changed since the last
+		 * time it was recorded and requeue ourselves if it moves.
+		 */
+		if (!waiter.pi.boosted && waiter.pi.prio != current->prio) {
+			waiter.pi.prio = current->prio;
+
+			requeue_waiter(lock, &waiter);
+		}
+
+		/*
 		 * Prevent schedule() to drop BKL, while waiting for
 		 * the lock ! We restore lock_depth when we come back.
 		 */
 		saved_flags = current->flags & PF_NOSCHED;
 		current->lock_depth = -1;
 		current->flags &= ~PF_NOSCHED;
-		orig_owner = rt_mutex_owner(lock);
 		get_task_struct(orig_owner);
 		spin_unlock_irqrestore(&lock->wait_lock, flags);
 
@@ -664,6 +747,24 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 			 * barrier which we rely upon to ensure current->state
 			 * is visible before we test waiter.task.
 			 */
+			if (waiter.task && !waiter.pi.boosted) {
+				spin_lock_irqsave(&lock->wait_lock, flags);
+
+				/*
+				 * We get here if we have not yet boosted
+				 * the lock, yet we are going to sleep. If
+				 * we are still pending (waiter.task != 0),
+				 * then go ahead and boost them now
+				 */
+				if (waiter.task) {
+					boost_lock(lock, &waiter);
+					boosted = 1;
+				}
+
+				spin_unlock_irqrestore(&lock->wait_lock, flags);
+				task_pi_update(current, 0);
+			}
+
 			if (waiter.task)
 				schedule_rt_mutex(lock);
 		} else
@@ -696,7 +797,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Undo any pi boosting, if necessary */
-	task_pi_update(current, 0);
+	if (boosted)
+		task_pi_update(current, 0);
 
 	debug_rt_mutex_free_waiter(&waiter);
 }
@@ -708,6 +810,7 @@ static void  noinline __sched
 rt_spin_lock_slowunlock(struct rt_mutex *lock)
 {
 	unsigned long flags;
+	int deboost = 0;
 
 	spin_lock_irqsave(&lock->wait_lock, flags);
 
@@ -721,12 +824,16 @@ rt_spin_lock_slowunlock(struct rt_mutex *lock)
 		return;
 	}
 
+	if (lock->pi.boosters)
+		deboost = 1;
+
 	wakeup_next_waiter(lock, 1);
 
 	spin_unlock_irqrestore(&lock->wait_lock, flags);
 
-	/* Undo pi boosting when necessary */
-	task_pi_update(current, 0);
+	if (deboost)
+		/* Undo pi boosting when necessary */
+		task_pi_update(current, 0);
 }
 
 void __lockfunc rt_spin_lock(spinlock_t *lock)
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index b0c6c16..8d4f745 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -55,6 +55,7 @@ struct rt_mutex_waiter {
 	struct {
 		struct pi_sink   sink;
 		int              prio;
+		int              boosted;
 	} pi;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 	unsigned long		ip;

