Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYJGPkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYJGPkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYJGPj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:39:59 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:39437 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYJGPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:39:58 -0400
Date: Tue, 7 Oct 2008 17:38:54 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to
	stop_machine infrastructrue.
Message-ID: <20081007153854.GA4122@osiris.boeblingen.de.ibm.com>
References: <20081003105632.357231142@de.ibm.com> <200810061542.41224.rusty@rustcorp.com.au> <20081006201650.GA4708@osiris.boeblingen.de.ibm.com> <200810071239.58732.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810071239.58732.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 11:39:58AM +1000, Rusty Russell wrote:
> On Tuesday 07 October 2008 07:16:50 Heiko Carstens wrote:
> > > > Patch 2 introduces the new proposed interface
> > >
> > > Could we just encapsulate the threads etc. into a "struct stopmachine"
> > > which is returned from stop_machine_prepare(), then implement everything
> > > in terms of that?
> >
> > You mean that we put the pointers to the threads, the cpu mask, etc. in
> > this structure, instead of wasting bss size?
> > That would be just a kmalloc call in __stop_machine_get_threads().
> > Or do you think of something different?
> 
> That's exactly my idea.  We kmalloc already because NR_CPUS might be too big 
> for the stack.  This version would just kmalloc a struct containing 
> everything we need.

Ok, I did that but the resulting code is astonishingly ugly, so I thought I
should share it :)
 
> I prefer _prepare() / _run() / _destroy() as nomenclature BTW.  prepare comes 
> from wait.h's prepare_to_wait; I don't like alloc() since it does more than 
> allocate memory, yet _get_threads unnecessarily reveals too much about the 
> implementation.
> 
> Then we have the simple case:
> 
> static inline int stop_machine(int (*fn)(void *), void *data,
> 			       const struct cpumask *cpus)
> {
> 	struct stop_machine *sm = stop_machine_prepare();
> 	int err;
> 
> 	if (!sm)
> 		return -ENOMEM;
> 
> 	err = stop_machine_run(sm, fn, data, cpus);
> 	stop_machine_destroy(sm);
> 	return err;
> }
> I think you want to be able to call stop_machine_run() with the same "sm" 
> multiple times, but that should be pretty easy to ensure.

Actually there should be at most a single "sm" present. stop_machine_prepare()
also is supposed to create the kstop threads. So there is no point in having
several of them. Which again makes me ask, why should it a return a pointer
to a (the) stop_machine structure at all?
Imho an error code should be sufficient.

Another thing that comes to mind is cpu hotplug: if somebody issued
stop_machine_prepare() and then a cpu hotplug operation gets started we need
to create or kill a kstop thread. For that we need the "sm" so we can
save/find the task_struct pointer of the thread.

And yet another ugly detail: I decided to kill all kstop threads with
kthread_stop(). In case of cpu hot unplug this is a bit of a problem, since
the thread in question hasn't been migrated yet (yet == when
stop_machine_destroy gets called). So I have to wait until the cpu hotplug
notifier list gets called... and hence I need a reference to the "sm"
structure before it can be freed, because that's where the pointer to the
task_struct is stored.
This all leads to very ugly reference counting.

Hmm.. while thinking about it.. maybe it would sense to do something like

	wait_task_inactive(p, 0);
	set_task_cpu(p, any_online_cpu());
	kthread_stop(p);

within stop_machine_destroy() in case of cpu hot unplug for the thread that
was on the dead cpu?
That would ease the ugly reference counting in the patch below a lot.

Anyway, the patch below is what I currently have. It does work and should
give you an idea of _what_ I want. However the implementation does suck
currently, no question about that.

---
 include/linux/stop_machine.h |    8 +
 kernel/stop_machine.c        |  250 +++++++++++++++++++++++++++++++++----------
 2 files changed, 204 insertions(+), 54 deletions(-)

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
@@ -34,11 +35,20 @@ struct stop_machine_data {
 	int fnret;
 };
 
+struct stop_machine {
+	struct task_struct *threads[NR_CPUS];
+	int usecount;
+	int threadcount;
+	struct stop_machine_data active, idle;
+	cpumask_t active_cpus;
+};
+
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
 static atomic_t thread_ack;
 static struct completion finished;
 static DEFINE_MUTEX(lock);
+static struct stop_machine *smh;
 
 static void set_state(enum stopmachine_state newstate)
 {
@@ -48,6 +58,13 @@ static void set_state(enum stopmachine_s
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
@@ -62,7 +79,7 @@ static void ack_state(void)
 
 /* This is the actual thread which stops the CPU.  It exits by itself rather
  * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
-static int stop_cpu(struct stop_machine_data *smdata)
+static void __stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 
@@ -90,7 +107,30 @@ static int stop_cpu(struct stop_machine_
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
+		wait_event_interruptible(wait,
+					 kthread_should_stop() ||
+					 read_state() == STOPMACHINE_PREPARE);
+		if (kthread_should_stop())
+			break;
+		/* active_cpus mask might have changed. */
+		barrier();
+		if (cpu_isset(cpu, smh->active_cpus))
+			smdata = &smh->active;
+		else
+			smdata = &smh->idle;
+		__stop_cpu(smdata);
+	}
+	return 0;
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -99,79 +139,142 @@ static int chill(void *unused)
 	return 0;
 }
 
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+static void put_smh(int is_thread)
 {
-	int i, err;
-	struct stop_machine_data active, idle;
-	struct task_struct **threads;
+	if (is_thread)
+		smh->threadcount--;
+	else
+		smh->usecount--;
+	if (smh->threadcount || smh->usecount)
+		return;
+	kfree(smh);
+	smh = NULL;
+}
 
