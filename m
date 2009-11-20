Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZKTEup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZKTEup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 23:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZKTEuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 23:50:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:45076 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134AbZKTEry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 23:47:54 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, peterz@infradead.org, johannes@sipsolutions.net
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/19] workqueue: introduce worker
Date: Fri, 20 Nov 2009 13:46:45 +0900
Message-Id: <1258692407-8985-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258692407-8985-1-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out worker thread related information to struct worker from
struct cpu_workqueue_struct and implement helper functions to deal
with the new struct worker.  The only change which is visible outside
is that now workqueue worker are all named "kworker/CPUID:WORKERID"
where WORKERID is allocated from per-cpu ida.

This is in preparation of concurrency managed workqueue where shared
multiple workers would be available per cpu.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |  220 +++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 157 insertions(+), 63 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dcb1c4b..4988e4d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/idr.h>
 
 /*
  * Structure fields follow one of the following exclusion rules.
@@ -46,6 +47,15 @@
  * W: workqueue_lock protected.
  */
 
+struct cpu_workqueue_struct;
+
+struct worker {
+	struct work_struct	*current_work;	/* L: work being processed */
+	struct task_struct	*task;		/* I: worker task */
+	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
+	int			id;		/* I: worker id */
+};
+
 /*
  * The per-CPU workqueue (if single thread, we always use the first
  * possible cpu).  The lower WORK_STRUCT_FLAG_BITS of
@@ -58,14 +68,14 @@ struct cpu_workqueue_struct {
 
 	struct list_head worklist;
 	wait_queue_head_t more_work;
-	struct work_struct *current_work;
+	unsigned int		cpu;
+	struct worker		*worker;
 
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	int			work_color;	/* L: current color */
 	int			flush_color;	/* L: flushing color */
 	int			nr_in_flight[WORK_COLORS];
 						/* L: nr of in_flight works */
-	struct task_struct	*thread;
 } __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
@@ -213,6 +223,9 @@ static inline void debug_work_deactivate(struct work_struct *work) { }
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
+static DEFINE_PER_CPU(struct ida, worker_ida);
+
+static int worker_thread(void *__worker);
 
 static int singlethread_cpu __read_mostly;
 
