Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYI2HDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYI2HDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYI2HDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:03:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:44683 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYI2HDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:03:20 -0400
From: Krishna Kumar <krkumar2@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Krishna Kumar <krkumar2@in.ibm.com>
Date: Mon, 29 Sep 2008 12:33:14 +0530
Message-Id: <20080929070314.7386.28163.sendpatchset@localhost.localdomain>
In-Reply-To: <20080929070302.7386.72726.sendpatchset@localhost.localdomain>
References: <20080929070302.7386.72726.sendpatchset@localhost.localdomain>
Subject: [REV2: PATCH 1/2]: workqueue: Implement the kernel API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krishna Kumar <krkumar2@in.ibm.com>

Implement two API's for quickly updating delayed works:
	int schedule_update_delayed_work(struct delayed_work *dwork,
					 unsigned long delay);
	int queue_update_delayed_work(struct workqueue_struct *wq,
					 struct delayed_work *dwork,
					 unsigned long delay);

These API's are useful to update an existing work entry more efficiently (but
can also be used to queue a new work entry) when the operation is done very
frequently. The rationale is to save time of first cancelling work/timer and
adding work/timer when the same work is added many times in quick succession.

Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
---
 include/linux/timer.h     |    1 
 include/linux/workqueue.h |    4 +
 kernel/timer.c            |   22 ++++++
 kernel/workqueue.c        |  124 +++++++++++++++++++++++++++++++-----
 4 files changed, 135 insertions(+), 16 deletions(-)

diff -ruNp 2.6.27-rc7-org/include/linux/timer.h 2.6.27-rc7-new/include/linux/timer.h
--- 2.6.27-rc7-org/include/linux/timer.h	2008-09-22 03:59:55.000000000 +0530
+++ 2.6.27-rc7-new/include/linux/timer.h	2008-09-29 12:06:17.000000000 +0530
@@ -88,6 +88,7 @@ extern void add_timer_on(struct timer_li
 extern int del_timer(struct timer_list * timer);
 extern int __mod_timer(struct timer_list *timer, unsigned long expires);
 extern int mod_timer(struct timer_list *timer, unsigned long expires);
+extern int update_timer_expiry(struct timer_list *timer, unsigned long expires);
 
 /*
  * The jiffies value which is added to now, when there is no timer
diff -ruNp 2.6.27-rc7-org/include/linux/workqueue.h 2.6.27-rc7-new/include/linux/workqueue.h
--- 2.6.27-rc7-org/include/linux/workqueue.h	2008-09-22 03:59:55.000000000 +0530
+++ 2.6.27-rc7-new/include/linux/workqueue.h	2008-09-29 12:06:17.000000000 +0530
@@ -185,6 +185,8 @@ extern int queue_delayed_work(struct wor
 			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern int queue_update_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
@@ -194,6 +196,8 @@ extern int schedule_work_on(int cpu, str
 extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
+extern int schedule_update_delayed_work(struct delayed_work *work,
+					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
diff -ruNp 2.6.27-rc7-org/kernel/timer.c 2.6.27-rc7-new/kernel/timer.c
--- 2.6.27-rc7-org/kernel/timer.c	2008-09-22 03:59:55.000000000 +0530
+++ 2.6.27-rc7-new/kernel/timer.c	2008-09-29 12:06:29.000000000 +0530
@@ -520,6 +520,28 @@ static struct tvec_base *lock_timer_base
 	}
 }
 
+/*
+ * update_timer: Quickly update the timer expiry if the timer is pending.
+ *
+ * Return 1 if the timer was successfully updated; otherwise return 0.
+ */
+int update_timer_expiry(struct timer_list *timer, unsigned long expires)
+{
+	struct tvec_base *base;
+	unsigned long flags;
+	int ret = 0;
+
+	base = lock_timer_base(timer, &flags);
+	if (likely(timer_pending(timer))) {
+		detach_timer(timer, 0);
+		timer->expires = expires;
+		internal_add_timer(base, timer);
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&base->lock, flags);
+	return ret;
+}
+
 int __mod_timer(struct timer_list *timer, unsigned long expires)
 {
 	struct tvec_base *base, *new_base;
diff -ruNp 2.6.27-rc7-org/kernel/workqueue.c 2.6.27-rc7-new/kernel/workqueue.c
--- 2.6.27-rc7-org/kernel/workqueue.c	2008-09-22 03:59:55.000000000 +0530
+++ 2.6.27-rc7-new/kernel/workqueue.c	2008-09-29 12:20:27.000000000 +0530
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
@@ -233,31 +257,75 @@ int queue_delayed_work_on(int cpu, struc
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
 
+static int try_to_grab_pending(struct work_struct *work);
+static void wait_on_work(struct work_struct *work);
+
+/**
+ * queue_update_delayed_work - queue or update a work entry on a workqueue
+ *			       after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing work
+ *
+ * This function is useful to update an existing delayed work without having
+ * to first cancel it. E.g. code snippets that can use this API:
+ * 	if (delayed_work_pending(&work))
+ * 		cancel_delayed_work(&work);
+ * 	queue_delayed_work(wq, &work, delay);
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ */
+int queue_update_delayed_work(struct workqueue_struct *wq,
+			      struct delayed_work *dwork, unsigned long delay)
+{
+	struct work_struct *work = &dwork->work;
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
+		__queue_delayed_work(-1, dwork, work, wq, delay);
+		return 1;
+	} else {
+		struct timer_list *timer = &dwork->timer;
+		unsigned long when = jiffies + delay;
+		int ret;
+
+		/*
+		 * Work is already scheduled. There is nothing to be done if
+		 * the work is being modified to run at the same time.
+		 */
+		if (timer->expires == when)
+			return 0;
+
+		do {
+			/*
+			 * If the timer has been added and it has not fired,
+			 * update_timer_expiry will update it with the correct
+			 * expiry. Otherwise timer has either not yet been
+			 * added or it has already fired - we need to try again.
+			 */
+			if (likely(update_timer_expiry(timer, when)))
+				return 0;
+
+			ret = try_to_grab_pending(work);
+			if (ret < 0)
+				wait_on_work(work);
+		} while (ret < 0);
+
+		__queue_delayed_work(-1, dwork, work, wq, delay);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(queue_update_delayed_work);
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	spin_lock_irq(&cwq->lock);
@@ -667,6 +735,30 @@ int schedule_delayed_work_on(int cpu,
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
 /**
+ * schedule_update_delayed_work - queue or update a work entry in global
+ *				  workqueue after a delay
+ * @dwork: job to be done
+ * @delay: number of jiffies to wait before queueing work
+ *
+ * This function is useful to update an existing delayed work without having
+ * to first cancel it. E.g. code snippets that can use this API:
+ * 	if (delayed_work_pending(&work))
+ * 		cancel_delayed_work(&work);
+ * 	schedule_delayed_work(&work, delay);
+ *
+ * After waiting for a given time this puts a job in the kernel global
+ * workqueue.
+ *
+ * Returns 0 if @work was already on global workqueue, non-zero otherwise.
+ */
+int schedule_update_delayed_work(struct delayed_work *dwork,
+				  unsigned long delay)
+{
+	return queue_update_delayed_work(keventd_wq, dwork, delay);
+}
+EXPORT_SYMBOL(schedule_update_delayed_work);
+
+/**
  * schedule_on_each_cpu - call a function on each online CPU from keventd
  * @func: the function to call
  *
