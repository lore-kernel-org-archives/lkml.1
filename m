Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab0BZKZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 05:25:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:34365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab0BZKZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 05:25:27 -0500
Date: Fri, 26 Feb 2010 10:24:34 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com, ling.ma@intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ling.ma@intel.com, a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
References: <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix SCHED_MC regression caused by change in sched cpu_power
Message-ID: <tip-d8462eb81b72ebee011a8adbb9a9a5cd94213af9@git.kernel.org>
Git-Commit-ID: d8462eb81b72ebee011a8adbb9a9a5cd94213af9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 10:24:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8462eb81b72ebee011a8adbb9a9a5cd94213af9
Gitweb:     http://git.kernel.org/tip/d8462eb81b72ebee011a8adbb9a9a5cd94213af9
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 23 Feb 2010 16:13:52 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Feb 2010 10:54:27 +0100

sched: Fix SCHED_MC regression caused by change in sched cpu_power

On platforms like dual socket quad-core platform, the scheduler load
balancer is not detecting the load imbalances in certain scenarios. This
is leading to scenarios like where one socket is completely busy (with
all the 4 cores running with 4 tasks) and leaving another socket
completely idle. This causes performance issues as those 4 tasks share
the memory controller, last-level cache bandwidth etc. Also we won't be
taking advantage of turbo-mode as much as we would like, etc.

Some of the comparisons in the scheduler load balancing code are
comparing the "weighted cpu load that is scaled wrt sched_group's
cpu_power" with the "weighted average load per task that is not scaled
wrt sched_group's cpu_power". While this has probably been broken for a
longer time (for multi socket numa nodes etc), the problem got aggrevated
via this recent change:

 |
 |  commit f93e65c186ab3c05ce2068733ca10e34fd00125e
 |  Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 |  Date:   Tue Sep 1 10:34:32 2009 +0200
 |
 |	sched: Restore __cpu_power to a straight sum of power
 |

Also with this change, the sched group cpu power alone no longer reflects
the group capacity that is needed to implement MC, MT performance
(default) and power-savings (user-selectable) policies.

We need to use the computed group capacity (sgs.group_capacity, that is
computed using the SD_PREFER_SIBLING logic in update_sd_lb_stats()) to
find out if the group with the max load is above its capacity and how
much load to move etc.

