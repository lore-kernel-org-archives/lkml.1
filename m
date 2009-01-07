Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbZAGWrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbZAGWrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZAGWrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:47:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51541 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZAGWrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:47:21 -0500
Date: Wed, 7 Jan 2009 14:47:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, snakebyte@gmx.de, josh@freedesktop.org,
       dipankar@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       kamalesh@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH -tip] Fix bug in rcutorture system-shutdown code
Message-ID: <20090107224719.GI6900@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090107223048.GA19903@linux.vnet.ibm.com> <20090107223538.GC27629@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107223538.GC27629@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 11:35:38PM +0100, Ingo Molnar wrote:
> 
> hm, doesnt apply to latest tip/master:
> 
> 4 out of 11 hunks FAILED -- rejects in file kernel/rcutorture.c
> 
> probably due to:
> 
>  c59ab97: rcu: fix rcutorture bug
> 
> which was an earlier fix i picked up. (already upstream)

Ah!  My apologies -- here is a patch that takes that fix into account.

							Thanx, Paul

This patch fixes an rcutorture bug found by Eric Sesterhenn that
resulted in oopses in response to "rmmod rcutorture".  The problem
was in some new code that attempted to handle the case where a system
is shut down while rcutorture is still running, for example, when
rcutorture is built into the kernel so that it cannot be removed.
The fix causes the rcutorture threads to "park" in an
schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT) rather than
trying to get them to terminate cleanly.  Concurrent shutdown and
rmmod is illegal.

I believe that this is 2.6.29 material, as it is used in some testing
setups.

For reference, here are the rcutorture operating modes:

CONFIG_RCU_TORTURE_TEST=m

	This is the normal rcutorture build.  Use "modprobe rcutorture"
	(with optional arguments) to start, and "rmmod rcutorture" to
	stop.  If you shut the system down without doing the rmmod, you
	should see console output like:

	rcutorture thread rcu_torture_writer parking due to system shutdown

	One for each rcutorture kthread.

CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=n

	Use this if you want rcutorture built in, but don't want the
	test to start running during early boot.  To start the
	torturing:

		echo 1 > /proc/sys/kernel/rcutorture_runnable

	To stop the torturing, s/1/0/

	You will get "parking" console messages as noted above when
	you shut the system down.

CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y

	Same as above, except that the torturing starts during early
	boot.  Only for the stout of heart and strong of stomach.
	The same /proc entry noted above may be used to control the
	test.

Located-by: Eric Sesterhenn <snakebyte@gmx.de>
Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rcutorture.c |  113 +++++++++++++++++++++++++++++++++++------------------------
 1 file changed, 68 insertions(+), 45 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 1cff28d..7c4142a 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -136,29 +136,47 @@ static int stutter_pause_test = 0;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
-#define FULLSTOP_SHUTDOWN 1	/* Bail due to system shutdown/panic. */
-#define FULLSTOP_CLEANUP  2	/* Orderly shutdown. */
-static int fullstop;		/* stop generating callbacks at test end. */
-DEFINE_MUTEX(fullstop_mutex);	/* protect fullstop transitions and */
-				/*  spawning of kthreads. */
+/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
+
+#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
+#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
+#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
+static int fullstop = FULLSTOP_RMMOD;
+DEFINE_MUTEX(fullstop_mutex);	/* Protect fullstop transitions and spawning */
+				/*  of kthreads. */
 
 /*
- * Detect and respond to a signal-based shutdown.
+ * Detect and respond to a system shutdown.
  */
 static int
 rcutorture_shutdown_notify(struct notifier_block *unused1,
 			   unsigned long unused2, void *unused3)
 {
-	if (fullstop)
-		return NOTIFY_DONE;
 	mutex_lock(&fullstop_mutex);
-	if (!fullstop)
+	if (fullstop == FULLSTOP_DONTSTOP)
 		fullstop = FULLSTOP_SHUTDOWN;
+	else
+		printk(KERN_WARNING /* but going down anyway, so... */
+		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
 }
 
 /*
+ * Absorb kthreads into a kernel function that won't return, so that
+ * they won't ever access module text or data again.
+ */
+static void rcutorture_shutdown_absorb(char *title)
+{
+	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
+		printk(KERN_NOTICE
+		       "rcutorture thread %s parking due to system shutdown\n",
+		       title);
+		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
+	}
+}
+
+/*
  * Allocate an element from the rcu_tortures pool.
  */
 static struct rcu_torture *
@@ -219,13 +237,14 @@ rcu_random(struct rcu_random_state *rrsp)
 }
 
 static void
-rcu_stutter_wait(void)
+rcu_stutter_wait(char *title)
 {
-	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
+	while (stutter_pause_test || !rcutorture_runnable) {
 		if (rcutorture_runnable)
 			schedule_timeout_interruptible(1);
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+		rcutorture_shutdown_absorb(title);
 	}
 }
 
