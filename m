Return-Path: <linux-kernel-owner+w=401wt.eu-S932323AbXBNOnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbXBNOnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 09:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbXBNOnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 09:43:13 -0500
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:44791 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbXBNOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 09:43:12 -0500
Date: Wed, 14 Feb 2007 20:13:05 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu
Cc: vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru, rjw@sisk.pl
Subject: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070214144305.GB19789@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214144229.GA19789@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts all the recent workqueue hacks added to make it 
hotplug safe. 

Signed-off-by : Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by : Gautham R Shenoy <ego@in.ibm.com> 

 kernel/workqueue.c |  225 +++++++++++++++++++++++------------------------------
 1 files changed, 98 insertions(+), 127 deletions(-)

Index: hotplug/kernel/workqueue.c
===================================================================
--- hotplug.orig/kernel/workqueue.c
+++ hotplug/kernel/workqueue.c
@@ -47,7 +47,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	int should_stop;
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -65,7 +64,7 @@ struct workqueue_struct {
 
 /* All the per-cpu workqueues on the system, for hotplug cpu to add/remove
    threads to each one as cpus come/go. */
-static DEFINE_MUTEX(workqueue_mutex);
+static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
@@ -344,24 +343,6 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irqrestore(&cwq->lock, flags);
 }
 
-/*
- * NOTE: the caller must not touch *cwq if this func returns true
- */
-static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
-{
-	int should_stop = cwq->should_stop;
-
-	if (unlikely(should_stop)) {
-		spin_lock_irq(&cwq->lock);
-		should_stop = cwq->should_stop && list_empty(&cwq->worklist);
-		if (should_stop)
-			cwq->thread = NULL;
-		spin_unlock_irq(&cwq->lock);
-	}
-
-	return should_stop;
-}
-
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
@@ -392,7 +373,7 @@ static int worker_thread(void *__cwq)
 	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
