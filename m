Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZIAIvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZIAIvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZIAIvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:51:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:41180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbZIAIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:51:38 -0400
Message-Id: <20090901083825.897028974@chello.nl>
References: <20090901083431.748830771@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 01 Sep 2009 10:34:33 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/8] sched: SD_PREFER_SIBLING
Content-Disposition: inline; filename=sched-lb-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the placement thing using SD flags

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |   29 +++++++++++++++--------------
 kernel/sched.c        |   14 +++++++++++++-
 2 files changed, 28 insertions(+), 15 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -808,18 +808,19 @@ enum cpu_idle_type {
 #define SCHED_LOAD_SCALE_FUZZ	SCHED_LOAD_SCALE
 
 #ifdef CONFIG_SMP
-#define SD_LOAD_BALANCE		1	/* Do load balancing on this domain. */
-#define SD_BALANCE_NEWIDLE	2	/* Balance when about to become idle */
-#define SD_BALANCE_EXEC		4	/* Balance on exec */
-#define SD_BALANCE_FORK		8	/* Balance on fork, clone */
-#define SD_WAKE_IDLE		16	/* Wake to idle CPU on task wakeup */
-#define SD_WAKE_AFFINE		32	/* Wake task to waking CPU */
-#define SD_WAKE_BALANCE		64	/* Perform balancing at task wakeup */
-#define SD_SHARE_CPUPOWER	128	/* Domain members share cpu power */
-#define SD_POWERSAVINGS_BALANCE	256	/* Balance for power savings */
-#define SD_SHARE_PKG_RESOURCES	512	/* Domain members share cpu pkg resources */
-#define SD_SERIALIZE		1024	/* Only a single load balancing instance */
-#define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
+#define SD_LOAD_BALANCE		0x0001	/* Do load balancing on this domain. */
+#define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
+#define SD_BALANCE_EXEC		0x0004	/* Balance on exec */
+#define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
+#define SD_WAKE_IDLE		0x0010	/* Wake to idle CPU on task wakeup */
+#define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
+#define SD_WAKE_BALANCE		0x0040	/* Perform balancing at task wakeup */
+#define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
+#define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
+#define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
+#define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
+#define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
+#define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
@@ -839,7 +840,7 @@ static inline int sd_balance_for_mc_powe
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 static inline int sd_balance_for_package_power(void)
@@ -847,7 +848,7 @@ static inline int sd_balance_for_package
 	if (sched_mc_power_savings | sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3803,9 +3803,13 @@ static inline void update_sd_lb_stats(st
 			const struct cpumask *cpus, int *balance,
 			struct sd_lb_stats *sds)
 {
+	struct sched_domain *child = sd->child;
 	struct sched_group *group = sd->groups;
 	struct sg_lb_stats sgs;
-	int load_idx;
+	int load_idx, prefer_sibling = 0;
+
+	if (child && child->flags & SD_PREFER_SIBLING)
+		prefer_sibling = 1;
 
 	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
@@ -3825,6 +3829,14 @@ static inline void update_sd_lb_stats(st
 		sds->total_load += sgs.group_load;
 		sds->total_pwr += group->__cpu_power;
 
+		/*
+		 * In case the child domain prefers tasks go to siblings
+		 * first, lower the group capacity to one so that we'll try
+		 * and move all the excess tasks away.
+		 */
+		if (prefer_sibling)
+			sgs.group_capacity = 1;
+
 		if (local_group) {
 			sds->this_load = sgs.avg_load;
 			sds->this = group;

-- 

