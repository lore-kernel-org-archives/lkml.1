Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXLEDSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXLEDSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 22:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXLEDRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 22:17:43 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:46992
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753465AbXLEDRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 22:17:40 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 3/3] Subject: SCHED - Use a 2-d bitmap for searching
	lowest-pri CPU
To: mingo@elte.hu
Cc: rostedt@goodmis.org, ghaskins@novell.com, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2007 21:55:38 -0500
Message-ID: <20071205025538.4494.52380.stgit@novell1.haskins.net>
In-Reply-To: <20071205025137.4494.18683.stgit@novell1.haskins.net>
References: <20071205025137.4494.18683.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code use a linear algorithm which causes scaling issues
on larger SMP machines.  This patch replaces that algorithm with a
2-dimensional bitmap to reduce latencies in the wake-up path.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
CC: Christoph Lameter <clameter@sgi.com>
---

 kernel/Kconfig.preempt |   11 +++
 kernel/Makefile        |    1 
 kernel/sched.c         |    8 ++
 kernel/sched_cpupri.c  |  174 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_cpupri.h  |   37 ++++++++++
 kernel/sched_rt.c      |   36 +++++++++-
 6 files changed, 265 insertions(+), 2 deletions(-)

diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index c64ce9c..f78ab80 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -63,3 +63,14 @@ config PREEMPT_BKL
 	  Say Y here if you are building a kernel for a desktop system.
 	  Say N if you are unsure.
 
+config CPUPRI
+	bool "Optimize lowest-priority search"
+	depends on SMP && EXPERIMENTAL
+	default n
+	help
+	  This option attempts to reduce latency in the kernel by replacing
+          the linear lowest-priority search algorithm with a 2-d bitmap.
+
+	  Say Y here if you want to try this experimental algorithm.
+	  Say N if you are unsure.
+
diff --git a/kernel/Makefile b/kernel/Makefile
index dfa9695..78a385e 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_MARKERS) += marker.o
+obj-$(CONFIG_CPUPRI) += sched_cpupri.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a09f82..1c173c1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -69,6 +69,8 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 
+#include "sched_cpupri.h"
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
@@ -374,6 +376,9 @@ struct root_domain {
 	 */
 	cpumask_t rto_mask;
 	atomic_t  rto_count;
+#ifdef CONFIG_CPUPRI
+	struct cpupri cpupri;
+#endif
 };
 
 static struct root_domain def_root_domain;
@@ -5860,6 +5865,9 @@ static void init_rootdomain(struct root_domain *rd, const cpumask_t *map)
 
 	rd->span = *map;
 	cpus_and(rd->online, rd->span, cpu_online_map);
