Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936122Ab0BZMSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:18:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:43521 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936028Ab0BZMPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:15:03 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/43] workqueue: introduce global cwq and unify cwq locks
Date: Fri, 26 Feb 2010 21:23:00 +0900
Message-Id: <1267187000-18791-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one gcwq (global cwq) per each cpu and all cwqs on an cpu
point to it.  A gcwq contains a lock to be used by all cwqs on the cpu
and an ida to give IDs to workers belonging to the cpu.

This patch introduces gcwq, moves worker_ida into gcwq and make all
cwqs on the same cpu use the cpu's gcwq->lock instead of separate
locks.  gcwq->ida is now protected by gcwq->lock too.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  156 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 96 insertions(+), 60 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0562e34..0b00722 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -40,38 +40,45 @@
  *
  * I: Set during initialization and read-only afterwards.
  *
- * L: cwq->lock protected.  Access with cwq->lock held.
+ * L: gcwq->lock protected.  Access with gcwq->lock held.
  *
  * F: wq->flush_mutex protected.
  *
  * W: workqueue_lock protected.
  */
 
+struct global_cwq;
 struct cpu_workqueue_struct;
 
 struct worker {
 	struct work_struct	*current_work;	/* L: work being processed */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
 	int			id;		/* I: worker id */
 };
 
 /*
+ * Global per-cpu workqueue.
+ */
+struct global_cwq {
+	spinlock_t		lock;		/* the gcwq lock */
+	unsigned int		cpu;		/* I: the associated cpu */
+	struct ida		worker_ida;	/* L: for worker IDs */
+} ____cacheline_aligned_in_smp;
+
+/*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
  * work_struct->data are used for flags and thus cwqs need to be
  * aligned at two's power of the number of flag bits.
  */
 struct cpu_workqueue_struct {
-
-	spinlock_t lock;
-
+	struct global_cwq	*gcwq;		/* I: the associated gcwq */
 	struct list_head worklist;
 	wait_queue_head_t more_work;
-	unsigned int		cpu;
 	struct worker		*worker;
-
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
@@ -228,13 +235,19 @@ static inline void debug_work_deactivate(struct work_struct *work) { }
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
-static DEFINE_PER_CPU(struct ida, worker_ida);
 static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
+static DEFINE_PER_CPU(struct global_cwq, global_cwq);
+
 static int worker_thread(void *__worker);
 
 static int singlethread_cpu __read_mostly;
 
+static struct global_cwq *get_gcwq(unsigned int cpu)
+{
+	return &per_cpu(global_cwq, cpu);
+}
+
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
@@ -303,7 +316,7 @@ static inline struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
  * Insert @work into @cwq after @head.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
@@ -326,12 +339,13 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = target_cwq(cpu, wq);
+	struct global_cwq *gcwq = cwq->gcwq;
 	struct list_head *worklist;
 	unsigned long flags;
 
 	debug_work_activate(work);
 
-	spin_lock_irqsave(&cwq->lock, flags);
+	spin_lock_irqsave(&gcwq->lock, flags);
 	BUG_ON(!list_empty(&work->entry));
 
 	cwq->nr_in_flight[cwq->work_color]++;
@@ -344,7 +358,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	insert_work(cwq, work, worklist, work_color_to_flags(cwq->work_color));
 
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	spin_unlock_irqrestore(&gcwq->lock, flags);
 }
 
 /**
@@ -483,39 +497,41 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
 	int id = -1;
 	struct worker *worker = NULL;
 
-	spin_lock(&workqueue_lock);
-	while (ida_get_new(&per_cpu(worker_ida, cwq->cpu), &id)) {
-		spin_unlock(&workqueue_lock);
-		if (!ida_pre_get(&per_cpu(worker_ida, cwq->cpu), GFP_KERNEL))
+	spin_lock_irq(&gcwq->lock);
+	while (ida_get_new(&gcwq->worker_ida, &id)) {
+		spin_unlock_irq(&gcwq->lock);
+		if (!ida_pre_get(&gcwq->worker_ida, GFP_KERNEL))
 			goto fail;
-		spin_lock(&workqueue_lock);
+		spin_lock_irq(&gcwq->lock);
 	}
-	spin_unlock(&workqueue_lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	worker = alloc_worker();
 	if (!worker)
 		goto fail;
 
+	worker->gcwq = gcwq;
 	worker->cwq = cwq;
 	worker->id = id;
 
 	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
-				      cwq->cpu, id);
+				      gcwq->cpu, id);
 	if (IS_ERR(worker->task))
 		goto fail;
 
 	if (bind)
-		kthread_bind(worker->task, cwq->cpu);
+		kthread_bind(worker->task, gcwq->cpu);
 
 	return worker;
 fail:
 	if (id >= 0) {
-		spin_lock(&workqueue_lock);
-		ida_remove(&per_cpu(worker_ida, cwq->cpu), id);
-		spin_unlock(&workqueue_lock);
+		spin_lock_irq(&gcwq->lock);
+		ida_remove(&gcwq->worker_ida, id);
+		spin_unlock_irq(&gcwq->lock);
 	}
 	kfree(worker);
 	return NULL;
@@ -528,7 +544,7 @@ fail:
  * Start @worker.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void start_worker(struct worker *worker)
 {
@@ -543,7 +559,7 @@ static void start_worker(struct worker *worker)
  */
 static void destroy_worker(struct worker *worker)
 {
-	int cpu = worker->cwq->cpu;
+	struct global_cwq *gcwq = worker->gcwq;
 	int id = worker->id;
 
 	/* sanity check frenzy */
@@ -553,9 +569,9 @@ static void destroy_worker(struct worker *worker)
 	kthread_stop(worker->task);
 	kfree(worker);
 
-	spin_lock(&workqueue_lock);
-	ida_remove(&per_cpu(worker_ida, cpu), id);
-	spin_unlock(&workqueue_lock);
+	spin_lock_irq(&gcwq->lock);
+	ida_remove(&gcwq->worker_ida, id);
+	spin_unlock_irq(&gcwq->lock);
 }
 
 /**
@@ -573,7 +589,7 @@ static void destroy_worker(struct worker *worker)
  * nested inside outer list_for_each_entry_safe().
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void move_linked_works(struct work_struct *work, struct list_head *head,
 			      struct work_struct **nextp)
@@ -618,7 +634,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 {
@@ -665,11 +681,12 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
  * call this function to process a work.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock) which is released and regrabbed.
+ * spin_lock_irq(gcwq->lock) which is released and regrabbed.
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq = worker->cwq;
+	struct global_cwq *gcwq = cwq->gcwq;
 	work_func_t f = work->func;
 	int work_color;
 #ifdef CONFIG_LOCKDEP
@@ -688,7 +705,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	work_color = work_flags_to_color(*work_data_bits(work));
 	list_del_init(&work->entry);
 
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	BUG_ON(get_wq_data(work) != cwq);
 	work_clear_pending(work);
@@ -708,7 +725,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 		dump_stack();
 	}
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 
 	/* we're done with it, release */
 	worker->current_work = NULL;
