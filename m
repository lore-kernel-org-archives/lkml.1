Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbZCYJQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbZCYJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbZCYJOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:30 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34650 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577AbZCYJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:28 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 05/11] sched: Define structure to store the sched_domain
	statistics for fbg()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:43:56 +0530
Message-ID: <20090325091356.13992.25970.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we use a lot of local variables in find_busiest_group() to capture
the various statistics related to the sched_domain. Group them together into a
single data structure.

This will help us to offload the job of updating the sched_domain statistics
to a helper function.

Credit: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |  207 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 121 insertions(+), 86 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d2e9b8a..c1b92da 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3086,6 +3086,37 @@ static int move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	return 0;
 }
 /********** Helpers for find_busiest_group ************************/
+/**
+ * sd_lb_stats - Structure to store the statistics of a sched_domain
+ * 		during load balancing.
+ */
+struct sd_lb_stats {
+	struct sched_group *busiest; /* Busiest group in this sd */
+	struct sched_group *this;  /* Local group in this sd */
+	unsigned long total_load;  /* Total load of all groups in sd */
+	unsigned long total_pwr;   /*	Total power of all groups in sd */
+	unsigned long avg_load;	   /* Average load across all groups in sd */
+
+	/** Statistics of this group */
+	unsigned long this_load;
+	unsigned long this_load_per_task;
+	unsigned long this_nr_running;
+
+	/* Statistics of the busiest group */
+	unsigned long max_load;
+	unsigned long busiest_load_per_task;
+	unsigned long busiest_nr_running;
+
+	int group_imb; /* Is there imbalance in this sd */
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+	int power_savings_balance; /* Is powersave balance needed for this sd */
+	struct sched_group *group_min; /* Least loaded group in sd */
+	struct sched_group *group_leader; /* Group which relieves group_min */
+	unsigned long min_load_per_task; /* load_per_task in group_min */
+	unsigned long leader_nr_running; /* Nr running of group_leader */
+	unsigned long min_nr_running; /* Nr running of group_min */
+#endif
+};
 
 /**
  * sg_lb_stats - stats of a sched_group required for load_balancing
@@ -3242,23 +3273,16 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
 		   int *sd_idle, const struct cpumask *cpus, int *balance)
 {
-	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
-	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
+	struct sd_lb_stats sds;
+	struct sched_group *group = sd->groups;
 	unsigned long max_pull;
-	unsigned long busiest_load_per_task, busiest_nr_running;
-	unsigned long this_load_per_task, this_nr_running;
-	int load_idx, group_imb = 0;
+	int load_idx;
+
+	memset(&sds, 0, sizeof(sds));
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance = 1;
-	unsigned long leader_nr_running = 0, min_load_per_task = 0;
-	unsigned long min_nr_running = ULONG_MAX;
-	struct sched_group *group_min = NULL, *group_leader = NULL;
+	sds.power_savings_balance = 1;
+	sds.min_nr_running = ULONG_MAX;
 #endif
-
-	max_load = this_load = total_load = total_pwr = 0;
-	busiest_load_per_task = busiest_nr_running = 0;
-	this_load_per_task = this_nr_running = 0;
-
 	load_idx = get_sd_load_idx(sd, idle);
 
 	do {
@@ -3274,22 +3298,22 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (balance && !(*balance))
 			goto ret;
 
-		total_load += sgs.group_load;
-		total_pwr += group->__cpu_power;
+		sds.total_load += sgs.group_load;
+		sds.total_pwr += group->__cpu_power;
 
 		if (local_group) {
-			this_load = sgs.avg_load;
-			this = group;
-			this_nr_running = sgs.sum_nr_running;
-			this_load_per_task = sgs.sum_weighted_load;
-		} else if (sgs.avg_load > max_load &&
+			sds.this_load = sgs.avg_load;
+			sds.this = group;
+			sds.this_nr_running = sgs.sum_nr_running;
+			sds.this_load_per_task = sgs.sum_weighted_load;
+		} else if (sgs.avg_load > sds.max_load &&
 			   (sgs.sum_nr_running > sgs.group_capacity ||
 				sgs.group_imb)) {
-			max_load = sgs.avg_load;
-			busiest = group;
-			busiest_nr_running = sgs.sum_nr_running;
-			busiest_load_per_task = sgs.sum_weighted_load;
-			group_imb = sgs.group_imb;
+			sds.max_load = sgs.avg_load;
+			sds.busiest = group;
+			sds.busiest_nr_running = sgs.sum_nr_running;
+			sds.busiest_load_per_task = sgs.sum_weighted_load;
+			sds.group_imb = sgs.group_imb;
 		}
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -3305,15 +3329,16 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * If the local group is idle or completely loaded
 		 * no need to do power savings balance at this domain
 		 */
