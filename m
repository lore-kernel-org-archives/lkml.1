Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbXECUnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbXECUnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766499AbXECUnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:43:09 -0400
Received: from mail.screens.ru ([213.234.233.54]:56145 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031304AbXECUnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:43:07 -0400
Date: Fri, 4 May 2007 00:42:26 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] make cancel_rearming_delayed_work() reliable
Message-ID: <20070503204226.GA212@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Jarek Poplawski for the ideas and for spotting the bug in the
initial draft patch.

cancel_rearming_delayed_work() currently has many limitations, because it
requires that dwork always re-arms itself via queue_delayed_work(). So it
hangs forever if dwork doesn't do this, or cancel_rearming_delayed_work/
cancel_delayed_work was already called. It uses flush_workqueue() in a loop,
so it can't be used if workqueue was freezed, and it is potentially live-
lockable on busy system if delay is small.

With this patch cancel_rearming_delayed_work() doesn't make any assumptions
about dwork, it can re-arm itself via queue_delayed_work(), or queue_work(),
or do nothing.

As a "side effect", cancel_work_sync() was changed to handle re-arming works
as well.

Disadvantages:

	- this patch adds wmb() to insert_work().

	- slowdowns the fast path (when del_timer() succeeds on entry) of
	  cancel_rearming_delayed_work(), because wait_on_work() is called
	  unconditionally. In that case, compared to the old version, we are
	  doing "unneeded" lock/unlock for each online CPU.

	  On the other hand, this means we don't need to use cancel_work_sync()
	  after cancel_rearming_delayed_work().

	- complicates the code (.text grows by 130 bytes).

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- OLD/kernel/workqueue.c~1_CRDW	2007-05-02 23:29:07.000000000 +0400
+++ OLD/kernel/workqueue.c	2007-05-03 22:42:29.000000000 +0400
@@ -120,6 +120,11 @@ static void insert_work(struct cpu_workq
 				struct work_struct *work, int tail)
 {
 	set_wq_data(work, cwq);
+	/*
+	 * Ensure that we get the right work->data if we see the
+	 * result of list_add() below, see try_to_grab_pending().
+	 */
+	smp_wmb();
 	if (tail)
 		list_add_tail(&work->entry, &cwq->worklist);
 	else
@@ -381,7 +386,46 @@ void fastcall flush_workqueue(struct wor
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
-static void wait_on_work(struct cpu_workqueue_struct *cwq,
+/*
+ * Upon a successfull return, the caller "owns" WORK_STRUCT_PENDING bit,
+ * so this work can't be re-armed in any way.
+ */
+static int try_to_grab_pending(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq;
+	int ret = 0;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work)))
+		return 1;
+
+	/*
+	 * The queueing is in progress, or it is already queued. Try to
+	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
+	 */
+
+	cwq = get_wq_data(work);
+	if (!cwq)
+		return ret;
+
+	spin_lock_irq(&cwq->lock);
+	if (!list_empty(&work->entry)) {
+		/*
+		 * This work is queued, but perhaps we locked the wrong cwq.
+		 * In that case we must see the new value after rmb(), see
+		 * insert_work()->wmb().
+		 */
+		smp_rmb();
+		if (cwq == get_wq_data(work)) {
+			list_del_init(&work->entry);
+			ret = 1;
+		}
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	return ret;
+}
+
+static void wait_on_cpu_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work)
 {
 	struct wq_barrier barr;
@@ -398,20 +442,7 @@ static void wait_on_work(struct cpu_work
 		wait_for_completion(&barr.done);
 }
 
-/**
- * cancel_work_sync - block until a work_struct's callback has terminated
- * @work: the work which is to be flushed
- *
- * cancel_work_sync() will attempt to cancel the work if it is queued. If the
- * work's callback appears to be running, cancel_work_sync() will block until
- * it has completed.
- *
- * cancel_work_sync() is designed to be used when the caller is tearing down
- * data structures which the callback function operates upon. It is expected
- * that, prior to calling cancel_work_sync(), the caller has arranged for the
- * work to not be requeued.
- */
-void cancel_work_sync(struct work_struct *work)
+static void wait_on_work(struct work_struct *work)
 {
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
@@ -421,29 +452,59 @@ void cancel_work_sync(struct work_struct
 	might_sleep();
 
 	cwq = get_wq_data(work);
-	/* Was it ever queued ? */
 	if (!cwq)
 		return;
 
-	/*
-	 * This work can't be re-queued, no need to re-check that
-	 * get_wq_data() is still the same when we take cwq->lock.
-	 */
-	spin_lock_irq(&cwq->lock);
-	list_del_init(&work->entry);
-	work_clear_pending(work);
-	spin_unlock_irq(&cwq->lock);
-
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu_mask(cpu, *cpu_map)
-		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+}
+
+/**
+ * cancel_work_sync - block until a work_struct's callback has terminated
+ * @work: the work which is to be flushed
+ *
+ * cancel_work_sync() will cancel the work if it is queued. If the work's
+ * callback appears to be running, cancel_work_sync() will block until it
+ * has completed.
+ *
+ * It is possible to use this function if the work re-queues itself. It can
+ * cancel the work even if it migrates to another workqueue, however in that
+ * case it only garantees that work->func() has completed on the last queued
+ * workqueue.
+ *
+ * The caller must ensure that workqueue_struct on which this work was last
+ * queued can't be destroyed before this function returns.
+ */
+void cancel_work_sync(struct work_struct *work)
+{
+	while (!try_to_grab_pending(work))
+		;
+	wait_on_work(work);
+	work_clear_pending(work);
 }
 EXPORT_SYMBOL_GPL(cancel_work_sync);
 
+/**
+ * cancel_rearming_delayed_work - reliably kill off a delayed work.
+ * @dwork: the delayed work struct
+ *
+ * It is possible to use this function if dwork rearms itself via queue_work()
+ * or queue_delayed_work(). See also the comment for cancel_work_sync().
+ */
+void cancel_rearming_delayed_work(struct delayed_work *dwork)
+{
+	while (!del_timer(&dwork->timer) &&
+	       !try_to_grab_pending(&dwork->work))
+		;
+	wait_on_work(&dwork->work);
+	work_clear_pending(&dwork->work);
+}
+EXPORT_SYMBOL(cancel_rearming_delayed_work);
 
-static struct workqueue_struct *keventd_wq;
+static struct workqueue_struct *keventd_wq __read_mostly;
 
 /**
  * schedule_work - put work task in global workqueue
@@ -530,28 +591,6 @@ void flush_scheduled_work(void)
 EXPORT_SYMBOL(flush_scheduled_work);
 
 /**
- * cancel_rearming_delayed_work - kill off a delayed work whose handler rearms the delayed work.
- * @dwork: the delayed work struct
- *
- * Note that the work callback function may still be running on return from
- * cancel_delayed_work(). Run flush_workqueue() or cancel_work_sync() to wait
- * on it.
- */
-void cancel_rearming_delayed_work(struct delayed_work *dwork)
-{
-	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
-
-	/* Was it ever queued ? */
-	if (cwq != NULL) {
-		struct workqueue_struct *wq = cwq->wq;
-
-		while (!cancel_delayed_work(dwork))
-			flush_workqueue(wq);
-	}
-}
-EXPORT_SYMBOL(cancel_rearming_delayed_work);
-
-/**
  * execute_in_process_context - reliably execute the routine with user context
  * @fn:		the function to execute
  * @ew:		guaranteed storage for the execute work structure (must

