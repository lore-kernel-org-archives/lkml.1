Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZHSHxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZHSHxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZHSHxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:53:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53254 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZHSHxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:53:46 -0400
Message-ID: <4A8BAF39.1030404@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 15:52:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] tracing/syscalls: Fix fields format for enter events
References: <4A8BAF16.8040504@cn.fujitsu.com>
In-Reply-To: <4A8BAF16.8040504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "format" file of a trace event is originally for parsers to
parse ftrace binary output.

But the "format" file of a syscall event can only be used by
perfcounter, because it describes the format of struct
syscall_enter_record not struct syscall_trace_enter.

To fix this, we remove struct syscall_enter_record, and then
struct syscall_trace_enter will be used by both perf profile
and ftrace.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_syscalls.c |   51 ++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f130dac..d10daf0 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -90,26 +90,39 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
+extern char *__bad_type_size(void);
+
+#define SYSCALL_FIELD(type, name)					\
+	sizeof(type) != sizeof(trace.name) ?				\
+		__bad_type_size() :					\
+		#type, #name, offsetof(typeof(trace), name), sizeof(trace.name)
+
 int ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	int i;
 	int nr;
-	int ret = 0;
+	int ret;
 	struct syscall_metadata *entry;
-	int offset = sizeof(struct trace_entry);
+	struct syscall_trace_enter trace;
+	int offset = offsetof(struct syscall_trace_enter, args);
 
-	nr = syscall_name_to_nr((char *)call->data);
+	nr = syscall_name_to_nr(call->data);
 	entry = syscall_nr_to_meta(nr);
 
 	if (!entry)
-		return ret;
+		return 0;
+
+	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;\n",
+			       SYSCALL_FIELD(int, nr));
+	if (!ret)
+		return 0;
 
 	for (i = 0; i < entry->nb_args; i++) {
 		ret = trace_seq_printf(s, "\tfield:%s %s;", entry->types[i],
 				        entry->args[i]);
 		if (!ret)
 			return 0;
-		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%lu;\n", offset,
+		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%zu;\n", offset,
 				       sizeof(unsigned long));
 		if (!ret)
 			return 0;
@@ -118,7 +131,7 @@ int ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s)
 
 	trace_seq_printf(s, "\nprint fmt: \"");
 	for (i = 0; i < entry->nb_args; i++) {
-		ret = trace_seq_printf(s, "%s: 0x%%0%lulx%s", entry->args[i],
+		ret = trace_seq_printf(s, "%s: 0x%%0%zulx%s", entry->args[i],
 				        sizeof(unsigned long),
 					i == entry->nb_args - 1 ? "\", " : ", ");
 		if (!ret)
@@ -287,16 +300,6 @@ struct trace_event event_syscall_exit = {
 
 #ifdef CONFIG_EVENT_PROFILE
 
-struct syscall_enter_record {
-	struct trace_entry	entry;
-	unsigned long		args[0];
-};
-
-struct syscall_exit_record {
-	struct trace_entry	entry;
-	unsigned long		ret;
-};
-
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
 static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
 static int sys_prof_refcount_enter;
@@ -304,7 +307,7 @@ static int sys_prof_refcount_exit;
 
 static void prof_syscall_enter(struct pt_regs *regs, long id)
 {
-	struct syscall_enter_record *rec;
+	struct syscall_trace_enter *rec;
 	struct syscall_metadata *sys_data;
 	int syscall_nr;
 	int size;
@@ -328,9 +331,10 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 		/* zero the dead bytes from align to not leak stack to user */
 		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
 
-		rec = (struct syscall_enter_record *) raw_data;
-		tracing_generic_entry_update(&rec->entry, 0, 0);
-		rec->entry.type = sys_data->enter_id;
+		rec = (struct syscall_trace_enter *) raw_data;
+		tracing_generic_entry_update(&rec->ent, 0, 0);
+		rec->ent.type = sys_data->enter_id;
+		rec->nr = syscall_nr;
 		syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 				       (unsigned long *)&rec->args);
 		perf_tpcounter_event(sys_data->enter_id, 0, 1, rec, size);
@@ -379,7 +383,7 @@ void unreg_prof_syscall_enter(char *name)
 static void prof_syscall_exit(struct pt_regs *regs, long ret)
 {
 	struct syscall_metadata *sys_data;
-	struct syscall_exit_record rec;
+	struct syscall_trace_exit rec;
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
@@ -390,8 +394,9 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	tracing_generic_entry_update(&rec.entry, 0, 0);
-	rec.entry.type = sys_data->exit_id;
+	tracing_generic_entry_update(&rec.ent, 0, 0);
+	rec.ent.type = sys_data->exit_id;
+	rec.nr = syscall_nr;
 	rec.ret = syscall_get_return_value(current, regs);
 
 	perf_tpcounter_event(sys_data->exit_id, 0, 1, &rec, sizeof(rec));
-- 
1.6.3
