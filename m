Return-Path: <linux-kernel-owner+w=401wt.eu-S1946155AbXBPWFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946155AbXBPWFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946158AbXBPWFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:05:53 -0500
Received: from mail.screens.ru ([213.234.233.54]:37625 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946155AbXBPWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:05:52 -0500
Date: Sat, 17 Feb 2007 01:05:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] workqueue: introduce wq_per_cpu() helper
Message-ID: <20070216220546.GA90@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup. A number of per_cpu_ptr(wq->cpu_wq, cpu) users have to check that cpu
is valid for this wq. Make a simple helper.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~8_cpu_helper	2007-02-16 23:27:06.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-17 00:31:18.000000000 +0300
@@ -86,6 +86,14 @@ static const cpumask_t *wq_cpu_map(struc
 		? &cpu_singlethread_map : &cpu_populated_map;
 }
 
+static
+struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+{
+	if (unlikely(is_single_threaded(wq)))
+		cpu = singlethread_cpu;
+	return per_cpu_ptr(wq->cpu_wq, cpu);
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -142,16 +150,14 @@ static void __queue_work(struct cpu_work
  */
 int fastcall queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	int ret = 0, cpu = get_cpu();
+	int ret = 0;
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		if (unlikely(is_single_threaded(wq)))
-			cpu = singlethread_cpu;
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		__queue_work(wq_per_cpu(wq, get_cpu()), work);
+		put_cpu();
 		ret = 1;
 	}
-	put_cpu();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(queue_work);
@@ -161,12 +167,8 @@ void delayed_work_timer_fn(unsigned long
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 	struct workqueue_struct *wq = cwq->wq;
-	int cpu = smp_processor_id();
-
-	if (unlikely(is_single_threaded(wq)))
-		cpu = singlethread_cpu;
 
-	__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), &dwork->work);
+	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
 }
 
 /**
@@ -209,9 +211,7 @@ int queue_delayed_work_on(int cpu, struc
 		BUG_ON(!list_empty(&work->entry));
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, wq->singlethread ?
-				singlethread_cpu : raw_smp_processor_id()));
+		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;

