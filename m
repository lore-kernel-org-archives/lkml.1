Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZGNGWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZGNGWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 02:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbZGNGWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 02:22:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:60172 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbZGNGWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 02:22:37 -0400
Date: Tue, 14 Jul 2009 06:21:55 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090710004828.GA19385@linux.vnet.ibm.com>
References: <20090710004828.GA19385@linux.vnet.ibm.com>
Subject: [tip:core/rcu] rcu: Simplify RCU CPU-hotplug notification
Message-ID: <tip-7fe616c5dd50a50f334edec1ea0580b90b7af0d9@git.kernel.org>
Git-Commit-ID: 7fe616c5dd50a50f334edec1ea0580b90b7af0d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Jul 2009 06:22:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7fe616c5dd50a50f334edec1ea0580b90b7af0d9
Gitweb:     http://git.kernel.org/tip/7fe616c5dd50a50f334edec1ea0580b90b7af0d9
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Thu, 9 Jul 2009 17:48:28 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Jul 2009 08:16:52 +0200

rcu: Simplify RCU CPU-hotplug notification

Simplify RCU's CPU-hotplug notifiers so that there is only one
notifier. This makes it trivial to provide the ordering
guarantee that rcu_barrier() depends on.  This change also
allows rcu_barrier() to rely on locking wholly contained in
_cpu_down(), rather than that of its callers, making the
locking more straightforward.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
LKML-Reference: <20090710004828.GA19385@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/rcupdate.c   |    8 ++++++--
 kernel/rcupreempt.c |   22 +++++-----------------
 kernel/rcutree.c    |   18 +++++++++---------
 3 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index eae29c2..3fea910 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -217,9 +217,13 @@ static void rcu_migrate_callback(struct rcu_head *notused)
 		wake_up(&rcu_migrate_wq);
 }
 
+extern int rcu_cpu_notify(struct notifier_block *self,
+			  unsigned long action, void *hcpu);
+
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
+	rcu_cpu_notify(self, action, hcpu);
 	if (action == CPU_DYING) {
 		/*
 		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
@@ -234,7 +238,7 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
 		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
 		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_POST_DEAD) {
+	} else if (action == CPU_DEAD) {
 		/* rcu_migrate_head is protected by cpu_add_remove_lock */
 		wait_migrated_callbacks();
 	}
@@ -244,8 +248,8 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 
 void __init rcu_init(void)
 {
-	__rcu_init();
 	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	__rcu_init();
 }
 
 void rcu_scheduler_starting(void)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index beb0e65..4300212 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1417,7 +1417,7 @@ int rcu_pending(int cpu)
 	return 0;
 }
 
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1439,10 +1439,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call = rcu_cpu_notify,
-};
-
 void __init __rcu_init(void)
 {
 	int cpu;
@@ -1471,22 +1467,14 @@ void __init __rcu_init(void)
 		rdp->waitschedtail = &rdp->waitschedlist;
 		rdp->rcu_sched_sleeping = 0;
 	}
-	register_cpu_notifier(&rcu_nb);
 
 	/*
-	 * We don't need protection against CPU-Hotplug here
-	 * since
-	 * a) If a CPU comes online while we are iterating over the
-	 *    cpu_online_mask below, we would only end up making a
-	 *    duplicate call to rcu_online_cpu() which sets the corresponding
-	 *    CPU's mask in the rcu_cpu_online_map.
-	 *
-	 * b) A CPU cannot go offline at this point in time since the user
-	 *    does not have access to the sysfs interface, nor do we
-	 *    suspend the system.
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
 	 */
 	for_each_online_cpu(cpu)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long) cpu);
 
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7717b95..e8e9e93 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1407,13 +1407,12 @@ static void __cpuinit rcu_online_cpu(int cpu)
 {
 	rcu_init_percpu_data(cpu, &rcu_state);
 	rcu_init_percpu_data(cpu, &rcu_bh_state);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 /*
  * Handle CPU online/offline notifcation events.
  */
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 				unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
@@ -1523,10 +1522,6 @@ do { \
 	} \
 } while (0)
 
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call	= rcu_cpu_notify,
-};
-
 void __init __rcu_init(void)
 {
 	int i;			/* All used by RCU_DATA_PTR_INIT(). */
@@ -1542,10 +1537,15 @@ void __init __rcu_init(void)
 	rcu_init_one(&rcu_bh_state);
 	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
 
+	/*
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
+	 */
 	for_each_online_cpu(i)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
-	/* Register notifier for non-boot CPUs */
-	register_cpu_notifier(&rcu_nb);
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
+
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 module_param(blimit, int, 0);
