Return-Path: <linux-kernel-owner+w=401wt.eu-S1761871AbXJYPBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761871AbXJYPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760551AbXJYPBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:01:17 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45120
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758602AbXJYPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:01:12 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing migration
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Thu, 25 Oct 2007 10:46:28 -0400
Message-ID: <20071025144628.19876.35583.stgit@novell1.haskins.net>
In-Reply-To: <20071025144456.19876.94333.stgit@novell1.haskins.net>
References: <20071025144456.19876.94333.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some RT tasks (particularly kthreads) are bound to one specific CPU.
It is fairly common for one or more bound tasks to get queued up at the
same time.  Consider, for instance, softirq_timer and softirq_sched.  A
timer goes off in an ISR which schedules softirq_thread to run at RT50.
Then during the handling of the timer, the system determines that it's
time to smp-rebalance the system so it schedules softirq_sched to run
from within the softirq_timer kthread context. So we are in a situation
where we have two RT50 tasks queued, and the system will go into
rt-overload condition to request other CPUs for help.

The problem is that these tasks cannot ever be pulled away since they
are already running on their one and only valid RQ.  However, the other
CPUs cannot determine that the tasks are unpullable without going
through expensive checks/locking.  Therefore the helping CPUS
experience unecessary overhead/latencies regardless as they
ineffectively try to process the overload condition.

This patch tries to optimize the situation by utilizing the hamming
weight of the task->cpus_allowed mask.  A weight of 1 indicates that
the task cannot be migrated, which may be utilized by the overload
handling code to eliminate uncessary rebalance attempts.  We also
introduce a per-rq variable to count the number of migratable tasks
that are currently running.  We only go into overload if we have more
than one rt task, AND at least one of them is migratable.

Calculating the weight is probably relatively expensive, so it is only
done when the cpus_allowed mask is updated (which should be relatively
infrequent, especially compared to scheduling frequency) and cached in
the task_struct.


Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/sched.h |    2 +
 kernel/fork.c         |    1 
 kernel/sched.c        |    9 +++-
 kernel/sched_rt.c     |  116 +++++++++++++++++++++++++++++++++++++++++--------
 4 files changed, 107 insertions(+), 21 deletions(-)

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
index b59dc20..ad35c89 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -50,6 +50,24 @@ static inline void update_curr_rt(struct rq *rq)
 	curr->se.sum_exec_runtime += delta_exec;
 	curr->se.exec_start = rq->clock;
 }
+#ifdef CONFIG_SMP
+static void inc_rt_migration(struct task_struct *p, struct rq *rq)
+{
+	rq->rt.rt_nr_migratory++;
+
+	if (rq->rt.rt_nr_running > 1)
+		rt_set_overload(p, rq->cpu);
+}
+
+static void dec_rt_migration(struct task_struct *p, struct rq *rq)
+{
+	WARN_ON(!rq->rt.rt_nr_migratory);
+	rq->rt.rt_nr_migratory--;
+
+	if ((rq->rt.rt_nr_running < 2) || !rq->rt.rt_nr_migratory)
+		rt_clear_overload(p, rq->cpu);
+}
+#endif
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
@@ -58,8 +76,8 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio)
 		rq->rt.highest_prio = p->prio;
-	if (rq->rt.rt_nr_running > 1)
-		rt_set_overload(p, rq->cpu);
+	if (p->nr_cpus_allowed > 1)
+		inc_rt_migration(p, rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -81,8 +99,8 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
-	if (rq->rt.rt_nr_running < 2)
-		rt_clear_overload(p, rq->cpu);
+	if (p->nr_cpus_allowed > 1)
+		dec_rt_migration(p, rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -286,6 +304,27 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq,
 	return next;
 }
 
+static int lock_migration_target(struct task_struct *p, struct rq *target_rq)
+{
+	struct rq *this_rq = task_rq(p);
+
+	if (double_lock_balance(this_rq, target_rq)) {
+		/*
+		 * We had to unlock the run queue. In
+		 * the mean time, task could have
+		 * migrated already or had its affinity changed.
+		 */
+		if (unlikely(task_running(this_rq, p) ||
+			     task_rq(p) != this_rq ||
+			     !cpu_isset(target_rq->cpu, p->cpus_allowed))) {
+			spin_unlock(&target_rq->lock);
+			return 0;
+		}
+	}	
+	
+	return 1;
+}
+
 /* Will lock the rq it finds */
 static struct rq *find_lock_lowest_rq(struct task_struct *task,
 				      struct rq *this_rq)
@@ -295,6 +334,28 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 	int cpu;
 	int tries;
 
+ 	/*
+ 	 * We can optimize if the hamming weight of the cpus_allowed mask
+ 	 * is 1 because the task has nowhere to go but one CPU.  So don't
+ 	 * waste the time trying to find the lowest RQ in this case.
+ 	 */
+ 	if (task->nr_cpus_allowed == 1) {
+ 		/* If the task is already on the RQ, we are done */
+ 		if (cpu_isset(this_rq->cpu, task->cpus_allowed))
+ 			return NULL;
+ 
+ 		cpu = first_cpu(task->cpus_allowed);
+ 
+ 		lowest_rq = cpu_rq(cpu);
+ 		BUG_ON(this_rq == lowest_rq);
+ 
+ 		/* Otherwise, we can simply grab the new RQ */
+ 		if (lock_migration_target(task, lowest_rq))
+ 			return lowest_rq;
+ 		else
+ 			return NULL;
+ 	}
+
 	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
 
 	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
@@ -324,22 +385,8 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 			break;
 
 		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(this_rq, lowest_rq)) {
-			/*
-			 * We had to unlock the run queue. In
-			 * the mean time, task could have
-			 * migrated already or had its affinity changed.
-			 * Also make sure that it wasn't scheduled on its rq.
-			 */
-			if (unlikely(task_rq(task) != this_rq ||
-				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed) ||
-				     task_running(this_rq, task) ||
-				     !task->se.on_rq)) {
-				spin_unlock(&lowest_rq->lock);
-				lowest_rq = NULL;
-				break;
-			}
-		}
+ 		if (!lock_migration_target(task, lowest_rq))
+ 			return NULL;
 
 		/* If this rq is still suitable use it. */
 		if (lowest_rq->rt.highest_prio > task->prio)
@@ -658,6 +705,31 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p)
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
+			inc_rt_migration(p, rq);
+		else if((p->nr_cpus_allowed > 1) && (weight <= 1))
+			dec_rt_migration(p, rq);
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
@@ -671,4 +743,8 @@ static struct sched_class rt_sched_class __read_mostly = {
 	.load_balance		= load_balance_rt,
 
 	.task_tick		= task_tick_rt,
+
+#ifdef CONFIG_SMP
+	.set_cpus_allowed       = set_cpus_allowed_rt,
+#endif
 };

