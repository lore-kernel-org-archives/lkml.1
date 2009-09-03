Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbZICNX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbZICNX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZICNXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:23:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37070 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbZICNXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:23:20 -0400
Message-Id: <20090903132212.317982805@chello.nl>
References: <20090903132145.482814810@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 03 Sep 2009 15:21:48 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 03/14] sched: update the cpu_power sum during load-balance
Content-Disposition: inline; filename=sched-lb-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare for a more dynamic cpu_power, update the group sum
while walking the sched domains during load-balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3699,6 +3699,28 @@ static inline int check_power_save_busie
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
+static void update_sched_power(struct sched_domain *sd)
+{
+	struct sched_domain *child = sd->child;
+	struct sched_group *group, *sdg = sd->groups;
+	unsigned long power = sdg->__cpu_power;
+
+	if (!child) {
+		/* compute cpu power for this cpu */
+		return;
+	}
+
+	sdg->__cpu_power = 0;
+
+	group = child->groups;
+	do {
+		sdg->__cpu_power += group->__cpu_power;
+		group = group->next;
+	} while (group != child->groups);
+
+	if (power != sdg->__cpu_power)
+		sdg->reciprocal_cpu_power = reciprocal_value(sdg->__cpu_power);
+}
 
 /**
  * update_sg_lb_stats - Update sched_group's statistics for load balancing.
@@ -3712,7 +3734,8 @@ static inline int check_power_save_busie
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+static inline void update_sg_lb_stats(struct sched_domain *sd,
+			struct sched_group *group, int this_cpu,
 			enum cpu_idle_type idle, int load_idx, int *sd_idle,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
@@ -3723,8 +3746,11 @@ static inline void update_sg_lb_stats(st
 	unsigned long sum_avg_load_per_task;
 	unsigned long avg_load_per_task;
 
-	if (local_group)
+	if (local_group) {
 		balance_cpu = group_first_cpu(group);
+		if (balance_cpu == this_cpu)
+			update_sched_power(sd);
+	}
 
 	/* Tally up the load of all CPUs in the group */
 	sum_avg_load_per_task = avg_load_per_task = 0;
@@ -3828,7 +3854,7 @@ static inline void update_sd_lb_stats(st
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && balance && !(*balance))
@@ -3863,7 +3889,6 @@ static inline void update_sd_lb_stats(st
 		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
-
 }
 
 /**

-- 