@@ -427,6 +440,105 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+static struct worker *alloc_worker(void)
+{
+	struct worker *worker;
+
+	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	return worker;
+}
+
+/**
+ * create_worker - create a new workqueue worker
+ * @cwq: cwq the new worker will belong to
+ * @bind: whether to set affinity to @cpu or not
+ *
+ * Create a new worker which is bound to @cwq.  The returned worker
+ * can be started by calling start_worker() or destroyed using
+ * destroy_worker().
+ *
+ * CONTEXT:
+ * Might sleep.  Does GFP_KERNEL allocations.
+ *
+ * RETURNS:
+ * Pointer to the newly created worker.
+ */
+static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
+{
+	int id = -1;
+	struct worker *worker = NULL;
+
+	spin_lock(&workqueue_lock);
+	while (ida_get_new(&per_cpu(worker_ida, cwq->cpu), &id)) {
+		spin_unlock(&workqueue_lock);
+		if (!ida_pre_get(&per_cpu(worker_ida, cwq->cpu), GFP_KERNEL))
+			goto fail;
+		spin_lock(&workqueue_lock);
+	}
+	spin_unlock(&workqueue_lock);
+
+	worker = alloc_worker();
+	if (!worker)
+		goto fail;
+
+	worker->cwq = cwq;
+	worker->id = id;
+
+	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
+				      cwq->cpu, id);
+	if (IS_ERR(worker->task))
+		goto fail;
+
+	if (bind)
+		kthread_bind(worker->task, cwq->cpu);
+
+	return worker;
+fail:
+	if (id >= 0) {
+		spin_lock(&workqueue_lock);
+		ida_remove(&per_cpu(worker_ida, cwq->cpu), id);
+		spin_unlock(&workqueue_lock);
+	}
+	kfree(worker);
+	return NULL;
+}
+
+/**
+ * start_worker - start a newly created worker
+ * @worker: worker to start
+ *
+ * Start @worker.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
+static void start_worker(struct worker *worker)
+{
+	wake_up_process(worker->task);
+}
+
+/**
+ * destroy_worker - destroy a workqueue worker
+ * @worker: worker to be destroyed
+ *
+ * Destroy @worker.
+ */
+static void destroy_worker(struct worker *worker)
+{
+	int cpu = worker->cwq->cpu;
+	int id = worker->id;
+
+	/* sanity check frenzy */
+	BUG_ON(worker->current_work);
+
+	kthread_stop(worker->task);
+	kfree(worker);
+
+	spin_lock(&workqueue_lock);
+	ida_remove(&per_cpu(worker_ida, cpu), id);
+	spin_unlock(&workqueue_lock);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -464,7 +576,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
 
 /**
  * process_one_work - process single work
- * @cwq: cwq to process work for
+ * @worker: self
  * @work: work to process
  *
  * Process @work.  This function contains all the logics necessary to
@@ -476,9 +588,9 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
  * CONTEXT:
  * spin_lock_irq(cwq->lock) which is released and regrabbed.
  */
-static void process_one_work(struct cpu_workqueue_struct *cwq,
-			     struct work_struct *work)
+static void process_one_work(struct worker *worker, struct work_struct *work)
 {
+	struct cpu_workqueue_struct *cwq = worker->cwq;
 	work_func_t f = work->func;
 	int work_color;
 #ifdef CONFIG_LOCKDEP
@@ -493,7 +605,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 #endif
 	/* claim and process */
 	debug_work_deactivate(work);
-	cwq->current_work = work;
+	worker->current_work = work;
 	work_color = work_flags_to_color(*work_data_bits(work));
 	list_del_init(&work->entry);
 
@@ -520,30 +632,33 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	spin_lock_irq(&cwq->lock);
 
 	/* we're done with it, release */
-	cwq->current_work = NULL;
+	worker->current_work = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
-static void run_workqueue(struct cpu_workqueue_struct *cwq)
+static void run_workqueue(struct worker *worker)
 {
+	struct cpu_workqueue_struct *cwq = worker->cwq;
+
 	spin_lock_irq(&cwq->lock);
 	while (!list_empty(&cwq->worklist)) {
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
-		process_one_work(cwq, work);
+		process_one_work(worker, work);
 	}
 	spin_unlock_irq(&cwq->lock);
 }
 
 /**
  * worker_thread - the worker thread function
- * @__cwq: cwq to serve
+ * @__worker: self
  *
  * The cwq worker thread function.
  */
-static int worker_thread(void *__cwq)
+static int worker_thread(void *__worker)
 {
-	struct cpu_workqueue_struct *cwq = __cwq;
+	struct worker *worker = __worker;
+	struct cpu_workqueue_struct *cwq = worker->cwq;
 	DEFINE_WAIT(wait);
 
 	if (cwq->wq->flags & WQ_FREEZEABLE)
@@ -562,7 +677,7 @@ static int worker_thread(void *__cwq)
 		if (kthread_should_stop())
 			break;
 
-		run_workqueue(cwq);
+		run_workqueue(worker);
 	}
 
 	return 0;
@@ -860,7 +975,7 @@ int flush_work(struct work_struct *work)
 			goto already_gone;
 		prev = &work->entry;
 	} else {
-		if (cwq->current_work != work)
+		if (!cwq->worker || cwq->worker->current_work != work)
 			goto already_gone;
 		prev = &cwq->worklist;
 	}
@@ -925,7 +1040,7 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 	int running = 0;
 
 	spin_lock_irq(&cwq->lock);
-	if (unlikely(cwq->current_work == work)) {
+	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
 		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
 		running = 1;
 	}
@@ -1188,46 +1303,13 @@ int current_is_keventd(void)
 	BUG_ON(!keventd_wq);
 
 	cwq = get_cwq(cpu, keventd_wq);
-	if (current == cwq->thread)
+	if (current == cwq->worker->task)
 		ret = 1;
 
 	return ret;
 
 }
 