-	for (;;) {
+	while (!kthread_should_stop()) {
 		if (cwq->wq->freezeable) {
 			try_to_freeze();
 			if (cpu_is_offline(bind_cpu))
@@ -400,14 +381,12 @@ static int worker_thread(void *__cwq)
 		}
 
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (!cwq->should_stop && list_empty(&cwq->worklist))
+		if (list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
-		if (cwq_should_stop(cwq))
-			break;
-
-		run_workqueue(cwq);
+		if (!list_empty(&cwq->worklist))
+			run_workqueue(cwq);
 	}
 
 	return 0;
@@ -445,9 +424,6 @@ static void insert_wq_barrier(struct cpu
 	insert_work(cwq, &barr->work, tail);
 }
 
-/* optimization, we could use cpu_possible_map */
-static cpumask_t cpu_populated_map __read_mostly;
-
 static void flush_cpu_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	if (cwq->thread == current) {
@@ -492,7 +468,7 @@ void fastcall flush_workqueue(struct wor
 	else {
 		int cpu;
 
-		for_each_cpu_mask(cpu, cpu_populated_map)
+		for_each_online_cpu(cpu)
 			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 	}
 }
@@ -552,7 +528,7 @@ void flush_work(struct workqueue_struct 
 	else {
 		int cpu;
 
-		for_each_cpu_mask(cpu, cpu_populated_map)
+		for_each_online_cpu(cpu)
 			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 	}
 }
@@ -737,43 +713,25 @@ init_cpu_workqueue(struct workqueue_stru
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
 	struct task_struct *p;
+	struct workqueue_struct *wq = cwq->wq;
+	const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
 
-	spin_lock_irq(&cwq->lock);
-	cwq->should_stop = 0;
-	p = cwq->thread;
-	spin_unlock_irq(&cwq->lock);
-
-	if (!p) {
-		struct workqueue_struct *wq = cwq->wq;
-		const char *fmt = is_single_threaded(wq) ? "%s" : "%s/%d";
-
-		p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
-		/*
-		 * Nobody can add the work_struct to this cwq,
-		 *	if (caller is __create_workqueue)
-		 *		nobody should see this wq
-		 *	else // caller is CPU_UP_PREPARE
-		 *		cpu is not on cpu_online_map
-		 * so we can abort safely.
-		 */
-		if (IS_ERR(p))
-			return PTR_ERR(p);
-
-		cwq->thread = p;
-		if (!is_single_threaded(wq))
-			kthread_bind(p, cpu);
-		/*
-		 * Cancels affinity if the caller is CPU_UP_PREPARE.
-		 * Needs a cleanup, but OK.
-		 */
-		wake_up_process(p);
-	}
+	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);
+	/*
+	 * Nobody can add the work_struct to this cwq,
+	 *	if (caller is __create_workqueue)
+	 *		nobody should see this wq
+	 *	else // caller is CPU_UP_PREPARE
+	 *		cpu is not on cpu_online_map
+	 * so we can abort safely.
+	 */
+	if (IS_ERR(p))
+		return PTR_ERR(p);
 
+	cwq->thread = p;
 	return 0;
 }
 
-static int embryonic_cpu __read_mostly = -1;
-
 struct workqueue_struct *__create_workqueue(const char *name,
 					    int singlethread, int freezeable)
 {
@@ -798,17 +756,20 @@ struct workqueue_struct *__create_workqu
 		INIT_LIST_HEAD(&wq->list);
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
+		if (!err)
+			wake_up_process(cwq->thread);
 	} else {
-		mutex_lock(&workqueue_mutex);
+		spin_lock(&workqueue_lock);
 		list_add(&wq->list, &workqueues);
-
-		for_each_possible_cpu(cpu) {
+		spin_unlock(&workqueue_lock);
+		for_each_online_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
-			if (err || !(cpu_online(cpu) || cpu == embryonic_cpu))
-				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			if (err)
+				break;
+			kthread_bind(cwq->thread, cpu);
+			wake_up_process(cwq->thread);
 		}
-		mutex_unlock(&workqueue_mutex);
 	}
 
 	if (err) {
@@ -822,28 +783,10 @@ EXPORT_SYMBOL_GPL(__create_workqueue);
 static void cleanup_workqueue_thread(struct workqueue_struct *wq, int cpu)
 {
 	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-	struct wq_barrier barr;
-	int alive = 0;
 
-	spin_lock_irq(&cwq->lock);
 	if (cwq->thread != NULL) {
-		insert_wq_barrier(cwq, &barr, 1);
-		cwq->should_stop = 1;
-		alive = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
-
-	if (alive) {
-		wait_for_completion(&barr.done);
-
-		while (unlikely(cwq->thread != NULL))
-			cpu_relax();
-		/*
-		 * Wait until cwq->thread unlocks cwq->lock,
-		 * it won't touch *cwq after that.
-		 */
-		smp_rmb();
-		spin_unlock_wait(&cwq->lock);
+		kthread_stop(cwq->thread);
+		cwq->thread = NULL;
 	}
 }
 
@@ -855,17 +798,18 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	flush_workqueue(wq);
+
 	if (is_single_threaded(wq))
 		cleanup_workqueue_thread(wq, singlethread_cpu);
 	else {
 		int cpu;
 
-		mutex_lock(&workqueue_mutex);
-		list_del(&wq->list);
-		mutex_unlock(&workqueue_mutex);
-
-		for_each_cpu_mask(cpu, cpu_populated_map)
+		for_each_online_cpu(cpu)
 			cleanup_workqueue_thread(wq, cpu);
+		spin_lock(&workqueue_lock);
+		list_del(&wq->list);
+		spin_unlock(&workqueue_lock);
 	}
 
 	free_percpu(wq->cpu_wq);
@@ -873,55 +817,82 @@ void destroy_workqueue(struct workqueue_
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
+/* Take the work from this (downed) CPU. */
+static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)
+{
+	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct list_head list;
+	struct work_struct *work;
+
+	spin_lock_irq(&cwq->lock);
+	list_replace_init(&cwq->worklist, &list);
+
+	while (!list_empty(&list)) {
+		work = list_entry(list.next,struct work_struct,entry);
+		list_del(&work->entry);
+		__queue_work(per_cpu_ptr(wq->cpu_wq, smp_processor_id()), work);
+	}
+
+	spin_unlock_irq(&cwq->lock);
+}
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
 {
 	struct workqueue_struct *wq;
 	struct cpu_workqueue_struct *cwq;
-	unsigned int cpu = (unsigned long)hcpu;
-	int ret = NOTIFY_OK;
+	unsigned int hotcpu = (unsigned long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		/* Create a new workqueue thread for it. */
+		list_for_each_entry(wq, &workqueues, list) {
+			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
+			if (create_workqueue_thread(cwq, hotcpu)) {
+				printk("workqueue for %i failed\n", hotcpu);
+				return NOTIFY_BAD;
+			}
+		}
+		break;
 
-	mutex_lock(&workqueue_mutex);
-	embryonic_cpu = -1;
-	if (action == CPU_UP_PREPARE) {
-		cpu_set(cpu, cpu_populated_map);
-		embryonic_cpu = cpu;
-	}
-
-	list_for_each_entry(wq, &workqueues, list) {
-		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
-		switch (action) {
-		case CPU_UP_PREPARE:
-			if (create_workqueue_thread(cwq, cpu))
-				ret = NOTIFY_BAD;
-			break;
-
-		case CPU_ONLINE:
-			set_cpus_allowed(cwq->thread, cpumask_of_cpu(cpu));
-			break;
-
-		case CPU_UP_CANCELED:
-		case CPU_DEAD:
-			cwq->should_stop = 1;
-			wake_up(&cwq->more_work);
-			break;
+	case CPU_ONLINE:
+		/* Kick off worker threads. */
+		list_for_each_entry(wq, &workqueues, list) {
+			struct cpu_workqueue_struct *cwq;
+
+			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
+			kthread_bind(cwq->thread, hotcpu);
+			wake_up_process(cwq->thread);
 		}
+		break;
 
-		if (ret != NOTIFY_OK) {
-			printk(KERN_ERR "workqueue for %i failed\n", cpu);
-			break;
+	case CPU_UP_CANCELED:
+		list_for_each_entry(wq, &workqueues, list) {
+			if (!per_cpu_ptr(wq->cpu_wq, hotcpu)->thread)
+				continue;
+			/* Unbind so it can run. */
+			kthread_bind(per_cpu_ptr(wq->cpu_wq, hotcpu)->thread,
+				any_online_cpu(cpu_online_map));
+			cleanup_workqueue_thread(wq, hotcpu);
 		}
+		break;
+
+	case CPU_DEAD:
+		list_for_each_entry(wq, &workqueues, list)
+			take_over_work(wq, hotcpu);
+		break;
+
+	case CPU_DEAD_KILL_THREADS:
+		list_for_each_entry(wq, &workqueues, list)
+			cleanup_workqueue_thread(wq, hotcpu);
 	}
-	mutex_unlock(&workqueue_mutex);
 
-	return ret;
+	return NOTIFY_OK;
 }
 
 void init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
