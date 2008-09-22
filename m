Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYIVEEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYIVEEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 00:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYIVEEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 00:04:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36887 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYIVEEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 00:04:22 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: krkumar2@in.ibm.com, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 22 Sep 2008 09:34:17 +0530
Message-Id: <20080922040417.10477.35834.sendpatchset@localhost.localdomain>
In-Reply-To: <20080922040404.10477.24678.sendpatchset@localhost.localdomain>
References: <20080922040404.10477.24678.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/2]: workqueue: Implement the kernel API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Implement two API's for quickly updating delayed works:
	void schedule_update_delayed_work(struct delayed_work *dwork,
					  unsigned long delay);
	void queue_update_delayed_work(struct workqueue_struct *wq,
				       struct delayed_work *dwork,
				       unsigned long delay);

These API's are useful to update an existing work entry more efficiently (but
can be used to queue a new work entry too) when the operation is done very
frequently. The rationale is to save time of first cancelling work/timer and
adding work/timer when the same work is added many times in quick succession.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/linux/workqueue.h |    4 +
 kernel/workqueue.c        |  127 ++++++++++++++++++++++++++++++------
 2 files changed, 113 insertions(+), 18 deletions(-)

diff -ruNp 2.6.27-rc7-org/include/linux/workqueue.h 2.6.27-rc7-new/include/linux/workqueue.h
--- 2.6.27-rc7-org/include/linux/workqueue.h	2008-09-17 13:14:27.000000000 +0530
+++ 2.6.27-rc7-new/include/linux/workqueue.h	2008-09-17 13:17:43.000000000 +0530
@@ -185,6 +185,8 @@ extern int queue_delayed_work(struct wor
 			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern void queue_update_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
@@ -194,6 +196,8 @@ extern int schedule_work_on(int cpu, str
 extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
+extern void schedule_update_delayed_work(struct delayed_work *work,
+					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
diff -ruNp 2.6.27-rc7-org/kernel/workqueue.c 2.6.27-rc7-new/kernel/workqueue.c
--- 2.6.27-rc7-org/kernel/workqueue.c	2008-09-17 13:14:07.000000000 +0530
+++ 2.6.27-rc7-new/kernel/workqueue.c	2008-09-18 12:52:22.000000000 +0530
@@ -202,6 +202,30 @@ static void delayed_work_timer_fn(unsign
 	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
 }
 
+static inline void __queue_delayed_work(int cpu, struct delayed_work *dwork,
+					struct work_struct *work,
+					struct workqueue_struct *wq,
+					unsigned long delay)
+{
+	struct timer_list *timer = &dwork->timer;
+
+	BUG_ON(timer_pending(timer));
+	BUG_ON(!list_empty(&work->entry));
+
+	timer_stats_timer_set_start_info(timer);
+
+	/* This stores cwq for the moment, for the timer_fn */
+	set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
+	timer->expires = jiffies + delay;
+	timer->data = (unsigned long)dwork;
+	timer->function = delayed_work_timer_fn;
+
+	if (unlikely(cpu >= 0))
+		add_timer_on(timer, cpu);
+	else
+		add_timer(timer);
+}
+
 /**
  * queue_delayed_work - queue work on a workqueue after delay
  * @wq: workqueue to use
@@ -233,31 +257,63 @@ int queue_delayed_work_on(int cpu, struc
 			struct delayed_work *dwork, unsigned long delay)
 {
 	int ret = 0;
-	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
-
-		timer_stats_timer_set_start_info(&dwork->timer);
-
-		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
-		timer->expires = jiffies + delay;
-		timer->data = (unsigned long)dwork;
-		timer->function = delayed_work_timer_fn;
-
-		if (unlikely(cpu >= 0))
-			add_timer_on(timer, cpu);
-		else
-			add_timer(timer);
+		__queue_delayed_work(cpu, dwork, work, wq, delay);
 		ret = 1;
 	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+static int __cancel_work_timer_internal(struct work_struct *work,
+					struct timer_list *timer);
+
+/**
+ * queue_update_delayed_work - queue or update a work entry on a workqueue
+ *			       after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * This function is useful to update an existing delayed work without having
+ * to first cancel it. E.g. code snippets that can use this API:
+ * 	if (delayed_work_pending(&work))
+ * 		cancel_delayed_work(&work);
+ * 	queue_delayed_work(wq, &work, delay);
+ *
+ * Passing delay=0 will result in immediate queueing of the entry, whether
+ * queue'd earlier or otherwise.
+ *
+ * Always succeeds. If work is already on a queue and different in the expiry,
+ * modify it with the new expiry value.
+ */
+void queue_update_delayed_work(struct workqueue_struct *wq,
+			       struct delayed_work *dwork, unsigned long delay)
+{
+	struct work_struct *work = &dwork->work;
+
+	if (likely(test_and_set_bit(WORK_STRUCT_PENDING,
+				    work_data_bits(work)))) {
+		struct timer_list *timer = &dwork->timer;
+
+		/*
+		 * Already present in workqueue. Check if the timer expiry is
+		 * the same. Also, optimize in case requests are within one
+		 * jiffy beyond the set expiry.
+		 */
+		if (time_in_range(jiffies + delay, timer->expires,
+				  timer->expires + 1))
+			return;
+
+		__cancel_work_timer_internal(work, timer);
+	}
+
+	__queue_delayed_work(-1, dwork, work, wq, delay);
+}
+EXPORT_SYMBOL_GPL(queue_update_delayed_work);
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -550,8 +606,8 @@ static void wait_on_work(struct work_str
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
-static int __cancel_work_timer(struct work_struct *work,
-				struct timer_list* timer)
+static int __cancel_work_timer_internal(struct work_struct *work,
+					struct timer_list *timer)
 {
 	int ret;
 
@@ -562,6 +618,15 @@ static int __cancel_work_timer(struct wo
 		wait_on_work(work);
 	} while (unlikely(ret < 0));
 
+	return ret;
+}
+
+static int __cancel_work_timer(struct work_struct *work,
+				struct timer_list *timer)
+{
+	int ret;
+
+	ret = __cancel_work_timer_internal(work, timer);
 	work_clear_pending(work);
 	return ret;
 }
@@ -667,6 +732,32 @@ int schedule_delayed_work_on(int cpu,
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
 /**
+ * schedule_update_delayed_work - put or update a work task in global workqueue
+ *				  after delay
+ * @dwork: job to be done
+ * @delay: number of jiffies to wait or 0 for immediate execution
+ *
+ * This function is useful to update an existing delayed work without having
+ * to first cancel it. E.g. code snippets that can use this API:
+ * 	if (delayed_work_pending(&work))
+ * 		cancel_delayed_work(&work);
+ * 	schedule_delayed_work(&work, delay);
+ *
+ * After waiting for a given time this puts a job in the kernel-global
+ * workqueue. Passing delay=0 will result in immediate queueing of the entry,
+ * whether queue'd earlier or otherwise.
+ *
+ * Always succeeds. If work is already on a queue and different in the expiry,
+ * modify it with the new expiry value.
+ */
+void schedule_update_delayed_work(struct delayed_work *dwork,
+				  unsigned long delay)
+{
+	queue_update_delayed_work(keventd_wq, dwork, delay);
+}
+EXPORT_SYMBOL(schedule_update_delayed_work);
+
+/**
  * schedule_on_each_cpu - call a function on each online CPU from keventd
  * @func: the function to call
  *
