Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbXJIPgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbXJIPgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 11:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXJIPgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 11:36:15 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:42997 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXJIPgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 11:36:14 -0400
Subject: Re: [PATCH 0/5] RT: scheduler fixes and rt_overload enhancements
From: Gregory Haskins <ghaskins@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, kravetz@us.ibm.com,
       LKML <linux-kernel@vger.kernel.org>, pmorreale@novell.com,
       sdietrich@novell.com, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com>
References: <20071009142044.4941.65189.stgit@novell1.haskins.net>
	 <Pine.LNX.4.58.0710091054430.21404@gandalf.stny.rr.com>
Content-Type: multipart/mixed; boundary="=-tEkFadhTPzvuNQj781z8"
Date: Tue, 09 Oct 2007 11:33:44 -0400
Message-Id: <1191944024.4281.72.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tEkFadhTPzvuNQj781z8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-10-09 at 11:00 -0400, Steven Rostedt wrote:
> 

Hi Steve, Peter,


> --
> On Tue, 9 Oct 2007, Gregory Haskins wrote:
> > Hi All,
> 
> Hi Gregory,
> 
> >
> > The first two patches are from Mike and Steven on LKML, which the rest of my
> > series is dependent on.  Patch #4 is a resend from earlier.
> >
> > Series Summary:
> >
> > 1) Send IPI on overload regardless of whether prev is an RT task
> 
> OK.
> 
> > 2) Set the NEEDS_RESCHED flag on reception of RESCHED_IPI
> 
> Peter Zijlstra and I have been discussing this IPI Resched change a bit.
> It seems that it is too much overkill for what is needed. That is, the
> send_reschedule is used elsewhere where we do not want to actually do a
> schedule.

That is a good point.  We definitely need a good "kick+resched" kind of
mechanism here, but perhaps it should be RTO specific instead of in the
primary data path.  I guess a rq-lock + set(NEEDS_RESCHED) + IPI works
too.

On the flip side:  Perhaps sending a reschedule-ipi that doesn't
reschedule is simply misused, and the misuse should be cleaned up
instead? 

> 
> I'm thinking about trying out a method that each rq has the priority of
> the current task that is running. On case where we get an rt overload
> (like in the finish_task_switch) we do a scan of all CPUS (not taking any
> locks) and find the CPU which the lowest priority. If that CPU has a lower
> prioirty than a waiting task to run on the current CPU then we grab the
> lock for that rq, check to see if the priority is still lower, and then
> push the rt task over to that CPU.

Great minds think alike ;)  See attached for a patch I have been working
on in this area.  It currently address the "wake_up" path.  It would
also need to address the "preempted" path if we were to eliminate RTO
outright.

I wasn't going to share it quite yet, since its still a work in
progress.  But the timing seems right now, given the discussion.

> 
> If after taking the rq lock a schedule had taken place and a higher RT
> task is running, then we would try again, two more times. If this
> phenomenon happens two more times, we punt and wouldn't do anything else
> (paranoid attempt to fall into trying over and over on a high context
> switch RT system).

My patch currently doesn't address this yet, but I have been thinking
about it for the last day or so.  I was wondering if perhaps an RCU
would be appropriate instead of the rwlock like I am using.

> 
> 
> > 3) Fix a mistargeted IPI on overload
> > 4) Track which CPUS are in overload for efficiency
> > 5) Track which CPUs are eligible for rebalancing for efficiency
> 
> The above three may be obsoleted by this new algorithm.

On the same page with you, here.

Regards,
-Greg 




--=-tEkFadhTPzvuNQj781z8
Content-Disposition: attachment; filename=cpu_priority.patch
Content-Type: text/x-patch; name=cpu_priority.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

SCHED: CPU priority management

From: Gregory Haskins <ghaskins@novell.com>

