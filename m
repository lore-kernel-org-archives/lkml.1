Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYLKRlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYLKRlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYLKRj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:39:57 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:57969 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640AbYLKRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:39:55 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v5 6/7] sched: add SD_BALANCE_NEWIDLE at MC and CPU level
	for sched_mc>0
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
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 11 Dec 2008 23:13:17 +0530
Message-ID: <20081211174317.2020.87473.stgit@drishya.in.ibm.com>
In-Reply-To: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
References: <20081211173831.2020.57550.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SD_BALANCE_NEWIDLE flag at MC level and CPU level
if sched_mc is set.  This helps power savings and
will not affect performance when sched_mc=0

Ingo and Mike Galbraith have optimised the SD flags by
removing SD_BALANCE_NEWIDLE at MC and CPU level.  This
helps performance but hurts power savings since this
slows down task consolidation by reducing the number
of times load_balance is run.

    sched: fine-tune SD_MC_INIT
        commit 14800984706bf6936bbec5187f736e928be5c218
        Author: Mike Galbraith <efault@gmx.de>
        Date:   Fri Nov 7 15:26:50 2008 +0100

    sched: re-tune balancing -- revert
        commit 9fcd18c9e63e325dbd2b4c726623f760788d5aa8
        Author: Ingo Molnar <mingo@elte.hu>
        Date:   Wed Nov 5 16:52:08 2008 +0100

This patch selectively enables SD_BALANCE_NEWIDLE flag
only when sched_mc is set to 1 or 2.  This helps power savings
by task consolidation and also does not hurt performance at
sched_mc=0 where all power saving optimisations are turned off.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 include/linux/sched.h    |   10 ++++++++++
 include/linux/topology.h |    6 ++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 888f2b2..e894892 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -782,6 +782,16 @@ enum powersavings_balance_level {
 	((sched_mc_power_savings || sched_smt_power_savings) ?	\
 	 SD_POWERSAVINGS_BALANCE : 0)
 
+/*
+ * Optimise SD flags for power savings:
+ * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
+ * Keep default SD flags if sched_{smt,mc}_power_saving=0
+ */
+
+#define POWERSAVING_SD_FLAGS	\
+	((sched_mc_power_savings || sched_smt_power_savings) ?	\
+	  SD_BALANCE_NEWIDLE : 0)
+
 #define test_sd_parent(sd, flag)	((sd->parent &&		\
 					 (sd->parent->flags & flag)) ? 1 : 0)
 
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 117f1b7..26c608c 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -125,7 +125,8 @@ void arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| BALANCE_FOR_MC_POWER,	\
+				| BALANCE_FOR_MC_POWER	\
+				| POWERSAVING_SD_FLAGS, \
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -150,7 +151,8 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| BALANCE_FOR_PKG_POWER,\
+				| BALANCE_FOR_PKG_POWER \
+				| POWERSAVING_SD_FLAGS, \
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }

