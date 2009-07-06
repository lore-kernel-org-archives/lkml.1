Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbZGFIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbZGFIKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbZGFIK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 04:10:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56591 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbZGFIKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 04:10:24 -0400
Message-ID: <4A51B16F.6010608@cn.fujitsu.com>
Date: Mon, 06 Jul 2009 16:10:23 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] trace_workqueue: add refcnt to struct cpu_workqueue_stats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The stat entries can be freed when the stat file is being read.
The worse is, the ptr can be freed immediately after it's returned
from workqueue_stat_start/next().

Add a refcnt to struct cpu_workqueue_stats to avoid use-after-free.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 97fcea4..40cafb0 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -9,6 +9,7 @@
 #include <trace/events/workqueue.h>
 #include <linux/list.h>
 #include <linux/percpu.h>
+#include <linux/kref.h>
 #include "trace_stat.h"
 #include "trace.h"
 
@@ -16,6 +17,7 @@
 /* A cpu workqueue thread */
 struct cpu_workqueue_stats {
 	struct list_head            list;
+	struct kref                 kref;
 	int		            cpu;
 	pid_t			    pid;
 /* Can be inserted from interrupt or user context, need to be atomic */
@@ -39,6 +41,11 @@ struct workqueue_global_stats {
 static DEFINE_PER_CPU(struct workqueue_global_stats, all_workqueue_stat);
 #define workqueue_cpu_stat(cpu) (&per_cpu(all_workqueue_stat, cpu))
 
+static void cpu_workqueue_stat_free(struct kref *kref)
+{
+	kfree(container_of(kref, struct cpu_workqueue_stats, kref));
+}
+
 /* Insertion of a work */
 static void
 probe_workqueue_insertion(struct task_struct *wq_thread,
@@ -96,8 +103,8 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 		return;
 	}
 	INIT_LIST_HEAD(&cws->list);
+	kref_init(&cws->kref);
 	cws->cpu = cpu;
-
 	cws->pid = wq_thread->pid;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
@@ -118,7 +125,7 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
 							list) {
 		if (node->pid == wq_thread->pid) {
 			list_del(&node->list);
-			kfree(node);
+			kref_put(&node->kref, cpu_workqueue_stat_free);
 			goto found;
 		}
 	}
@@ -137,9 +144,11 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 
-	if (!list_empty(&workqueue_cpu_stat(cpu)->list))
+	if (!list_empty(&workqueue_cpu_stat(cpu)->list)) {
 		ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
 				 struct cpu_workqueue_stats, list);
+		kref_get(&ret->kref);
+	}
 
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
@@ -162,9 +171,9 @@ static void *workqueue_stat_start(struct tracer_stat *trace)
 static void *workqueue_stat_next(void *prev, int idx)
 {
 	struct cpu_workqueue_stats *prev_cws = prev;
+	struct cpu_workqueue_stats *ret;
 	int cpu = prev_cws->cpu;
 	unsigned long flags;
-	void *ret = NULL;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
@@ -175,11 +184,14 @@ static void *workqueue_stat_next(void *prev, int idx)
 				return NULL;
 		} while (!(ret = workqueue_stat_start_cpu(cpu)));
 		return ret;
+	} else {
+		ret = list_entry(prev_cws->list.next,
+				 struct cpu_workqueue_stats, list);
+		kref_get(&ret->kref);
 	}
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 
-	return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
-			  list);
+	return ret;
 }
 
 static int workqueue_stat_show(struct seq_file *s, void *p)
@@ -203,6 +215,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static void workqueue_stat_release(void *stat)
+{
+	struct cpu_workqueue_stats *node = stat;
+
+	kref_put(&node->kref, cpu_workqueue_stat_free);
+}
+
 static int workqueue_stat_headers(struct seq_file *s)
 {
 	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
@@ -215,6 +234,7 @@ struct tracer_stat workqueue_stats __read_mostly = {
 	.stat_start = workqueue_stat_start,
 	.stat_next = workqueue_stat_next,
 	.stat_show = workqueue_stat_show,
+	.stat_release = workqueue_stat_release,
 	.stat_headers = workqueue_stat_headers
 };
 
-- 
1.5.4.rc3





