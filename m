Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYFMO0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYFMO0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYFMOZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:25:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:51096 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbYFMOZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:25:52 -0400
Date: Fri, 13 Jun 2008 18:28:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080613142801.GA9165@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of [PATCH] workqueues: insert_work: use "list_head *" instead of "int tail"
 http://marc.info/?l=linux-kernel&m=121328944230175)

Most of users of flush_workqueue() can be changed to use cancel_work_sync(),
but sometimes we really need to wait for the completion and cancelling is not
an option. schedule_on_each_cpu() is good example.

Add the new helper, flush_work(work), which waits for the completion of the
specific work_struct.

By its nature it requires that this work must not be re-queued, and thus its
usage is limited. For example, this code

	queue_work(wq, work);
	/* WINDOW */
	queue_work(wq, work);

	flush_work(work);

is not right. What can happen in the WINDOW above is

	- wq starts the execution of work->func()

	- the caller migrates to another CPU

now, after the 2nd queue_work() this work is active on the previous CPU, and
at the same time it is queued on another. We can fix this limitation, but in
that case we have to iterate over all CPUs like wait_on_work() does, this
will depreciate the advantages of this helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/include/linux/workqueue.h~WQ_2_FLUSH_WORK	2008-05-18 15:42:34.000000000 +0400
+++ 26-rc2/include/linux/workqueue.h	2008-05-18 15:42:34.000000000 +0400
@@ -198,6 +198,8 @@ extern int keventd_up(void);
 extern void init_workqueues(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
+extern int flush_work(struct work_struct *work);
+
 extern int cancel_work_sync(struct work_struct *work);
 
 /*
--- 26-rc2/kernel/workqueue.c~WQ_2_FLUSH_WORK	2008-06-12 21:28:13.000000000 +0400
+++ 26-rc2/kernel/workqueue.c	2008-06-13 17:31:54.000000000 +0400
@@ -399,6 +399,52 @@ void flush_workqueue(struct workqueue_st
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
+/**
+ * flush_work - block until a work_struct's callback has terminated
+ * @work: the work which is to be flushed
+ *
+ * It is expected that, prior to calling flush_work(), the caller has
+ * arranged for the work to not be requeued, otherwise it doesn't make
+ * sense to use this function.
+ */
+int flush_work(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq;
+	struct list_head *prev;
+	struct wq_barrier barr;
+
+	might_sleep();
+	cwq = get_wq_data(work);
+	if (!cwq)
+		return 0;
+
+	prev = NULL;
+	spin_lock_irq(&cwq->lock);
+	if (unlikely(cwq->current_work == work)) {
+		prev = &cwq->worklist;
+	} else {
+		if (list_empty(&work->entry))
+			goto out;
+		/*
+		 * See the comment near try_to_grab_pending()->smp_rmb().
+		 * If it was re-queued under us we are not going to wait.
+		 */
+		smp_rmb();
+		if (cwq != get_wq_data(work))
+			goto out;
+		prev = &work->entry;
+	}
+	insert_wq_barrier(cwq, &barr, prev->next);
+out:
+	spin_unlock_irq(&cwq->lock);
+	if (!prev)
+		return 0;
+
+	wait_for_completion(&barr.done);
+	return 1;
+}
+EXPORT_SYMBOL_GPL(flush_work);
+
 /*
  * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.

