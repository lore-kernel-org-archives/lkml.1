Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYF0MCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYF0MCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYF0L6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 07:58:07 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:47175 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbYF0L55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 07:57:57 -0400
Message-Id: <20080627115211.899673668@chello.nl>
References: <20080627114109.724249622@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jun 2008 13:41:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 19/30] sched: hierarchical load vs find_busiest_group
Content-Disposition: inline; filename=sched-find_busiest_group.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_busiest_group() has some assumptions about task weight being in the
NICE_0_LOAD range. Hierarchical task groups break this assumption - fix this
by replacing it with the average task weight, which will adapt the situation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3111,6 +3111,7 @@ find_busiest_group(struct sched_domain *
 	max_load = this_load = total_load = total_pwr = 0;
 	busiest_load_per_task = busiest_nr_running = 0;
 	this_load_per_task = this_nr_running = 0;
+
 	if (idle == CPU_NOT_IDLE)
 		load_idx = sd->busy_idx;
 	else if (idle == CPU_NEWLY_IDLE)
@@ -3125,6 +3126,8 @@ find_busiest_group(struct sched_domain *
 		int __group_imb = 0;
 		unsigned int balance_cpu = -1, first_idle_cpu = 0;
 		unsigned long sum_nr_running, sum_weighted_load;
+		unsigned long sum_avg_load_per_task;
+		unsigned long avg_load_per_task;
 
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
@@ -3133,6 +3136,8 @@ find_busiest_group(struct sched_domain *
 
 		/* Tally up the load of all CPUs in the group */
 		sum_weighted_load = sum_nr_running = avg_load = 0;
+		sum_avg_load_per_task = avg_load_per_task = 0;
+
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
@@ -3166,6 +3171,8 @@ find_busiest_group(struct sched_domain *
 			avg_load += load;
 			sum_nr_running += rq->nr_running;
 			sum_weighted_load += weighted_cpuload(i);
+
+			sum_avg_load_per_task += cpu_avg_load_per_task(i);
 		}
 
 		/*
@@ -3187,7 +3194,20 @@ find_busiest_group(struct sched_domain *
 		avg_load = sg_div_cpu_power(group,
 				avg_load * SCHED_LOAD_SCALE);
 
-		if ((max_cpu_load - min_cpu_load) > SCHED_LOAD_SCALE)
+
+		/*
+		 * Consider the group unbalanced when the imbalance is larger
+		 * than the average weight of two tasks.
+		 *
+		 * APZ: with cgroup the avg task weight can vary wildly and
+		 *      might not be a suitable number - should we keep a
+		 *      normalized nr_running number somewhere that negates
+		 *      the hierarchy?
+		 */
+		avg_load_per_task = sg_div_cpu_power(group,
+				sum_avg_load_per_task * SCHED_LOAD_SCALE);
+
+		if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 			__group_imb = 1;
 
 		group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
@@ -3328,9 +3348,9 @@ small_imbalance:
 			if (busiest_load_per_task > this_load_per_task)
 				imbn = 1;
 		} else
-			this_load_per_task = SCHED_LOAD_SCALE;
+			this_load_per_task = cpu_avg_load_per_task(this_cpu);
 
-		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
+		if (max_load - this_load + 2*busiest_load_per_task >=
 					busiest_load_per_task * imbn) {
 			*imbalance = busiest_load_per_task;
 			return busiest;

-- 

