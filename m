Return-Path: <linux-kernel-owner+w=401wt.eu-S1759460AbXJXOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460AbXJXOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbXJXOH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:07:58 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:49127
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759123AbXJXOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:07:55 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 8/9] RT: CPU priority management
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
Date: Wed, 24 Oct 2007 09:53:15 -0400
Message-ID: <20071024135314.7960.55011.stgit@novell1.haskins.net>
In-Reply-To: <20071024134431.7960.41984.stgit@novell1.haskins.net>
References: <20071024134431.7960.41984.stgit@novell1.haskins.net>
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

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/Makefile       |    2 
 kernel/sched.c        |   37 +++------
 kernel/sched_cpupri.c |  200 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_cpupri.h |   10 ++
 4 files changed, 222 insertions(+), 27 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index e4e2acf..d9d1351 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
-	    utsname.o
+	    utsname.o sched_cpupri.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc4389..effcb63 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -67,6 +67,8 @@
 
 #include <asm/tlb.h>
 
+#include "sched_cpupri.h"
+
 /*
  * Scheduler clock - returns current time in nanosec units.
  * This is default implementation.
@@ -384,8 +386,10 @@ static inline void update_rq_prio(struct rq *rq)
 	if ((prio != MAX_PRIO) && (prio > MAX_RT_PRIO))
 		prio = MAX_RT_PRIO;
 
-	if (rq->highest_prio != prio)
+	if (rq->highest_prio != prio) {
+		cpupri_set(rq->cpu, prio);
 		set_rq_prio(rq, prio);
+	}
 }
 
 #else
@@ -1532,36 +1536,15 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task,
 	struct rq *lowest_rq = NULL;
 	int cpu;
 	int tries;
-	cpumask_t cpu_mask;
-
-	cpus_and(cpu_mask, cpu_online_map, task->cpus_allowed);
 
 	for (tries = 0; tries < RT_PUSH_MAX_TRIES; tries++) {
-		/*
-		 * Scan each rq for the lowest prio.
-		 */
-		for_each_cpu_mask(cpu, cpu_mask) {
-			struct rq *rq = &per_cpu(runqueues, cpu);
-
-			if (cpu == this_rq->cpu)
-				continue;
+		cpu = cpupri_find(this_rq->cpu, task);
 
-			/* We look for lowest RT prio or non-rt CPU */
-			if (rq->highest_prio >= MAX_RT_PRIO) {
-				lowest_rq = rq;
-				break;
-			}
-
-			/* no locking for now */
-			if (rq->highest_prio > task->prio &&
-			    (!lowest_rq || rq->highest_prio < lowest_rq->highest_prio)) {
-				lowest_rq = rq;
-			}
-		}
-
-		if (!lowest_rq)
+		if (cpu == this_rq->cpu)
 			break;
 
