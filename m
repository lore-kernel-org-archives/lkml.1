Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZEZIIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZEZIIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZEZIIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:08:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51526 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbZEZII3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:08:29 -0400
Message-ID: <4A1BA322.9060505@cn.fujitsu.com>
Date: Tue, 26 May 2009 16:06:58 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/workqueue: fix list header and function name
 format
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 kernel/trace/trace_workqueue.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
index c67be60..6cee4a8 100644
--- a/kernel/trace/trace_workqueue.c
+++ b/kernel/trace/trace_workqueue.c
@@ -409,7 +409,7 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
 			avg_time = 0;
 		}
 
-		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pF\n",
+		seq_printf(s, "  %3d   %6d   %6u   %6llu   %6llu   %c-%pf\n",
 			cws->cpu,
 			wfstat->inserted,
 			wfstat->executed,
@@ -457,11 +457,13 @@ static void workqueue_stat_file_open(void)
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
1.5.5.3

