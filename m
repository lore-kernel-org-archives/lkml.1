Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYKUNus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYKUNus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbYKUNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:50:36 -0500
Received: from ozlabs.org ([203.10.76.45]:36395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYKUNuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:50:35 -0500
To: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 22 Nov 2008 00:20:30 +1030
Subject: [PATCH 2/3] cpumask: use new cpumask API in drivers/infiniband/hw/ehca
Cc: linux-kernel@vger.kernel.org, Christoph Raisch <raisch@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811220020.30658.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

We're moving from handing around cpumask_t's to handing around struct
cpumask *'s.  cpus_*, cpumask_t and cpu_*_map are deprecated: convert
to cpumask_*, cpu_*_mask.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -r 38b459d1e9c7 drivers/infiniband/hw/ehca/ehca_irq.c
--- a/drivers/infiniband/hw/ehca/ehca_irq.c	Fri Nov 07 22:33:08 2008 +1100
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c	Fri Nov 07 22:48:13 2008 +1100
@@ -650,7 +650,7 @@ static inline int find_next_online_cpu(s
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
 	if (cpu >= nr_cpu_ids)
 		cpu = first_cpu(cpu_online_map);
 	pool->last_cpu = cpu;
@@ -659,12 +659,12 @@
 
 	WARN_ON_ONCE(!in_interrupt());
 	if (ehca_debug_level >= 3)
-		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
+		ehca_dmp(cpu_online_mask, cpumask_size(), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
 	cpu = cpumask_next(pool->last_cpu, cpu_online_mask);
 	if (cpu >= nr_cpu_ids)
-		cpu = first_cpu(cpu_online_map);
+		cpu = cpumask_first(cpu_online_mask);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
 
@@ -855,7 +855,7 @@
 	case CPU_UP_CANCELED_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_CANCELED)", cpu);
 		cct = per_cpu_ptr(pool->cpu_comp_tasks, cpu);
-		kthread_bind(cct->task, any_online_cpu(cpu_online_map));
+		kthread_bind(cct->task, cpumask_any(cpu_online_mask));
 		destroy_comp_task(pool, cpu);
 		break;
 	case CPU_ONLINE:
@@ -902,7 +902,7 @@
 		return -ENOMEM;
 
 	spin_lock_init(&pool->last_cpu_lock);
-	pool->last_cpu = any_online_cpu(cpu_online_map);
+	pool->last_cpu = cpumask_any(cpu_online_mask);
 
 	pool->cpu_comp_tasks = alloc_percpu(struct ehca_cpu_comp_task);
 	if (pool->cpu_comp_tasks == NULL) {


