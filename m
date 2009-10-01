Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbZJAIME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbZJAIME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbZJAIMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:12:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:38413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936AbZJAIKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:42 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/19] workqueue: reimplement work flushing using linked works
Date: Thu,  1 Oct 2009 17:09:16 +0900
Message-Id: <1254384558-1018-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A work is linked to the next one by having WORK_STRUCT_LINKED bit set
and these links can be chained.  When a linked work is dispatched to a
worker, all linked works are dispatched to the worker's newly added
->scheduled queue and processed back-to-back.

Currently, as there's only single worker per cwq, having linked works
doesn't make any visible behavior difference.  This change is to
prepare for multiple shared workers per cpu.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |  152 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 131 insertions(+), 23 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 78fd6eb..a6136ca 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -25,9 +25,11 @@ typedef void (*work_func_t)(struct work_struct *work);
 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
 	WORK_STRUCT_COLOR_BIT	= 1,	/* color for workqueue flushing */
+	WORK_STRUCT_LINKED_BIT	= 2,	/* next work is linked to this one */
 
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
 	WORK_STRUCT_COLOR	= 1 << WORK_STRUCT_COLOR_BIT,
+	WORK_STRUCT_LINKED	= 1 << WORK_STRUCT_LINKED_BIT,
 
 	/*
 	 * Reserve 3bits off of cwq pointer.  This is enough and
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f10fe4a..e234604 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -50,6 +50,7 @@ struct cpu_workqueue_struct;
 
 struct worker {
 	struct work_struct	*current_work;	/* L: work being processed */
+	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
 	struct cpu_workqueue_struct *cwq;	/* I: the associated cwq */
 };
@@ -297,6 +298,8 @@ static struct worker *alloc_worker(void)
 	struct worker *worker;
 
 	worker = kzalloc(sizeof(*worker), GFP_KERNEL);
+	if (worker)
+		INIT_LIST_HEAD(&worker->scheduled);
 	return worker;
 }
 
@@ -363,12 +366,56 @@ static void destroy_worker(struct worker *worker)
 {
 	/* sanity check frenzy */
 	BUG_ON(worker->current_work);
+	BUG_ON(!list_empty(&worker->scheduled));
 
 	kthread_stop(worker->task);
 	kfree(worker);
 }
 
 /**
+ * schedule_work_to_worker - schedule linked works to a worker
+ * @worker: target worker
+ * @work: start of series of works to be scheduled
+ * @nextp: out paramter for nested worklist walking
+ *
+ * Schedule linked works starting from @work to @worker.  Work series
+ * to be scheduled starts at @work and includes any consecutive work
+ * with WORK_STRUCT_LINKED set in its predecessor.
+ *
+ * If @nextp is not NULL, it's updated to point to the next work of
+ * the last scheduled work.  This allows schedule_work_to_worker() to
+ * be nested inside outer list_for_each_entry_safe().
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
+static void schedule_work_to_worker(struct worker *worker,
+				    struct work_struct *work,
+				    struct work_struct **nextp)
+{
+	struct work_struct *n;
+
+	/*
+	 * Linked worklist will always end before the end of the list,
+	 * use NULL for list head.
+	 */
+	work = list_entry(work->entry.prev, struct work_struct, entry);
+	list_for_each_entry_safe_continue(work, n, NULL, entry) {
+		list_move_tail(&work->entry, &worker->scheduled);
+		if (!(*work_data_bits(work) & WORK_STRUCT_LINKED))
+			break;
+	}
+
+	/*
+	 * If we're already inside safe list traversal and have moved
+	 * multiple works to the scheduled queue, the next position
+	 * needs to be updated.
+	 */
+	if (nextp)
+		*nextp = n;
+}
+
+/**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
  * @work_color: color of work which left the queue
@@ -451,17 +498,25 @@ static void process_one_work(struct worker *worker, struct work_struct *work)
 	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
-static void run_workqueue(struct worker *worker)
+/**
+ * process_scheduled_works - process scheduled works
+ * @worker: self
+ *
+ * Process all scheduled works.  Please note that the scheduled list
+ * may change while processing a work, so this function repeatedly
+ * fetches a work from the top and executes it.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock) which may be released and regrabbed
+ * multiple times.
+ */
+static void process_scheduled_works(struct worker *worker)
 {
-	struct cpu_workqueue_struct *cwq = worker->cwq;
-
-	spin_lock_irq(&cwq->lock);
-	while (!list_empty(&cwq->worklist)) {
-		struct work_struct *work = list_entry(cwq->worklist.next,
+	while (!list_empty(&worker->scheduled)) {
+		struct work_struct *work = list_first_entry(&worker->scheduled,
 						struct work_struct, entry);
 		process_one_work(worker, work);
 	}
-	spin_unlock_irq(&cwq->lock);
 }
 
 /**
@@ -495,7 +550,26 @@ static int worker_thread(void *__worker)
 		if (kthread_should_stop())
 			break;
 
-		run_workqueue(worker);
+		spin_lock_irq(&cwq->lock);
+
+		while (!list_empty(&cwq->worklist)) {
+			struct work_struct *work =
+				list_first_entry(&cwq->worklist,
+						 struct work_struct, entry);
+
+			if (likely(!(*work_data_bits(work) &
+				     WORK_STRUCT_LINKED))) {
+				/* optimization path, not strictly necessary */
+				process_one_work(worker, work);
+				if (unlikely(!list_empty(&worker->scheduled)))
+					process_scheduled_works(worker);
+			} else {
+				schedule_work_to_worker(worker, work, NULL);
+				process_scheduled_works(worker);
+			}
+		}
+
+		spin_unlock_irq(&cwq->lock);
 	}
 
 	return 0;
