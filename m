Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbZJAIOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbZJAIOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbZJAIKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbZJAIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:14 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/19] workqueue: misc/cosmetic updates
Date: Thu,  1 Oct 2009 17:09:07 +0900
Message-Id: <1254384558-1018-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following updates in preparation of concurrency managed
workqueue.  None of these changes causes any visible behavior
difference.

* Add comments and adjust indentations to data structures and several
  functions.

* Rename wq_per_cpu() to get_cwq() and swap the position of two
  parameters for consistency.  Convert a direct per_cpu_ptr() access
  to wq->cpu_wq to get_cwq().

* Update set_wq_data() such that it sets the flags part to
  WORK_STRUCT_PENDING | @extra_flags.

* Move santiy check on work->entry emptiness from queue_work_on() to
  __queue_work() which all queueing paths share.

* Make __queue_work() take @cpu and @wq instead of @cwq.

* Restructure flush_work() and __create_workqueue_key() to make them
  easier to modify.

NOT_SIGNED_OFF_YET
---
 kernel/workqueue.c |  122 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 80 insertions(+), 42 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a8a35a9..10c0cc4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -39,6 +39,16 @@
 #include "sched_workqueue.h"
 
 /*
+ * Structure fields follow one of the following exclusion rules.
+ *
+ * I: Set during initialization and read-only afterwards.
+ *
+ * L: cwq->lock protected.  Access with cwq->lock held.
+ *
+ * W: workqueue_lock protected.
+ */
+
+/*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).
  */
@@ -50,8 +60,8 @@ struct cpu_workqueue_struct {
 	wait_queue_head_t more_work;
 	struct work_struct *current_work;
 
-	struct workqueue_struct *wq;
-	struct task_struct *thread;
+	struct workqueue_struct *wq;		/* I: the owning workqueue */
+	struct task_struct	*thread;
 } ____cacheline_aligned;
 
 /*
@@ -59,13 +69,13 @@ struct cpu_workqueue_struct {
  * per-CPU workqueues:
  */
 struct workqueue_struct {
-	struct cpu_workqueue_struct *cpu_wq;
-	struct list_head list;
-	const char *name;
+	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
+	struct list_head	list;		/* W: list of all workqueues */
+	const char		*name;		/* I: workqueue name */
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
 #ifdef CONFIG_LOCKDEP
-	struct lockdep_map lockdep_map;
+	struct lockdep_map	lockdep_map;
 #endif
 };
 
@@ -96,8 +106,8 @@ static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 		? cpu_singlethread_map : cpu_populated_map;
 }
 
-static
-struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
+					    struct workqueue_struct *wq)
 {
 	if (unlikely(is_wq_single_threaded(wq)))
 		cpu = singlethread_cpu;
@@ -109,15 +119,12 @@ struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
  * - Must *only* be called if the pending flag is set
  */
 static inline void set_wq_data(struct work_struct *work,
-				struct cpu_workqueue_struct *cwq)
+			       struct cpu_workqueue_struct *cwq,
+			       unsigned long extra_flags)
 {
-	unsigned long new;
-
 	BUG_ON(!work_pending(work));
-
-	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
-	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
-	atomic_long_set(&work->data, new);
+	atomic_long_set(&work->data, (unsigned long)cwq |
+			(1UL << WORK_STRUCT_PENDING) | extra_flags);
 }
 
 static inline
@@ -142,28 +149,46 @@ void sched_workqueue_worker_sleep(struct task_struct *task)
 {
 }
 
+/**
+ * insert_work - insert a work into cwq
+ * @cwq: cwq @work belongs to
+ * @work: work to insert
+ * @head: insertion point
+ * @extra_flags: extra WORK_STRUCT_* flags to set
+ *
+ * Insert @work into @cwq after @head.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
 static void insert_work(struct cpu_workqueue_struct *cwq,
-			struct work_struct *work, struct list_head *head)
+			struct work_struct *work, struct list_head *head,
+			unsigned int extra_flags)
 {
 	trace_workqueue_insertion(cwq->thread, work);
 
-	set_wq_data(work, cwq);
+	/* we own @work, set data and link */
+	set_wq_data(work, cwq, extra_flags);
+
 	/*
 	 * Ensure that we get the right work->data if we see the
 	 * result of list_add() below, see try_to_grab_pending().
 	 */
 	smp_wmb();
+
 	list_add_tail(&work->entry, head);
 	wake_up(&cwq->more_work);
 }
 
-static void __queue_work(struct cpu_workqueue_struct *cwq,
+static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
+	struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 	unsigned long flags;
 
 	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, &cwq->worklist);
+	BUG_ON(!list_empty(&work->entry));
+	insert_work(cwq, work, &cwq->worklist, 0);
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
@@ -205,8 +230,7 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, cpu), work);
+		__queue_work(cpu, wq, work);
 		ret = 1;
 	}
 	return ret;
@@ -217,9 +241,8 @@ static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-	struct workqueue_struct *wq = cwq->wq;
 
-	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
+	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
 
 /**
@@ -263,7 +286,7 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
+		set_wq_data(work, get_cwq(raw_smp_processor_id(), wq), 0);
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -326,6 +349,12 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 	spin_unlock_irq(&cwq->lock);
 }
 
+/**
+ * worker_thread - the worker thread function
+ * @__cwq: cwq to serve
+ *
+ * The cwq worker thread function.
+ */
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
@@ -367,15 +396,25 @@ static void wq_barrier_func(struct work_struct *work)
 	complete(&barr->done);
 }
 
+/**
+ * insert_wq_barrier - insert a barrier work
+ * @cwq: cwq to insert barrier into
+ * @barr: wq_barrier to insert
+ * @head: insertion point
+ *
+ * Insert barrier @barr into @cwq before @head.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			struct wq_barrier *barr, struct list_head *head)
 {
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING, work_data_bits(&barr->work));
-
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, head);
+	insert_work(cwq, &barr->work, head, 0);
 }
 
 static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
@@ -407,9 +446,6 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  *
  * We sleep until all works which were queued on entry have been handled,
  * but we are not livelocked by new incoming ones.
- *
- * This function used to run the workqueues itself.  Now we just wait for the
- * helper threads to do it.
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
@@ -448,7 +484,6 @@ int flush_work(struct work_struct *work)
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-	prev = NULL;
 	spin_lock_irq(&cwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
@@ -457,21 +492,20 @@ int flush_work(struct work_struct *work)
 		 */
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
-			goto out;
+			goto already_gone;
 		prev = &work->entry;
 	} else {
 		if (cwq->current_work != work)
-			goto out;
+			goto already_gone;
 		prev = &cwq->worklist;
 	}
 	insert_wq_barrier(cwq, &barr, prev->next);
-out:
 	spin_unlock_irq(&cwq->lock);
-	if (!prev)
-		return 0;
-
 	wait_for_completion(&barr.done);
 	return 1;
+already_gone:
+	spin_unlock_irq(&cwq->lock);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -551,7 +585,7 @@ static void wait_on_work(struct work_struct *work)
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu(cpu, cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(get_cwq(cpu, wq), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -809,13 +843,11 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
-		return NULL;
+		goto err;
 
 	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
-	if (!wq->cpu_wq) {
-		kfree(wq);
-		return NULL;
-	}
+	if (!wq->cpu_wq)
+		goto err;
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
@@ -859,6 +891,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		wq = NULL;
 	}
 	return wq;
+err:
+	if (wq) {
+		free_percpu(wq->cpu_wq);
+		kfree(wq);
+	}
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-- 
1.6.4.2

