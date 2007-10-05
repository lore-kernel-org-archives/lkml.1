Return-Path: <linux-kernel-owner+w=401wt.eu-S1762636AbXJEMvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762636AbXJEMvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJEMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:51:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57541 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXJEMvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:51:04 -0400
Date: Fri, 5 Oct 2007 05:51:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] RCU torture update for preemption
Message-ID: <20071005125100.GC22034@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1191445191.11881.33.camel@localhost.localdomain> <20071005033458.GA23372@linux.vnet.ibm.com> <Pine.LNX.4.58.0710050813580.20859@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0710050813580.20859@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 08:21:49AM -0400, Steven Rostedt wrote:
> 
> On Thu, 4 Oct 2007, Paul E. McKenney wrote:
> 
> > On Wed, Oct 03, 2007 at 04:59:51PM -0400, Steven Rostedt wrote:
> > >
> > > PS. I got rid of your rcu_preeempt_task for rcu_preempt_tasks ;-)
> > >
> > > (No the above is _not_ a typo)
> >
> > :-/
> 
> I thought it was some mind bender thing ;-)

Well, it would indeed appear that my mind was bent...

> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > >
> > > Index: linux-2.6.23-rc9-rt1/kernel/rcutorture.c
> > > ===================================================================
> > > --- linux-2.6.23-rc9-rt1.orig/kernel/rcutorture.c
> > > +++ linux-2.6.23-rc9-rt1/kernel/rcutorture.c
> > > @@ -54,6 +54,7 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck
> > >
> > >  static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
> > >  static int nfakewriters = 4;	/* # fake writer threads */
> > > +static int npreempthogs = -1; 	/* # preempt hogs to run (defaults to ncpus-1) or 1 */
> > >  static int stat_interval;	/* Interval between stats, in seconds. */
> > >  				/*  Defaults to "only at end of test". */
> > >  static int verbose;		/* Print more debug info. */
> > > @@ -90,9 +91,11 @@ MODULE_PARM_DESC(torture_type, "Type of
> > >  static char printk_buf[4096];
> > >
> > >  static int nrealreaders;
> > > +static int nrealpreempthogs;
> >
> > I made the above be a module parameter.  This OK?
> 
> That is definitely OK. I simply forgot to do it myself.

Fair enough!

> > >  static int rcu_preempt_stats(char *page)
> > > @@ -613,10 +634,20 @@ rcu_torture_writer(void *arg)
> > >  static int
> > >  rcu_torture_fakewriter(void *arg)
> > >  {
> > > +	struct sched_param sp;
> > > +	long id = (long) arg;
> > > +	int err;
> > >  	DEFINE_RCU_RANDOM(rand);
> > >
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> > > -	set_user_nice(current, 19);
> > > +	/*
> > > +	 * Set up at a higher prio than the readers.
> > > +	 */
> > > +	sp.sched_priority = 1 + id;
> > > +	err = sched_setscheduler(current, SCHED_RR, &sp);
> > > +	if (err != 0)
> > > +		printk(KERN_ALERT "rcu_torture_writer() priority err: %d\n",
> > > +		       err);
> >
> > The idea here is to force inheritance, to force the writer to continue
> > pushing grace periods even when the hogs are running, or both?
> 
> The idea is to push inheritance. As my method of RCU priority boosting
> has the readers inherit the priority of synchronize_rcu caller. If the
> caller is of lower priority than the hog, then it doesn't make much sense,
> since nothing will happen. I'm assuming that RT system designers know what
> they are doing when setting up high priority tasks. If they starve RCU
> grace periods, it's their own fault.

OK, got it -- not needed in conjunction with my priority-boost mechanism.
(Though I do very much like the idea of high-priority synchronize_rcu()
invocations speeding up grace periods -- in fact, am considering
accelerating the detection mechanism in this case.  But later.)

> > >  	do {
> > >  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> > > @@ -849,9 +880,11 @@ rcu_torture_print_module_parms(char *tag
> > >  {
> > >  	printk(KERN_ALERT "%s" TORTURE_FLAG
> > >  		"--- %s: nreaders=%d nfakewriters=%d "
> > > +	        "npreempthogs=%d "
> > >  		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
> > >  		"shuffle_interval=%d preempt_torture=%d\n",
> > >  		torture_type, tag, nrealreaders, nfakewriters,
> > > +		nrealpreempthogs,
> > >  		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
> > >  		preempt_torture);
> > >  }
> > > @@ -925,7 +958,7 @@ rcu_torture_cleanup(void)
> > >  static int __init
> > >  rcu_torture_init(void)
> > >  {
> > > -	int i;
> > > +	long i;
> > >  	int cpu;
> > >  	int firsterr = 0;
> > >  	static struct rcu_torture_ops *torture_ops[] =
> > > @@ -953,6 +986,12 @@ rcu_torture_init(void)
> > >  	rcu_torture_print_module_parms("Start of test");
> > >  	fullstop = 0;
> > >
> > > +	if (npreempthogs >= 0)
> > > +		nrealpreempthogs = npreempthogs;
> > > +	else
> > > +		nrealpreempthogs = num_online_cpus() == 1 ? 1 :
> > > +			num_online_cpus() - 1;
> >
> > OK -- the idea here is to leave at least one CPU to respond to keyboard
> > and mouse?  I end up with all the readers getting shoved to the left-over
> 
> Yeah, I was nervious about locking up the test, and being able to do
> anything.
> 
> > CPU.  I am experimenting with ways of synchronizing the hogs and also
> > allowing synchronized idle time...
> 
> Thanks, I'd like to have a semi hog on each CPU.

OK, seems to be at least limping, see patch below.  (But you will want
to add the high priority to the writers for your RCU priority-boost
mechanism.)

> PS. I've incorporated this and my version of the RCU Preempt Boost into
> the latest -rt patch. It's labeled as experimental so we can always pull
> it. Have you had a chance to look at some of my changes.
> 
> I'll be going out of town today so I wont be answering emails till Monday.

:-/  We overlap exactly...

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |   67 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 19 deletions(-)

diff -urpNa -X dontdiff linux-2.6.22-i-cleanups/kernel/rcutorture.c linux-2.6.22-j-rostedtrt/kernel/rcutorture.c
--- linux-2.6.22-i-cleanups/kernel/rcutorture.c	2007-09-09 16:58:35.000000000 -0700
+++ linux-2.6.22-j-rostedtrt/kernel/rcutorture.c	2007-10-05 04:50:24.000000000 -0700
@@ -53,6 +53,7 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
+static int npreempthogs = -1; 	/* # preempt hogs to run (defaults to ncpus-1) or 1 */
 static int stat_interval;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
 static int verbose;		/* Print more debug info. */
@@ -65,6 +66,8 @@ module_param(nreaders, int, 0444);
 MODULE_PARM_DESC(nreaders, "Number of RCU reader threads");
 module_param(nfakewriters, int, 0444);
 MODULE_PARM_DESC(nfakewriters, "Number of RCU fake writer threads");
+module_param(npreempthogs, int, 0444);
+MODULE_PARM_DESC(npreempthogs, "Number of preemption hog threads to run");
 module_param(stat_interval, int, 0444);
 MODULE_PARM_DESC(stat_interval, "Number of seconds between stats printk()s");
 module_param(verbose, bool, 0444);
@@ -89,9 +92,11 @@ MODULE_PARM_DESC(torture_type, "Type of 
 static char printk_buf[4096];
 
 static int nrealreaders;
+static int nrealpreempthogs;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
+static struct task_struct **rcu_preempt_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 
@@ -263,17 +268,15 @@ static void rcu_torture_deferred_free(st
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
 }
 
-static struct task_struct *rcu_preeempt_task;
 static unsigned long rcu_torture_preempt_errors;
 
 static int rcu_torture_preempt(void *arg)
 {
 	int completedstart;
 	int err;
-	time_t gcstart;
 	struct sched_param sp;
 
-	sp.sched_priority = MAX_RT_PRIO - 1;
+	sp.sched_priority = 1;
 	err = sched_setscheduler(current, SCHED_RR, &sp);
 	if (err != 0)
 		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
@@ -282,13 +285,12 @@ static int rcu_torture_preempt(void *arg
 
 	do {
 		completedstart = rcu_torture_completed();
-		gcstart = xtime.tv_sec;
-		while ((xtime.tv_sec - gcstart < 10) &&
-		       (rcu_torture_completed() == completedstart))
+		while (((xtime.tv_sec & 0xf) < 7) &&
+		       ((rcu_torture_completed() - completedstart) < 2))
 			cond_resched();
 		if (rcu_torture_completed() == completedstart)
 			rcu_torture_preempt_errors++;
-		schedule_timeout_interruptible(1);
+		schedule_timeout_interruptible(10 * HZ);
 	} while (!kthread_should_stop());
 	return 0;
 }
@@ -296,24 +298,43 @@ static int rcu_torture_preempt(void *arg
 static long rcu_preempt_start(void)
 {
 	long retval = 0;
+	int i;
+
+	rcu_preempt_tasks = kzalloc(nrealpreempthogs * sizeof(rcu_preempt_tasks[0]),
+				GFP_KERNEL);
+	if (rcu_preempt_tasks == NULL) {
+		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		retval = -ENOMEM;
+		goto out;
+	}
 
-	rcu_preeempt_task = kthread_run(rcu_torture_preempt, NULL,
-					"rcu_torture_preempt");
-	if (IS_ERR(rcu_preeempt_task)) {
-		VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
-		retval = PTR_ERR(rcu_preeempt_task);
-		rcu_preeempt_task = NULL;
+	for (i=0; i < nrealpreempthogs; i++) {
+		rcu_preempt_tasks[i] = kthread_run(rcu_torture_preempt, NULL,
+						"rcu_torture_preempt");
+		if (IS_ERR(rcu_preempt_tasks[i])) {
+			VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
+			retval = PTR_ERR(rcu_preempt_tasks[i]);
+			rcu_preempt_tasks[i] = NULL;
+			break;
+		}
 	}
+ out:
 	return retval;
 }
 
 static void rcu_preempt_end(void)
 {
-	if (rcu_preeempt_task != NULL) {
-		VERBOSE_PRINTK_STRING("Stopping rcu_preempt task");
-		kthread_stop(rcu_preeempt_task);
+	int i;
+	if (rcu_preempt_tasks) {
+		for (i=0; i < nrealpreempthogs; i++) {
+			if (rcu_preempt_tasks[i] != NULL) {
+				VERBOSE_PRINTK_STRING("Stopping rcu_preempt task");
+				kthread_stop(rcu_preempt_tasks[i]);
+			}
+			rcu_preempt_tasks[i] = NULL;
+		}
+		kfree(rcu_preempt_tasks);
 	}
-	rcu_preeempt_task = NULL;
 }
 
 static int rcu_preempt_stats(char *page)
@@ -847,9 +868,11 @@ rcu_torture_print_module_parms(char *tag
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
+	        "npreempthogs=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
 		"shuffle_interval=%d preempt_torture=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
+		nrealpreempthogs,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
 		preempt_torture);
 }
@@ -923,7 +946,7 @@ rcu_torture_cleanup(void)
 static int __init
 rcu_torture_init(void)
 {
-	int i;
+	long i;
 	int cpu;
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
@@ -951,6 +974,12 @@ rcu_torture_init(void)
 	rcu_torture_print_module_parms("Start of test");
 	fullstop = 0;
 
+	if (npreempthogs >= 0)
+		nrealpreempthogs = npreempthogs;
+	else
+		nrealpreempthogs = num_online_cpus() == 1 ? 1 :
+			num_online_cpus() - 1;
+
 	/* Set up the freelist. */
 
 	INIT_LIST_HEAD(&rcu_torture_freelist);
@@ -998,7 +1027,7 @@ rcu_torture_init(void)
 	}
 	for (i = 0; i < nfakewriters; i++) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
-		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
+		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, (void*)i,
 		                                  "rcu_torture_fakewriter");
 		if (IS_ERR(fakewriter_tasks[i])) {
 			firsterr = PTR_ERR(fakewriter_tasks[i]);
