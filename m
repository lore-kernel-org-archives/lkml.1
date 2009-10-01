Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZJAIKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZJAIKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932084AbZJAIKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:38411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZJAIKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:40 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/19] workqueue: reimplement workqueue flushing using color coded works
Date: Thu,  1 Oct 2009 17:09:14 +0900
Message-Id: <1254384558-1018-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement workqueue flushing using color coded works.  There are two
colors and each cwq has the current color which is painted on the
works being issued via the cwq.  Flushing a workqueue is achieved by
flipping the current colors of each cwq and wait for the works which
have the old color to drain.  This new implementation is to allow
having and sharing multiple workers per cpu.  One restriction this
implementation has is that there can only be single workqueue flushing
in progress at any given time.  If one is in progress, others should
wait for their turn.

This new flush implementation leaves only cleanup_workqueue_thread()
as the user of flush_cpu_workqueue().  Just make its users use
flush_workqueue() and kthread_stop() directly and kill
cleanup_workqueue_thread().  As workqueue flushing doesn't use barrier
request anymore, the comment describing the complex synchronization
around it in cleanup_workqueue_thread() is removed together with the
function.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |  151 ++++++++++++++++++++++++++++-----------------
 2 files changed, 97 insertions(+), 56 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 5aa0e15..78fd6eb 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -24,8 +24,10 @@ typedef void (*work_func_t)(struct work_struct *work);
 
 enum {
 	WORK_STRUCT_PENDING_BIT	= 0,	/* work item is pending execution */
+	WORK_STRUCT_COLOR_BIT	= 1,	/* color for workqueue flushing */
 
 	WORK_STRUCT_PENDING	= 1 << WORK_STRUCT_PENDING_BIT,
+	WORK_STRUCT_COLOR	= 1 << WORK_STRUCT_COLOR_BIT,
 
 	/*
 	 * Reserve 3bits off of cwq pointer.  This is enough and
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6370c9b..269f6c5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -59,6 +59,9 @@ struct cpu_workqueue_struct {
 	wait_queue_head_t more_work;
 	struct work_struct *current_work;
 
+	int			nr_in_flight;	/* L: nr of in_flight works */
+	unsigned int		flush_color;	/* L: current flush color */
+	int			flush_cnt;	/* L: in-progress flush count */
 	struct workqueue_struct *wq;		/* I: the owning workqueue */
 	struct task_struct	*thread;
 } __attribute__((aligned(1 << WORK_STRUCT_FLAG_BITS)));
@@ -71,6 +74,11 @@ struct workqueue_struct {
 	unsigned int		flags;		/* I: WQ_* flags */
 	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
 	struct list_head	list;		/* W: list of all workqueues */
+
+	struct mutex		flush_mutex;	/* single flush at a time */
+	atomic_t		nr_cwqs_to_flush; /* flush in progress */
+	struct completion	*flush_done;	/* flush done */
+
 	const char		*name;		/* I: workqueue name */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
@@ -138,8 +146,10 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
 			unsigned int extra_flags)
 {
+	cwq->nr_in_flight++;
+
 	/* we own @work, set data and link */
-	set_wq_data(work, cwq, extra_flags);
+	set_wq_data(work, cwq, cwq->flush_color | extra_flags);
 
 	/*
 	 * Ensure that we get the right work->data if we see the
@@ -273,6 +283,28 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
 /**
+ * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
+ * @cwq: cwq of interest
+ * @work_color: color of work which left the queue
+ *
+ * A work either has completed or is removed from pending queue,
+ * decrement nr_in_flight of its cwq and handle workqueue flushing.
+ *
+ * CONTEXT:
+ * spin_lock_irq(cwq->lock).
+ */
+static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq,
+				 unsigned int work_color)
+{
+	cwq->nr_in_flight--;
+	if (unlikely(cwq->flush_cnt)) {
+		if (work_color ^ cwq->flush_color && !--cwq->flush_cnt &&
+		    atomic_dec_and_test(&cwq->wq->nr_cwqs_to_flush))
+			complete(cwq->wq->flush_done);
+	}
+}
+
+/**
  * process_one_work - process single work
  * @cwq: cwq to process work for
  * @work: work to process
@@ -290,6 +322,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 			     struct work_struct *work)
 {
 	work_func_t f = work->func;
+	unsigned int work_color;
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
@@ -302,6 +335,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 #endif
 	/* claim and process */
 	cwq->current_work = work;
+	work_color = *work_data_bits(work) & WORK_STRUCT_COLOR;
 	list_del_init(&work->entry);
 
 	spin_unlock_irq(&cwq->lock);
