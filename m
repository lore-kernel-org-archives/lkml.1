Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZHSH4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZHSH4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZHSH4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:56:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56566 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZHSH4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:56:13 -0400
Message-ID: <4A8BAFCB.1040006@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 15:54:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] tracing/syscalls: Add filtering support
References: <4A8BAF16.8040504@cn.fujitsu.com>
In-Reply-To: <4A8BAF16.8040504@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add filtering support for syscall events:

 # echo 'mode == 0666' > events/syscalls/sys_enter_open
 # echo 'ret == 0' > events/syscalls/sys_exit_open
 # echo 1 > events/syscalls/sys_enter_open
 # echo 1 > events/syscalls/sys_exit_open
 # cat trace
 ...
   modprobe-3084 [001] 117.463140: sys_open(filename: 917d3e8, flags: 0, mode: 1b6) 
   modprobe-3084 [001] 117.463176: sys_open -> 0x0
       less-3086 [001] 117.510455: sys_open(filename: 9c6bdb8, flags: 8000, mode: 1b6) 
   sendmail-2574 [001] 122.145840: sys_open(filename: b807a365, flags: 0, mode: 1b6) 
 ...


Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h  |    5 ++-
 include/linux/syscalls.h      |   16 +++++++++----
 include/trace/syscall.h       |    7 +++++
 kernel/trace/trace_events.c   |    5 ++-
 kernel/trace/trace_syscalls.c |   51 +++++++++++++++++++++++++++++++++++++---
 5 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 07f5cd1..a010429 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -140,8 +140,9 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 					void *rec,
 					struct ring_buffer_event *event);
 
-extern int trace_define_field(struct ftrace_event_call *call, char *type,
-			      char *name, int offset, int size, int is_signed);
+extern int trace_define_field(struct ftrace_event_call *call,
+			      const char *type, const char *name,
+			      int offset, int size, int is_signed);
 extern int trace_define_common_fields(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 8d57f77..f124c89 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -190,6 +190,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.event                  = &event_syscall_enter,		\
 		.raw_init		= init_enter_##sname,		\
 		.show_format		= syscall_enter_format,		\
+		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= "sys"#sname,			\
@@ -226,6 +227,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.event                  = &event_syscall_exit,		\
 		.raw_init		= init_exit_##sname,		\
 		.show_format		= syscall_exit_format,		\
+		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= "sys"#sname,			\
@@ -233,6 +235,8 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
+	SYSCALL_TRACE_ENTER_EVENT(sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
@@ -241,20 +245,22 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 		.nb_args 	= nb,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
-	};							\
-	SYSCALL_TRACE_ENTER_EVENT(sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(sname);
+		.enter_event	= &event_enter_##sname,		\
+		.exit_event	= &event_exit_##sname,		\
+	};
 
 #define SYSCALL_DEFINE0(sname)					\
+	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
+	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static const struct syscall_metadata __used		\
 	  __attribute__((__aligned__(4)))			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
+		.enter_event	= &event_enter__##sname,	\
+		.exit_event	= &event_exit__##sname,		\
 	};							\
-	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
-	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	asmlinkage long sys_##sname(void)
 #else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 5ce85d7..9661dd4 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -34,6 +34,8 @@ DECLARE_TRACE_WITH_CALLBACK(syscall_exit,
  * @args: list of args as strings (args[i] matches types[i])
  * @enter_id: associated ftrace enter event id
  * @exit_id: associated ftrace exit event id
+ * @enter_event: associated syscall_enter trace event
+ * @exit_event: associated syscall_exit trace event
  */
 struct syscall_metadata {
 	const char	*name;
@@ -42,6 +44,9 @@ struct syscall_metadata {
 	const char	**args;
 	int		enter_id;
 	int		exit_id;
+
+	struct ftrace_event_call *enter_event;
+	struct ftrace_event_call *exit_event;
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
@@ -59,6 +64,8 @@ extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
 extern int syscall_exit_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
+extern int syscall_enter_define_fields(struct ftrace_event_call *call);
+extern int syscall_exit_define_fields(struct ftrace_event_call *call);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9c7ecfb..79d3520 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,8 +27,8 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
-int trace_define_field(struct ftrace_event_call *call, char *type,
-		       char *name, int offset, int size, int is_signed)
+int trace_define_field(struct ftrace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed)
 {
 	struct ftrace_event_field *field;
 
@@ -83,6 +83,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(trace_define_common_fields);
 
 #ifdef CONFIG_MODULES
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ce44cdd..495c639 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -163,6 +163,49 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 	return trace_seq_printf(s, "\nprint fmt: \"0x%%lx\", REC->ret\n");
 }
 
+int syscall_enter_define_fields(struct ftrace_event_call *call)
+{
+	struct syscall_trace_enter trace;
+	struct syscall_metadata *meta;
+	int ret;
+	int nr;
+	int i;
+	int offset = offsetof(typeof(trace), args);
+
+	nr = syscall_name_to_nr(call->data);
+	meta = syscall_nr_to_meta(nr);
+
+	if (!meta)
+		return 0;
+
+	ret = trace_define_common_fields(call);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < meta->nb_args; i++) {
+		ret = trace_define_field(call, meta->types[i],
+					 meta->args[i], offset,
+					 sizeof(unsigned long), 0);
+		offset += sizeof(unsigned long);
+	}
+
+	return ret;
+}
+
+int syscall_exit_define_fields(struct ftrace_event_call *call)
+{
+	struct syscall_trace_exit trace;
+	int ret;
+
+	ret = trace_define_common_fields(call);
+	if (ret)
+		return ret;
+
+	ret = trace_define_field(call, SYSCALL_FIELD(unsigned long, ret), 0);
+
+	return ret;
+}
+
 void ftrace_syscall_enter(struct pt_regs *regs, long id)
 {
 	struct syscall_trace_enter *entry;
@@ -190,8 +233,8 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
+	if (!filter_current_check_discard(sys_data->enter_event, entry, event))
+		trace_current_buffer_unlock_commit(event, 0, 0);
 }
 
 void ftrace_syscall_exit(struct pt_regs *regs, long ret)
@@ -218,8 +261,8 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	trace_current_buffer_unlock_commit(event, 0, 0);
-	trace_wake_up();
+	if (!filter_current_check_discard(sys_data->exit_event, entry, event))
+		trace_current_buffer_unlock_commit(event, 0, 0);
 }
 
 int reg_event_syscall_enter(void *ptr)
-- 
1.6.3
