Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935882Ab0BZMOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:14:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:43293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935850Ab0BZMOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:20 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/43] workqueue: reimplement CPU hotplugging support using trustee
Date: Fri, 26 Feb 2010 21:23:02 +0900
Message-Id: <1267187000-18791-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement CPU hotplugging support using trustee thread.  On CPU
down, a trustee thread is created and each step of CPU down is
executed by the trustee and workqueue_cpu_callback() simply drives and
waits for trustee state transitions.

CPU down operation no longer waits for works to be drained but trustee
sticks around till all pending works have been completed.  If CPU is
brought back up while works are still draining,
workqueue_cpu_callback() tells trustee to step down and rebinds
workers to the cpu.

As it's difficult to tell whether cwqs are empty if it's freezing or
frozen, trustee doesn't consider draining to be complete while a gcwq
is freezing or frozen (tracked by new GCWQ_FREEZING flag).  Also,
workers which get unbound from their cpu are marked with WORKER_ROGUE.

Trustee based implementation doesn't bring any new feature at this
point but it will be used to manage worker pool when dynamic shared
worker pool is implemented.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  296 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 281 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fe1f3a8..962b623 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -36,14 +36,27 @@
 #include <linux/idr.h>
 
 enum {
+	/* global_cwq flags */
+	GCWQ_FREEZING		= 1 << 3,	/* freeze in progress */
+
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
+	WORKER_ROGUE		= 1 << 4,	/* not bound to any cpu */
+
+	/* gcwq->trustee_state */
+	TRUSTEE_START		= 0,		/* start */
+	TRUSTEE_IN_CHARGE	= 1,		/* trustee in charge of gcwq */
+	TRUSTEE_BUTCHER		= 2,		/* butcher workers */
+	TRUSTEE_RELEASE		= 3,		/* release workers */
+	TRUSTEE_DONE		= 4,		/* trustee is done */
 
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 	BUSY_WORKER_HASH_SIZE	= 1 << BUSY_WORKER_HASH_ORDER,
 	BUSY_WORKER_HASH_MASK	= BUSY_WORKER_HASH_SIZE - 1,
+
+	TRUSTEE_COOLDOWN	= HZ / 10,	/* for trustee draining */
 };
 
 /*
@@ -83,6 +96,7 @@ struct worker {
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
 	unsigned int		cpu;		/* I: the associated cpu */
+	unsigned int		flags;		/* L: GCWQ_* flags */
 
 	int			nr_workers;	/* L: total number of workers */
 	int			nr_idle;	/* L: currently idle ones */
@@ -93,6 +107,10 @@ struct global_cwq {
 						/* L: hash of busy workers */
 
 	struct ida		worker_ida;	/* L: for worker IDs */
+
+	struct task_struct	*trustee;	/* L: for gcwq shutdown */
+	unsigned int		trustee_state;	/* L: trustee state */
+	wait_queue_head_t	trustee_wait;	/* trustee wait */
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -148,6 +166,10 @@ struct workqueue_struct {
 #endif
 };
 
+#define for_each_busy_worker(worker, i, pos, gcwq)			\
+	for (i = 0; i < BUSY_WORKER_HASH_SIZE; i++)			\
+		hlist_for_each_entry(worker, pos, &gcwq->busy_hash[i], hentry)
+
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
 static struct debug_obj_descr work_debug_descr;
@@ -546,6 +568,9 @@ static void worker_enter_idle(struct worker *worker)
 
 	/* idle_list is LIFO */
 	list_add(&worker->entry, &gcwq->idle_list);
+
+	if (unlikely(worker->flags & WORKER_ROGUE))
+		wake_up_all(&gcwq->trustee_wait);
 }
 
 /**
@@ -622,8 +647,15 @@ static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	/*
+	 * A rogue worker will become a regular one if CPU comes
+	 * online later on.  Make sure every worker has
+	 * PF_THREAD_BOUND set.
+	 */
 	if (bind)
 		kthread_bind(worker->task, gcwq->cpu);
+	else
+		worker->task->flags |= PF_THREAD_BOUND;
 
 	return worker;
 fail:
