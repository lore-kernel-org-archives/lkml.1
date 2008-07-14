Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYGNHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYGNHz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbYGNHxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:53:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42871 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083AbYGNHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:53:11 -0400
Message-ID: <487B05CE.1050508@jp.fujitsu.com>
Date: Mon, 14 Jul 2008 16:52:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] stopmachine: add stopmachine_timeout
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If stop_machine() invoked while one of onlined cpu is locked up
by some reason, stop_machine cannot finish its work because the
locked cpu cannot stop.  This means all other healthy cpus
will be blocked infinitely by one dead cpu.

This patch allows stop_machine to return -EBUSY with some printk
messages if any of stop_machine's threads cannot start running on
its target cpu.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/stop_machine.c |   52 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/sysctl.c       |   15 ++++++++++++++
 2 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 5b72c2b..9e36809 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -35,15 +35,19 @@ struct stop_machine_data {
 };
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-static unsigned int num_threads;
+static atomic_t num_threads;
 static atomic_t thread_ack;
+static cpumask_t prepared_cpus;
 static struct completion finished;
 static DEFINE_MUTEX(lock);
 
+static unsigned long limit;
+unsigned long stopmachine_timeout = 5; /* secs, arbitrary */
+
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
-	atomic_set(&thread_ack, num_threads);
+	atomic_set(&thread_ack, atomic_read(&num_threads));
 	smp_wmb();
 	state = newstate;
 }
@@ -62,11 +66,14 @@ static void ack_state(void)
 
 /* This is the actual thread which stops the CPU.  It exits by itself rather
  * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+static int stop_cpu(void *__smdata)
 {
+	struct stop_machine_data *smdata = __smdata;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int uninitialized_var(ret);
 
+	cpu_set(smp_processor_id(), prepared_cpus);
+
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -90,6 +97,7 @@ static int stop_cpu(struct stop_machine_data *smdata)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
+	atomic_dec(&num_threads);
 	local_irq_enable();
 	do_exit(0);
 }
@@ -106,6 +114,14 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	struct stop_machine_data active, idle;
 	struct task_struct **threads;
 
+	if (atomic_read(&num_threads)) {
+		/*
+		 * previous try was timeout, and still there are some
+		 * unfinished thread dangling stucked CPUs.
+		 */
+		return -EBUSY;
+	}
+
 	active.fn = fn;
 	active.data = data;
 	active.fnret = 0;
@@ -120,7 +136,8 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	init_completion(&finished);
-	num_threads = num_online_cpus();
+	atomic_set(&num_threads, num_online_cpus());
+	limit = jiffies + msecs_to_jiffies(stopmachine_timeout * MSEC_PER_SEC);
 	set_state(STOPMACHINE_PREPARE);
 
 	for_each_online_cpu(i) {
@@ -152,10 +169,18 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 
 	/* We've created all the threads.  Wake them all: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
+	cpus_clear(prepared_cpus);
 	get_cpu();
 	for_each_online_cpu(i)
 		wake_up_process(threads[i]);
 
+	/* Wait all others come to life */
+	while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
+		if (time_is_before_jiffies(limit))
+			goto timeout;
+		cpu_relax();
+	}
+
 	/* This will release the thread on our CPU. */
 	put_cpu();
 	wait_for_completion(&finished);
@@ -169,10 +194,29 @@ kill_threads:
 	for_each_online_cpu(i)
 		if (threads[i])
 			kthread_stop(threads[i]);
+	atomic_set(&num_threads, 0);
 	mutex_unlock(&lock);
 
 	kfree(threads);
 	return err;
+
+timeout:
+	printk(KERN_CRIT "stopmachine: Failed to stop machine in time(%lds).\n",
+			stopmachine_timeout);
+	for_each_online_cpu(i) {
+		if (!cpu_isset(i, prepared_cpus) && i != smp_processor_id())
+			printk(KERN_CRIT "stopmachine: cpu#%d seems to be "
+					"stuck.\n", i);
+		/* Unbind threads */
+		set_cpus_allowed(threads[i], cpu_online_map);
+	}
+
+	set_state(STOPMACHINE_EXIT);
+	put_cpu();
+	mutex_unlock(&lock);
+	kfree(threads);
+
+	return -EBUSY;	/* canceled */
 }
 
 int stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2911665..3c7ca98 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -146,6 +146,10 @@ extern int no_unaligned_warning;
 extern int max_lock_depth;
 #endif
 
+#ifdef CONFIG_STOP_MACHINE
+extern unsigned long stopmachine_timeout;
+#endif
+
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -813,6 +817,17 @@ static struct ctl_table kern_table[] = {
 		.child		= key_sysctls,
 	},
 #endif
+#ifdef CONFIG_STOP_MACHINE
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "stopmachine_timeout",
+		.data           = &stopmachine_timeout,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0644,
+		.proc_handler   = &proc_doulongvec_minmax,
+		.strategy       = &sysctl_intvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
-- 
