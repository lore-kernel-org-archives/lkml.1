Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbXCURaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbXCURaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933215AbXCURaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:30:08 -0400
Received: from mail25.syd.optusnet.com.au ([211.29.133.166]:39750 "EHLO
	mail25.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbXCURaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:30:05 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sched: rsdl improvements
Date: Thu, 22 Mar 2007 04:29:44 +1100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220429.45311.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

As my time at the pc is limited I unfortunately cannot spend it responding to
the huge number of emails I got in response to RSDL. Instead, here's a patch.
I may be offline for extended periods at a time still so please others feel 
free to poke at the code and don't take it personally if I don't respond to
your emails. 

Note no interactive boost idea here.

Patch is for 2.6.21-rc4-mm1. I have not spent the time trying to bring other
bases in sync.

---
Further improve the deterministic nature of the RSDL cpu scheduler and make
the rr_interval tunable.

By only giving out priority slots to tasks at the current runqueue's
prio_level or below we can make the cpu allocation not altered by accounting
issues across major_rotation periods. This makes the cpu allocation and
latencies more deterministic, and decreases maximum latencies substantially.
This change removes the possibility that tasks can get bursts of cpu activity
which can favour towards interactive tasks but also favour towards cpu bound
tasks which happen to wait on other activity (such as I/O) and is a net
gain.

This change also makes negative nice values less harmful to latencies of more
niced tasks, and should lead to less preemption which might decrease the
context switch rate and subsequently improve throughput.

The rr_interval can be made a tunable such that if an environment exists that
is not as latency sensitive, it can be increased for maximum throughput.

A tiny change checking for MAX_PRIO in normal_prio() may prevent oopses on
bootup on large SMP due to forking off the idle task.

Other minor cleanups.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 Documentation/sysctl/kernel.txt |   12 +++++
 kernel/sched.c                  |   94 ++++++++++++++++++++++------------------
 kernel/sysctl.c                 |   25 ++++++++--
 3 files changed, 83 insertions(+), 48 deletions(-)

Index: linux-2.6.21-rc4-mm1/Documentation/sysctl/kernel.txt
===================================================================
--- linux-2.6.21-rc4-mm1.orig/Documentation/sysctl/kernel.txt	2007-03-21 20:53:50.000000000 +1100
+++ linux-2.6.21-rc4-mm1/Documentation/sysctl/kernel.txt	2007-03-21 20:54:19.000000000 +1100
@@ -43,6 +43,7 @@ show up in /proc/sys/kernel:
 - printk
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
+- rr_interval
 - rtsig-max
 - rtsig-nr
 - sem
@@ -288,6 +289,17 @@ rebooting. ???
 
 ==============================================================
 
+rr_interval:
+
+This is the smallest duration that any cpu process scheduling unit
+will run for. Increasing this value can increase throughput of cpu
+bound tasks substantially but at the expense of increased latencies
+overall. This value is in _ticks_ and the default value chosen depends
+on the number of cpus available at scheduler initialisation. Valid
+values are from 1-100.
+
+==============================================================
+
 rtsig-max & rtsig-nr:
 
 The file rtsig-max can be used to tune the maximum number
Index: linux-2.6.21-rc4-mm1/kernel/sched.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/sched.c	2007-03-21 20:53:50.000000000 +1100
+++ linux-2.6.21-rc4-mm1/kernel/sched.c	2007-03-22 03:58:42.000000000 +1100
@@ -93,8 +93,10 @@ unsigned long long __attribute__((weak))
 /*
  * This is the time all tasks within the same priority round robin.
  * Set to a minimum of 8ms. Scales with number of cpus and rounds with HZ.
+ * Tunable via /proc interface.
  */
-static unsigned int rr_interval __read_mostly;
+int rr_interval __read_mostly;
+
 #define RR_INTERVAL		8
 #define DEF_TIMESLICE		(rr_interval * 20)
 
@@ -686,19 +688,32 @@ static inline void task_new_array(struct
 	p->rotation = rq->prio_rotation;
 }
 
+/* Find the first slot from the relevant prio_matrix entry */
 static inline int first_prio_slot(struct task_struct *p)
 {
 	return SCHED_PRIO(find_first_zero_bit(
 		prio_matrix[USER_PRIO(p->static_prio)], PRIO_RANGE));
 }
 
-static inline int next_prio_slot(struct task_struct *p, int prio)
+/* Is a dynamic_prio part of the allocated slots for this static_prio */
+static inline int entitled_slot(int static_prio, int dynamic_prio)
+{
+	return !test_bit(USER_PRIO(dynamic_prio),
+		prio_matrix[USER_PRIO(static_prio)]);
+}
+
+/*
+ * Find the first unused slot by this task that is also in its prio_matrix
+ * level.
+ */
+static inline int next_entitled_slot(struct task_struct *p, struct rq *rq)
 {
 	DECLARE_BITMAP(tmp, PRIO_RANGE);
+
 	bitmap_or(tmp, p->bitmap, prio_matrix[USER_PRIO(p->static_prio)],
 		  PRIO_RANGE);
 	return SCHED_PRIO(find_next_zero_bit(tmp, PRIO_RANGE,
-		USER_PRIO(prio)));
+		USER_PRIO(rq->prio_level)));
 }
 
 static void queue_expired(struct task_struct *p, struct rq *rq)
