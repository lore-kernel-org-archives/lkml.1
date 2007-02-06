Return-Path: <linux-kernel-owner+w=401wt.eu-S1030583AbXBFXaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030583AbXBFXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:30:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030584AbXBFXay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:30:54 -0500
Received: from mail.screens.ru ([213.234.233.54]:58452 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030574AbXBFXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:30:27 -0500
Date: Wed, 7 Feb 2007 02:30:25 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] workqueue: introduce cpu_singlethread_map
Message-ID: <20070206233025.GA111@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The code like

	if (is_single_threaded(wq))
		do_something(singlethread_cpu);
	else {
		for_each_cpu_mask(cpu, cpu_populated_map)
			do_something(cpu);
	}

looks very annoying. We can add "static cpumask_t cpu_singlethread_map" and
simplify the code. Lessens .text a bit, and imho makes the code more readable.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 6.20-rc6-mm3/kernel/workqueue.c~4_ss_cpus	2007-02-06 23:42:43.000000000 +0300
+++ 6.20-rc6-mm3/kernel/workqueue.c	2007-02-07 00:44:52.000000000 +0300
@@ -69,6 +69,7 @@ static DEFINE_MUTEX(workqueue_mutex);
 static LIST_HEAD(workqueues);
 
 static int singlethread_cpu __read_mostly;
+static cpumask_t cpu_singlethread_map __read_mostly;
 /* optimization, we could use cpu_possible_map */
 static cpumask_t cpu_populated_map __read_mostly;
 
@@ -78,6 +79,12 @@ static inline int is_single_threaded(str
 	return list_empty(&wq->list);
 }
 
+static const cpumask_t *wq_cpu_map(struct workqueue_struct *wq)
+{
+	return is_single_threaded(wq)
+		? &cpu_singlethread_map : &cpu_populated_map;
+}
+
 /*
  * Set the workqueue on which a work item is to be run
  * - Must *only* be called if the pending flag is set
@@ -393,14 +400,11 @@ static void flush_cpu_workqueue(struct c
  */
 void fastcall flush_workqueue(struct workqueue_struct *wq)
 {
-	if (is_single_threaded(wq))
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, singlethread_cpu));
-	else {
-		int cpu;
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
+	int cpu;
 
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -437,7 +441,9 @@ static void wait_on_work(struct cpu_work
  */
 void flush_work(struct workqueue_struct *wq, struct work_struct *work)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
 	cwq = get_wq_data(work);
 	/* Was it ever queued ? */
@@ -453,14 +459,8 @@ void flush_work(struct workqueue_struct 
 	work_release(work);
 	spin_unlock_irq(&cwq->lock);
 
-	if (is_single_threaded(wq))
-		wait_on_work(per_cpu_ptr(wq->cpu_wq, singlethread_cpu), work);
-	else {
-		int cpu;
-
-		for_each_cpu_mask(cpu, cpu_populated_map)
-			wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
-	}
+	for_each_cpu_mask(cpu, *cpu_map)
+		wait_on_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -753,22 +753,17 @@ static void cleanup_workqueue_thread(str
  */
 void destroy_workqueue(struct workqueue_struct *wq)
 {
+	const cpumask_t *cpu_map = wq_cpu_map(wq);
 	struct cpu_workqueue_struct *cwq;
+	int cpu;
 
-	if (is_single_threaded(wq)) {
-		cwq = per_cpu_ptr(wq->cpu_wq, singlethread_cpu);
-		cleanup_workqueue_thread(cwq, singlethread_cpu);
-	} else {
-		int cpu;
-
-		mutex_lock(&workqueue_mutex);
-		list_del(&wq->list);
-		mutex_unlock(&workqueue_mutex);
+	mutex_lock(&workqueue_mutex);
+	list_del(&wq->list);
+	mutex_unlock(&workqueue_mutex);
 
-		for_each_cpu_mask(cpu, cpu_populated_map) {
-			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-			cleanup_workqueue_thread(cwq, cpu);
-		}
+	for_each_cpu_mask(cpu, *cpu_map) {
+		cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+		cleanup_workqueue_thread(cwq, cpu);
 	}
 
 	free_percpu(wq->cpu_wq);
@@ -827,6 +822,7 @@ void init_workqueues(void)
 {
 	cpu_populated_map = cpu_online_map;
 	singlethread_cpu = first_cpu(cpu_possible_map);
+	cpu_singlethread_map = cpumask_of_cpu(singlethread_cpu);
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);

