Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbZKUNf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbZKUNf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZKUNf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:35:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:41688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444AbZKUNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:35:56 -0500
Date: Sat, 21 Nov 2009 13:35:33 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com
In-Reply-To: <4A6685BB.2090809@cn.fujitsu.com>
References: <4A6685BB.2090809@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/ksym_tracer: fix the output of ksym tracer
Message-ID: <tip-d857ace143df3884954887e1899a65831ca72ece@git.kernel.org>
Git-Commit-ID: d857ace143df3884954887e1899a65831ca72ece
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d857ace143df3884954887e1899a65831ca72ece
Gitweb:     http://git.kernel.org/tip/d857ace143df3884954887e1899a65831ca72ece
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Wed, 22 Jul 2009 11:21:31 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Jul 2009 20:51:35 -0400

tracing/ksym_tracer: fix the output of ksym tracer

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
 
