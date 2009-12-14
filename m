Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZLNJqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZLNJqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZLNJq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:46:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:59644 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbZLNJq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:46:28 -0500
Date: Mon, 14 Dec 2009 09:45:33 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, jbaron@redhat.com, mingo@elte.hu
In-Reply-To: <4B1DC48C.7080603@cn.fujitsu.com>
References: <4B1DC48C.7080603@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing: Extract duplicate ftrace_raw_init_event_foo()
Message-ID: <tip-87d9b4e1c52867a45331a9a5495f6448e0c68b23@git.kernel.org>
Git-Commit-ID: 87d9b4e1c52867a45331a9a5495f6448e0c68b23
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87d9b4e1c52867a45331a9a5495f6448e0c68b23
Gitweb:     http://git.kernel.org/tip/87d9b4e1c52867a45331a9a5495f6448e0c68b23
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:14:20 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:34:23 +0100

tracing: Extract duplicate ftrace_raw_init_event_foo()

Use a generic trace_event_raw_init() function for all event's raw_init
callbacks (but kprobes) instead of defining the same version for each
of these.
This shrinks the kernel code:

   text    data     bss     dec     hex filename
5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
5346802 1961864 7103260 14411926         dbe896 vmlinux.o

raw_init can't be removed, because ftrace events and kprobe events
use different raw_init callbacks. Though it's possible to totally
remove raw_init, I choose to leave it as it is for now.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <4B1DC48C.7080603@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h |    1 +
 include/linux/syscalls.h     |    4 ++--
 include/trace/ftrace.h       |   35 ++++-------------------------------
 kernel/trace/trace_events.c  |   14 ++++++++++++++
 4 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 38f8d65..ea44b89 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -158,6 +158,7 @@ enum {
 	FILTER_PTR_STRING,
 };
 
+extern int trace_event_raw_init(struct ftrace_event_call *call);
 extern int trace_define_common_fields(struct ftrace_event_call *call);
 extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index bc70c58..94ac284 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -145,7 +145,7 @@ struct perf_event_attr;
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
+		.raw_init		= trace_event_raw_init,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
@@ -167,7 +167,7 @@ struct perf_event_attr;
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= init_syscall_trace,		\
+		.raw_init		= trace_event_raw_init,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c4eca38..6055b06 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -623,23 +623,12 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
- * static int ftrace_raw_init_event_<call>(struct ftrace_event_call *unused)
- * {
- *	int id;
- *
- *	id = register_ftrace_event(&ftrace_event_type_<call>);
- *	if (!id)
- *		return -ENODEV;
- *	event_<call>.id = id;
- *	return 0;
- * }
- *
  * static struct ftrace_event_call __used
  * __attribute__((__aligned__(4)))
  * __attribute__((section("_ftrace_events"))) event_<call> = {
  *	.name			= "<call>",
  *	.system			= "<system>",
- *	.raw_init		= ftrace_raw_init_event_<call>,
+ *	.raw_init		= trace_event_raw_init,
  *	.regfunc		= ftrace_reg_event_<call>,
  *	.unregfunc		= ftrace_unreg_event_<call>,
  *	.show_format		= ftrace_format_<call>,
@@ -647,9 +636,6 @@ static void ftrace_profile_disable_##name(struct ftrace_event_call *unused)\
  *
  */
 
-#undef TP_FMT
-#define TP_FMT(fmt, args...)	fmt "\n", ##args
-
 #ifdef CONFIG_EVENT_PROFILE
 
 #define _TRACE_PROFILE_INIT(call)					\
@@ -744,19 +730,7 @@ static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
 									\
 static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
-};									\
-									\
-static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
-{									\
-	int id;								\
-									\
-	id = register_ftrace_event(&ftrace_event_type_##call);		\
-	if (!id)							\
-		return -ENODEV;						\
-	event_##call.id = id;						\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	return 0;							\
-}
+};
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
@@ -776,7 +750,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##template,		\
@@ -793,7 +767,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.event			= &ftrace_event_type_##call,		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
@@ -953,7 +927,6 @@ end:									\
 	perf_swevent_put_recursion_context(rctx);			\
 end_recursion:								\
 	local_irq_restore(irq_flags);					\
-									\
 }
 
 #undef DEFINE_EVENT
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1d18315..8ed66e0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -105,6 +105,20 @@ void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
+int trace_event_raw_init(struct ftrace_event_call *call)
+{
+	int id;
+
+	id = register_ftrace_event(call->event);
+	if (!id)
+		return -ENODEV;
+	call->id = id;
+	INIT_LIST_HEAD(&call->fields);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(trace_event_raw_init);
+
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
