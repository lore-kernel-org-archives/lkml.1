Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYFRMXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYFRMXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYFRMXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:23:12 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:43832 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYFRMXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:23:11 -0400
Date: Wed, 18 Jun 2008 05:21:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: [PATCH] Make rcutorture more vicious: add stutter feature
Message-ID: <20080618122144.GA27143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patch takes a step towards making rcutorture more brutal by allowing
the test to be automatically periodically paused, with the default being
to run the test for five seconds then pause for five seconds and repeat.
This behavior can be controlled using a new "stutter" module parameter, so
that "stutter=0" gives the old default behavior of running continuously.

Starting and stopping rcutorture more heavily stresses RCU's interaction
with the scheduler, as well as exercising more paths through the
grace-period detection code.

Note that the default to "shuffle_interval" has also been adjusted from
5 seconds to 3 seconds to provide varying overlap with the "stutter"
interval.

I am still unable to provoke the failures that Alexey has been seeing,
even with this patch, but will be doing a few additional things to beef
up rcutorture.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/torture.txt |    8 ++++-
 kernel/rcutorture.c           |   59 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 63 insertions(+), 4 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4/Documentation/RCU/torture.txt linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt
--- linux-2.6.26-rc4/Documentation/RCU/torture.txt	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.26-rc4-rcut1-stutter/Documentation/RCU/torture.txt	2008-06-18 05:15:43.000000000 -0700
@@ -46,9 +46,15 @@ stat_interval	The number of seconds betw
 
 shuffle_interval
 		The number of seconds to keep the test threads affinitied
-		to a particular subset of the CPUs, defaults to 5 seconds.
+		to a particular subset of the CPUs, defaults to 3 seconds.
 		Used in conjunction with test_no_idle_hz.
 
+stutter		The length of time to run the test before pausing for this
+		same period of time.  Defaults to "stutter=5", so as
+		to run and pause for (roughly) five-second intervals.
+		Specifying "stutter=0" causes the test to run continuously
+		without pausing, which is the old default behavior.
+
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
 		idle CPUs.  Boolean parameter, "1" to test, "0" otherwise.
diff -urpNa -X dontdiff linux-2.6.26-rc4/kernel/rcutorture.c linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c
--- linux-2.6.26-rc4/kernel/rcutorture.c	2008-05-30 04:39:01.000000000 -0700
+++ linux-2.6.26-rc4-rcut1-stutter/kernel/rcutorture.c	2008-06-18 04:54:41.000000000 -0700
@@ -57,7 +57,8 @@ static int stat_interval;	/* Interval be
 				/*  Defaults to "only at end of test". */
 static int verbose;		/* Print more debug info. */
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
-static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
+static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
+static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -72,6 +73,8 @@ module_param(test_no_idle_hz, bool, 0444
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+module_param(stutter, int, 0444);
+MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -91,6 +94,7 @@ static struct task_struct **fakewriter_t
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
+static struct task_struct *stutter_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -119,6 +123,8 @@ static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
 static struct list_head rcu_torture_removed;
 
+static int stutter_pause_test = 0;
+
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -179,6 +185,13 @@ rcu_random(struct rcu_random_state *rrsp
 	return swahw32(rrsp->rrs_state);
 }
 
+static void
+rcu_stutter_wait(void)
+{
+	while (stutter_pause_test)
+		schedule_timeout_interruptible(1);
+}
+
 /*
  * Operations vector for selecting different types of tests.
  */
@@ -537,6 +550,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())
@@ -560,6 +574,7 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
@@ -615,6 +630,7 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	while (!kthread_should_stop())
@@ -785,15 +801,34 @@ rcu_torture_shuffle(void *arg)
 	return 0;
 }
 
+/* Cause the rcutorture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int
+rcu_torture_stutter(void *arg)
+{
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
+	do {
+		schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 1;
+		if (!kthread_should_stop())
+			schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 0;
+	} while (!kthread_should_stop());
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
+	return 0;
+}
+
 static inline void
 rcu_torture_print_module_parms(char *tag)
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval = %d\n",
+		"shuffle_interval=%d stutter=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval);
+		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		stutter);
 }
 
 static void
@@ -802,6 +837,11 @@ rcu_torture_cleanup(void)
 	int i;
 
 	fullstop = 1;
+	if (stutter_task) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
+		kthread_stop(stutter_task);
+	}
+	stutter_task = NULL;
 	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
@@ -988,6 +1028,19 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (stutter < 0)
+		stutter = 0;
+	if (stutter) {
+		/* Create the stutter thread */
+		stutter_task = kthread_run(rcu_torture_stutter, NULL,
+					  "rcu_torture_stutter");
+		if (IS_ERR(stutter_task)) {
+			firsterr = PTR_ERR(stutter_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
+			stutter_task = NULL;
+			goto unwind;
+		}
+	}
 	return 0;
 
 unwind:
