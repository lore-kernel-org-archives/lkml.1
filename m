Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZCYJOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZCYJOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZCYJNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:13:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:43537 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbZCYJNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:13:52 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 02/11] sched: Fix indentations in find_busiest_group using
	gotos.
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Date: Wed, 25 Mar 2009 14:43:40 +0530
Message-ID: <20090325091340.13992.45062.stgit@sofia.in.ibm.com>
In-Reply-To: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
References: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some indentations in find_busiest_group() can minimized by using
early exits with the help of gotos. This improves readability in a couple of
cases.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---

 kernel/sched.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0b65f8c..d95dcc0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3299,14 +3299,14 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
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
@@ -3427,14 +3427,16 @@ out_balanced:
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

