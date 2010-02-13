Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0BMBdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:33:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:30850 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab0BMBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:33:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208";a="595624850"
Subject: change in sched cpu_power causing regressions with SCHED_MC
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>,
       "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 12 Feb 2010 17:31:19 -0800
Message-Id: <1266024679.2808.153.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peterz,

We have one more problem that Yanmin and Ling Ma reported. On a dual
socket quad-core platforms (for example platforms based on NHM-EP), we
are seeing scenarios where one socket is completely busy (with all the 4
cores running with 4 tasks) and another socket is completely idle.

This causes performance issues as those 4 tasks share the memory
controller, last-level cache bandwidth etc. Also we won't be taking
advantage of turbo-mode as much as we like. We will have all these
benefits if we move two of those tasks to the other socket. Now both the
sockets can potentially go to turbo etc and improve performance.

In short, your recent change (shown below) broke this behavior. In the
kernel summit you mentioned you made this change with out affecting the
behavior of SMT/MC. And my testing immediately after kernel-summit also
didn't show the problem (perhaps my test didn't hit this specific
change). But apparently we are having performance issues with this patch
(Ling Ma's bisect pointed to this patch). I will look more detailed into
this after the long weekend (to see if we can catch this scenario in
fix_small_imbalance() etc). But wanted to give you a quick heads up.
Thanks.

commit f93e65c186ab3c05ce2068733ca10e34fd00125e
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Tue Sep 1 10:34:32 2009 +0200

    sched: Restore __cpu_power to a straight sum of power
    
    cpu_power is supposed to be a representation of the process
    capacity of the cpu, not a value to randomly tweak in order to
    affect placement.
    
    Remove the placement hacks.
    
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
    Acked-by: Gautham R Shenoy <ego@in.ibm.com>
    Cc: Balbir Singh <balbir@in.ibm.com>
    LKML-Reference: <20090901083825.810860576@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/sched.c b/kernel/sched.c
index da1edc8..584a122 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8464,15 +8464,13 @@ static void free_sched_groups(const struct cpumask *cpu_map,
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
 
@@ -8483,22 +8481,20 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
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