-	active.fn = fn;
-	active.data = data;
-	active.fnret = 0;
-	idle.fn = chill;
-	idle.data = NULL;
-
-	/* This could be too big for stack on large machines. */
-	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
-	if (!threads)
-		return -ENOMEM;
+static int create_kstop_thread(int cpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct task_struct *k;
+	int err;
+
+	if (!smh || !smh->usecount)
+		return 0;
+	k = kthread_create((void *)stop_cpu, (void *)(long)cpu, "kstop%u", cpu);
+	err = IS_ERR(k) ? PTR_ERR(k) : 0;
+	if (err)
+		return err;
+	smh->threads[cpu] = k;
+	/* Place it onto correct cpu. */
+	kthread_bind(k, cpu);
+
+	/* Make it highest prio. */
+	if (sched_setscheduler_nocheck(k, SCHED_FIFO, &param))
+		BUG();
+	/* Move it into state INTERRUPTIBLE. */
+	wake_up_process(k);
+	smh->threadcount++;
+	return 0;
+}
 
-	/* Set up initial state. */
+static void kill_kstop_thread(int cpu)
+{
+	if (!smh || !smh->threads[cpu])
+		return;
+	kthread_stop(smh->threads[cpu]);
+	smh->threads[cpu] = NULL;
+	put_smh(1);
+}
+
+static void __stop_machine_destroy(void)
+{
+	int i;
+
+	if (smh->usecount > 1) {
+		put_smh(0);
+		return;
+	}
+	for_each_online_cpu(i)
+		kill_kstop_thread(i);
+	put_smh(0);
+}
+
+void stop_machine_destroy(void)
+{
 	mutex_lock(&lock);
-	init_completion(&finished);
-	num_threads = num_online_cpus();
-	set_state(STOPMACHINE_PREPARE);
+	__stop_machine_destroy();
+	mutex_unlock(&lock);
+}
+
+static int __stop_machine_prepare(void)
+{
+	int i, err;
 
+	if (!smh)
+		smh = kzalloc(sizeof(*smh), GFP_KERNEL);
+	if (!smh)
+		return -ENOMEM;
+	if (smh->usecount++)
+		return 0;
 	for_each_online_cpu(i) {
-		struct stop_machine_data *smdata = &idle;
-		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+		err = create_kstop_thread(i);
+		if (err)
+			goto destroy;
+	}
+	return 0;
+destroy:
+	__stop_machine_destroy();
+	return err;
+}
 
-		if (!cpus) {
-			if (i == first_cpu(cpu_online_map))
-				smdata = &active;
-		} else {
-			if (cpu_isset(i, *cpus))
-				smdata = &active;
-		}
+int stop_machine_prepare(void)
+{
+	int err;
 
-		threads[i] = kthread_create((void *)stop_cpu, smdata, "kstop%u",
-					    i);
-		if (IS_ERR(threads[i])) {
-			err = PTR_ERR(threads[i]);
-			threads[i] = NULL;
-			goto kill_threads;
-		}
+	mutex_lock(&lock);
+	err = __stop_machine_prepare();
+	mutex_unlock(&lock);
+	return err;
+}
+
+int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
+{
+	int i, err;
 
-		/* Place it onto correct cpu. */
-		kthread_bind(threads[i], i);
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	init_completion(&finished);
+	num_threads = num_online_cpus();
 
-		/* Make it highest prio. */
-		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
-			BUG();
+	set_state(STOPMACHINE_NONE);
+	err = __stop_machine_prepare();
+	if (err) {
+		mutex_unlock(&lock);
+		return err;
 	}
 
+	if (cpus)
+		smh->active_cpus = *cpus;
+	else
+		smh->active_cpus = cpumask_of_cpu(first_cpu(cpu_online_map));
+	smh->active.fn = fn;
+	smh->active.data = data;
+	smh->active.fnret = 0;
+	smh->idle.fn = chill;
+	smh->idle.data = NULL;
+
 	/* We've created all the threads.  Wake them all: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
+	set_state(STOPMACHINE_PREPARE);
 	for_each_online_cpu(i)
-		wake_up_process(threads[i]);
+		wake_up_process(smh->threads[i]);
 
 	/* This will release the thread on our CPU. */
 	put_cpu();
 	wait_for_completion(&finished);
+	err = smh->active.fnret;
+	__stop_machine_destroy();
 	mutex_unlock(&lock);
-
-	kfree(threads);
-
-	return active.fnret;
-
-kill_threads:
-	for_each_online_cpu(i)
-		if (threads[i])
-			kthread_stop(threads[i]);
-	mutex_unlock(&lock);
-
-	kfree(threads);
 	return err;
 }
 
@@ -187,3 +290,42 @@ int stop_machine(int (*fn)(void *), void
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
+		rc = create_kstop_thread((long)hcpu);
+		mutex_unlock(&lock);
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		mutex_lock(&lock);
+		kill_kstop_thread((long)hcpu);
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
+int stop_machine_prepare(void);
+void stop_machine_destroy(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -46,5 +50,9 @@ static inline int stop_machine(int (*fn)
 	local_irq_enable();
 	return ret;
 }
+
+static inline int stop_machine_prepare(void) { return 0; }
+static inline void stop_machine_destroy(void) { }
+
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
