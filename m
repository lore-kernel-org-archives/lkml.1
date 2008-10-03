Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYJCK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYJCK6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYJCK6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:58:05 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:54601 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYJCK6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:58:03 -0400
Message-Id: <20081003105752.957653891@de.ibm.com>
References: <20081003105632.357231142@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Oct 2008 12:56:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au, jens.axboe@oracle.com, schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 2/4] stop_machine: add stop_machine_get/put_threads interface
Content-Disposition: inline; filename=stopmachine_getput.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Please note that this patch is not final. It contains bugs, doesn't care much
about memory barries etc. It just is intended to get feedback if the proposed
interface makes sense.

This patch adds to new interfaces to the stop_machine infrastructure:

stop_machine_get_threads() will create all needed kstop threads in advance.
If it is called multiple times it will just increase an internal usecount.

stop_machine_put_threads() will kill all previously created kstop threads,
if the internal usecount drops to zero.

This new interface can be used if there is the need to synchronize all cpus
without allocating any memory. This is achieved by simply creating the
kstop threads early and letting them sleep until they are finally needed.

It could also make sense to use this interface if plenty of stop_machine
calls are going to happen (e.g. kprobes). This would probably speed things
up.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/stop_machine.h |    8 +
 kernel/stop_machine.c        |  206 +++++++++++++++++++++++++++++++++----------
 2 files changed, 167 insertions(+), 47 deletions(-)

Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -4,6 +4,7 @@
 #include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/kthread.h>
+#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
@@ -39,6 +40,10 @@ static unsigned int num_threads;
 static atomic_t thread_ack;
 static struct completion finished;
 static DEFINE_MUTEX(lock);
+static struct stop_machine_data active, idle;
+static cpumask_t active_cpus;
+static struct task_struct *threads[NR_CPUS];
+static int usecount;
 
 static void set_state(enum stopmachine_state newstate)
 {
@@ -48,6 +53,13 @@ static void set_state(enum stopmachine_s
 	state = newstate;
 }
 
+static enum stopmachine_state read_state(void)
+{
+	/* Force read of state. */
+	barrier();
+	return state;
+}
+
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
@@ -62,7 +74,7 @@ static void ack_state(void)
 
 /* This is the actual thread which stops the CPU.  It exits by itself rather
  * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+static void __stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int *frp, fnret, old;
@@ -95,7 +107,27 @@ static int stop_cpu(struct stop_machine_
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
-	do_exit(0);
+}
+
+static int stop_cpu(void *smcpu)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait);
+	struct stop_machine_data *smdata;
+	int cpu;
+
+	cpu = (long)smcpu;
+	while (1) {
+		if (kthread_should_stop())
+			break;
+		/* active_cpus mask might have changed. */
+		barrier();
+		smdata =  cpu_isset(cpu, active_cpus) ? &active : &idle;
+		__stop_cpu(smdata);
+		wait_event_interruptible(wait,
+					 kthread_should_stop() ||
+					 read_state() == STOPMACHINE_PREPARE);
+	}
+	return 0;
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -104,55 +136,103 @@ static int chill(void *unused)
 	return 0;
 }
 
+static int create_kstop_thread(int cpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct task_struct *k;
+	int err;
+
+	k = kthread_create((void *)stop_cpu, (void *)(long)cpu, "kstop%u", cpu);
+	err = IS_ERR(k) ? PTR_ERR(k) : 0;
+	if (err)
+		return err;
+	threads[cpu] = k;
+	/* Place it onto correct cpu. */
+	kthread_bind(k, cpu);
+
+	/* Make it highest prio. */
+	if (sched_setscheduler_nocheck(k, SCHED_FIFO, &param))
+		BUG();
+	return 0;
+}
+
+static void kill_kstop_thread(int cpu)
+{
+	if (!threads[cpu])
+		return;
+	kthread_stop(threads[cpu]);
+	threads[cpu] = NULL;
+}
+
+static int __stop_machine_get_threads(void)
+{
+	int i, err;
+
+	if (usecount++)
+		return 0;
+	for_each_online_cpu(i) {
+		err = create_kstop_thread(i);
+		if (err)
+			goto kill_threads;
+	}
+	return 0;
+kill_threads:
+	for_each_online_cpu(i)
+		kill_kstop_thread(i);
+	usecount--;
+	return err;
+}
+
+int stop_machine_get_threads(void)
+{
+	int err;
+
+	mutex_lock(&lock);
+	/* FIXME: All created tasks will be in state UNINTERRUPTIBLE
+	 * but we want INTERRUPTIBLE. */
+	err = __stop_machine_get_threads();
+	mutex_unlock(&lock);
+	return err;
+}
+
+static void __stop_machine_put_threads(void)
+{
+	int i;
+
+	if (--usecount)
+		return;
+	for_each_online_cpu(i)
+		kill_kstop_thread(i);
+}
+
+void stop_machine_put_threads(void)
+{
+	mutex_lock(&lock);
+	__stop_machine_put_threads();
+	mutex_unlock(&lock);
+}
+
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
 	int i, err;
