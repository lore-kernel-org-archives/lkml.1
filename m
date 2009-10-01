Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZJAINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZJAINk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZJAIKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38366 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbZJAIKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:18 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/19] workqueue: introduce worker
Date: Thu,  1 Oct 2009 17:09:15 +0900
Message-Id: <1254384558-1018-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out worker thread related information to struct worker from
struct cpu_workqueue_struct and implement helper functions to deal
with the new struct worker.  This patch only shifts things around
without any actual behavior change.  This is in preparation of
concurrency managed workqueue where shared multiple workers would be
available per cpu.

NOT_SIGNED_OFF_YET
---
 kernel/workqueue.c |  186 +++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 125 insertions(+), 61 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 269f6c5..f10fe4a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -46,6 +46,14 @@
  * W: workqueue_lock protected.
  */
 
+struct cpu_workqueue_struct;
+
+struct worker {
+	struct work_struct	*current_work;	/* L: work being processed */
+	struct task_struct	*task;		/* I: worker task */
+	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
+};
+
 /*
  * The per-CPU workqueue.  The lower WORK_STRUCT_FLAG_BITS of
  * work_struct->data are used for flags and thus cwqs need to be
@@ -57,13 +65,13 @@ struct cpu_workqueue_struct {
 
 	struct list_head worklist;
 	wait_queue_head_t more_work;
-	struct work_struct *current_work;
+	unsigned int		cpu;
+	struct worker		*worker;
 
 	int			nr_in_flight;	/* L: nr of in_flight works */
 	unsigned int		flush_color;	/* L: current flush color */
 	int			flush_cnt;	/* L: in-progress flush count */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
-	struct task_struct	*thread;
 } __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
 
 /*
@@ -89,6 +97,8 @@ struct workqueue_struct {
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
+static int worker_thread(void *__worker);
+
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
@@ -282,6 +292,82 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
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
+	struct worker *worker;
+
+	worker = alloc_worker();
+	if (!worker)
+		goto fail;
+
+	worker->cwq = cwq;
+
+	worker->task = kthread_create(worker_thread, worker, "kworker/%u",
+				      cwq->cpu);
+	if (IS_ERR(worker->task))
+		goto fail;
+
+	if (bind)
+		kthread_bind(worker->task, cwq->cpu);
+
+	return worker;
+fail:
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
+	/* sanity check frenzy */
+	BUG_ON(worker->current_work);
+
+	kthread_stop(worker->task);
+	kfree(worker);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -306,7 +392,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
 
 /**
  * process_one_work - process single work
- * @cwq: cwq to process work for
+ * @worker: self
  * @work: work to process
  *
  * Process @work.  This function contains all the logics necessary to
@@ -318,9 +404,9 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
  * CONTEXT:
  * spin_lock_irq(cwq->lock) which is released and regrabbed.
  */
-static void process_one_work(struct cpu_workqueue_struct *cwq,
-			     struct work_struct *work)
+static void process_one_work(struct worker *worker, struct work_struct *work)
 {
+	struct cpu_workqueue_struct *cwq = worker->cwq;
 	work_func_t f = work->func;
 	unsigned int work_color;
 #ifdef CONFIG_LOCKDEP
@@ -334,7 +420,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 	struct lockdep_map lockdep_map = work->lockdep_map;
 #endif
 	/* claim and process */
-	cwq->current_work = work;
+	worker->current_work = work;
 	work_color = *work_data_bits(work) & WORK_STRUCT_COLOR;
 	list_del_init(&work->entry);
 
@@ -361,30 +447,33 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
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
 
 	/* set workqueue scheduler */
@@ -406,7 +495,7 @@ static int worker_thread(void *__cwq)
 		if (kthread_should_stop())
 			break;
 
-		run_workqueue(cwq);
+		run_workqueue(worker);
 	}
 
 	return 0;
@@ -532,7 +621,7 @@ int flush_work(struct work_struct *work)
 			goto already_gone;
 		prev = &work->entry;
 	} else {
-		if (cwq->current_work != work)
+		if (!cwq->worker || cwq->worker->current_work != work)
 			goto already_gone;
 		prev = &cwq->worklist;
 	}
@@ -594,7 +683,7 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 	int running = 0;
 
 	spin_lock_irq(&cwq->lock);
-	if (unlikely(cwq->current_work == work)) {
+	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
 		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
 		running = 1;
 	}
@@ -820,45 +909,14 @@ int current_is_keventd(void)
 	return is_sched_workqueue(current);
 }
 
-static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
-{
-	struct workqueue_struct *wq = cwq->wq;
-	struct task_struct *p;
-
-	p = kthread_create(worker_thread, cwq, "%s/%d", wq->name, cpu);
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
 						const char *lock_name)
 {
 	struct workqueue_struct *wq;
-	int err = 0, cpu;
+	bool failed = false;
+	unsigned int cpu;
 
 	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
 	if (!wq)
@@ -894,19 +952,23 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	for_each_possible_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
+		cwq->cpu = cpu;
 		cwq->wq = wq;
 		spin_lock_init(&cwq->lock);
 		INIT_LIST_HEAD(&cwq->worklist);
 		init_waitqueue_head(&cwq->more_work);
 
-		if (err || !cpu_online(cpu))
+		if (failed || !cpu_online(cpu))
 			continue;
-		err = create_workqueue_thread(cwq, cpu);
-		start_workqueue_thread(cwq, cpu);
+		cwq->worker = create_worker(cwq, true);
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
@@ -941,9 +1003,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
 		/* cpu_add_remove_lock protects cwq->thread */
-		if (cwq->thread) {
-			kthread_stop(cwq->thread);
-			cwq->thread = NULL;
+		if (cwq->worker) {
+			destroy_worker(cwq->worker);
+			cwq->worker = NULL;
 		}
 		BUG_ON(cwq->nr_in_flight);
 	}
@@ -972,7 +1034,8 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
-			if (!create_workqueue_thread(cwq, cpu))
+			cwq->worker = create_worker(cwq, false);
+			if (cwq->worker)
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
 				wq->name, cpu);
@@ -981,17 +1044,18 @@ undo:
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
-- 
1.6.4.2

