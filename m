Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbZIAIvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbZIAIvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZIAIvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:41183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbZIAIvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:44 -0400
Message-Id: <20090901083825.810860576@chello.nl>
References: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:32 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/8] sched: restore __cpu_power to a straight sum of power
Content-Disposition: inline; filename=sched-lb-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_power is supposed to be a representation of the process capacity
of the cpu, not a value to randomly tweak in order to affect
placement.

Remove the placement hacks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h    |    1 +
 include/linux/topology.h |    1 +
 kernel/sched.c           |   34 ++++++++++++++++++----------------
 3 files changed, 20 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -8468,15 +8468,13 @@ static void free_sched_groups(const stru
  * there are asymmetries in the topology. If there are asymmetries, group
  * having more cpu_power will pickup more load compared to the group having
  * less cpu_power.
- *
- * cpu_power will be a multiple of SCHED_LOAD_SCALE. This multiple represents
- * the maximum number of tasks a group can handle in the presence of other idle
- * or lightly loaded groups in the same sched domain.
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_domain *child;
 	struct sched_group *group;
+	long power;
+	int weight;
 
 	WARN_ON(!sd || !sd->groups);
 
@@ -8487,22 +8485,20 @@ static void init_sched_groups_power(int 
 
 	sd->groups->__cpu_power = 0;
 
-	/*
-	 * For perf policy, if the groups in child domain share resources
-	 * (for example cores sharing some portions of the cache hierarchy
-	 * or SMT), then set this domain groups cpu_power such that each group
-	 * can handle only one task, when there are other idle groups in the
-	 * same sched domain.
-	 */
-	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
-		       (child->flags &
-			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
-		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+	if (!child) {
+		power = SCHED_LOAD_SCALE;
+		weight = cpumask_weight(sched_domain_span(sd));
+		/*
+		 * SMT siblings share the power of a single core.
+		 */
+		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
+			power /= weight;
+		sg_inc_cpu_power(sd->groups, power);
 		return;
 	}
 
 	/*
-	 * add cpu_power of each child group to this groups cpu_power
+	 * Add cpu_power of each child group to this groups cpu_power.
 	 */
 	group = child->groups;
 	do {

-- 