@@ -725,23 +740,12 @@ static void queue_expired(struct task_st
 static void recalc_task_prio(struct task_struct *p, struct rq *rq)
 {
 	struct prio_array *array = rq->active;
-	int queue_prio, search_prio = MAX_RT_PRIO;
-
-	/*
-	 * SCHED_BATCH tasks never start at better priority than any other
-	 * task that is already running since they are flagged as latency
-	 * insensitive. This means they never cause greater latencies in other
-	 * non SCHED_BATCH tasks of the same nice level, but they still will
-	 * not be exposed to high latencies themselves.
-	 */
-	if (unlikely(p->policy == SCHED_BATCH))
-		search_prio = rq->prio_level;
+	int queue_prio;
 
 	if (p->rotation == rq->prio_rotation) {
 		if (p->array == array) {
 			if (p->time_slice && rq_quota(rq, p->prio))
 				return;
-			search_prio = p->prio;
 		} else if (p->array == rq->expired) {
 			queue_expired(p, rq);
 			return;
@@ -750,7 +754,7 @@ static void recalc_task_prio(struct task
 	} else
 		task_new_array(p, rq);
 
-	queue_prio = next_prio_slot(p, search_prio);
+	queue_prio = next_entitled_slot(p, rq);
 	if (queue_prio >= MAX_PRIO) {
 		queue_expired(p, rq);
 		return;
@@ -907,7 +911,7 @@ static inline int normal_prio(struct tas
 	if (has_rt_policy(p))
 		return MAX_RT_PRIO-1 - p->rt_priority;
 	/* Other tasks all have normal_prio set in recalc_task_prio */
-	if (likely(p->prio >= MAX_RT_PRIO))
+	if (likely(p->prio >= MAX_RT_PRIO && p->prio < MAX_PRIO))
 		return p->prio;
 	else
 		return p->static_prio;
@@ -942,10 +946,10 @@ static int effective_prio(struct task_st
  */
 static unsigned int rr_quota(struct task_struct *p)
 {
-	int neg_nice = -TASK_NICE(p), rr = rr_interval;
+	int nice = TASK_NICE(p), rr = rr_interval;
 
-	if (neg_nice > 6 && !rt_task(p)) {
-		rr *= neg_nice * neg_nice;
+	if (nice < -6 && !rt_task(p)) {
+		rr *= nice * nice;
 		rr /= 40;
 	}
 	return rr;
@@ -1583,7 +1587,7 @@ int fastcall wake_up_state(struct task_s
 	return try_to_wake_up(p, state, 0);
 }
 
-static void task_running_tick(struct rq *rq, struct task_struct *p);
+static void task_running_tick(struct rq *rq, struct task_struct *p, int tick);
 /*
  * Perform scheduler related setup for a newly forked process p.
  * p is forked by current.
@@ -1645,7 +1649,7 @@ void fastcall sched_fork(struct task_str
 		 * a problem.
 		 */
 		current->time_slice = 1;
-		task_running_tick(cpu_rq(cpu), current);
+		task_running_tick(cpu_rq(cpu), current, 0);
 	}
 	local_irq_enable();
 out:
@@ -1720,14 +1724,16 @@ void fastcall wake_up_new_task(struct ta
  */
 void fastcall sched_exit(struct task_struct *p)
 {
+	struct task_struct *parent;
 	unsigned long flags;
 	struct rq *rq;
 
-	rq = task_rq_lock(p->parent, &flags);
-	if (p->first_time_slice && task_cpu(p) == task_cpu(p->parent)) {
-		p->parent->time_slice += p->time_slice;
-		if (unlikely(p->parent->time_slice > p->quota))
-			p->parent->time_slice = p->quota;
+	parent = p->parent;
+	rq = task_rq_lock(parent, &flags);
+	if (p->first_time_slice && task_cpu(p) == task_cpu(parent)) {
+		parent->time_slice += p->time_slice;
+		if (unlikely(parent->time_slice > parent->quota))
+			parent->time_slice = parent->quota;
 	}
 	task_rq_unlock(rq, &flags);
 }
@@ -3372,7 +3378,7 @@ static inline void rotate_runqueue_prior
 	rq_quota(rq, new_prio_level) += 1;
 }
 
-static void task_running_tick(struct rq *rq, struct task_struct *p)
+static void task_running_tick(struct rq *rq, struct task_struct *p, int tick)
 {
 	if (unlikely(!task_queued(p))) {
 		/* Task has expired but was not scheduled yet */
@@ -3395,6 +3401,13 @@ static void task_running_tick(struct rq 
 	if (!--p->time_slice)
 		task_expired_entitlement(rq, p);
 	/*
+	 * If we're actually calling this function not in a scheduler_tick
+	 * we are doing so to fix accounting across fork and should not be
+	 * deducting anything from rq_quota.
+	 */
+	if (!tick)
+		goto out_unlock;
+	/*
 	 * We only employ the deadline mechanism if we run over the quota.
 	 * It allows aliasing problems around the scheduler_tick to be
 	 * less harmful.
@@ -3405,6 +3418,7 @@ static void task_running_tick(struct rq 
 		rotate_runqueue_priority(rq);
 		set_tsk_need_resched(p);
 	}
+out_unlock:
 	spin_unlock(&rq->lock);
 }
 
@@ -3423,7 +3437,7 @@ void scheduler_tick(void)
 	update_cpu_clock(p, rq, now);
 
 	if (!idle_at_tick)
-		task_running_tick(rq, p);
+		task_running_tick(rq, p, 1);
 #ifdef CONFIG_SMP
 	update_load(rq);
 	rq->idle_at_tick = idle_at_tick;
@@ -3469,20 +3483,13 @@ EXPORT_SYMBOL(sub_preempt_count);
 
 #endif
 
-/* Is a dynamic_prio part of the allocated slots for this static_prio */
-static inline int entitled_slot(int static_prio, int dynamic_prio)
-{
-	return !test_bit(USER_PRIO(dynamic_prio),
-		prio_matrix[USER_PRIO(static_prio)]);
-}
-
 /*
  * If a task is queued at a priority that isn't from its bitmap we exchange
  * by setting one of the entitlement bits.
  */
-static inline void exchange_slot(struct task_struct *p, int prio)
+static inline void exchange_slot(struct task_struct *p, struct rq *rq)
 {
-	int slot = next_prio_slot(p, prio);
+	int slot = next_entitled_slot(p, rq);
 
 	if (slot < MAX_PRIO)
 		__set_bit(USER_PRIO(slot), p->bitmap);
@@ -3524,6 +3531,7 @@ retry:
 	}
 	queue = array->queue + idx;
 	next = list_entry(queue->next, struct task_struct, run_list);
+	rq->prio_level = idx;
 	/*
 	 * When the task is chosen it is checked to see if its quota has been
 	 * added to this runqueue level which is only performed once per
@@ -3533,17 +3541,16 @@ retry:
 			/* Task has moved during major rotation */
 			task_new_array(next, rq);
 			if (!entitled_slot(next->static_prio, idx))
-				exchange_slot(next, idx);
+				exchange_slot(next, rq);
 			set_task_entitlement(next);
 			rq_quota(rq, idx) += next->quota;
 	} else if (!test_bit(USER_PRIO(idx), next->bitmap)) {
 			/* Task has moved during minor rotation */
 			if (!entitled_slot(next->static_prio, idx))
-				exchange_slot(next, idx);
+				exchange_slot(next, rq);
 			set_task_entitlement(next);
 			rq_quota(rq, idx) += next->quota;
 	}
-	rq->prio_level = idx;
 	/*
 	 * next needs to have its prio and array reset here in case the
 	 * values are wrong due to priority rotation.
@@ -3632,8 +3639,11 @@ need_resched_nonpreemptible:
 		next = list_entry(queue->next, struct task_struct, run_list);
 	}
 switch_tasks:
-	if (next == rq->idle)
+	if (next == rq->idle) {
+		rq->prio_level = MAX_RT_PRIO;
+		rq->prio_rotation++;
 		schedstat_inc(rq, sched_goidle);
+	}
 	prefetch(next);
 	prefetch_stack(next);
 	clear_tsk_need_resched(prev);
Index: linux-2.6.21-rc4-mm1/kernel/sysctl.c
===================================================================
--- linux-2.6.21-rc4-mm1.orig/kernel/sysctl.c	2007-03-21 20:53:50.000000000 +1100
+++ linux-2.6.21-rc4-mm1/kernel/sysctl.c	2007-03-21 20:56:16.000000000 +1100
@@ -79,6 +79,7 @@ extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
 extern int print_fatal_signals;
+extern int rr_interval;
 
 #if defined(CONFIG_ADAPTIVE_READAHEAD)
 extern int readahead_ratio;
@@ -167,6 +168,13 @@ int sysctl_legacy_va_layout;
 #endif
 
 
+/* Constants for minimum and maximum testing in vm_table.
+   We use these as one-element integer vectors. */
+static int  __read_mostly zero;
+static int  __read_mostly one = 1;
+static int  __read_mostly one_hundred = 100;
+
+
 /* The default sysctl tables: */
 
 static ctl_table root_table[] = {
@@ -515,6 +523,17 @@ static ctl_table kern_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rr_interval",
+		.data		= &rr_interval,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &one_hundred,
+	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
 		.ctl_name       = KERN_UNKNOWN_NMI_PANIC,
@@ -631,12 +650,6 @@ static ctl_table kern_table[] = {
 	{ .ctl_name = 0 }
 };
 
-/* Constants for minimum and maximum testing in vm_table.
-   We use these as one-element integer vectors. */
-static int zero;
-static int one_hundred = 100;
-
-
 static ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,

-- 
-ck
