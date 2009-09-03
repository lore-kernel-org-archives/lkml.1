Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZICNX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZICNX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZICNXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37069 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZICNXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:19 -0400
Message-Id: <20090903132212.822243547@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:53 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 08/14] sched: remove reciprocal for cpu_power
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
---
 include/linux/sched.h |   10 +----
 kernel/sched.c        |  100 +++++++++++++++++---------------------------------
 2 files changed, 36 insertions(+), 74 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -120,30 +120,8 @@
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
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO || policy == SCHED_RR))
@@ -2335,8 +2313,7 @@ find_idlest_group(struct sched_domain *s
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -3768,7 +3745,6 @@ static void update_cpu_power(struct sche
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
-	unsigned long old = sdg->__cpu_power;
 
 	/* here we could scale based on cpufreq */
 
@@ -3783,33 +3759,26 @@ static void update_cpu_power(struct sche
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
@@ -3889,8 +3858,7 @@ static inline void update_sg_lb_stats(st
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = sg_div_cpu_power(group,
-			sgs->group_load * SCHED_LOAD_SCALE);
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 
 	/*
@@ -3902,14 +3870,14 @@ static inline void update_sg_lb_stats(st
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
@@ -3951,7 +3919,7 @@ static inline void update_sd_lb_stats(st
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->__cpu_power;
+		sds->total_pwr += group->cpu_power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4016,28 +3984,28 @@ static inline void fix_small_imbalance(s
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
 
@@ -4072,8 +4040,8 @@ static inline void calculate_imbalance(s
 			sds->max_load - sds->busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->__cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
+	*imbalance = min(max_pull * sds->busiest->cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -4208,7 +4176,7 @@ static unsigned long power_of(int cpu)
 	if (!group)
 		return SCHED_LOAD_SCALE;
 
-	return group->__cpu_power;
+	return group->cpu_power;
 }
 
 /*
@@ -7934,7 +7902,7 @@ static int sched_domain_debug_one(struct
 			break;
 		}
 
-		if (!group->__cpu_power) {
+		if (!group->cpu_power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -7958,9 +7926,9 @@ static int sched_domain_debug_one(struct
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
@@ -8245,7 +8213,7 @@ init_sched_build_groups(const struct cpu
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 
 		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
@@ -8503,7 +8471,7 @@ static void init_numa_sched_groups_power
 				continue;
 			}
 
-			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+			sg->cpu_power += sd->groups->cpu_power;
 		}
 		sg = sg->next;
 	} while (sg != group_head);
@@ -8540,7 +8508,7 @@ static int build_numa_sched_groups(struc
 		sd->groups = sg;
 	}
 
-	sg->__cpu_power = 0;
+	sg->cpu_power = 0;
 	cpumask_copy(sched_group_cpus(sg), d->nodemask);
 	sg->next = sg;
 	cpumask_or(d->covered, d->covered, d->nodemask);
@@ -8563,7 +8531,7 @@ static int build_numa_sched_groups(struc
 			       "Can not alloc domain group for node %d\n", j);
 			return -ENOMEM;
 		}
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
 		sg->next = prev->next;
 		cpumask_or(d->covered, d->covered, d->tmpmask);
@@ -8641,7 +8609,7 @@ static void init_sched_groups_power(int 
 
 	child = sd->child;
 
-	sd->groups->__cpu_power = 0;
+	sd->groups->cpu_power = 0;
 
 	if (!child) {
 		power = SCHED_LOAD_SCALE;
@@ -8657,7 +8625,7 @@ static void init_sched_groups_power(int 
 			power /= weight;
 			power >>= SCHED_LOAD_SHIFT;
 		}
-		sg_inc_cpu_power(sd->groups, power);
+		sd->groups->cpu_power += power;
 		return;
 	}
 
@@ -8666,7 +8634,7 @@ static void init_sched_groups_power(int 
 	 */
 	group = child->groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sd->groups->cpu_power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
 }
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -870,15 +870,9 @@ struct sched_group {
 
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