@@ -328,6 +362,7 @@ static void process_one_work(struct cpu_workqueue_struct *cwq,
 
 	/* we're done with it, release */
 	cwq->current_work = NULL;
+	cwq_dec_nr_in_flight(cwq, work_color);
 }
 
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
@@ -409,26 +444,6 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	insert_work(cwq, &barr->work, head, 0);
 }
 
-static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
-{
-	int active = 0;
-	struct wq_barrier barr;
-
-	WARN_ON(cwq->thread == current);
-
-	spin_lock_irq(&cwq->lock);
-	if (!list_empty(&cwq->worklist) || cwq->current_work != NULL) {
-		insert_wq_barrier(cwq, &barr, &cwq->worklist);
-		active = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
-
-	if (active)
-		wait_for_completion(&barr.done);
-
-	return active;
-}
-
 /**
  * flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
@@ -441,13 +456,44 @@ static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
-	int cpu;
+	DECLARE_COMPLETION_ONSTACK(flush_done);
+	bool wait = false;
+	unsigned int cpu;
 
-	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_possible_cpu(cpu)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+
+	/* only single flush can be in progress at any given time */
+	mutex_lock(&wq->flush_mutex);
+
+	BUG_ON(atomic_read(&wq->nr_cwqs_to_flush) || wq->flush_done);
+
+	wq->flush_done = &flush_done;
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		spin_lock_irq(&cwq->lock);
+
+		BUG_ON(cwq->flush_cnt);
+
+		cwq->flush_color ^= WORK_STRUCT_COLOR;
+		cwq->flush_cnt = cwq->nr_in_flight;
+
+		if (cwq->flush_cnt) {
+			atomic_inc(&wq->nr_cwqs_to_flush);
+			wait = true;
+		}
+
+		spin_unlock_irq(&cwq->lock);
+	}
+
+	if (wait)
+		wait_for_completion(&flush_done);
+
+	wq->flush_done = NULL;
+
+	mutex_unlock(&wq->flush_mutex);
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -531,6 +577,8 @@ static int try_to_grab_pending(struct work_struct *work)
 		smp_rmb();
 		if (cwq == get_wq_data(work)) {
 			list_del_init(&work->entry);
+			cwq_dec_nr_in_flight(cwq,
+				*work_data_bits(work) & WORK_STRUCT_COLOR);
 			ret = 1;
 		}
 	}
@@ -821,6 +869,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		goto err;
 
 	wq->flags = flags;
+	mutex_init(&wq->flush_mutex);
+	atomic_set(&wq->nr_cwqs_to_flush, 0);
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	INIT_LIST_HEAD(&wq->list);
@@ -842,7 +892,7 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	 * lock.
 	 */
 	for_each_possible_cpu(cpu) {
-		struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
 		cwq->wq = wq;
 		spin_lock_init(&cwq->lock);
@@ -870,33 +920,6 @@ err:
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
 
-static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
-{
-	/*
-	 * Our caller is either destroy_workqueue() or CPU_POST_DEAD,
-	 * cpu_add_remove_lock protects cwq->thread.
-	 */
-	if (cwq->thread == NULL)
-		return;
-
-	lock_map_acquire(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
-
-	flush_cpu_workqueue(cwq);
-	/*
-	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
-	 * a concurrent flush_workqueue() can insert a barrier after us.
-	 * However, in that case run_workqueue() won't return and check
-	 * kthread_should_stop() until it flushes all work_struct's.
-	 * When ->worklist becomes empty it is safe to exit because no
-	 * more work_structs can be queued on this cwq: flush_workqueue
-	 * checks list_empty(), and a "normal" queue_work() can't use
-	 * a dead CPU.
-	 */
-	kthread_stop(cwq->thread);
-	cwq->thread = NULL;
-}
-
 /**
  * destroy_workqueue - safely terminate a workqueue
  * @wq: target workqueue
@@ -912,8 +935,19 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_possible_cpu(cpu)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
+	flush_workqueue(wq);
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+
+		/* cpu_add_remove_lock protects cwq->thread */
+		if (cwq->thread) {
+			kthread_stop(cwq->thread);
+			cwq->thread = NULL;
+		}
+		BUG_ON(cwq->nr_in_flight);
+	}
+
  	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
@@ -953,7 +987,12 @@ undo:
 		case CPU_UP_CANCELED:
 			start_workqueue_thread(cwq, -1);
 		case CPU_POST_DEAD:
-			cleanup_workqueue_thread(cwq);
+			flush_workqueue(wq);
+			/* cpu_add_remove_lock protects cwq->thread */
+			if (cwq->thread) {
+				kthread_stop(cwq->thread);
+				cwq->thread = NULL;
+			}
 			break;
 		}
 	}
-- 
1.6.4.2

