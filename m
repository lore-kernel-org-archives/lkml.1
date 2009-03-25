Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbZCYJt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbZCYJt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbZCYJrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:47:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:46469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419AbZCYJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:47:39 -0400
Date: Wed, 25 Mar 2009 09:46:09 GMT
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
In-Reply-To: <20090325091340.13992.45062.stgit@sofia.in.ibm.com>
References: <20090325091340.13992.45062.stgit@sofia.in.ibm.com>
Subject: [tip:sched/balancing] sched: Fix indentations in find_busiest_group() using gotos
Message-ID: <tip-6dfdb0629019f307ab18864b1fd3e5dbb02f383c@git.kernel.org>
Git-Commit-ID: 6dfdb0629019f307ab18864b1fd3e5dbb02f383c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 09:46:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6dfdb0629019f307ab18864b1fd3e5dbb02f383c
Gitweb:     http://git.kernel.org/tip/6dfdb0629019f307ab18864b1fd3e5dbb02f383c
Author:     Gautham R Shenoy <ego@in.ibm.com>
AuthorDate: Wed, 25 Mar 2009 14:43:40 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 25 Mar 2009 10:30:44 +0100

sched: Fix indentations in find_busiest_group() using gotos

Impact: cleanup

Some indentations in find_busiest_group() can minimized by using
early exits with the help of gotos. This improves readability in
a couple of cases.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Balbir Singh" <balbir@in.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
LKML-Reference: <20090325091340.13992.45062.stgit@sofia.in.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6aec1e7..f87adbe 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3403,14 +3403,14 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		 * capacity but still has some space to pick up some load
 		 * from other group and save more power
 		 */
-		if (sum_nr_running <= group_capacity - 1) {
-			if (sum_nr_running > leader_nr_running ||
-			    (sum_nr_running == leader_nr_running &&
-			     group_first_cpu(group) <
-			     group_first_cpu(group_leader))) {
-				group_leader = group;
-				leader_nr_running = sum_nr_running;
-			}
+		if (sum_nr_running > group_capacity - 1)
+			goto group_next;
+
+		if (sum_nr_running > leader_nr_running ||
+		    (sum_nr_running == leader_nr_running &&
+		     group_first_cpu(group) < group_first_cpu(group_leader))) {
+			group_leader = group;
+			leader_nr_running = sum_nr_running;
 		}
 group_next:
 #endif
@@ -3531,14 +3531,16 @@ out_balanced:
 	if (idle == CPU_NOT_IDLE || !(sd->flags & SD_POWERSAVINGS_BALANCE))
 		goto ret;
 
-	if (this == group_leader && group_leader != group_min) {
-		*imbalance = min_load_per_task;
-		if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-			cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-				group_first_cpu(group_leader);
-		}
-		return group_min;
+	if (this != group_leader || group_leader == group_min)
+		goto ret;
+
+	*imbalance = min_load_per_task;
+	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
+		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
+			group_first_cpu(group_leader);
 	}
+	return group_min;
+
 #endif
 ret:
 	*imbalance = 0;
