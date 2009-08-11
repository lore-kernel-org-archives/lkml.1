Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbZHKSuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbZHKSuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932218AbZHKSt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:59 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbZHKStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J4MtfeRILwLSqMvxVLn5kS5Rw7u57w2PqUpyCzbCAyMQZJ4qBYN6au78jRuLnK7BQE
         aRF8erIR1HjwS9FN8L4v6IydjaAxwg/rxvVom6XDhhyRTtMrMdx8+IE/mzztY/W57lfd
         uXp6uEMmyXFBtBNBiPK6jJvine6cxwdChlVdA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Jason Baron <jbaron@redhat.com>
Subject: [PATCH 15/16] tracing: Add fields format definition for syscall events
Date: Tue, 11 Aug 2009 20:49:04 +0200
Message-Id: <1250016545-6601-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the format of the syscall trace fields to parse the binary
values from a raw trace using the syscall events "format" file.

This is defined dynamically using the syscalls metadata.
It prepares the export of syscall event raw records to perf
counters.

Example:

$ cat /debug/tracing/events/syscalls/sys_enter_sched_getparam/format
name: sys_enter_sched_getparam
ID: 39
format:
	field:unsigned short common_type;	offset:0;	size:2;
	field:unsigned char common_flags;	offset:2;	size:1;
	field:unsigned char common_preempt_count;	offset:3;	size:1;
	field:int common_pid;	offset:4;	size:4;
	field:int common_tgid;	offset:8;	size:4;

	field:pid_t pid;	offset:12;	size:8;
	field:struct sched_param * param;	offset:20;	size:8;

print fmt: "pid: 0x%08lx, param: 0x%08lx", ((unsigned long)(REC->pid)), ((unsigned long)(REC->param))

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/syscalls.h      |    1 +
 include/trace/syscall.h       |    2 +
 kernel/trace/trace_syscalls.c |   46 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5541e75..87d06c1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -189,6 +189,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.system                 = "syscalls",			\
 		.event                  = &event_syscall_enter,		\
 		.raw_init		= init_enter_##sname,		\
+		.show_format		= ftrace_format_syscall,	\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= "sys"#sname,			\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 3ab6dd1..0cb0362 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -55,6 +55,8 @@ extern int reg_event_syscall_enter(void *ptr);
 extern void unreg_event_syscall_enter(void *ptr);
 extern int reg_event_syscall_exit(void *ptr);
 extern void unreg_event_syscall_exit(void *ptr);
+extern int
+ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f4eaec3..9ee6386 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -105,6 +105,52 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	return TRACE_TYPE_HANDLED;
 }
 
+int ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s)
+{
+	int i;
+	int nr;
+	int ret = 0;
+	struct syscall_metadata *entry;
+	int offset = sizeof(struct trace_entry);
+
+	nr = syscall_name_to_nr((char *)call->data);
+	entry = syscall_nr_to_meta(nr);
+
+	if (!entry)
+		return ret;
+
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, "\tfield:%s %s;", entry->types[i],
+				        entry->args[i]);
+		if (!ret)
+			return 0;
+		ret = trace_seq_printf(s, "\toffset:%d;\tsize:%lu;\n", offset,
+				       sizeof(unsigned long));
+		if (!ret)
+			return 0;
+		offset += sizeof(unsigned long);
+	}
+
+	trace_seq_printf(s, "\nprint fmt: \"");
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, "%s: 0x%%0%lulx%s", entry->args[i],
+				        sizeof(unsigned long),
+					i == entry->nb_args - 1 ? "\", " : ", ");
+		if (!ret)
+			return 0;
+	}
+
+	for (i = 0; i < entry->nb_args; i++) {
+		ret = trace_seq_printf(s, "((unsigned long)(REC->%s))%s",
+				        entry->args[i],
+					i == entry->nb_args - 1 ? "\n" : ", ");
+		if (!ret)
+			return 0;
+	}
+
+	return ret;
+}
+
 void ftrace_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
-- 
1.6.2.3

