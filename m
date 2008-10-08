Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYJHKPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYJHKPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYJHKP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:15:28 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:56824 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYJHKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:15:27 -0400
Date: Wed, 8 Oct 2008 12:14:50 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to
	stop_machine infrastructrue.
Message-ID: <20081008101450.GA2954@osiris.boeblingen.de.ibm.com>
References: <20081003105632.357231142@de.ibm.com> <200810071239.58732.rusty@rustcorp.com.au> <20081007153854.GA4122@osiris.boeblingen.de.ibm.com> <200810081127.05311.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810081127.05311.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 10:27:04AM +1000, Rusty Russell wrote:
> 
> > Another thing that comes to mind is cpu hotplug: if somebody issued
> > stop_machine_prepare() and then a cpu hotplug operation gets started we
> > need to create or kill a kstop thread. For that we need the "sm" so we can
> > save/find the task_struct pointer of the thread.
> 
> Erk, good point.  Suckage.
> 
> OK, idea #2.  Let's just always have a kstopmachine thread running on every 
> online cpu.  Is there a sane way to reuse the workqueue threads for this?

That's a very good idea and what the patch below does. It even simplifies
the stop_machine code and it does work on an otherwise idle system.
The only thing that needs to be addressed is that workqueue threads aka
stop_machine threads are no real time threads now.
We would need something like create_workqueue_prio() or create_workqueue_rt().
Would that be acceptable?

---
 kernel/stop_machine.c |   97 ++++++++++++++++----------------------------------
 1 file changed, 32 insertions(+), 65 deletions(-)

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
+static struct work_struct *stop_machine_work;
+static struct stop_machine_data active, idle;
+static cpumask_t active_cpus;
+
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
@@ -51,21 +55,21 @@ static void set_state(enum stopmachine_s
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
 
 /* This is the actual thread which stops the CPU.  It exits by itself rather
  * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+static void stop_cpu(struct work_struct *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
+	struct stop_machine_data *smdata;
 
+	if (cpu_isset(smp_processor_id(), active_cpus))
+		smdata = &active;
+	else
+		smdata = &idle;
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -90,7 +94,6 @@ static int stop_cpu(struct stop_machine_
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
-	do_exit(0);
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -101,78 +104,33 @@ static int chill(void *unused)
 
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	int i, err;
-	struct stop_machine_data active, idle;
-	struct task_struct **threads;
+	int i;
 
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	num_threads = num_online_cpus();
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
 	/* We've created all the threads.  Wake them all: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
-	for_each_online_cpu(i)
-		wake_up_process(threads[i]);
-
+	for_each_online_cpu(i) {
+		INIT_WORK(&stop_machine_work[i], stop_cpu);
+		queue_work_on(i, stop_machine_wq, &stop_machine_work[i]);
+	}
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	wait_for_completion(&finished);
+	flush_workqueue(stop_machine_wq);
 	mutex_unlock(&lock);
 
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
@@ -187,3 +145,12 @@ int stop_machine(int (*fn)(void *), void
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+static int __init stop_machine_init(void)
+{
+	stop_machine_wq = create_workqueue("kstop");
+	stop_machine_work = kcalloc(NR_CPUS, sizeof(struct work_struct),
+				    GFP_KERNEL);
+	return 0;
+}
+device_initcall(stop_machine_init);
