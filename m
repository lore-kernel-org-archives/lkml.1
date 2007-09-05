Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXIEVhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXIEVhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXIEVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:37:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39939 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087AbXIEVhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:37:22 -0400
Date: Wed, 5 Sep 2007 14:37:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, tglx@linutronix.de, a.p.zijlstra@chello.nl,
       bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru, srostedt@redhat.com
Subject: [PATCH RFC 5/8] RCU: CPU hotplug support for preemptible RCU
Message-ID: <20070905213719.GE4363@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070905213120.GA29204@linux.vnet.ibm.com> <20070905213239.GA4363@linux.vnet.ibm.com> <20070905213344.GB4363@linux.vnet.ibm.com> <20070905213456.GC4363@linux.vnet.ibm.com> <20070905213619.GD4363@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070905213619.GD4363@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Work in progress, not for inclusion.

This patch allows preemptible RCU to tolerate CPU-hotplug operations.
It accomplishes this by maintaining a local copy of a map of online 
CPUs, which it accesses under its own lock.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/rcuclassic.h |    2 
 include/linux/rcupreempt.h |    2 
 kernel/rcuclassic.c        |    8 +++
 kernel/rcupreempt.c        |   93 +++++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 100 insertions(+), 5 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22-d-schedclassic/include/linux/rcuclassic.h linux-2.6.22-e-hotplugcpu/include/linux/rcuclassic.h
--- linux-2.6.22-d-schedclassic/include/linux/rcuclassic.h	2007-08-22 15:38:22.000000000 -0700
+++ linux-2.6.22-e-hotplugcpu/include/linux/rcuclassic.h	2007-08-22 15:55:39.000000000 -0700
@@ -143,6 +143,8 @@ extern int rcu_needs_cpu(int cpu);
 #define rcu_check_callbacks_rt(cpu, user)
 #define rcu_init_rt()
 #define rcu_needs_cpu_rt(cpu) 0
+#define rcu_offline_cpu_rt(cpu)
+#define rcu_online_cpu_rt(cpu)
 #define rcu_pending_rt(cpu) 0
 #define rcu_process_callbacks_rt(unused)
 
