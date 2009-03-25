Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZCYJsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZCYJsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbZCYJrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:46430 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759180AbZCYJrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:19 -0400
Date: Wed, 25 Mar 2009 09:46:24 GMT
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, bharata@linux.vnet.ibm.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090325091351.13992.43461.stgit@sofia.in.ibm.com>
References: <20090325091351.13992.43461.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Create a helper function to calculate sched_group stats for fbg()
Message-ID: <tip-1f8c553d0f11d85f7993fe21015695d266771c00@git.kernel.org>
Git-Commit-ID: 1f8c553d0f11d85f7993fe21015695d266771c00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f8c553d0f11d85f7993fe21015695d266771c00
Gitweb:     http://git.kernel.org/tip/1f8c553d0f11d85f7993fe21015695d266771c00
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:43:51 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:45 +0100

sched: Create a helper function to calculate sched_group stats for fbg()

Impact: cleanup

Create a helper function named update_sg_lb_stats() which
can be invoked to calculate the individual group's statistics
in find_busiest_group().

This reduces the lenght of find_busiest_group() considerably.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Aked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
LKML-Reference: <20090325091351.13992.43461.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |  175 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 100 insertions(+), 75 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 109db12..1893d55 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3237,6 +3237,103 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 
 	return load_idx;
 }
