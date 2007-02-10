Return-Path: <linux-kernel-owner+w=401wt.eu-S1751940AbXBJVut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbXBJVut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 16:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXBJVus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 16:50:48 -0500
Received: from mail.screens.ru ([213.234.233.54]:60914 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbXBJVur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 16:50:47 -0500
Date: Sun, 11 Feb 2007 00:50:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] unify queue_delayed_work() and queue_delayed_work_on()
Message-ID: <20070210215049.GA2216@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change queue_delayed_work() to use queue_delayed_work_on() to avoid the code
duplication (saves 133 bytes).

Q: queue_delayed_work() enqueues &dwork->work directly when delay == 0, why?

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~2_factor	2007-02-10 18:23:34.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-10 19:07:41.000000000 +0300
@@ -180,28 +180,11 @@ void delayed_work_timer_fn(unsigned long
 int fastcall queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	int ret = 0;
-	struct timer_list *timer = &dwork->timer;
-	struct work_struct *work = &dwork->work;
-
-	timer_stats_timer_set_start_info(timer);
+	timer_stats_timer_set_start_info(&dwork->timer);
 	if (delay == 0)
-		return queue_work(wq, work);
-
-	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
-		BUG_ON(timer_pending(timer));
-		BUG_ON(!list_empty(&work->entry));
+		return queue_work(wq, &dwork->work);
 
-		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work,
-			per_cpu_ptr(wq->cpu_wq, raw_smp_processor_id()));
-		timer->expires = jiffies + delay;
-		timer->data = (unsigned long)dwork;
-		timer->function = delayed_work_timer_fn;
-		add_timer(timer);
-		ret = 1;
-	}
-	return ret;
+	return queue_delayed_work_on(-1, wq, dwork, delay);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
@@ -231,7 +214,11 @@ int queue_delayed_work_on(int cpu, struc
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
-		add_timer_on(timer, cpu);
+
+		if (unlikely(cpu >= 0))
+			add_timer_on(timer, cpu);
+		else
+			add_timer(timer);
 		ret = 1;
 	}
 	return ret;

