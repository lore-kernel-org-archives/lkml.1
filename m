Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZIAIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZIAIvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZIAIvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:41179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbZIAIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:37 -0400
Message-Id: <20090901083826.342231003@chello.nl>
References: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 7/8] sched: try to deal with low capacity
Content-Disposition: inline; filename=sched-lb-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the capacity drops low, we want to migrate load away. Allow the
load-balancer to remove all tasks when we hit rock bottom.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3908,8 +3908,8 @@ static inline void update_sg_lb_stats(st
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->__cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**
@@ -3959,7 +3959,7 @@ static inline void update_sd_lb_stats(st
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
-			sgs.group_capacity = 1;
+			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -4191,6 +4191,26 @@ ret:
 	return NULL;
 }
 
+static struct sched_group *group_of(int cpu)
+{
+	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+
+	if (!sd)
+		return NULL;
+
+	return sd->groups;
+}
+
+static unsigned long power_of(int cpu)
+{
+	struct sched_group *group = group_of(cpu);
+
+	if (!group)
+		return SCHED_LOAD_SCALE;
+
+	return group->__cpu_power;
+}
+
 /*
  * find_busiest_queue - find the busiest runqueue among the cpus in group.
  */
@@ -4203,15 +4223,18 @@ find_busiest_queue(struct sched_group *g
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
+		unsigned long power = power_of(i);
+		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
 		unsigned long wl;
 
 		if (!cpumask_test_cpu(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
-		wl = weighted_cpuload(i);
+		wl = weighted_cpuload(i) * SCHED_LOAD_SCALE;
+		wl /= power;
 
-		if (rq->nr_running == 1 && wl > imbalance)
+		if (capacity && rq->nr_running == 1 && wl > imbalance)
 			continue;
 
 		if (wl > max_load) {

-- 