@@ -724,7 +741,7 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
  * fetches a work from the top and executes it.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock) which may be released and regrabbed
+ * spin_lock_irq(gcwq->lock) which may be released and regrabbed
  * multiple times.
  */
 static void process_scheduled_works(struct worker *worker)
@@ -745,6 +762,7 @@ static void process_scheduled_works(struct worker *worker)
 static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
+	struct global_cwq *gcwq = worker->gcwq;
 	struct cpu_workqueue_struct *cwq = worker->cwq;
 	DEFINE_WAIT(wait);
 
@@ -758,7 +776,7 @@ static int worker_thread(void *__worker)
 		if (kthread_should_stop())
 			break;
 
-		spin_lock_irq(&cwq->lock);
+		spin_lock_irq(&gcwq->lock);
 
 		while (!list_empty(&cwq->worklist)) {
 			struct work_struct *work =
@@ -778,7 +796,7 @@ static int worker_thread(void *__worker)
 			}
 		}
 
-		spin_unlock_irq(&cwq->lock);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	return 0;
@@ -817,7 +835,7 @@ static void wq_barrier_func(struct work_struct *work)
  * underneath us, so we can't reliably determine cwq from @target.
  *
  * CONTEXT:
- * spin_lock_irq(cwq->lock).
+ * spin_lock_irq(gcwq->lock).
  */
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			      struct wq_barrier *barr,
@@ -827,7 +845,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	unsigned int linked = 0;
 
 	/*
-	 * debugobject calls are safe here even with cwq->lock locked
+	 * debugobject calls are safe here even with gcwq->lock locked
 	 * as we know for sure that this will not trigger any of the
 	 * checks and call back into the fixup functions where we
 	 * might deadlock.
@@ -897,8 +915,9 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = cwq->gcwq;
 
-		spin_lock_irq(&cwq->lock);
+		spin_lock_irq(&gcwq->lock);
 
 		if (flush_color >= 0) {
 			BUG_ON(cwq->flush_color != -1);
@@ -915,7 +934,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 			cwq->work_color = work_color;
 		}
 
-		spin_unlock_irq(&cwq->lock);
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	return wait;
@@ -1088,17 +1107,19 @@ int flush_work(struct work_struct *work)
 {
 	struct worker *worker = NULL;
 	struct cpu_workqueue_struct *cwq;
+	struct global_cwq *gcwq;
 	struct wq_barrier barr;
 
 	might_sleep();
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return 0;
+	gcwq = cwq->gcwq;
 
 	lock_map_acquire(&cwq->wq->lockdep_map);
 	lock_map_release(&cwq->wq->lockdep_map);
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
@@ -1115,12 +1136,12 @@ int flush_work(struct work_struct *work)
 	}
 
 	insert_wq_barrier(cwq, &barr, work, worker);
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 	wait_for_completion(&barr.done);
 	destroy_work_on_stack(&barr.work);
 	return 1;
 already_gone:
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flush_work);
@@ -1131,6 +1152,7 @@ EXPORT_SYMBOL_GPL(flush_work);
  */
 static int try_to_grab_pending(struct work_struct *work)
 {
+	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 	int ret = -1;
 
@@ -1145,8 +1167,9 @@ static int try_to_grab_pending(struct work_struct *work)
 	cwq = get_wq_data(work);
 	if (!cwq)
 		return ret;
+	gcwq = cwq->gcwq;
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * This work is queued, but perhaps we locked the wrong cwq.
@@ -1162,7 +1185,7 @@ static int try_to_grab_pending(struct work_struct *work)
 			ret = 1;
 		}
 	}
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	return ret;
 }
