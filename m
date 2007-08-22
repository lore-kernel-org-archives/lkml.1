Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbXHVTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbXHVTsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932383AbXHVTsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:48:24 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35302 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932360AbXHVTsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:48:22 -0400
Date: Wed, 22 Aug 2007 12:48:19 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, tglx@linutronix.de, ego@in.ibm.com
Subject: [PATCH RFC] rcutorture for priority boosting for preemptible RCU
Message-ID: <20070822194819.GA8399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies rcutorture to also torture RCU priority boosting.
Tested for some hours on x86_64 and POWER, so OK for experimentation,
but not ready for inclusion.

Patches yet to come include making the priority-boost task more
power-consumption friendly and some cleanup patches.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 14 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22-f-boost/kernel/rcutorture.c linux-2.6.22-g-boosttorture/kernel/rcutorture.c
--- linux-2.6.22-f-boost/kernel/rcutorture.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22-g-boosttorture/kernel/rcutorture.c	2007-08-21 10:58:18.000000000 -0700
@@ -58,6 +58,7 @@ static int stat_interval;	/* Interval be
 static int verbose;		/* Print more debug info. */
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
+static int preempt_torture = 0;	/* Realtime task preempts torture readers. */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -72,6 +73,8 @@ module_param(test_no_idle_hz, bool, 0444
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+module_param(preempt_torture, bool, 0444);
+MODULE_PARM_DESC(preempt_torture, "Enable realtime preemption torture");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -194,6 +197,8 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
+	long (*preemptstart)(void);
+	void (*preemptend)(void);
 	int (*stats)(char *page);
 	char *name;
 };
@@ -258,16 +263,74 @@ static void rcu_torture_deferred_free(st
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
 }
 
+static struct task_struct *rcu_preeempt_task;
+static unsigned long rcu_torture_preempt_errors = 0;
+
+static int rcu_torture_preempt(void *arg)
+{
+	int completedstart;
+	int err;
+	time_t gcstart;
+	struct sched_param sp;
+
+	sp.sched_priority = MAX_RT_PRIO - 1;
+	err = sched_setscheduler(current, SCHED_RR, &sp);
+	if (err != 0)
+		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
+		       err);
+	current->flags |= PF_NOFREEZE;
+
+	do {
+		completedstart = rcu_torture_completed();
+		gcstart = xtime.tv_sec;
+		while ((xtime.tv_sec - gcstart < 10) &&
+		       (rcu_torture_completed() == completedstart))
+			cond_resched();
+		if (rcu_torture_completed() == completedstart)
+			rcu_torture_preempt_errors++;
+		schedule_timeout_interruptible(HZ);
+	} while (!kthread_should_stop());
+	return 0;
+}
+
+static long rcu_preempt_start(void)
+{
+	long retval = 0;
+
+	rcu_preeempt_task = kthread_run(rcu_torture_preempt, NULL,
+					"rcu_torture_preempt");
+	if (IS_ERR(rcu_preeempt_task)) {
+		VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
+		retval = PTR_ERR(rcu_preeempt_task);
+		rcu_preeempt_task = NULL;
+	}
+	return retval;
+}
+
+static void rcu_preempt_end(void)
+{
+	if (rcu_preeempt_task != NULL) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_preempt task");
+		kthread_stop(rcu_preeempt_task);
+	}
+	rcu_preeempt_task = NULL;
+}
+
+static int rcu_preempt_stats(char *page) {
+	return sprintf(page,
+		       "Preemption stalls: %lu\n", rcu_torture_preempt_errors);
+}
+
 static struct rcu_torture_ops rcu_ops = {
-	.init = NULL,
-	.cleanup = NULL,
 	.readlock = rcu_torture_read_lock,
 	.readdelay = rcu_read_delay,
 	.readunlock = rcu_torture_read_unlock,
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
-	.stats = NULL,
+	.preemptstart = rcu_preempt_start,
+	.preemptend = rcu_preempt_end,
+	.stats = rcu_preempt_stats,
 	.name = "rcu"
 };
 
@@ -299,14 +362,12 @@ static void rcu_sync_torture_init(void)
 
 static struct rcu_torture_ops rcu_sync_ops = {
 	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
 	.readlock = rcu_torture_read_lock,
 	.readdelay = rcu_read_delay,
 	.readunlock = rcu_torture_read_unlock,
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
-	.stats = NULL,
 	.name = "rcu_sync"
 };
 
@@ -358,28 +419,23 @@ static void rcu_bh_torture_synchronize(v
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
-	.init = NULL,
-	.cleanup = NULL,
 	.readlock = rcu_bh_torture_read_lock,
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = rcu_bh_torture_read_unlock,
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
-	.stats = NULL,
 	.name = "rcu_bh"
 };
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
 	.readlock = rcu_bh_torture_read_lock,
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = rcu_bh_torture_read_unlock,
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
-	.stats = NULL,
 	.name = "rcu_bh_sync"
 };
 
@@ -491,14 +547,12 @@ static void sched_torture_synchronize(vo
 
 static struct rcu_torture_ops sched_ops = {
 	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
 	.readlock = sched_torture_read_lock,
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = sched_torture_read_unlock,
 	.completed = sched_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = sched_torture_synchronize,
-	.stats = NULL,
 	.name = "sched"
 };
 
@@ -793,9 +847,10 @@ rcu_torture_print_module_parms(char *tag
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval = %d\n",
+		"shuffle_interval=%d preempt_torture=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval);
+		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		preempt_torture);
 }
 
 static void
@@ -848,6 +903,8 @@ rcu_torture_cleanup(void)
 		kthread_stop(stats_task);
 	}
 	stats_task = NULL;
+	if (preempt_torture && (cur_ops->preemptend != NULL))
+		cur_ops->preemptend();
 
 	/* Wait for all RCU callbacks to fire.  */
 	rcu_barrier();
@@ -990,6 +1047,11 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (preempt_torture && (cur_ops->preemptstart != NULL)) {
+		firsterr = cur_ops->preemptstart();
+		if (firsterr != 0)
+			goto unwind;
+	}
 	return 0;
 
 unwind:
