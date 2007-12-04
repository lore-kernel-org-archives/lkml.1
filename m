Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXLDVKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXLDVKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbXLDVHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:07:10 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:53446
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754712AbXLDVHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:07:06 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 08/23] Subject: SCHED - Cache cpus_allowed weight for
	optimizing migration
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 15:45:06 -0500
Message-ID: <20071204204506.3567.35263.stgit@novell1.haskins.net>
In-Reply-To: <20071204204236.3567.65491.stgit@novell1.haskins.net>
References: <20071204204236.3567.65491.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---

 include/linux/init_task.h |    1 +
 include/linux/sched.h     |    2 ++
 kernel/fork.c             |    1 +
 kernel/sched.c            |    9 +++++++-
 kernel/sched_rt.c         |   50 +++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index cae35b6..572c65b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -130,6 +130,7 @@ extern struct group_info init_groups;
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
+	.nr_cpus_allowed = NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ac3d496..a3dc53b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -847,6 +847,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
+	void (*set_cpus_allowed)(struct task_struct *p, cpumask_t *newmask);
 };
 
 struct load_weight {
@@ -956,6 +957,7 @@ struct task_struct {
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
+	int nr_cpus_allowed;
 	unsigned int time_slice;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
diff --git a/kernel/fork.c b/kernel/fork.c
index 8ca1a14..12e3e58 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1237,6 +1237,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
 	p->cpus_allowed = current->cpus_allowed;
+	p->nr_cpus_allowed = current->nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
diff --git a/kernel/sched.c b/kernel/sched.c
index ebd114b..70f08de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -269,6 +269,7 @@ struct rt_rq {
 	int rt_load_balance_idx;
 	struct list_head *rt_load_balance_head, *rt_load_balance_curr;
 	unsigned long rt_nr_running;
+	unsigned long rt_nr_migratory;
 	/* highest queued rt task prio */
 	int highest_prio;
 };
@@ -5080,7 +5081,13 @@ int set_cpus_allowed(struct task_struct *p, cpumask_t new_mask)
 		goto out;
 	}
 
-	p->cpus_allowed = new_mask;
+	if (p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, &new_mask);
+	else {
+		p->cpus_allowed    = new_mask;
+		p->nr_cpus_allowed = cpus_weight(new_mask);
+	}
+
 	/* Can the task run on the task's current CPU? If so, we're done */
 	if (cpu_isset(task_cpu(p), new_mask))
 		goto out;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index ea07ffa..e5bce6a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -33,6 +33,14 @@ static inline void rt_clear_overload(struct rq *rq)
 	atomic_dec(&rto_count);
 	cpu_clear(rq->cpu, rt_overload_mask);
 }
+
+static void update_rt_migration(struct rq *rq)
+{
+	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1))
+		rt_set_overload(rq);
+	else
+		rt_clear_overload(rq);
+}
 #endif /* CONFIG_SMP */
 
 /*
@@ -65,8 +73,10 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio)
 		rq->rt.highest_prio = p->prio;
-	if (rq->rt.rt_nr_running > 1)
-		rt_set_overload(rq);
+	if (p->nr_cpus_allowed > 1)
+		rq->rt.rt_nr_migratory++;
+
+	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -88,8 +98,10 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
-	if (rq->rt.rt_nr_running < 2)
-		rt_clear_overload(rq);
+	if (p->nr_cpus_allowed > 1)
+		rq->rt.rt_nr_migratory--;
+
+	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
 }
 
@@ -180,7 +192,8 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)))
+	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
+	    (p->nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -582,6 +595,32 @@ move_one_task_rt(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	/* don't touch RT tasks */
 	return 0;
 }
+static void set_cpus_allowed_rt(struct task_struct *p, cpumask_t *new_mask)
+{
+	int weight = cpus_weight(*new_mask);
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
+		else if ((p->nr_cpus_allowed > 1) && (weight <= 1)) {
+			BUG_ON(!rq->rt.rt_nr_migratory);
+			rq->rt.rt_nr_migratory--;
+		}
+
+		update_rt_migration(rq);
+	}
+
+	p->cpus_allowed    = *new_mask;
+	p->nr_cpus_allowed = weight;
+}
 #else /* CONFIG_SMP */
 # define schedule_tail_balance_rt(rq)	do { } while (0)
 # define schedule_balance_rt(rq, prev)	do { } while (0)
@@ -633,6 +672,7 @@ const struct sched_class rt_sched_class = {
 #ifdef CONFIG_SMP
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
+	.set_cpus_allowed       = set_cpus_allowed_rt,
 #endif
 
 	.set_curr_task          = set_curr_task_rt,

