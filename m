Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936171Ab0BZMYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:24:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:43310 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935886Ab0BZMOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:14:23 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/43] stop_machine: reimplement without using workqueue
Date: Fri, 26 Feb 2010 21:22:47 +0900
Message-Id: <1267187000-18791-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 12:13:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stop_machine() is the only user of RT workqueue.  Reimplement it using
kthreads directly and rip RT support from workqueue.  This is in
preparation of concurrency managed workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/stop_machine.h |    6 ++
 include/linux/workqueue.h    |   20 +++---
 init/main.c                  |    2 +
 kernel/stop_machine.c        |  151 ++++++++++++++++++++++++++++++++++-------
 kernel/workqueue.c           |    6 --
 5 files changed, 142 insertions(+), 43 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index baba3a2..2d32e06 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -53,6 +53,11 @@ int stop_machine_create(void);
  */
 void stop_machine_destroy(void);
 
+/**
+ * init_stop_machine: initialize stop_machine during boot
+ */
+void init_stop_machine(void);
+
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -67,6 +72,7 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 
 static inline int stop_machine_create(void) { return 0; }
 static inline void stop_machine_destroy(void) { }
+static inline void init_stop_machine(void) { }
 
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 9466e86..0697946 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -181,12 +181,11 @@ static inline void destroy_work_on_stack(struct work_struct *work) { }
 
 
 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+__create_workqueue_key(const char *name, int singlethread, int freezeable,
+		       struct lock_class_key *key, const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
+#define __create_workqueue(name, singlethread, freezeable)	\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -197,19 +196,18 @@ __create_workqueue_key(const char *name, int singlethread,
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
+#define __create_workqueue(name, singlethread, freezeable)	\
+	__create_workqueue_key((name), (singlethread), (freezeable), \
 			       NULL, NULL)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name) __create_workqueue((name), 0, 0)
+#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
+#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/init/main.c b/init/main.c
index 4cb47a1..8cf7543 100644
--- a/init/main.c
+++ b/init/main.c
@@ -34,6 +34,7 @@
 #include <linux/security.h>
 #include <linux/smp.h>
 #include <linux/workqueue.h>
+#include <linux/stop_machine.h>
 #include <linux/profile.h>
 #include <linux/rcupdate.h>
 #include <linux/moduleparam.h>
@@ -769,6 +770,7 @@ static void __init do_initcalls(void)
 static void __init do_basic_setup(void)
 {
 	init_workqueues();
+	init_stop_machine();
 	cpuset_init_smp();
 	usermodehelper_init();
 	init_tmpfs();
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 912823e..671a4ac 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -25,6 +25,8 @@ enum stopmachine_state {
 	STOPMACHINE_RUN,
 	/* Exit */
 	STOPMACHINE_EXIT,
+	/* Done */
+	STOPMACHINE_DONE,
 };
 static enum stopmachine_state state;
 
@@ -42,10 +44,9 @@ static DEFINE_MUTEX(lock);
 static DEFINE_MUTEX(setup_lock);
 /* Users of stop_machine. */
 static int refcount;
-static struct workqueue_struct *stop_machine_wq;
+static struct task_struct **stop_machine_threads;
 static struct stop_machine_data active, idle;
 static const struct cpumask *active_cpus;
-static void *stop_machine_work;
 
 static void set_state(enum stopmachine_state newstate)
 {
@@ -63,14 +64,31 @@ static void ack_state(void)
 }
 
 /* This is the actual function which stops the CPU. It runs
- * in the context of a dedicated stopmachine workqueue. */
-static void stop_cpu(struct work_struct *unused)
+ * on dedicated per-cpu kthreads. */
+static int stop_cpu(void *unused)
 {
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	struct stop_machine_data *smdata = &idle;
+	struct stop_machine_data *smdata;
 	int cpu = smp_processor_id();
 	int err;
 
+repeat:
+	/* Wait for __stop_machine() to initiate */
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		/* <- kthread_stop() and __stop_machine()::smp_wmb() */
+		if (kthread_should_stop()) {
+			__set_current_state(TASK_RUNNING);
+			return 0;
+		}
+		if (state == STOPMACHINE_PREPARE)
+			break;
+		schedule();
+	}
+	smp_rmb();	/* <- __stop_machine()::set_state() */
+
+	/* Okay, let's go */
+	smdata = &idle;
 	if (!active_cpus) {
 		if (cpu == cpumask_first(cpu_online_mask))
 			smdata = &active;
@@ -104,6 +122,7 @@ static void stop_cpu(struct work_struct *unused)
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
+	goto repeat;
 }
 
 /* Callback for CPUs which aren't supposed to do anything. */
@@ -112,46 +131,122 @@ static int chill(void *unused)
 	return 0;
 }
 
