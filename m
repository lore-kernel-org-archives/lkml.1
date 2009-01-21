Return-Path: <linux-kernel-owner+w=401wt.eu-S1762193AbZAUJnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762193AbZAUJnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 04:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZAUJni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 04:43:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56405 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZAUJnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:43:37 -0500
Message-ID: <4976EE0B.5090200@cn.fujitsu.com>
Date: Wed, 21 Jan 2009 17:42:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: don't alloc_percpu for single workqueue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


allocating memory for every cpu for single workqueue is waste.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..ecd693d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -99,7 +99,7 @@ static
 struct cpu_workqueue_struct *wq_per_cpu(struct workqueue_struct *wq, int cpu)
 {
 	if (unlikely(is_wq_single_threaded(wq)))
-		cpu = singlethread_cpu;
+		return wq->cpu_wq;
 	return per_cpu_ptr(wq->cpu_wq, cpu);
 }
 
@@ -417,7 +417,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
 	for_each_cpu_mask_nr(cpu, *cpu_map)
-		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
+		flush_cpu_workqueue(wq_per_cpu(wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
 
@@ -548,7 +548,7 @@ static void wait_on_work(struct work_struct *work)
 	cpu_map = wq_cpu_map(wq);
 
 	for_each_cpu_mask_nr(cpu, *cpu_map)
-		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+		wait_on_cpu_work(wq_per_cpu(wq, cpu), work);
 }
 
 static int __cancel_work_timer(struct work_struct *work,
@@ -752,17 +752,13 @@ int current_is_keventd(void)
 
 }
 
-static struct cpu_workqueue_struct *
-init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
+static void init_cpu_workqueue(struct workqueue_struct *wq,
+		struct cpu_workqueue_struct *cwq)
 {
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
-
 	cwq->wq = wq;
 	spin_lock_init(&cwq->lock);
 	INIT_LIST_HEAD(&cwq->worklist);
 	init_waitqueue_head(&cwq->more_work);
-
-	return cwq;
 }
 
 static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
@@ -816,7 +812,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (!wq)
 		return NULL;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	if (singlethread)
+		wq->cpu_wq = kmalloc(sizeof(*cwq), GFP_KERNEL);
+	else
+		wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
 	if (!wq->cpu_wq) {
 		kfree(wq);
 		return NULL;
@@ -830,7 +829,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	INIT_LIST_HEAD(&wq->list);
 
 	if (singlethread) {
-		cwq = init_cpu_workqueue(wq, singlethread_cpu);
+		cwq = wq->cpu_wq;
+		init_cpu_workqueue(wq, cwq);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
 	} else {
@@ -851,7 +851,8 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 		 * lock.
 		 */
 		for_each_possible_cpu(cpu) {
-			cwq = init_cpu_workqueue(wq, cpu);
+			cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+			init_cpu_workqueue(wq, cwq);
 			if (err || !cpu_online(cpu))
 				continue;
 			err = create_workqueue_thread(cwq, cpu);
@@ -906,6 +907,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
+	if (is_wq_single_threaded(wq)) {
+		cleanup_workqueue_thread(wq->cpu_wq);
+		kfree(wq->cpu_wq);
+		kfree(wq);
+		return;
+	}
+
 	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);


