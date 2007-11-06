Return-Path: <linux-kernel-owner+w=401wt.eu-S1759103AbXKFUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103AbXKFUBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXKFTwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:40 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52133 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755785AbXKFTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:01 -0500
Message-Id: <20071106195159.940836114@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:51:54 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 10/28] cpu alloc: workqueue conversion
Content-Disposition: inline; filename=cpu_alloc_workqueue
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 kernel/workqueue.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c	2007-11-04 13:10:18.000000000 -0800
+++ linux-2.6/kernel/workqueue.c	2007-11-04 13:14:22.000000000 -0800
@@ -33,6 +33,7 @@
 #include <linux/kallsyms.h>
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
+#include <linux/cpu_alloc.h>
 
 /*
  * The per-CPU workqueue (if single thread, we always use the first
@@ -100,7 +101,7 @@ struct cpu_workqueue_struct *wq_per_cpu(
 {
 	if (unlikely(is_single_threaded(wq)))
 		cpu = singlethread_cpu;
-	return per_cpu_ptr(wq->cpu_wq, cpu);
+	return CPU_PTR(wq->cpu_wq, cpu);
 }
 
 /*
@@ -398,7 +399,7 @@ void fastcall flush_workqueue(struct wor
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
 	for_each_cpu_mask(cpu, *cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+		flush_cpu_workqueue(CPU_PTR(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -478,7 +479,7 @@ static void wait_on_work(struct work_str
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu_mask(cpu, *cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(CPU_PTR(wq->cpu_wq, cpu), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -601,21 +602,21 @@ int schedule_on_each_cpu(work_func_t fun
 	int cpu;
 	struct work_struct *works;
 
-	works = alloc_percpu(struct work_struct);
+	works = CPU_ALLOC(struct work_struct, GFP_KERNEL);
 	if (!works)
 		return -ENOMEM;
 
 	preempt_disable();		/* CPU hotplug */
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = per_cpu_ptr(works, cpu);
+		struct work_struct *work = CPU_PTR(works, cpu);
 
 		INIT_WORK(work, func);
 		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
+		__queue_work(CPU_PTR(keventd_wq->cpu_wq, cpu), work);
 	}
 	preempt_enable();
 	flush_workqueue(keventd_wq);
-	free_percpu(works);
+	CPU_FREE(works);
 	return 0;
 }
 
@@ -664,7 +665,7 @@ int current_is_keventd(void)
 
 	BUG_ON(!keventd_wq);
 
-	cwq = per_cpu_ptr(keventd_wq->cpu_wq, cpu);
+	cwq = CPU_PTR(keventd_wq->cpu_wq, cpu);
 	if (current == cwq->thread)
 		ret = 1;
 
@@ -675,7 +676,7 @@ int current_is_keventd(void)
 static struct cpu_workqueue_struct *
 init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct cpu_workqueue_struct *cwq = CPU_PTR(wq->cpu_wq, cpu);
 
 	cwq->wq = wq;
 	spin_lock_init(&cwq->lock);
@@ -732,7 +733,8 @@ struct workqueue_struct *__create_workqu
 	if (!wq)
 		return NULL;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	wq->cpu_wq = CPU_ALLOC(struct cpu_workqueue_struct,
+					GFP_KERNEL|__GFP_ZERO);
 	if (!wq->cpu_wq) {
 		kfree(wq);
 		return NULL;
@@ -814,11 +816,11 @@ void destroy_workqueue(struct workqueue_
 	mutex_unlock(&workqueue_mutex);
 
 	for_each_cpu_mask(cpu, *cpu_map) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cwq = CPU_PTR(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
 
-	free_percpu(wq->cpu_wq);
+	CPU_FREE(wq->cpu_wq);
 	kfree(wq);
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
@@ -847,7 +849,7 @@ static int __devinit workqueue_cpu_callb
 	}
 
 	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cwq = CPU_PTR(wq->cpu_wq, cpu);
 
 		switch (action) {
 		case CPU_UP_PREPARE:

-- 