-static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
-{
-	struct workqueue_struct *wq = cwq->wq;
-	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
-	struct task_struct *p;
-
-	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
-	/*
-	 * Nobody can add the work_struct to this cwq,
-	 *	if (caller is __create_workqueue)
-	 *		nobody should see this wq
-	 *	else // caller is CPU_UP_PREPARE
-	 *		cpu is not on cpu_online_map
-	 * so we can abort safely.
-	 */
-	if (IS_ERR(p))
-		return PTR_ERR(p);
-	cwq->thread = p;
-
-	return 0;
-}
-
-static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
-{
-	struct task_struct *p = cwq->thread;
-
-	if (p != NULL) {
-		if (cpu >= 0)
-			kthread_bind(p, cpu);
-		wake_up_process(p);
-	}
-}
-
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						unsigned int flags,
 						struct lock_class_key *key,
@@ -1235,7 +1317,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 {
 	bool singlethread = flags & WQ_SINGLE_THREAD;
 	struct workqueue_struct *wq;
-	int err = 0, cpu;
+	bool failed = false;
+	unsigned int cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
@@ -1273,22 +1356,26 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
+		cwq->cpu = cpu;
 		cwq->wq = wq;
 		cwq->flush_color = -1;
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		init_waitqueue_head(&cwq->more_work);
 
-		if (err || !cpu_online(cpu))
+		if (failed || !cpu_online(cpu))
 			continue;
 		if (singlethread && cpu != singlethread_cpu)
 			continue;
-		err = create_workqueue_thread(cwq, cpu);
-		start_workqueue_thread(cwq, singlethread ? -1 : cpu);
+		cwq->worker = create_worker(cwq, !singlethread);
+		if (cwq->worker)
+			start_worker(cwq->worker);
+		else
+			failed = true;
 	}
 	cpu_maps_update_done();
 
-	if (err) {
+	if (failed) {
 		destroy_workqueue(wq);
 		wq = NULL;
 	}
@@ -1324,9 +1411,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		int i;
 
 		/* cpu_add_remove_lock protects cwq->thread */
-		if (cwq->thread) {
-			kthread_stop(cwq->thread);
-			cwq->thread = NULL;
+		if (cwq->worker) {
+			destroy_worker(cwq->worker);
+			cwq->worker = NULL;
 		}
 
 		for (i = 0; i < WORK_COLORS; i++)
@@ -1360,7 +1447,8 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
+			cwq->worker = create_worker(cwq, false);
+			if (cwq->worker)
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
@@ -1369,17 +1457,18 @@ undo:
 			goto undo;
 
 		case CPU_ONLINE:
-			start_workqueue_thread(cwq, cpu);
+			kthread_bind(cwq->worker->task, cpu);
+			start_worker(cwq->worker);
 			break;
 
 		case CPU_UP_CANCELED:
-			start_workqueue_thread(cwq, -1);
+			start_worker(cwq->worker);
 		case CPU_POST_DEAD:
 			flush_workqueue(wq);
 			/* cpu_add_remove_lock protects cwq->thread */
-			if (cwq->thread) {
-				kthread_stop(cwq->thread);
-				cwq->thread = NULL;
+			if (cwq->worker) {
+				destroy_worker(cwq->worker);
+				cwq->worker = NULL;
 			}
 			break;
 		}
@@ -1437,6 +1526,8 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 
 void __init init_workqueues(void)
 {
+	unsigned int cpu;
+
 	/*
 	 * cwqs are forced aligned according to WORK_STRUCT_FLAG_BITS.
 	 * Make sure that the alignment isn't lower than that of
@@ -1446,6 +1537,9 @@ void __init init_workqueues(void)
 	BUILD_BUG_ON(__alignof__(struct cpu_workqueue_struct) <
 		     __alignof__(unsigned long long));
 
+	for_each_possible_cpu(cpu)
+		ida_init(&per_cpu(worker_ida, cpu));
+
 	singlethread_cpu = cpumask_first(cpu_possible_mask);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
-- 
1.6.4.2

