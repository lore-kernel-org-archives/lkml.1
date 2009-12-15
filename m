Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbZLOXP1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 15 Dec 2009 18:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934142AbZLOXOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:14:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53796 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934169AbZLOXCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:02:46 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 11/18] rcu: add force_quiescent_state() testing to rcutorture
Date: Tue, 15 Dec 2009 15:02:34 -0800
Message-Id: <1260918161183-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20091215230213.GA9093@linux.vnet.ibm.com>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Proposed for 2.6.34, not for inclusion.

Add force_quiescent_state() testing to rcutorture, with a separate
thread that repeatedly invokes force_quiescent_state() in bursts.
This can greatly increase the probability of encountering certain types
of race conditions.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |   12 +++++++
 include/linux/rcutree.h |    3 ++
 kernel/rcutorture.c     |   80 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/rcutree.c        |   18 ++++++++++
 kernel/rcutree_plugin.h |   19 +++++++++++
 5 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index c4ba9a7..b524590 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -62,6 +62,18 @@ static inline long rcu_batches_completed_bh(void)
 
 extern int rcu_expedited_torture_stats(char *page);
 
+static inline void rcu_force_quiescent_state(void)
+{
+}
+
+static inline void rcu_bh_force_quiescent_state(void)
+{
+}
+
+static inline void rcu_sched_force_quiescent_state(void)
+{
+}
+
 #define synchronize_rcu synchronize_sched
 
 static inline void synchronize_rcu_expedited(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c93eee5..564a025 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -88,6 +88,9 @@ extern void rcu_check_callbacks(int cpu, int user);
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
+extern void rcu_force_quiescent_state(void);
+extern void rcu_bh_force_quiescent_state(void);
+extern void rcu_sched_force_quiescent_state(void);
 
 #ifdef CONFIG_NO_HZ
 void rcu_enter_nohz(void);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index a621a67..b4096d3 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -61,6 +61,9 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
+static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
+static int fqs_holdoff = 0;	/* Hold time within burst (us). */
+static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -79,6 +82,12 @@ module_param(stutter, int, 0444);
 MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
 module_param(irqreader, int, 0444);
 MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
+module_param(fqs_duration, int, 0444);
+MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us)");
+module_param(fqs_holdoff, int, 0444);
+MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
+module_param(fqs_stutter, int, 0444);
+MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -99,6 +108,7 @@ static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
+static struct task_struct *fqs_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -263,6 +273,7 @@ struct rcu_torture_ops {
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*cb_barrier)(void);
+	void (*fqs)(void);
 	int (*stats)(char *page);
 	int irq_capable;
 	char *name;
@@ -347,6 +358,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.cb_barrier	= rcu_barrier,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu"
@@ -388,6 +400,7 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_sync"
@@ -403,6 +416,7 @@ static struct rcu_torture_ops rcu_expedited_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu_expedited,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_expedited"
@@ -465,6 +479,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= rcu_bh_torture_synchronize,
 	.cb_barrier	= rcu_barrier_bh,
+	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_bh"
@@ -480,6 +495,7 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= rcu_bh_torture_synchronize,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_bh_sync"
@@ -621,6 +637,7 @@ static struct rcu_torture_ops sched_ops = {
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= rcu_barrier_sched,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "sched"
@@ -636,6 +653,7 @@ static struct rcu_torture_ops sched_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
 	.name		= "sched_sync"
 };
@@ -650,12 +668,45 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= rcu_expedited_torture_stats,
 	.irq_capable	= 1,
 	.name		= "sched_expedited"
 };
 
 /*
+ * RCU torture force-quiescent-state kthread.  Repeatedly induces
+ * bursts of calls to force_quiescent_state(), increasing the probability
+ * of occurrence of some important types of race conditions.
+ */
+static int
+rcu_torture_fqs(void *arg)
+{
+	unsigned long fqs_resume_time;
+	int fqs_burst_remaining;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
+	do {
+		fqs_resume_time = jiffies + fqs_stutter * HZ;
+		while (jiffies - fqs_resume_time > LONG_MAX) {
+			schedule_timeout_interruptible(1);
+		}
+		fqs_burst_remaining = fqs_duration;
+		while (fqs_burst_remaining > 0) {
+			cur_ops->fqs();
+			udelay(fqs_holdoff);
+			fqs_burst_remaining -= fqs_holdoff;
+		}
+		rcu_stutter_wait("rcu_torture_fqs");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	VERBOSE_PRINTK_STRING("rcu_torture_fqs task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_fqs");
+	while (!kthread_should_stop())
+		schedule_timeout_uninterruptible(1);
+	return 0;
+}
+
+/*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
  * after a series of grace periods (the "pipeline").
@@ -1030,10 +1081,11 @@ rcu_torture_print_module_parms(char *tag)
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval=%d stutter=%d irqreader=%d\n",
+		"shuffle_interval=%d stutter=%d irqreader=%d "
+		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader);
+		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter);
 }
 
 static struct notifier_block rcutorture_nb = {
@@ -1109,6 +1161,12 @@ rcu_torture_cleanup(void)
 	}
 	stats_task = NULL;
 
+	if (fqs_task) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_fqs task");
+		kthread_stop(fqs_task);
+	}
+	fqs_task = NULL;
+
 	/* Wait for all RCU callbacks to fire.  */
 
 	if (cur_ops->cb_barrier != NULL)
@@ -1154,6 +1212,11 @@ rcu_torture_init(void)
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
+	if (cur_ops->fqs == NULL && fqs_duration != 0) {
+		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero "
+				  "fqs_duration, fqs disabled.\n");
+		fqs_duration = 0;
+	}
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
@@ -1282,6 +1345,19 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (fqs_duration < 0)
+		fqs_duration = 0;
+	if (fqs_duration) {
+		/* Create the stutter thread */
+		fqs_task = kthread_run(rcu_torture_fqs, NULL,
+				       "rcu_torture_fqs");
+		if (IS_ERR(fqs_task)) {
+			firsterr = PTR_ERR(fqs_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create fqs");
+			fqs_task = NULL;
+			goto unwind;
+		}
+	}
 	register_reboot_notifier(&rcutorture_nb);
 	mutex_unlock(&fullstop_mutex);
 	return 0;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 55e8f6e..0a4c328 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -157,6 +157,24 @@ long rcu_batches_completed_bh(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 
 /*
+ * Force a quiescent state for RCU BH.
+ */
+void rcu_bh_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_bh_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
+
+/*
+ * Force a quiescent state for RCU-sched.
+ */
+void rcu_sched_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_sched_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_sched_force_quiescent_state);
+
+/*
  * Does the CPU have callbacks ready to be invoked?
  */
 static int
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 37fbccd..f11ebd4 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -62,6 +62,15 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
+ * Force a quiescent state for preemptible RCU.
+ */
+void rcu_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_preempt_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Record a preemptable-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
@@ -713,6 +722,16 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
+ * Force a quiescent state for RCU, which, because there is no preemptible
+ * RCU, becomes the same as rcu-sched.
+ */
+void rcu_force_quiescent_state(void)
+{
+	rcu_sched_force_quiescent_state();
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Because preemptable RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
-- 
1.5.2.5

