Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZCYJQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZCYJQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758576AbZCYJOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:25 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:46173 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbZCYJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:24 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 09/11] sched: Optimize the !power_savings_balance during
	find_busiest_group.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:44:17 +0530
Message-ID: <20090325091417.13992.2657.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to perform power_savings balance if either the cpu is NOT_IDLE
or if the sched_domain doesn't contain the SD_POWERSAVINGS_BALANCE flag set.

Currently, we check for these conditions multiple number of times, even though
these variables don't change over the scope of find_busiest_group().

Check once, and store the value in the already exiting "power_savings_balance"
variable.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b1b1b8a..cb2c97b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3282,8 +3282,17 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	int load_idx;
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	sds->power_savings_balance = 1;
-	sds->min_nr_running = ULONG_MAX;
+	/*
+	 * Busy processors will not participate in power savings
+	 * balance.
+	 */
+	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+		sds->power_savings_balance = 0;
+	else {
+		sds->power_savings_balance = 1;
+		sds->min_nr_running = ULONG_MAX;
+		sds->leader_nr_running = 0;
+	}
 #endif
 	load_idx = get_sd_load_idx(sd, idle);
 
@@ -3318,12 +3327,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 		}
 
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-		/*
-		 * Busy processors will not participate in power savings
-		 * balance.
-		 */
-		if (idle == CPU_NOT_IDLE ||
-				!(sd->flags & SD_POWERSAVINGS_BALANCE))
+
+		if (!sds->power_savings_balance)
 			goto group_next;
 
 		/*
@@ -3547,7 +3552,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 
 out_balanced:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+	if (!sds.power_savings_balance)
 		goto ret;
 
 	if (sds.this != sds.group_leader || sds.group_leader == sds.group_min)

