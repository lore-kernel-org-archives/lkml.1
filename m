Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZHXH5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZHXH5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZHXH5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:57:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45610 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbZHXH5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:05 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/7] workqueue: add support for lazy workqueues
Date: Mon, 24 Aug 2009 09:56:51 +0200
Message-Id: <1251100616-28604-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lazy workqueues are like normal workqueues, except they don't
start a thread per CPU by default. Instead threads are started
when they are needed, and exit when they have been idle for
some time.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |    5 +
 kernel/workqueue.c        |  203 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 194 insertions(+), 14 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ab5a16d..44cdd3c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -32,6 +32,7 @@ struct work_struct {
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
+	unsigned int cpu;
 };
 
 #define WORK_DATA_INIT()	ATOMIC_LONG_INIT(0)
@@ -172,6 +173,7 @@ enum {
 	WQ_F_SINGLETHREAD	= 1,
 	WQ_F_FREEZABLE		= 2,
 	WQ_F_RT			= 4,
+	WQ_F_LAZY		= 8,
 };
 
 #ifdef CONFIG_LOCKDEP
@@ -198,6 +200,7 @@ enum {
 	__create_workqueue((name), WQ_F_SINGLETHREAD | WQ_F_FREEZABLE)
 #define create_singlethread_workqueue(name)	\
 	__create_workqueue((name), WQ_F_SINGLETHREAD)
+#define create_lazy_workqueue(name)	__create_workqueue((name), WQ_F_LAZY)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
@@ -211,6 +214,8 @@ extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
+extern void workqueue_set_lazy_timeout(struct workqueue_struct *wq,
+			unsigned long timeout);
 
 extern int schedule_work(struct work_struct *work);
 extern int schedule_work_on(int cpu, struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 02ba7c9..8aba6a4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -61,11 +61,17 @@ struct workqueue_struct {
 	struct list_head list;
 	const char *name;
 	unsigned int flags;	/* WQ_F_* flags */
+	unsigned long lazy_timeout;
+	unsigned int core_cpu;
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
 };
 
+/* Default lazy workqueue timeout */
+#define WQ_DEF_LAZY_TIMEOUT	(60 * HZ)
+
+
 /* Serializes the accesses to the list of workqueues. */
 static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
@@ -81,6 +87,8 @@ static const struct cpumask *cpu_singlethread_map __read_mostly;
  */
 static cpumask_var_t cpu_populated_map __read_mostly;
 
+static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu);
+
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
 {
@@ -138,14 +146,37 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
 	wake_up(&cwq->more_work);
 }
 
+static inline bool wq_is_lazy(struct workqueue_struct *wq)
+{
+	return wq->flags & WQ_F_LAZY;
+}
+
 static void __queue_work(struct cpu_workqueue_struct *cwq,
 			 struct work_struct *work)
 {
+	struct workqueue_struct *wq = cwq->wq;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cwq->lock, flags);
-	insert_work(cwq, work, &cwq->worklist);
-	spin_unlock_irqrestore(&cwq->lock, flags);
+	/*
+	 * This is a lazy workqueue and this particular CPU thread has
+	 * exited. We can't create it from here, so add this work on our
+	 * static thread. It will create this thread and move the work there.
+	 */
+	if (wq_is_lazy(wq) && !cwq->thread) {
+		struct cpu_workqueue_struct *__cwq;
+
+		local_irq_save(flags);
+		__cwq = wq_per_cpu(wq, wq->core_cpu);
+		work->cpu = smp_processor_id();
+		spin_lock(&__cwq->lock);
+		insert_work(__cwq, work, &__cwq->worklist);
+		spin_unlock_irqrestore(&__cwq->lock, flags);
+	} else {
+		spin_lock_irqsave(&cwq->lock, flags);
+		work->cpu = smp_processor_id();
+		insert_work(cwq, work, &cwq->worklist);
+		spin_unlock_irqrestore(&cwq->lock, flags);
+	}
 }
 
 /**
@@ -259,13 +290,16 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-static void run_workqueue(struct cpu_workqueue_struct *cwq)
+static bool run_workqueue(struct cpu_workqueue_struct *cwq)
 {
+	bool did_work = false;
+
 	spin_lock_irq(&cwq->lock);
 	while (!list_empty(&cwq->worklist)) {
 		struct work_struct *work = list_entry(cwq->worklist.next,
 						struct work_struct, entry);
 		work_func_t f = work->func;
+		int cpu;
 #ifdef CONFIG_LOCKDEP
 		/*
 		 * It is permissible to free the struct work_struct
@@ -279,8 +313,51 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 #endif
 		trace_workqueue_execution(cwq->thread, work);
 		cwq->current_work = work;
-		list_del_init(cwq->worklist.next);
+		list_del_init(&work->entry);
+		cpu = smp_processor_id();
 		spin_unlock_irq(&cwq->lock);
+		did_work = true;
+
+		/*
+		 * If work->cpu isn't us, then we need to create the target
+		 * workqueue thread (if someone didn't already do that) and
+		 * move the work over there.
+		 */
+		if (wq_is_lazy(cwq->wq) && work->cpu != cpu) {
+			struct cpu_workqueue_struct *__cwq;
+			struct task_struct *p;
+			int err;
+
+			/*
+			 * Create new thread if we don't already have one
+			 * and move the work there. If we fail, fall through
+			 * and let this thread handle it
+			 */
+			__cwq = wq_per_cpu(cwq->wq, work->cpu);
+			spin_lock_irq(&__cwq->lock);
+			p = __cwq->thread;
+			spin_unlock_irq(&__cwq->lock);
+
+			if (!p)
+				err = create_workqueue_thread(__cwq, work->cpu);
+
+			spin_lock_irq(&__cwq->lock);
+			p = __cwq->thread;
+			if (p) {
+				insert_work(__cwq, work, &__cwq->worklist);
+				spin_unlock_irq(&__cwq->lock);
+				kthread_bind(p, work->cpu);
+				wake_up_process(p);
+				work = NULL;
+			} else
+				spin_unlock_irq(&__cwq->lock);
+		}
+
+		if (!work) {
+			spin_lock_irq(&cwq->lock);
+			cwq->current_work = NULL;
+			continue;
+		}
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
@@ -305,24 +382,44 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		cwq->current_work = NULL;
 	}
 	spin_unlock_irq(&cwq->lock);
