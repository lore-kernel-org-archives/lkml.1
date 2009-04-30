Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbZD3A2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbZD3A2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbZD3A1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:27:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:49710 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbZD3A1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jG1AT0hoB2yWZeLoAxFw6103a8qdoLOW5x9VN2QIZBz89nF22R3fwibdyM2LlzCPMc
         eI+Q3U765nxDiOwveEdga35wY3eZYrTmoEDHIHUNuO5N8S550SWjEegxJ5ml2L217cgU
         3gD35UZQKQmDw+sf6xvXtz5ZfzmLqmqQaSe9g=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/19] trace_workqueue: remove blank line between each cpu
Date: Thu, 30 Apr 2009 02:27:05 +0200
Message-Id: <1241051240-4280-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
References: <1241051240-4280-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

The blankline between each cpu's workqueue stat is not necessary, because
the cpu number is enough to part them by eye.
Old style also caused a blankline below headline, and made code complex
by using lock, disableirq and get cpu var.

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

[ Impact: provide more readable code ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index 890974a..97fcea4 100644
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
1.6.2.3

