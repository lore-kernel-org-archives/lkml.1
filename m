Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZGJKn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZGJKn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZGJKng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:43:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755247AbZGJKne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:43:34 -0400
Date: Fri, 10 Jul 2009 10:42:58 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4A51B16F.6010608@cn.fujitsu.com>
References: <4A51B16F.6010608@cn.fujitsu.com>
Subject: [tip:tracing/core] tracing/workqueues: Add refcnt to struct cpu_workqueue_stats
Message-ID: <tip-a35780005eb256eb5ec83ffcc802967295887a45@git.kernel.org>
Git-Commit-ID: a35780005eb256eb5ec83ffcc802967295887a45
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:43:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a35780005eb256eb5ec83ffcc802967295887a45
Gitweb:     http://git.kernel.org/tip/a35780005eb256eb5ec83ffcc802967295887a45
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Mon, 6 Jul 2009 16:10:23 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:14:07 +0200

tracing/workqueues: Add refcnt to struct cpu_workqueue_stats

The stat entries can be freed when the stat file is being read.
The worse is, the ptr can be freed immediately after it's returned
from workqueue_stat_start/next().

Add a refcnt to struct cpu_workqueue_stats to avoid use-after-free.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A51B16F.6010608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
 
