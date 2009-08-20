Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZHTKR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZHTKR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbZHTKR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:17:56 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60138 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbZHTKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/6] workqueue: add support for lazy workqueues
Date: Thu, 20 Aug 2009 12:17:39 +0200
Message-Id: <1250763466-24282-5-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-4-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lazy workqueues are like normal workqueues, except they don't
start a thread per CPU by default. Instead threads are started
when they are needed, and exit when they have been idle for
some time.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |    5 ++
 kernel/workqueue.c        |  152 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 147 insertions(+), 10 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f14e20e..b2dd267 100644
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
index 02ba7c9..d9ccebc 100644
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
@@ -141,11 +149,29 @@ static void insert_work(struct cpu_workqueue_struct *cwq,
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
+	if ((wq->flags & WQ_F_LAZY) && !cwq->thread) {
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
@@ -259,13 +285,16 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
-static void run_workqueue(struct cpu_workqueue_struct *cwq)
+static int run_workqueue(struct cpu_workqueue_struct *cwq)
 {
+	int did_work = 0;
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
@@ -280,7 +309,34 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		trace_workqueue_execution(cwq->thread, work);
 		cwq->current_work = work;
 		list_del_init(cwq->worklist.next);
+		cpu = smp_processor_id();
 		spin_unlock_irq(&cwq->lock);
+		did_work = 1;
+
+		/*
+		 * If work->cpu isn't us, then we need to create the target
+		 * workqueue thread (if someone didn't already do that) and
+		 * move the work over there.
+		 */
+		if ((cwq->wq->flags & WQ_F_LAZY) && work->cpu != cpu) {
+			struct cpu_workqueue_struct *__cwq;
+			struct task_struct *p;
+			int err;
+
+			__cwq = wq_per_cpu(cwq->wq, work->cpu);
+			p = __cwq->thread;
+			if (!p)
+				err = create_workqueue_thread(__cwq, work->cpu);
+			p = __cwq->thread;
+			if (p) {
+				if (work->cpu >= 0)
+					kthread_bind(p, work->cpu);
+				insert_work(__cwq, work, &__cwq->worklist);
+				wake_up_process(p);
+				goto out;
+			}
+		}
+
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
@@ -305,24 +361,45 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 		cwq->current_work = NULL;
 	}
 	spin_unlock_irq(&cwq->lock);
+out:
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
+	if ((wq->flags & WQ_F_LAZY) && smp_processor_id() != wq->core_cpu)
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
+				schedule_timeout(timeout);
+			else
+				schedule();
+		}
 		finish_wait(&cwq->more_work, &wait);
 
 		try_to_freeze();
@@ -330,7 +407,19 @@ static int worker_thread(void *__cwq)
 		if (kthread_should_stop())
 			break;
 
-		run_workqueue(cwq);
+		did_work = run_workqueue(cwq);
+
+		/*
+		 * If we did no work for the defined timeout period and we are
+		 * allowed to exit, do so.
+		 */
+		if (did_work)
+			last_active = jiffies;
+		else if (time_after(jiffies, last_active + wq->lazy_timeout) &&
+			 may_exit) {
+			cwq->thread = NULL;
+			break;
+		}
 	}
 
 	return 0;
@@ -814,7 +903,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
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
@@ -833,10 +925,16 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		 */
 		for_each_possible_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !cpu_online(cpu))
+			if (err || !cpu_online(cpu) ||
+			    (created && (wq->flags & WQ_F_LAZY)))
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
@@ -844,7 +942,9 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (err) {
 		destroy_workqueue(wq);
 		wq = NULL;
-	}
+	} else if (wq->flags & WQ_F_LAZY)
+		workqueue_set_lazy_timeout(wq, WQ_DEF_LAZY_TIMEOUT);
+
 	return wq;
 }
 EXPORT_SYMBOL_GPL(__create_workqueue_key);
@@ -877,6 +977,13 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	cwq->thread = NULL;
 }
 
+static bool hotplug_should_start_thread(struct workqueue_struct *wq, int cpu)
+{
+	if ((wq->flags & WQ_F_LAZY) && cpu != wq->core_cpu)
+		return 0;
+	return 1;
+}
+
 /**
  * destroy_workqueue - safely terminate a workqueue
  * @wq: target workqueue
@@ -923,6 +1030,8 @@ undo:
 
 		switch (action) {
 		case CPU_UP_PREPARE:
+			if (!hotplug_should_start_thread(wq, cpu))
+				break;
 			if (!create_workqueue_thread(cwq, cpu))
 				break;
 			printk(KERN_ERR "workqueue [%s] for %i failed\n",
@@ -932,6 +1041,8 @@ undo:
 			goto undo;
 
 		case CPU_ONLINE:
+			if (!hotplug_should_start_thread(wq, cpu))
+				break;
 			start_workqueue_thread(cwq, cpu);
 			break;
 
@@ -999,6 +1110,27 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
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
+	if (WARN_ON(!(wq->flags & WQ_F_LAZY)))
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

