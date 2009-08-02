Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZHBShH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZHBShH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZHBShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:37:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:51051 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZHBShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:37:04 -0400
Date: Sun, 2 Aug 2009 18:36:36 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:core/rcu] rcu: Fix RCU & CPU hotplug hang
Message-ID: <tip-04b06256ccdd0af50ece04530f7dde0f81aa8f46@git.kernel.org>
Git-Commit-ID: 04b06256ccdd0af50ece04530f7dde0f81aa8f46
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 18:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04b06256ccdd0af50ece04530f7dde0f81aa8f46
Gitweb:     http://git.kernel.org/tip/04b06256ccdd0af50ece04530f7dde0f81aa8f46
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Fri, 31 Jul 2009 23:25:50 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 16:08:47 +0200

rcu: Fix RCU & CPU hotplug hang

This patch divides the rcutree initialization into boot-time and
hotplug-time components, so that the tree data structures are guaranteed
to be fully linked at boot time regardless of what might happen in CPU
hotplug operations.

This should prevent the noted panic, but then again so should the
pre-patch setup...

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupdate.c   |   12 +++++++++-
 kernel/rcupreempt.c |    9 -------
 kernel/rcutree.c    |   62 +++++++++++++++++++++++++++-----------------------
 3 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 3fea910..9f0584e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -248,8 +248,18 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 
 void __init rcu_init(void)
 {
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	int i;
+
 	__rcu_init();
+	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+
+	/*
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
+	 */
+	for_each_online_cpu(i)
+		rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
 }
 
 void rcu_scheduler_starting(void)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 4300212..5948353 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1467,15 +1467,6 @@ void __init __rcu_init(void)
 		rdp->waitschedtail = &rdp->waitschedlist;
 		rdp->rcu_sched_sleeping = 0;
 	}
-
-	/*
-	 * We don't need protection against CPU-hotplug here because
-	 * this is called early in boot, before either interrupts
-	 * or the scheduler are operational.
-	 */
-	for_each_online_cpu(cpu)
-		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long) cpu);
-
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index e8e9e93..3313244 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1325,22 +1325,40 @@ int rcu_needs_cpu(int cpu)
 }
 
 /*
- * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
- * approach so that we don't have to worry about how long the CPU has
- * been gone, or whether it ever was online previously.  We do trust the
- * ->mynode field, as it is constant for a given struct rcu_data and
- * initialized during early boot.
- *
- * Note that only one online or offline event can be happening at a given
- * time.  Note also that we can accept some slop in the rsp->completed
- * access due to the fact that this CPU cannot possibly have any RCU
- * callbacks in flight yet.
+ * Do boot-time initialization of a CPU's per-CPU RCU data.
+ */
+static void __init
+rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	int i;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  Note that only one online or
+ * offline event can be happening at a given time.  Note also that we
+ * can accept some slop in the rsp->completed access due to the fact
+ * that this CPU cannot possibly have any RCU callbacks in flight yet.
  */
 static void __cpuinit
 rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
-	int i;
 	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
@@ -1355,16 +1373,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
 	rdp->passed_quiesc_completed = lastcomp - 1;
-	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
-	rdp->qlen = 0;
 	rdp->blimit = blimit;
-#ifdef CONFIG_NO_HZ
-	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
-	rdp->cpu = cpu;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
@@ -1534,17 +1543,12 @@ void __init __rcu_init(void)
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 	rcu_init_one(&rcu_state);
 	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	for_each_possible_cpu(i)
+		rcu_boot_init_percpu_data(i, &rcu_state);
 	rcu_init_one(&rcu_bh_state);
 	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
-
-	/*
-	 * We don't need protection against CPU-hotplug here because
-	 * this is called early in boot, before either interrupts
-	 * or the scheduler are operational.
-	 */
-	for_each_online_cpu(i)
-		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
-
+	for_each_possible_cpu(i)
+		rcu_boot_init_percpu_data(i, &rcu_bh_state);
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
