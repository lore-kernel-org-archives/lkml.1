Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbXKFAvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbXKFAvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXKFAuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:35 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25184 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755166AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 6/8] RT: Optimize our cpu selection based on topology
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:49:03 -0700
Message-ID: <20071105234903.25451.30047.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 kernel/sched.c    |    1 +
 kernel/sched_rt.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d16c686..8a27f09 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -26,6 +26,7 @@
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
  *  2007-10-22  RT overload balancing by Steven Rostedt
  *                 (with thanks to Gregory Haskins)
+ *  2007-11-05  RT migration/wakeup tuning by Gregory Haskins
  */
 
 #include <linux/mm.h>
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 43d4ea6..6ba5921 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -331,34 +331,109 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq,
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

