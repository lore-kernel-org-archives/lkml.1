Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbXERUf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbXERUf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbXERUfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:35:05 -0400
Received: from mail.screens.ru ([213.234.233.54]:40523 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321AbXERUfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:35:03 -0400
Date: Sat, 19 May 2007 00:34:29 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zilvinas Valinskas <zilvinas@wilibox.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] simplify cleanup_workqueue_thread()
Message-ID: <20070518203429.GA325@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup_workqueue_thread() and cwq_should_stop() are overcomplicated. Convert
the code to use kthread_should_stop/kthread_stop as was suggested by Gautham
and Srivatsa.

In particular this patch removes the (unlikely) busy-wait loop from the exit
path, it was a temporary and ugly kludge (if not a bug).

Note: the current code was designed to solve another old problem: work->func
can't share locks with hotplug callbacks. I think this could be done, see

	http://marc.info/?l=linux-kernel&m=116905366428633

but this needs some more complications to preserve CPU affinity of cwq->thread
during cpu_up(). A freezer-based hotplug looks more appealing.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~1_KILL_CRAP	2007-05-13 15:19:54.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-18 00:12:05.000000000 +0400
@@ -47,7 +47,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	int should_stop;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -71,7 +70,13 @@ static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
 static cpumask_t cpu_singlethread_map __read_mostly;
-/* optimization, we could use cpu_possible_map */
+/*
+ * _cpu_down() first removes CPU from cpu_online_map, then CPU_DEAD
+ * flushes cwq->worklist. This means that flush_workqueue/wait_on_work
+ * which comes in between can't use for_each_online_cpu(). We could
+ * use cpu_possible_map, the cpumask below is more a documentation
+ * than optimization.
+ */
 static cpumask_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
@@ -272,24 +277,6 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irq(&cwq->lock);
 }
 
-/*
- * NOTE: the caller must not touch *cwq if this func returns true
- */
-static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
-{
-	int should_stop = cwq->should_stop;
-
-	if (unlikely(should_stop)) {
-		spin_lock_irq(&cwq->lock);
-		should_stop = cwq->should_stop && list_empty(&cwq->worklist);
-		if (should_stop)
-			cwq->thread = NULL;
-		spin_unlock_irq(&cwq->lock);
-	}
-
-	return should_stop;
-}
-
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
@@ -302,14 +289,15 @@ static int worker_thread(void *__cwq)
 
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!freezing(current) && !cwq->should_stop
-		    && list_empty(&cwq->worklist))
+		if (!freezing(current) &&
+		    !kthread_should_stop() &&
+		    list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
 		try_to_freeze();
 
-		if (cwq_should_stop(cwq))
+		if (kthread_should_stop())
 			break;
 
 		run_workqueue(cwq);
@@ -340,7 +328,7 @@ static void insert_wq_barrier(struct cpu
 	insert_work(cwq, &barr->work, tail);
 }
 
-static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
+static int flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	if (cwq->thread == current) {
 		/*
@@ -348,6 +336,7 @@ static void flush_cpu_workqueue(struct c
 		 * it by hand rather than deadlocking.
 		 */
 		run_workqueue(cwq);
+		return 1;
 	} else {
 		struct wq_barrier barr;
 		int active = 0;
@@ -361,6 +350,8 @@ static void flush_cpu_workqueue(struct c
 
 		if (active)
 			wait_for_completion(&barr.done);
+
+		return active;
 	}
 }
 
@@ -674,7 +665,6 @@ static int create_workqueue_thread(struc
 		return PTR_ERR(p);
 
 	cwq->thread = p;
-	cwq->should_stop = 0;
 
 	return 0;
 }
@@ -740,29 +730,27 @@ EXPORT_SYMBOL_GPL(__create_workqueue);
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct wq_barrier barr;
-	int alive = 0;
-
-	spin_lock_irq(&cwq->lock);
-	if (cwq->thread != NULL) {
-		insert_wq_barrier(cwq, &barr, 1);
-		cwq->should_stop = 1;
-		alive = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
+	/*
+	 * Our caller is either destroy_workqueue() or CPU_DEAD,
+	 * workqueue_mutex protects cwq->thread
+	 */
+	if (cwq->thread == NULL)
+		return;
 
-	if (alive) {
-		wait_for_completion(&barr.done);
+	/*
+	 * If the caller is CPU_DEAD the single flush_cpu_workqueue()
+	 * is not enough, a concurrent flush_workqueue() can insert a
+	 * barrier after us.
+	 * When ->worklist becomes empty it is safe to exit because no
+	 * more work_structs can be queued on this cwq: flush_workqueue
+	 * checks list_empty(), and a "normal" queue_work() can't use
+	 * a dead CPU.
+	 */
+	while (flush_cpu_workqueue(cwq))
+		;
 
-		while (unlikely(cwq->thread != NULL))
-			cpu_relax();
-		/*
-		 * Wait until cwq->thread unlocks cwq->lock,
-		 * it won't touch *cwq after that.
-		 */
-		smp_rmb();
-		spin_unlock_wait(&cwq->lock);
-	}
+	kthread_stop(cwq->thread);
+	cwq->thread = NULL;
 }
 
 /**

