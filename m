Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbZDMFyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbZDMFyD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 01:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZDMFxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 01:53:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41105 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZDMFxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 01:53:50 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] ftrace: add max execution time mesurement to workqueue tracer
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090413145105.6E07.A69D9226@jp.fujitsu.com>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com>
Message-Id: <20090413145254.6E0D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 13 Apr 2009 14:53:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] ftrace: add max execution time mesurement to workqueue tracer

Too slow workqueue handler often introduce some trouble to system.
Then, administrator want to know may handler execution time.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_workqueue.c |   48 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

Index: b/kernel/trace/trace_workqueue.c
===================================================================
--- a/kernel/trace/trace_workqueue.c	2009-04-13 13:23:59.000000000 +0900
+++ b/kernel/trace/trace_workqueue.c	2009-04-13 13:59:51.000000000 +0900
@@ -27,6 +27,10 @@ struct cpu_workqueue_stats {
  *  on a single CPU.
  */
 	unsigned int		    executed;
+
+	/* store handler execution time */
+	u64			    handler_start_time;
+	u64			    max_executed_time;
 };
 
 /* List of workqueue threads on one cpu */
@@ -77,6 +81,7 @@ probe_workqueue_entry(struct task_struct
 							list) {
 		if (node->pid == wq_thread->pid) {
 			node->executed++;
+			node->handler_start_time = trace_clock_global();
 			goto found;
 		}
 	}
@@ -85,6 +90,29 @@ found:
 	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
 }
 
+static void probe_workqueue_exit(struct task_struct *wq_thread,
+				 struct work_struct *work)
+{
+	int cpu = cpumask_first(&wq_thread->cpus_allowed);
+	struct cpu_workqueue_stats *node, *next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
+							list) {
+		if (node->pid == wq_thread->pid) {
+			u64 start = node->handler_start_time;
+			u64 executed_time = trace_clock_global() - start;
+
+			if (node->max_executed_time < executed_time)
+				node->max_executed_time = executed_time;
+			goto found;
+		}
+	}
+found:
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
+}
+
 /* Creation of a cpu workqueue thread */
 static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
 {
@@ -195,6 +223,9 @@ static int workqueue_stat_show(struct se
 	int cpu = cws->cpu;
 	struct pid *pid;
 	struct task_struct *tsk;
+	unsigned long long exec_time = ns2usecs(cws->max_executed_time);
+	unsigned long exec_usec_rem = do_div(exec_time, USEC_PER_SEC);
+	unsigned long exec_secs = (unsigned long)exec_time;
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
@@ -205,8 +236,11 @@ static int workqueue_stat_show(struct se
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
 		if (tsk) {
-			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
+			seq_printf(s, "%3d %6d     %6u     %5lu.%06lu"
+				   "  %s\n",
+				   cws->cpu,
 				   atomic_read(&cws->inserted), cws->executed,
+				   exec_secs, exec_usec_rem,
 				   tsk->comm);
 			put_task_struct(tsk);
 		}
@@ -218,8 +252,8 @@ static int workqueue_stat_show(struct se
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
-	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
-	seq_printf(s, "# |      |         |          |\n");
+	seq_printf(s, "# CPU  INSERTED  EXECUTED     MAX_TIME  NAME\n");
+	seq_printf(s, "# |      |         |           |         |\n");
 	return 0;
 }
 
@@ -259,10 +293,14 @@ int __init trace_workqueue_early_init(vo
 	if (ret)
 		goto no_insertion;
 
-	ret = register_trace_workqueue_creation(probe_workqueue_creation);
+	ret = register_trace_workqueue_handler_exit(probe_workqueue_exit);
 	if (ret)
 		goto no_handler_entry;
 
+	ret = register_trace_workqueue_creation(probe_workqueue_creation);
+	if (ret)
+		goto no_handler_exit;
+
 	ret = register_trace_workqueue_destruction(probe_workqueue_destruction);
 	if (ret)
 		goto no_creation;
@@ -276,6 +314,8 @@ int __init trace_workqueue_early_init(vo
 
 no_creation:
 	unregister_trace_workqueue_creation(probe_workqueue_creation);
+no_handler_exit:
+	unregister_trace_workqueue_handler_exit(probe_workqueue_exit);
 no_handler_entry:
 	unregister_trace_workqueue_handler_entry(probe_workqueue_entry);
 no_insertion:


