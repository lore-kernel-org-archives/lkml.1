Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbXA1ML3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbXA1ML3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 07:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbXA1ML2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 07:11:28 -0500
Received: from amsfep17-int.chello.nl ([213.46.243.15]:10126 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751927AbXA1ML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 07:11:26 -0500
Message-Id: <20070128120510.851511000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:24 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 6/7] schedule_on_each_cpu_wq()
Content-Disposition: inline; filename=s_files-schedule_on_each_cpu_wq.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Provide a schedule_on_each_cpu_wq() function that uses a workqueue to do all
the work. This avoid the calling process to schedule.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/workqueue.h |    1 
 kernel/workqueue.c        |   66 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 11 deletions(-)

Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h	2007-01-13 21:04:11.000000000 +0100
+++ linux-2.6/include/linux/workqueue.h	2007-01-27 21:12:16.000000000 +0100
@@ -179,6 +179,7 @@ extern int FASTCALL(schedule_delayed_wor
 
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work, unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
+extern int schedule_on_each_cpu_wq(struct workqueue_struct *wq, work_func_t func);
 extern void flush_scheduled_work(void);
 extern int current_is_keventd(void);
 extern int keventd_up(void);
Index: linux-2.6/kernel/workqueue.c
===================================================================
--- linux-2.6.orig/kernel/workqueue.c	2007-01-13 21:04:12.000000000 +0100
+++ linux-2.6/kernel/workqueue.c	2007-01-27 21:12:16.000000000 +0100
@@ -296,6 +296,20 @@ int queue_delayed_work_on(int cpu, struc
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
+static void leak_check(void *func)
+{
+	if (!in_atomic() && lockdep_depth(current) <= 0)
+		return;
+	printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
+				"%s/0x%08x/%d\n",
+				current->comm, preempt_count(),
+			       	current->pid);
+	printk(KERN_ERR "    last function: ");
+	print_symbol("%s\n", (unsigned long)func);
+	debug_show_held_locks(current);
+	dump_stack();
+}
+
 static void run_workqueue(struct cpu_workqueue_struct *cwq)
 {
 	unsigned long flags;
@@ -323,18 +337,10 @@ static void run_workqueue(struct cpu_wor
 		BUG_ON(get_wq_data(work) != cwq);
 		if (!test_bit(WORK_STRUCT_NOAUTOREL, work_data_bits(work)))
 			work_release(work);
-		f(work);
 
-		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-					"%s/0x%08x/%d\n",
-					current->comm, preempt_count(),
-				       	current->pid);
-			printk(KERN_ERR "    last function: ");
-			print_symbol("%s\n", (unsigned long)f);
-			debug_show_held_locks(current);
-			dump_stack();
-		}
+		leak_check(NULL);
+		f(work);
+		leak_check(f);
 
 		spin_lock_irqsave(&cwq->lock, flags);
 		cwq->remove_sequence++;
@@ -649,6 +655,44 @@ int schedule_on_each_cpu(work_func_t fun
 	return 0;
 }
 
+/**
+ * schedule_on_each_cpu_wq - call a function on each online CPU on a per-CPU wq
+ * @func: the function to call
+ *
+ * Returns zero on success.
+ * Returns -ve errno on failure.
+ *
+ * Appears to be racy against CPU hotplug.
+ *
+ * schedule_on_each_cpu() is very slow.
+ */
+int schedule_on_each_cpu_wq(struct workqueue_struct *wq, work_func_t func)
+{
+	int cpu;
+	struct work_struct *works;
+
+	if (is_single_threaded(wq)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	works = alloc_percpu(struct work_struct);
+	if (!works)
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		struct work_struct *work = per_cpu_ptr(works, cpu);
+
+		INIT_WORK(work, func);
+		set_bit(WORK_STRUCT_PENDING, work_data_bits(work));
+		__queue_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
+	}
+	flush_workqueue(wq);
+	free_percpu(works);
+
+	return 0;
+}
+
+
 void flush_scheduled_work(void)
 {
 	flush_workqueue(keventd_wq);

--