@@ -287,7 +306,7 @@ rcu_torture_cb(struct rcu_head *p)
 	int i;
 	struct rcu_torture *rp = container_of(p, struct rcu_torture, rtort_rcu);
 
-	if (fullstop) {
+	if (fullstop != FULLSTOP_DONTSTOP) {
 		/* Test is ending, just drop callbacks on the floor. */
 		/* The next initialization will pick up the pieces. */
 		return;
@@ -619,10 +638,11 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_writer");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	rcutorture_shutdown_absorb("rcu_torture_writer");
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -643,11 +663,12 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_fakewriter");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -752,12 +773,13 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
-		rcu_stutter_wait();
-	} while (!kthread_should_stop() && !fullstop);
+		rcu_stutter_wait("rcu_torture_reader");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irqcapable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop() && fullstop != FULLSTOP_SHUTDOWN)
+	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -854,7 +876,8 @@ rcu_torture_stats(void *arg)
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_stats");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
 	return 0;
 }
@@ -866,52 +889,49 @@ static int rcu_idle_cpu;	/* Force all torture tasks off this CPU */
  */
 static void rcu_torture_shuffle_tasks(void)
 {
-	cpumask_var_t tmp_mask;
+	cpumask_t tmp_mask;
 	int i;
 
-	if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL))
-		BUG();
-
-	cpumask_setall(tmp_mask);
+	cpus_setall(tmp_mask);
 	get_online_cpus();
 
 	/* No point in shuffling if there is only one online CPU (ex: UP) */
-	if (num_online_cpus() == 1)
-		goto out;
+	if (num_online_cpus() == 1) {
+		put_online_cpus();
+		return;
+	}
 
 	if (rcu_idle_cpu != -1)
-		cpumask_clear_cpu(rcu_idle_cpu, tmp_mask);
+		cpu_clear(rcu_idle_cpu, tmp_mask);
 
-	set_cpus_allowed_ptr(current, tmp_mask);
+	set_cpus_allowed_ptr(current, &tmp_mask);
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
 			if (reader_tasks[i])
 				set_cpus_allowed_ptr(reader_tasks[i],
-						     tmp_mask);
+						     &tmp_mask);
 	}
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++)
 			if (fakewriter_tasks[i])
 				set_cpus_allowed_ptr(fakewriter_tasks[i],
-						     tmp_mask);
+						     &tmp_mask);
 	}
 
 	if (writer_task)
-		set_cpus_allowed_ptr(writer_task, tmp_mask);
+		set_cpus_allowed_ptr(writer_task, &tmp_mask);
 
 	if (stats_task)
-		set_cpus_allowed_ptr(stats_task, tmp_mask);
+		set_cpus_allowed_ptr(stats_task, &tmp_mask);
 
 	if (rcu_idle_cpu == -1)
 		rcu_idle_cpu = num_online_cpus() - 1;
 	else
 		rcu_idle_cpu--;
 
-out:
 	put_online_cpus();
-	free_cpumask_var(tmp_mask);
 }
 
 /* Shuffle tasks across CPUs, with the intent of allowing each CPU in the
@@ -925,7 +945,8 @@ rcu_torture_shuffle(void *arg)
 	do {
 		schedule_timeout_interruptible(shuffle_interval * HZ);
 		rcu_torture_shuffle_tasks();
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_shuffle");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
 	return 0;
 }
@@ -940,10 +961,11 @@ rcu_torture_stutter(void *arg)
 	do {
 		schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 1;
-		if (!kthread_should_stop() && !fullstop)
+		if (!kthread_should_stop())
 			schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 0;
-	} while (!kthread_should_stop() && !fullstop);
+		rcutorture_shutdown_absorb("rcu_torture_stutter");
+	} while (!kthread_should_stop());
 	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
 	return 0;
 }
@@ -970,15 +992,16 @@ rcu_torture_cleanup(void)
 	int i;
 
 	mutex_lock(&fullstop_mutex);
-	if (!fullstop) {
-		/* If being signaled, let it happen, then exit. */
+	if (fullstop == FULLSTOP_SHUTDOWN) {
+		printk(KERN_WARNING /* but going down anyway, so... */
+		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
 		mutex_unlock(&fullstop_mutex);
-		schedule_timeout_interruptible(10 * HZ);
+		schedule_timeout_uninterruptible(10);
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
 	}
-	fullstop = FULLSTOP_CLEANUP;
+	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_nb);
 	if (stutter_task) {
@@ -1078,7 +1101,7 @@ rcu_torture_init(void)
 	else
 		nrealreaders = 2 * num_online_cpus();
 	rcu_torture_print_module_parms("Start of test");
-	fullstop = 0;
+	fullstop = FULLSTOP_DONTSTOP;
 
 	/* Set up the freelist. */
 