+	return did_work;
 }
 
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
+	struct workqueue_struct *wq = cwq->wq;
+	unsigned long last_active = jiffies;
 	DEFINE_WAIT(wait);
+	int may_exit;
 
-	if (cwq->wq->flags & WQ_F_FREEZABLE)
+	if (wq->flags & WQ_F_FREEZABLE)
 		set_freezable();
 
 	set_user_nice(current, -5);
 
+	/*
+	 * Allow exit if this isn't our core thread
+	 */
+	if (wq_is_lazy(wq) && smp_processor_id() != wq->core_cpu)
+		may_exit = 1;
+	else
+		may_exit = 0;
+
 	for (;;) {
+		int did_work;
+
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
 		    !kthread_should_stop() &&
-		    list_empty(&cwq->worklist))
-			schedule();
+		    list_empty(&cwq->worklist)) {
+			unsigned long timeout = wq->lazy_timeout;
+
+			if (timeout && may_exit)
+				schedule_timeout(timeout + 1);
+			else
+				schedule();
+		}
 		finish_wait(&cwq->more_work, &wait);
 
 		try_to_freeze();
@@ -330,9 +427,29 @@ static int worker_thread(void *__cwq)
 		if (kthread_should_stop())
 			break;
 
-		run_workqueue(cwq);
+		did_work = run_workqueue(cwq);
+		if (!may_exit)
+			continue;
+
+		/*
+		 * If we did no work for the defined timeout period and we are
+		 * allowed to exit, do so.
+		 */
+		if (did_work)
+			last_active = jiffies;
+		else if (time_after(jiffies, last_active + wq->lazy_timeout)) {
+			spin_lock_irq(&cwq->lock);
+			cwq->thread = NULL;
+			spin_unlock_irq(&cwq->lock);
+			break;
+		}
 	}
 