+static int create_stop_machine_thread(unsigned int cpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
+	struct task_struct **pp = per_cpu_ptr(stop_machine_threads, cpu);
+	struct task_struct *p;
+
+	if (*pp)
+		return -EBUSY;
+
+	p = kthread_create(stop_cpu, NULL, "kstop/%u", cpu);
+	if (IS_ERR(p))
+		return PTR_ERR(p);
+
+	sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+	*pp = p;
+	return 0;
+}
+
+/* Should be called with cpu hotplug disabled and setup_lock held */
+static void kill_stop_machine_threads(void)
+{
+	unsigned int cpu;
+
+	if (!stop_machine_threads)
+		return;
+
+	for_each_online_cpu(cpu) {
+		struct task_struct *p = *per_cpu_ptr(stop_machine_threads, cpu);
+		if (p)
+			kthread_stop(p);
+	}
+	free_percpu(stop_machine_threads);
+	stop_machine_threads = NULL;
+}
+
 int stop_machine_create(void)
 {
+	unsigned int cpu;
+
+	get_online_cpus();
 	mutex_lock(&setup_lock);
 	if (refcount)
 		goto done;
-	stop_machine_wq = create_rt_workqueue("kstop");
-	if (!stop_machine_wq)
-		goto err_out;
-	stop_machine_work = alloc_percpu(struct work_struct);
-	if (!stop_machine_work)
+
+	stop_machine_threads = alloc_percpu(struct task_struct *);
+	if (!stop_machine_threads)
 		goto err_out;
+
+	/*
+	 * cpu hotplug is disabled, create only for online cpus,
+	 * cpu_callback() will handle cpu hot [un]plugs.
+	 */
+	for_each_online_cpu(cpu) {
+		if (create_stop_machine_thread(cpu))
+			goto err_out;
+		kthread_bind(*per_cpu_ptr(stop_machine_threads, cpu), cpu);
+	}
 done:
 	refcount++;
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 	return 0;
 
 err_out:
-	if (stop_machine_wq)
-		destroy_workqueue(stop_machine_wq);
+	kill_stop_machine_threads();
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 	return -ENOMEM;
 }
 EXPORT_SYMBOL_GPL(stop_machine_create);
 
 void stop_machine_destroy(void)
 {
+	get_online_cpus();
 	mutex_lock(&setup_lock);
-	refcount--;
-	if (refcount)
-		goto done;
-	destroy_workqueue(stop_machine_wq);
-	free_percpu(stop_machine_work);
-done:
+	if (!--refcount)
+		kill_stop_machine_threads();
 	mutex_unlock(&setup_lock);
+	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(stop_machine_destroy);
 
+static int __cpuinit stop_machine_cpu_callback(struct notifier_block *nfb,
+					       unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct task_struct **pp = per_cpu_ptr(stop_machine_threads, cpu);
+
+	/* Hotplug exclusion is enough, no need to worry about setup_lock */
+	if (!stop_machine_threads)
+		return NOTIFY_OK;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		if (create_stop_machine_thread(cpu)) {
+			printk(KERN_ERR "failed to create stop machine "
+			       "thread for %u\n", cpu);
+			return NOTIFY_BAD;
+		}
+		break;
+
+	case CPU_ONLINE:
+		kthread_bind(*pp, cpu);
+		break;
+
+	case CPU_UP_CANCELED:
+	case CPU_POST_DEAD:
+		kthread_stop(*pp);
+		*pp = NULL;
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
-	struct work_struct *sm_work;
 	int i, ret;
 
 	/* Set up initial state. */
@@ -164,19 +259,18 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 	idle.fn = chill;
 	idle.data = NULL;
 
-	set_state(STOPMACHINE_PREPARE);
+	set_state(STOPMACHINE_PREPARE);	/* -> stop_cpu()::smp_rmb() */
+	smp_wmb();			/* -> stop_cpu()::set_current_state() */
 
 	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
-	for_each_online_cpu(i) {
-		sm_work = per_cpu_ptr(stop_machine_work, i);
-		INIT_WORK(sm_work, stop_cpu);
-		queue_work_on(i, stop_machine_wq, sm_work);
-	}
+	for_each_online_cpu(i)
+		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));
 	/* This will release the thread on our CPU. */
 	put_cpu();
-	flush_workqueue(stop_machine_wq);
+	while (state < STOPMACHINE_DONE)
+		yield();
 	ret = active.fnret;
 	mutex_unlock(&lock);
 	return ret;
@@ -197,3 +291,8 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
+
+void __init init_stop_machine(void)
+{
+	hotcpu_notifier(stop_machine_cpu_callback, 0);
+}
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f7a914f..115f30b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -62,7 +62,6 @@ struct workqueue_struct {
 	const char *name;
 	int singlethread;
 	int freezeable;		/* Freeze threads during suspend */
-	int rt;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
@@ -923,7 +922,6 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 	struct workqueue_struct *wq = cwq->wq;
 	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
 	struct task_struct *p;
@@ -939,8 +937,6 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-	if (cwq->wq->rt)
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
 	trace_workqueue_creation(cwq->thread, cpu);
@@ -962,7 +958,6 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 struct workqueue_struct *__create_workqueue_key(const char *name,
 						int singlethread,
 						int freezeable,
-						int rt,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -984,7 +979,6 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
 	wq->singlethread = singlethread;
 	wq->freezeable = freezeable;
-	wq->rt = rt;
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
-- 
1.6.4.2