This code tracks the priority of each CPU so that global migration
  decisions are easy to calculate.  Each CPU can be in a state as follows:

                 (INVALID), IDLE, NORMAL, RT1, ... RT99

  going from the lowest priority to the highest.  CPUs in the INVALID state
  are not eligible for routing.  The system maintains this state with
  a 2 dimensional bitmap (the first for priority class, the second for cpus
  in that class).  Therefore a typical application without affinity
  restrictions can find a suitable CPU with O(1) complexity (e.g. two bit
  searches).  For tasks with affinity restrictions, the algorithm has a
  worst case complexity of O(min(102, NR_CPUS)), though the scenario that
  yields the worst case search is fairly contrived.

  Because this type of data structure is going to be cache/lock hot,
  certain design considerations were made to mitigate this overhead, such
  as:  rwlocks, per_cpu data to avoid cacheline contention, avoiding locks
  in the update code when possible, etc.

  This logic can really be seen as a superset of the wake_idle()
  functionality (in fact, it replaces wake_idle() when enabled).  The
  original logic performed a similar function, but was limited to only two
  priority classifications: IDLE, and !IDLE.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/cpupri.h |   26 ++++++
 kernel/Kconfig.preempt |   11 +++
 kernel/Makefile        |    1 
 kernel/cpupri.c        |  198 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c         |   39 +++++++++
 5 files changed, 274 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpupri.h b/include/linux/cpupri.h
new file mode 100644
index 0000000..c5749db
--- /dev/null
+++ b/include/linux/cpupri.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_CPUPRI_H
+#define _LINUX_CPUPRI_H
+
+#include <linux/sched.h>
+
+#define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
+
+#define CPUPRI_INVALID -2
+#define CPUPRI_IDLE    -1
+#define CPUPRI_NORMAL   0
+/* values 1-99 are RT priorities */
+
+#ifdef CONFIG_CPU_PRIORITIES
+int cpupri_find_best(int cpu, int pri, struct task_struct *p);
+void cpupri_set(int pri);
+void cpupri_init(void);
+#else
+inline int cpupri_find_best(int cpu, struct task_struct *p)
+{
+	return cpu;
+}
+#define cpupri_set(pri) do { } while(0)
+#define cpupri_init() do { } while(0)
+#endif /* CONFIG_CPU_PRIORITIES */
+
+#endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 2316f28..5397e59 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -197,3 +197,14 @@ config RCU_TRACE
 	  Say Y here if you want to enable RCU tracing
 	  Say N if you are unsure.
 