diff -urpNa -X dontdiff linux-2.6.22-d-schedclassic/include/linux/rcupreempt.h linux-2.6.22-e-hotplugcpu/include/linux/rcupreempt.h
--- linux-2.6.22-d-schedclassic/include/linux/rcupreempt.h	2007-08-22 15:38:22.000000000 -0700
+++ linux-2.6.22-e-hotplugcpu/include/linux/rcupreempt.h	2007-08-22 15:55:39.000000000 -0700
@@ -59,6 +59,8 @@ extern void rcu_advance_callbacks_rt(int
 extern void rcu_check_callbacks_rt(int cpu, int user);
 extern void rcu_init_rt(void);
 extern int  rcu_needs_cpu_rt(int cpu);
+extern void rcu_offline_cpu_rt(int cpu);
+extern void rcu_online_cpu_rt(int cpu);
 extern int  rcu_pending_rt(int cpu);
 struct softirq_action;
 extern void rcu_process_callbacks_rt(struct softirq_action *unused);
diff -urpNa -X dontdiff linux-2.6.22-d-schedclassic/kernel/rcuclassic.c linux-2.6.22-e-hotplugcpu/kernel/rcuclassic.c
--- linux-2.6.22-d-schedclassic/kernel/rcuclassic.c	2007-08-22 15:51:22.000000000 -0700
+++ linux-2.6.22-e-hotplugcpu/kernel/rcuclassic.c	2007-08-22 15:55:39.000000000 -0700
@@ -414,14 +414,19 @@ static void __rcu_offline_cpu(struct rcu
 static void rcu_offline_cpu(int cpu)
 {
 	struct rcu_data *this_rdp = &get_cpu_var(rcu_data);
+#ifdef CONFIG_CLASSIC_RCU
 	struct rcu_data *this_bh_rdp = &get_cpu_var(rcu_bh_data);
+#endif /* #ifdef CONFIG_CLASSIC_RCU */
 
 	__rcu_offline_cpu(this_rdp, &rcu_ctrlblk,
 					&per_cpu(rcu_data, cpu));
+#ifdef CONFIG_CLASSIC_RCU
 	__rcu_offline_cpu(this_bh_rdp, &rcu_bh_ctrlblk,
 					&per_cpu(rcu_bh_data, cpu));
-	put_cpu_var(rcu_data);
 	put_cpu_var(rcu_bh_data);
+#endif /* #ifdef CONFIG_CLASSIC_RCU */
+	put_cpu_var(rcu_data);
+	rcu_offline_cpu_rt(cpu);
 }
 
 #else
@@ -571,6 +576,7 @@ static void __devinit rcu_online_cpu(int
 	rdp->passed_quiesc = &per_cpu(rcu_data_passed_quiesc, cpu);
 	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
 	bh_rdp->passed_quiesc = &per_cpu(rcu_data_bh_passed_quiesc, cpu);
+	rcu_online_cpu_rt(cpu);
 }
 
 static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
diff -urpNa -X dontdiff linux-2.6.22-d-schedclassic/kernel/rcupreempt.c linux-2.6.22-e-hotplugcpu/kernel/rcupreempt.c
--- linux-2.6.22-d-schedclassic/kernel/rcupreempt.c	2007-08-22 15:45:28.000000000 -0700
+++ linux-2.6.22-e-hotplugcpu/kernel/rcupreempt.c	2007-08-22 15:56:22.000000000 -0700
@@ -125,6 +125,8 @@ enum rcu_mb_flag_values {
 };
 static DEFINE_PER_CPU(enum rcu_mb_flag_values, rcu_mb_flag) = rcu_mb_done;
 
+static cpumask_t rcu_cpu_online_map = CPU_MASK_NONE;
+
 /*
  * Macro that prevents the compiler from reordering accesses, but does
  * absolutely -nothing- to prevent CPUs from reordering.  This is used
@@ -404,7 +406,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 
 	return 1;
@@ -420,7 +422,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
 			return 0;
@@ -462,7 +464,7 @@ rcu_try_flip_waitzero(void)
 
 	/* Call for a memory barrier from each CPU. */
 
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
@@ -480,7 +482,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_possible_cpu(cpu)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
 			return 0;
@@ -583,6 +585,89 @@ void rcu_advance_callbacks_rt(int cpu, i
 	spin_unlock_irqrestore(&rdp->lock, oldirq);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+
+#define rcu_offline_cpu_rt_enqueue(srclist, srctail, dstlist, dsttail) do { \
+		*dsttail = srclist; \
+		if (srclist != NULL) { \
+			dsttail = srctail; \
+			srclist = NULL; \
+			srctail = &srclist;\
+		} \
+	} while (0)
+
+
+void rcu_offline_cpu_rt(int cpu)
+{
+	int i;
+	struct rcu_head *list = NULL;
+	unsigned long oldirq;
+	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_head **tail = &list;
+
+	/* Remove all callbacks from the newly dead CPU, retaining order. */
+
+	spin_lock_irqsave(&rdp->lock, oldirq);
+	rcu_offline_cpu_rt_enqueue(rdp->donelist, rdp->donetail, list, tail);
+	for (i = GP_STAGES - 1; i >= 0; i--)
+		rcu_offline_cpu_rt_enqueue(rdp->waitlist[i], rdp->waittail[i],
+					   list, tail);
+	rcu_offline_cpu_rt_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
+	spin_unlock_irqrestore(&rdp->lock, oldirq);
+	rdp->waitlistcount = 0;
+
+	/* Disengage the newly dead CPU from grace-period computation. */
+
+	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
+	rcu_check_mb(cpu);
+	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
+		smp_mb();  /* Subsequent counter accesses must see new value */
+		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
+		smp_mb();  /* Subsequent RCU read-side critical sections */
+			   /*  seen -after- acknowledgement. */
+	}
+	cpu_clear(cpu, rcu_cpu_online_map);
+	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
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
+	spin_lock_irqsave(&rdp->lock, oldirq);
+	*rdp->nexttail = list;
+	if (list)
+		rdp->nexttail = tail;
+	spin_unlock_irqrestore(&rdp->lock, oldirq);
+}
+
+void __devinit rcu_online_cpu_rt(int cpu)
+{
+	unsigned long oldirq;
+
+	spin_lock_irqsave(&rcu_ctrlblk.fliplock, oldirq);
+	cpu_set(cpu, rcu_cpu_online_map);
+	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+void rcu_offline_cpu(int cpu)
+{
+}
+
+void __devinit rcu_online_cpu_rt(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
 void rcu_process_callbacks_rt(struct softirq_action *unused)
 {
 	unsigned long flags;
