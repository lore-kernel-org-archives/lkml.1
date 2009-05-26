Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZEZIWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZEZIWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbZEZIWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:22:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbZEZIWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:22:32 -0400
Message-ID: <4A1BA66F.6060503@cn.fujitsu.com>
Date: Tue, 26 May 2009 16:21:03 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing/workqueue: cleanup for trace_workqueue.c
References: <4A1BA322.9060505@cn.fujitsu.com>
In-Reply-To: <4A1BA322.9060505@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: Make function's order in source same with definition in struct tracer_stat
2: Remove ";" after workqueue_stat_file_release()
3: Remove redundant blank in struct tracer_stat workqueue_stats
4: add "static" prefix for some function and struct

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   65 +++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 6cee4a8..53fe43e 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -81,7 +81,7 @@ static int wq_file_ref;
  * Update record when insert a work into workqueue
  * Caller need to hold cpu_workqueue_stats spin_lock
  */
-int do_worklet_enqueue(struct cpu_workqueue_stats *cws,
+static int do_worklet_enqueue(struct cpu_workqueue_stats *cws,
 			 struct work_struct *work)
 {
 	struct workfunc_stats *wfstat;
@@ -422,6 +422,27 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static int workqueue_stat_headers(struct seq_file *s)
+{
+	seq_printf(s,
+		"# CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID\n");
+	seq_printf(s,
+		"#  |     |        |         |        |      `-WORKFUNC\n");
+	seq_printf(s,
+		"#  |     |        |         |        |           |\n");
+
+	return 0;
+}
+
+static void workqueue_stat_file_open(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&free_wq_lock, flags);
+	wq_file_ref++;
+	spin_unlock_irqrestore(&free_wq_lock, flags);
+}
+
 /*
  * Here we are sure that we have no more readers on our stat file
  * and that further readers will block until we return from this function.
@@ -443,42 +464,20 @@ static void workqueue_stat_file_release(void)
 	}
 
 	spin_unlock_irqrestore(&free_wq_lock, flags);
-};
-
-static void workqueue_stat_file_open(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&free_wq_lock, flags);
-	wq_file_ref++;
-	spin_unlock_irqrestore(&free_wq_lock, flags);
-}
-
-		/**/
-static int workqueue_stat_headers(struct seq_file *s)
-{
-	seq_printf(s,
-		"# CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID\n");
-	seq_printf(s,
-		"#  |     |        |         |        |      `-WORKFUNC\n");
-	seq_printf(s,
-		"#  |     |        |         |        |           |\n");
-
-	return 0;
 }
 
-struct tracer_stat workqueue_stats __read_mostly = {
-	.name		 = "workqueues",
-	.stat_start	 = workqueue_stat_start,
-	.stat_next	 = workqueue_stat_next,
-	.stat_show	 = workqueue_stat_show,
-	.stat_headers	 = workqueue_stat_headers,
-	.file_open	 = workqueue_stat_file_open,
-	.file_open	 = workqueue_stat_file_release,
+static struct tracer_stat workqueue_stats __read_mostly = {
+	.name		= "workqueues",
+	.stat_start	= workqueue_stat_start,
+	.stat_next	= workqueue_stat_next,
+	.stat_show	= workqueue_stat_show,
+	.stat_headers	= workqueue_stat_headers,
+	.file_open	= workqueue_stat_file_open,
+	.file_open	= workqueue_stat_file_release,
 };
 
 
-int __init stat_workqueue_init(void)
+static int __init stat_workqueue_init(void)
 {
 	if (register_stat_tracer(&workqueue_stats)) {
 		pr_warning("Unable to register workqueue stat tracer\n");
@@ -493,7 +492,7 @@ fs_initcall(stat_workqueue_init);
  * Workqueues are created very early, just after pre-smp initcalls.
  * So we must register our tracepoints at this stage.
  */
-int __init trace_workqueue_early_init(void)
+static int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-- 
1.5.5.3

