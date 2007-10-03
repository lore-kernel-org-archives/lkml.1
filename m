Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbXJCVAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbXJCVAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbXJCVAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:00:34 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:39958 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXJCVAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:00:33 -0400
Subject: [PATCH] RCU torture update for preemption
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 16:59:51 -0400
Message-Id: <1191445191.11881.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

I ran your original preemption test of RCU torture, and after several
minutes, my preempt boost patch had one Preemption stall.  I then
disabled preemption boosting, and ran the preempt torture again, and it
seemed to never stall.  Something seemed strange, so I took a look.

Looks like you have a single thread that will run at max prio that runs
for 10 secs and then sleeps again. This thread seems to only push rcu
readers around. But it doesn't seem to do much else. That is a good test
to see if RCU readers can handle being pushed around, but it doesn't
test preemption boosting.

To do that, I modified the test to create CPUS-1 preempt boost hogs (or
1 if it is UP). But instead of putting it at max prio, I set it to the
lowest RT prio of 1. This way it's still at a higher priority than the
readers. I also switched the writers to run at 1+n where n increases for
every fake writer there is.

Without preempt boosting, after a couple of minutes I had 83 preemption
stalls.  When I turned my boosting back on, after several minutes (still
running as I type this) it has no preemption stalls.

This seems to be a good test for RCU preemption boosting.

-- Steve

PS. I got rid of your rcu_preeempt_task for rcu_preempt_tasks ;-)

(No the above is _not_ a typo)

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc9-rt1/kernel/rcutorture.c
===================================================================
--- linux-2.6.23-rc9-rt1.orig/kernel/rcutorture.c
+++ linux-2.6.23-rc9-rt1/kernel/rcutorture.c
@@ -54,6 +54,7 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck
 
 static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
 static int nfakewriters = 4;	/* # fake writer threads */
+static int npreempthogs = -1; 	/* # preempt hogs to run (defaults to ncpus-1) or 1 */
 static int stat_interval;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
 static int verbose;		/* Print more debug info. */
@@ -90,9 +91,11 @@ MODULE_PARM_DESC(torture_type, "Type of 
 static char printk_buf[4096];
 
 static int nrealreaders;
+static int nrealpreempthogs;
 static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
+static struct task_struct **rcu_preempt_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 
@@ -264,7 +267,6 @@ static void rcu_torture_deferred_free(st
 	call_rcu(&p->rtort_rcu, rcu_torture_cb);
 }
 
-static struct task_struct *rcu_preeempt_task;
 static unsigned long rcu_torture_preempt_errors;
 
 static int rcu_torture_preempt(void *arg)
@@ -274,7 +276,7 @@ static int rcu_torture_preempt(void *arg
 	time_t gcstart;
 	struct sched_param sp;
 
-	sp.sched_priority = MAX_RT_PRIO - 1;
+	sp.sched_priority = 1;
 	err = sched_setscheduler(current, SCHED_RR, &sp);
 	if (err != 0)
 		printk(KERN_ALERT "rcu_torture_preempt() priority err: %d\n",
@@ -297,24 +299,43 @@ static int rcu_torture_preempt(void *arg
 static long rcu_preempt_start(void)
 {
 	long retval = 0;
+	int i;
 
-	rcu_preeempt_task = kthread_run(rcu_torture_preempt, NULL,
-					"rcu_torture_preempt");
-	if (IS_ERR(rcu_preeempt_task)) {
-		VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
-		retval = PTR_ERR(rcu_preeempt_task);
-		rcu_preeempt_task = NULL;
+	rcu_preempt_tasks = kzalloc(nrealpreempthogs * sizeof(rcu_preempt_tasks[0]),
+				GFP_KERNEL);
+	if (rcu_preempt_tasks == NULL) {
+		VERBOSE_PRINTK_ERRSTRING("out of memory");
+		retval = -ENOMEM;
+		goto out;
 	}
+
+	for (i=0; i < nrealpreempthogs; i++) {
+		rcu_preempt_tasks[i] = kthread_run(rcu_torture_preempt, NULL,
+						"rcu_torture_preempt");
+		if (IS_ERR(rcu_preempt_tasks[i])) {
+			VERBOSE_PRINTK_ERRSTRING("Failed to create preempter");
+			retval = PTR_ERR(rcu_preempt_tasks[i]);
+			rcu_preempt_tasks[i] = NULL;
+			break;
+		}
+	}
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
@@ -613,10 +634,20 @@ rcu_torture_writer(void *arg)
 static int
 rcu_torture_fakewriter(void *arg)
 {
+	struct sched_param sp;
+	long id = (long) arg;
+	int err;
 	DEFINE_RCU_RANDOM(rand);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
-	set_user_nice(current, 19);
+	/*
+	 * Set up at a higher prio than the readers.
+	 */
+	sp.sched_priority = 1 + id;
+	err = sched_setscheduler(current, SCHED_RR, &sp);
+	if (err != 0)
+		printk(KERN_ALERT "rcu_torture_writer() priority err: %d\n",
+		       err);
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -849,9 +880,11 @@ rcu_torture_print_module_parms(char *tag
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
@@ -925,7 +958,7 @@ rcu_torture_cleanup(void)
 static int __init
 rcu_torture_init(void)
 {
-	int i;
+	long i;
 	int cpu;
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
@@ -953,6 +986,12 @@ rcu_torture_init(void)
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
@@ -1000,7 +1039,7 @@ rcu_torture_init(void)
 	}
 	for (i = 0; i < nfakewriters; i++) {
 		VERBOSE_PRINTK_STRING("Creating rcu_torture_fakewriter task");
-		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, NULL,
+		fakewriter_tasks[i] = kthread_run(rcu_torture_fakewriter, (void*)i,
 		                                  "rcu_torture_fakewriter");
 		if (IS_ERR(fakewriter_tasks[i])) {
 			firsterr = PTR_ERR(fakewriter_tasks[i]);


