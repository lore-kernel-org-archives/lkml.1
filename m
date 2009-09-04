Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZIDIzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZIDIzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbZIDIze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:55:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:36580 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZIDIzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:55:33 -0400
Date: Fri, 4 Sep 2009 08:54:58 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, ego@in.ibm.com, hpa@zytor.com,
       mingo@redhat.com, andreas.herrmann3@amd.com, a.p.zijlstra@chello.nl,
       balbir@in.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: balbir@in.ibm.com, mingo@redhat.com, hpa@zytor.com, ego@in.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090901083825.810860576@chello.nl>
References: <20090901083825.810860576@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/balancing] sched: Restore __cpu_power to a straight sum of power
Message-ID: <tip-f93e65c186ab3c05ce2068733ca10e34fd00125e@git.kernel.org>
Git-Commit-ID: f93e65c186ab3c05ce2068733ca10e34fd00125e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 08:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f93e65c186ab3c05ce2068733ca10e34fd00125e
Gitweb:     http://git.kernel.org/tip/f93e65c186ab3c05ce2068733ca10e34fd00125e
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 1 Sep 2009 10:34:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 10:09:53 +0200

sched: Restore __cpu_power to a straight sum of power

cpu_power is supposed to be a representation of the process
capacity of the cpu, not a value to randomly tweak in order to
affect placement.

Remove the placement hacks.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
LKML-Reference: <20090901083825.810860576@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index da1edc8..584a122 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8464,15 +8464,13 @@ static void free_sched_groups(const struct cpumask *cpu_map,
  * there are asymmetries in the topology. If there are asymmetries, group
  * having more cpu_power will pickup more load compared to the group having
  * less cpu_power.
- *
- * cpu_power will be a multiple of SCHED_LOAD_SCALE. This multiple represents
- * the maximum number of tasks a group can handle in the presence of other idle
- * or lightly loaded groups in the same sched domain.
  */
 static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_domain *child;
 	struct sched_group *group;
+	long power;
+	int weight;
 
 	WARN_ON(!sd || !sd->groups);
 
@@ -8483,22 +8481,20 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	sd->groups->__cpu_power = 0;
 
-	/*
-	 * For perf policy, if the groups in child domain share resources
-	 * (for example cores sharing some portions of the cache hierarchy
-	 * or SMT), then set this domain groups cpu_power such that each group
-	 * can handle only one task, when there are other idle groups in the
-	 * same sched domain.
-	 */
-	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
-		       (child->flags &
-			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
-		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+	if (!child) {
+		power = SCHED_LOAD_SCALE;
+		weight = cpumask_weight(sched_domain_span(sd));
+		/*
+		 * SMT siblings share the power of a single core.
+		 */
+		if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1)
+			power /= weight;
+		sg_inc_cpu_power(sd->groups, power);
 		return;
 	}
 
 	/*
-	 * add cpu_power of each child group to this groups cpu_power
+	 * Add cpu_power of each child group to this groups cpu_power.
 	 */
 	group = child->groups;
 	do {
