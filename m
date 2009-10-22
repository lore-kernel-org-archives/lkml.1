Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbZJVMmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbZJVMmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755638AbZJVMma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:42:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40330 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZJVMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:16 -0400
Message-Id: <20091022124111.383069928@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:51 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 08/17] sched: remove reciprocal for cpu_power
Content-Disposition: inline; filename=sched-lb-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its a source of fail, also, now that cpu_power is dynamical, its a
waste of time.

before:
<idle>-0   [000]   132.877936: find_busiest_group: avg_load: 0 group_load: 8241 power: 1 

after:
bash-1689  [001]   137.862151: find_busiest_group: avg_load: 10636288 group_load: 10387 power: 1

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[andreas.herrmann3@amd.com: remove include]
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 include/linux/sched.h |   10 +----
 kernel/sched.c        |  100 +++++++++++++++++---------------------------------
 2 files changed, 36 insertions(+), 74 deletions(-)

Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 09:15:37.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:38.000000000 -0400
@@ -137,30 +137,8 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
-#ifdef CONFIG_SMP
-
 static void double_rq_lock(struct rq *rq1, struct rq *rq2);
 
-/*
- * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
- * Since cpu_power is a 'constant', we can use a reciprocal divide.
- */
-static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
-{
-	return reciprocal_divide(load, sg->reciprocal_cpu_power);
-}
-
-/*
- * Each time a sched group cpu_power is changed,
- * we must compute its reciprocal value
- */
-static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
-{
-	sg->__cpu_power += val;
-	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
-}
-#endif
-
 #define TASK_PREEMPTS_CURR(p, rq) \
 	((p)->prio < (rq)->curr->prio)
 
@@ -2401,8 +2379,7 @@
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -3849,7 +3826,6 @@
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
-	unsigned long old = sdg->__cpu_power;
 
 	/* here we could scale based on cpufreq */
 
@@ -3864,33 +3840,26 @@
 	if (!power)
 		power = 1;
 
-	if (power != old) {
-		sdg->__cpu_power = power;
-		sdg->reciprocal_cpu_power = reciprocal_value(power);
-	}
+	sdg->cpu_power = power;
 }
 
 static void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
-	unsigned long power = sdg->__cpu_power;
 
 	if (!child) {
 		update_cpu_power(sd, cpu);
 		return;
 	}
 
-	sdg->__cpu_power = 0;
+	sdg->cpu_power = 0;
 
 	group = child->groups;
 	do {
-		sdg->__cpu_power += group->__cpu_power;
+		sdg->cpu_power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
-
-	if (power != sdg->__cpu_power)
-		sdg->reciprocal_cpu_power = reciprocal_value(sdg->__cpu_power);
 }
 
 /**
@@ -3970,8 +3939,7 @@
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = sg_div_cpu_power(group,
-			sgs->group_load * SCHED_LOAD_SCALE);
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 
 	/*
@@ -3983,14 +3951,14 @@
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	avg_load_per_task = sg_div_cpu_power(group,
-			sum_avg_load_per_task * SCHED_LOAD_SCALE);
+	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
+		group->cpu_power;
 
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
 	sgs->group_capacity =
-		DIV_ROUND_CLOSEST(group->__cpu_power, SCHED_LOAD_SCALE);
+		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**
@@ -4032,7 +4000,7 @@
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->__cpu_power;
+		sds->total_pwr += group->cpu_power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4097,28 +4065,28 @@
 	 * moving them.
 	 */
 
-	pwr_now += sds->busiest->__cpu_power *
+	pwr_now += sds->busiest->cpu_power *
 			min(sds->busiest_load_per_task, sds->max_load);