@@ -514,23 +588,51 @@ static void wq_barrier_func(struct work_struct *work)
 
 /**
  * insert_wq_barrier - insert a barrier work
- * @cwq: cwq to insert barrier into
  * @barr: wq_barrier to insert
- * @head: insertion point
+ * @target: target work to attach @barr to
+ * @worker: worker currently executing @target, NULL if @target is not executing
+ *
+ * @barr is linked to @target such that @barr is completed only after
+ * @target finishes execution.  Please note that the ordering
+ * guarantee is observed only with respect to @target and on the local
+ * cpu.
  *
- * Insert barrier @barr into @cwq before @head.
+ * Currently, a queued barrier can't be canceled.  This is because
+ * try_to_grab_pending() can't determine whether the work to be
+ * grabbed is at the head of the queue and thus can't clear LINKED
+ * flag of the previous work while there must be a valid next work
+ * after a work with LINKED flag set.
  *
  * CONTEXT:
  * spin_lock_irq(cwq->lock).
  */
-static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
-			struct wq_barrier *barr, struct list_head *head)
+static void insert_wq_barrier(struct wq_barrier *barr,
+			      struct work_struct *target, struct worker *worker)
 {
+	struct cpu_workqueue_struct *cwq = get_wq_data(target);
+	struct list_head *head;
+	unsigned int linked = 0;
+
 	INIT_WORK(&barr->work, wq_barrier_func);
 	__set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(&barr->work));
 	init_completion(&barr->done);
 
-	insert_work(cwq, &barr->work, head, 0);
+	/*
+	 * If @target is currently being executed, schedule the
+	 * barrier to the worker; otherwise, put it after @target.
+	 */
+	if (worker)
+		head = worker->scheduled.next;
+	else {
+		unsigned long *bits = work_data_bits(target);
+
+		head = target->entry.next;
+		/* there can already be other linked works, inherit and set */
+		linked = *bits & WORK_STRUCT_LINKED;
+		*bits |= WORK_STRUCT_LINKED;
+	}
+
+	insert_work(cwq, &barr->work, head, linked);
 }
 
 /**
@@ -598,8 +700,8 @@ EXPORT_SYMBOL_GPL(flush_workqueue);
  */
 int flush_work(struct work_struct *work)
 {
+	struct worker *worker = NULL;
 	struct cpu_workqueue_struct *cwq;
-	struct list_head *prev;
 	struct wq_barrier barr;
 
 	might_sleep();
@@ -619,13 +721,14 @@ int flush_work(struct work_struct *work)
 		smp_rmb();
 		if (unlikely(cwq != get_wq_data(work)))
 			goto already_gone;
-		prev = &work->entry;
 	} else {
-		if (!cwq->worker || cwq->worker->current_work != work)
+		if (cwq->worker && cwq->worker->current_work == work)
+			worker = cwq->worker;
+		if (!worker)
 			goto already_gone;
-		prev = &cwq->worklist;
 	}
-	insert_wq_barrier(cwq, &barr, prev->next);
+
+	insert_wq_barrier(&barr, work, worker);
 	spin_unlock_irq(&cwq->lock);
 	wait_for_completion(&barr.done);
 	return 1;
@@ -680,16 +783,19 @@ static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
 	struct wq_barrier barr;
-	int running = 0;
+	struct worker *worker;
 
 	spin_lock_irq(&cwq->lock);
+
+	worker = NULL;
 	if (unlikely(cwq->worker && cwq->worker->current_work == work)) {
-		insert_wq_barrier(cwq, &barr, cwq->worklist.next);
-		running = 1;
+		worker = cwq->worker;
+		insert_wq_barrier(&barr, work, worker);
 	}
+
 	spin_unlock_irq(&cwq->lock);
 
-	if (unlikely(running))
+	if (unlikely(worker))
 		wait_for_completion(&barr.done);
 }
 
-- 
1.6.4.2

