Return-Path: <linux-kernel-owner+w=401wt.eu-S1765146AbXKQGZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765146AbXKQGZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 01:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXKQGYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 01:24:31 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63546 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXKQGY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 01:24:28 -0500
Message-Id: <20071117062405.321402015@goodmis.org>
References: <20071117062104.177779113@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 01:21:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v3 14/17] Optimize our cpu selection based on topology
Content-Disposition: inline; filename=0006-optimize-cpu-section-topology.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory Haskins <ghaskins@novell.com>

The current code base assumes a relatively flat CPU/core topology and will
route RT tasks to any CPU fairly equally.  In the real world, there are
various toplogies and affinities that govern where a task is best suited to
run with the smallest amount of overhead.  NUMA and multi-core CPUs are
prime examples of topologies that can impact cache performance.

Fortunately, linux is already structured to represent these topologies via
the sched_domains interface.  So we change our RT router to consult a
combination of topology and affinity policy to best place tasks during
migration.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 kernel/sched.c    |    1 
 kernel/sched_rt.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 12 deletions(-)

Index: linux-compile.git/kernel/sched.c
===================================================================
--- linux-compile.git.orig/kernel/sched.c	2007-11-16 22:23:39.000000000 -0500
+++ linux-compile.git/kernel/sched.c	2007-11-16 22:23:50.000000000 -0500
@@ -24,6 +24,7 @@
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
  *  2007-10-22  RT overload balancing by Steven Rostedt
  *                 (with thanks to Gregory Haskins)
+ *  2007-11-05  RT migration/wakeup tuning by Gregory Haskins
  */
 
 #include <linux/mm.h>
Index: linux-compile.git/kernel/sched_rt.c
===================================================================
--- linux-compile.git.orig/kernel/sched_rt.c	2007-11-16 22:23:48.000000000 -0500
+++ linux-compile.git/kernel/sched_rt.c	2007-11-16 22:23:50.000000000 -0500
@@ -275,34 +275,109 @@ static struct task_struct *pick_next_hig
 	return next;
 }
 
-static int find_lowest_rq(struct task_struct *task)
+static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 {
-	int cpu;
-	cpumask_t cpu_mask;
-	struct rq *lowest_rq = NULL;
+	int       cpu;
+	cpumask_t valid_mask;
+	int       lowest_prio = -1;
+	int       ret         = 0;
 
-	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
+	cpus_clear(*lowest_mask);
+	cpus_and(valid_mask, cpu_online_map, task->cpus_allowed);
 
 	/*
 	 * Scan each rq for the lowest prio.
 	 */
-	for_each_cpu_mask(cpu, cpu_mask) {
+	for_each_cpu_mask(cpu, valid_mask) {
 		struct rq *rq = cpu_rq(cpu);
 
 		/* We look for lowest RT prio or non-rt CPU */
 		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			lowest_rq = rq;
-			break;
+			if (ret)
+				cpus_clear(*lowest_mask);
+			cpu_set(rq->cpu, *lowest_mask);
+			return 1;
 		}
 
 		/* no locking for now */
-		if (rq->rt.highest_prio > task->prio &&
-		    (!lowest_rq || rq->rt.highest_prio > lowest_rq->rt.highest_prio)) {
-			lowest_rq = rq;
+		if ((rq->rt.highest_prio > task->prio)
+		    && (rq->rt.highest_prio >= lowest_prio)) {
+			if (rq->rt.highest_prio > lowest_prio) {
+				/* new low - clear old data */
+				lowest_prio = rq->rt.highest_prio;
+				cpus_clear(*lowest_mask);
+			}
+			cpu_set(rq->cpu, *lowest_mask);
+			ret = 1;
+		}
+	}
+
+	return ret;
+}
+
+static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
+{
+	int first;
+
+	/* "this_cpu" is cheaper to preempt than a remote processor */
+	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
+		return this_cpu;
+
+	first = first_cpu(*mask);
+	if (first != NR_CPUS)
+		return first;
+
+	return -1;
+}
+
+static int find_lowest_rq(struct task_struct *task)
+{
+	struct sched_domain *sd;
+	cpumask_t lowest_mask;
+	int this_cpu = smp_processor_id();
+	int cpu      = task_cpu(task);
+
+	if (!find_lowest_cpus(task, &lowest_mask))
+		return -1;
+
+	/*
+	 * At this point we have built a mask of cpus representing the
+	 * lowest priority tasks in the system.  Now we want to elect
+	 * the best one based on our affinity and topology.
+	 *
+	 * We prioritize the last cpu that the task executed on since
+	 * it is most likely cache-hot in that location.
+	 */
+	if (cpu_isset(cpu, lowest_mask))
+		return cpu;
+
+	/*
+	 * Otherwise, we consult the sched_domains span maps to figure
+	 * out which cpu is logically closest to our hot cache data.
+	 */
+	if (this_cpu == cpu)
+		this_cpu = -1; /* Skip this_cpu opt if the same */
+
+	for_each_domain(cpu, sd) {
+		if (sd->flags & SD_WAKE_AFFINE) {
+			cpumask_t domain_mask;
+			int       best_cpu;
+
+			cpus_and(domain_mask, sd->span, lowest_mask);
+
+			best_cpu = pick_optimal_cpu(this_cpu,
+						    &domain_mask);
+			if (best_cpu != -1)
+				return best_cpu;
 		}
 	}
 
-	return lowest_rq ? lowest_rq->cpu : -1;
+	/*
+	 * And finally, if there were no matches within the domains
+	 * just give the caller *something* to work with from the compatible
+	 * locations.
+	 */
+	return pick_optimal_cpu(this_cpu, &lowest_mask);
 }
 
 /* Will lock the rq it finds */

-- 
