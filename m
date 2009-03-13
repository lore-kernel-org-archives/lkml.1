Return-Path: <linux-kernel-owner+w=401wt.eu-S1751198AbZCMEE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbZCMEE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 00:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZCMED7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 00:03:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:38088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZCMED6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 00:03:58 -0400
Date: Fri, 13 Mar 2009 04:03:14 GMT
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       srostedt@redhat.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
References: <20090313090042.43CD.A69D9226@jp.fujitsu.com>
Subject: [tip:tracing/ftrace] tracing: Don't use tracing_record_cmdline() in workqueue tracer fix
Message-ID: <tip-889a6c367283709a80dad9413488472596a1a1d2@git.kernel.org>
Git-Commit-ID: 889a6c367283709a80dad9413488472596a1a1d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 04:03:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  889a6c367283709a80dad9413488472596a1a1d2
Gitweb:     http://git.kernel.org/tip/889a6c367283709a80dad9413488472596a1a1d2
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Fri, 13 Mar 2009 09:03:04 +0900
Commit:     Steven Rostedt <srostedt@redhat.com>
CommitDate: Thu, 12 Mar 2009 21:23:47 -0400

tracing: Don't use tracing_record_cmdline() in workqueue tracer fix

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
