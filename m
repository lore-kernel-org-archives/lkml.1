Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZJVMlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZJVMlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZJVMlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57757 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812AbZJVMlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:08 -0400
Message-Id: <20091022124109.712036201@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:44 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 01/17] sched: restore __cpu_power to a straight sum of power
Content-Disposition: inline; filename=sched-lb-1.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_power is supposed to be a representation of the process capacity
of the cpu, not a value to randomly tweak in order to affect
placement.

Remove the placement hacks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 include/linux/sched.h    |    1 +
 include/linux/topology.h |    1 +
 kernel/sched.c           |   34 ++++++++++++++++++----------------
 3 files changed, 20 insertions(+), 16 deletions(-)

Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 08:56:17.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:18.000000000 -0400
@@ -8670,15 +8670,13 @@
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
 
@@ -8689,22 +8687,20 @@
 
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
