Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZDTHCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZDTHCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZDTHCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:02:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49568 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZDTHCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:02:44 -0400
Message-ID: <49EC1DF9.4020708@cn.fujitsu.com>
Date: Mon, 20 Apr 2009 15:02:17 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] trace_workqueue: Remove blank line between each cpu
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com>
In-Reply-To: <49EC1943.8080606@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Blankline between each cpu's workqueue stat is not necessary, because cpu
number is enough to part them by eye.
Old style also caused a blankline below headline, and makes code complex by
lock, disableirq and get cpu var.

Old style:
 # CPU  INSERTED  EXECUTED   NAME
 # |      |         |          |

   0   8644       8644       events/0
   0      0          0       cpuset
   ...
   0      1          1       kdmflush

   1  35365      35365       events/1
   ...

New style:
 # CPU  INSERTED  EXECUTED   NAME
 # |      |         |          |

   0   8644       8644       events/0
   0      0          0       cpuset
   ...
   0      1          1       kdmflush
   1  35365      35365       events/1
   ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index f52db53..3393c95 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -185,16 +185,9 @@ static void *workqueue_stat_next(void *prev, int idx)
 static int workqueue_stat_show(struct seq_file *s, void *p)
 {
 	struct cpu_workqueue_stats *cws = p;
-	unsigned long flags;
-	int cpu = cws->cpu;
 	struct pid *pid;
 	struct task_struct *tsk;
 
-	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
-	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
-		seq_printf(s, "\n");
-	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
-
 	pid = find_get_pid(cws->pid);
 	if (pid) {
 		tsk = get_pid_task(pid, PIDTYPE_PID);
-- 
1.5.5.3