+config CPU_PRIORITIES
+       bool "Enable CPU priority management"
+       default n
+       help
+         This option allows the scheduler to efficiently track the absolute
+	 priority of the current task on each CPU.  This helps it to make
+	 global decisions for real-time tasks before a overload conflict
+	 actually occurs.
+
+	 Say Y here if you want to enable priority management
+	 Say N if you are unsure.
\ No newline at end of file
diff --git a/kernel/Makefile b/kernel/Makefile
index e4e2acf..63aaaf5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_CPU_PRIORITIES) += cpupri.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/cpupri.c b/kernel/cpupri.c
new file mode 100644
index 0000000..c6a2e3e
--- /dev/null
+++ b/kernel/cpupri.c
@@ -0,0 +1,198 @@
+/*
+ *  kernel/cpupri.c
+ *
+ *  CPU priority management
+ *
+ *  Copyright (C) 2007 Novell
+ *
+ *  Author: Gregory Haskins <ghaskins@novell.com>
+ *
+ *  This code tracks the priority of each CPU so that global migration
+ *  decisions are easy to calculate.  Each CPU can be in a state as follows:
+ *
+ *                 (INVALID), IDLE, NORMAL, RT1, ... RT99
+ *
+ *  going from the lowest priority to the highest.  CPUs in the INVALID state
+ *  are not eligible for routing.  The system maintains this state with
+ *  a 2 dimensional bitmap (the first for priority class, the second for cpus
+ *  in that class).  Therefore a typical application without affinity
+ *  restrictions can find a suitable CPU with O(1) complexity (e.g. two bit
+ *  searches).  For tasks with affinity restrictions, the algorithm has a
+ *  worst case complexity of O(min(102, NR_CPUS)), though the scenario that
+ *  yields the worst case search is fairly contrived.
+ *
+ *  Because this type of data structure is going to be cache/lock hot,
+ *  certain design considerations were made to mitigate this overhead, such
+ *  as:  rwlocks, per_cpu data to avoid cacheline contention, avoiding locks
+ *  in the update code when possible, etc.
+ *
+ *  This logic can really be seen as a superset of the wake_idle()
+ *  functionality (in fact, it replaces wake_idle() when enabled).  The
+ *  original logic performed a similar function, but was limited to only two
+ *  priority classifications: IDLE, and !IDLE.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include <linux/cpupri.h>
+#include <asm/idle.h>
+
+struct cpu_priority {
+	raw_rwlock_t lock;
+	cpumask_t    pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long         pri_active[CPUPRI_NR_PRIORITIES/BITS_PER_LONG];
+};
+
+static DEFINE_PER_CPU(int, cpu_to_pri);
+
+static __cacheline_aligned_in_smp struct cpu_priority cpu_priority;
+
+#define for_each_cpupri_active(array, idx)                   \
+  for( idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);    \
+       idx < CPUPRI_NR_PRIORITIES;                           \
+       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+
+/**
+ * cpupri_find_best - find the best (lowest-pri) CPU in the system
+ * @cpu: The recommended/default CPU
+ * @task_pri: The priority of the task being scheduled (IDLE-RT99)
+ * @p: The task being scheduled
+ *
+ * Note: This function returns the recommeded CPU as calculated during the
+ * current invokation.  By the time the call returns, the CPUs may have in
+ * fact changed priorities any number of times.  While not ideal, it is not
+ * an issue of correctness since the normal rebalancer logic will correct
+ * any discrepancies created by racing against the uncertainty of the current
+ * priority configuration.
+ *
+ * Returns: (int)cpu - The recommended cpu to accept the task
+ */
+int cpupri_find_best(int cpu, int task_pri, struct task_struct *p)
+{
+	int                  idx      = 0;
+	struct cpu_priority *cp       = &cpu_priority;
+	unsigned long        flags;
+
+	read_lock_irqsave(&cp->lock, flags);
+
+	for_each_cpupri_active(cp->pri_active, idx) {
+		cpumask_t mask;
+		int       lowest_pri = idx-1;
+
+		if (lowest_pri > task_pri)
+			break;
+
+		cpus_and(mask, p->cpus_allowed, cp->pri_to_cpu[idx]);
+
+		/*
+		 * If the default cpu is available for this task to run on,
+		 * it wins automatically
+		 */
+		if (cpu_isset(cpu, mask))
+			break;
+
+		if (!cpus_empty(mask)) {
+			/*
+			 * Else we should pick one of the remaining elements
+			 */
+			cpu = first_cpu(mask);
+			break;
+		}
+	}
+
+	read_unlock_irqrestore(&cp->lock, flags);
+
+	return cpu;
+}
+
+/**
+ * cpupri_set - update the cpu priority setting
+ * @pri: The priority (INVALID-RT99) to assign to this CPU
+ *
+ * Returns: (void)
+ */
+void cpupri_set(int pri)
+{
+	struct cpu_priority *cp   = &cpu_priority;
+	int                  cpu  = raw_smp_processor_id();
+	int                 *cpri = &per_cpu(cpu_to_pri, cpu);
+
+	/*
+	 * Its safe to check the CPU priority outside the lock because 
+	 * it can only be modified from the processor in question
+	 */
+	if (*cpri != pri) {
+		int           oldpri = *cpri;
+		unsigned long flags;
+		
+		write_lock_irqsave(&cp->lock, flags);
+
+		/*
+		 * If the cpu was currently mapped to a different value, we
+		 * first need to unmap the old value
+		 */
+		if (likely(oldpri != CPUPRI_INVALID)) {
+			int        idx  = oldpri+1;
+			cpumask_t *mask = &cp->pri_to_cpu[idx];
+
+			cpu_clear(cpu, *mask);
+			if (cpus_empty(*mask))
+				__clear_bit(idx, cp->pri_active);
+		}
+
+		if (likely(pri != CPUPRI_INVALID)) {
+			int        idx  = pri+1;
+			cpumask_t *mask = &cp->pri_to_cpu[idx];
+
+			cpu_set(cpu, *mask);
+			__set_bit(idx, cp->pri_active);
+		}
+
+		write_unlock_irqrestore(&cp->lock, flags);
+
+		*cpri = pri;
+	}
+}
+
+static int cpupri_idle(struct notifier_block *b, unsigned long event, void *v)
+{
+	if (event == IDLE_START)
+		cpupri_set(CPUPRI_IDLE);
+
+	return 0;
+}
+
+static struct notifier_block cpupri_idle_notifier = {
+	.notifier_call = cpupri_idle
+};
+
+/**
+ * cpupri_init - initialize the cpupri subsystem
+ *
+ * This must be called during the scheduler initialization before the 
+ * other methods may be used.
+ *
+ * Returns: (void)
+ */
+void cpupri_init(void)
+{
+	struct cpu_priority *cp = &cpu_priority;
+	int i;
+
+	printk("CPU Priority Management, Copyright(c) 2007, Novell\n");
+
+	memset(cp, 0, sizeof(*cp));
+
+	rwlock_init(&cp->lock);
+
+	for_each_possible_cpu(i) {
+		per_cpu(cpu_to_pri, i) = CPUPRI_INVALID;
+	}
+
+	idle_notifier_register(&cpupri_idle_notifier);
+}
+
+
diff --git a/kernel/sched.c b/kernel/sched.c
index 6ca5f4f..0f815ad 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -24,6 +24,7 @@
  *              by Peter Williams
  *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-10-07  Cpu priorities by Greg Haskins
  */
 
 #include <linux/mm.h>