-	pwr_now += sds->this->__cpu_power *
+	pwr_now += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load);
 	pwr_now /= SCHED_LOAD_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = sg_div_cpu_power(sds->busiest,
-			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
+	tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+		sds->busiest->cpu_power;
 	if (sds->max_load > tmp)
-		pwr_move += sds->busiest->__cpu_power *
+		pwr_move += sds->busiest->cpu_power *
 			min(sds->busiest_load_per_task, sds->max_load - tmp);
 
 	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->__cpu_power <
+	if (sds->max_load * sds->busiest->cpu_power <
 		sds->busiest_load_per_task * SCHED_LOAD_SCALE)
-		tmp = sg_div_cpu_power(sds->this,
-			sds->max_load * sds->busiest->__cpu_power);
+		tmp = (sds->max_load * sds->busiest->cpu_power) /
+			sds->this->cpu_power;
 	else
-		tmp = sg_div_cpu_power(sds->this,
-			sds->busiest_load_per_task * SCHED_LOAD_SCALE);
-	pwr_move += sds->this->__cpu_power *
+		tmp = (sds->busiest_load_per_task * SCHED_LOAD_SCALE) /
+			sds->this->cpu_power;
+	pwr_move += sds->this->cpu_power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_LOAD_SCALE;
 
@@ -4153,8 +4121,8 @@
 			sds->max_load - sds->busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->__cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
+	*imbalance = min(max_pull * sds->busiest->cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -4289,7 +4257,7 @@
 	if (!group)
 		return SCHED_LOAD_SCALE;
 
-	return group->__cpu_power;
+	return group->cpu_power;
 }
 
 /*
@@ -8226,7 +8194,7 @@
 			break;
 		}
 
-		if (!group->__cpu_power) {
+		if (!group->cpu_power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -8250,9 +8218,9 @@
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
 
 		printk(KERN_CONT " %s", str);
-		if (group->__cpu_power != SCHED_LOAD_SCALE) {
-			printk(KERN_CONT " (__cpu_power = %d)",
-				group->__cpu_power);
+		if (group->cpu_power != SCHED_LOAD_SCALE) {
+			printk(KERN_CONT " (cpu_power = %d)",
+				group->cpu_power);
 		}
 
 		group = group->next;
@@ -8537,7 +8505,7 @@
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 
 		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
@@ -8762,7 +8730,7 @@
 				continue;
 			}
 
-			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+			sg->cpu_power += sd->groups->cpu_power;
 		}
 		sg = sg->next;
 	} while (sg != group_head);
@@ -8835,7 +8803,7 @@
 
 	child = sd->child;
 
-	sd->groups->__cpu_power = 0;
+	sd->groups->cpu_power = 0;
 
 	if (!child) {
 		power = SCHED_LOAD_SCALE;
@@ -8851,7 +8819,7 @@
 			power /= weight;
 			power >>= SCHED_LOAD_SHIFT;
 		}
-		sg_inc_cpu_power(sd->groups, power);
+		sd->groups->cpu_power += power;
 		return;
 	}
 
@@ -8860,7 +8828,7 @@
 	 */
 	group = child->groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sd->groups->cpu_power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
 }
@@ -9133,7 +9101,7 @@
 			sd = &per_cpu(node_domains, j).sd;
 			sd->groups = sg;
 		}
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 		cpumask_copy(sched_group_cpus(sg), nodemask);
 		sg->next = sg;
 		cpumask_or(covered, covered, nodemask);
@@ -9160,7 +9128,7 @@
 				"Can not alloc domain group for node %d\n", j);
 				goto error;
 			}
-			sg->__cpu_power = 0;
+			sg->cpu_power = 0;
 			cpumask_copy(sched_group_cpus(sg), tmpmask);
 			sg->next = prev->next;
 			cpumask_or(covered, covered, tmpmask);
Index: linux-2.6.31.4-rt14/include/linux/sched.h
===================================================================
--- linux-2.6.31.4-rt14.orig/include/linux/sched.h	2009-10-16 09:15:36.000000000 -0400
+++ linux-2.6.31.4-rt14/include/linux/sched.h	2009-10-16 09:15:38.000000000 -0400
@@ -905,15 +905,9 @@
 
 	/*
 	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
-	 * single CPU. This is read only (except for setup, hotplug CPU).
-	 * Note : Never change cpu_power without recompute its reciprocal
+	 * single CPU.
 	 */
-	unsigned int __cpu_power;
-	/*
-	 * reciprocal value of cpu_power to avoid expensive divides
-	 * (see include/linux/reciprocal_div.h)
-	 */
-	u32 reciprocal_cpu_power;
+	unsigned int cpu_power;
 
 	/*
 	 * The CPUs this group covers.

--