+#ifdef CONFIG_CPUPRI
+	cpupri_init(&rd->cpupri);
+#endif
 }
 
 static void init_defrootdomain(void)
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
new file mode 100644
index 0000000..78e069e
--- /dev/null
+++ b/kernel/sched_cpupri.c
@@ -0,0 +1,174 @@
+/*
+ *  kernel/sched_cpupri.c
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
+ *  worst case complexity of O(min(102, nr_domcpus)), though the scenario that
+ *  yields the worst case search is fairly contrived.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; version 2
+ *  of the License.
+ */
+
+#include "sched_cpupri.h"
+
+/* Convert between a 140 based task->prio, and our 102 based cpupri */
+static int convert_prio(int prio)
+{
+	int cpupri;
+
+	if (prio == CPUPRI_INVALID)
+		cpupri = CPUPRI_INVALID;
+	else if (prio == MAX_PRIO)
+		cpupri = CPUPRI_IDLE;
+	else if (prio >= MAX_RT_PRIO)
+		cpupri = CPUPRI_NORMAL;
+	else
+		cpupri = MAX_RT_PRIO - prio + 1;
+
+	return cpupri;
+}
+
+#define for_each_cpupri_active(array, idx)                    \
+  for (idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);     \
+       idx < CPUPRI_NR_PRIORITIES;                            \
+       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+
+/**
+ * cpupri_find - find the best (lowest-pri) CPU in the system
+ * @cp: The cpupri context
+ * @p: The task
+ * @lowest_mask: A mask to fill in with selected CPUs
+ *
+ * Note: This function returns the recommended CPUs as calculated during the
+ * current invokation.  By the time the call returns, the CPUs may have in
+ * fact changed priorities any number of times.  While not ideal, it is not
+ * an issue of correctness since the normal rebalancer logic will correct
+ * any discrepancies created by racing against the uncertainty of the current
+ * priority configuration.
+ *
+ * Returns: (int)bool - CPUs were found
+ */
+int cpupri_find(struct cpupri *cp, struct task_struct *p,
+		cpumask_t *lowest_mask)
+{
+	int                  idx      = 0;
+	int                  task_pri = convert_prio(p->prio);
+
+	for_each_cpupri_active(cp->pri_active, idx) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
+		cpumask_t mask;
+
+		if (idx >= task_pri)
+			break;
+
+		cpus_and(mask, p->cpus_allowed, vec->mask);
+
+		if (cpus_empty(mask))
+			continue;
+
+		*lowest_mask = mask;
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * cpupri_set - update the cpu priority setting
+ * @cp: The cpupri context
+ * @cpu: The target cpu
+ * @pri: The priority (INVALID-RT99) to assign to this CPU
+ *
+ * Note: Assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpupri_set(struct cpupri *cp, int cpu, int newpri)
+{
+	int                 *currpri = &cp->cpu_to_pri[cpu];
+	int                  oldpri  = *currpri;
+	unsigned long        flags;
+
+	newpri = convert_prio(newpri);
+
+	BUG_ON(newpri >= CPUPRI_NR_PRIORITIES);
+
+	if (newpri == oldpri)
+		return;
+
+	/*
+	 * If the cpu was currently mapped to a different value, we
+	 * first need to unmap the old value
+	 */
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		cpu_clear(cpu, vec->mask);
+		vec->count--;
+		if (!vec->count)
+			clear_bit(oldpri, cp->pri_active);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	if (likely(newpri != CPUPRI_INVALID)) {
+		struct cpupri_vec *vec = &cp->pri_to_cpu[newpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		cpu_set(cpu, vec->mask);
+		vec->count++;
+		if (vec->count == 1)
+			set_bit(newpri, cp->pri_active);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	*currpri = newpri;
+}
+
+/**
+ * cpupri_init - initialize the cpupri structure
+ * @cp: The cpupri context
+ *
+ * Returns: (void)
+ */
+void cpupri_init(struct cpupri *cp)
+{
+	int i;
+
+	memset(cp, 0, sizeof(*cp));
+
+	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++) {
+		struct cpupri_vec *vec = &cp->pri_to_cpu[i];
+
+		spin_lock_init(&vec->lock);
+		vec->count = 0;
+		cpus_clear(vec->mask);
+	}
+
+	for_each_possible_cpu(i)
+		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+}
+
+
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
new file mode 100644
index 0000000..7e62008
--- /dev/null
+++ b/kernel/sched_cpupri.h
@@ -0,0 +1,37 @@
+#ifndef _LINUX_CPUPRI_H
+#define _LINUX_CPUPRI_H
+
+#include <linux/sched.h>
+
+#define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
+#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
+
+#define CPUPRI_INVALID -1
+#define CPUPRI_IDLE     0
+#define CPUPRI_NORMAL   1
+/* values 2-101 are RT priorities 0-99 */
+
+struct cpupri_vec
+{
+	spinlock_t lock;
+	int        count;
+	cpumask_t  mask;
+};
+
+struct cpupri {
+	struct cpupri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long              pri_active[CPUPRI_NR_PRI_WORDS];
+	int               cpu_to_pri[NR_CPUS];
+};
+
+#ifdef CONFIG_CPUPRI
+int  cpupri_find(struct cpupri *cp,
+		 struct task_struct *p, cpumask_t *lowest_mask);
+void cpupri_set(struct cpupri *cp, int cpu, int pri);
+void cpupri_init(struct cpupri *cp);
+#else
+#define cpupri_set(cp, cpu, pri) do { } while (0)
+#define cpupri_init() do { } while (0)
+#endif
+
+#endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f9728d0..0fe22ea 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -71,8 +71,10 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 	WARN_ON(!rt_task(p));
 	rq->rt.rt_nr_running++;
 #ifdef CONFIG_SMP
-	if (p->prio < rq->rt.highest_prio)
+	if (p->prio < rq->rt.highest_prio) {
 		rq->rt.highest_prio = p->prio;
+		cpupri_set(&rq->rd->cpupri, rq->cpu, p->prio);
+	}
 	if (p->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory++;
 
@@ -82,6 +84,8 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 
 static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 {
+	int highest_prio = rq->rt.highest_prio;
+
 	WARN_ON(!rt_task(p));
 	WARN_ON(!rq->rt.rt_nr_running);
 	rq->rt.rt_nr_running--;
@@ -101,6 +105,9 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 	if (p->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory--;
 
+	if (rq->rt.highest_prio != highest_prio)
+		cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
+
 	update_rt_migration(rq);
 #endif /* CONFIG_SMP */
 }
@@ -293,6 +300,7 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 
 static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
 
+#ifndef CONFIG_CPUPRI
 static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 {
 	int       lowest_prio = -1;
@@ -359,6 +367,22 @@ static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
 
 	return count;
 }
+#else
+static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
+{
+	int count;
+
+	count = cpupri_find(&task_rq(task)->rd->cpupri, task, lowest_mask);
+
+	/*
+	 * cpupri cannot efficiently tell us how many bits are set, so it only
+	 * returns a boolean.  However, the caller of this function will
+	 * special case the value "1", so we want to return a positive integer
+	 * other than one if there are bits to look at
+	 */
+	return count ? 2 : 0;
+}
+#endif
 
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
@@ -381,8 +405,12 @@ static int find_lowest_rq(struct task_struct *task)
 	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
-	int count    = find_lowest_cpus(task, lowest_mask);
+	int count;
 
+	if (task->nr_cpus_allowed == 1)
+		return -1; /* No other targets possible */
+
+	count = find_lowest_cpus(task, lowest_mask);
 	if (!count)
 		return -1; /* No targets found */
 
@@ -802,6 +830,8 @@ static void join_domain_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, rq->rt.highest_prio);
 }
 
 /* Assumes rq->lock is held */
@@ -809,6 +839,8 @@ static void leave_domain_rt(struct rq *rq)
 {
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
+
+	cpupri_set(&rq->rd->cpupri, rq->cpu, CPUPRI_INVALID);
 }
 
 static void set_curr_task_rt(struct rq *rq)

