Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbXJKWPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbXJKWPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759083AbXJKWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:37 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45369
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758977AbXJKWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 6/7] RT: Convert Steve's rt-push infrastructure to cpupri
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 18:00:15 -0400
Message-ID: <20071011220015.27097.74545.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize the CPU priority system between the two search algorithms, and
modularlize the search function within push_rt_tasks.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |   91 ++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 0065551..e8942c5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -24,6 +24,7 @@
  *              by Peter Williams
  *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-10-11  RT overload enhancements by Steven Rostedt, Greg Haskins
  */
 
 #include <linux/mm.h>
@@ -305,8 +306,10 @@ struct rq {
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
 	unsigned long rt_nr_uninterruptible;
+#ifndef CONFIG_CPU_PRIORITIES
 	int curr_prio;
 #endif
+#endif
 
 	unsigned long switch_timestamp;
 	unsigned long slice_avg;
@@ -501,9 +504,48 @@ static int get_cpupri(struct rq *rq)
 	return cpupri_get(rq->cpu);
 }
 
+static int find_lowest_cpu(int defcpu, int pri, struct task_struct *p)
+{
+	return cpupri_find_best(defcpu, pri, p);
+}
 #else
-#define set_cpupri(rq, task) do { } while (0)
-#define get_cpupri(rq)         CPUPRI_INVALID
+static void set_cpupri(struct rq *rq, struct task_struct *p)
+{
+	rq->curr_prio = calc_task_cpupri(rq, p);
+}
+
+static int get_cpupri(struct rq *rq)
+{
+	return rq->curr_prio;
+}
+
+static int find_lowest_cpu(int defcpu, int pri, struct task_struct *p)
+{
+	cpumask_t  mask;
+	int        cpu;
+	struct rq *lowest_rq = NULL;
+
+	cpus_and(mask, cpu_online_map, p->cpus_allowed);
+
+	/*
+	 * Scan each rq for the lowest prio.
+	 */
+	for_each_cpu_mask(cpu, mask) {
+		struct rq *rq = &per_cpu(runqueues, cpu);
+		
+		if (cpu == smp_processor_id())
+			continue;
+		
+		/* no locking for now */
+		if (rq->curr_prio < pri &&
+		    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
+			lowest_rq = rq;
+		}
+	}
+
+	return lowest_rq ? lowest_rq->cpu : defcpu;
+}
+
 #endif
 
 /*
@@ -1531,11 +1573,9 @@ static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 static int push_rt_task(struct rq *this_rq)
 {
 	struct task_struct *next_task;
-	struct rq *lowest_rq = NULL;
 	int tries;
-	int cpu;
-	int dst_cpu = -1;
 	int ret = 0;
+	int pri;
 
 	assert_spin_locked(&this_rq->lock);
 
@@ -1546,32 +1586,19 @@ static int push_rt_task(struct rq *this_rq)
 	/* We might release this_rq lock */
 	get_task_struct(next_task);
 
+	pri = calc_task_cpupri(this_rq, next_task);
+
 	/* Only try this algorithm three times */
 	for (tries = 0; tries < 3; tries++) {
-		cpumask_t mask;
-
-		cpus_and(mask, cpu_online_map, next_task->cpus_allowed);
-
-		/*
-		 * Scan each rq for the lowest prio.
-		 */
-		for_each_cpu_mask(cpu, mask) {
-			struct rq *rq = &per_cpu(runqueues, cpu);
-
-			if (cpu == smp_processor_id())
-				continue;
-
-			/* no locking for now */
-			if (rq->curr_prio > next_task->prio &&
-			    (!lowest_rq || rq->curr_prio < lowest_rq->curr_prio)) {
-				dst_cpu = cpu;
-				lowest_rq = rq;
-			}
-		}
+		struct rq *lowest_rq;
+		int        cpu;
 
-		if (!lowest_rq)
+		cpu = find_lowest_cpu(this_rq->cpu, pri, next_task); 
+		if (cpu == this_rq->cpu)
 			break;
 
+		lowest_rq = cpu_rq(cpu);
+
 		if (double_lock_balance(this_rq, lowest_rq)) {
 			/*
 			 * We had to unlock the run queue. In
@@ -1579,20 +1606,20 @@ static int push_rt_task(struct rq *this_rq)
 			 * migrated already or had its affinity changed.
 			 */
 			if (unlikely(task_rq(next_task) != this_rq ||
-				     !cpu_isset(dst_cpu, next_task->cpus_allowed))) {
+				     !cpu_isset(cpu, next_task->cpus_allowed))) {
 				spin_unlock(&lowest_rq->lock);
 				break;
 			}
 		}
 
 		/* if the prio of this runqueue changed, try again */
-		if (lowest_rq->curr_prio <= next_task->prio) {
+		if (get_cpupri(lowest_rq) > pri) {
 			spin_unlock(&lowest_rq->lock);
 			continue;
 		}
 
 		deactivate_task(this_rq, next_task, 0);
-		set_task_cpu(next_task, dst_cpu);
+		set_task_cpu(next_task, lowest_rq->cpu);
 		activate_task(lowest_rq, next_task, 0);
 
 		resched_task(lowest_rq->curr);
@@ -2333,7 +2360,7 @@ static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	 * If we pushed an RT task off the runqueue,
 	 * then kick other CPUs, they might run it:
 	 */
-	rq->curr_prio = current->prio;
+
 	if (unlikely(rq->rt_nr_running > 1))
 		push_rt_task(rq);
 
@@ -7371,6 +7398,10 @@ void __init sched_init(void)
 		highest_cpu = i;
 		/* delimiter for bitsearch: */
 		__set_bit(MAX_RT_PRIO, array->bitmap);
+
+#if defined(CONFIG_PREEMPT_RT) && !defined(CONFIG_CPU_PRIORITIES)
+		rq->curr_prio = CPUPRI_INVALID;
+#endif
 	}
 
 	set_load_weight(&init_task);

