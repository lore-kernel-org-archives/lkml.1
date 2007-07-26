Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXGZLJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXGZLJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 07:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbXGZLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:09:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbXGZLJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:09:12 -0400
Subject: [PATCH] make schedule_on_each_cpu() look like on_each_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 13:08:59 +0200
Message-Id: <1185448139.8197.78.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It always bothered me a bit that on_each_cpu() and
schedule_on_each_cpu() had wildly different interfaces.

Rectify this and convert the sole in-kernel user to the new interface.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/workqueue.h |    2 -
 kernel/workqueue.c        |   63 ++++++++++++++++++++++++++++++++++++++--------
 mm/swap.c                 |    4 +-
 3 files changed, 56 insertions(+), 13 deletions(-)

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h
+++ linux-2.6/include/linux/workqueue.h
@@ -141,7 +141,7 @@ extern int FASTCALL(schedule_delayed_wor
 					unsigned long delay));
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
-extern int schedule_on_each_cpu(work_func_t func);
+extern int schedule_on_each_cpu(void (*func)(void *info), void *info, int retry, int wait);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
 
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c
+++ linux-2.6/kernel/workqueue.c
@@ -561,9 +561,28 @@ int schedule_delayed_work_on(int cpu,
 }
 EXPORT_SYMBOL(schedule_delayed_work_on);
 
+struct schedule_on_each_cpu_work {
+	struct work_struct work;
+	void (*func)(void *info);
+	void *info;
+};
+
+static void schedule_on_each_cpu_func(struct work_struct *work)
+{
+	struct schedule_on_each_cpu_work *w;
+
+	w = container_of(work, typeof(*w), work);
+	w->func(w->info);
+
+	kfree(w);
+}
+
 /**
  * schedule_on_each_cpu - call a function on each online CPU from keventd
  * @func: the function to call
+ * @info: data to pass to function
+ * @retry: ignored
+ * @wait: wait for completion
  *
  * Returns zero on success.
  * Returns -ve errno on failure.
@@ -572,27 +591,51 @@ EXPORT_SYMBOL(schedule_delayed_work_on);
  *
  * schedule_on_each_cpu() is very slow.
  */
-int schedule_on_each_cpu(work_func_t func)
+int schedule_on_each_cpu(void (*func)(void *info), void *info, int retry, int wait)
 {
 	int cpu;
-	struct work_struct *works;
+	struct schedule_on_each_cpu_work **works;
+	int err = 0;
 
-	works = alloc_percpu(struct work_struct);
+	works = kzalloc(sizeof(void *)*nr_cpu_ids, GFP_KERNEL);
 	if (!works)
 		return -ENOMEM;
 
+	for_each_possible_cpu(cpu) {
+		works[cpu] = kmalloc_node(sizeof(struct schedule_on_each_cpu_work),
+				GFP_KERNEL, cpu_to_node(cpu));
+		if (!works[cpu]) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
+
 	preempt_disable();		/* CPU hotplug */
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = per_cpu_ptr(works, cpu);
+		struct schedule_on_each_cpu_work *work;
+
+		work = works[cpu];
+		works[cpu] = NULL;
 
-		INIT_WORK(work, func);
-		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
-		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), work);
+		work->func = func;
+		work->info = info;
+		INIT_WORK(&work->work, schedule_on_each_cpu_func);
+		set_bit(WORK_STRUCT_PENDING, work_data_bits(&work->work));
+		__queue_work(per_cpu_ptr(keventd_wq->cpu_wq, cpu), &work->work);
 	}
 	preempt_enable();
-	flush_workqueue(keventd_wq);
-	free_percpu(works);
-	return 0;
+
+out:
+	for_each_possible_cpu(cpu) {
+		if (works[cpu])
+			kfree(works[cpu]);
+	}
+	kfree(works);
+
+	if (!err && wait)
+		flush_workqueue(keventd_wq);
+
+	return err;
 }
 
 void flush_scheduled_work(void)
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c
+++ linux-2.6/mm/swap.c
@@ -216,7 +216,7 @@ void lru_add_drain(void)
 }
 
 #ifdef CONFIG_NUMA
-static void lru_add_drain_per_cpu(struct work_struct *dummy)
+static void lru_add_drain_per_cpu(void *info)
 {
 	lru_add_drain();
 }
@@ -226,7 +226,7 @@ static void lru_add_drain_per_cpu(struct
  */
 int lru_add_drain_all(void)
 {
-	return schedule_on_each_cpu(lru_add_drain_per_cpu);
+	return schedule_on_each_cpu(lru_add_drain_per_cpu, NULL, 0, 1);
 }
 
 #else


