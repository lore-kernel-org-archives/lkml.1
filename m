Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYLCBa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYLCBa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYLCBao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:30:44 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:43767 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYLCBam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=iAHEugiKpf5JTUudLL+tm9UY+J6H661L+/9h1P3OtaAhR9wv9M8dFagt77H/vevymf
         zqQp5FTTrf2cKKLOJBRIf9FLPFiafthtILPeCLrzIT7RoHLR64BY5Q3i3nCaI+1TArUB
         5+rSPZ0bpXFSFva7lBUIK7UXT0lfO8C0eRZRM=
Message-ID: <4935E13D.9000208@gmail.com>
Date: Wed, 03 Dec 2008 02:30:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] tracing/function-graph-tracer: display unified style
 cmdline and pid
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: let one know which thread called a function

This patch implements a helper function to print the couple cmdline/pid.
Its output is provided during task switching and on each row if the new
"funcgraph-proc" defualt-off option is set through trace_options file.

The output is center aligned and never exceeds 14 characters. The cmdline
is truncated over 7 chars.
But note that if the pid exceeds 6 characters, the column will overflow (but
the situation is abnormal).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 894b50b..23e19d2 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -19,6 +19,7 @@
 #define TRACE_GRAPH_PRINT_OVERRUN	0x1
 #define TRACE_GRAPH_PRINT_CPU		0x2
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
+#define TRACE_GRAPH_PRINT_PROC		0x8
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns ? */
@@ -27,11 +28,13 @@ static struct tracer_opt trace_opts[] = {
 	{ TRACER_OPT(funcgraph-cpu, TRACE_GRAPH_PRINT_CPU) },
 	/* Display Overhead ? */
 	{ TRACER_OPT(funcgraph-overhead, TRACE_GRAPH_PRINT_OVERHEAD) },
+	/* Display proc name/pid */
+	{ TRACER_OPT(funcgraph-proc, TRACE_GRAPH_PRINT_PROC) },
 	{ } /* Empty entry */
 };
 
 static struct tracer_flags tracer_flags = {
-	/* Don't display overruns by default */
+	/* Don't display overruns and proc by default */
 	.val = TRACE_GRAPH_PRINT_CPU | TRACE_GRAPH_PRINT_OVERHEAD,
 	.opts = trace_opts
 };
@@ -104,23 +107,63 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 	return TRACE_TYPE_HANDLED;
 }
 
+#define TRACE_GRAPH_PROCINFO_LENGTH	14
+
+static enum print_line_t
+print_graph_proc(struct trace_seq *s, pid_t pid)
+{
+	int i;
+	int ret;
+	int len;
+	char comm[8];
+	int spaces = 0;
+	/* sign + log10(MAX_INT) + '\0' */
+	char pid_str[11];
+
+	strncpy(comm, trace_find_cmdline(pid), 7);
+	comm[7] = '\0';
+	sprintf(pid_str, "%d", pid);
+
+	/* 1 stands for the "-" character */
+	len = strlen(comm) + strlen(pid_str) + 1;
+
+	if (len < TRACE_GRAPH_PROCINFO_LENGTH)
+		spaces = TRACE_GRAPH_PROCINFO_LENGTH - len;
+
+	/* First spaces to align center */
+	for (i = 0; i < spaces / 2; i++) {
+		ret = trace_seq_printf(s, " ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	ret = trace_seq_printf(s, "%s-%s", comm, pid_str);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	/* Last spaces to align center */
+	for (i = 0; i < spaces - (spaces / 2); i++) {
+		ret = trace_seq_printf(s, " ");
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+	return TRACE_TYPE_HANDLED;
+}
+
 
 /* If the pid changed since the last trace, output this event */
-static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
+static enum print_line_t
+verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 {
-	char *comm, *prev_comm;
 	pid_t prev_pid;
 	int ret;
 
 	if (last_pid[cpu] != -1 && last_pid[cpu] == pid)
-		return 1;
+		return TRACE_TYPE_HANDLED;
 
 	prev_pid = last_pid[cpu];
 	last_pid[cpu] = pid;
 
-	comm = trace_find_cmdline(pid);
-	prev_comm = trace_find_cmdline(prev_pid);
-
 /*
  * Context-switch trace line:
 
@@ -130,11 +173,31 @@ static int verif_pid(struct trace_seq *s, pid_t pid, int cpu)
 
  */
 	ret = trace_seq_printf(s,
-		" ------------------------------------------\n");
-	ret += trace_seq_printf(s, " | %d)  %s-%d  =>  %s-%d\n",
-				  cpu, prev_comm, prev_pid, comm, pid);
-	ret += trace_seq_printf(s,
-		" ------------------------------------------\n\n");
+		"\n ------------------------------------------\n |");
+	if (!ret)
+		TRACE_TYPE_PARTIAL_LINE;
+
+	ret = print_graph_cpu(s, cpu);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
+		TRACE_TYPE_PARTIAL_LINE;
+
+	ret = print_graph_proc(s, prev_pid);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
+		TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s, " => ");
+	if (!ret)
+		TRACE_TYPE_PARTIAL_LINE;
+
+	ret = print_graph_proc(s, pid);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
+		TRACE_TYPE_PARTIAL_LINE;
+
+	ret = trace_seq_printf(s,
+		"\n ------------------------------------------\n\n");
+	if (!ret)
+		TRACE_TYPE_PARTIAL_LINE;
+
 	return ret;
 }
 
@@ -288,12 +351,23 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	struct trace_entry *ent = iter->ent;
 
 	/* Pid */
-	if (!verif_pid(s, ent->pid, cpu))
+	if (verif_pid(s, ent->pid, cpu) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Cpu */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Proc */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+		ret = print_graph_proc(s, ent->pid);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		ret = trace_seq_printf(s, " | ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
@@ -318,12 +392,23 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		duration = 9999999ULL;
 
 	/* Pid */
-	if (!verif_pid(s, ent->pid, cpu))
+	if (verif_pid(s, ent->pid, cpu) == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Cpu */
 	if (tracer_flags.val & TRACE_GRAPH_PRINT_CPU) {
 		ret = print_graph_cpu(s, cpu);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Proc */
+	if (tracer_flags.val & TRACE_GRAPH_PRINT_PROC) {
+		ret = print_graph_proc(s, ent->pid);
+		if (ret == TRACE_TYPE_PARTIAL_LINE)
+			return TRACE_TYPE_PARTIAL_LINE;
+
+		ret = trace_seq_printf(s, " | ");
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
-- 
1.5.6.3

