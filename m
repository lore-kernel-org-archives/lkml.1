Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXDBFnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXDBFnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXDBFnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:43:41 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38684 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbXDBFnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:43:39 -0400
Date: Mon, 2 Apr 2007 11:12:06 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070402054206.GG12962@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053457.GA9076@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up workqueue.c from the perspective of freezer-based cpu-hotplug.
This patch
o Removes cpu_populated_map as cpu_online_map is safe to use.
o removes cwq_should_stop and uses kthread_should_stop instead.
o Reintroduces take_over_work from the worker_thread of a downed
  cpu. This means that all non-singlethreaded workqueues *have* to
  be frozen to avoid any races.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
--
 kernel/workqueue.c |  118 ++++++++++++++++++++++-------------------------------
 1 files changed, 50 insertions(+), 68 deletions(-)

Index: linux-2.6.21-rc4/kernel/workqueue.c
===================================================================
--- linux-2.6.21-rc4.orig/kernel/workqueue.c
+++ linux-2.6.21-rc4/kernel/workqueue.c
@@ -47,10 +47,6 @@ struct cpu_workqueue_struct {
 
 	struct workqueue_struct *wq;
 	struct task_struct *thread;
-	int status;
-	#define CWQ_RUNNING	0
-	#define CWQ_SHOULD_STOP	1
-	#define CWQ_STOPPED	2
 
 	int run_depth;		/* Detect run_workqueue() recursion depth */
 } ____cacheline_aligned;
@@ -75,7 +71,6 @@ static LIST_HEAD(workqueues);
 static int singlethread_cpu __read_mostly;
 static cpumask_t cpu_singlethread_map __read_mostly;
 /* optimization, we could use cpu_possible_map */
-static cpumask_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
 static inline int is_single_threaded(struct workqueue_struct *wq)
@@ -86,7 +81,7 @@ static inline int is_single_threaded(str
 static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_single_threaded(wq)
-		? &cpu_singlethread_map : &cpu_populated_map;
+		? &cpu_singlethread_map : &cpu_online_map;
 }
 
 static
@@ -270,32 +265,16 @@ static void run_workqueue(struct cpu_wor
 	spin_unlock_irq(&cwq->lock);
 }
 
