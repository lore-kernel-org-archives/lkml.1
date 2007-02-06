Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXBFXaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXBFXaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030574AbXBFXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:30:06 -0500
Received: from mail.screens.ru ([213.234.233.54]:58422 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030578AbXBFXaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:30:00 -0500
Date: Wed, 7 Feb 2007 02:29:58 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] workqueue: kill run_scheduled_work()
Message-ID: <20070206232958.GA102@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

because it has no callers.

Actually, I think the whole idea of run_scheduled_work() was not right, not
good to mix "unqueue this work and execute its ->func()" in one function.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/include/linux/workqueue.h~1_del_rsw	2007-02-03 20:41:10.000000000 +0300
+++ 6.20-rc6-mm3/include/linux/workqueue.h	2007-02-06 22:54:24.000000000 +0300
@@ -176,7 +176,6 @@ extern void flush_work(struct workqueue_
 extern void flush_work_keventd(struct work_struct *work);
 
 extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(run_scheduled_work(struct work_struct *work));
 extern int FASTCALL(schedule_delayed_work(struct delayed_work *work, unsigned long delay));
 
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
--- 6.20-rc6-mm3/kernel/workqueue.c~1_del_rsw	2007-02-04 21:35:15.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-06 22:54:16.000000000 +0300
@@ -98,79 +98,6 @@ static inline void *get_wq_data(struct w
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
 
-static int __run_work(struct cpu_workqueue_struct *cwq, struct work_struct *work)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cwq->lock, flags);
-	/*
-	 * We need to re-validate the work info after we've gotten
-	 * the cpu_workqueue lock. We can run the work now iff:
-	 *
-	 *  - the wq_data still matches the cpu_workqueue_struct
-	 *  - AND the work is still marked pending
-	 *  - AND the work is still on a list (which will be this
-	 *    workqueue_struct list)
-	 *
-	 * All these conditions are important, because we
-	 * need to protect against the work being run right
-	 * now on another CPU (all but the last one might be
-	 * true if it's currently running and has not been
-	 * released yet, for example).
-	 */
-	if (get_wq_data(work) == cwq
-	    && work_pending(work)
-	    && !list_empty(&work->entry)) {
-		work_func_t f = work->func;
-		cwq->current_work = work;
-		list_del_init(&work->entry);
-		spin_unlock_irqrestore(&cwq->lock, flags);
-
-		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
-			work_release(work);
-		f(work);
-
-		spin_lock_irqsave(&cwq->lock, flags);
-		cwq->current_work = NULL;
-		ret = 1;
-	}
-	spin_unlock_irqrestore(&cwq->lock, flags);
-	return ret;
-}
-
-/**
- * run_scheduled_work - run scheduled work synchronously
- * @work: work to run
- *
- * This checks if the work was pending, and runs it
- * synchronously if so. It returns a boolean to indicate
- * whether it had any scheduled work to run or not.
- *
- * NOTE! This _only_ works for normal work_structs. You
- * CANNOT use this for delayed work, because the wq data
- * for delayed work will not point properly to the per-
- * CPU workqueue struct, but will change!
- */
-int fastcall run_scheduled_work(struct work_struct *work)
-{
-	for (;;) {
-		struct cpu_workqueue_struct *cwq;
-
-		if (!work_pending(work))
-			return 0;
-		if (list_empty(&work->entry))
-			return 0;
-		/* NOTE! This depends intimately on __queue_work! */
-		cwq = get_wq_data(work);
-		if (!cwq)
-			return 0;
-		if (__run_work(cwq, work))
-			return 1;
-	}
-}
-EXPORT_SYMBOL(run_scheduled_work);
-
 static void insert_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work, int tail)
 {

