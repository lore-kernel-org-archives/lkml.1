Return-Path: <linux-kernel-owner+w=401wt.eu-S1764644AbXLMRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764644AbXLMRSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765064AbXLMRSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:18:11 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:34145 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764844AbXLMRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:18:07 -0500
Date: Thu, 13 Dec 2007 22:47:38 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E McKenney <paulmck@us.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 5/6] Preempt-RCU: CPU Hotplug handling
Message-ID: <20071213171738.GF25981@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20071213170348.GA25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213170348.GA25981@in.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preempt-RCU: CPU Hotplug handling

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

This patch allows preemptible RCU to tolerate CPU-hotplug operations.
It accomplishes this by maintaining a local copy of a map of online
CPUs, which it accesses under its own lock.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 kernel/rcupreempt.c |  147 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 142 insertions(+), 5 deletions(-)

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index a5aabb1..987cfb7 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -147,6 +147,8 @@ static char *rcu_try_flip_state_names[] =
 	{ "idle", "waitack", "waitzero", "waitmb" };
 #endif /* #ifdef CONFIG_RCU_TRACE */
 
+static cpumask_t rcu_cpu_online_map __read_mostly = CPU_MASK_NONE;
+
 /*
  * Enum and per-CPU flag to determine when each CPU has seen
  * the most recent counter flip.
@@ -445,7 +447,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 
 	return 1;
@@ -461,7 +463,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
 			return 0;
@@ -492,7 +494,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -507,7 +509,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
@@ -525,7 +527,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
 			return 0;
@@ -637,6 +639,98 @@ void rcu_advance_callbacks(int cpu, int user)
 	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+#define rcu_offline_cpu_enqueue(srclist, srctail, dstlist, dsttail) do { \
+		*dsttail = srclist; \
+		if (srclist != NULL) { \
+			dsttail = srctail; \
+			srclist = NULL; \
+			srctail = &srclist;\
+		} \
+	} while (0)
+
+void rcu_offline_cpu(int cpu)
+{
+	int i;
+	struct rcu_head *list = NULL;
+	unsigned long flags;
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_head **tail = &list;
+
+	/*
+	 * Remove all callbacks from the newly dead CPU, retaining order.
+	 * Otherwise rcu_barrier() will fail
+	 */
+
+	spin_lock_irqsave(&rdp->lock, flags);
+	rcu_offline_cpu_enqueue(rdp->donelist, rdp->donetail, list, tail);
+	for (i = GP_STAGES - 1; i >= 0; i--)
+		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
+						list, tail);
+	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
+	spin_unlock_irqrestore(&rdp->lock, flags);
+	rdp->waitlistcount = 0;
+
+	/* Disengage the newly dead CPU from the grace-period computation. */
+
+	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
+	rcu_check_mb(cpu);
+	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
+		smp_mb();  /* Subsequent counter accesses must see new value */
+		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
+		smp_mb();  /* Subsequent RCU read-side critical sections */
+			   /*  seen -after- acknowledgement. */
+	}
+
+	RCU_DATA_ME()->rcu_flipctr[0] += RCU_DATA_CPU(cpu)->rcu_flipctr[0];
+	RCU_DATA_ME()->rcu_flipctr[1] += RCU_DATA_CPU(cpu)->rcu_flipctr[1];
+
+	RCU_DATA_CPU(cpu)->rcu_flipctr[0] = 0;
+	RCU_DATA_CPU(cpu)->rcu_flipctr[1] = 0;
+
+	cpu_clear(cpu, rcu_cpu_online_map);
+
+	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
+
+	/*
+	 * Place the removed callbacks on the current CPU's queue.
+	 * Make them all start a new grace period: simple approach,
+	 * in theory could starve a given set of callbacks, but
+	 * you would need to be doing some serious CPU hotplugging
+	 * to make this happen.  If this becomes a problem, adding
+	 * a synchronize_rcu() to the hotplug path would be a simple
+	 * fix.
+	 */
+
+	rdp = RCU_DATA_ME();
+	spin_lock_irqsave(&rdp->lock, flags);
+	*rdp->nexttail = list;
+	if (list)
+		rdp->nexttail = tail;
+	spin_unlock_irqrestore(&rdp->lock, flags);
+}
+
+void __devinit rcu_online_cpu(int cpu)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
+	cpu_set(cpu, rcu_cpu_online_map);
+	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+void rcu_offline_cpu(int cpu)
+{
+}
+
+void __devinit rcu_online_cpu(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
 static void rcu_process_callbacks(struct softirq_action *unused)
 {
 	unsigned long flags;
@@ -746,6 +840,32 @@ int rcu_pending(int cpu)
 	return 0;
 }
 
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		rcu_online_cpu(cpu);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		rcu_offline_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+	.notifier_call = rcu_cpu_notify,
+};
+
 void __init __rcu_init(void)
 {
 	int cpu;
@@ -769,6 +889,23 @@ void __init __rcu_init(void)
 		rdp->rcu_flipctr[0] = 0;
 		rdp->rcu_flipctr[1] = 0;
 	}
+	register_cpu_notifier(&rcu_nb);
+
+	/*
+	 * We don't need protection against CPU-Hotplug here
+	 * since
+	 * a) If a CPU comes online while we are iterating over the
+	 *    cpu_online_map below, we would only end up making a
+	 *    duplicate call to rcu_online_cpu() which sets the corresponding
+	 *    CPU's mask in the rcu_cpu_online_map.
+	 *
+	 * b) A CPU cannot go offline at this point in time since the user
+	 *    does not have access to the sysfs interface, nor do we
+	 *    suspend the system.
+	 */
+	for_each_online_cpu(cpu)
+		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
+
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks, NULL);
 }
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
