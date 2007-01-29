Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXA2CLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXA2CLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 21:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXA2CLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 21:11:17 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:27837
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933090AbXA2CLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 21:11:16 -0500
Date: Sun, 28 Jan 2007 18:11:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linuxtronix.de,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       oleg@tv-sign.ru, twoerner.k@gmail.com, billh@gnuppy.monkey.org,
       nielsen.esben@googlemail.com, corbet@lwn.net
Subject: Re: [RFC PATCH -rt 2/2] RCU priority boosting additions to rcutorture
Message-ID: <20070129021126.GA8417@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070125021101.GA23428@linux.vnet.ibm.com> <20070125021444.GA22540@linux.vnet.ibm.com> <20070125022338.GB22540@linux.vnet.ibm.com> <45B86E88.6020209@kernel.org> <20070125180158.GC1705@linux.vnet.ibm.com> <45B8FFBB.4090307@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B8FFBB.4090307@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 11:06:35AM -0800, Josh Triplett wrote:
> Paul E. McKenney wrote:
> > On Thu, Jan 25, 2007 at 12:47:04AM -0800, Josh Triplett wrote:
> >> One major item: this new test feature really needs a new module parameter to
> >> enable or disable it.
> > 
> > CONFIG_PREEMPT_RCU_BOOST is the parameter -- if not set, then no test.
> > This parameter is provided by the accompanying RCU-boost patch.
> 
> It seems useful for rcutorture to use or not use the preempting thread
> independently of CONFIG_PREEMPT_RCU_BOOST.  That would bring you from two
> cases to four, and the two new cases both make sense:
> 
> * CONFIG_PREEMPT_RCU_BOOST=n, but run rcutorture with the preempting thread.
>   This configuration allows you to demonstrate the need for
>   CONFIG_PREEMPT_RCU_BOOST, by showing what happens when you need it and don't
>   have it.
> 
> * CONFIG_PREEMPT_RCU_BOOST=y, but run rcutorture without the preempting
>   thread.  This configuration allows you to test with rcutorture while running
>   a *real* real-time workload rather than the simple preempting thread, or
>   just test basic RCU functionality.
> 
> A simple boolean module_param would work here.

OK, am finally with you.  See below for updated patch.

> At some point, we may want to add the ability to run multiple preempting
> threads, but that doesn't need to happen for this patch.

Or to make it bounce around onto multiple CPUs, I suppose.  Leaving
these out for the moment.  ;-)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 14 deletions(-)

diff -urpNa -X dontdiff linux-2.6.20-rc4-rt1/kernel/rcutorture.c linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c
--- linux-2.6.20-rc4-rt1/kernel/rcutorture.c	2007-01-09 10:59:54.000000000 -0800
+++ linux-2.6.20-rc4-rt1-rcubtorture/kernel/rcutorture.c	2007-01-26 22:16:13.000000000 -0800
@@ -58,6 +58,7 @@ static int stat_interval;	/* Interval be
 static int verbose;		/* Print more debug info. */
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
+static int preempt_torture = 0;	/* Realtime task preempts torture readers. */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0);
@@ -72,6 +73,8 @@ module_param(test_no_idle_hz, bool, 0);
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(shuffle_interval, int, 0);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+module_param(preempt_torture, bool, 0);
+MODULE_PARM_DESC(preempt_torture, "Enable realtime preemption torture");
 module_param(torture_type, charp, 0);
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
+	return NULL;
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
 
@@ -362,28 +423,23 @@ static void rcu_bh_torture_synchronize(v
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
 
@@ -495,14 +551,12 @@ static void sched_torture_synchronize(vo
 
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
 
@@ -801,9 +855,10 @@ rcu_torture_print_module_parms(char *tag
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
@@ -856,6 +911,8 @@ rcu_torture_cleanup(void)
 		kthread_stop(stats_task);
 	}
 	stats_task = NULL;
+	if (preempt_torture && (cur_ops->preemptend != NULL))
+		cur_ops->preemptend();
 
 	/* Wait for all RCU callbacks to fire.  */
 	rcu_barrier();
@@ -997,6 +1054,11 @@ rcu_torture_init(void)
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
