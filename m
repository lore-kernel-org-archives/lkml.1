Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbXKFAw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbXKFAw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXKFAui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:50:38 -0500
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:25186 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755528AbXKFAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:50:33 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 8/8] RT: Use a 2-d bitmap for searching lowest-pri CPU
To: rostedt@goodmis.org
Cc: mingo@elte.hu, dvhltc@us.ibm.com, zijlstra@redhat.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       ghaskins@novell.com
Date: Mon, 05 Nov 2007 16:49:13 -0700
Message-ID: <20071105234913.25451.32622.stgit@lsg>
In-Reply-To: <20071105234832.25451.55430.stgit@lsg>
References: <20071105234832.25451.55430.stgit@lsg>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The current code use a linear algorithm which causes scaling issues
on larger SMP machines.  This patch replaces that algorithm with a
2-dimensional bitmap to reduce latencies in the wake-up path.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/Makefile       |    1 
 kernel/sched.c        |    4 +
 kernel/sched_cpupri.c |  186 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_cpupri.h |   10 +++
 kernel/sched_rt.c     |   52 ++------------
 5 files changed, 210 insertions(+), 43 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index e4e2acf..a822706 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-$(CONFIG_SMP) += sched_cpupri.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff --git a/kernel/sched.c b/kernel/sched.c
index 0eced8c..6f24aa0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -70,6 +70,8 @@
 
 #include <asm/tlb.h>
 
+#include "sched_cpupri.h"
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
@@ -6842,6 +6844,8 @@ void __init sched_init(void)
 	fair_sched_class.next = &idle_sched_class;
 	idle_sched_class.next = NULL;
 
