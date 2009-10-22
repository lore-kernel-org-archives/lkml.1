Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZJVMoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZJVMoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZJVMoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:44:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58201 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZJVMlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:10 -0400
Message-Id: <20091022124111.196085315@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:50 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 07/17] sched: try to deal with low capacity
Content-Disposition: inline; filename=sched-lb-6.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the capacity drops low, we want to migrate load away. Allow the
load-balancer to remove all tasks when we hit rock bottom.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[ego@in.ibm.com: fix to update_sd_power_savings_stats]
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 kernel/sched.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 09:15:36.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:37.000000000 -0400
@@ -3749,7 +3749,7 @@
 	 * capacity but still has some space to pick up some load
 	 * from other group and save more power
 	 */
-	if (sgs->sum_nr_running > sgs->group_capacity - 1)
+	if (sgs->sum_nr_running + 1 > sgs->group_capacity)
 		return;
 
 	if (sgs->sum_nr_running > sds->leader_nr_running ||
@@ -3989,8 +3989,8 @@
 	if ((max_cpu_load - min_cpu_load) > 2*avg_load_per_task)
 		sgs->group_imb = 1;
 
-	sgs->group_capacity = group->__cpu_power / SCHED_LOAD_SCALE;
-
+	sgs->group_capacity =
+		DIV_ROUND_CLOSEST(group->__cpu_power, SCHED_LOAD_SCALE);
 }
 
 /**
@@ -4040,7 +4040,7 @@
 		 * and move all the excess tasks away.
 		 */
 		if (prefer_sibling)
-			sgs.group_capacity = 1;
+			sgs.group_capacity = min(sgs.group_capacity, 1UL);
 
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
@@ -4272,6 +4272,26 @@
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
@@ -4284,15 +4304,18 @@
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
