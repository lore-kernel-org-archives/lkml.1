Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbZAVJOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbZAVJOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZAVJOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:14:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57424 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbZAVJO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:14:29 -0500
Message-ID: <497838DF.2040605@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 17:14:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] workqueue: don't alloc_percpu for single workqueue
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allocating memory for every cpu for single workqueue is waste.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..6c1e31b 100644
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
@@ -755,7 +755,7 @@ int current_is_keventd(void)
 static struct cpu_workqueue_struct *
 init_cpu_workqueue(struct workqueue_struct *wq, int cpu)
 {
-	struct cpu_workqueue_struct *cwq = per_cpu_ptr(wq->cpu_wq, cpu);
+	struct cpu_workqueue_struct *cwq = wq_per_cpu(wq, cpu);
 
 	cwq->wq = wq;
 	spin_lock_init(&cwq->lock);
@@ -816,7 +816,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (!wq)
 		return NULL;
 
-	wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
+	if (singlethread)
+		wq->cpu_wq = kzalloc(sizeof(*cwq), GFP_KERNEL);
+	else
+		wq->cpu_wq = alloc_percpu(struct cpu_workqueue_struct);
 	if (!wq->cpu_wq) {
 		kfree(wq);
 		return NULL;
@@ -906,6 +910,13 @@ void destroy_workqueue(struct workqueue_struct *wq)
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

