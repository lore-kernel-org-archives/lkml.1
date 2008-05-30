Return-Path: <linux-kernel-owner+w=401wt.eu-S1758496AbYE3ECn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496AbYE3ECn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYE3EAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40488 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbYE3EAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:14 -0400
Message-Id: <20080530040012.575084574@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:27 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 07/41] cpu alloc: Workqueue conversion
Content-Disposition: inline; filename=cpu_alloc_workqueue_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the workqueue waitqueue handling to cpu alloc.

The second parameter to wq_per_cpu() is always the current processor
id. So drop the parameter and use THIS_CPU in wq_per_cpu that we rename
to wq_this_cpu.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 kernel/workqueue.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c	2008-05-28 22:02:19.000000000 -0700
+++ linux-2.6/kernel/workqueue.c	2008-05-28 22:52:29.000000000 -0700
@@ -95,11 +95,11 @@
 }
 
 static
-struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
+struct cpu_workqueue_struct *wq_this_cpu(struct workqueue_struct *wq)
 {
 	if (unlikely(is_single_threaded(wq)))
-		cpu = singlethread_cpu;
-	return per_cpu_ptr(wq->cpu_wq, cpu);
+		return CPU_PTR(wq->cpu_wq, singlethread_cpu);
+	return THIS_CPU(wq->cpu_wq);
 }
 
 /*
@@ -167,8 +167,9 @@
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
 		BUG_ON(!list_empty(&work->entry));
-		__queue_work(wq_per_cpu(wq, get_cpu()), work);
-		put_cpu();
+		preempt_disable();
+		__queue_work(wq_this_cpu(wq), work);
+		preempt_enable();
 		ret = 1;
 	}
 	return ret;
@@ -181,7 +182,7 @@
 	struct cpu_workqueue_struct *cwq = get_wq_data(&dwork->work);
 	struct workqueue_struct *wq = cwq->wq;
 
-	__queue_work(wq_per_cpu(wq, smp_processor_id()), &dwork->work);
+	__queue_work(wq_this_cpu(wq), &dwork->work);
 }
 
 /**
@@ -225,7 +226,7 @@
 		timer_stats_timer_set_start_info(&dwork->timer);
 
 		/* This stores cwq for the moment, for the timer_fn */
-		set_wq_data(work, wq_per_cpu(wq, raw_smp_processor_id()));
+		set_wq_data(work, wq_this_cpu(wq));
 		timer->expires = jiffies + delay;
 		timer->data = (unsigned long)dwork;
 		timer->function = delayed_work_timer_fn;
@@ -398,7 +399,7 @@
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+		flush_cpu_workqueue(CPU_PTR(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -478,7 +479,7 @@
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu_mask(cpu, *cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(CPU_PTR(wq->cpu_wq, cpu), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -598,21 +599,21 @@
 	int cpu;
 	struct work_struct *works;
 
-	works = alloc_percpu(struct work_struct);
+	works = CPU_ALLOC(struct work_struct, GFP_KERNEL);
 	if (!works)
 		return -ENOMEM;
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = per_cpu_ptr(works, cpu);
+		struct work_struct *work = CPU_PTR(works, cpu);
 
 		INIT_WORK(work, func);
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
+		__queue_work(CPU_PTR(keventd_wq->cpu_wq, cpu), work);
 	}
 	flush_workqueue(keventd_wq);
 	put_online_cpus();
-	free_percpu(works);
+	CPU_FREE(works);
 	return 0;
 }
 
@@ -661,7 +662,7 @@
 
 	BUG_ON(!keventd_wq);
 
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
+	cwq = CPU_PTR(keventd_wq->cpu_wq, cpu);
 	if (current == cwq->thread)
 		ret = 1;
 
@@ -672,7 +673,7 @@
 static struct cpu_workqueue_struct *
 init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct cpu_workqueue_struct *cwq = CPU_PTR(wq->cpu_wq, cpu);
 
 	cwq->wq = wq;
 	spin_lock_init(&cwq->lock);
@@ -730,7 +731,8 @@
 	if (!wq)
 		return NULL;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	wq->cpu_wq = CPU_ALLOC(struct cpu_workqueue_struct,
+					GFP_KERNEL|__GFP_ZERO);
 	if (!wq->cpu_wq) {
 		kfree(wq);
 		return NULL;
@@ -814,10 +816,10 @@
 	spin_unlock(&workqueue_lock);
 
 	for_each_cpu_mask(cpu, *cpu_map)
-		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
+		cleanup_workqueue_thread(CPU_PTR(wq->cpu_wq, cpu));
 	put_online_cpus();
 
-	free_percpu(wq->cpu_wq);
+	CPU_FREE(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
@@ -838,7 +840,7 @@
 	}
 
 	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cwq = CPU_PTR(wq->cpu_wq, cpu);
 
 		switch (action) {
 		case CPU_UP_PREPARE:

-- 