Reported-by: Ma Ling <ling.ma@intel.com>
Initial-Analysis-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org> # [2.6.32.x, 2.6.33.x]
LKML-Reference: <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |   76 +++++++++++++++++++++++++++++----------------------
 1 files changed, 43 insertions(+), 33 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ff7692c..a3591a7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2097,6 +2097,7 @@ struct sd_lb_stats {
 	unsigned long max_load;
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
+	unsigned long busiest_group_capacity;
 
 	int group_imb; /* Is there imbalance in this sd */
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
@@ -2416,14 +2417,12 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	unsigned long load, max_cpu_load, min_cpu_load;
 	int i;
 	unsigned int balance_cpu = -1, first_idle_cpu = 0;
-	unsigned long sum_avg_load_per_task;
-	unsigned long avg_load_per_task;
+	unsigned long avg_load_per_task = 0;
 
 	if (local_group)
 		balance_cpu = group_first_cpu(group);
 
 	/* Tally up the load of all CPUs in the group */
-	sum_avg_load_per_task = avg_load_per_task = 0;
 	max_cpu_load = 0;
 	min_cpu_load = ~0UL;
 
@@ -2453,7 +2452,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		sgs->sum_nr_running += rq->nr_running;
 		sgs->sum_weighted_load += weighted_cpuload(i);
 
-		sum_avg_load_per_task += cpu_avg_load_per_task(i);
 	}
 
 	/*
@@ -2473,7 +2471,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
-
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
 	 * than the average weight of two tasks.
@@ -2483,8 +2480,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
-		group->cpu_power;
+	if (sgs->sum_nr_running)
+		avg_load_per_task = sgs->sum_weighted_load / sgs->sum_nr_running;
 
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
@@ -2553,6 +2550,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->group_imb = sgs.group_imb;
 		}
@@ -2575,6 +2573,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
+	unsigned long scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
@@ -2585,8 +2584,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 		sds->this_load_per_task =
 			cpu_avg_load_per_task(this_cpu);
 
-	if (sds->max_load - sds->this_load + sds->busiest_load_per_task >=
-			sds->busiest_load_per_task * imbn) {
+	scaled_busy_load_per_task = sds->busiest_load_per_task
+						 * SCHED_LOAD_SCALE;
+	scaled_busy_load_per_task /= sds->busiest->cpu_power;
+
+	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
+			(scaled_busy_load_per_task * imbn)) {
 		*imbalance = sds->busiest_load_per_task;
 		return;
 	}
@@ -2637,7 +2640,14 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		unsigned long *imbalance)
 {
-	unsigned long max_pull;
+	unsigned long max_pull, load_above_capacity = ~0UL;
+
+	sds.busiest_load_per_task /= sds.busiest_nr_running;
+	if (sds.group_imb) {
+		sds.busiest_load_per_task =
+			min(sds.busiest_load_per_task, sds.avg_load);
+	}
+
 	/*
 	 * In the presence of smp nice balancing, certain scenarios can have
 	 * max load less than avg load(as we skip the groups at or below
@@ -2648,9 +2658,29 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		return fix_small_imbalance(sds, this_cpu, imbalance);
 	}
 
-	/* Don't want to pull so many tasks that a group would go idle */
-	max_pull = min(sds->max_load - sds->avg_load,
-			sds->max_load - sds->busiest_load_per_task);
+	if (!sds->group_imb) {
+		/*
+		 * Don't want to pull so many tasks that a group would go idle.
+		 */
+		load_above_capacity = (sds->busiest_nr_running -
+						sds->busiest_group_capacity);
+
+		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_LOAD_SCALE);
+
+		load_above_capacity /= sds->busiest->cpu_power;
+	}
+
+	/*
+	 * We're trying to get all the cpus to the average_load, so we don't
+	 * want to push ourselves above the average load, nor do we wish to
+	 * reduce the max loaded cpu below the average load. At the same time,
+	 * we also don't want to reduce the group load below the group capacity
+	 * (so that we can implement power-savings policies etc). Thus we look
+	 * for the minimum possible imbalance.
+	 * Be careful of negative numbers as they'll appear as very large values
+	 * with unsigned longs.
+	 */
+	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
 
 	/* How much load to actually move to equalise the imbalance */
 	*imbalance = min(max_pull * sds->busiest->cpu_power,
@@ -2718,7 +2748,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	 * 4) This group is more busy than the avg busieness at this
 	 *    sched_domain.
 	 * 5) The imbalance is within the specified limit.
-	 * 6) Any rebalance would lead to ping-pong
 	 */
 	if (!(*balance))
 		goto ret;
@@ -2737,25 +2766,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 	if (100 * sds.max_load <= sd->imbalance_pct * sds.this_load)
 		goto out_balanced;
 
-	sds.busiest_load_per_task /= sds.busiest_nr_running;
-	if (sds.group_imb)
-		sds.busiest_load_per_task =
-			min(sds.busiest_load_per_task, sds.avg_load);
-
-	/*
-	 * We're trying to get all the cpus to the average_load, so we don't
-	 * want to push ourselves above the average load, nor do we wish to
-	 * reduce the max loaded cpu below the average load, as either of these
-	 * actions would just result in more rebalancing later, and ping-pong
-	 * tasks around. Thus we look for the minimum possible imbalance.
-	 * Negative imbalances (*we* are more loaded than anyone else) will
-	 * be counted as no imbalance for these purposes -- we can't fix that
-	 * by pulling tasks to us. Be careful of negative numbers as they'll
-	 * appear as very large values with unsigned longs.
-	 */
-	if (sds.max_load <= sds.busiest_load_per_task)
-		goto out_balanced;
-
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);
 	return sds.busiest;
