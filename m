Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0BXAO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 19:14:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:23698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0BXAO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 19:14:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,528,1262592000"; 
   d="scan'208";a="775329113"
Subject: Re: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>
In-Reply-To: <1266864618.6122.472.camel@laptop>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
	 <1266057388.557.59599.camel@twins>
	 <1266545807.2909.46.camel@sbs-t61.sc.intel.com>
	 <1266588316.1529.370.camel@laptop>
	 <1266604594.2814.37.camel@sbs-t61.sc.intel.com>
	 <1266608875.1529.749.camel@laptop>
	 <1266609029.4729.1.camel@sbs-t61.sc.intel.com>
	 <1266609734.1529.772.camel@laptop>
	 <1266628424.4729.23.camel@sbs-t61.sc.intel.com>
	 <1266864618.6122.472.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 23 Feb 2010 16:13:52 -0800
Message-Id: <1266970432.11588.22.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 10:50 -0800, Peter Zijlstra wrote:
> On Fri, 2010-02-19 at 17:13 -0800, Suresh Siddha wrote:
> 
> > Ok Peter. There is another place that is scaling load_per_task with
> > cpu_power but later comparing with the difference of max and min of the
> > actual cpu load. :(
> > 
> >         avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
> >                 group->cpu_power;
> > 
> >         if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
> >                 sgs->group_imb = 1;
> > 
> > Fixing this seems to have fixed the problem you mentioned. Can you
> > please checkout the appended patch? If everything seems ok, then I will
> > send the patch (against -tip tree) on monday morning with the detailed
> > changelog.
> 
> Yes, this one does seem to generate the intended behaviour and does look
> good (after cleaning up some of the now redundant comments).
> 
> Thanks!

Ok. Here is the patch with complete changelog. I added "Cc stable" tag
so that it can be picked up for 2.6.32 and 2.6.33, as we would like to
see this regression addressed in those kernels. Peter/Ingo: Can you
please queue this patch for -tip for 2.6.34?

Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: sched: fix imbalance calculations to address SCHED_MC regression

On platforms like dual socket quad-core platform, the scheduler load balancer
is not detecting the load imbalances in certain scenarios. This is leading to
scenarios like where one socket is completely busy (with all the 4 cores running
with 4 tasks) and leaving another socket completely idle. This causes
performance issues as those 4 tasks share the memory controller, last-level
cache bandwidth etc. Also we won't be taking advantage of turbo-mode as much as
we like etc.

Some of the comparisons in the scheduler load balancing code are comparing
the "weighted cpu load that is scaled wrt sched_group's cpu_power" with the
"weighted average load per task that is not scaled wrt sched_group's cpu_power".
While this is probably broken for a long time (for multi socket numa nodes etc),
the problem is aggrevated with this recent change:

   commit f93e65c186ab3c05ce2068733ca10e34fd00125e
   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
   Date:   Tue Sep 1 10:34:32 2009 +0200

	sched: Restore __cpu_power to a straight sum of power

Also with this change, the sched group cpu power alone no longer reflects the
group capacity that is needed to implement MC, MT performance (default) and
power-savings (user-selectable) policies. We need to use the computed
group capacity (sgs.group_capacity, that is computed using the
SD_PREFER_SIBLING logic in update_sd_lb_stats()) to find out if the group with
the max load is above its capacity and how much load to move etc.

Fix it.

Reported-by: Ma Ling <ling.ma@intel.com>
Initial-Analysis-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [2.6.32.x, 2.6.33.x]
---

 kernel/sched_fair.c |   63 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 26 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ff7692c..7e0620e 100644
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
@@ -2474,6 +2472,9 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
 
+	if (sgs->sum_nr_running)
+		avg_load_per_task =
+				sgs->sum_weighted_load / sgs->sum_nr_running;
 	/*
 	 * Consider the group unbalanced when the imbalance is larger
 	 * than the average weight of two tasks.
@@ -2483,9 +2484,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 	 *      normalized nr_running number somewhere that negates
 	 *      the hierarchy?
 	 */
-	avg_load_per_task = (sum_avg_load_per_task * SCHED_LOAD_SCALE) /
-		group->cpu_power;
-
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
@@ -2553,6 +2551,7 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 			sds->max_load = sgs.avg_load;
 			sds->busiest = group;
 			sds->busiest_nr_running = sgs.sum_nr_running;
+			sds->busiest_group_capacity = sgs.group_capacity;
 			sds->busiest_load_per_task = sgs.sum_weighted_load;
 			sds->group_imb = sgs.group_imb;
 		}
@@ -2575,6 +2574,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 {
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
+	unsigned long scaled_busy_load_per_task;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
@@ -2585,8 +2585,12 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
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
@@ -2637,7 +2641,7 @@ static inline void fix_small_imbalance(struct sd_lb_stats *sds,
 static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
 		unsigned long *imbalance)
 {
-	unsigned long max_pull;
+	unsigned long max_pull, load_above_capacity = ~0UL;
 	/*
 	 * In the presence of smp nice balancing, certain scenarios can have
 	 * max load less than avg load(as we skip the groups at or below
@@ -2648,9 +2652,29 @@ static inline void calculate_imbalance(struct sd_lb_stats *sds, int this_cpu,
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
@@ -2742,19 +2766,6 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		sds.busiest_load_per_task =
 			min(sds.busiest_load_per_task, sds.avg_load);
 
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
 
 	/* Looks like there is an imbalance. Compute it */
 	calculate_imbalance(&sds, this_cpu, imbalance);


