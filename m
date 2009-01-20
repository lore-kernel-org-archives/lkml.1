Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbZATAWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbZATAWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 19:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764818AbZATARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 19:17:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54561 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764792AbZATARf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 19:17:35 -0500
Message-Id: <20090120001734.075013982@goodmis.org>
References: <20090120001542.687427797@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 19 Jan 2009 19:15:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 8/8] trace_workqueue: use percpu data for workqueue stat
Content-Disposition: inline; filename=0008-trace_workqueue-use-percpu-data-for-workqueue-stat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Impact: use percpu data instead of hardcode

Use
static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
instead of allocate it.

And percpu data works well on NUMA.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_workqueue.c |   64 ++++++++++++++++++----------------------
 1 files changed, 29 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index f8118d3..4664990 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -8,6 +8,7 @@
 
 #include <trace/workqueue.h>
 #include <linux/list.h>
+#include <linux/percpu.h>
 #include "trace_stat.h"
 #include "trace.h"
 
@@ -37,7 +38,8 @@ struct workqueue_global_stats {
 /* Don't need a global lock because allocated before the workqueues, and
  * never freed.
  */
-static struct workqueue_global_stats *all_workqueue_stat;
+static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
+#define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
 
 /* Insertion of a work */
 static void
@@ -48,8 +50,8 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 	struct cpu_workqueue_stats *node, *next;
 	unsigned long flags;
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
 							list) {
 		if (node->pid == wq_thread->pid) {
 			atomic_inc(&node->inserted);
@@ -58,7 +60,7 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
 	}
 	pr_debug("trace_workqueue: entry not found\n");
 found:
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
 
 /* Execution of a work */
@@ -70,8 +72,8 @@ probe_workqueue_execution(struct task_struct *wq_thread,
 	struct cpu_workqueue_stats *node, *next;
 	unsigned long flags;
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
 							list) {
 		if (node->pid == wq_thread->pid) {
 			node->executed++;
@@ -80,7 +82,7 @@ probe_workqueue_execution(struct task_struct *wq_thread,
 	}
 	pr_debug("trace_workqueue: entry not found\n");
 found:
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
 
 /* Creation of a cpu workqueue thread */
@@ -104,11 +106,11 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 
 	cws->pid = wq_thread->pid;
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	if (list_empty(&all_workqueue_stat[cpu].list))
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	if (list_empty(&workqueue_cpu_stat(cpu)->list))
 		cws->first_entry = true;
-	list_add_tail(&cws->list, &all_workqueue_stat[cpu].list);
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
 
 /* Destruction of a cpu workqueue thread */
@@ -119,8 +121,8 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 	struct cpu_workqueue_stats *node, *next;
 	unsigned long flags;
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
 							list) {
 		if (node->pid == wq_thread->pid) {
 			list_del(&node->list);
@@ -131,7 +133,7 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 
 	pr_debug("trace_workqueue: don't find workqueue to destroy\n");
 found:
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
 }
 
@@ -141,13 +143,13 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
 	struct cpu_workqueue_stats *ret = NULL;
 
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 
-	if (!list_empty(&all_workqueue_stat[cpu].list))
-		ret = list_entry(all_workqueue_stat[cpu].list.next,
+	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
+		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
 				 struct cpu_workqueue_stats, list);
 
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
 	return ret;
 }
@@ -172,9 +174,9 @@ static void *workqueue_stat_next(void *prev, int idx)
 	unsigned long flags;
 	void *ret = NULL;
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	if (list_is_last(&prev_cws->list, &all_workqueue_stat[cpu].list)) {
-		spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
+		spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 		for (++cpu ; cpu < num_possible_cpus(); cpu++) {
 			ret = workqueue_stat_start_cpu(cpu);
 			if (ret)
@@ -182,7 +184,7 @@ static void *workqueue_stat_next(void *prev, int idx)
 		}
 		return NULL;
 	}
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
 	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
 			  list);
@@ -199,10 +201,10 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 		   cws->executed,
 		   trace_find_cmdline(cws->pid));
 
-	spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
-	if (&cws->list == all_workqueue_stat[cpu].list.next)
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
 		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
 	return 0;
 }
@@ -258,17 +260,9 @@ int __init trace_workqueue_early_init(void)
 	if (ret)
 		goto no_creation;
 
-	all_workqueue_stat = kmalloc(sizeof(struct workqueue_global_stats)
-				     * num_possible_cpus(), GFP_KERNEL);
-
-	if (!all_workqueue_stat) {
-		pr_warning("trace_workqueue: not enough memory\n");
-		goto no_creation;
-	}
-
 	for_each_possible_cpu(cpu) {
-		spin_lock_init(&all_workqueue_stat[cpu].lock);
-		INIT_LIST_HEAD(&all_workqueue_stat[cpu].list);
+		spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
+		INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
 	}
 
 	return 0;
-- 
1.5.6.5

-- 
