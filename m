Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXLEDSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXLEDSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXLEDRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:17:38 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:46987
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752889AbXLEDRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:17:35 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] Subject: SCHED - Only balance our RT tasks within our
	root-domain
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 21:55:33 -0500
Message-ID: <20071205025533.4494.63786.stgit@novell1.haskins.net>
In-Reply-To: <20071205025137.4494.18683.stgit@novell1.haskins.net>
References: <20071205025137.4494.18683.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We move the rt-overload data as the first global to per-domain
reclassification.  This limits the scope of overload related cache-line
bouncing to stay with a specified partition instead of affecting all
cpus in the system.

Finally, we limit the scope of find_lowest_cpu searches to the domain
instead of the entire system.  Note that we would always respect domain
boundaries even without this patch, but we first would scan potentially
all cpus before whittling the list down.  Now we can avoid looking at
RQs that are out of scope, again reducing cache-line hits.

Note: In some cases, task->cpus_allowed will effectively reduce our search
to within our domain.  However, I believe there are cases where the
cpus_allowed mask may be all ones and therefore we err on the side of
caution.  If it can be optimized later, so be it.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Christoph Lameter <clameter@sgi.com>
---

 kernel/sched.c    |    7 +++++++
 kernel/sched_rt.c |   57 +++++++++++++++++++++++++++++------------------------
 2 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dfb939f..9a09f82 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -367,6 +367,13 @@ struct root_domain {
 	atomic_t refcount;
 	cpumask_t span;
 	cpumask_t online;
+
+        /*
+	 * The "RT overload" flag: it gets set if a CPU has more than
+	 * one runnable RT task.
+	 */
+	cpumask_t rto_mask;
+	atomic_t  rto_count;
 };
 
 static struct root_domain def_root_domain;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 9dcf522..f9728d0 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -5,22 +5,14 @@
 
 #ifdef CONFIG_SMP
 
-/*
- * The "RT overload" flag: it gets set if a CPU has more than
- * one runnable RT task.
- */
-static cpumask_t rt_overload_mask;
-static atomic_t rto_count;
-
-static inline int rt_overloaded(void)
+static inline int rt_overloaded(struct rq *rq)
 {
-	return atomic_read(&rto_count);
+	return atomic_read(&rq->rd->rto_count);
 }
 
 static inline void rt_set_overload(struct rq *rq)
 {
-	rq->rt.overloaded = 1;
-	cpu_set(rq->cpu, rt_overload_mask);
+	cpu_set(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
 	 * the overload count. That is checked to determine
@@ -29,23 +21,25 @@ static inline void rt_set_overload(struct rq *rq)
 	 * updated yet.
 	 */
 	wmb();
-	atomic_inc(&rto_count);
+	atomic_inc(&rq->rd->rto_count);
 }
 
 static inline void rt_clear_overload(struct rq *rq)
 {
 	/* the order here really doesn't matter */
-	atomic_dec(&rto_count);
-	cpu_clear(rq->cpu, rt_overload_mask);
-	rq->rt.overloaded = 0;
+	atomic_dec(&rq->rd->rto_count);
+	cpu_clear(rq->cpu, rq->rd->rto_mask);
 }
 
 static void update_rt_migration(struct rq *rq)
 {
-	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1))
+	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
 		rt_set_overload(rq);
-	else
+		rq->rt.overloaded = 1;
+	} else {
 		rt_clear_overload(rq);
+		rq->rt.overloaded = 0;
+	}
 }
 #endif /* CONFIG_SMP */
 
@@ -306,7 +300,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	int       count       = 0;
 	int       cpu;
 
-	cpus_and(*lowest_mask, cpu_online_map, task->cpus_allowed);
+	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
 
 	/*
 	 * Scan each rq for the lowest prio.
@@ -580,18 +574,12 @@ static int pull_rt_task(struct rq *this_rq)
 	struct task_struct *p, *next;
 	struct rq *src_rq;
 
-	/*
-	 * If cpusets are used, and we have overlapping
-	 * run queue cpusets, then this algorithm may not catch all.
-	 * This is just the price you pay on trying to keep
-	 * dirtying caches down on large SMP machines.
-	 */
-	if (likely(!rt_overloaded()))
+	if (likely(!rt_overloaded(this_rq)))
 		return 0;
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask(cpu, rt_overload_mask) {
+	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
@@ -809,6 +797,20 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
 	}
 }
 
+/* Assumes rq->lock is held */
+static void join_domain_rt(struct rq *rq)
+{
+	if (rq->rt.overloaded)
+		rt_set_overload(rq);
+}
+
+/* Assumes rq->lock is held */
+static void leave_domain_rt(struct rq *rq)
+{
+	if (rq->rt.overloaded)
+		rt_clear_overload(rq);
+}
+
 static void set_curr_task_rt(struct rq *rq)
 {
 	struct task_struct *p = rq->curr;
@@ -838,4 +840,7 @@ const struct sched_class rt_sched_class = {
 
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
+
+	.join_domain            = join_domain_rt,
+	.leave_domain           = leave_domain_rt,
 };

