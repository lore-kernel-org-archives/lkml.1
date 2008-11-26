Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbYKZFR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbYKZFR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYKZFRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:17:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYKZFRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:17:11 -0500
Message-Id: <20081126051710.149585354@goodmis.org>
References: <20081126051622.134970943@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Nov 2008 00:16:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: add thread comm to function graph tracer
Content-Disposition: inline; filename=0004-ftrace-add-thread-comm-to-function-graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Impact: enhancement to function graph tracer

Export the trace_find_cmdline so the function graph tracer can
use it to print the comms of the threads.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c                 |    2 +-
 kernel/trace/trace.h                 |    1 +
 kernel/trace/trace_functions_graph.c |   21 ++++++++++++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d5f7c9..5811e0a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -804,7 +804,7 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	spin_unlock(&trace_cmdline_lock);
 }
 
-static char *trace_find_cmdline(int pid)
+char *trace_find_cmdline(int pid)
 {
 	char *cmdline = "<...>";
 	unsigned map;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ffe1bb1..7adacf3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -450,6 +450,7 @@ struct tracer_switch_ops {
 	struct tracer_switch_ops	*next;
 };
 
+char *trace_find_cmdline(int pid);
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
 #ifdef CONFIG_DYNAMIC_FTRACE
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b6f0cc2..bbb81e7 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -32,29 +32,40 @@ static pid_t last_pid = -1;
 
 static int graph_trace_init(struct trace_array *tr)
 {
-	int cpu;
+	int cpu, ret;
+
 	for_each_online_cpu(cpu)
 		tracing_reset(tr, cpu);
 
-	return register_ftrace_graph(&trace_graph_return,
+	ret = register_ftrace_graph(&trace_graph_return,
 					&trace_graph_entry);
+	if (ret)
+		return ret;
+	tracing_start_cmdline_record();
+
+	return 0;
 }
 
 static void graph_trace_reset(struct trace_array *tr)
 {
-		unregister_ftrace_graph();
+	tracing_stop_cmdline_record();
+	unregister_ftrace_graph();
 }
 
 /* If the pid changed since the last trace, output this event */
 static int verif_pid(struct trace_seq *s, pid_t pid)
 {
+	char *comm;
+
 	if (last_pid != -1 && last_pid == pid)
 		return 1;
 
 	last_pid = pid;
-	return trace_seq_printf(s, "\n------------8<---------- thread %d"
+	comm = trace_find_cmdline(pid);
+
+	return trace_seq_printf(s, "\n------------8<---------- thread %s-%d"
 				    " ------------8<----------\n\n",
-				  pid);
+				    comm, pid);
 }
 
 static enum print_line_t
-- 
1.5.6.5

-- 
