Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbZH0PJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbZH0PJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZH0PJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:09:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZH0PJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:09:25 -0400
Message-Id: <20090827150524.238884869@chello.nl>
References: <20090827150051.846026837@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 27 Aug 2009 17:00:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/6] sched: try to deal with low capacity
Content-Disposition: inline; filename=sched-lb-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the capacity drops low, we want to migrate load away. Allow the
load-balancer to remove all tasks when we hit rock bottom.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3951,7 +3951,7 @@ static inline void update_sd_lb_stats(st
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
-			sgs.group_capacity = 1;
+			sgs.group_capacity = min(sgs.group_capacity, 1);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -4183,6 +4183,26 @@ ret:
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
@@ -4195,15 +4215,18 @@ find_busiest_queue(struct sched_group *g
 	int i;
 
 	for_each_cpu(i, sched_group_cpus(group)) {
+		unsigned long power = power_of(i);
+		unsigned long capacity = power >> SCHED_LOAD_SHIFT;
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

