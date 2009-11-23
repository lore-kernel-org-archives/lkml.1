Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbZKWHC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbZKWHC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 02:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZKWHC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 02:02:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:51899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZKWHC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 02:02:26 -0500
Date: Mon, 23 Nov 2009 07:01:57 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <12589088302320-git-send-email->
References: <12589088302320-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] rcu: Eliminate unneeded function wrapping
Message-ID: <tip-9f680ab41485edfdc96331b70afa7513aa0a7720@git.kernel.org>
Git-Commit-ID: 9f680ab41485edfdc96331b70afa7513aa0a7720
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f680ab41485edfdc96331b70afa7513aa0a7720
Gitweb:     http://git.kernel.org/tip/9f680ab41485edfdc96331b70afa7513aa0a7720
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Sun, 22 Nov 2009 08:53:49 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Nov 2009 18:58:16 +0100

rcu: Eliminate unneeded function wrapping

The functions rcu_init() is a wrapper for __rcu_init(), and also
sets up the CPU-hotplug notifier for rcu_barrier_cpu_hotplug().
But TINY_RCU doesn't need CPU-hotplug notification, and the
rcu_barrier_cpu_hotplug() is a simple wrapper for
rcu_cpu_notify().

So push rcu_init() out to kernel/rcutree.c and kernel/rcutiny.c
and get rid of the wrapper function rcu_barrier_cpu_hotplug().

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
LKML-Reference: <12589088302320-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/rcutiny.h |    2 --
 include/linux/rcutree.h |    3 ---
 kernel/rcupdate.c       |   22 ----------------------
 kernel/rcutiny.c        |   11 +----------
 kernel/rcutree.c        |   17 ++++++++++++++---
 5 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 2c1fe83..a3b6272 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -38,7 +38,6 @@ void rcu_bh_qs(int cpu);
 
 #define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
-extern void __rcu_init(void);
 
 /*
  * Return the number of grace periods.
@@ -69,7 +68,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 }
 
 struct notifier_block;
-extern int rcu_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu);
 
 #ifdef CONFIG_NO_HZ
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 9642c6b..111a652 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -34,8 +34,6 @@ struct notifier_block;
 
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
-extern int rcu_cpu_notify(struct notifier_block *self,
-			  unsigned long action, void *hcpu);
 extern int rcu_needs_cpu(int cpu);
 extern int rcu_expedited_torture_stats(char *page);
 
@@ -83,7 +81,6 @@ static inline void synchronize_rcu_bh_expedited(void)
 	synchronize_sched_expedited();
 }
 
-extern void __rcu_init(void);
 extern void rcu_check_callbacks(int cpu, int user);
 
 extern long rcu_batches_completed(void);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 7625f20..eb6b534 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -161,28 +161,6 @@ EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
 #endif /* #ifndef CONFIG_TINY_RCU */
 
-static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
-		unsigned long action, void *hcpu)
-{
-	return rcu_cpu_notify(self, action, hcpu);
-}
-
-void __init rcu_init(void)
-{
-	int i;
-
-	__rcu_init();
-	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
-
-	/*
-	 * We don't need protection against CPU-hotplug here because
-	 * this is called early in boot, before either interrupts
-	 * or the scheduler are operational.
-	 */
-	for_each_online_cpu(i)
-		rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
-}
-
 void rcu_scheduler_starting(void)
 {
 	WARN_ON(num_online_cpus() != 1);
diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index b33ec3a..9f6d9ff 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -178,15 +178,6 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 }
 
 /*
- * Null function to handle CPU being onlined.  Longer term, we want to
- * make TINY_RCU avoid using rcupdate.c, but later...
- */
-int rcu_cpu_notify(struct notifier_block *self, unsigned long action, void *hcpu)
-{
-	return NOTIFY_OK;
-}
-
-/*
  * Wait for a grace period to elapse.  But it is illegal to invoke
  * synchronize_sched() from within an RCU read-side critical section.
  * Therefore, any legal call to synchronize_sched() is a quiescent
@@ -285,7 +276,7 @@ void rcu_barrier_sched(void)
 }
 EXPORT_SYMBOL_GPL(rcu_barrier_sched);
 
-void __rcu_init(void)
+void __init rcu_init(void)
 {
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b79bfcd..e3d3bbd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1644,8 +1644,8 @@ static void __cpuinit rcu_online_cpu(int cpu)
 /*
  * Handle CPU online/offline notification events.
  */
-int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-			     unsigned long action, void *hcpu)
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
 
@@ -1781,8 +1781,10 @@ do { \
 	} \
 } while (0)
 
-void __init __rcu_init(void)
+void __init rcu_init(void)
 {
+	int i;
+
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
@@ -1791,6 +1793,15 @@ void __init __rcu_init(void)
 	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
 	__rcu_init_preempt();
 	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+
+	/*
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
+	 */
+	cpu_notifier(rcu_cpu_notify, 0);
+	for_each_online_cpu(i)
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
 }
 
 #include "rcutree_plugin.h"
