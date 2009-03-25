Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbZCYJus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbZCYJus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbZCYJrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:46493 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759530AbZCYJrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:51 -0400
Date: Wed, 25 Mar 2009 09:47:01 GMT
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com,
       balbir@in.ibm.com, bharata@linux.vnet.ibm.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu,
       svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, balbir@in.ibm.com,
       bharata@linux.vnet.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, nickpiggin@yahoo.com.au, svaidy@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20090325091417.13992.2657.stgit@sofia.in.ibm.com>
References: <20090325091417.13992.2657.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Optimize the !power_savings_balance during fbg()
Message-ID: <tip-a021dc03376707c55a3483e32c16b8986d4414cc@git.kernel.org>
Git-Commit-ID: a021dc03376707c55a3483e32c16b8986d4414cc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:47:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a021dc03376707c55a3483e32c16b8986d4414cc
Gitweb:     http://git.kernel.org/tip/a021dc03376707c55a3483e32c16b8986d4414cc
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:44:17 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:48 +0100

sched: Optimize the !power_savings_balance during fbg()

Impact: cleanup, micro-optimization

We don't need to perform power_savings balance if either the
cpu is NOT_IDLE or if the sched_domain doesn't contain the
SD_POWERSAVINGS_BALANCE flag set.

Currently, we check for these conditions multiple number of
times, even though these variables don't change over the scope
of find_busiest_group().

Check once, and store the value in the already exiting
"power_savings_balance" variable.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
LKML-Reference: <20090325091417.13992.2657.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 934f615..71e8dca 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3386,8 +3386,17 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
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
 
@@ -3422,12 +3431,8 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
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
@@ -3651,7 +3656,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 
 out_balanced:
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
+	if (!sds.power_savings_balance)
 		goto ret;
 
 	if (sds.this != sds.group_leader || sds.group_leader == sds.group_min)
