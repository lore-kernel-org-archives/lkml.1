Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZDZUrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZDZUrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 16:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZDZUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 16:46:49 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:34936 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbZDZUqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 16:46:47 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 2/3] sched: threshold helper functions
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Mon, 27 Apr 2009 02:16:57 +0530
Message-ID: <20090426204657.17495.21835.stgit@drishya.in.ibm.com>
In-Reply-To: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
References: <20090426204029.17495.46609.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define group capacity threshold as a multiple of
impalance percentage at higher levels of sched_mc settings.

sched_mc=3 Group capacity increased by 25% (5 tasks on quad core)
sched_mc=4 Group capacity increased by 50% (6 tasks on quad core)
sched_mc=5 Group capacity increased by 100% (8 tasks on quad core)

*** RFC patch for discussion ***

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
---

 kernel/sched.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..f88ed04 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3291,6 +3291,21 @@ static inline int get_sd_load_idx(struct sched_domain *sd,
 
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+
+static inline unsigned int group_capacity_bump_pct(struct sched_domain *sd)
+{
+	if (sched_mc_power_savings >= POWERSAVINGS_INCREASE_GROUP_CAPACITY_3)
+		return 100+(sd->imbalance_pct-100)*4;
+
+	if (sched_mc_power_savings >= POWERSAVINGS_INCREASE_GROUP_CAPACITY_2)
+		return 100+(sd->imbalance_pct-100)*2;
+
+	if (sched_mc_power_savings >= POWERSAVINGS_INCREASE_GROUP_CAPACITY_1)
+		return sd->imbalance_pct;
+
+	return 100;
+}
+
 /**
  * init_sd_power_savings_stats - Initialize power savings statistics for
  * the given sched_domain, during load balancing.
@@ -3433,6 +3448,12 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 {
 	return 0;
 }
+
+static inline unsigned int group_capacity_bump_pct(struct sched_domain *sd)
+{
+	return 100;
+}
+
 #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
 
 

