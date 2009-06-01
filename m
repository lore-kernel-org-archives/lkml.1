Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZFARSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZFARSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbZFARRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:13342 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108AbZFARRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QFd8a3uyttEoAsCvCP9LWbX+QFQqlqP8vHg1ZuiTqsqMkGGj8NXOd5PH1ZgWsT/dnY
         uPzLSOzW4vcfpwOjcr280NMiFLRdavQmOmIcyt95PgkvNy00oAYBZ7J4cBx8/1Wp7HzH
         TOFDgCo0O/kKuIr/jfN6hIqgfJ4wtH5BswDis=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, Anton Blanchard <anton@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/5] tracing/workqueue: cleanup for trace_workqueue.c
Date: Mon,  1 Jun 2009 19:17:17 +0200
Message-Id: <1243876637-6616-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

1: Make function's order in source same with definition in struct tracer_stat
2: Remove ";" after workqueue_stat_file_release()
3: Remove redundant blank in struct tracer_stat workqueue_stats
4: add "static" prefix for some function and struct

[ Impact: reorganize code, cleanup ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |   65 +++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index cb6429e..ae98be4 100644
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
@@ -415,6 +415,27 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
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
@@ -436,42 +457,20 @@ static void workqueue_stat_file_release(void)
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
@@ -486,7 +485,7 @@ fs_initcall(stat_workqueue_init);
  * Workqueues are created very early, just after pre-smp initcalls.
  * So we must register our tracepoints at this stage.
  */
-int __init trace_workqueue_early_init(void)
+static int __init trace_workqueue_early_init(void)
 {
 	int ret, cpu;
 
-- 
1.6.2.3