@@ -64,6 +65,7 @@
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
+#include <linux/cpupri.h>
 
 #include <asm/tlb.h>
 
@@ -1716,6 +1718,38 @@ static inline int wake_idle(int cpu, struct task_struct *p)
 }
 #endif
 
+#ifdef CONFIG_CPU_PRIORITIES
+static int cpupri_task_priority(struct rq *rq, struct task_struct *p)
+{
+	int pri;
+
+	if (rt_task(p))
+		pri = p->rt_priority;
+	else if (p == rq->idle)
+		pri = CPUPRI_IDLE;
+	else
+		pri = CPUPRI_NORMAL;
+
+	return pri;
+}
+
+static void cpupri_set_task(struct rq *rq, struct task_struct *p)
+{
+	int pri = cpupri_task_priority(rq, p);
+	cpupri_set(pri);
+}
+
+static int wake_lowest(int cpu, struct task_struct *p)
+{
+	int pri = cpupri_task_priority(cpu_rq(cpu), p);
+
+	return cpupri_find_best(cpu, pri, p);
+}
+#else
+#define cpupri_set_task(rq, task) do { } while (0)
+#define wake_lowest(cpu, task)  wake_idle(cpu, task)
+#endif
+
 /***
  * try_to_wake_up - wake up a thread
  * @p: the to-be-woken-up thread
@@ -1840,7 +1874,7 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int sync, int mutex)
 
 	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
 out_set_cpu:
-	new_cpu = wake_idle(new_cpu, p);
+	new_cpu = wake_lowest(new_cpu, p);
 	if (new_cpu != cpu) {
 		set_task_cpu(p, new_cpu);
 		task_rq_unlock(rq, &flags);
@@ -2177,6 +2211,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
+	cpupri_set_task(rq, next);
 }
 
 /**
@@ -7214,6 +7249,8 @@ void __init sched_init(void)
 	int highest_cpu = 0;
 	int i, j;
 
+	cpupri_init();
+
 	/*
 	 * Link up the scheduling class hierarchy:
 	 */

--=-tEkFadhTPzvuNQj781z8--

