Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZJVMlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZJVMlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 08:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755467AbZJVMlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 08:41:12 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51694 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbZJVMlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 08:41:09 -0400
Message-Id: <20091022124110.018490129@spinlock.in.ibm.com>
References: <20091022123743.506956796@spinlock.in.ibm.com>
User-Agent: quilt/0.44-1
Date: Thu, 22 Oct 2009 18:07:45 +0530
From: dino@in.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       John Kacur <jkacur@redhat.com>
Subject: [patch -rt 02/17] sched: SD_PREFER_SIBLING
Content-Disposition: inline; filename=sched-lb-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do the placement thing using SD flags

XXX: consider degenerate bits

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
---
 include/linux/sched.h |   29 +++++++++++++++--------------
 kernel/sched.c        |   14 +++++++++++++-
 2 files changed, 28 insertions(+), 15 deletions(-)

Index: linux-2.6.31.4-rt14/include/linux/sched.h
===================================================================
--- linux-2.6.31.4-rt14.orig/include/linux/sched.h	2009-10-16 09:15:18.000000000 -0400
+++ linux-2.6.31.4-rt14/include/linux/sched.h	2009-10-16 09:15:30.000000000 -0400
@@ -843,18 +843,19 @@
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
@@ -874,7 +875,7 @@
 	if (sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 static inline int sd_balance_for_package_power(void)
@@ -882,7 +883,7 @@
 	if (sched_mc_power_savings | sched_smt_power_savings)
 		return SD_POWERSAVINGS_BALANCE;
 
-	return 0;
+	return SD_PREFER_SIBLING;
 }
 
 /*
Index: linux-2.6.31.4-rt14/kernel/sched.c
===================================================================
--- linux-2.6.31.4-rt14.orig/kernel/sched.c	2009-10-16 09:15:18.000000000 -0400
+++ linux-2.6.31.4-rt14/kernel/sched.c	2009-10-16 09:15:30.000000000 -0400
@@ -3892,9 +3892,13 @@
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
@@ -3914,6 +3918,14 @@
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
