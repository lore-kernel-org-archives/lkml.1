Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684AbYJXTpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbYJXTpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYJXTpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:45:36 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:45612 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYJXTpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:45:35 -0400
Date: Fri, 24 Oct 2008 21:44:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: w41ter@gmail.com
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: commit a802dd0e breaks console keyboard input
Message-ID: <20081024194414.GB4155@osiris.boeblingen.de.ibm.com>
References: <49011234.7090902@gmail.com> <20081024110742.GD4620@osiris.boeblingen.de.ibm.com> <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 05:52:57AM -0700, w41ter@gmail.com wrote:
> On Fri, 24 Oct 2008, Heiko Carstens wrote:
> > On Thu, Oct 23, 2008 at 05:09:24PM -0700, walt wrote:
> > > Hi team,
> > >
> > > commit a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635
> > > Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> > > Date:   Mon Oct 13 23:50:08 2008 +0200
> > >
> > >     Call init_workqueues before pre smp initcalls.
> > >
> > > This commit causes the console login prompt to ignore my keystrokes
> > > so I'm unable to log in (though ssh works fine).  Oddly, if I hit
> > > ctrl-alt-delete the machine does reboot, but no other keystrokes
> > > appear on the screen or have any effect that I can detect.
> > >
> > > No surprise that this problem appears only on my dual-core amd64
> > > machine, while the k7 single processor machine works normally.
> > >
> > > I've not seen anyone else complaining on the linux list, so maybe
> > > this is a BIOS bug on the affected machine?  It's an ECS mobo with
> > > a GeForce6100PM-M2 chipset, and I use a ps/2 keyboard.
> >
> > Could you try the patch below and see if it makes any difference?
> > Thanks!
> 
> <patch snipped for brevity>
> 
> No difference that I can detect, sorry.  The login prompt still
> ignores my keystrokes.  I'm happy to try any other ideas or patches.
> (Yes, I did use git bisect to find this commit.)

Could you cc me on replies, please? Mails sent via vger.kernel.org reach
me with a lag of several hours.. so I might miss your reply. :)

Please try the patch below. It basically reverts the whole stop_machine
patches. That way we should know if it really comes from the moved init
call or if it is some other weird bug. I would have expected more bug
reports if the stop_machine patches would be broken. Hmmm...

diff -purN a/include/linux/workqueue.h b/include/linux/workqueue.h
--- a/include/linux/workqueue.h	2008-10-24 21:30:55.000000000 +0200
+++ b/include/linux/workqueue.h	2008-10-24 21:34:05.000000000 +0200
@@ -149,11 +149,11 @@ struct execute_work {
 
 extern struct workqueue_struct *
 __create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, int rt, struct lock_class_key *key,
+		       int freezeable, struct lock_class_key *key,
 		       const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
+#define __create_workqueue(name, singlethread, freezeable)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -164,19 +164,17 @@ __create_workqueue_key(const char *name,
 		__lock_name = #name;				\
 								\
 	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), (rt), &__key,	\
+			       (freezeable), &__key,		\
 			       __lock_name);			\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
-			       NULL, NULL)
+#define __create_workqueue(name, singlethread, freezeable)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), NULL, NULL)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name) __create_workqueue((name), 0, 0)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff -purN a/init/main.c b/init/main.c
--- a/init/main.c	2008-10-24 21:30:55.000000000 +0200
+++ b/init/main.c	2008-10-24 21:34:09.000000000 +0200
@@ -768,6 +768,8 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	rcu_init_sched(); /* needed by module_init stage. */
+	/* drivers will send hotplug events */
+	init_workqueues();
 	usermodehelper_init();
 	driver_init();
 	init_irq_proc();
@@ -851,8 +853,6 @@ static int __init kernel_init(void * unu
 
 	cad_pid = task_pid(current);
 
-	init_workqueues();
-
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
diff -purN a/kernel/stop_machine.c b/kernel/stop_machine.c
--- a/kernel/stop_machine.c	2008-10-24 21:30:55.000000000 +0200
+++ b/kernel/stop_machine.c	2008-10-24 21:34:01.000000000 +0200
@@ -37,13 +37,9 @@ struct stop_machine_data {
 /* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
 static unsigned int num_threads;
 static atomic_t thread_ack;
+static struct completion finished;
 static DEFINE_MUTEX(lock);
 
-static struct workqueue_struct *stop_machine_wq;
-static struct stop_machine_data active, idle;
-static const cpumask_t *active_cpus;
-static void *stop_machine_work;
-
 static void set_state(enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
@@ -55,26 +51,21 @@ static void set_state(enum stopmachine_s
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
-	if (atomic_dec_and_test(&thread_ack))
-		set_state(state + 1);
+	if (atomic_dec_and_test(&thread_ack)) {
+		/* If we're the last one to ack the EXIT, we're finished. */
+		if (state == STOPMACHINE_EXIT)
+			complete(&finished);
+		else
+			set_state(state + 1);
+	}
 }
 
