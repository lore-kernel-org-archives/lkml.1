Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbZLPRGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbZLPRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762286AbZLPRGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:06:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:53815 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbZLPRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:06:16 -0500
Message-Id: <20091216170517.961475466@chello.nl>
References: <20091216170430.073353839@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 16 Dec 2009 18:04:38 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/12] sched: Fix select_task_rq() vs hotplug issues
Content-Disposition: inline; filename=foo8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since select_task_rq() is now responsible for guaranteeing
->cpus_allowed and cpu_active_mask, we need to verify this.

select_task_rq_rt() can blindly return smp_processor_id()/task_cpu()
without checking the valid masks, select_task_rq_fair() can do the
same in the rare case that all SD_flags are disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   75 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2317,6 +2317,43 @@ void task_oncpu_function_call(struct tas
 }
 
 #ifdef CONFIG_SMP
+static int select_fallback_rq(int cpu, struct task_struct *p)
+{
+	int dest_cpu;
+	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+
+	/* Look for allowed, online CPU in same node. */
+	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+			return dest_cpu;
+
+	/* Any allowed, online CPU? */
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	if (dest_cpu < nr_cpu_ids)
+		return dest_cpu;
+
+	/* No more Mr. Nice Guy. */
+	if (dest_cpu >= nr_cpu_ids) {
+		rcu_read_lock();
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		rcu_read_unlock();
+		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk(KERN_INFO "process %d (%s) no "
+			       "longer affine to cpu%d\n",
+			       task_pid_nr(p), p->comm, cpu);
+		}
+	}
+
+	return dest_cpu;
+}
+
 /*
  * Called from:
  *
@@ -2343,14 +2380,8 @@ int select_task_rq(struct task_struct *p
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu))) {
-
-		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
-		/*
-		 * XXX: race against hot-plug modifying cpu_active_mask
-		 */
-		BUG_ON(cpu >= nr_cpu_ids);
-	}
+		     !cpu_active(cpu)))
+		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;
 }
@@ -7319,36 +7350,10 @@ static int __migrate_task_irq(struct tas
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
 
 again:
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
-			goto move;
-
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		goto move;
-
-	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
-
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit()) {
-			pr_info("process %d (%s) no longer affine to cpu%d\n",
-				task_pid_nr(p), p->comm, dead_cpu);
-		}
-	}
+	dest_cpu = select_fallback_rq(dead_cpu, p);
 
-move:
 	/* It can have affinity changed while we were choosing. */
 	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
 		goto again;

-- 

