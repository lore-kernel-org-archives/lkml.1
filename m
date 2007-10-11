Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbXJKWOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbXJKWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 18:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXJKWNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 18:13:33 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:45363
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758815AbXJKWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 18:13:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 5/7] RT: CPU priority management
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>
Date: Thu, 11 Oct 2007 18:00:10 -0400
Message-ID: <20071011220009.27097.18770.stgit@novell1.haskins.net>
In-Reply-To: <20071011213916.27097.42597.stgit@novell1.haskins.net>
References: <20071011213916.27097.42597.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
  as:  seqlocks, per_cpu data to avoid cacheline contention, avoiding locks
  in the update code when possible, etc.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/cpupri.h |   25 +++++
 kernel/Kconfig.preempt |   11 ++
 kernel/Makefile        |    1 
 kernel/cpupri.c        |  220 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched.c         |   36 ++++++++
 5 files changed, 293 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpupri.h b/include/linux/cpupri.h
new file mode 100644
index 0000000..1ca5007
--- /dev/null
+++ b/include/linux/cpupri.h
@@ -0,0 +1,25 @@
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
+void cpupri_set(int cpu, int pri);
+int cpupri_get(int cpu);
+void cpupri_init(void);
+#else
+#define cpupri_find_best(cpu, pri, tsk) cpu
+#define cpupri_set(cpu, pri)            do { } while(0)
+#define cpupri_get(cpu)                 CPUPRI_INVALID
+#define cpupri_init()                   do { } while(0)
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
index 0000000..46a8758
--- /dev/null
+++ b/kernel/cpupri.c
@@ -0,0 +1,220 @@
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
+ *  as:  seqlocks, per_cpu data to avoid cacheline contention, avoiding locks
+ *  in the update code when possible, etc.
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
+	raw_seqlock_t lock;
+	cpumask_t     pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long          pri_active[CPUPRI_NR_PRIORITIES/BITS_PER_LONG];
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
+int cpupri_find_best(int def_cpu, int task_pri, struct task_struct *p)
+{
+	int                  idx      = 0;
+	struct cpu_priority *cp       = &cpu_priority;
+	int                  this_cpu = smp_processor_id();
+	int                  cpu      = def_cpu;
+	unsigned long        seq;
+
+	do {
+		seq = read_seqbegin(&cp->lock);
+
+		for_each_cpupri_active(cp->pri_active, idx) {
+			cpumask_t mask;
+			int       lowest_pri = idx-1;
+			
+			if (lowest_pri > task_pri)
+				break;
+			
+			cpus_and(mask, p->cpus_allowed, cp->pri_to_cpu[idx]);
+			
+			if (!cpus_empty(mask)) {
+				/*
+				 * We select a CPU in the following priority:
+				 *
+				 *       def_cpu, this_cpu, first_cpu
+				 *
+				 * for efficiency.  def_cpu preserves cache
+				 * affinity, and this_cpu is cheaper to preempt
+				 * (note that sometimes they are the same).
+				 * Finally, we will take whatever is available
+				 * if the first two don't pan out.
+				 */
+				if (cpu_isset(def_cpu, mask))
+					break;
+				
+				if (cpu_isset(this_cpu, mask)) {
+					cpu = this_cpu;
+					break;
+				}
+
+				cpu = first_cpu(mask);
+				break;
+			}
+		}
+	} while (unlikely(read_seqretry(&cp->lock, seq)));
+
+	return cpu;
+}
+
+/**
+ * cpupri_set - update the cpu priority setting
+ * @cpu: The target cpu
+ * @pri: The priority (INVALID-RT99) to assign to this CPU
+ *
+ * Note: Assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpupri_set(int cpu, int pri)
+{
+	struct cpu_priority *cp   = &cpu_priority;
+	int                 *cpri = &per_cpu(cpu_to_pri, cpu);
+
+	/*
+	 * Its safe to check the CPU priority outside the seqlock because 
+	 * it can only be modified while holding the rq->lock for this cpu
+	 */
+	if (*cpri != pri) {
+		int           oldpri = *cpri;
+		unsigned long flags;
+		
+		write_seqlock_irqsave(&cp->lock, flags);
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
+		write_sequnlock_irqrestore(&cp->lock, flags);
+
+		*cpri = pri;
+	}
+}
+
+/**
+ * cpupri_get - read the current cpu priority setting
+ * @cpu: The target cpu
+ *
+ * Note: Assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (int)pri - The current priority of this cpu
+ */
+int cpupri_get(int cpu)
+{
+	return per_cpu(cpu_to_pri, cpu);
+}
+
+#if 0
+static int cpupri_idle(struct notifier_block *b, unsigned long event, void *v)
+{
+	// FIXME: We now need to hold the rq->lock before calling!
+	if (event == IDLE_START)
+		cpupri_set(raw_smp_processor_id(), CPUPRI_IDLE);
+
+	return 0;
+}
+
+static struct notifier_block cpupri_idle_notifier = {
+	.notifier_call = cpupri_idle
+};
+#endif
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
+y	memset(cp, 0, sizeof(*cp));
+
+	raw_seqlock_init(&cp->lock);
+
+	for_each_possible_cpu(i) {
+		per_cpu(cpu_to_pri, i) = CPUPRI_INVALID;
+	}
+
+	// idle_notifier_register(&cpupri_idle_notifier);
+}
+
+
diff --git a/kernel/sched.c b/kernel/sched.c
index 41b0e9c..0065551 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -64,6 +64,7 @@
 #include <linux/delayacct.h>
 #include <linux/reciprocal_div.h>
 #include <linux/unistd.h>
+#include <linux/cpupri.h>
 
 #include <asm/tlb.h>
 
@@ -474,6 +475,37 @@ static inline void set_task_cfs_rq(struct task_struct *p)
 }
 #endif
 
+static int calc_task_cpupri(struct rq *rq, struct task_struct *p)
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
+#ifdef CONFIG_CPU_PRIORITIES
+static void set_cpupri(struct rq *rq, struct task_struct *p)
+{
+	int pri = calc_task_cpupri(rq, p);
+	cpupri_set(rq->cpu, pri);
+}
+
+static int get_cpupri(struct rq *rq)
+{
+	return cpupri_get(rq->cpu);
+}
+
+#else
+#define set_cpupri(rq, task) do { } while (0)
+#define get_cpupri(rq)         CPUPRI_INVALID
+#endif
+
 /*
  * We really dont want to do anything complex within switch_to()
  * on PREEMPT_RT - this check enforces this.
@@ -2259,6 +2291,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
 	fire_sched_out_preempt_notifiers(prev, next);
 	prepare_lock_switch(rq, next);
 	prepare_arch_switch(next);
+	set_cpupri(rq, next);
 }
 
 /**
@@ -4603,6 +4636,7 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 		 * this runqueue and our priority is higher than the current's
 		 */
 		if (task_running(rq, p)) {
+			set_cpupri(rq, p);
 			if (p->prio > oldprio)
 				resched_task(rq->curr);
 		} else {
@@ -7290,6 +7324,8 @@ void __init sched_init(void)
 	int highest_cpu = 0;
 	int i, j;
 
+	cpupri_init();
+
 	/*
 	 * Link up the scheduling class hierarchy:
 	 */

