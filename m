Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZBPQvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZBPQvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZBPQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:51:15 -0500
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:58754 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZBPQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:51:14 -0500
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH 1/3] sched: code cleanup - sd_power_saving_flags(),
	sd_balance_for_mc/package_power()
To: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, ego@in.ibm.com
Cc: balbir@in.ibm.com, dipankar@in.ibm.com, efault@gmx.de, andi@firstfloor.org,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Mon, 16 Feb 2009 22:21:06 +0530
Message-ID: <20090216165105.12804.32344.stgit@sofia.in.ibm.com>
In-Reply-To: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
References: <20090216164719.12804.37013.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a code cleanup patch which combines the functions of
sd_balance_for_mc/package_power() and sd_power_saving_flags() into a single
function.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 include/linux/sched.h    |   46 ++++++++++++++++------------------------------
 include/linux/topology.h |    6 ++----
 2 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 02e16d2..06c5c6c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -777,34 +777,30 @@ enum powersavings_balance_level {
 
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
-
-	return 0;
-}
+enum sched_domain_level {
+	SD_LV_NONE = 0,
+	SD_LV_SIBLING,
+	SD_LV_MC,
+	SD_LV_CPU,
+	SD_LV_NODE,
+	SD_LV_ALLNODES,
+	SD_LV_MAX
+};
 
 /*
  * Optimise SD flags for power savings:
  * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
  * Keep default SD flags if sched_{smt,mc}_power_saving=0
  */
-
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
@@ -830,16 +826,6 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
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
index e632d29..8097dce 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -125,8 +125,7 @@ int arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| sd_balance_for_mc_power()\
-				| sd_power_saving_flags(),\
+				| sd_power_saving_flags(SD_LV_MC),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -151,8 +150,7 @@ int arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power()\
-				| sd_power_saving_flags(),\
+				| sd_power_saving_flags(SD_LV_CPU),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }

