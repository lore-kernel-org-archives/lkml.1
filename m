Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753022AbYLRRxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYLRRxU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYLRRwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:52:51 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:50208 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYLRRwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:52:50 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v7 1/8] sched: convert BALANCE_FOR_xx_POWER to inline functions
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
        Tim Connors <tconnors@astro.swin.edu.au>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Gregory Haskins <gregory.haskins@gmail.com>,
        Pavel Machek <pavel@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 18 Dec 2008 23:26:02 +0530
Message-ID: <20081218175602.29812.66863.stgit@drishya.in.ibm.com>
In-Reply-To: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BALANCE_FOR_MC_POWER and similar macros defined in sched.h are
not constants and have various condition checks and significant
amount of code that is not suitable to be contain in a macro.
Also there could be side effects on the expressions passed to
some of them like test_sd_parent().

This patch converts all complex macros related to power savings
balance to inline functions.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/sched.h    |   33 ++++++++++++++++++++++++---------
 include/linux/topology.h |    4 ++--
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 55e30d1..311122f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -764,15 +764,23 @@ enum cpu_idle_type {
 #define SD_SERIALIZE		1024	/* Only a single load balancing instance */
 #define SD_WAKE_IDLE_FAR	2048	/* Gain latency sacrificing cache hit */
 
-#define BALANCE_FOR_MC_POWER	\
-	(sched_smt_power_savings ? SD_POWERSAVINGS_BALANCE : 0)
+extern int sched_mc_power_savings, sched_smt_power_savings;
+
+static inline int sd_balance_for_mc_power(void)
+{
+	if (sched_smt_power_savings)
+		return SD_POWERSAVINGS_BALANCE;
 
-#define BALANCE_FOR_PKG_POWER	\
-	((sched_mc_power_savings || sched_smt_power_savings) ?	\
-	 SD_POWERSAVINGS_BALANCE : 0)
+	return 0;
+}
 
-#define test_sd_parent(sd, flag)	((sd->parent &&		\
-					 (sd->parent->flags & flag)) ? 1 : 0)
+static inline int sd_balance_for_package_power(void)
+{
+	if (sched_mc_power_savings | sched_smt_power_savings)
+		return SD_POWERSAVINGS_BALANCE;
+
+	return 0;
+}
 
 
 struct sched_group {
@@ -1358,6 +1366,15 @@ struct task_struct {
 	struct list_head	*scm_work_list;
 };
 
+/* Test a flag in parent sched domain */
+static inline int test_sd_parent(struct sched_domain *sd, int flag)
+{
+	if (sd->parent && (sd->parent->flags & flag))
+		return 1;
+
+	return 0;
+}
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
@@ -2215,8 +2232,6 @@ __trace_special(void *__tr, void *__data,
 extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
 extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
 
-extern int sched_mc_power_savings, sched_smt_power_savings;
-
 extern void normalize_rt_tasks(void);
 
 #ifdef CONFIG_GROUP_SCHED
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 117f1b7..7f10439 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -125,7 +125,7 @@ void arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| BALANCE_FOR_MC_POWER,	\
+				| sd_balance_for_mc_power(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -150,7 +150,7 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| BALANCE_FOR_PKG_POWER,\
+				| sd_balance_for_package_power(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }

