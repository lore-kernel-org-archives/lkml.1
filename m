Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966747Ab0B0AjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 19:39:09 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33648 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966717Ab0B0AjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 19:39:03 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/3] rcu: fixes for accelerated grace periods for last non-dynticked CPU
Date: Fri, 26 Feb 2010 16:38:56 -0800
Message-Id: <1267231138-27856-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100227003831.GA27703@linux.vnet.ibm.com>
References: <20100227003831.GA27703@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is illegal to invoke __rcu_process_callbacks() with irqs disabled,
so do it indirectly via raise_softirq().  This requires a state-machine
implementation to cycle through the grace-period machinery the required
number of times.

Located-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    3 ++
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |   73 ++++++++++++++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 335bfe4..3ec8160 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1341,6 +1341,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	 * grace-period manipulations above.
 	 */
 	smp_mb(); /* See above block comment. */
+
+	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
+	rcu_needs_cpu_flush();
 }
 
 static void
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 2ceb083..1439eb5 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -373,5 +373,6 @@ static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_orphanage(void);
 static void __init __rcu_init_preempt(void);
+static void rcu_needs_cpu_flush(void);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3516de7..ed241fc 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -973,9 +973,19 @@ int rcu_needs_cpu(int cpu)
 	return rcu_needs_cpu_quick_check(cpu);
 }
 
+/*
+ * Check to see if we need to continue a callback-flush operations to
+ * allow the last CPU to enter dyntick-idle mode.  But fast dyntick-idle
+ * entry is not configured, so we never do need to.
+ */
+static void rcu_needs_cpu_flush(void)
+{
+}
+
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #define RCU_NEEDS_CPU_FLUSHES 5
+static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 
 /*
  * Check to see if any future RCU-related work will need to be done
@@ -988,39 +998,62 @@ int rcu_needs_cpu(int cpu)
  * only if all other CPUs are already in dynticks-idle mode.  This will
  * allow the CPU cores to be powered down immediately, as opposed to after
  * waiting many milliseconds for grace periods to elapse.
+ *
+ * Because it is not legal to invoke rcu_process_callbacks() with irqs
+ * disabled, we do one pass of force_quiescent_state(), then do a
+ * raise_softirq() to cause rcu_process_callbacks() to be invoked later.
+ * The per-cpu rcu_dyntick_drain variable controls the sequencing.
  */
 int rcu_needs_cpu(int cpu)
 {
-	int c = 1;
-	int i;
+	int c = 0;
 	int thatcpu;
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
 	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (thatcpu != cpu)
+		if (thatcpu != cpu) {
+			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			return rcu_needs_cpu_quick_check(cpu);
-
-	/* Try to push remaining RCU-sched and RCU-bh callbacks through. */
-	for (i = 0; i < RCU_NEEDS_CPU_FLUSHES && c; i++) {
-		c = 0;
-		if (per_cpu(rcu_sched_data, cpu).nxtlist) {
-			rcu_sched_qs(cpu);
-			force_quiescent_state(&rcu_sched_state, 0);
-			__rcu_process_callbacks(&rcu_sched_state,
-						&per_cpu(rcu_sched_data, cpu));
-			c = !!per_cpu(rcu_sched_data, cpu).nxtlist;
-		}
-		if (per_cpu(rcu_bh_data, cpu).nxtlist) {
-			rcu_bh_qs(cpu);
-			force_quiescent_state(&rcu_bh_state, 0);
-			__rcu_process_callbacks(&rcu_bh_state,
-						&per_cpu(rcu_bh_data, cpu));
-			c = !!per_cpu(rcu_bh_data, cpu).nxtlist;
 		}
+
+	/* Check and update the rcu_dyntick_drain sequencing. */
+	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		/* First time through, initialize the counter. */
+		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
+	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		/* We have hit the limit, so time to give up. */
+		return rcu_needs_cpu_quick_check(cpu);
+	}
+
+	/* Do one step pushing remaining RCU callbacks through. */
+	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
+		rcu_sched_qs(cpu);
+		force_quiescent_state(&rcu_sched_state, 0);
+		c = c || per_cpu(rcu_sched_data, cpu).nxtlist;
+	}
+	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
+		rcu_bh_qs(cpu);
+		force_quiescent_state(&rcu_bh_state, 0);
+		c = c || per_cpu(rcu_bh_data, cpu).nxtlist;
 	}
 
 	/* If RCU callbacks are still pending, RCU still needs this CPU. */
+	if (c)
+		raise_softirq(RCU_SOFTIRQ);
 	return c;
 }
 
+/*
+ * Check to see if we need to continue a callback-flush operations to
+ * allow the last CPU to enter dyntick-idle mode.
+ */
+static void rcu_needs_cpu_flush(void)
+{
+	int cpu = smp_processor_id();
+
+	if (per_cpu(rcu_dyntick_drain, cpu) <= 0)
+		return;
+	(void)rcu_needs_cpu(cpu);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
-- 
1.6.6