@@ -1170,10 +1193,11 @@ static int try_to_grab_pending(struct work_struct *work)
 static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
+	struct global_cwq *gcwq = cwq->gcwq;
 	struct wq_barrier barr;
 	struct worker *worker;
 
-	spin_lock_irq(&cwq->lock);
+	spin_lock_irq(&gcwq->lock);
 
 	worker = NULL;
 	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
@@ -1181,7 +1205,7 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 		insert_wq_barrier(cwq, &barr, work, worker);
 	}
 
-	spin_unlock_irq(&cwq->lock);
+	spin_unlock_irq(&gcwq->lock);
 
 	if (unlikely(worker)) {
 		wait_for_completion(&barr.done);
@@ -1525,13 +1549,13 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	 */
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct global_cwq *gcwq = get_gcwq(cpu);
 
 		BUG_ON((unsigned long)cwq & WORK_STRUCT_FLAG_MASK);
-		cwq->cpu = cpu;
+		cwq->gcwq = gcwq;
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		cwq->max_active = max_active;
-		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		INIT_LIST_HEAD(&cwq->delayed_works);
 		init_waitqueue_head(&cwq->more_work);
@@ -1705,7 +1729,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * list instead of the cwq ones.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and cwq->lock's.
+ * Grabs and releases workqueue_lock and gcwq->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -1718,16 +1742,18 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			spin_lock_irq(&cwq->lock);
-
 			if (wq->flags & WQ_FREEZEABLE)
 				cwq->max_active = 0;
-
-			spin_unlock_irq(&cwq->lock);
 		}
+
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	spin_unlock(&workqueue_lock);
@@ -1786,7 +1812,7 @@ out_unlock:
  * frozen works are transferred to their respective cwq worklists.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and cwq->lock's.
+ * Grabs and releases workqueue_lock and gcwq->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -1799,14 +1825,16 @@ void thaw_workqueues(void)
 		goto out_unlock;
 
 	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_irq(&gcwq->lock);
+
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
 			if (!(wq->flags & WQ_FREEZEABLE))
 				continue;
 
-			spin_lock_irq(&cwq->lock);
-
 			/* restore max_active and repopulate worklist */
 			cwq->max_active = wq->saved_max_active;
 
@@ -1815,9 +1843,9 @@ void thaw_workqueues(void)
 				cwq_activate_first_delayed(cwq);
 
 			wake_up(&cwq->more_work);
-
-			spin_unlock_irq(&cwq->lock);
 		}
+
+		spin_unlock_irq(&gcwq->lock);
 	}
 
 	workqueue_freezing = false;
@@ -1838,11 +1866,19 @@ void __init init_workqueues(void)
 	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
 		     __alignof__(unsigned long long));
 
-	for_each_possible_cpu(cpu)
-		ida_init(&per_cpu(worker_ida, cpu));
-
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
+
+	/* initialize gcwqs */
+	for_each_possible_cpu(cpu) {
+		struct global_cwq *gcwq = get_gcwq(cpu);
+
+		spin_lock_init(&gcwq->lock);
+		gcwq->cpu = cpu;
+
+		ida_init(&gcwq->worker_ida);
+	}
+
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
 }
-- 
1.6.4.2