-	struct stop_machine_data active, idle;
-	struct task_struct **threads;
 
+	active_cpus = cpus ? *cpus : cpumask_of_cpu(first_cpu(cpu_online_map));
 	active.fn = fn;
 	active.data = data;
 	active.fnret = 0;
 	idle.fn = chill;
 	idle.data = NULL;
 
-	/* This could be too big for stack on large machines. */
-	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
-	if (!threads)
-		return -ENOMEM;
-
 	/* Set up initial state. */
 	mutex_lock(&lock);
 	init_completion(&finished);
 	num_threads = num_online_cpus();
 	set_state(STOPMACHINE_PREPARE);
 
-	for_each_online_cpu(i) {
-		struct stop_machine_data *smdata = &idle;
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
-
-		if (!cpus) {
-			if (i == first_cpu(cpu_online_map))
-				smdata = &active;
-		} else {
-			if (cpu_isset(i, *cpus))
-				smdata = &active;
-		}
-
-		threads[i] = kthread_create((void *)stop_cpu, smdata, "kstop%u",
-					    i);
-		if (IS_ERR(threads[i])) {
-			err = PTR_ERR(threads[i]);
-			threads[i] = NULL;
-			goto kill_threads;
-		}
-
-		/* Place it onto correct cpu. */
-		kthread_bind(threads[i], i);
-
-		/* Make it highest prio. */
-		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
-			BUG();
+	err = __stop_machine_get_threads();
+	if (err) {
+		mutex_unlock(&lock);
+		return err;
 	}
 
 	/* We've created all the threads.  Wake them all: hold this CPU so one
@@ -164,20 +244,9 @@ int __stop_machine(int (*fn)(void *), vo
 	/* This will release the thread on our CPU. */
 	put_cpu();
 	wait_for_completion(&finished);
+	__stop_machine_put_threads();
 	mutex_unlock(&lock);
-
-	kfree(threads);
-
 	return active.fnret;
-
-kill_threads:
-	for_each_online_cpu(i)
-		if (threads[i])
-			kthread_stop(threads[i]);
-	mutex_unlock(&lock);
-
-	kfree(threads);
-	return err;
 }
 
 int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
@@ -192,3 +261,46 @@ int stop_machine(int (*fn)(void *), void
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+static int __cpuinit stop_machine_notify(struct notifier_block *self,
+					 unsigned long action, void *hcpu)
+{
+	int rc = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		mutex_lock(&lock);
+		if (usecount)
+			/* FIXME: new thread will be in state UNINTERRUPTIBLE
+			 * but we want INTERRUPTIBLE. */
+			rc = create_kstop_thread((long)hcpu);
+		mutex_unlock(&lock);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		mutex_lock(&lock);
+		if (usecount)
+			kill_kstop_thread((long)hcpu);
+		mutex_unlock(&lock);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		mutex_lock(&lock);
+		kill_kstop_thread((long)hcpu);
+		mutex_unlock(&lock);
+		break;
+	}
+	return rc ? NOTIFY_BAD : NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata stop_machine_nb = {
+	.notifier_call = stop_machine_notify,
+};
+
+static int __init stop_machine_init(void)
+{
+	register_hotcpu_notifier(&stop_machine_nb);
+	return 0;
+}
+early_initcall(stop_machine_init);
Index: linux-2.6/include/linux/stop_machine.h
===================================================================
--- linux-2.6.orig/include/linux/stop_machine.h
+++ linux-2.6/include/linux/stop_machine.h
@@ -35,6 +35,10 @@ int stop_machine(int (*fn)(void *), void
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+
+int stop_machine_get_threads(void);
+void stop_machine_put_threads(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -46,5 +50,9 @@ static inline int stop_machine(int (*fn)
 	local_irq_enable();
 	return ret;
 }
+
+static inline int stop_machine_get_threads(void) { return 0; }
+static inline void stop_machine_put_threads(void) { }
+
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */

-- 
