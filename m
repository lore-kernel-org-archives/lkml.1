Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXJWDb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXJWDb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 23:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXJWD3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 23:29:46 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:64637 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJWD3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 23:29:42 -0400
Message-Id: <20071023032916.651749224@goodmis.org>
References: <20071023025900.927578809@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 22 Oct 2007 22:59:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -v2 4/7] RT overloaded runqueues accounting
Content-Disposition: inline; filename=rt-overload.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an RT overload accounting system. When a runqueue has
more than one RT task queued, it is marked as overloaded. That is that it
is a candidate to have RT tasks pulled from it.

If CONFIG_CPUSET is defined, then an rt overloaded CPU bitmask is created
in the cpusets.  The algorithm for pulling tasks is limited to the cpuset
of the current task on the runqueue. Because of overlapping cpusets, it is
possible that the bitmask may get out of sync with actual overloaded RT
runqueues. But it wont cause any real harm. The worst that can happen is
that a RT task may not migrate to a CPU that it can run on when it could.
But that's a OK price to pay to keep the accounting simple and not kill
the cache on large SMP boxes.

When CONFIG_CPUSET is not set, then a single RT overload CPU mask is used.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/cpuset.h |    6 ++++
 kernel/cpuset.c        |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_rt.c      |   29 ++++++++++++++++++++++
 3 files changed, 97 insertions(+)

Index: linux-test.git/kernel/sched_rt.c
===================================================================
--- linux-test.git.orig/kernel/sched_rt.c	2007-10-22 22:31:59.000000000 -0400
+++ linux-test.git/kernel/sched_rt.c	2007-10-22 22:32:18.000000000 -0400
@@ -3,6 +3,31 @@
  * policies)
  */
 
+#ifdef CONFIG_CPUSETS
+# define rt_overload(p) cpuset_rt_overload(p)
+# define rt_set_overload(p, cpu) cpuset_rt_set_overload(p, cpu)
+# define rt_clear_overload(p, cpu) cpuset_rt_clear_overload(p, cpu)
+# define rt_overloaded(p) cpuset_rt_overloaded(p)
+#else
+static cpumask_t rt_overload_mask;
+static inline int rt_overloaded(struct task_struct *p)
+{
+	return !cpus_empty(rt_overload_mask);
+}
+static inline cpumask_t rt_overload(struct task_struct *p)
+{
+	return rt_overload_mask;
+}
+static inline void rt_set_overload(struct task_struct *p, int cpu)
+{
+	cpu_set(cpu, rt_overload_mask);
+}
+static inline void rt_clear_overload(struct task_struct *p, int cpu)
+{
+	cpu_clear(cpu, rt_overload_mask);
+}
+#endif
+
 /*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
@@ -32,6 +57,8 @@ static inline void inc_rt_tasks(struct t
 #ifdef CONFIG_SMP
 	if (p->prio < rq->rt.highest_prio)
 		rq->rt.highest_prio = p->prio;
+	if (rq->rt.rt_nr_running > 1)
+		rt_set_overload(p, rq->cpu);
 #endif /* CONFIG_SMP */
 }
 
@@ -53,6 +80,8 @@ static inline void dec_rt_tasks(struct t
 		} /* otherwise leave rq->highest prio alone */
 	} else
 		rq->rt.highest_prio = MAX_RT_PRIO;
+	if (rq->rt.rt_nr_running < 2)
+		rt_clear_overload(p, rq->cpu);
 #endif /* CONFIG_SMP */
 }
 
