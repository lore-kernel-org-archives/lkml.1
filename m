Return-Path: <linux-kernel-owner+w=401wt.eu-S1758307AbYFYTZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbYFYTZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbYFYTZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:25:09 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50960 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFYTZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:25:07 -0400
Date: Wed, 25 Jun 2008 12:24:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, josh@freedesktop.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: [PATCH -tip-rcu] Make rcutorture more vicious: invoke RCU readers from irq handlers (timers)
Message-ID: <20080625192452.GA12754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com> <20080622200638.GA25328@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080622200638.GA25328@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows torturing RCU from irq handlers (timers, in this case).
A new module parameter irqreader enables such additional torturing,
and is enabled by default.  Variants of RCU that do not tolerate readers
being called from irq handlers (e.g., SRCU) ignore irqreader.

(No failures observed, but only short tests thus far.  And no failures
observed thus far from about 10 hours of running stock rcutorture in
parallel with 170 kernel builds on a two-CPU machine.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 Documentation/RCU/torture.txt |   23 +++++++------
 kernel/rcutorture.c           |   74 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 13 deletions(-)

diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut4-procqp/Documentation/RCU/torture.txt linux-2.6.26-rc4-rcut5-timer/Documentation/RCU/torture.txt
--- linux-2.6.26-rc4-rcut4-procqp/Documentation/RCU/torture.txt	2008-06-22 10:29:04.000000000 -0700
+++ linux-2.6.26-rc4-rcut5-timer/Documentation/RCU/torture.txt	2008-06-25 11:44:51.000000000 -0700
@@ -30,10 +30,10 @@ MODULE PARAMETERS
 
 This module has the following parameters:
 
-nreaders	This is the number of RCU reading threads supported.
-		The default is twice the number of CPUs.  Why twice?
-		To properly exercise RCU implementations with preemptible
-		read-side critical sections.
+irqreaders	Says to invoke RCU readers from irq level.  This is currently
+		done via timers.  Defaults to "1" for variants of RCU that
+		permit this.  (Or, more accurately, variants of RCU that do
+		-not- permit this know to ignore this variable.)
 
 nfakewriters	This is the number of RCU fake writer threads to run.  Fake
 		writer threads repeatedly use the synchronous "wait for
@@ -44,6 +44,16 @@ nfakewriters	This is the number of RCU f
 		to trigger special cases caused by multiple writers, such as
 		the synchronize_srcu() early return optimization.
 
+nreaders	This is the number of RCU reading threads supported.
+		The default is twice the number of CPUs.  Why twice?
+		To properly exercise RCU implementations with preemptible
+		read-side critical sections.
+
+shuffle_interval
+		The number of seconds to keep the test threads affinitied
+		to a particular subset of the CPUs, defaults to 3 seconds.
+		Used in conjunction with test_no_idle_hz.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
@@ -51,11 +61,6 @@ stat_interval	The number of seconds betw
 		be printed -only- when the module is unloaded, and this
 		is the default.
 
-shuffle_interval
-		The number of seconds to keep the test threads affinitied
-		to a particular subset of the CPUs, defaults to 3 seconds.
-		Used in conjunction with test_no_idle_hz.
-
 stutter		The length of time to run the test before pausing for this
 		same period of time.  Defaults to "stutter=5", so as
 		to run and pause for (roughly) five-second intervals.
diff -urpNa -X dontdiff linux-2.6.26-rc4-rcut4-procqp/kernel/rcutorture.c linux-2.6.26-rc4-rcut5-timer/kernel/rcutorture.c
--- linux-2.6.26-rc4-rcut4-procqp/kernel/rcutorture.c	2008-06-25 11:39:58.000000000 -0700
+++ linux-2.6.26-rc4-rcut5-timer/kernel/rcutorture.c	2008-06-25 11:47:14.000000000 -0700
@@ -59,6 +59,7 @@ static int verbose;		/* Print more debug
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
+static int irqreader = 1;	/* RCU readers from irq (timers). */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -75,6 +76,8 @@ module_param(shuffle_interval, int, 0444
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
 module_param(stutter, int, 0444);
 MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
+module_param(irqreader, int, 0444);
+MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -121,6 +124,7 @@ static atomic_t n_rcu_torture_alloc_fail
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
+static long n_rcu_torture_timers = 0;
 static struct list_head rcu_torture_removed;
 
 static int stutter_pause_test = 0;
@@ -216,6 +220,7 @@ struct rcu_torture_ops {
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
 	int (*stats)(char *page);
+	int irqcapable;
 	char *name;
 };
 static struct rcu_torture_ops *cur_ops = NULL;
@@ -289,6 +294,7 @@ static struct rcu_torture_ops rcu_ops = 
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu"
 };
 
@@ -328,6 +334,7 @@ static struct rcu_torture_ops rcu_sync_o
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_sync"
 };
 
