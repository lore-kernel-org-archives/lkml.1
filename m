Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbYE3ENx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbYE3ENx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbYE3EBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:01:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40527 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbYE3EAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:21 -0400
Message-Id: <20080530040018.840731414@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:43 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 23/41] cpu alloc: Use it for infiniband
Content-Disposition: inline; filename=cpu_alloc_infiniband_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu alloc for infiniband.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2008-05-14 19:40:32.000000000 -0700
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2008-05-21 22:01:32.000000000 -0700
@@ -680,7 +680,7 @@
 	cpu_id = find_next_online_cpu(pool);
 	BUG_ON(!cpu_online(cpu_id));
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu_id);
 	BUG_ON(!cct);
 
 	spin_lock_irqsave(&cct->task_lock, flags);
@@ -688,7 +688,7 @@
 	spin_unlock_irqrestore(&cct->task_lock, flags);
 	if (cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+		cct = CPU_PTR(pool->cpu_comp_tasks, cpu_id);
 		BUG_ON(!cct);
 	}
 
@@ -761,7 +761,7 @@
 {
 	struct ehca_cpu_comp_task *cct;
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 	spin_lock_init(&cct->task_lock);
 	INIT_LIST_HEAD(&cct->cq_list);
 	init_waitqueue_head(&cct->wait_queue);
@@ -777,7 +777,7 @@
 	struct task_struct *task;
 	unsigned long flags_cct;
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 
 	spin_lock_irqsave(&cct->task_lock, flags_cct);
 
@@ -793,7 +793,7 @@
 
 static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
-	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	struct ehca_cpu_comp_task *cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
 	struct ehca_cq *cq;
 	unsigned long flags_cct;
@@ -806,8 +806,7 @@
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
-		__queue_comp_task(cq, per_cpu_ptr(pool->cpu_comp_tasks,
-						  smp_processor_id()));
+		__queue_comp_task(cq, THIS_CPU(pool->cpu_comp_tasks));
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
@@ -833,14 +832,14 @@
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+		cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
 		destroy_comp_task(pool, cpu);
 		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_ONLINE)", cpu);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+		cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 		kthread_bind(cct->task, cpu);
 		wake_up_process(cct->task);
 		break;
@@ -883,7 +882,8 @@
 	spin_lock_init(&pool->last_cpu_lock);
 	pool->last_cpu = any_online_cpu(cpu_online_map);
 
-	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
+	pool->cpu_comp_tasks = CPU_ALLOC(struct ehca_cpu_comp_task,
+						GFP_KERNEL | __GFP_ZERO);
 	if (pool->cpu_comp_tasks == NULL) {
 		kfree(pool);
 		return -EINVAL;
@@ -917,6 +917,6 @@
 		if (cpu_online(i))
 			destroy_comp_task(pool, i);
 	}
-	free_percpu(pool->cpu_comp_tasks);
+	CPU_FREE(pool->cpu_comp_tasks);
 	kfree(pool);
 }

-- 
