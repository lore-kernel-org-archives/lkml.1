Return-Path: <linux-kernel-owner+w=401wt.eu-S1762762AbZCQDu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762762AbZCQDu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbZCQDte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:49:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbZCQDtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:49:31 -0400
Message-Id: <20090317034928.818128022@goodmis.org>
References: <20090317034820.400357912@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 23:48:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] tracing: protect reader of cmdline output
Content-Disposition: inline; filename=0002-tracing-protect-reader-of-cmdline-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: fix to one cause of incorrect comm outputs in trace

The spinlock only protected the creation of a comm <=> pid pair.
But it was possible that a reader could look up a pid, and get the
wrong comm because it had no locking.

This also required changing trace_find_cmdline to copy the comm cache
and not just send back a pointer to it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/blktrace.c              |   23 ++++++++++++++++++-----
 kernel/trace/trace.c                 |   20 ++++++++++++--------
 kernel/trace/trace.h                 |    2 +-
 kernel/trace/trace_functions_graph.c |   12 ++++++------
 kernel/trace/trace_output.c          |   18 ++++++++++++------
 5 files changed, 49 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1f32e4e..b171778 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1027,7 +1027,9 @@ static int blk_log_action_seq(struct trace_seq *s, const struct blk_io_trace *t,
 
 static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
 {
-	const char *cmd = trace_find_cmdline(ent->pid);
+	char cmd[TASK_COMM_LEN];
+
+	trace_find_cmdline(ent->pid, cmd);
 
 	if (t_sec(ent))
 		return trace_seq_printf(s, "%llu + %u [%s]\n",
@@ -1057,19 +1059,30 @@ static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
 
 static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
 {
-	return trace_seq_printf(s, "[%s]\n", trace_find_cmdline(ent->pid));
+	char cmd[TASK_COMM_LEN];
+
+	trace_find_cmdline(ent->pid, cmd);
+
+	return trace_seq_printf(s, "[%s]\n", cmd);
 }
 
 static int blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
 {
-	return trace_seq_printf(s, "[%s] %llu\n", trace_find_cmdline(ent->pid),
-				get_pdu_int(ent));
+	char cmd[TASK_COMM_LEN];
+
+	trace_find_cmdline(ent->pid, cmd);
+
+	return trace_seq_printf(s, "[%s] %llu\n", cmd, get_pdu_int(ent));
 }
 
 static int blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
 {
+	char cmd[TASK_COMM_LEN];
+
+	trace_find_cmdline(ent->pid, cmd);
+
 	return trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
-				get_pdu_int(ent), trace_find_cmdline(ent->pid));
+				get_pdu_int(ent), cmd);
 }
 
 /*
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index efe3202..2796bd2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -770,25 +770,29 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	__raw_spin_unlock(&trace_cmdline_lock);
 }
 
-char *trace_find_cmdline(int pid)
+void trace_find_cmdline(int pid, char comm[])
 {
-	char *cmdline = "<...>";
 	unsigned map;
 
-	if (!pid)
-		return "<idle>";
+	if (!pid) {
+		strcpy(comm, "<idle>");
+		return;
+	}
 
-	if (pid > PID_MAX_DEFAULT)
-		goto out;
+	if (pid > PID_MAX_DEFAULT) {
+		strcpy(comm, "<...>");
+		return;
+	}
 
+	__raw_spin_lock(&trace_cmdline_lock);
 	map = map_pid_to_cmdline[pid];
 	if (map >= SAVED_CMDLINES)
 		goto out;
 
-	cmdline = saved_cmdlines[map];
+	strcpy(comm, saved_cmdlines[map]);
 
  out:
-	return cmdline;
+	__raw_spin_unlock(&trace_cmdline_lock);
 }
 
 void tracing_record_cmdline(struct task_struct *tsk)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 56ce34d..b0ecad8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -547,7 +547,7 @@ struct tracer_switch_ops {
 };
 #endif /* CONFIG_CONTEXT_SWITCH_TRACER */
 
-extern char *trace_find_cmdline(int pid);
+extern void trace_find_cmdline(int pid, char comm[]);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 extern unsigned long ftrace_update_tot_cnt;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4c38860..6004cca 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -190,15 +190,15 @@ print_graph_cpu(struct trace_seq *s, int cpu)
 static enum print_line_t
 print_graph_proc(struct trace_seq *s, pid_t pid)
 {
-	int i;
-	int ret;
-	int len;
-	char comm[8];
-	int spaces = 0;
+	char comm[TASK_COMM_LEN];
 	/* sign + log10(MAX_INT) + '\0' */
 	char pid_str[11];
+	int spaces = 0;
+	int ret;
+	int len;
+	int i;
 
-	strncpy(comm, trace_find_cmdline(pid), 7);
+	trace_find_cmdline(pid, comm);
 	comm[7] = '\0';
 	sprintf(pid_str, "%d", pid);
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index ea9d3b4..6a4c9de 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -309,9 +309,9 @@ static int
 lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 {
 	int hardirq, softirq;
-	char *comm;
+	char comm[TASK_COMM_LEN];
 
-	comm = trace_find_cmdline(entry->pid);
+	trace_find_cmdline(entry->pid, comm);
 	hardirq = entry->flags & TRACE_FLAG_HARDIRQ;
 	softirq = entry->flags & TRACE_FLAG_SOFTIRQ;
 
@@ -346,10 +346,12 @@ int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
-	char *comm = trace_find_cmdline(entry->pid);
 	unsigned long long t = ns2usecs(iter->ts);
 	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
 	unsigned long secs = (unsigned long)t;
+	char comm[TASK_COMM_LEN];
+
+	trace_find_cmdline(entry->pid, comm);
 
 	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
 				comm, entry->pid, iter->cpu, secs, usec_rem);
@@ -372,7 +374,10 @@ int trace_print_lat_context(struct trace_iterator *iter)
 	rel_usecs = ns2usecs(next_ts - iter->ts);
 
 	if (verbose) {
-		char *comm = trace_find_cmdline(entry->pid);
+		char comm[TASK_COMM_LEN];
+
+		trace_find_cmdline(entry->pid, comm);
+
 		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08lx]"
 				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
 				       entry->pid, iter->cpu, entry->flags,
@@ -577,14 +582,15 @@ static enum print_line_t trace_ctxwake_print(struct trace_iterator *iter,
 					     char *delim)
 {
 	struct ctx_switch_entry *field;
-	char *comm;
+	char comm[TASK_COMM_LEN];
 	int S, T;
 
+
 	trace_assign_type(field, iter->ent);
 
 	T = task_state_char(field->next_state);
 	S = task_state_char(field->prev_state);
-	comm = trace_find_cmdline(field->next_pid);
+	trace_find_cmdline(field->next_pid, comm);
 	if (!trace_seq_printf(&iter->seq,
 			      " %5d:%3d:%c %s [%03d] %5d:%3d:%c %s\n",
 			      field->prev_pid,
-- 
1.6.2

-- 
