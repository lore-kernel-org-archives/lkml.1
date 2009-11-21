Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbZKUNeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbZKUNeh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZKUNeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:34:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:41569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbZKUNef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:34:35 -0500
Date: Sat, 21 Nov 2009 13:33:55 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, lizf@cn.fujitsu.com, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
In-Reply-To: <4A52E2A4.4050007@cn.fujitsu.com>
References: <4A52E2A4.4050007@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ksym_tracer: Extract trace entry from struct trace_ksym
Message-ID: <tip-db59504d89db1462a5281fb55b1d962cb74a398f@git.kernel.org>
Git-Commit-ID: db59504d89db1462a5281fb55b1d962cb74a398f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db59504d89db1462a5281fb55b1d962cb74a398f
Gitweb:     http://git.kernel.org/tip/db59504d89db1462a5281fb55b1d962cb74a398f
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 7 Jul 2009 13:52:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 11:59:40 +0200

ksym_tracer: Extract trace entry from struct trace_ksym

struct trace_ksym is used as an entry in hbp list, and is also
used as trace_entry stored in ring buffer.

This is not necessary and is a waste of memory in ring buffer.

There is also a bug that dereferencing field->ksym_hbp in
ksym_trace_output() can be invalid.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4A52E2A4.4050007@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.h      |   13 ++++---------
 kernel/trace/trace_ksym.c |   26 ++++++++++++++++++--------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7d5cc37..ff1ef41 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -215,17 +215,12 @@ struct syscall_trace_exit {
 #define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
-struct trace_ksym {
+struct ksym_trace_entry {
 	struct trace_entry	ent;
-	struct hw_breakpoint	*ksym_hbp;
-	unsigned long		ksym_addr;
 	unsigned long		ip;
-#ifdef CONFIG_PROFILE_KSYM_TRACER
-	unsigned long		counter;
-#endif
-	struct hlist_node	ksym_hlist;
+	unsigned char		type;
 	char			ksym_name[KSYM_NAME_LEN];
-	char			p_name[TASK_COMM_LEN];
+	char			cmd[TASK_COMM_LEN];
 };
 
 /*
@@ -343,7 +338,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_SYSCALL_ENTER);				\
 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
 			  TRACE_SYSCALL_EXIT);				\
-		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
+		IF_ASSIGN(var, ent, struct ksym_trace_entry, TRACE_KSYM);\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index eef97e7..085ff05 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -37,6 +37,15 @@
 #define KSYM_TRACER_OP_LEN 3 /* rw- */
 #define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
 
+struct trace_ksym {
+	struct hw_breakpoint	*ksym_hbp;
+	unsigned long		ksym_addr;
+#ifdef CONFIG_PROFILE_KSYM_TRACER
+	unsigned long		counter;
+#endif
+	struct hlist_node	ksym_hlist;
+};
+
 static struct trace_array *ksym_trace_array;
 
 static unsigned int ksym_filter_entry_count;
@@ -71,7 +80,7 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 {
 	struct ring_buffer_event *event;
 	struct trace_array *tr;
-	struct trace_ksym *entry;
+	struct ksym_trace_entry *entry;
 	int pc;
 
 	if (!ksym_tracing_enabled)
@@ -85,11 +94,12 @@ void ksym_hbp_handler(struct hw_breakpoint *hbp, struct pt_regs *regs)
 	if (!event)
 		return;
 
-	entry = ring_buffer_event_data(event);
+	entry		= ring_buffer_event_data(event);
+	entry->ip	= instruction_pointer(regs);
+	entry->type	= hbp->info.type;
 	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
-	entry->ksym_hbp = hbp;
-	entry->ip = instruction_pointer(regs);
-	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
+	strlcpy(entry->cmd, current->comm, TASK_COMM_LEN);
+
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	ksym_collect_stats(hbp->info.address);
 #endif /* CONFIG_PROFILE_KSYM_TRACER */
@@ -380,7 +390,7 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
-	struct trace_ksym *field;
+	struct ksym_trace_entry *field;
 	char str[KSYM_SYMBOL_LEN];
 	int ret;
 
@@ -389,12 +399,12 @@ static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
 
 	trace_assign_type(field, entry);
 
-	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
+	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->cmd,
 				entry->pid, iter->cpu, field->ksym_name);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (field->ksym_hbp->info.type) {
+	switch (field->type) {
 	case HW_BREAKPOINT_WRITE:
 		ret = trace_seq_printf(s, " W  ");
 		break;
