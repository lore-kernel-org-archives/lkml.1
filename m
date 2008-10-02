Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYJBAiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYJBAiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJBAh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:37:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38147 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYJBAh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:37:57 -0400
Date: Wed, 1 Oct 2008 17:36:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       laijs@cn.fujitsu.com, manfred@colorfullife.com, dipankar@in.ibm.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, josht@linux.vnet.ibm.com
Subject: [PATCH,RFC] RCU-based detection of stalled CPUs for Classic RCU
Message-ID: <20081002003628.GA7877@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch adds stalled-CPU detection to Classic RCU.  This capability
is enabled by a new config variable CONFIG_RCU_CPU_STALL_DETECTOR,
which defaults disabled.  This is a debugging feature, not something
that non-kernel-hackers would be expected to care about.  This feature
can detect looping CPUs in !PREEMPT builds and looping CPUs with
preemption disabled in PREEMPT builds.  This is essentially a port of
this functionality from the treercu patch.

One current shortcoming: on some systems, stalls are detected during
early boot, when we normally would not care about them.  My thought is
to add a call from late initialization to suppress stall detection until
the system is well along its way to being booted, but thought I should
check to see if there might already be something for this purpose.

(Currently against 2.6.27-rc8, FYI.)

Thoughts?

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |    9 ++++
 kernel/rcuclassic.c        |   88 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug          |   13 ++++++
 3 files changed, 110 insertions(+)

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 4ab8436..9b62e9a 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -40,6 +40,10 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK	3	/* for rcp->seconds_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK	30	/* for rcp->seconds_stall */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /* Global control variables for rcupdate callback mechanism. */
 struct rcu_ctrlblk {
@@ -52,6 +56,11 @@ struct rcu_ctrlblk {
 	spinlock_t	lock	____cacheline_internodealigned_in_smp;
 	cpumask_t	cpumask; /* CPUs that need to switch in order    */
 				 /* for current batch to proceed.        */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;	 /* Time at which GP started in jiffies. */
+	unsigned long seconds_stall;
+				 /* Time at which to check for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 } ____cacheline_internodealigned_in_smp;
 
 /* Is batch a before batch b ? */
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index aad93cd..c092ba9 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -118,6 +118,87 @@ static inline void force_quiescent_state(struct rcu_data *rdp,
 }
 #endif
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+	rcp->gp_start = jiffies;
+	rcp->seconds_stall = get_seconds() + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rcp->lock, flags);
+	delta = get_seconds() - rcp->seconds_stall;
+	if (delta < 2 || rcp->cur != rcp->completed) {
+		spin_unlock_irqrestore(&rcp->lock, flags);
+		return;
+	}
+	rcp->seconds_stall = get_seconds() + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "RCU detected CPU stalls:");
+	for_each_possible_cpu(cpu) {
+		if (cpu_isset(cpu, rcp->cpumask))
+			printk(" %d", cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
+}
+
+static void print_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	unsigned long flags;
+
+	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
+			smp_processor_id(), get_seconds(),
+			jiffies - rcp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rcp->lock, flags);
+	if ((long)(get_seconds() - rcp->seconds_stall) >= 0)
+		rcp->seconds_stall =
+			get_seconds() + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rcp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp)
+{
+	long delta;
+
+	delta = get_seconds() - rcp->seconds_stall;
+	if (cpu_isset(smp_processor_id(), rcp->cpumask) && delta >= 0) {
+		
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rcp);
+
+	} else if (rcp->cur != rcp->completed && delta >= 2) {
+
+		/* They had two seconds to dump stack, so complain. */
+		print_other_cpu_stall(rcp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
+{
+}
+
+static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 /**
  * call_rcu - Queue an RCU callback for invocation after a grace period.
  * @head: structure to be used for queueing the RCU updates.
@@ -285,6 +366,7 @@ static void rcu_start_batch(struct rcu_ctrlblk *rcp)
 		 */
 		smp_wmb();
 		rcp->cur++;
+		record_gp_stall_check_time(rcp);
 
 		/*
 		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
@@ -468,6 +550,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 
 static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
 {
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rcp);
+
 	/* This cpu has pending rcu entries and the grace period
 	 * for them has completed.
 	 */
@@ -558,6 +643,9 @@ void rcu_check_callbacks(int cpu, int user)
 static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
 						struct rcu_data *rdp)
 {
+#ifdef CONFIG_DEBUG_RCU_STALL
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_DEBUG_RCU_STALL */
 	memset(rdp, 0, sizeof(*rdp));
 	rdp->curtail = &rdp->curlist;
 	rdp->nxttail = &rdp->nxtlist;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0b50481..9fee969 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -597,6 +597,19 @@ config RCU_TORTURE_TEST_RUNNABLE
 	  Say N here if you want the RCU torture tests to start only
 	  after being manually enabled via /proc.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU
+	default n
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
