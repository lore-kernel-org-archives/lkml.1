Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752791AbYLRRzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYLRRzj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYLRRyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:54:54 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57640 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYLRRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:54:52 -0500
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [PATCH v7 7/8] sched: add SD_BALANCE_NEWIDLE at MC and CPU level for
	sched_mc>0
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
Date: Thu, 18 Dec 2008 23:26:47 +0530
Message-ID: <20081218175647.29812.34915.stgit@drishya.in.ibm.com>
In-Reply-To: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
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

 include/linux/sched.h    |   13 +++++++++++++
 include/linux/topology.h |    6 ++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5fe906b..07348ff 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -793,6 +793,19 @@ static inline int sd_balance_for_package_power(void)
 	return 0;
 }
 
+/*
+ * Optimise SD flags for power savings:
+ * SD_BALANCE_NEWIDLE helps agressive task consolidation and power savings.
+ * Keep default SD flags if sched_{smt,mc}_power_saving=0
+ */
+
+static inline int sd_power_saving_flags(void)
+{
+	if (sched_mc_power_savings | sched_smt_power_savings)
+		return SD_BALANCE_NEWIDLE;
+
+	return 0;
+}
 
 struct sched_group {
 	struct sched_group *next;	/* Must be a circular list */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7f10439..1628b43 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -125,7 +125,8 @@ void arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
 				| SD_SHARE_PKG_RESOURCES\
-				| sd_balance_for_mc_power(),\
+				| sd_balance_for_mc_power()\
+				| sd_power_saving_flags(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
@@ -150,7 +151,8 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_FORK	\
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_BALANCE	\
-				| sd_balance_for_package_power(),\
+				| sd_balance_for_package_power()\
+				| sd_power_saving_flags(),\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }

