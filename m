Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZHKSte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZHKSte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbZHKSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:49:30 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42538 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbZHKSt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FyDXNgdfSJVutMeBdBfsRLsYcmyrM5paEzWSeEU7wayK1ye00kqA54HaWJxbt57Xmi
         vqLtfGsE4MRHK0jjdYqkrRf78ydC9qxeGOK1DfZ5dSCV+JOZ0tocKcTMr7hpB4H9jvak
         FX3CJZO0jWuOpXk7FJdCiDVyuNR0mOgr8DkuE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/16] tracing: Add individual syscalls tracepoint id support
Date: Tue, 11 Aug 2009 20:48:59 +0200
Message-Id: <1250016545-6601-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

The current state of syscalls tracepoints generates only one event id
for every syscall events.

This patch associates an id with each syscall trace event, so that we
can identify each syscall trace event using the 'perf' tool.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ftrace.c      |   10 ++++++++++
 include/linux/syscalls.h      |   22 ++++++++++++++++++----
 include/trace/syscall.h       |    8 ++++++++
 kernel/trace/trace.h          |    6 ------
 kernel/trace/trace_syscalls.c |   26 ++++++++++++++++----------
 5 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 0d93d40..3cff121 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -516,6 +516,16 @@ int syscall_name_to_nr(char *name)
 	return -1;
 }
 
+void set_syscall_enter_id(int num, int id)
+{
+	syscalls_metadata[num]->enter_id = id;
+}
+
+void set_syscall_exit_id(int num, int id)
+{
+	syscalls_metadata[num]->exit_id = id;
+}
+
 static int __init arch_init_ftrace_syscalls(void)
 {
 	int i;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 5e5b4d3..ce4b01c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -116,13 +116,20 @@ struct perf_counter_attr;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct ftrace_event_call event_enter_##sname;		\
+	struct trace_event enter_syscall_print_##sname = {		\
+		.trace                  = print_syscall_enter,		\
+	};								\
 	static int init_enter_##sname(void)				\
 	{								\
-		int num;						\
+		int num, id;						\
 		num = syscall_name_to_nr("sys"#sname);			\
 		if (num < 0)						\
 			return -ENOSYS;					\
-		register_ftrace_event(&event_syscall_enter);		\
+		id = register_ftrace_event(&enter_syscall_print_##sname);\
+		if (!id)						\
+			return -ENODEV;					\
+		event_enter_##sname.id = id;				\
+		set_syscall_enter_id(num, id);				\
 		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
 		init_preds(&event_enter_##sname);			\
 		return 0;						\
@@ -142,13 +149,20 @@ struct perf_counter_attr;
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
 	static struct ftrace_event_call event_exit_##sname;		\
+	struct trace_event exit_syscall_print_##sname = {		\
+		.trace                  = print_syscall_exit,		\
+	};								\
 	static int init_exit_##sname(void)				\
 	{								\
-		int num;						\
+		int num, id;						\
 		num = syscall_name_to_nr("sys"#sname);			\
 		if (num < 0)						\
 			return -ENOSYS;					\
-		register_ftrace_event(&event_syscall_exit);		\
+		id = register_ftrace_event(&exit_syscall_print_##sname);\
+		if (!id)						\
+			return -ENODEV;					\
+		event_exit_##sname.id = id;				\
+		set_syscall_exit_id(num, id);				\
 		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
 		init_preds(&event_exit_##sname);			\
 		return 0;						\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 73fb8b4..df62840 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -32,23 +32,31 @@ DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
+ * @enter_id: associated ftrace enter event id
+ * @exit_id: associated ftrace exit event id
  */
 struct syscall_metadata {
 	const char	*name;
 	int		nb_args;
 	const char	**types;
 	const char	**args;
+	int		enter_id;
+	int		exit_id;
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern struct syscall_metadata *syscall_nr_to_meta(int nr);
 extern int syscall_name_to_nr(char *name);
+void set_syscall_enter_id(int num, int id);
+void set_syscall_exit_id(int num, int id);
 extern struct trace_event event_syscall_enter;
 extern struct trace_event event_syscall_exit;
 extern int reg_event_syscall_enter(void *ptr);
 extern void unreg_event_syscall_enter(void *ptr);
 extern int reg_event_syscall_exit(void *ptr);
 extern void unreg_event_syscall_exit(void *ptr);
+enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
+enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d682357..300ef78 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -34,8 +34,6 @@ enum trace_type {
 	TRACE_GRAPH_ENT,
 	TRACE_USER_STACK,
 	TRACE_HW_BRANCHES,
-	TRACE_SYSCALL_ENTER,
-	TRACE_SYSCALL_EXIT,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
@@ -319,10 +317,6 @@ extern void __ftrace_bad_type(void);
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
 			  TRACE_KMEM_FREE);	\
-		IF_ASSIGN(var, ent, struct syscall_trace_enter,		\
-			  TRACE_SYSCALL_ENTER);				\
-		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
-			  TRACE_SYSCALL_EXIT);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c7ae25e..e58a9c1 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -36,14 +36,18 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 	struct syscall_metadata *entry;
 	int i, ret, syscall;
 
-	trace_assign_type(trace, ent);
-
+	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-
 	entry = syscall_nr_to_meta(syscall);
+
 	if (!entry)
 		goto end;
 
+	if (entry->enter_id != ent->type) {
+		WARN_ON_ONCE(1);
+		goto end;
+	}
+
 	ret = trace_seq_printf(s, "%s(", entry->name);
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
@@ -78,16 +82,20 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 	struct syscall_metadata *entry;
 	int ret;
 
-	trace_assign_type(trace, ent);
-
+	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-
 	entry = syscall_nr_to_meta(syscall);
+
 	if (!entry) {
 		trace_seq_printf(s, "\n");
 		return TRACE_TYPE_HANDLED;
 	}
 
+	if (entry->exit_id != ent->type) {
+		WARN_ON_ONCE(1);
+		return TRACE_TYPE_UNHANDLED;
+	}
+
 	ret = trace_seq_printf(s, "%s -> 0x%lx\n", entry->name,
 				trace->ret);
 	if (!ret)
@@ -114,7 +122,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_ENTER, size,
+	event = trace_current_buffer_lock_reserve(sys_data->enter_id, size,
 							0, 0);
 	if (!event)
 		return;
@@ -142,7 +150,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	event = trace_current_buffer_lock_reserve(TRACE_SYSCALL_EXIT,
+	event = trace_current_buffer_lock_reserve(sys_data->exit_id,
 				sizeof(*entry), 0, 0);
 	if (!event)
 		return;
@@ -239,10 +247,8 @@ void unreg_event_syscall_exit(void *ptr)
 
 struct trace_event event_syscall_enter = {
 	.trace			= print_syscall_enter,
-	.type			= TRACE_SYSCALL_ENTER
 };
 
 struct trace_event event_syscall_exit = {
 	.trace			= print_syscall_exit,
-	.type			= TRACE_SYSCALL_EXIT
 };
-- 
1.6.2.3

