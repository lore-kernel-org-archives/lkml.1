Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbXKTBXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbXKTBXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbXKTBOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49867 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755899AbXKTBNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:39 -0500
Message-Id: <20071120011338.562240758@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:01 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 29/45] cpu alloc: Use for infiniband
Content-Disposition: inline; filename=0038-cpu-alloc-Use-for-infiniband.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c
===================================================================
--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_irq.c	2007-11-15 21:17:23.663404239 -0800
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_irq.c	2007-11-15 21:25:39.310404188 -0800
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
