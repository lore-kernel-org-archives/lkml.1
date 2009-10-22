Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZJVMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZJVMlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZJVMlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60371 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZJVMlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:12 -0400
Message-Id: <20091022124110.216791990@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:46 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 03/17] sched: update the cpu_power sum during load-balance
Content-Disposition: inline; filename=sched-lb-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prepare for a more dynamic cpu_power, update the group sum
while walking the sched domains during load-balance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 kernel/sched.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 09:15:30.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:32.000000000 -0400
@@ -3780,6 +3780,28 @@
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
@@ -3793,7 +3815,8 @@
  * @balance: Should we balance.
  * @sgs: variable to hold the statistics for this group.
  */
-static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+static inline void update_sg_lb_stats(struct sched_domain *sd,
+			struct sched_group *group, int this_cpu,
 			enum cpu_idle_type idle, int load_idx, int *sd_idle,
 			int local_group, const struct cpumask *cpus,
 			int *balance, struct sg_lb_stats *sgs)
@@ -3804,8 +3827,11 @@
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
@@ -3909,7 +3935,7 @@
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 		memset(&sgs, 0, sizeof(sgs));
-		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+		update_sg_lb_stats(sd, group, this_cpu, idle, load_idx, sd_idle,
 				local_group, cpus, balance, &sgs);
 
 		if (local_group && balance && !(*balance))
@@ -3944,7 +3970,6 @@
 		update_sd_power_savings_stats(group, sds, local_group, &sgs);
 		group = group->next;
 	} while (group != sd->groups);
-
 }
 
 /**

--
