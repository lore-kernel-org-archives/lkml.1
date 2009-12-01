Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZLAIYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZLAIYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZLAIYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:24:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54362 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZLAIY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:24:29 -0500
Message-ID: <4B14D29B.6090708@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:23:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/7] trace_syscalls: remove duplicate init_enter_##sname()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use only one init_syscall_trace instead of
many init_enter_##sname()/init_exit_##sname()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3c280d7..cf0d923 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -158,19 +158,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	struct trace_event enter_syscall_print_##sname = {		\
 		.trace                  = print_syscall_enter,		\
 	};								\
-	static int init_enter_##sname(struct ftrace_event_call *call)	\
-	{								\
-		int num, id;						\
-		num = __syscall_meta_##sname.syscall_nr;		\
-		if (num < 0)						\
-			return -ENOSYS;					\
-		id = register_ftrace_event(&enter_syscall_print_##sname);\
-		if (!id)						\
-			return -ENODEV;					\
-		event_enter_##sname.id = id;				\
-		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
-		return 0;						\
-	}								\
 	TRACE_SYS_ENTER_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
@@ -179,7 +166,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		.name                   = "sys_enter"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &enter_syscall_print_##sname,	\
-		.raw_init		= init_enter_##sname,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_enter_format,		\
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
@@ -194,19 +181,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	struct trace_event exit_syscall_print_##sname = {		\
 		.trace                  = print_syscall_exit,		\
 	};								\
-	static int init_exit_##sname(struct ftrace_event_call *call)	\
-	{								\
-		int num, id;						\
-		num = __syscall_meta_##sname.syscall_nr;		\
-		if (num < 0)						\
-			return -ENOSYS;					\
-		id = register_ftrace_event(&exit_syscall_print_##sname);\
-		if (!id)						\
-			return -ENODEV;					\
-		event_exit_##sname.id = id;				\
-		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
-		return 0;						\
-	}								\
 	TRACE_SYS_EXIT_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
@@ -215,7 +189,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		.name                   = "sys_exit"#sname,		\
 		.system                 = "syscalls",			\
 		.event                  = &exit_syscall_print_##sname,	\
-		.raw_init		= init_exit_##sname,		\
+		.raw_init		= init_syscall_trace,		\
 		.show_format		= syscall_exit_format,		\
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 1531eef..dff9371 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -32,6 +32,7 @@ struct syscall_metadata {
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
+extern int init_syscall_trace(struct ftrace_event_call *call);
 
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 144cc14..c651409 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -412,6 +412,18 @@ void unreg_event_syscall_exit(struct ftrace_event_call *call)
 	mutex_unlock(&syscall_trace_lock);
 }
 
+int init_syscall_trace(struct ftrace_event_call *call)
+{
+	int id;
+
+	id = register_ftrace_event(call->event);
+	if (!id)
+		return -ENODEV;
+	call->id = id;
+	INIT_LIST_HEAD(&call->fields);
+	return 0;
+}
+
 int __init init_ftrace_syscalls(void)
 {
 	struct syscall_metadata *meta;


