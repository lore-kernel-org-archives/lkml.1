Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXLDVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXLDVNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXLDVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:57 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53496
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755306AbXLDVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:56 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 18/23] Subject: SCHED - Optimize cpu search with hamming weight
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:56 -0500
Message-ID: <20071204204556.3567.19342.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can cheaply track the number of bits set in the cpumask for the lowest
priority CPUs.  Therefore, compute the mask's weight and use it to skip
the optimal domain search logic when there is only one CPU available.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index fe0b43f..0514b27 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -301,7 +301,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	int       cpu;
 	cpumask_t *valid_mask = &__get_cpu_var(valid_cpu_mask);
 	int       lowest_prio = -1;
-	int       ret         = 0;
+	int       count       = 0;
 
 	cpus_clear(*lowest_mask);
 	cpus_and(*valid_mask, cpu_online_map, task->cpus_allowed);
@@ -314,7 +314,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			if (ret)
+			if (count)
 				cpus_clear(*lowest_mask);
 			cpu_set(rq->cpu, *lowest_mask);
 			return 1;
@@ -326,14 +326,17 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 			if (rq->rt.highest_prio > lowest_prio) {
 				/* new low - clear old data */
 				lowest_prio = rq->rt.highest_prio;
-				cpus_clear(*lowest_mask);
+				if (count) {
+					cpus_clear(*lowest_mask);
+					count = 0;
+				}
 			}
 			cpu_set(rq->cpu, *lowest_mask);
-			ret = 1;
+			count++;
 		}
 	}
 
-	return ret;
+	return count;
 }
 
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
@@ -357,9 +360,17 @@ static int find_lowest_rq(struct task_struct *task)
 	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	int count    = find_lowest_cpus(task, lowest_mask);
 
-	if (!find_lowest_cpus(task, lowest_mask))
-		return -1;
+	if (!count)
+		return -1; /* No targets found */
+
+	/*
+	 * There is no sense in performing an optimal search if only one
+	 * target is found.
+	 */
+	if (count == 1)
+		return first_cpu(*lowest_mask);
 
 	/*
 	 * At this point we have built a mask of cpus representing the