-/* This is the actual function which stops the CPU. It runs
- * in the context of a dedicated stopmachine workqueue. */
-static void stop_cpu(struct work_struct *unused)
+/* This is the actual thread which stops the CPU.  It exits by itself rather
+ * than waiting for kthread_stop(), because it's easier for hotplug CPU. */
+static int stop_cpu(struct stop_machine_data *smdata)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	struct stop_machine_data *smdata = &idle;
-	int cpu = smp_processor_id();
-	int err;
-
-	if (!active_cpus) {
-		if (cpu == first_cpu(cpu_online_map))
-			smdata = &active;
-	} else {
-		if (cpu_isset(cpu, *active_cpus))
-			smdata = &active;
-	}
+
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
@@ -87,11 +78,9 @@ static void stop_cpu(struct work_struct 
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
-				/* On multiple CPUs only a single error code
-				 * is needed to tell that something failed. */
-				err = smdata->fn(smdata->data);
-				if (err)
-					smdata->fnret = err;
+				/* |= allows error detection if functions on
+				 * multiple CPUs. */
+				smdata->fnret |= smdata->fn(smdata->data);
 				break;
 			default:
 				break;
@@ -101,6 +90,7 @@ static void stop_cpu(struct work_struct 
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
+	do_exit(0);
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -111,34 +101,78 @@ static int chill(void *unused)
 
 int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
 {
-	struct work_struct *sm_work;
-	int i;
+	int i, err;
+	struct stop_machine_data active, idle;
+	struct task_struct **threads;
 
-	/* Set up initial state. */
-	mutex_lock(&lock);
-	num_threads = num_online_cpus();
-	active_cpus = cpus;
 	active.fn = fn;
 	active.data = data;
 	active.fnret = 0;
 	idle.fn = chill;
 	idle.data = NULL;
 
+	/* This could be too big for stack on large machines. */
+	threads = kcalloc(NR_CPUS, sizeof(threads[0]), GFP_KERNEL);
+	if (!threads)
+		return -ENOMEM;
+
+	/* Set up initial state. */
+	mutex_lock(&lock);
+	init_completion(&finished);
+	num_threads = num_online_cpus();
 	set_state(STOPMACHINE_PREPARE);
 
-	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
-	 * doesn't hit this CPU until we're ready. */
-	get_cpu();
 	for_each_online_cpu(i) {
-		sm_work = percpu_ptr(stop_machine_work, i);
-		INIT_WORK(sm_work, stop_cpu);
-		queue_work_on(i, stop_machine_wq, sm_work);
+		struct stop_machine_data *smdata = &idle;
+		struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+
+		if (!cpus) {
+			if (i == first_cpu(cpu_online_map))
+				smdata = &active;
+		} else {
+			if (cpu_isset(i, *cpus))
+				smdata = &active;
+		}
+
+		threads[i] = kthread_create((void *)stop_cpu, smdata, "kstop%u",
+					    i);
+		if (IS_ERR(threads[i])) {
+			err = PTR_ERR(threads[i]);
+			threads[i] = NULL;
+			goto kill_threads;
+		}
+
+		/* Place it onto correct cpu. */
+		kthread_bind(threads[i], i);
+
+		/* Make it highest prio. */
+		if (sched_setscheduler_nocheck(threads[i], SCHED_FIFO, &param))
+			BUG();
 	}
+
+	/* We've created all the threads.  Wake them all: hold this CPU so one
+	 * doesn't hit this CPU until we're ready. */
+	get_cpu();
+	for_each_online_cpu(i)
+		wake_up_process(threads[i]);
+
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	flush_workqueue(stop_machine_wq);
+	wait_for_completion(&finished);
 	mutex_unlock(&lock);
+
+	kfree(threads);
+
 	return active.fnret;
+
+kill_threads:
+	for_each_online_cpu(i)
+		if (threads[i])
+			kthread_stop(threads[i]);
+	mutex_unlock(&lock);
+
+	kfree(threads);
+	return err;
 }
 
 int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus)
@@ -153,11 +187,3 @@ int stop_machine(int (*fn)(void *), void
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
-
-static int __init stop_machine_init(void)
-{
-	stop_machine_wq = create_rt_workqueue("kstop");
-	stop_machine_work = alloc_percpu(struct work_struct);
-	return 0;
-}
-early_initcall(stop_machine_init);
diff -purN a/kernel/workqueue.c b/kernel/workqueue.c
--- a/kernel/workqueue.c	2008-10-24 21:30:55.000000000 +0200
+++ b/kernel/workqueue.c	2008-10-24 21:34:05.000000000 +0200
@@ -62,7 +62,6 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
-	int rt;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
@@ -767,7 +766,6 @@ init_cpu_workqueue(struct workqueue_stru
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct workqueue_struct *wq = cwq->wq;
 	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
@@ -783,8 +781,7 @@ static int create_workqueue_thread(struc
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-	if (cwq->wq->rt)
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+
 	cwq->thread = p;
 
 	return 0;
@@ -804,7 +801,6 @@ static void start_workqueue_thread(struc
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
-						int rt,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -826,7 +822,6 @@ struct workqueue_struct *__create_workqu
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
-	wq->rt = rt;
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
