Return-Path: <linux-kernel-owner+w=401wt.eu-S935536AbXK3RKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536AbXK3RKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935158AbXK3RIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:08:21 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:43073
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935454AbXK3RIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:08:19 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/4] Subject: SCHED - Only balance our RT tasks within our
	root-domain
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML 
	<"linux-kernel@vger.kernel.org>, linux-rt-users"@vger.kernel.org>,
       mingo@elte.hu
Date: Fri, 30 Nov 2007 11:46:59 -0500
Message-ID: <20071130164659.30588.70134.stgit@novell1.haskins.net>
In-Reply-To: <20071130163638.30588.47845.stgit@novell1.haskins.net>
References: <20071130163638.30588.47845.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
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

 kernel/sched.c    |    2 ++
 kernel/sched_rt.c |   57 ++++++++++++++++++++++++++++++++---------------------
 2 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 9fcf36a..e9d932d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -292,6 +292,8 @@ struct root_domain {
 	atomic_t refcount;
 	cpumask_t span;
 	cpumask_t online;
+	cpumask_t rto_mask;
+	atomic_t  rto_count;
 };
 
 static struct root_domain def_root_domain;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a9675dc..78a188f 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -4,20 +4,18 @@
  */
 
 #ifdef CONFIG_SMP
-static cpumask_t rt_overload_mask;
-static atomic_t rto_count;
-static inline int rt_overloaded(void)
+
+static inline int rt_overloaded(struct rq *rq)
 {
-	return atomic_read(&rto_count);
+	return atomic_read(&rq->rd->rto_count);
 }
-static inline cpumask_t *rt_overload(void)
+static inline cpumask_t *rt_overload(struct rq *rq)
 {
-	return &rt_overload_mask;
+	return &rq->rd->rto_mask;
 }
 static inline void rt_set_overload(struct rq *rq)
 {
-	rq->rt.overloaded = 1;
-	cpu_set(rq->cpu, rt_overload_mask);
+	cpu_set(rq->cpu, rq->rd->rto_mask);
 	/*
 	 * Make sure the mask is visible before we set
 	 * the overload count. That is checked to determine
@@ -26,22 +24,24 @@ static inline void rt_set_overload(struct rq *rq)
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
 
@@ -325,7 +325,7 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 	int       count       = 0;
 	int       cpu;
 
-	cpus_and(*lowest_mask, cpu_online_map, task->cpus_allowed);
+	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
 
 	/*
 	 * Scan each rq for the lowest prio.
@@ -608,18 +608,12 @@ static int pull_rt_task(struct rq *this_rq)
 
 	assert_spin_locked(&this_rq->lock);
 
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
 
-	rto_cpumask = rt_overload();
+	rto_cpumask = rt_overload(this_rq);
 
 	for_each_cpu_mask(cpu, *rto_cpumask) {
 		if (this_cpu == cpu)
@@ -838,6 +832,20 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
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
@@ -867,4 +875,7 @@ const struct sched_class rt_sched_class = {
 
 	.set_curr_task          = set_curr_task_rt,
 	.task_tick		= task_tick_rt,
+
+	.join_domain            = join_domain_rt,
+	.leave_domain           = leave_domain_rt,
 };