-/*
- * NOTE: the caller must not touch *cwq if this func returns true
- */
-static int cwq_should_stop(struct cpu_workqueue_struct *cwq)
-{
-	int should_stop = cwq->status;
-
-	if (unlikely(should_stop == CWQ_SHOULD_STOP)) {
-		spin_lock_irq(&cwq->lock);
-		should_stop = cwq->status && list_empty(&cwq->worklist);
-		if (should_stop)
-			cwq->status= CWQ_STOPPED;
-		spin_unlock_irq(&cwq->lock);
-	}
-
-	return should_stop;
-}
 
 static int worker_thread(void *__cwq)
 {
 	struct cpu_workqueue_struct *cwq = __cwq;
+	int bind_cpu;
 	DEFINE_WAIT(wait);
 	struct k_sigaction sa;
 
 	freezer_exempt(cwq->wq->freeze_exempt_events);
-
+	bind_cpu = smp_processor_id();
 	/*
 	 * We inherited MPOL_INTERLEAVE from the booting kernel.
 	 * Set MPOL_DEFAULT to insure node local allocations.
@@ -308,20 +287,28 @@ static int worker_thread(void *__cwq)
 	siginitset(&sa.sa.sa_mask, sigmask(SIGCHLD));
 	do_sigaction(SIGCHLD, &sa, (struct k_sigaction *)0);
 
-	for (;;) {
+	while (!kthread_should_stop()) {
 		try_to_freeze();
-
+
+		if (cpu_is_offline(bind_cpu) && !is_single_threaded(cwq->wq))
+			goto wait_to_die;
+
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
-		if (cwq->status == CWQ_RUNNING && list_empty(&cwq->worklist))
+		if (list_empty(&cwq->worklist))
 			schedule();
 		finish_wait(&cwq->more_work, &wait);
 
-		if (cwq_should_stop(cwq))
-			break;
-
 		run_workqueue(cwq);
 	}
 
+wait_to_die:
+	set_current_state(TASK_INTERRUPTIBLE);
+	while(!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+
 	return 0;
 }
 
@@ -386,11 +373,10 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
 	might_sleep();
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_online_cpu(cpu)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -644,13 +630,6 @@ static int create_workqueue_thread(struc
 		return PTR_ERR(p);
 
 	cwq->thread = p;
-	cwq->status = CWQ_RUNNING;
-	if (!is_single_threaded(wq))
-		kthread_bind(p, cpu);
-
-	if (is_single_threaded(wq) || cpu_online(cpu))
-		wake_up_process(p);
-
 	return 0;
 }
 
@@ -680,15 +659,21 @@ static struct workqueue_struct *__create
 	if (singlethread) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
+		wake_up_process(cwq->thread);
 	} else {
 		mutex_lock(&workqueue_mutex);
 		list_add(&wq->list, &workqueues);
 
-		for_each_possible_cpu(cpu) {
+		for_each_online_cpu(cpu) {
 			cwq = init_cpu_workqueue(wq, cpu);
 			if (err || !cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
+			if (err)
+				continue;
+
+			kthread_bind(cwq->thread, cpu);
+			wake_up_process(cwq->thread);
 		}
 		mutex_unlock(&workqueue_mutex);
 	}
@@ -721,30 +706,11 @@ EXPORT_SYMBOL_GPL(create_singlethread_wo
 
 static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 {
-	struct wq_barrier barr;
-	int alive = 0;
 
-	spin_lock_irq(&cwq->lock);
 	if (cwq->thread != NULL) {
-		insert_wq_barrier(cwq, &barr, 1);
-		cwq->status = CWQ_SHOULD_STOP;
-		alive = 1;
-	}
-	spin_unlock_irq(&cwq->lock);
-
-	if (alive) {
 		thaw_process(cwq->thread);
-		wait_for_completion(&barr.done);
-
-		while (unlikely(cwq->status != CWQ_STOPPED))
-			cpu_relax();
-		/*
-		 * Wait until cwq->thread unlocks cwq->lock,
-		 * it won't touch *cwq after that.
-		 */
-		smp_rmb();
+		kthread_stop(cwq->thread);
 		cwq->thread = NULL;
-		spin_unlock_wait(&cwq->lock);
 	}
 }
 
@@ -756,15 +722,16 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
-	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
 	int cpu;
 
+	flush_workqueue(wq);
+
 	mutex_lock(&workqueue_mutex);
 	list_del(&wq->list);
 	mutex_unlock(&workqueue_mutex);
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_online_cpu(cpu) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
 		cleanup_workqueue_thread(cwq, cpu);
 	}
@@ -774,6 +741,25 @@ void destroy_workqueue(struct workqueue_
 }
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
+/*Take the work from this (downed) CPU. */
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
+	spin_unlock_irq(&cwq->lock);
+}
+
+
 static int __devinit workqueue_cpu_callback(struct notifier_block *nfb,
 						unsigned long action,
 						void *hcpu)
@@ -782,11 +768,6 @@ static int __devinit workqueue_cpu_callb
 	struct cpu_workqueue_struct *cwq;
 	struct workqueue_struct *wq;
 
-	switch (action) {
-	case CPU_UP_PREPARE:
-		cpu_set(cpu, cpu_populated_map);
-	}
-
 	mutex_lock(&workqueue_mutex);
 	list_for_each_entry(wq, &workqueues, list) {
 		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
@@ -799,6 +780,7 @@ static int __devinit workqueue_cpu_callb
 			return NOTIFY_BAD;
 
 		case CPU_ONLINE:
+			kthread_bind(cwq->thread, cpu);
 			wake_up_process(cwq->thread);
 			break;
 
@@ -806,6 +788,7 @@ static int __devinit workqueue_cpu_callb
 			if (cwq->thread)
 				wake_up_process(cwq->thread);
 		case CPU_DEAD:
+			take_over_work(wq, cpu);
 			cleanup_workqueue_thread(cwq, cpu);
 			break;
 		}
@@ -817,7 +800,6 @@ static int __devinit workqueue_cpu_callb
 
 void __init init_workqueues(void)
 {
-	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
 	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
