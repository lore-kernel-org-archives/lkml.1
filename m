Return-Path: <linux-kernel-owner+w=401wt.eu-S1763271AbXKUBNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763271AbXKUBNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:13:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760426AbXKUBNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:13:16 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:36130 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759907AbXKUBNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:13:15 -0500
Message-Id: <20071121011251.746498886@goodmis.org>
References: <20071121010054.663842380@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 20 Nov 2007 20:01:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH v4 18/20] Optimize cpu search with hamming weight
Content-Disposition: inline; filename=rt-balance-find-cpu-count.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

We can cheaply track the number of bits set in the cpumask for the lowest
priority CPUs.  Therefore, compute the mask's weight and use it to skip
the optimal domain search logic when there is only one CPU available.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-20 19:53:13.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-20 19:53:15.000000000 -0500
@@ -300,7 +300,7 @@ static int find_lowest_cpus(struct task_
 	int       cpu;
 	cpumask_t *valid_mask = &__get_cpu_var(valid_cpu_mask);
 	int       lowest_prio = -1;
-	int       ret         = 0;
+	int       count       = 0;
 
 	cpus_clear(*lowest_mask);
 	cpus_and(*valid_mask, cpu_online_map, task->cpus_allowed);
@@ -313,7 +313,7 @@ static int find_lowest_cpus(struct task_
 
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			if (ret)
+			if (count)
 				cpus_clear(*lowest_mask);
 			cpu_set(rq->cpu, *lowest_mask);
 			return 1;
@@ -325,14 +325,17 @@ static int find_lowest_cpus(struct task_
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
@@ -356,9 +359,17 @@ static int find_lowest_rq(struct task_st
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

-- 
