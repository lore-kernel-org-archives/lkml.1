Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXJWRJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXJWRJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 13:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJWRGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 13:06:08 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:35126
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754847AbXJWRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 13:06:05 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 13/13] RT: Cache cpus_allowed weight for optimizing migration
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Tue, 23 Oct 2007 12:51:30 -0400
Message-ID: <20071023165130.5536.73345.stgit@novell1.haskins.net>
In-Reply-To: <20071023164156.5536.95573.stgit@novell1.haskins.net>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
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

 include/linux/sched.h |    1 
 kernel/fork.c         |    1 
 kernel/sched.c        |  121 +++++++++++++++++++++++++++++++++++++------------
 3 files changed, 94 insertions(+), 29 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7a3829f..b657c13 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1144,6 +1144,7 @@ struct task_struct {
 
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
index bdb6be0..9120b41 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -305,6 +305,7 @@ struct rq {
 
 #ifdef CONFIG_PREEMPT_RT
 	unsigned long rt_nr_running;
+	unsigned long rt_nr_migratory;
 	unsigned long rt_nr_uninterruptible;
 	int highest_prio;
 #endif
@@ -665,20 +666,43 @@ static inline struct rq *this_rq_lock(void)
 #if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP)
 static __cacheline_aligned_in_smp atomic_t rt_overload;
 static cpumask_t rto_cpus;
-#endif
+
+static void inc_rt_migration(struct rq *rq)
+{
+	rq->rt_nr_migratory++;
+
+	if ((rq->rt_nr_running > 1) && !cpu_isset(rq->cpu, rto_cpus)) {
+		cpu_set(rq->cpu, rto_cpus);
+		smp_wmb();
+		atomic_inc(&rt_overload);
+	}
+}
+
+static void dec_rt_migration(struct rq *rq)
+{
+	WARN_ON(!rq->rt_nr_migratory);
+	rq->rt_nr_migratory--;
+
+	if (((rq->rt_nr_running <= 1) || !rq->rt_nr_migratory)
+	    && cpu_isset(rq->cpu, rto_cpus)) {
+		atomic_dec(&rt_overload);
+		cpu_clear(rq->cpu, rto_cpus);
+	}
+}
+
+#else
+#define inc_rt_migration(rq) do { } while(0)
+#define dec_rt_migration(rq) do { } while(0)
+#endif /* defined(CONFIG_PREEMPT_RT) && defined(CONFIG_SMP) */
+
 
 static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 {
 #ifdef CONFIG_PREEMPT_RT
 	if (rt_task(p)) {
 		rq->rt_nr_running++;
-# ifdef CONFIG_SMP
-		if (rq->rt_nr_running == 2) {
-			cpu_set(rq->cpu, rto_cpus);
-			smp_wmb();
-			atomic_inc(&rt_overload);
-		}
-# endif
+		if (p->nr_cpus_allowed > 1)
+			inc_rt_migration(rq);
 	}
 #endif
 }
@@ -689,12 +713,8 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 	if (rt_task(p)) {
 		WARN_ON(!rq->rt_nr_running);
 		rq->rt_nr_running--;
-# ifdef CONFIG_SMP
-		if (rq->rt_nr_running == 1) {
-			atomic_dec(&rt_overload);
-			cpu_clear(rq->cpu, rto_cpus);
-		}
-# endif
+		if (p->nr_cpus_allowed > 1)
+			dec_rt_migration(rq);
 	}
 #endif
 }
@@ -1526,6 +1546,27 @@ next_in_queue:
 
 static int double_lock_balance(struct rq *this_rq, struct rq *busiest);
 
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
 /* Only try this algorithm three times */
 #define RT_PUSH_MAX_TRIES 3
 
@@ -1537,6 +1578,28 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 	int cpu;
 	int tries;
 
+	/*
+	 * We can optimize if the hamming weight of the cpus_allowed mask
+	 * is 1 because the task has nowhere to go but one CPU.  So don't
+	 * waste the time trying to find the lowest RQ in this case.
+	 */
+	if (task->nr_cpus_allowed == 1) {
+		/* If the task is already on the RQ, we are done */
+		if (cpu_isset(this_rq->cpu, task->cpus_allowed))
+			return NULL;
+
+		cpu = first_cpu(task->cpus_allowed);
+
+		lowest_rq = cpu_rq(cpu);
+		BUG_ON(this_rq == lowest_rq);
+
+		/* Otherwise, we can simply grab the new RQ */
+		if (lock_migration_target(task, lowest_rq))
+			return lowest_rq;
+		else
+			return NULL;
+	}
+
 	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
 		cpu = cpupri_find(this_rq->cpu, task);
 
@@ -1546,21 +1609,8 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 		lowest_rq = cpu_rq(cpu);
 
 		/* if the prio of this runqueue changed, try again */
-		if (double_lock_balance(this_rq, lowest_rq)) {
-			/*
-			 * We had to unlock the run queue. In
-			 * the mean time, task could have
-			 * migrated already or had its affinity changed.
-			 */
-			if (unlikely(task_running(this_rq, task) ||
-				     task_rq(task) != this_rq ||
-				     !cpu_isset(lowest_rq->cpu, task->cpus_allowed))) {
-				spin_unlock(&lowest_rq->lock);
-				lowest_rq = NULL;
-				break;
-			}
-
-		}
+		if (!lock_migration_target(task, lowest_rq))
+			return NULL;
 
 		/* If this rq is still suitable use it. */
 		if (lowest_rq->highest_prio > task->prio)
@@ -5794,6 +5844,7 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 	unsigned long flags;
 	struct rq *rq;
 	int ret = 0;
+	int weight = cpus_weight(new_mask);
 
 	rq = task_rq_lock(p, &flags);
 	if (!cpus_intersects(new_mask, cpu_online_map)) {
@@ -5801,7 +5852,19 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 		goto out;
 	}
 
+#ifdef CONFIG_SMP
+	if (rt_task(p) && task_running(rq,p)) {
+		if (weight != p->nr_cpus_allowed) {
+			if ((p->nr_cpus_allowed <= 1) && (weight > 1))
+				inc_rt_migration(rq);
+			else if((p->nr_cpus_allowed > 1) && (weight <= 1))
+				dec_rt_migration(rq);
+		}
+	}
+#endif
 	p->cpus_allowed = new_mask;
+	p->nr_cpus_allowed = weight;
+
 	/* Can the task run on the task's current CPU? If so, we're done */
 	if (cpu_isset(task_cpu(p), new_mask))
 		goto out;

