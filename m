Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbZCMCox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbZCMCox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZCMCin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:38:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbZCMCia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:38:30 -0400
Message-Id: <20090313023827.790845257@goodmis.org>
References: <20090313023704.971438367@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 12 Mar 2009 22:37:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 14/16] tracing: Dont use tracing_record_cmdline() in workqueue tracer fix
Content-Disposition: inline; filename=0014-tracing-Don-t-use-tracing_record_cmdline-in-workq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit c3ffc7a40b7e94b094efe1c8ab4e24370a782b65
"Don't use tracing_record_cmdline() in workqueue tracer"
has a race window.

find_task_by_vpid() requires task_list_lock().

LKML-Reference: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_workqueue.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index fb5ccac..9ab035b 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -193,12 +193,20 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 	struct cpu_workqueue_stats *cws = p;
 	unsigned long flags;
 	int cpu = cws->cpu;
-	struct task_struct *tsk = find_task_by_vpid(cws->pid);
-
-	seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
-		   atomic_read(&cws->inserted),
-		   cws->executed,
-		   tsk ? tsk->comm : "<...>");
+	struct pid *pid;
+	struct task_struct *tsk;
+
+	pid = find_get_pid(cws->pid);
+	if (pid) {
+		tsk = get_pid_task(pid, PIDTYPE_PID);
+		if (tsk) {
+			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
+				   atomic_read(&cws->inserted), cws->executed,
+				   tsk->comm);
+			put_task_struct(tsk);
+		}
+		put_pid(pid);
+	}
 
 	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
 	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-- 
1.6.1.3

-- 
