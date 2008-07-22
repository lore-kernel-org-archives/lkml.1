Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYGVD3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYGVD3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYGVD3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:29:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50177 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYGVD3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:29:32 -0400
Message-ID: <488553EB.1040605@jp.fujitsu.com>
Date: Tue, 22 Jul 2008 12:28:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] stopmachine: allow force progress on timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807151750.12131.rusty@rustcorp.com.au> <487D738B.4070104@jp.fujitsu.com> <200807201945.58836.rusty@rustcorp.com.au>
In-Reply-To: <200807201945.58836.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Rusty Russell wrote:
> The scenario we are addressing is a stuck CPU and module load.  If we fail 
> stop machine, module load fails.
> 
> That is why we should continue if we can.  It is also why the default timeout 
> cannot be 0.  You can't turn this on once you notice there's a problem: it's 
> too late.
> 
> If we don't want to handle this case, let's not apply any patch at all.
> Rusty.

I see.  Still we can have an another patch for an another feature.
How about this patch?  This will be applied on "add stopmachine_timeout v4".

Thanks,
H.Seto

===

This patch reflects Rusty's suggestion that if we did not want to do
something on the stuck CPU then treat the CPU as stopped.

If you afraid that the stuck CPUs may harm what we want to do, then
turn off stopmachine_force by writing 0 via sysctl.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/stop_machine.h |    1 +
 kernel/stop_machine.c        |   84 +++++++++++++++++++++++++++---------------
 kernel/sysctl.c              |    8 ++++
 3 files changed, 63 insertions(+), 30 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 4c934f7..2bb339b 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -15,6 +15,7 @@
 
 /* for sysctl entry */
 extern unsigned long stopmachine_timeout;
+extern unsigned int stopmachine_force;
 
 /**
  * stop_machine_run: freeze the machine on all CPUs and run this function
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 9059b9e..824aafe 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -35,18 +35,20 @@ struct stop_machine_data {
 };
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-static atomic_t num_threads;
+static unsigned int num_threads;
+static atomic_t num_tardy;
 static atomic_t thread_ack;
 static cpumask_t prepared_cpus;
 static struct completion finished;
 static DEFINE_MUTEX(lock);
 
 unsigned long stopmachine_timeout; /* msecs, default is 0 = "never timeout" */
+unsigned int stopmachine_force = 1; /* force progress on timeout, 0:turn off */
 
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
-	atomic_set(&thread_ack, atomic_read(&num_threads));
+	atomic_set(&thread_ack, num_threads);
 	smp_wmb();
 	state = newstate;
 }
@@ -70,7 +72,11 @@ static int stop_cpu(struct stop_machine_data *smdata)
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int uninitialized_var(ret);
 
-	cpu_set(smp_processor_id(), prepared_cpus);
+	/* If we've been shoved off the normal CPU, abort. */
+	if (cpu_test_and_set(smp_processor_id(), prepared_cpus)) {
+		atomic_dec(&num_tardy);
+		do_exit(0);
+	}
 
 	/* Simple state machine */
 	do {
@@ -95,7 +101,6 @@ static int stop_cpu(struct stop_machine_data *smdata)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	atomic_dec(&num_threads);
 	local_irq_enable();
 	do_exit(0);
 }
@@ -106,6 +111,41 @@ static int chill(void *unused)
 	return 0;
 }
 
+static bool fixup_timeout(struct task_struct **threads, const cpumask_t *cpus)
+{
+	int i;
+	bool ret = !!stopmachine_force ? true : false;
+
+	printk(KERN_CRIT "stopmachine: Failed to stop machine in "
+			"time(%ldms).\n", stopmachine_timeout);
+
+	for_each_online_cpu(i) {
+		if (i != smp_processor_id()
+		    && !cpu_test_and_set(i, prepared_cpus)) {
+
+			printk(KERN_CRIT "stopmachine: cpu#%d seems to be "
+					"stuck.\n", i);
+
+			/* Unbind thread */
+			set_cpus_allowed(threads[i], cpu_online_map);
+			atomic_inc(&num_tardy);
+			num_threads--;
+
+			/*
+			 * If we wanted to run on a particular CPU, and that's
+			 * the one which is stuck, we cannot continue.
+			 */
+			if (stopmachine_force)
+				ret &= (!cpus || !cpu_isset(i, *cpus));
+		}
+	}
+
+	if (ret)
+		printk(KERN_CRIT "stopmachine: Force progress ignoring stuck "
+			"CPUs.\n");
+	return ret;
+}
+
 int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int i, err;
@@ -113,7 +153,7 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	struct task_struct **threads;
 	unsigned long limit;
 
-	if (atomic_read(&num_threads)) {
+	if (atomic_read(&num_tardy)) {
 		/*
 		 * previous stop_machine was timeout, and still there are some
 		 * unfinished thread (dangling stucked CPU?).
@@ -135,7 +175,7 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	init_completion(&finished);
-	atomic_set(&num_threads, num_online_cpus());
+	num_threads = num_online_cpus();
 	set_state(STOPMACHINE_PREPARE);
 
 	for_each_online_cpu(i) {
@@ -176,8 +216,14 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	if (stopmachine_timeout) {
 		limit = jiffies + msecs_to_jiffies(stopmachine_timeout);
 		while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
-			if (time_is_before_jiffies(limit))
-				goto timeout;
+			if (time_is_before_jiffies(limit)) {
+				if (!fixup_timeout(threads, cpus)) {
+					/* Let threads go exit */
+					set_state(STOPMACHINE_EXIT);
+					active.fnret = -EBUSY;
+				}
+				break;
+			}
 			cpu_relax();
 		}
 	}
@@ -195,32 +241,10 @@ kill_threads:
 	for_each_online_cpu(i)
 		if (threads[i])
 			kthread_stop(threads[i]);
-	atomic_set(&num_threads, 0);
 	mutex_unlock(&lock);
 
 	kfree(threads);
 	return err;
-
-timeout:
-	printk(KERN_CRIT "stopmachine: Failed to stop machine in time(%lds).\n",
-			stopmachine_timeout);
-	for_each_online_cpu(i) {
-		if (!cpu_isset(i, prepared_cpus) && i != smp_processor_id())
-			printk(KERN_CRIT "stopmachine: cpu#%d seems to be "
-					"stuck.\n", i);
-		/* Unbind threads */
-		set_cpus_allowed(threads[i], cpu_online_map);
-	}
-
-	/* Let threads go exit */
-	set_state(STOPMACHINE_EXIT);
-
-	put_cpu();
-	/* no wait for completion */
-	mutex_unlock(&lock);
-	kfree(threads);
-
-	return -EBUSY;	/* canceled */
 }
 
 int stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index d9e9900..5cd72b8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -824,6 +824,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_doulongvec_minmax,
 		.strategy       = &sysctl_intvec,
 	},
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "stopmachine_force",
+		.data           = &stopmachine_force,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
 #endif
 /*
  * NOTE: do not add new entries to this table unless you have read
-- 