+	/*
+	 * Thread is marked as gone now, re-check if work got added
+	 * between deciding to exit and really exiting
+	 */
+	run_workqueue(cwq);
 	return 0;
 }
 
@@ -355,6 +472,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 
 	init_completion(&barr->done);
 
+	barr->work.cpu = smp_processor_id();
 	insert_work(cwq, &barr->work, head);
 }
 
@@ -744,6 +862,7 @@ init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
+	cwq->thread = NULL;
 
 	return cwq;
 }
@@ -756,6 +875,7 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	struct task_struct *p;
 
 	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+
 	/*
 	 * Nobody can add the work_struct to this cwq,
 	 *	if (caller is __create_workqueue)
@@ -766,11 +886,23 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-	if (cwq->wq->flags & WQ_F_RT)
+	if (wq->flags & WQ_F_RT)
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-	cwq->thread = p;
 
-	trace_workqueue_creation(cwq->thread, cpu);
+	spin_lock_irq(&cwq->lock);
+	if (!cwq->thread) {
+		cwq->thread = p;
+		p = NULL;
+	}
+	spin_unlock_irq(&cwq->lock);
+
+	/*
+	 * If we raced on the thread creation, kill the new task
+	 */
+	if (p)
+		kthread_stop(p);
+	else
+		trace_workqueue_creation(cwq->thread, cpu);
 
 	return 0;
 }
@@ -814,7 +946,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
+		wq->core_cpu = singlethread_cpu;
 	} else {
+		int created = 0;
+
 		cpu_maps_update_begin();
 		/*
 		 * We must place this wq on list even if the code below fails.
@@ -833,10 +968,16 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		 */
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
+			if (err || !cpu_online(cpu) ||
+			    (created && wq_is_lazy(wq)))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
 			start_workqueue_thread(cwq, cpu);
+			if (!err) {
+				if (!created)
+					wq->core_cpu = cpu;
+				created++;
+			}
 		}
 		cpu_maps_update_done();
 	}
@@ -844,7 +985,9 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (err) {
 		destroy_workqueue(wq);
 		wq = NULL;
-	}
+	} else if (wq_is_lazy(wq))
+		workqueue_set_lazy_timeout(wq, WQ_DEF_LAZY_TIMEOUT);
+
 	return wq;
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
@@ -877,6 +1020,13 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	cwq->thread = NULL;
 }
 
+static bool hotplug_should_start_thread(struct workqueue_struct *wq, int cpu)
+{
+	if (wq_is_lazy(wq) && cpu != wq->core_cpu)
+		return 0;
+	return 1;
+}
+
 /**
  * destroy_workqueue - safely terminate a workqueue
  * @wq: target workqueue
@@ -923,6 +1073,8 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			if (!hotplug_should_start_thread(wq, cpu))
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
@@ -932,6 +1084,8 @@ undo:
 			goto undo;
 
 		case CPU_ONLINE:
+			if (!hotplug_should_start_thread(wq, cpu))
+				break;
 			start_workqueue_thread(cwq, cpu);
 			break;
 
@@ -999,6 +1153,27 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 EXPORT_SYMBOL_GPL(work_on_cpu);
 #endif /* CONFIG_SMP */
 
+/**
+ * workqueue_set_lazy_timeout - set lazy exit timeout
+ * @wq: the associated workqueue_struct
+ * @timeout: timeout in jiffies
+ *
+ * This will set the timeout for a lazy workqueue. If no work has been
+ * processed for @timeout jiffies, then the workqueue is allowed to exit.
+ * It will be dynamically created again when work is queued to it.
+ *
+ * Note that this only works for workqueues created with
+ * create_lazy_workqueue().
+ */
+void workqueue_set_lazy_timeout(struct workqueue_struct *wq,
+				unsigned long timeout)
+{
+	if (WARN_ON(!wq_is_lazy(wq)))
+		return;
+
+	wq->lazy_timeout = timeout;
+}
+
 void __init init_workqueues(void)
 {
 	alloc_cpumask_var(&cpu_populated_map, GFP_KERNEL);
-- 
1.6.4.173.g3f189

