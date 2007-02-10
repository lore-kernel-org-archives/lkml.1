Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbXBJVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbXBJVu5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXBJVu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:50:56 -0500
Received: from mail.screens.ru ([213.234.233.54]:60922 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbXBJVuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:50:55 -0500
Date: Sun, 11 Feb 2007 00:50:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] make queue_delayed_work() friendly to flush_fork()
Message-ID: <20070210215040.GA2213@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently typeof(delayed_work->work.data) is

	"struct workqueue_struct" when the timer is pending

	"struct cpu_workqueue_struct" whe the work is queued

This makes impossible to use flush_fork(delayed_work->work) in addition
to cancel_delayed_work/cancel_rearming_delayed_work, not good.

Change queue_delayed_work/delayed_work_timer_fn to use cwq, not wq. This
complicates (and uglifies) these functions a little bit, but alows us to
use flush_fork(dwork) and imho makes the whole code more consistent.

Also, document the fact that cancel_rearming_delayed_work() doesn't garantee
the completion of work->func() upon return.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/include/linux/workqueue.h~1_dw_fw	2007-02-10 18:15:04.000000000 +0300
+++ 6.20-rc6-mm3/include/linux/workqueue.h	2007-02-10 18:16:15.000000000 +0300
@@ -193,7 +193,7 @@ int execute_in_process_context(work_func
 /*
  * Kill off a pending schedule_delayed_work().  Note that the work callback
  * function may still be running on return from cancel_delayed_work().  Run
- * flush_scheduled_work() or flush_work() to wait on it.
+ * flush_workqueue() or flush_work() to wait on it.
  */
 static inline int cancel_delayed_work(struct delayed_work *work)
 {
--- 6.20-rc6-mm3/kernel/workqueue.c~1_dw_fw	2007-02-07 23:08:23.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-10 18:23:34.000000000 +0300
@@ -90,18 +90,20 @@ static const cpumask_t *wq_cpu_map(struc
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
  */
-static inline void set_wq_data(struct work_struct *work, void *wq)
+static inline void set_wq_data(struct work_struct *work,
+				struct cpu_workqueue_struct *cwq)
 {
 	unsigned long new;
 
 	BUG_ON(!work_pending(work));
 
-	new = (unsigned long) wq | (1UL << WORK_STRUCT_PENDING);
+	new = (unsigned long) cwq | (1UL << WORK_STRUCT_PENDING);
 	new |= WORK_STRUCT_FLAG_MASK & *work_data_bits(work);
 	atomic_long_set(&work->data, new);
 }
 
-static inline void *get_wq_data(struct work_struct *work)
+static inline
+struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
 	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
 }
@@ -157,7 +159,8 @@ EXPORT_SYMBOL_GPL(queue_work);
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct workqueue_struct *wq = get_wq_data(&dwork->work);
+	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
+	struct workqueue_struct *wq = cwq->wq;
 	int cpu = smp_processor_id();
 
 	if (unlikely(is_single_threaded(wq)))
@@ -189,8 +192,9 @@ int fastcall queue_delayed_work(struct w
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -221,8 +225,9 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(timer_pending(timer));
 		BUG_ON(!list_empty(&work->entry));
 
-		/* This stores wq for the moment, for the timer_fn */
-		set_wq_data(work, wq);
+		/* This stores cwq for the moment, for the timer_fn */
+		set_wq_data(work,
+			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -563,9 +568,12 @@ void flush_work_keventd(struct work_stru
 EXPORT_SYMBOL(flush_work_keventd);
 
 /**
- * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_workqueue - kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
  * @dwork: the delayed work struct
+ *
+ * Note that the work callback function may still be running on return from
+ * cancel_delayed_work(). Run flush_workqueue() or flush_work() to wait on it.
  */
 void cancel_rearming_delayed_workqueue(struct workqueue_struct *wq,
 				       struct delayed_work *dwork)
@@ -580,7 +588,7 @@ void cancel_rearming_delayed_workqueue(s
 EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed keventd work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_work - kill off a delayed keventd work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)

