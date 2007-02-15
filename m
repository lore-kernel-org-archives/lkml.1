Return-Path: <linux-kernel-owner+w=401wt.eu-S966011AbXBOQED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966011AbXBOQED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966012AbXBOQED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:04:03 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:17927 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966011AbXBOQEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:04:00 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org,
       bos@pathscale.com
Subject: [PATCH 2.6.21-rc1 2/5] ehca: fix race condition/locking issues in scaling code
Date: Thu, 15 Feb 2007 17:07:30 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, heiko.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151707.31021.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fix a race condition in find_next_cpu_online() and some
other locking issues in scaling code


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_irq.c |   68 +++++++++++++++++++++++++++++--------------------------------
 1 files changed, 33 insertions(+), 35 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index b923b5d..9679b07 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -544,28 +544,30 @@ void ehca_tasklet_eq(unsigned long data)
 
 static inline int find_next_online_cpu(struct ehca_comp_pool* pool)
 {
-	unsigned long flags_last_cpu;
+	int cpu;
+	unsigned long flags;
 
+	WARN_ON_ONCE(!in_interrupt());
 	if (ehca_debug_level)
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
-	spin_lock_irqsave(&pool->last_cpu_lock, flags_last_cpu);
-	pool->last_cpu = next_cpu(pool->last_cpu, cpu_online_map);
-	if (pool->last_cpu == NR_CPUS)
-		pool->last_cpu = first_cpu(cpu_online_map);
-	spin_unlock_irqrestore(&pool->last_cpu_lock, flags_last_cpu);
+	spin_lock_irqsave(&pool->last_cpu_lock, flags);
+	cpu = next_cpu(pool->last_cpu, cpu_online_map);
+	if (cpu == NR_CPUS)
+		cpu = first_cpu(cpu_online_map);
+	pool->last_cpu = cpu;
+	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
-	return pool->last_cpu;
+	return cpu;
 }
 
 static void __queue_comp_task(struct ehca_cq *__cq,
 			      struct ehca_cpu_comp_task *cct)
 {
-	unsigned long flags_cct;
-	unsigned long flags_cq;
+	unsigned long flags;
 
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
-	spin_lock_irqsave(&__cq->task_lock, flags_cq);
+	spin_lock_irqsave(&cct->task_lock, flags);
+	spin_lock(&__cq->task_lock);
 
 	if (__cq->nr_callbacks == 0) {
 		__cq->nr_callbacks++;
@@ -576,8 +578,8 @@ static void __queue_comp_task(struct ehc
 	else
 		__cq->nr_callbacks++;
 
-	spin_unlock_irqrestore(&__cq->task_lock, flags_cq);
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
+	spin_unlock(&__cq->task_lock);
+	spin_unlock_irqrestore(&cct->task_lock, flags);
 }
 
 static void queue_comp_task(struct ehca_cq *__cq)
@@ -588,69 +590,69 @@ static void queue_comp_task(struct ehca_
 
 	cpu = get_cpu();
 	cpu_id = find_next_online_cpu(pool);
-
 	BUG_ON(!cpu_online(cpu_id));
 
 	cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+	BUG_ON(!cct);
 
 	if (cct->cq_jobs > 0) {
 		cpu_id = find_next_online_cpu(pool);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu_id);
+		BUG_ON(!cct);
 	}
 
 	__queue_comp_task(__cq, cct);
-
-	put_cpu();
-
-	return;
 }
 
 static void run_comp_task(struct ehca_cpu_comp_task* cct)
 {
 	struct ehca_cq *cq;
-	unsigned long flags_cct;
-	unsigned long flags_cq;
+	unsigned long flags;
 
-	spin_lock_irqsave(&cct->task_lock, flags_cct);
+	spin_lock_irqsave(&cct->task_lock, flags);
 
 	while (!list_empty(&cct->cq_list)) {
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
-		spin_unlock_irqrestore(&cct->task_lock, flags_cct);
+		spin_unlock_irqrestore(&cct->task_lock, flags);
 		comp_event_callback(cq);
-		spin_lock_irqsave(&cct->task_lock, flags_cct);
+		spin_lock_irqsave(&cct->task_lock, flags);
 
-		spin_lock_irqsave(&cq->task_lock, flags_cq);
+		spin_lock(&cq->task_lock);
 		cq->nr_callbacks--;
 		if (cq->nr_callbacks == 0) {
 			list_del_init(cct->cq_list.next);
 			cct->cq_jobs--;
 		}
-		spin_unlock_irqrestore(&cq->task_lock, flags_cq);
-
+		spin_unlock(&cq->task_lock);
 	}
 
-	spin_unlock_irqrestore(&cct->task_lock, flags_cct);
-
-	return;
+	spin_unlock_irqrestore(&cct->task_lock, flags);
 }
 
 static int comp_task(void *__cct)
 {
 	struct ehca_cpu_comp_task* cct = __cct;
+	int cql_empty;
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while(!kthread_should_stop()) {
 		add_wait_queue(&cct->wait_queue, &wait);
 
-		if (list_empty(&cct->cq_list))
+		spin_lock_irq(&cct->task_lock);
+		cql_empty = list_empty(&cct->cq_list);
+		spin_unlock_irq(&cct->task_lock);
+		if (cql_empty)
 			schedule();
 		else
 			__set_current_state(TASK_RUNNING);
 
 		remove_wait_queue(&cct->wait_queue, &wait);
 
-		if (!list_empty(&cct->cq_list))
+		spin_lock_irq(&cct->task_lock);
+		cql_empty = list_empty(&cct->cq_list);
+		spin_unlock_irq(&cct->task_lock);
+		if (!cql_empty)
 			run_comp_task(__cct);
 
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -693,8 +695,6 @@ static void destroy_comp_task(struct ehc
 
 	if (task)
 		kthread_stop(task);
-
-	return;
 }
 
 static void take_over_work(struct ehca_comp_pool *pool,
@@ -815,6 +815,4 @@ void ehca_destroy_comp_pool(void)
 	free_percpu(pool->cpu_comp_tasks);
 	kfree(pool);
 #endif
-
-	return;
 }