+	cpupri_init();
+
 	for_each_possible_cpu(i) {
 		struct rt_prio_array *array;
 		struct rq *rq;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
new file mode 100644
index 0000000..e6280b1
--- /dev/null
+++ b/kernel/sched_cpupri.c
@@ -0,0 +1,186 @@
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
+ *  worst case complexity of O(min(102, NR_CPUS)), though the scenario that
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
+#define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
+#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
+
+#define CPUPRI_INVALID -1
+#define CPUPRI_IDLE     0
+#define CPUPRI_NORMAL   1
+/* values 2-101 are RT priorities 0-99 */
+
+struct pri_vec
+{
+	raw_spinlock_t lock;
+	cpumask_t      mask;
+};
+
+struct cpu_priority {
+	struct pri_vec pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long           pri_active[CPUPRI_NR_PRI_WORDS];
+	int            cpu_to_pri[NR_CPUS];
+};
+
+static __cacheline_aligned_in_smp struct cpu_priority cpu_priority;
+
+/* Convert between a 140 based task->prio, and our 102 based cpupri */
+static int convert_prio(int prio)
+{
+	int cpupri;
+
+	if (prio == MAX_PRIO)
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
+int cpupri_find(struct task_struct *p, cpumask_t *lowest_mask)
+{
+	int                  idx      = 0;
+	struct cpu_priority *cp       = &cpu_priority;
+	int                  task_pri = convert_prio(p->prio);
+
+	for_each_cpupri_active(cp->pri_active, idx) {
+		struct pri_vec *vec  = &cp->pri_to_cpu[idx];
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
+ * @cpu: The target cpu
+ * @pri: The priority (INVALID-RT99) to assign to this CPU
+ *
+ * Note: Assumes cpu_rq(cpu)->lock is locked
+ *
+ * Returns: (void)
+ */
+void cpupri_set(int cpu, int newpri)
+{
+	struct cpu_priority *cp      = &cpu_priority;
+	int                 *currpri = &cp->cpu_to_pri[cpu];
+	int                  oldpri  = *currpri;
+	unsigned long        flags;
+
+	newpri = convert_prio(newpri);
+
+	if (newpri == oldpri)
+		return;
+
+	/*
+	 * If the cpu was currently mapped to a different value, we
+	 * first need to unmap the old value
+	 */
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		struct pri_vec *vec  = &cp->pri_to_cpu[oldpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		cpu_clear(cpu, vec->mask);
+		if (cpus_empty(vec->mask))
+			clear_bit(oldpri, cp->pri_active);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	if (likely(newpri != CPUPRI_INVALID)) {
+		struct pri_vec *vec = &cp->pri_to_cpu[newpri];
+
+		spin_lock_irqsave(&vec->lock, flags);
+
+		cpu_set(cpu, vec->mask);
+		set_bit(newpri, cp->pri_active);
+
+		spin_unlock_irqrestore(&vec->lock, flags);
+	}
+
+	*currpri = newpri;
+}
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
+	memset(cp, 0, sizeof(*cp));
+
+	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
+		spin_lock_init(&cp->pri_to_cpu[i].lock);
+
+	for_each_possible_cpu(i)
+		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+}
+
+
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
new file mode 100644
index 0000000..8cdd15d
--- /dev/null
+++ b/kernel/sched_cpupri.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_CPUPRI_H
+#define _LINUX_CPUPRI_H
+
+#include <linux/sched.h>
+
+int  cpupri_find(struct task_struct *p, cpumask_t *lowest_mask);
+void cpupri_set(int cpu, int pri);
+void cpupri_init(void);
+
+#endif /* _LINUX_CPUPRI_H */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 698f4d9..71ae9e6 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -72,8 +72,10 @@ static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
 	WARN_ON(!rt_task(p));
 	rq->rt.rt_nr_running++;
 #ifdef CONFIG_SMP
-	if (p->prio < rq->rt.highest_prio)
+	if (p->prio < rq->rt.highest_prio) {
 		rq->rt.highest_prio = p->prio;
+		cpupri_set(rq->cpu, p->prio);
+	}
 	if (p->nr_cpus_allowed > 1)
 		rq->rt.rt_nr_migratory++;
 
@@ -96,6 +98,7 @@ static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
 			array = &rq->rt.active;
 			rq->rt.highest_prio =
 				sched_find_first_bit(array->bitmap);
+			cpupri_set(rq->cpu, rq->rt.highest_prio);
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
@@ -333,46 +336,6 @@ static struct task_struct *pick_next_highest_task_rt(struct rq *rq,
 	return next;
 }
 
-static int find_lowest_cpus(struct task_struct *task, cpumask_t *lowest_mask)
-{
-	int       cpu;
-	cpumask_t valid_mask;
-	int       lowest_prio = -1;
-	int       ret         = 0;
-
-	cpus_clear(*lowest_mask);
-	cpus_and(valid_mask, cpu_online_map, task->cpus_allowed);
-
-	/*
-	 * Scan each rq for the lowest prio.
-	 */
-	for_each_cpu_mask(cpu, valid_mask) {
-		struct rq *rq = cpu_rq(cpu);
-
-		/* We look for lowest RT prio or non-rt CPU */
-		if (rq->rt.highest_prio >= MAX_RT_PRIO) {
-			if (ret)
-				cpus_clear(*lowest_mask);
-			cpu_set(rq->cpu, *lowest_mask);
-			return 1;
-		}
-
-		/* no locking for now */
-		if ((rq->rt.highest_prio > task->prio)
-		    && (rq->rt.highest_prio >= lowest_prio)) {
-			if (rq->rt.highest_prio > lowest_prio) {
-				/* new low - clear old data */
-				lowest_prio = rq->rt.highest_prio;
-				cpus_clear(*lowest_mask);
-			}
-			cpu_set(rq->cpu, *lowest_mask);
-			ret = 1;
-		}
-	}
-
-	return ret;
-}
-
 static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
 {
 	int first;
@@ -394,9 +357,12 @@ static int find_lowest_rq(struct task_struct *task)
 	cpumask_t lowest_mask;
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	
+	if (task->nr_cpus_allowed == 1)
+		return -1; /* No other targets possible */
 
-	if (!find_lowest_cpus(task, &lowest_mask))
-		return -1;
+	if (!cpupri_find(task, &lowest_mask))
+		return -1; /* No better targets found */
 
 	/*
 	 * At this point we have built a mask of cpus representing the