+		lowest_rq = cpu_rq(cpu);
+
 		/* if the prio of this runqueue changed, try again */
 		if (double_lock_balance(this_rq, lowest_rq)) {
 			/*
@@ -7395,6 +7378,8 @@ void __init sched_init(void)
 	fair_sched_class.next = &idle_sched_class;
 	idle_sched_class.next = NULL;
 
+	cpupri_init();
+
 	for_each_possible_cpu(i) {
 		struct rt_prio_array *array;
 		struct rq *rq;
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
new file mode 100644
index 0000000..5cb51ae
--- /dev/null
+++ b/kernel/sched_cpupri.c
@@ -0,0 +1,200 @@
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
+#include <asm/idle.h>
+
+#include "sched_cpupri.h"
+
+#define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
+
+#define CPUPRI_INVALID -2
+#define CPUPRI_IDLE    -1
+#define CPUPRI_NORMAL   0
+/* values 1-99 are RT priorities */
+
+struct cpu_priority {
+	raw_spinlock_t lock;
+	cpumask_t      pri_to_cpu[CPUPRI_NR_PRIORITIES];
+	long           pri_active[CPUPRI_NR_PRIORITIES/BITS_PER_LONG];
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
+		cpupri = MAX_RT_PRIO - prio;
+    
+	return cpupri;
+}
+
+#define for_each_cpupri_active(array, idx)                   \
+  for( idx = find_first_bit(array, CPUPRI_NR_PRIORITIES);    \
+       idx < CPUPRI_NR_PRIORITIES;                           \
+       idx = find_next_bit(array, CPUPRI_NR_PRIORITIES, idx+1))
+
+/**
+ * cpupri_find - find the best (lowest-pri) CPU in the system
+ * @cpu: The recommended/default CPU
+ * @task_pri: The priority of the task being scheduled (IDLE-RT99)
+ * @p: The task being scheduled
+ *
+ * Note: This function returns the recommended CPU as calculated during the
+ * current invokation.  By the time the call returns, the CPUs may have in
+ * fact changed priorities any number of times.  While not ideal, it is not
+ * an issue of correctness since the normal rebalancer logic will correct
+ * any discrepancies created by racing against the uncertainty of the current
+ * priority configuration.
+ *
+ * Returns: (int)cpu - The recommended cpu to accept the task
+ */
+int cpupri_find(int def_cpu, struct task_struct *p)
+{
+	int                  idx      = 0;
+	struct cpu_priority *cp       = &cpu_priority;
+	int                  this_cpu = smp_processor_id();
+	int                  cpu      = def_cpu;
+	int                  task_pri = convert_prio(p->prio);
+
+	for_each_cpupri_active(cp->pri_active, idx) {
+		cpumask_t mask;
+		int       lowest_pri = idx-1;
+		
+		if (lowest_pri >= task_pri)
+			break;
+		
+		cpus_and(mask, p->cpus_allowed, cp->pri_to_cpu[idx]);
+		
+		if (!cpus_empty(mask)) {
+			/*
+			 * We select a CPU in the following priority:
+			 *
+			 *       def_cpu, this_cpu, first_cpu
+			 *
+			 * for efficiency.  def_cpu preserves cache
+			 * affinity, and this_cpu is cheaper to preempt
+			 * (note that sometimes they are the same).
+			 * Finally, we will take whatever is available
+			 * if the first two don't pan out.
+			 */
+			if (cpu_isset(def_cpu, mask))
+				break;
+			
+			if (cpu_isset(this_cpu, mask)) {
+				cpu = this_cpu;
+				break;
+			}
+			
+			cpu = first_cpu(mask);
+			break;
+		}
+	}
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
+void cpupri_set(int cpu, int newpri)
+{
+	struct cpu_priority *cp      = &cpu_priority;
+	int                 *currpri = &cp->cpu_to_pri[cpu];
+	int                  oldpri  = *currpri;
+	unsigned long        flags;
+
+	newpri = convert_prio(newpri);
+
+	WARN_ON(oldpri == newpri);
+
+	spin_lock_irqsave(&cp->lock, flags);
+	
+	/*
+	 * If the cpu was currently mapped to a different value, we
+	 * first need to unmap the old value
+	 */
+	if (likely(oldpri != CPUPRI_INVALID)) {
+		int        idx  = oldpri+1;
+		cpumask_t *mask = &cp->pri_to_cpu[idx];
+		
+		cpu_clear(cpu, *mask);
+		if (cpus_empty(*mask))
+			__clear_bit(idx, cp->pri_active);
+	}
+	
+	if (likely(newpri != CPUPRI_INVALID)) {
+		int        idx  = newpri+1;
+		cpumask_t *mask = &cp->pri_to_cpu[idx];
+		
+		cpu_set(cpu, *mask);
+		__set_bit(idx, cp->pri_active);
+	}
+
+	spin_unlock_irqrestore(&cp->lock, flags);
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
+	spin_lock_init(&cp->lock);
+
+	for_each_possible_cpu(i) {
+		cp->cpu_to_pri[i] = CPUPRI_INVALID;
+	}
+}
+
+
diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
new file mode 100644
index 0000000..a58a4e8
--- /dev/null
+++ b/kernel/sched_cpupri.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_CPUPRI_H
+#define _LINUX_CPUPRI_H
+
+#include <linux/sched.h>
+
+int  cpupri_find(int cpu, struct task_struct *p);
+void cpupri_set(int cpu, int pri);
+void cpupri_init(void);
+
+#endif /* _LINUX_CPUPRI_H */