@@ -388,6 +395,7 @@ static struct rcu_torture_ops rcu_bh_ops
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_bh"
 };
 
@@ -401,6 +409,7 @@ static struct rcu_torture_ops rcu_bh_syn
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_bh_sync"
 };
 
@@ -520,6 +529,7 @@ static struct rcu_torture_ops sched_ops 
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = sched_torture_synchronize,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "sched"
 };
 
@@ -594,6 +604,52 @@ rcu_torture_fakewriter(void *arg)
 }
 
 /*
+ * RCU torture reader from timer handler.  Dereferences rcu_torture_current,
+ * incrementing the corresponding element of the pipeline array.  The
+ * counter in the element should never be greater than 1, otherwise, the
+ * RCU implementation is broken.
+ */
+static void rcu_torture_timer(unsigned long unused)
+{
+	int idx;
+	int completed;
+	static DEFINE_RCU_RANDOM(rand);
+	static DEFINE_SPINLOCK(rand_lock);
+	struct rcu_torture *p;
+	int pipe_count;
+
+	idx = cur_ops->readlock();
+	completed = cur_ops->completed();
+	p = rcu_dereference(rcu_torture_current);
+	if (p == NULL) {
+		/* Leave because rcu_torture_writer is not yet underway */
+		cur_ops->readunlock(idx);
+		return;
+	}
+	if (p->rtort_mbtest == 0)
+		atomic_inc(&n_rcu_torture_mberror);
+	spin_lock(&rand_lock);
+	cur_ops->readdelay(&rand);
+	n_rcu_torture_timers++;
+	spin_unlock(&rand_lock);
+	preempt_disable();
+	pipe_count = p->rtort_pipe_count;
+	if (pipe_count > RCU_TORTURE_PIPE_LEN) {
+		/* Should not happen, but... */
+		pipe_count = RCU_TORTURE_PIPE_LEN;
+	}
+	++__get_cpu_var(rcu_torture_count)[pipe_count];
+	completed = cur_ops->completed() - completed;
+	if (completed > RCU_TORTURE_PIPE_LEN) {
+		/* Should not happen, but... */
+		completed = RCU_TORTURE_PIPE_LEN;
+	}
+	++__get_cpu_var(rcu_torture_batch)[completed];
+	preempt_enable();
+	cur_ops->readunlock(idx);
+}
+
+/*
  * RCU torture reader kthread.  Repeatedly dereferences rcu_torture_current,
  * incrementing the corresponding element of the pipeline array.  The
  * counter in the element should never be greater than 1, otherwise, the
@@ -607,11 +663,18 @@ rcu_torture_reader(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 	struct rcu_torture *p;
 	int pipe_count;
+	struct timer_list t;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
+	if (irqreader && cur_ops->irqcapable)
+		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
 	do {
+		if (irqreader && cur_ops->irqcapable) {
+			if (!timer_pending(&t))
+				mod_timer(&t, 1);
+		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
 		p = rcu_dereference(rcu_torture_current);
@@ -643,6 +706,8 @@ rcu_torture_reader(void *arg)
 		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
+	if (irqreader && cur_ops->irqcapable)
+		del_timer_sync(&t);
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
@@ -673,14 +738,15 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d",
+		       "rtmbe: %d nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free),
-		       atomic_read(&n_rcu_torture_mberror));
+		       atomic_read(&n_rcu_torture_mberror),
+		       n_rcu_torture_timers);
 	if (atomic_read(&n_rcu_torture_mberror) != 0)
 		cnt += sprintf(&page[cnt], " !!!");
 	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
@@ -835,10 +901,10 @@ rcu_torture_print_module_parms(char *tag
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval=%d stutter=%d\n",
+		"shuffle_interval=%d stutter=%d irqreader=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter);
+		stutter, irqreader);
 }
 
 static void