-		if (local_group && (this_nr_running >= sgs.group_capacity ||
-				    !this_nr_running))
-			power_savings_balance = 0;
+		if (local_group &&
+			(sds.this_nr_running >= sgs.group_capacity ||
+			!sds.this_nr_running))
+			sds.power_savings_balance = 0;
 
 		/*
 		 * If a group is already running at full capacity or idle,
 		 * don't include that group in power savings calculations
 		 */
-		if (!power_savings_balance ||
+		if (!sds.power_savings_balance ||
 			sgs.sum_nr_running >= sgs.group_capacity ||
 			!sgs.sum_nr_running)
 			goto group_next;
@@ -3323,12 +3348,13 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * This is the group from where we need to pick up the load
 		 * for saving power
 		 */
-		if ((sgs.sum_nr_running < min_nr_running) ||
-		    (sgs.sum_nr_running == min_nr_running &&
-		     group_first_cpu(group) > group_first_cpu(group_min))) {
-			group_min = group;
-			min_nr_running = sgs.sum_nr_running;
-			min_load_per_task = sgs.sum_weighted_load /
+		if ((sgs.sum_nr_running < sds.min_nr_running) ||
+		    (sgs.sum_nr_running == sds.min_nr_running &&
+		     group_first_cpu(group) >
+			group_first_cpu(sds.group_min))) {
+			sds.group_min = group;
+			sds.min_nr_running = sgs.sum_nr_running;
+			sds.min_load_per_task = sgs.sum_weighted_load /
 						sgs.sum_nr_running;
 		}
 
@@ -3340,29 +3366,32 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		if (sgs.sum_nr_running > sgs.group_capacity - 1)
 			goto group_next;
 
-		if (sgs.sum_nr_running > leader_nr_running ||
-		    (sgs.sum_nr_running == leader_nr_running &&
-		     group_first_cpu(group) < group_first_cpu(group_leader))) {
-			group_leader = group;
-			leader_nr_running = sgs.sum_nr_running;
+		if (sgs.sum_nr_running > sds.leader_nr_running ||
+		    (sgs.sum_nr_running == sds.leader_nr_running &&
+		     group_first_cpu(group) <
+			group_first_cpu(sds.group_leader))) {
+			sds.group_leader = group;
+			sds.leader_nr_running = sgs.sum_nr_running;
 		}
 group_next:
 #endif
 		group = group->next;
 	} while (group != sd->groups);
 
-	if (!busiest || this_load >= max_load || busiest_nr_running == 0)
+	if (!sds.busiest || sds.this_load >= sds.max_load
+		|| sds.busiest_nr_running == 0)
 		goto out_balanced;
 
-	avg_load = (SCHED_LOAD_SCALE * total_load) / total_pwr;
+	sds.avg_load = (SCHED_LOAD_SCALE * sds.total_load) / sds.total_pwr;
 
-	if (this_load >= avg_load ||
-			100*max_load <= sd->imbalance_pct*this_load)
+	if (sds.this_load >= sds.avg_load ||
+			100*sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
-	busiest_load_per_task /= busiest_nr_running;
-	if (group_imb)
-		busiest_load_per_task = min(busiest_load_per_task, avg_load);
+	sds.busiest_load_per_task /= sds.busiest_nr_running;
+	if (sds.group_imb)
+		sds.busiest_load_per_task =
+			min(sds.busiest_load_per_task, sds.avg_load);
 
 	/*
 	 * We're trying to get all the cpus to the average_load, so we don't
@@ -3375,7 +3404,7 @@ group_next:
 	 * by pulling tasks to us. Be careful of negative numbers as they'll
 	 * appear as very large values with unsigned longs.
 	 */
-	if (max_load <= busiest_load_per_task)
+	if (sds.max_load <= sds.busiest_load_per_task)
 		goto out_balanced;
 
 	/*
@@ -3383,17 +3412,18 @@ group_next:
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (max_load < avg_load) {
+	if (sds.max_load < sds.avg_load) {
 		*imbalance = 0;
 		goto small_imbalance;
 	}
 
 	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(max_load - avg_load, max_load - busiest_load_per_task);
+	max_pull = min(sds.max_load - sds.avg_load,
+			sds.max_load - sds.busiest_load_per_task);
 
 	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * busiest->__cpu_power,
-				(avg_load - this_load) * this->__cpu_power)
+	*imbalance = min(max_pull * sds.busiest->__cpu_power,
+			(sds.avg_load - sds.this_load) * sds.this->__cpu_power)
 			/ SCHED_LOAD_SCALE;
 
 	/*
@@ -3402,24 +3432,27 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < busiest_load_per_task) {
+	if (*imbalance < sds.busiest_load_per_task) {
 		unsigned long tmp, pwr_now, pwr_move;
 		unsigned int imbn;
 
 small_imbalance:
 		pwr_move = pwr_now = 0;
 		imbn = 2;
-		if (this_nr_running) {
-			this_load_per_task /= this_nr_running;
-			if (busiest_load_per_task > this_load_per_task)
+		if (sds.this_nr_running) {
+			sds.this_load_per_task /= sds.this_nr_running;
+			if (sds.busiest_load_per_task >
+					sds.this_load_per_task)
 				imbn = 1;
 		} else
-			this_load_per_task = cpu_avg_load_per_task(this_cpu);
-
-		if (max_load - this_load + busiest_load_per_task >=
-					busiest_load_per_task * imbn) {
-			*imbalance = busiest_load_per_task;
-			return busiest;
+			sds.this_load_per_task =
+				cpu_avg_load_per_task(this_cpu);
+
+		if (sds.max_load - sds.this_load +
+			sds.busiest_load_per_task >=
+				sds.busiest_load_per_task * imbn) {
+			*imbalance = sds.busiest_load_per_task;
+			return sds.busiest;
 		}
 
 		/*
@@ -3428,52 +3461,54 @@ small_imbalance:
 		 * moving them.
 		 */
 
-		pwr_now += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load);
-		pwr_now += this->__cpu_power *
-				min(this_load_per_task, this_load);
+		pwr_now += sds.busiest->__cpu_power *
+				min(sds.busiest_load_per_task, sds.max_load);
+		pwr_now += sds.this->__cpu_power *
+				min(sds.this_load_per_task, sds.this_load);
 		pwr_now /= SCHED_LOAD_SCALE;
 
 		/* Amount of load we'd subtract */
-		tmp = sg_div_cpu_power(busiest,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		if (max_load > tmp)
-			pwr_move += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load - tmp);
+		tmp = sg_div_cpu_power(sds.busiest,
+				sds.busiest_load_per_task * SCHED_LOAD_SCALE);
+		if (sds.max_load > tmp)
+			pwr_move += sds.busiest->__cpu_power *
+				min(sds.busiest_load_per_task,
+						sds.max_load - tmp);
 
 		/* Amount of load we'd add */
-		if (max_load * busiest->__cpu_power <
-				busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = sg_div_cpu_power(this,
-					max_load * busiest->__cpu_power);
+		if (sds.max_load * sds.busiest->__cpu_power <
+				sds.busiest_load_per_task * SCHED_LOAD_SCALE)
+			tmp = sg_div_cpu_power(sds.this,
+				sds.max_load * sds.busiest->__cpu_power);
 		else
-			tmp = sg_div_cpu_power(this,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		pwr_move += this->__cpu_power *
-				min(this_load_per_task, this_load + tmp);
+			tmp = sg_div_cpu_power(sds.this,
+				sds.busiest_load_per_task * SCHED_LOAD_SCALE);
+		pwr_move += sds.this->__cpu_power *
+				min(sds.this_load_per_task,
+					sds.this_load + tmp);
 		pwr_move /= SCHED_LOAD_SCALE;
 
 		/* Move if we gain throughput */
 		if (pwr_move > pwr_now)
-			*imbalance = busiest_load_per_task;
+			*imbalance = sds.busiest_load_per_task;
 	}
 
-	return busiest;
+	return sds.busiest;
 
 out_balanced:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
 		goto ret;
 
-	if (this != group_leader || group_leader == group_min)
+	if (sds.this != sds.group_leader || sds.group_leader == sds.group_min)
 		goto ret;
 
-	*imbalance = min_load_per_task;
+	*imbalance = sds.min_load_per_task;
 	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
 		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-			group_first_cpu(group_leader);
+			group_first_cpu(sds.group_leader);
 	}
-	return group_min;
+	return sds.group_min;
 
 #endif
 ret:

