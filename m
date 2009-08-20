Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZHTNmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZHTNmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZHTNmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:42:09 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:18784
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754436AbZHTNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:42:08 -0400
X-SpamScore: 6
X-BigFish: VPS6(z46fm34a4jz14c3Lzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KOOGPY-01-18V-02
X-M-MSG: 
Date: Thu, 20 Aug 2009 15:41:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] sched: Pass unlimited __cpu_power information to
	upper domain level groups
Message-ID: <20090820134155.GZ29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090820131243.GO29327@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2009 13:41:56.0112 (UTC) FILETIME=[FBC50100:01CA219B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For performance reasons __cpu_power in a sched_group might be limited
such that the group can handle only one task. To correctly calculate
the capacity in upper domain level groups the unlimited power
information is required. This patch stores unlimited __cpu_power
information in sched_groups.orig_power and uses this when calculating
__cpu_power in upper domain level groups.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 include/linux/sched.h |    8 +++++++-
 kernel/sched.c        |   36 ++++++++++++++++++++++++------------
 2 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c53bdd8..d230717 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -890,7 +890,13 @@ struct sched_group {
 	 * (see include/linux/reciprocal_div.h)
 	 */
 	u32 reciprocal_cpu_power;
-
+	/*
+	 * Backup of original power for this group.
+	 * It is used to pass correct power information to upper
+	 * domain level groups in case __cpu_power is limited for
+	 * performance reasons.
+	 */
+	unsigned int orig_power;
 	/*
 	 * The CPUs this group covers.
 	 *
diff --git a/kernel/sched.c b/kernel/sched.c
index 7a0d710..464b6ba 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8376,6 +8376,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 
 			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
 		}
+		sg->orig_power = sg->__cpu_power;
 		sg = sg->next;
 	} while (sg != group_head);
 }
@@ -8514,18 +8515,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	child = sd->child;
 
 	sd->groups->__cpu_power = 0;
-
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
+	if (!child) {
 		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+		sd->groups->orig_power = sd->groups->__cpu_power;
 		return;
 	}
 
@@ -8534,9 +8526,29 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	 */
 	group = child->groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sg_inc_cpu_power(sd->groups, group->orig_power);
 		group = group->next;
 	} while (group != child->groups);
+	sd->groups->orig_power = sd->groups->__cpu_power;
+
+	/*
+	 * For perf policy, if the groups in child domain share resources
+	 * (for example cores sharing some portions of the cache hierarchy
+	 * or SMT), then set this domain groups cpu_power such that each group
+	 * can handle only one task, when there are other idle groups in the
+	 * same sched domain.
+	 * Note: Unmodified power information is kept in orig_power and
+	 *       can be used in higher domain levels to calculate
+	 *       and reflect the correct capacity of a sched_group.
+	 *       This is required for power_savings scheduling.
+	 */
+	if (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
+	    ((child->flags &
+	      (SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
+		sd->groups->__cpu_power = 0;
+		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+	}
+
 }
 
 /*
-- 
1.6.0.4



