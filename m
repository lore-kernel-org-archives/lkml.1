Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYFJNMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYFJNMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 09:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYFJNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 09:12:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:51075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbYFJNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 09:12:09 -0400
Message-Id: <20080610111832.882895861@chello.nl>
References: <20080610111259.766940257@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jun 2008 13:13:03 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 4/5] rcu: backport RCU cpu hotplug support
Content-Disposition: inline; filename=hotplug-rcu.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backport the RCU cpu-hotplug support from .26-rc to .24-rt

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/rcupreempt.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

Index: linux-2.6.24.7.noarch/kernel/rcupreempt.c
===================================================================
--- linux-2.6.24.7.noarch.orig/kernel/rcupreempt.c
+++ linux-2.6.24.7.noarch/kernel/rcupreempt.c
@@ -820,6 +820,13 @@ void rcu_offline_cpu_rt(int cpu)
 		smp_mb();  /* Subsequent RCU read-side critical sections */
 			   /*  seen -after- acknowledgement. */
 	}
+
+	__get_cpu_var(rcu_flipctr)[0] += per_cpu(rcu_flipctr, cpu)[0];
+	__get_cpu_var(rcu_flipctr)[1] += per_cpu(rcu_flipctr, cpu)[1];
+
+	per_cpu(rcu_flipctr, cpu)[0] = 0;
+	per_cpu(rcu_flipctr, cpu)[1] = 0;
+
 	cpu_clear(cpu, rcu_cpu_online_map);
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, oldirq);
 
@@ -833,8 +840,9 @@ void rcu_offline_cpu_rt(int cpu)
 	 * fix.
 	 */
 
+	local_irq_save(oldirq);
 	rdp = RCU_DATA_ME();
-	spin_lock_irqsave(&rdp->lock, oldirq);
+	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
@@ -866,9 +874,11 @@ void rcu_process_callbacks_rt(struct sof
 {
 	unsigned long flags;
 	struct rcu_head *next, *list;
-	struct rcu_data *rdp = RCU_DATA_ME();
+	struct rcu_data *rdp;
 
-	spin_lock_irqsave(&rdp->lock, flags);
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
 	list = rdp->donelist;
 	if (list == NULL) {
 		spin_unlock_irqrestore(&rdp->lock, flags);
@@ -951,6 +961,32 @@ int rcu_pending_rt(int cpu)
 	return 0;
 }
 
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+                                unsigned long action, void *hcpu)
+{
+        long cpu = (long)hcpu;
+
+        switch (action) {
+        case CPU_UP_PREPARE:
+        case CPU_UP_PREPARE_FROZEN:
+                rcu_online_cpu_rt(cpu);
+                break;
+        case CPU_UP_CANCELED:
+        case CPU_UP_CANCELED_FROZEN:
+        case CPU_DEAD:
+        case CPU_DEAD_FROZEN:
+                rcu_offline_cpu_rt(cpu);
+                break;
+        default:
+                break;
+        }
+        return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+        .notifier_call = rcu_cpu_notify,
+};
+
 void __init rcu_init_rt(void)
 {
 	int cpu;
@@ -972,6 +1008,22 @@ void __init rcu_init_rt(void)
 		rdp->donetail = &rdp->donelist;
 	}
 	rcu_preempt_boost_init();
+	register_cpu_notifier(&rcu_nb);
+
+	/*
+         * We don't need protection against CPU-Hotplug here
+         * since
+         * a) If a CPU comes online while we are iterating over the
+         *    cpu_online_map below, we would only end up making a
+         *    duplicate call to rcu_online_cpu() which sets the corresponding
+         *    CPU's mask in the rcu_cpu_online_map.
+         *
+         * b) A CPU cannot go offline at this point in time since the user
+         *    does not have access to the sysfs interface, nor do we
+         *    suspend the system.
+         */
+        for_each_online_cpu(cpu)
+                rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long) cpu);
 }
 
 /*

-- 

