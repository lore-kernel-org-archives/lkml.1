Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbZCaKuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbZCaKuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbZCaKua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:50:30 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:58987 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZCaKu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:50:28 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH v4 1/5] sched: code cleanup - sd_power_saving_flags(),
	sd_balance_for_*_power()
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>
Date: Tue, 31 Mar 2009 16:20:17 +0530
Message-ID: <20090331105017.16414.10279.stgit@sofia.in.ibm.com>
In-Reply-To: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
References: <20090331104829.16414.11385.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combines the functions of sd_balance_for_mc/package_power() and
sd_power_saving_flags() into a single function.

Also add comments for various sched_domain levels.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/sched.h    |   65 +++++++++++++++++++++++-----------------------
 include/linux/topology.h |    6 +---
 2 files changed, 35 insertions(+), 36 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1df4745..8aaf276 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -803,34 +803,45 @@ enum powersavings_balance_level {
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
 
-static inline int sd_balance_for_mc_power(void)
-{
-	if (sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
-
-	return 0;
-}
-
-static inline int sd_balance_for_package_power(void)
-{
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_POWERSAVINGS_BALANCE;
+enum sched_domain_level {
+	SD_LV_NONE = 0,
+	SD_LV_SIBLING,	/* Represents the THREADS domain */
+	SD_LV_MC,	/* Represents the CORES domain */
+	SD_LV_CPU,	/* Represents the PACKAGE domain */
+	SD_LV_NODE,	/* Represents the NODES domain */
+	SD_LV_ALLNODES,
+	SD_LV_MAX
+};
 
-	return 0;
-}
 
-/*
- * Optimise SD flags for power savings:
- * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
- * Keep default SD flags if sched_{smt,mc}_power_saving=0
+/**
+ * sd_power_savings_flags: Returns the flags specific to power-aware-load
+ * balancing for a given sched_domain level
+ *
+ * @level: The sched_domain level for which the the power-aware-load balancing
+ * flags need to be set.
+ *
+ * This function helps in setting the flags for power-aware load balancing for
+ * a given sched_domain.
+ *	- SD_POWERSAVINGS_BALANCE tells the load-balancer that power-aware
+ *	load balancing is applicable at this domain.
+ *
+ *	- SD_BALANCE_NEWIDLE helps aggressive task consolidation and
+ *	power-savings.
+ *
+ * For more information on power aware scheduling, see the comment before
+ * find_busiest_group() in kernel/sched.c
  */
 
-static inline int sd_power_saving_flags(void)
+static inline int sd_power_saving_flags(enum sched_domain_level level)
 {
-	if (sched_mc_power_savings | sched_smt_power_savings)
-		return SD_BALANCE_NEWIDLE;
+	if (level == SD_LV_MC && !sched_smt_power_savings)
+		return 0;
+	if (level == SD_LV_CPU &&
+		!(sched_mc_power_savings || sched_smt_power_savings))
+		return 0;
 
-	return 0;
+	return SD_POWERSAVINGS_BALANCE | SD_BALANCE_NEWIDLE;
 }
 
 struct sched_group {
@@ -856,16 +867,6 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
-enum sched_domain_level {
-	SD_LV_NONE = 0,
-	SD_LV_SIBLING,
-	SD_LV_MC,
-	SD_LV_CPU,
-	SD_LV_NODE,
-	SD_LV_ALLNODES,
-	SD_LV_MAX
-};
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7402c1a..2338388 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -121,8 +121,7 @@ int arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| sd_balance_for_mc_power()\
-				| sd_power_saving_flags(),\
+				| sd_power_saving_flags(SD_LV_MC),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -147,8 +146,7 @@ int arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power()\
-				| sd_power_saving_flags(),\
+				| sd_power_saving_flags(SD_LV_CPU),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }

