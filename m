Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYJMVxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYJMVxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYJMVwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:52:24 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:49151 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828AbYJMVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:52:22 -0400
Message-Id: <20081013215131.623479134@de.ibm.com>
References: <20081013215007.634620563@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 13 Oct 2008 23:50:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: rusty@rustcorp.com.au
Cc: jens.axboe@oracle.com, mingo@elte.hu, akpm@linux-foundation.org,
       schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC v2 3/6] stop_machine: use workqueues instead of kernel threads
Content-Disposition: inline; filename=003_stopmachine_wq.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Convert stop_machine to a workqueue based approach. Instead of using kernel
threads for stop_machine we now use a an rt workqueue to synchronize all
cpus.
This has the advantage that all needed per cpu threads are already created
when stop_machine gets called. And therefore a call to stop_machine won't
fail anymore. This is needed for s390 which needs a mechanism to synchronize
all cpus without allocating any memory.
As Rusty pointed out free_module() needs a non-failing stop_machine interface
as well.

As a side effect the stop_machine code gets simplified.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/stop_machine.c |  109 ++++++++++++++++++--------------------------------
 1 file changed, 40 insertions(+), 69 deletions(-)

Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -37,9 +37,13 @@ struct stop_machine_data {
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
 static atomic_t thread_ack;
-static struct completion finished;
 static DEFINE_MUTEX(lock);
 
+static struct workqueue_struct *stop_machine_wq;
+static struct stop_machine_data active, idle;
+static const cpumask_t *active_cpus;
+static void *stop_machine_work;
+
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
@@ -51,21 +55,25 @@ static void set_state(enum stopmachine_s
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
-	if (atomic_dec_and_test(&thread_ack)) {
-		/* If we're the last one to ack the EXIT, we're finished. */
-		if (state == STOPMACHINE_EXIT)
-			complete(&finished);
-		else
-			set_state(state + 1);
-	}
+	if (atomic_dec_and_test(&thread_ack))
+		set_state(state + 1);
 }
 
-/* This is the actual thread which stops the CPU.  It exits by itself rather
- * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+/* This is the actual function which stops the CPU. It runs
+ * in the context of a dedicated stopmachine workqueue. */
+static void stop_cpu(struct work_struct *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
+	struct stop_machine_data *smdata = &idle;
+	int cpu = smp_processor_id();
 
+	if (!active_cpus) {
+		if (cpu == first_cpu(cpu_online_map))
+			smdata = &active;
+	} else {
+		if (cpu_isset(cpu, *active_cpus))
+			smdata = &active;
+	}
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -90,7 +98,6 @@ static int stop_cpu(struct stop_machine_
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
-	do_exit(0);
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -101,78 +108,34 @@ static int chill(void *unused)
 
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	int i, err;
-	struct stop_machine_data active, idle;
-	struct task_struct **threads;
+	struct work_struct *sm_work;
+	int i;
 
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	num_threads = num_online_cpus();
+	active_cpus = cpus;
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
-	/* Set up initial state. */
-	mutex_lock(&lock);
-	init_completion(&finished);
-	num_threads = num_online_cpus();
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
-	}
-
-	/* We've created all the threads.  Wake them all: hold this CPU so one
+	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
-	for_each_online_cpu(i)
-		wake_up_process(threads[i]);
-
+	for_each_online_cpu(i) {
+		sm_work = percpu_ptr(stop_machine_work, i);
+		INIT_WORK(sm_work, stop_cpu);
+		queue_work_on(i, stop_machine_wq, sm_work);
+	}
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	wait_for_completion(&finished);
+	flush_workqueue(stop_machine_wq);
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
@@ -187,3 +150,11 @@ int stop_machine(int (*fn)(void *), void
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+static int __init stop_machine_init(void)
+{
+	stop_machine_wq = create_rt_workqueue("kstop");
+	stop_machine_work = alloc_percpu(struct work_struct);
+	return 0;
+}
+early_initcall(stop_machine_init);

-- 
