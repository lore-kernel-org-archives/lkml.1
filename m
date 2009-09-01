Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZIAIx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZIAIx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZIAIx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:53:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZIAIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:38 -0400
Message-Id: <20090901083826.162033479@chello.nl>
References: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:36 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 5/8] sched: dynamic cpu_power
Content-Disposition: inline; filename=sched-lb-4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recompute the cpu_power for each cpu during load-balance

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3691,14 +3691,46 @@ static inline int check_power_save_busie
 }
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
-static void update_sched_power(struct sched_domain *sd)
+unsigned long __weak arch_smt_gain(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long smt_gain = sd->smt_gain;
+
+	smt_gain /= weight;
+
+	return smt_gain;
+}
+
+static void update_cpu_power(struct sched_domain *sd, int cpu)
+{
+	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long power = SCHED_LOAD_SCALE;
+	struct sched_group *sdg = sd->groups;
+	unsigned long old = sdg->__cpu_power;
+
+	/* here we could scale based on cpufreq */
+
+	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
+		power *= arch_smt_gain(sd, cpu);
+		power >>= SCHED_LOAD_SHIFT;
+	}
+
+	/* here we could scale based on RT time */
+
+	if (power != old) {
+		sdg->__cpu_power = power;
+		sdg->reciprocal_cpu_power = reciprocal_value(power);
+	}
+}
+
+static void update_group_power(struct sched_domain *sd, int cpu)
 {
 	struct sched_domain *child = sd->child;
 	struct sched_group *group, *sdg = sd->groups;
 	unsigned long power = sdg->__cpu_power;
 
 	if (!child) {
-		/* compute cpu power for this cpu */
+		update_cpu_power(sd, cpu);
 		return;
 	}
 
@@ -3743,7 +3775,7 @@ static inline void update_sg_lb_stats(st
 	if (local_group) {
 		balance_cpu = group_first_cpu(group);
 		if (balance_cpu == this_cpu)
-			update_sched_power(sd);
+			update_group_power(sd, this_cpu);
 	}
 
 	/* Tally up the load of all CPUs in the group */

-- 

