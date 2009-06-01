Return-Path: <linux-kernel-owner+w=401wt.eu-S1758996AbZFARSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996AbZFARSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbZFARR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:17:29 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:47405 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZFARR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NRmIrZ461eadBI0on6muK9hfRfyZwKIASkApupJs8H381EvNkkHoOKSpogBq6noiLE
         LarafmLripsYAEd3B+RUIVRq7Gp+MzEmOcTZTFDaq1wGe8lzX+kpX+BXwnbPZD8UI2/i
         c54PFCHS1PEs9CuxQhsjulPKqnu47jzz/cDEc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Oleg Nesterov <oleg@redhat.com>, Anton Blanchard <anton@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] tracing/workqueue: fix list header and function name format
Date: Mon,  1 Jun 2009 19:17:16 +0200
Message-Id: <1243876637-6616-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
References: <1243876637-6616-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhaolei <zhaolei@cn.fujitsu.com>

Fix list header of workqueue trace,
and use %pf to print the function name only(ignore the offsets).

Before patch:
 # CPU INSERTED EXECUTED    MAX us   AVG us   TASKNAME:PID
 #  |     |        |           |      ` |     -WORKFUNC
 #  |     |        |           |        |          |
     0        1        1     1053     1053   `-flush_async_commits+0x0/0x90
 ...

After patch:
 # CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID
 #  |     |        |         |        |      `-WORKFUNC
 #  |     |        |         |        |           |
     0        1        1     1155     1155   `-flush_async_commits
 ...

[ Impact: fix and clarify workqueue stats output ]

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_workqueue.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index fa70ea2..cb6429e 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -402,7 +402,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 			avg_time = 0;
 		}
 
-		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pF\n",
+		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pf\n",
 			cws->cpu,
 			wfstat->inserted,
 			wfstat->executed,
@@ -450,11 +450,13 @@ static void workqueue_stat_file_open(void)
 		/**/
 static int workqueue_stat_headers(struct seq_file *s)
 {
-	seq_printf(s, "# CPU INSERTED EXECUTED    MAX us   AVG us"
-			"   TASKNAME:PID\n");
-	seq_printf(s, "#  |     |        |           |      ` |"
-			"     -WORKFUNC\n");
-	seq_printf(s, "#  |     |        |           |        |          |\n");
+	seq_printf(s,
+		"# CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID\n");
+	seq_printf(s,
+		"#  |     |        |         |        |      `-WORKFUNC\n");
+	seq_printf(s,
+		"#  |     |        |         |        |           |\n");
+
 	return 0;
 }
 
-- 
1.6.2.3

