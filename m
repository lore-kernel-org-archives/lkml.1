Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab0BYKOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:14:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:40949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759013Ab0BYKOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:14:11 -0500
Date: Thu, 25 Feb 2010 10:13:29 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1266887105-1528-15-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-15-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Accelerate grace period if last non-dynticked CPU
Message-ID: <tip-8bd93a2c5d4cab2ae17d06350daa7dbf546a4634@git.kernel.org>
Git-Commit-ID: 8bd93a2c5d4cab2ae17d06350daa7dbf546a4634
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:13:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bd93a2c5d4cab2ae17d06350daa7dbf546a4634
Gitweb:     http://git.kernel.org/tip/8bd93a2c5d4cab2ae17d06350daa7dbf546a4634
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:59 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:55 +0100

rcu: Accelerate grace period if last non-dynticked CPU

Currently, rcu_needs_cpu() simply checks whether the current CPU
has an outstanding RCU callback, which means that the last CPU
to go into dyntick-idle mode might wait a few ticks for the
relevant grace periods to complete.  However, if all the other
CPUs are in dyntick-idle mode, and if this CPU is in a quiescent
state (which it is for RCU-bh and RCU-sched any time that we are
considering going into dyntick-idle mode), then the grace period
is instantly complete.

This patch therefore repeatedly invokes the RCU grace-period
machinery in order to force any needed grace periods to complete
quickly.  It does so a limited number of times in order to
prevent starvation by an RCU callback function that might pass
itself to call_rcu().

However, if any CPU other than the current one is not in
dyntick-idle mode, fall back to simply checking (with fix to bug
noted by Lai Jiangshan).  Also, take advantage of last
grace-period forcing, the opportunity to do so noted by Steve
Rostedt.  And apply simplified #ifdef condition suggested by
Frederic Weisbecker.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
LKML-Reference: <1266887105-1528-15-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
