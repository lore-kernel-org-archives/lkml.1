Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbZCYJAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbZCYJAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZCYJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:00:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58412 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZCYJAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:00:43 -0400
Message-ID: <49C9F266.2060706@cn.fujitsu.com>
Date: Wed, 25 Mar 2009 16:59:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] trace_workqueues: fix empty line's output
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Empty lines separate cpus stat. After previous
fix(trace_stat: keep original order) applied, the empty lines
are displayed at incorrect position.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 9ab035b..797201e 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -196,6 +196,11 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	struct pid *pid;
 	struct task_struct *tsk;
 
+	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
+	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
+		seq_printf(s, "\n");
+	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
+
 	pid = find_get_pid(cws->pid);
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
@@ -208,18 +213,13 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 		put_pid(pid);
 	}
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-
 	return 0;
 }
 
 static int workqueue_stat_headers(struct seq_file *s)
 {
 	seq_printf(s, "# CPU  INSERTED  EXECUTED   NAME\n");
-	seq_printf(s, "# |      |         |          |\n\n");
+	seq_printf(s, "# |      |         |          |\n");
 	return 0;
 }
 


