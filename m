Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZBQFSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZBQFSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZBQFOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:14:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZBQFOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:14:09 -0500
Message-Id: <20090217051408.109006651@goodmis.org>
References: <20090217051227.957864159@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 17 Feb 2009 00:12:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 15/15] ftrace: add pretty print function for traceon and traceoff hooks
Content-Disposition: inline; filename=0015-ftrace-add-pretty-print-function-for-traceon-and-tr.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds a pretty print version of traceon and traceoff
output for set_ftrace_filter.

  # echo 'sys_open:traceon:4' > set_ftrace_filter
  # cat set_ftrace_filter

 #### all functions enabled ####
 sys_open:traceon:count=4

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_functions.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 5c95708..f520aa4 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -267,15 +267,43 @@ ftrace_traceoff(unsigned long ip, unsigned long parent_ip, void **data)
 	tracing_off();
 }
 
+static int
+ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
+			 struct ftrace_hook_ops *ops, void *data);
+
 static struct ftrace_hook_ops traceon_hook_ops = {
 	.func			= ftrace_traceon,
+	.print			= ftrace_trace_onoff_print,
 };
 
 static struct ftrace_hook_ops traceoff_hook_ops = {
 	.func			= ftrace_traceoff,
+	.print			= ftrace_trace_onoff_print,
 };
 
 static int
+ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
+			 struct ftrace_hook_ops *ops, void *data)
+{
+	char str[KSYM_SYMBOL_LEN];
+	long count = (long)data;
+
+	kallsyms_lookup(ip, NULL, NULL, NULL, str);
+	seq_printf(m, "%s:", str);
+
+	if (ops == &traceon_hook_ops)
+		seq_printf(m, "traceon");
+	else
+		seq_printf(m, "traceoff");
+
+	if (count != -1)
+		seq_printf(m, ":count=%ld", count);
+	seq_putc(m, '\n');
+
+	return 0;
+}
+
+static int
 ftrace_trace_onoff_unreg(char *glob, char *cmd, char *param)
 {
 	struct ftrace_hook_ops *ops;
-- 
1.5.6.5

-- 
