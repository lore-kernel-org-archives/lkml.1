Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZGXCPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZGXCPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 22:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZGXCPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 22:15:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZGXCPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 22:15:11 -0400
Message-Id: <20090724021510.636184177@goodmis.org>
References: <20090724021403.694891838@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Jul 2009 22:14:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/3] tracing/ksym_tracer: fix the output of ksym tracer
Content-Disposition: inline; filename=0001-tracing-ksym_tracer-fix-the-output-of-ksym-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Fix the output format of ksym tracer, make it properly aligned

Befor patch:
# tracer: ksym_tracer
#
#       TASK-PID      CPU#      Symbol         Type    Function
#          |           |          |              |         |
bash            1378  1   ksym_tracer_mutex     W  mutex_lock+0x11/0x27
bash            1378  1   ksym_filter_head      W  process_new_ksym_entry+0xd2/0x10c
bash            1378  1   ksym_tracer_mutex     W  mutex_unlock+0x12/0x1b
cat             1429  0   ksym_tracer_mutex     W  mutex_lock+0x11/0x27

After patch:
# tracer: ksym_tracer
#
#       TASK-PID   CPU#      Symbol                    Type    Function
#          |        |          |                        |         |
        cat-1423  [000] ksym_tracer_mutex               RW mutex_lock+0x11/0x27
        cat-1423  [000] ksym_filter_head                RW ksym_trace_filter_read+0x6e/0x10d
        cat-1423  [000] ksym_tracer_mutex               RW mutex_unlock+0x12/0x1b
        cat-1423  [000] ksym_tracer_mutex               RW mutex_lock+0x11/0x27
        cat-1423  [000] ksym_filter_head                RW ksym_trace_filter_read+0x6e/0x10d
        cat-1423  [000] ksym_tracer_mutex               RW mutex_unlock+0x12/0x1b

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
LKML-Reference: <4A6685BB.2090809@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_ksym.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 1256a6e..fbf3a8e 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -370,13 +370,12 @@ static int ksym_trace_init(struct trace_array *tr)
 
 static void ksym_trace_print_header(struct seq_file *m)
 {
-
 	seq_puts(m,
-		 "#       TASK-PID      CPU#      Symbol         Type    "
-		 "Function         \n");
+		 "#       TASK-PID   CPU#      Symbol                    "
+		 "Type    Function\n");
 	seq_puts(m,
-		 "#          |           |          |              |         "
-		 "|            \n");
+		 "#          |        |          |                       "
+		 " |         |\n");
 }
 
 static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
@@ -392,7 +391,7 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->cmd,
+	ret = trace_seq_printf(s, "%11s-%-5d [%03d] %-30s ", field->cmd,
 				entry->pid, iter->cpu, field->ksym_name);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -412,7 +411,7 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	sprint_symbol(str, field->ip);
-	ret = trace_seq_printf(s, "%-20s\n", str);
+	ret = trace_seq_printf(s, "%s\n", str);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-- 
1.6.3.3

-- 