@@ -1769,34 +1801,259 @@ void destroy_workqueue(struct workqueue_struct *wq)
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
+/*
+ * CPU hotplug.
+ *
+ * CPU hotplug is implemented by allowing cwqs to be detached from
+ * CPU, running with unbound workers and allowing them to be
+ * reattached later if the cpu comes back online.  A separate thread
+ * is created to govern cwqs in such state and is called the trustee.
+ *
+ * Trustee states and their descriptions.
+ *
+ * START	Command state used on startup.  On CPU_DOWN_PREPARE, a
+ *		new trustee is started with this state.
+ *
+ * IN_CHARGE	Once started, trustee will enter this state after
+ *		making all existing workers rogue.  DOWN_PREPARE waits
+ *		for trustee to enter this state.  After reaching
+ *		IN_CHARGE, trustee tries to execute the pending
+ *		worklist until it's empty and the state is set to
+ *		BUTCHER, or the state is set to RELEASE.
+ *
+ * BUTCHER	Command state which is set by the cpu callback after
+ *		the cpu has went down.  Once this state is set trustee
+ *		knows that there will be no new works on the worklist
+ *		and once the worklist is empty it can proceed to
+ *		killing idle workers.
+ *
+ * RELEASE	Command state which is set by the cpu callback if the
+ *		cpu down has been canceled or it has come online
+ *		again.  After recognizing this state, trustee stops
+ *		trying to drain or butcher and transits to DONE.
+ *
+ * DONE		Trustee will enter this state after BUTCHER or RELEASE
+ *		is complete.
+ *
+ *          trustee                 CPU                draining
+ *         took over                down               complete
+ * START -----------> IN_CHARGE -----------> BUTCHER -----------> DONE
+ *                        |                     |                  ^
+ *                        | CPU is back online  v   return workers |
+ *                         ----------------> RELEASE --------------
+ */
+
+/**
+ * trustee_wait_event_timeout - timed event wait for trustee
+ * @cond: condition to wait for
+ * @timeout: timeout in jiffies
+ *
+ * wait_event_timeout() for trustee to use.  Handles locking and
+ * checks for RELEASE request.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by trustee.
+ *
+ * RETURNS:
+ * Positive indicating left time if @cond is satisfied, 0 if timed
+ * out, -1 if canceled.
+ */
+#define trustee_wait_event_timeout(cond, timeout) ({			\
+	long __ret = (timeout);						\
+	while (!((cond) || (gcwq->trustee_state == TRUSTEE_RELEASE)) &&	\
+	       __ret) {							\
+		spin_unlock_irq(&gcwq->lock);				\
+		__wait_event_timeout(gcwq->trustee_wait, (cond) ||	\
+			(gcwq->trustee_state == TRUSTEE_RELEASE),	\
+			__ret);						\
+		spin_lock_irq(&gcwq->lock);				\
+	}								\
+	gcwq->trustee_state == TRUSTEE_RELEASE ? -1 : (__ret);		\
+})
+
+/**
+ * trustee_wait_event - event wait for trustee
+ * @cond: condition to wait for
+ *
+ * wait_event() for trustee to use.  Automatically handles locking and
+ * checks for CANCEL request.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by trustee.
+ *
+ * RETURNS:
+ * 0 if @cond is satisfied, -1 if canceled.
+ */
+#define trustee_wait_event(cond) ({					\
+	long __ret1;							\
+	__ret1 = trustee_wait_event_timeout(cond, MAX_SCHEDULE_TIMEOUT);\
+	__ret1 < 0 ? -1 : 0;						\
+})
+
+static bool __cpuinit trustee_unset_rogue(struct worker *worker)
+{
+	struct global_cwq *gcwq = worker->gcwq;
+	int rc;
+
+	if (!(worker->flags & WORKER_ROGUE))
+		return false;
+
+	spin_unlock_irq(&gcwq->lock);
+	rc = __set_cpus_allowed(worker->task, get_cpu_mask(gcwq->cpu), true);
+	BUG_ON(rc);
+	spin_lock_irq(&gcwq->lock);
+	worker->flags &= ~WORKER_ROGUE;
+	return true;
+}
+
+static int __cpuinit trustee_thread(void *__gcwq)
+{
+	struct global_cwq *gcwq = __gcwq;
+	struct worker *worker;
+	struct hlist_node *pos;
+	int i;
+
+	BUG_ON(gcwq->cpu != smp_processor_id());
+
+	spin_lock_irq(&gcwq->lock);
+	/*
+	 * Make all multithread workers rogue.  Trustee must be bound
+	 * to the target cpu and can't be cancelled.
+	 */
+	BUG_ON(gcwq->cpu != smp_processor_id());
+
+	list_for_each_entry(worker, &gcwq->idle_list, entry)
+		if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
+			worker->flags |= WORKER_ROGUE;
+
+	for_each_busy_worker(worker, i, pos, gcwq)
+		if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD))
+			worker->flags |= WORKER_ROGUE;
+
+	/*
+	 * We're now in charge.  Notify and proceed to drain.  We need
+	 * to keep the gcwq running during the whole CPU down
+	 * procedure as other cpu hotunplug callbacks may need to
+	 * flush currently running tasks.
+	 */
+	gcwq->trustee_state = TRUSTEE_IN_CHARGE;
+	wake_up_all(&gcwq->trustee_wait);
+
+	/*
+	 * The original cpu is in the process of dying and may go away
+	 * anytime now.  When that happens, we and all workers would
+	 * be migrated to other cpus.  Try draining any left work.
+	 * Note that if the gcwq is frozen, there may be frozen works
+	 * in freezeable cwqs.  Don't declare completion while frozen.
+	 */
+	while (gcwq->nr_workers != gcwq->nr_idle ||
+	       gcwq->flags & GCWQ_FREEZING ||
+	       gcwq->trustee_state == TRUSTEE_IN_CHARGE) {
+		/* give a breather */
+		if (trustee_wait_event_timeout(false, TRUSTEE_COOLDOWN) < 0)
+			break;
+	}
+
+	/* notify completion */
+	gcwq->trustee = NULL;
+	gcwq->trustee_state = TRUSTEE_DONE;
+	wake_up_all(&gcwq->trustee_wait);
+	spin_unlock_irq(&gcwq->lock);
+	return 0;
+}
+
+/**
+ * wait_trustee_state - wait for trustee to enter the specified state
+ * @gcwq: gcwq the trustee of interest belongs to
+ * @state: target state to wait for
+ *
+ * Wait for the trustee to reach @state.  DONE is already matched.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * multiple times.  To be used by cpu_callback.
+ */
+static void __cpuinit wait_trustee_state(struct global_cwq *gcwq, int state)
+{
+	if (!(gcwq->trustee_state == state ||
+	      gcwq->trustee_state == TRUSTEE_DONE)) {
+		spin_unlock_irq(&gcwq->lock);
+		__wait_event(gcwq->trustee_wait,
+			     gcwq->trustee_state == state ||
+			     gcwq->trustee_state == TRUSTEE_DONE);
+		spin_lock_irq(&gcwq->lock);
+	}
+}
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
-	struct cpu_workqueue_struct *cwq;
-	struct workqueue_struct *wq;
+	struct global_cwq *gcwq = get_gcwq(cpu);
+	struct task_struct *new_trustee = NULL;
+	struct worker *worker;
+	struct hlist_node *pos;
+	int i;
 
 	action &= ~CPU_TASKS_FROZEN;
 