+
+
+/**
+ * update_sg_lb_stats - Update sched_group's statistics for load balancing.
+ * @group: sched_group whose statistics are to be updated.
+ * @this_cpu: Cpu for which load balance is currently performed.
+ * @idle: Idle status of this_cpu
+ * @load_idx: Load index of sched_domain of this_cpu for load calc.
+ * @sd_idle: Idle status of the sched_domain containing group.
+ * @local_group: Does group contain this_cpu.
+ * @cpus: Set of cpus considered for load balancing.
+ * @balance: Should we balance.
+ * @sgs: variable to hold the statistics for this group.
+ */
+static inline void update_sg_lb_stats(struct sched_group *group, int this_cpu,
+			enum cpu_idle_type idle, int load_idx, int *sd_idle,
+			int local_group, const struct cpumask *cpus,
+			int *balance, struct sg_lb_stats *sgs)
+{
+	unsigned long load, max_cpu_load, min_cpu_load;
+	int i;
+	unsigned int balance_cpu = -1, first_idle_cpu = 0;
+	unsigned long sum_avg_load_per_task;
+	unsigned long avg_load_per_task;
+
+	if (local_group)
+		balance_cpu = group_first_cpu(group);
+
+	/* Tally up the load of all CPUs in the group */
+	sum_avg_load_per_task = avg_load_per_task = 0;
+	max_cpu_load = 0;
+	min_cpu_load = ~0UL;
+
+	for_each_cpu_and(i, sched_group_cpus(group), cpus) {
+		struct rq *rq = cpu_rq(i);
+
+		if (*sd_idle && rq->nr_running)
+			*sd_idle = 0;
+
+		/* Bias balancing toward cpus of our domain */
+		if (local_group) {
+			if (idle_cpu(i) && !first_idle_cpu) {
+				first_idle_cpu = 1;
+				balance_cpu = i;
+			}
+
+			load = target_load(i, load_idx);
+		} else {
+			load = source_load(i, load_idx);
+			if (load > max_cpu_load)
+				max_cpu_load = load;
+			if (min_cpu_load > load)
+				min_cpu_load = load;
+		}
+
+		sgs->group_load += load;
+		sgs->sum_nr_running += rq->nr_running;
+		sgs->sum_weighted_load += weighted_cpuload(i);
+
+		sum_avg_load_per_task += cpu_avg_load_per_task(i);
+	}
+
+	/*
+	 * First idle cpu or the first cpu(busiest) in this sched group
+	 * is eligible for doing load balancing at this and above
+	 * domains. In the newly idle case, we will allow all the cpu's
+	 * to do the newly idle load balance.
+	 */
+	if (idle != CPU_NEWLY_IDLE && local_group &&
+	    balance_cpu != this_cpu && balance) {
+		*balance = 0;
+		return;
+	}
+
+	/* Adjust by relative CPU power of the group */
+	sgs->avg_load = sg_div_cpu_power(group,
+			sgs->group_load * SCHED_LOAD_SCALE);
+
+
+	/*
+	 * Consider the group unbalanced when the imbalance is larger
+	 * than the average weight of two tasks.
+	 *
+	 * APZ: with cgroup the avg task weight can vary wildly and
+	 *      might not be a suitable number - should we keep a
+	 *      normalized nr_running number somewhere that negates
+	 *      the hierarchy?
+	 */
+	avg_load_per_task = sg_div_cpu_power(group,
+			sum_avg_load_per_task * SCHED_LOAD_SCALE);
+
+	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
+		sgs->group_imb = 1;
+
+	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
+
+}
 /******* find_busiest_group() helpers end here *********************/
 
 /*
@@ -3270,92 +3367,20 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 
 	do {
 		struct sg_lb_stats sgs;
-		unsigned long load, max_cpu_load, min_cpu_load;
 		int local_group;
-		int i;
-		unsigned int balance_cpu = -1, first_idle_cpu = 0;
-		unsigned long sum_avg_load_per_task;
-		unsigned long avg_load_per_task;
 
 		local_group = cpumask_test_cpu(this_cpu,
 					       sched_group_cpus(group));
 		memset(&sgs, 0, sizeof(sgs));
+		update_sg_lb_stats(group, this_cpu, idle, load_idx, sd_idle,
+				local_group, cpus, balance, &sgs);
 
-		if (local_group)
-			balance_cpu = group_first_cpu(group);
-
-		/* Tally up the load of all CPUs in the group */
-		sum_avg_load_per_task = avg_load_per_task = 0;
-
-		max_cpu_load = 0;
-		min_cpu_load = ~0UL;
-
-		for_each_cpu_and(i, sched_group_cpus(group), cpus) {
-			struct rq *rq = cpu_rq(i);
-
-			if (*sd_idle && rq->nr_running)
-				*sd_idle = 0;
-
-			/* Bias balancing toward cpus of our domain */
-			if (local_group) {
-				if (idle_cpu(i) && !first_idle_cpu) {
-					first_idle_cpu = 1;
-					balance_cpu = i;
-				}
-
-				load = target_load(i, load_idx);
-			} else {
-				load = source_load(i, load_idx);
-				if (load > max_cpu_load)
-					max_cpu_load = load;
-				if (min_cpu_load > load)
-					min_cpu_load = load;
-			}
-
-			sgs.group_load += load;
-			sgs.sum_nr_running += rq->nr_running;
-			sgs.sum_weighted_load += weighted_cpuload(i);
-
-			sum_avg_load_per_task += cpu_avg_load_per_task(i);
-		}
-
-		/*
-		 * First idle cpu or the first cpu(busiest) in this sched group
-		 * is eligible for doing load balancing at this and above
-		 * domains. In the newly idle case, we will allow all the cpu's
-		 * to do the newly idle load balance.
-		 */
-		if (idle != CPU_NEWLY_IDLE && local_group &&
-		    balance_cpu != this_cpu && balance) {
-			*balance = 0;
+		if (balance && !(*balance))
 			goto ret;
-		}
 
 		total_load += sgs.group_load;
 		total_pwr += group->__cpu_power;
 
-		/* Adjust by relative CPU power of the group */
-		sgs.avg_load = sg_div_cpu_power(group,
-				sgs.group_load * SCHED_LOAD_SCALE);
-
-
-		/*
-		 * Consider the group unbalanced when the imbalance is larger
-		 * than the average weight of two tasks.
-		 *
-		 * APZ: with cgroup the avg task weight can vary wildly and
-		 *      might not be a suitable number - should we keep a
-		 *      normalized nr_running number somewhere that negates
-		 *      the hierarchy?
-		 */
-		avg_load_per_task = sg_div_cpu_power(group,
-				sum_avg_load_per_task * SCHED_LOAD_SCALE);
-
-		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
-			sgs.group_imb = 1;
-
-		sgs.group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
 		if (local_group) {
 			this_load = sgs.avg_load;
 			this = group;
