Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYGPGyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYGPGyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 02:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYGPGyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 02:54:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37589 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYGPGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 02:54:14 -0400
Message-ID: <487D9A8B.5020005@jp.fujitsu.com>
Date: Wed, 16 Jul 2008 15:51:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Zachary Amsden <zach@vmware.com>
Subject: [PATCH] stopmachine: add stopmachine_timeout v3
References: <487B05CE.1050508@jp.fujitsu.com> <487D78A3.6050105@jp.fujitsu.com> <487D93CD.1000007@qualcomm.com> <487D96A2.10904@jp.fujitsu.com>
In-Reply-To: <487D96A2.10904@jp.fujitsu.com>
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
its target cpu in time.  You can enable this timeout via sysctl.

v3:
 - set stopmachine_timeout default to 0 (= never timeout)

v2:
 - remove fix for warning since it will be fixed upcoming typesafe
   patches
 - make stopmachine_timeout from secs to msecs
 - allow disabling timeout by setting the stopmachine_timeout to 0

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/stop_machine.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sysctl.c       |   15 +++++++++++++
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 5b72c2b..77b7944 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -35,15 +35,18 @@ struct stop_machine_data {
 };
 
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-static unsigned int num_threads;
+static atomic_t num_threads;
 static atomic_t thread_ack;
+static cpumask_t prepared_cpus;
 static struct completion finished;
 static DEFINE_MUTEX(lock);
 
+unsigned long stopmachine_timeout = 0; /* msecs, 0 = "never timeout" */
+
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
-	atomic_set(&thread_ack, num_threads);
+	atomic_set(&thread_ack, atomic_read(&num_threads));
 	smp_wmb();
 	state = newstate;
 }
@@ -67,6 +70,8 @@ static int stop_cpu(struct stop_machine_data *smdata)
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int uninitialized_var(ret);
 
+	cpu_set(smp_processor_id(), prepared_cpus);
+
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -90,6 +95,7 @@ static int stop_cpu(struct stop_machine_data *smdata)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
+	atomic_dec(&num_threads);
 	local_irq_enable();
 	do_exit(0);
 }
@@ -105,6 +111,15 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	int i, err;
 	struct stop_machine_data active, idle;
 	struct task_struct **threads;
+	unsigned long limit;
+
+	if (atomic_read(&num_threads)) {
+		/*
+		 * previous stop_machine was timeout, and still there are some
+		 * unfinished thread (dangling stucked CPU?).
+		 */
+		return -EBUSY;
+	}
 
 	active.fn = fn;
 	active.data = data;
@@ -120,7 +135,7 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	init_completion(&finished);
-	num_threads = num_online_cpus();
+	atomic_set(&num_threads, num_online_cpus());
 	set_state(STOPMACHINE_PREPARE);
 
 	for_each_online_cpu(i) {
@@ -152,10 +167,21 @@ int __stop_machine_run(int (*fn)(void *), void *data, const cpumask_t *cpus)
 
 	/* We've created all the threads.  Wake them all: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
+	cpus_clear(prepared_cpus);
 	get_cpu();
 	for_each_online_cpu(i)
 		wake_up_process(threads[i]);
 
+	/* Wait all others come to life */
+	if (stopmachine_timeout) {
+		limit = jiffies + msecs_to_jiffies(stopmachine_timeout);
+		while (cpus_weight(prepared_cpus) != num_online_cpus() - 1) {
+			if (time_is_before_jiffies(limit))
+				goto timeout;
+			cpu_relax();
+		}
+	}
+
 	/* This will release the thread on our CPU. */
 	put_cpu();
 	wait_for_completion(&finished);
@@ -169,10 +195,32 @@ kill_threads:
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
+	/* Let threads go exit */
+	set_state(STOPMACHINE_EXIT);
+
+	put_cpu();
+	/* no wait for completion */
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
