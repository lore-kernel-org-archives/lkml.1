Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZGVDVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZGVDVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbZGVDVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:21:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55910 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755566AbZGVDVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:21:39 -0400
Message-ID: <4A6685BB.2090809@cn.fujitsu.com>
Date: Wed, 22 Jul 2009 11:21:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/ksym_tracer: fix the output of ksym tracer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.6.1.2


