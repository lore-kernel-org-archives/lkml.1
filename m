Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZCMADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZCMADT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbZCMADL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:03:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55647 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZCMADK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:03:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for tip] tracing: Don't use tracing_record_cmdline() in workqueue tracer fix
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Message-Id: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 09:03:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit c3ffc7a40b7e94b094efe1c8ab4e24370a782b65 "Don't use tracing_record_cmdline() 
in workqueue tracer" have a race window.

find_task_by_vpid() require task_list_lock(). but the patch doesn't.

fixing here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
1.6.0.6