Index: linux-test.git/include/linux/cpuset.h
===================================================================
--- linux-test.git.orig/include/linux/cpuset.h	2007-10-22 22:18:53.000000000 -0400
+++ linux-test.git/include/linux/cpuset.h	2007-10-22 22:32:18.000000000 -0400
@@ -78,6 +78,12 @@ extern void cpuset_track_online_nodes(vo
 
 extern int current_cpuset_is_being_rebound(void);
 
+/* The cpuset_rt_overload code is only used when CONFIG_CPUSETS is defined */
+extern int cpuset_rt_overloaded(struct task_struct *tsk);
+extern void cpuset_rt_set_overload(struct task_struct *tsk, int cpu);
+extern cpumask_t cpuset_rt_overload(struct task_struct *tsk);
+extern void cpuset_rt_clear_overload(struct task_struct *tsk, int cpu);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline int cpuset_init_early(void) { return 0; }
Index: linux-test.git/kernel/cpuset.c
===================================================================
--- linux-test.git.orig/kernel/cpuset.c	2007-10-22 22:18:53.000000000 -0400
+++ linux-test.git/kernel/cpuset.c	2007-10-22 22:36:29.000000000 -0400
@@ -84,6 +84,9 @@ struct cpuset {
 	cpumask_t cpus_allowed;		/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
+	/* bits protected by rq locks. */
+	cpumask_t rt_overload;		/* runqueue overload mask */
+
 	struct cpuset *parent;		/* my parent */
 
 	/*
@@ -179,6 +182,7 @@ static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
 	.cpus_allowed = CPU_MASK_ALL,
 	.mems_allowed = NODE_MASK_ALL,
+	.rt_overload = CPU_MASK_NONE,
 };
 
 /*
@@ -1566,6 +1570,7 @@ static void cpuset_post_clone(struct cgr
 
 	cs->mems_allowed = parent_cs->mems_allowed;
 	cs->cpus_allowed = parent_cs->cpus_allowed;
+	cs->rt_overload = parent_cs->rt_overload;
 	return;
 }
 
@@ -1604,6 +1609,7 @@ static struct cgroup_subsys_state *cpuse
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cs->cpus_allowed = CPU_MASK_NONE;
 	cs->mems_allowed = NODE_MASK_NONE;
+	cs->rt_overload = CPU_MASK_NONE;
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
 
@@ -1674,6 +1680,7 @@ int __init cpuset_init(void)
 
 	top_cpuset.cpus_allowed = CPU_MASK_ALL;
 	top_cpuset.mems_allowed = NODE_MASK_ALL;
+	top_cpuset.rt_overload = CPU_MASK_NONE;
 
 	fmeter_init(&top_cpuset.fmeter);
 	top_cpuset.mems_generation = cpuset_mems_generation++;
@@ -1749,6 +1756,7 @@ static void common_cpu_mem_hotplug_unplu
 	guarantee_online_cpus_mems_in_subtree(&top_cpuset);
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	top_cpuset.rt_overload = CPU_MASK_NONE;
 
 	mutex_unlock(&callback_mutex);
 	cgroup_unlock();
@@ -1798,6 +1806,7 @@ void __init cpuset_init_smp(void)
 {
 	top_cpuset.cpus_allowed = cpu_online_map;
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+	top_cpuset.rt_overload = CPU_MASK_NONE;
 
 	hotcpu_notifier(cpuset_handle_cpuhp, 0);
 }
@@ -1868,6 +1877,59 @@ nodemask_t cpuset_mems_allowed(struct ta
 }
 
 /**
+ * cpuset_rt_overloaded - true if the tasks cpuset has a RT overloaded runqueue.
+ * @tsk: pointer to the task_struct from which to test the runqueues.
+ *
+ * Description: Returns true if the tasks cpuset has a RT overloaded bit set.
+ * Due to overlapping cpusets, the runqueue marked as overloaded may no longer
+ * be overloaded, and a run queue that may be overloaded may not be marked.
+ * The RT balancing only focuses on relm of cpusets, so we tolerate these
+ * inconsistencies.
+ */
+int cpuset_rt_overloaded(struct task_struct *tsk)
+{
+	return !cpus_empty(task_cs(tsk)->rt_overload);
+}
+
+/**
+ * cpuset_rt_set_overload - set the tasks cpuset RT overload cpu
+ * @tsk: pointer to the task_struct from which to set the cpuset rt overload.
+ * @cpu: CPU number of the runqueue to set the rt overload.
+ *
+ * Description: Set the bit in the tasks cpuset RT overload mask
+ * that corresponds to the given @cpu.
+ */
+void cpuset_rt_set_overload(struct task_struct *tsk, int cpu)
+{
+	cpu_set(cpu, task_cs(tsk)->rt_overload);
+}
+
+/**
+ * cpuset_rt_overload - return the RT overload mask of a cpuset.
+ * @tsk: pointer to the task_struct from which to set the cpuset rt overload.
+ *
+ * Description: return the cpumask of the rt overload of a
+ * cpuset for a task.
+ */
+cpumask_t cpuset_rt_overload(struct task_struct *tsk)
+{
+	return task_cs(tsk)->rt_overload;
+}
+
+/**
+ * cpuset_rt_clear_overload - clear the tasks cpuset RT overload CPU
+ * @tsk: pointer to the task_struct from which to set the cpuset rt overload.
+ * @cpu: CPU number of the runqueue to clear the rt overload.
+ *
+ * Description: Clear the bit in the tasks cpuset RT overload maks
+ * that corresponds to the given @cpu.
+ */
+void cpuset_rt_clear_overload(struct task_struct *tsk, int cpu)
+{
+	cpu_clear(cpu, task_cs(tsk)->rt_overload);
+}
+
+/**
  * cpuset_zonelist_valid_mems_allowed - check zonelist vs. curremt mems_allowed
  * @zl: the zonelist to be checked
  *

-- 
