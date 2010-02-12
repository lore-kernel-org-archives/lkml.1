Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0BLADT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:03:19 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52824 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab0BLABI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:01:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/13] rcu: accelerate grace period if last non-dynticked CPU
Date: Thu, 11 Feb 2010 16:00:39 -0800
Message-Id: <1265932839-25899-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100212000016.GA25781@linux.vnet.ibm.com>
References: <20100212000016.GA25781@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, rcu_needs_cpu() simply checks whether the current CPU has
an outstanding RCU callback, which means that the last CPU to go into
dyntick-idle mode might wait a few ticks for the relevant grace periods
to complete.  However, if all the other CPUs are in dyntick-idle mode,
and if this CPU is in a quiescent state (which it is for RCU-bh and
RCU-sched any time that we are considering going into dyntick-idle mode),
then the grace period is instantly complete.

This patch therefore repeatedly invokes the RCU grace-period machinery
in order to force any needed grace periods to complete quickly.  It does
so a limited number of times in order to prevent starvation by an RCU
callback function that might pass itself to call_rcu().

However, if any CPU other than the current one is not in dyntick-idle
mode, fall back to simply checking (with fix to bug noted by Lai
Jiangshan).  Also, take advantage of last grace-period forcing, the
opportunity to do so noted by Steve Rostedt.  And apply simplified #ifdef
condition suggested by Frederic Weisbecker.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/cpumask.h |   14 +++++++++
 init/Kconfig            |   16 +++++++++++
 kernel/rcutree.c        |    5 +--
 kernel/rcutree_plugin.h |   69 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d77b547..dbcee76 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -143,6 +143,8 @@ static inline unsigned int cpumask_any_but(const struct cpumask *mask,
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_cpu_not(cpu, mask)		\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
 #define for_each_cpu_and(cpu, mask, and)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
 #else
@@ -203,6 +205,18 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 		(cpu) < nr_cpu_ids;)
 
 /**
+ * for_each_cpu_not - iterate over every cpu in a complemented mask
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the cpumask pointer
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_not(cpu, mask)				\
+	for ((cpu) = -1;					\
+		(cpu) = cpumask_next_zero((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids;)
+
+/**
  * for_each_cpu_and - iterate over every cpu in both masks
  * @cpu: the (optionally unsigned) integer iterator
  * @mask: the first cpumask pointer
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..42bf914 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -396,6 +396,22 @@ config RCU_FANOUT_EXACT
 
 	  Say N if unsure.
 
+config RCU_FAST_NO_HZ
+	bool "Accelerate last non-dyntick-idle CPU's grace periods"
+	depends on TREE_RCU && NO_HZ && SMP
+	default n
+	help
+	  This option causes RCU to attempt to accelerate grace periods
+	  in order to allow the final CPU to enter dynticks-idle state
+	  more quickly.  On the other hand, this option increases the
+	  overhead of the dynticks-idle checking, particularly on systems
+	  with large numbers of CPUs.
+
+	  Say Y if energy efficiency is critically important, particularly
+	  	if you have relatively few CPUs.
+
+	  Say N if you are unsure.
+
 config TREE_RCU_TRACE
 	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
 	select DEBUG_FS
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 099a255..29d88c0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1550,10 +1550,9 @@ static int rcu_pending(int cpu)
 /*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
+ * 1 if so.
  */
-int rcu_needs_cpu(int cpu)
+static int rcu_needs_cpu_quick_check(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e77cdf3..a825666 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -906,3 +906,72 @@ static void __init __rcu_init_preempt(void)
 }
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+#if !defined(CONFIG_RCU_FAST_NO_HZ)
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ *
+ * Because we have preemptible RCU, just check whether this CPU needs
+ * any flavor of RCU.  Do not chew up lots of CPU cycles with preemption
+ * disabled in a most-likely vain attempt to cause RCU not to need this CPU.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	return rcu_needs_cpu_quick_check(cpu);
+}
+
+#else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
+
+#define RCU_NEEDS_CPU_FLUSHES 5
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ *
+ * Because we are not supporting preemptible RCU, attempt to accelerate
+ * any current grace periods so that RCU no longer needs this CPU, but
+ * only if all other CPUs are already in dynticks-idle mode.  This will
+ * allow the CPU cores to be powered down immediately, as opposed to after
+ * waiting many milliseconds for grace periods to elapse.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	int c = 1;
+	int i;
+	int thatcpu;
+
+	/* Don't bother unless we are the last non-dyntick-idle CPU. */
+	for_each_cpu_not(thatcpu, nohz_cpu_mask)
+		if (thatcpu != cpu)
+			return rcu_needs_cpu_quick_check(cpu);
+
+	/* Try to push remaining RCU-sched and RCU-bh callbacks through. */
+	for (i = 0; i < RCU_NEEDS_CPU_FLUSHES && c; i++) {
+		c = 0;
+		if (per_cpu(rcu_sched_data, cpu).nxtlist) {
+			rcu_sched_qs(cpu);
+			force_quiescent_state(&rcu_sched_state, 0);
+			__rcu_process_callbacks(&rcu_sched_state,
+						&per_cpu(rcu_sched_data, cpu));
+			c = !!per_cpu(rcu_sched_data, cpu).nxtlist;
+		}
+		if (per_cpu(rcu_bh_data, cpu).nxtlist) {
+			rcu_bh_qs(cpu);
+			force_quiescent_state(&rcu_bh_state, 0);
+			__rcu_process_callbacks(&rcu_bh_state,
+						&per_cpu(rcu_bh_data, cpu));
+			c = !!per_cpu(rcu_bh_data, cpu).nxtlist;
+		}
+	}
+
+	/* If RCU callbacks are still pending, RCU still needs this CPU. */
+	return c;
+}
+
+#endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.6.6

