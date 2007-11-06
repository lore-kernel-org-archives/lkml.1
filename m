Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbXKFT7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbXKFT7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXKFTwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45428 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756247AbXKFTwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:04 -0500
Message-Id: <20071106195203.601314278@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:10 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 26/28] cpu alloc: Use for infiniband
Content-Disposition: inline; filename=cpu_alloc_infiniband
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/infiniband/hw/ehca/ehca_irq.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2007-11-05 16:04:55.350534140 -0800
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2007-11-05 16:39:25.151283658 -0800
@@ -646,7 +646,7 @@ static void queue_comp_task(struct ehca_
 	cpu_id = find_next_online_cpu(pool);
 	BUG_ON(!cpu_online(cpu_id));
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu_id);
 	BUG_ON(!cct);
 
 	spin_lock_irqsave(&cct->task_lock, flags);
@@ -654,7 +654,7 @@ static void queue_comp_task(struct ehca_
 	spin_unlock_irqrestore(&cct->task_lock, flags);
 	if (cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
-		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+		cct = CPU_PTR(pool->cpu_comp_tasks, cpu_id);
 		BUG_ON(!cct);
 	}
 
@@ -727,7 +727,7 @@ static struct task_struct *create_comp_t
 {
 	struct ehca_cpu_comp_task *cct;
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 	spin_lock_init(&cct->task_lock);
 	INIT_LIST_HEAD(&cct->cq_list);
 	init_waitqueue_head(&cct->wait_queue);
@@ -743,7 +743,7 @@ static void destroy_comp_task(struct ehc
 	struct task_struct *task;
 	unsigned long flags_cct;
 
-	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 
 	spin_lock_irqsave(&cct->task_lock, flags_cct);
 
@@ -759,7 +759,7 @@ static void destroy_comp_task(struct ehc
 
 static void __cpuinit take_over_work(struct ehca_comp_pool *pool, int cpu)
 {
-	struct ehca_cpu_comp_task *cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
+	struct ehca_cpu_comp_task *cct = CPU_PTR(pool->cpu_comp_tasks, cpu);
 	LIST_HEAD(list);
 	struct ehca_cq *cq;
 	unsigned long flags_cct;
@@ -772,8 +772,7 @@ static void __cpuinit take_over_work(str
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
-		__queue_comp_task(cq, per_cpu_ptr(pool->cpu_comp_tasks,
-						  smp_processor_id()));
+		__queue_comp_task(cq, THIS_CPU(pool->cpu_comp_tasks));
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
@@ -799,14 +798,14 @@ static int __cpuinit comp_pool_callback(
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
@@ -849,7 +848,8 @@ int ehca_create_comp_pool(void)
 	spin_lock_init(&pool->last_cpu_lock);
 	pool->last_cpu = any_online_cpu(cpu_online_map);
 
-	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
+	pool->cpu_comp_tasks = CPU_ALLOC(struct ehca_cpu_comp_task,
+						GFP_KERNEL | __GFP_ZERO);
 	if (pool->cpu_comp_tasks == NULL) {
 		kfree(pool);
 		return -EINVAL;
@@ -883,6 +883,6 @@ void ehca_destroy_comp_pool(void)
 		if (cpu_online(i))
 			destroy_comp_task(pool, i);
 	}
-	free_percpu(pool->cpu_comp_tasks);
+	CPU_FREE(pool->cpu_comp_tasks);
 	kfree(pool);
 }

-- 
