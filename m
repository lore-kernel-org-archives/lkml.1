Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbZHOQyS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 15 Aug 2009 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932161AbZHOQx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:53:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50752 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbZHOQxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:53:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
   josht@linux.vnet.ibm.com, akpm@linux-foundation.org,
   mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
   tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
   hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org,
   "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH -tip/core/rcu 3/6] Simplify RCU CPU-hotplug notification
Date: Sat, 15 Aug 2009 09:53:48 -0700
Message-Id: <12503552312510-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20090815165153.GA8886@linux.vnet.ibm.com>
References: <20090815165153.GA8886@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Use the new cpu_notifier() API to simplify RCU's CPU-hotplug
notifiers, collapsing down to a single such notifier.  This
makes it trivial to provide the notifier-ordering guarantee
that rcu_barrier() depends on.  Also remove redundant
open_softirq() calls from Hierarchical RCU notifier.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcupdate.c   |   16 +++++++++++++++-
 kernel/rcupreempt.c |   25 ++-----------------------
 kernel/rcutree.c    |   17 +++++------------
 3 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index eae29c2..8df1156 100644
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
@@ -244,8 +248,18 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 
 void __init rcu_init(void)
 {
+	int i;
+
 	__rcu_init();
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
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
index beb0e65..9b87f51 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -1417,8 +1417,8 @@ int rcu_pending(int cpu)
 	return 0;
 }
 
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
+int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+			     unsigned long action, void *hcpu)
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
@@ -1471,23 +1467,6 @@ void __init __rcu_init(void)
 		rdp->waitschedtail = &rdp->waitschedlist;
 		rdp->rcu_sched_sleeping = 0;
 	}
-	register_cpu_notifier(&rcu_nb);
-
-	/*
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
-	 */
-	for_each_online_cpu(cpu)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
-
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f3e4327..75762cd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1132,6 +1132,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(rdp->beenonline == 0);
+
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
@@ -1416,14 +1418,13 @@ static void __cpuinit rcu_online_cpu(int cpu)
 {
 	rcu_init_percpu_data(cpu, &rcu_state);
 	rcu_init_percpu_data(cpu, &rcu_bh_state);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 /*
  * Handle CPU online/offline notifcation events.
  */
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
+int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+			     unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
 
@@ -1532,10 +1533,6 @@ do { \
 	} \
 } while (0)
 
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call	= rcu_cpu_notify,
-};
-
 void __init __rcu_init(void)
 {
 	int i;			/* All used by RCU_DATA_PTR_INIT(). */
@@ -1554,11 +1551,7 @@ void __init __rcu_init(void)
 	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
 	for_each_possible_cpu(i)
 		rcu_boot_init_percpu_data(i, &rcu_bh_state);
-
-	for_each_online_cpu(i)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
-	/* Register notifier for non-boot CPUs */
-	register_cpu_notifier(&rcu_nb);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 module_param(blimit, int, 0);
-- 
1.5.2.5