-	list_for_each_entry(wq, &workqueues, list) {
-		if (wq->flags & WQ_SINGLE_THREAD)
-			continue;
-
-		cwq = get_cwq(cpu, wq);
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+		new_trustee = kthread_create(trustee_thread, gcwq,
+					     "workqueue_trustee/%d\n", cpu);
+		if (IS_ERR(new_trustee))
+			return NOTIFY_BAD;
+		kthread_bind(new_trustee, cpu);
+	}
 
-		switch (action) {
-		case CPU_ONLINE:
-			__set_cpus_allowed(cwq->worker->task,
-					   get_cpu_mask(cpu), true);
-			break;
+	spin_lock_irq(&gcwq->lock);
 
-		case CPU_POST_DEAD:
-			flush_workqueue(wq);
-			break;
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+		/* initialize trustee and tell it to acquire the gcwq */
+		BUG_ON(gcwq->trustee || gcwq->trustee_state != TRUSTEE_DONE);
+		gcwq->trustee = new_trustee;
+		gcwq->trustee_state = TRUSTEE_START;
+		wake_up_process(gcwq->trustee);
+		wait_trustee_state(gcwq, TRUSTEE_IN_CHARGE);
+		break;
+
+	case CPU_POST_DEAD:
+		gcwq->trustee_state = TRUSTEE_BUTCHER;
+		break;
+
+	case CPU_DOWN_FAILED:
+	case CPU_ONLINE:
+		if (gcwq->trustee_state != TRUSTEE_DONE) {
+			gcwq->trustee_state = TRUSTEE_RELEASE;
+			wake_up_process(gcwq->trustee);
+			wait_trustee_state(gcwq, TRUSTEE_DONE);
 		}
+
+		/*
+		 * Clear ROGUE from and rebind all multithread
+		 * workers.  Unsetting ROGUE and rebinding require
+		 * dropping gcwq->lock.  Restart loop after each
+		 * successful release.
+		 */
+	recheck:
+		list_for_each_entry(worker, &gcwq->idle_list, entry)
+			if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD) &&
+			    trustee_unset_rogue(worker))
+				goto recheck;
+
+		for_each_busy_worker(worker, i, pos, gcwq)
+			if (!(worker->cwq->wq->flags & WQ_SINGLE_THREAD) &&
+			    trustee_unset_rogue(worker))
+				goto recheck;
+		break;
 	}
 
+	spin_unlock_irq(&gcwq->lock);
+
 	return NOTIFY_OK;
 }
 
@@ -1874,6 +2131,9 @@ void freeze_workqueues_begin(void)
 
 		spin_lock_irq(&gcwq->lock);
 
+		BUG_ON(gcwq->flags & GCWQ_FREEZING);
+		gcwq->flags |= GCWQ_FREEZING;
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
@@ -1957,6 +2217,9 @@ void thaw_workqueues(void)
 
 		spin_lock_irq(&gcwq->lock);
 
+		BUG_ON(!(gcwq->flags & GCWQ_FREEZING));
+		gcwq->flags &= ~GCWQ_FREEZING;
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
@@ -2010,6 +2273,9 @@ void __init init_workqueues(void)
 			INIT_HLIST_HEAD(&gcwq->busy_hash[i]);
 
 		ida_init(&gcwq->worker_ida);
+
+		gcwq->trustee_state = TRUSTEE_DONE;
+		init_waitqueue_head(&gcwq->trustee_wait);
 	}
 
 	keventd_wq = create_workqueue("events");
-- 
1.6.4.2

