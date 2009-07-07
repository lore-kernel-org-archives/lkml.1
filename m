Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZGGFwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZGGFwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbZGGFwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:52:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZGGFwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:52:32 -0400
Message-ID: <4A52E2A4.4050007@cn.fujitsu.com>
Date: Tue, 07 Jul 2009 13:52:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] ksym_tracer: Extract trace entry from struct trace_ksym
References: <4A52E291.1020408@cn.fujitsu.com>
In-Reply-To: <4A52E291.1020408@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct trace_ksym is used as an entry in hbp list, and is also
used as trace_entry stored in ring buffer.

This is not necessary and is a waste of memory in ring buffer.

There is also a bug that dereferencing field->ksym_hbp in
ksym_trace_output() can be invalid.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h      |   13 ++++---------
 kernel/trace/trace_ksym.c |   26 ++++++++++++++++++--------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 61b4e94..6868902 100644
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
-- 
1.5.4.rc3

