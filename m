Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYJIQZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYJIQZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYJIQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:25:43 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51215 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYJIQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:25:42 -0400
Date: Thu, 9 Oct 2008 18:25:36 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to
	stop_machine infrastructrue.
Message-ID: <20081009162536.GA11247@osiris.boeblingen.de.ibm.com>
References: <20081003105632.357231142@de.ibm.com> <200810081127.05311.rusty@rustcorp.com.au> <20081008101450.GA2954@osiris.boeblingen.de.ibm.com> <200810091118.27464.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810091118.27464.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 11:18:27AM +1100, Rusty Russell wrote:
> On Wednesday 08 October 2008 21:14:50 Heiko Carstens wrote:
> > The only thing that needs to be addressed is that workqueue threads aka
> > stop_machine threads are no real time threads now.
> > We would need something like create_workqueue_prio() or
> > create_workqueue_rt(). Would that be acceptable?
> 
> Hmm, I was hoping to reuse the kevent threads rather than create YA set
> of threads.  But hey, everyone else is doing it.

Reusing the kevent threads wouldn't work. The stopmachine work might be
queued behind a different work which could block on I/O.
Which is what I try to avoid.

> > +static struct workqueue_struct *stop_machine_wq;
> > +static struct work_struct *stop_machine_work;
> > +static struct stop_machine_data active, idle;
> > +static cpumask_t active_cpus;
> Hmm, please make active cpus a const cpumask_t pointer.  I'm trying to
> get rid of these kind of decls in another patch series :)

done.

> >  /* This is the actual thread which stops the CPU.  It exits by itself rather
> >   * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
> This comment is no longer valid...

fixed.
 
> > +static int __init stop_machine_init(void)
> > +{
> > +	stop_machine_wq = create_workqueue("kstop");
> > +	stop_machine_work = kcalloc(NR_CPUS, sizeof(struct work_struct),
> > +				    GFP_KERNEL);
> Perhaps make stop_machine_work a per-cpu array of struct work_struct
> instead of initializing it here.  Or at least make it a percpu pointer and
> only alloc possible cpus.

For the time being I converted it to alloc_percpu. Might be worth to use
percpu_alloc instead and register a cpu hotplug notifier...
 
> Does it break cpu hotplug BTW?  That's usually the problem.

It works. CPU hotplug is my primary test case, because it usually breaks ;)

So, how about the patch below then? I converted the device_initcall() to an
early_initcall(), so we get stop_machine working before smp works. For that
I had to move the init_workqueues() call a bit.

There are two more things that probably need to be addressed: the priority
of the workqueue should probably be changed to MAX_RT_PRIO-1 like it was
for the kstop threads.

And for num_online_cpus() == 1 we might as well call the simple stop_machine()
version which is defined in include/linux/stop_machine.h for !CONFIG_SMP.

---
 init/main.c           |    4 -
 kernel/stop_machine.c |  109 ++++++++++++++++++--------------------------------
 2 files changed, 42 insertions(+), 71 deletions(-)

Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -767,8 +767,6 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
-	/* drivers will send hotplug events */
-	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -852,6 +850,8 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
+	init_workqueues();
+
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
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
+	stop_machine_wq = create_workqueue("kstop");
+	stop_machine_work = alloc_percpu(struct work_struct);
+	return 0;
+}
+early_initcall(stop_machine_init);
