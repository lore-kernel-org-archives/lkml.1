Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYIXQQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYIXQQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbYIXQOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:14:48 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:41163 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbYIXQOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:14:44 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 5/5] Split find_busiest_group()
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2008 21:48:22 +0530
Message-ID: <20080924161822.31581.71135.stgit@drishya.in.ibm.com>
In-Reply-To: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
References: <20080924161228.31581.57651.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the previously defined helper functions and data
structures and split the find_busiest_group() function into
smaller modular functions.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |  324 +++++++++++---------------------------------------------
 1 files changed, 64 insertions(+), 260 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 1f38e2c..1cd2e60 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3387,7 +3387,6 @@ static struct sched_group *powersavings_balance_group(struct sd_loads *sdl,
 	return NULL;
 }
 #endif
-
 /*
  * find_busiest_group finds and returns the busiest CPU group within the
  * domain. It calculates and returns the amount of weighted load which
@@ -3398,208 +3397,55 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
 		   int *sd_idle, const cpumask_t *cpus, int *balance)
 {
-	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
-	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
+	struct sched_group *group = sd->groups;
 	unsigned long max_pull;
-	unsigned long busiest_load_per_task, busiest_nr_running;
-	unsigned long this_load_per_task, this_nr_running;
-	int load_idx, group_imb = 0;
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	int power_savings_balance = 1;
-	unsigned long leader_nr_running = 0, min_load_per_task = 0;
-	unsigned long min_nr_running = ULONG_MAX;
-	struct sched_group *group_min = NULL, *group_leader = NULL;
-#endif
+	int load_idx;
+	struct group_loads gl;
+	struct sd_loads sdl;
 
-	max_load = this_load = total_load = total_pwr = 0;
-	busiest_load_per_task = busiest_nr_running = 0;
-	this_load_per_task = this_nr_running = 0;
+	memset(&sdl, 0, sizeof(sdl));
+	sdl.sd = sd;
 
-	if (idle == CPU_NOT_IDLE)
-		load_idx = sd->busy_idx;
-	else if (idle == CPU_NEWLY_IDLE)
-		load_idx = sd->newidle_idx;
-	else
-		load_idx = sd->idle_idx;
+	/* Get the load index corresponding to cpu idle state */
+	load_idx = get_load_idx(sd, idle);
 
 	do {
-		unsigned long load, group_capacity, max_cpu_load, min_cpu_load;
-		int local_group;
-		int i;
-		int __group_imb = 0;
-		unsigned int balance_cpu = -1, first_idle_cpu = 0;
-		unsigned long sum_nr_running, sum_weighted_load;
-		unsigned long sum_avg_load_per_task;
-		unsigned long avg_load_per_task;
-
-		local_group = cpu_isset(this_cpu, group->cpumask);
-
-		if (local_group)
-			balance_cpu = first_cpu(group->cpumask);
+		int need_balance;
 
-		/* Tally up the load of all CPUs in the group */
-		sum_weighted_load = sum_nr_running = avg_load = 0;
-		sum_avg_load_per_task = avg_load_per_task = 0;
-
-		max_cpu_load = 0;
-		min_cpu_load = ~0UL;
-
-		for_each_cpu_mask_nr(i, group->cpumask) {
-			struct rq *rq;
-
-			if (!cpu_isset(i, *cpus))
-				continue;
+		need_balance = get_group_loads(group, this_cpu, cpus, idle,
+					       load_idx, &gl);
 
-			rq = cpu_rq(i);
+		if (*sd_idle && gl.nr_running)
+			*sd_idle = 0;
 
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
-			avg_load += load;
-			sum_nr_running += rq->nr_running;
-			sum_weighted_load += weighted_cpuload(i);
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
+		if (!need_balance && balance) {
 			*balance = 0;
-			goto ret;
+			*imbalance = 0;
+			return NULL;
 		}
 
-		total_load += avg_load;
-		total_pwr += group->__cpu_power;
+		/* Compare groups and find busiest non-local group */
+		update_sd_loads(&sdl, &gl);
+		/* Compare groups and find power saving candidates */
+		update_powersavings_group_loads(&sdl, &gl, idle);
 
-		/* Adjust by relative CPU power of the group */
-		avg_load = sg_div_cpu_power(group,
-				avg_load * SCHED_LOAD_SCALE);
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
-			__group_imb = 1;
-
-		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
-		if (local_group) {
-			this_load = avg_load;
-			this = group;
-			this_nr_running = sum_nr_running;
-			this_load_per_task = sum_weighted_load;
-		} else if (avg_load > max_load &&
-			   (sum_nr_running > group_capacity || __group_imb)) {
-			max_load = avg_load;
-			busiest = group;
-			busiest_nr_running = sum_nr_running;
-			busiest_load_per_task = sum_weighted_load;
-			group_imb = __group_imb;
-		}
-
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-		/*
-		 * Busy processors will not participate in power savings
-		 * balance.
-		 */
-		if (idle == CPU_NOT_IDLE ||
-				!(sd->flags & SD_POWERSAVINGS_BALANCE))
-			goto group_next;
-
-		/*
-		 * If the local group is idle or completely loaded
-		 * no need to do power savings balance at this domain
-		 */
-		if (local_group && (this_nr_running >= group_capacity ||
-				    !this_nr_running))
-			power_savings_balance = 0;
-
-		/*
-		 * If a group is already running at full capacity or idle,
-		 * don't include that group in power savings calculations
-		 */
-		if (!power_savings_balance || sum_nr_running >= group_capacity
-		    || !sum_nr_running)
-			goto group_next;
-
-		/*
-		 * Calculate the group which has the least non-idle load.
-		 * This is the group from where we need to pick up the load
-		 * for saving power
-		 */
-		if ((sum_nr_running < min_nr_running) ||
-		    (sum_nr_running == min_nr_running &&
-		     first_cpu(group->cpumask) <
-		     first_cpu(group_min->cpumask))) {
-			group_min = group;
-			min_nr_running = sum_nr_running;
-			min_load_per_task = sum_weighted_load /
-						sum_nr_running;
-		}
-
-		/*
-		 * Calculate the group which is almost near its
-		 * capacity but still has some space to pick up some load
-		 * from other group and save more power
-		 */
-		if (sum_nr_running <= group_capacity - 1) {
-			if (sum_nr_running > leader_nr_running ||
-			    (sum_nr_running == leader_nr_running &&
-			     first_cpu(group->cpumask) >
-			      first_cpu(group_leader->cpumask))) {
-				group_leader = group;
-				leader_nr_running = sum_nr_running;
-			}
-		}
-group_next:
-#endif
 		group = group->next;
 	} while (group != sd->groups);
 
-	if (!busiest || this_load >= max_load || busiest_nr_running == 0)
+	if (!sdl.busiest.group ||
+	     sdl.local.load >= sdl.max_load ||
+	     sdl.busiest.nr_running == 0)
 		goto out_balanced;
 
-	avg_load = (SCHED_LOAD_SCALE * total_load) / total_pwr;
+	sdl.avg_load = (SCHED_LOAD_SCALE * sdl.load) / sdl.cpu_power;
 
-	if (this_load >= avg_load ||
-			100*max_load <= sd->imbalance_pct*this_load)
+	if (sdl.local.load >= sdl.avg_load ||
+			100*sdl.load <= sd->imbalance_pct*sdl.local.load)
 		goto out_balanced;
 
-	busiest_load_per_task /= busiest_nr_running;
-	if (group_imb)
-		busiest_load_per_task = min(busiest_load_per_task, avg_load);
+	if (sdl.busiest.group_imbalance)
+		sdl.busiest.avg_load_per_task =
+			min(sdl.busiest.avg_load_per_task, sdl.avg_load);
 
 	/*
 	 * We're trying to get all the cpus to the average_load, so we don't
@@ -3612,26 +3458,38 @@ group_next:
 	 * by pulling tasks to us. Be careful of negative numbers as they'll
 	 * appear as very large values with unsigned longs.
 	 */
-	if (max_load <= busiest_load_per_task)
+	if (sdl.max_load <= sdl.busiest.avg_load_per_task)
 		goto out_balanced;
 
 	/*
 	 * In the presence of smp nice balancing, certain scenarios can have
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
+	 * In this condition attempt to adjust the imbalance parameter
+	 * in the small_imbalance functions.
+	 *
+	 * Now if max_load is more than avg load, balancing is needed,
+	 * find the exact number of tasks to be moved.
 	 */
-	if (max_load < avg_load) {
-		*imbalance = 0;
-		goto small_imbalance;
-	}
+	if (sdl.max_load >= sdl.avg_load) {
+
+		/* Don't want to pull so many tasks that
+		 * a group would go idle
+		 */
+		max_pull = min(sdl.max_load - sdl.avg_load,
+				sdl.max_load - sdl.busiest.avg_load_per_task);
+
+		/* How much load to actually move to equalise the imbalance */
+		*imbalance = min(max_pull * sdl.busiest.group->__cpu_power,
+				(sdl.avg_load - sdl.local.load) *
+				 sdl.local.group->__cpu_power) /
+				 SCHED_LOAD_SCALE;
 
-	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(max_load - avg_load, max_load - busiest_load_per_task);
+		/* If we have adjusted the required imbalance, then return */
+		if (*imbalance >= sdl.busiest.avg_load_per_task)
+			return sdl.busiest.group;
 
-	/* How much load to actually move to equalise the imbalance */
-	*imbalance = min(max_pull * busiest->__cpu_power,
-				(avg_load - this_load) * this->__cpu_power)
-			/ SCHED_LOAD_SCALE;
+	}
 
 	/*
 	 * if *imbalance is less than the average load per runnable task
@@ -3639,77 +3497,23 @@ group_next:
 	 * a think about bumping its value to force at least one task to be
 	 * moved
 	 */
-	if (*imbalance < busiest_load_per_task) {
-		unsigned long tmp, pwr_now, pwr_move;
-		unsigned int imbn;
-
-small_imbalance:
-		pwr_move = pwr_now = 0;
-		imbn = 2;
-		if (this_nr_running) {
-			this_load_per_task /= this_nr_running;
-			if (busiest_load_per_task > this_load_per_task)
-				imbn = 1;
-		} else
-			this_load_per_task = cpu_avg_load_per_task(this_cpu);
-
-		if (max_load - this_load + 2*busiest_load_per_task >=
-					busiest_load_per_task * imbn) {
-			*imbalance = busiest_load_per_task;
-			return busiest;
-		}
+	*imbalance = 0;  /* Will be adjusted below */
 
-		/*
-		 * OK, we don't have enough imbalance to justify moving tasks,
-		 * however we may be able to increase total CPU power used by
-		 * moving them.
-		 */
+	if (small_imbalance_one_task(&sdl, imbalance))
+		return sdl.busiest.group;
 
-		pwr_now += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load);
-		pwr_now += this->__cpu_power *
-				min(this_load_per_task, this_load);
-		pwr_now /= SCHED_LOAD_SCALE;
-
-		/* Amount of load we'd subtract */
-		tmp = sg_div_cpu_power(busiest,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		if (max_load > tmp)
-			pwr_move += busiest->__cpu_power *
-				min(busiest_load_per_task, max_load - tmp);
-
-		/* Amount of load we'd add */
-		if (max_load * busiest->__cpu_power <
-				busiest_load_per_task * SCHED_LOAD_SCALE)
-			tmp = sg_div_cpu_power(this,
-					max_load * busiest->__cpu_power);
-		else
-			tmp = sg_div_cpu_power(this,
-				busiest_load_per_task * SCHED_LOAD_SCALE);
-		pwr_move += this->__cpu_power *
-				min(this_load_per_task, this_load + tmp);
-		pwr_move /= SCHED_LOAD_SCALE;
+	/* Further look for effective cpu power utilisation */
+	small_imbalance_optimize_cpu_power(&sdl, imbalance);
 
-		/* Move if we gain throughput */
-		if (pwr_move > pwr_now)
-			*imbalance = busiest_load_per_task;
-	}
-
-	return busiest;
+	/*
+	 * Un conditional return, we have tries all possible means to adjust
+	 * the imbalance for effective task move
+	 */
+	return sdl.busiest.group;
 
 out_balanced:
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
-		goto ret;
-
-	if (this == group_leader && group_leader != group_min) {
-		*imbalance = min_load_per_task;
-		return group_min;
-	}
-#endif
-ret:
-	*imbalance = 0;
-	return NULL;
+	/* Try opportuinity for power save balance */
+	return powersavings_balance_group(&sdl, &gl, idle, imbalance);
 }
 
 /*

