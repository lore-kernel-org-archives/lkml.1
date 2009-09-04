Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZIDI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZIDI51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933031AbZIDI50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:57:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:40976 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933024AbZIDI5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:57:24 -0400
Date: Fri, 4 Sep 2009 08:56:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083826.425896304@chello.nl>
References: <20090901083826.425896304@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Remove reciprocal for cpu_power
Message-ID: <tip-18a3885fc1ffa92c2212ff0afdf033403d5b0fa0@git.kernel.org>
Git-Commit-ID: 18a3885fc1ffa92c2212ff0afdf033403d5b0fa0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:56:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  18a3885fc1ffa92c2212ff0afdf033403d5b0fa0
Gitweb:     http://git.kernel.org/tip/18a3885fc1ffa92c2212ff0afdf033403d5b0fa0
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:56 +0200

sched: Remove reciprocal for cpu_power

Its a source of fail, also, now that cpu_power is dynamical,
its a waste of time.

before:
<idle>-0   [000]   132.877936: find_busiest_group: avg_load: 0 group_load: 8241 power: 1

after:
bash-1689  [001]   137.862151: find_busiest_group: avg_load: 10636288 group_load: 10387 power: 1

[ v2: build fix from From: Andreas Herrmann ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083826.425896304@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |   10 +----
 kernel/sched.c        |  101 ++++++++++++++++--------------------------------
 2 files changed, 36 insertions(+), 75 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c67ddf3..3b7f43e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -860,15 +860,9 @@ struct sched_group {
 
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
diff --git a/kernel/sched.c b/kernel/sched.c
index e1ebf9b..b537853 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -64,7 +64,6 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
-#include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
 #include <linux/pagemap.h>
 #include <linux/hrtimer.h>
@@ -120,30 +119,8 @@
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
@@ -2335,8 +2312,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		}
 
 		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
+		avg_load = (avg_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 		if (local_group) {
 			this_load = avg_load;
@@ -3768,7 +3744,6 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	unsigned long weight = cpumask_weight(sched_domain_span(sd));
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
-	unsigned long old = sdg->__cpu_power;
 
 	/* here we could scale based on cpufreq */
 
@@ -3783,33 +3758,26 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
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
@@ -3889,8 +3857,7 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	}
 
 	/* Adjust by relative CPU power of the group */
-	sgs->avg_load = sg_div_cpu_power(group,
-			sgs->group_load * SCHED_LOAD_SCALE);
+	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 
 	/*
@@ -3902,14 +3869,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
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
@@ -3951,7 +3918,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			return;
 
 		sds->total_load += sgs.group_load;
-		sds->total_pwr += group->__cpu_power;
+		sds->total_pwr += group->cpu_power;
 
 		/*
 		 * In case the child domain prefers tasks go to siblings
@@ -4016,28 +3983,28 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
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
 
@@ -4072,8 +4039,8 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 			sds->max_load - sds->busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * sds->busiest->__cpu_power,
-		(sds->avg_load - sds->this_load) * sds->this->__cpu_power)
+	*imbalance = min(max_pull * sds->busiest->cpu_power,
+		(sds->avg_load - sds->this_load) * sds->this->cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -4208,7 +4175,7 @@ static unsigned long power_of(int cpu)
 	if (!group)
 		return SCHED_LOAD_SCALE;
 
-	return group->__cpu_power;
+	return group->cpu_power;
 }
 
 /*
@@ -7922,7 +7889,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 			break;
 		}
 
-		if (!group->__cpu_power) {
+		if (!group->cpu_power) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: domain->cpu_power not "
 					"set\n");
@@ -7946,9 +7913,9 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
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
@@ -8233,7 +8200,7 @@ init_sched_build_groups(const struct cpumask *span,
 			continue;
 
 		cpumask_clear(sched_group_cpus(sg));
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 
 		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
@@ -8491,7 +8458,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 				continue;
 			}
 
-			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+			sg->cpu_power += sd->groups->cpu_power;
 		}
 		sg = sg->next;
 	} while (sg != group_head);
@@ -8528,7 +8495,7 @@ static int build_numa_sched_groups(struct s_data *d,
 		sd->groups = sg;
 	}
 
-	sg->__cpu_power = 0;
+	sg->cpu_power = 0;
 	cpumask_copy(sched_group_cpus(sg), d->nodemask);
 	sg->next = sg;
 	cpumask_or(d->covered, d->covered, d->nodemask);
@@ -8551,7 +8518,7 @@ static int build_numa_sched_groups(struct s_data *d,
 			       "Can not alloc domain group for node %d\n", j);
 			return -ENOMEM;
 		}
-		sg->__cpu_power = 0;
+		sg->cpu_power = 0;
 		cpumask_copy(sched_group_cpus(sg), d->tmpmask);
 		sg->next = prev->next;
 		cpumask_or(d->covered, d->covered, d->tmpmask);
@@ -8629,7 +8596,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	child = sd->child;
 
-	sd->groups->__cpu_power = 0;
+	sd->groups->cpu_power = 0;
 
 	if (!child) {
 		power = SCHED_LOAD_SCALE;
@@ -8645,7 +8612,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 			power /= weight;
 			power >>= SCHED_LOAD_SHIFT;
 		}
-		sg_inc_cpu_power(sd->groups, power);
+		sd->groups->cpu_power += power;
 		return;
 	}
 
@@ -8654,7 +8621,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	 */
 	group = child->groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sd->groups->cpu_power += group->cpu_power;
 		group = group->next;
 	} while (group != child->groups);
 }
