Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbXJZQBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbXJZQBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbXJZQB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:01:26 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:33780
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbXJZQBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:01:23 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/2] RT: Cache cpus_allowed weight for optimizing migration
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 26 Oct 2007 11:46:25 -0400
Message-ID: <20071026154625.6195.36378.stgit@novell1.haskins.net>
In-Reply-To: <Pine.LNX.4.58.0710261114270.3280@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0710261114270.3280@gandalf.stny.rr.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some RT tasks (particularly kthreads) are bound to one specific CPU.
It is fairly common for two or more bound tasks to get queued up at the
same time.  Consider, for instance, softirq_timer and softirq_sched.  A
timer goes off in an ISR which schedules softirq_thread to run at RT50.
Then the timer handler determines that it's time to smp-rebalance the
system so it schedules softirq_sched to run.  So we are in a situation
where we have two RT50 tasks queued, and the system will go into
rt-overload condition to request other CPUs for help.

This causes two problems in the current code:

1) If a high-priority bound task and a low-priority unbounded task queue
   up behind the running task, we will fail to ever relocate the unbounded
   task because we terminate the search on the first unmovable task.

2) We spend precious futile cycles in the fast-path trying to pull
   overloaded tasks over.  It is therefore optimial to strive to avoid the
   overhead all together if we can cheaply detect the condition before
   overload even occurs.

This patch tries to achieve this optimization by utilizing the hamming
weight of the task->cpus_allowed mask.  A weight of 1 indicates that
the task cannot be migrated.  We will then utilize this information to
skip non-migratable tasks and to eliminate uncessary rebalance attempts.

We introduce a per-rq variable to count the number of migratable tasks
that are currently running.  We only go into overload if we have more
than one rt task, AND at least one of them is migratable.

In addition, we introduce a per-task variable to cache the cpus_allowed
weight, since the hamming calculation is probably relatively expensive.
We only update the cached value when the mask is updated which should be
relatively infrequent, especially compared to scheduling frequency
in the fast path.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    2 ++
 kernel/fork.c         |    1 +
 kernel/sched.c        |    9 +++++++-
 kernel/sched_rt.c     |   58 +++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7a3829f..829de6f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1048,6 +1048,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t newmask);
 };
 
 struct load_weight {
@@ -1144,6 +1145,7 @@ struct task_struct {
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
+	int nr_cpus_allowed;
 	unsigned int time_slice;
 
 #ifdef CONFIG_PREEMPT_RCU
diff --git a/kernel/fork.c b/kernel/fork.c
index 5f11f23..f808e18 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1257,6 +1257,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	preempt_disable();
 	p->cpus_allowed = current->cpus_allowed;
+	p->nr_cpus_allowed = current->nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
diff --git a/kernel/sched.c b/kernel/sched.c
index 30fa531..6c90093 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -262,6 +262,7 @@ struct rt_rq {
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
 	unsigned long rt_nr_running;
+	unsigned long rt_nr_migratory;
 	unsigned long rt_nr_uninterruptible;
 	/* highest queued rt task prio */
 	int highest_prio;
@@ -5371,7 +5372,13 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 		goto out;
 	}
 
-	p->cpus_allowed = new_mask;
+	if (p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, new_mask);
+	else {
+		p->cpus_allowed    = new_mask;
+		p->nr_cpus_allowed = cpus_weight(new_mask);
+	}
+
 	/* Can the task run on the task's current CPU? If so, we're done */
 	if (cpu_isset(task_cpu(p), new_mask))
 		goto out;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b59dc20..64481c8 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -51,6 +51,16 @@ static inline void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 }
 
+#ifdef CONFIG_SMP
+static void update_rt_migration(struct task_struct *p, struct rq *rq)
+{
+	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1))
+		rt_set_overload(p, rq->cpu);
+	else
+		rt_clear_overload(p, rq->cpu);
+}
+#endif
+
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
 	WARN_ON(!rt_task(p));
@@ -58,8 +68,10 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio)
 		rq->rt.highest_prio = p->prio;
-	if (rq->rt.rt_nr_running > 1)
-		rt_set_overload(p, rq->cpu);
+	if (p->nr_cpus_allowed > 1)
+		rq->rt.rt_nr_migratory++;
+
+	update_rt_migration(p, rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -81,8 +93,10 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
-	if (rq->rt.rt_nr_running < 2)
-		rt_clear_overload(p, rq->cpu);
+	if (p->nr_cpus_allowed > 1)
+		rq->rt.rt_nr_migratory--;
+
+	update_rt_migration(p, rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -227,7 +241,8 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)))
+	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
+	    (p->nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -658,6 +673,35 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
 	}
 }
 
+#ifdef CONFIG_SMP
+static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t new_mask)
+{
+	int weight = cpus_weight(new_mask);
+
+	BUG_ON(!rt_task(p));
+
+	/*
+	 * Update the migration status of the RQ if we have an RT task
+	 * which is running AND changing its weight value.
+	 */
+	if (p->se.on_rq && (weight != p->nr_cpus_allowed)) {
+		struct rq *rq = task_rq(p);
+
+		if ((p->nr_cpus_allowed <= 1) && (weight > 1))
+			rq->rt.rt_nr_migratory++;
+		else if((p->nr_cpus_allowed > 1) && (weight <= 1)) {
+			BUG_ON(!rq->rt.rt_nr_migratory);
+			rq->rt.rt_nr_migratory--;
+		}
+
+		update_rt_migration(p, rq);
+	}
+
+	p->cpus_allowed    = new_mask;
+	p->nr_cpus_allowed = weight;
+}
+#endif
+
 static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -671,4 +715,8 @@ static struct sched_class rt_sched_class __read_mostly = {
 	.load_balance		= load_balance_rt,
 
 	.task_tick		= task_tick_rt,
+
+#ifdef CONFIG_SMP
+	.set_cpus_allowed       = set_cpus_allowed_rt,
+#endif
 };

