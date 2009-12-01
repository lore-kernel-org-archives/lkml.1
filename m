Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZLAIYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZLAIYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZLAIYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:24:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbZLAIYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:24:35 -0500
Message-ID: <4B14D2A1.8060304@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:24:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] trace_syscalls: simplify syscall profile
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use only one prof_sysenter_enable() instead of
prof_sysenter_enable_##sname()

use only one prof_sysenter_disable() instead of
prof_sysenter_disable_##sname()

use only one prof_sysexit_enable() instead of
prof_sysexit_enable_##sname()

use only one prof_sysexit_disable() instead of
prof_sysexit_disable_##sname()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cf0d923..c2df3a5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -99,37 +99,16 @@ struct perf_event_attr;
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
 #ifdef CONFIG_EVENT_PROFILE
-#define TRACE_SYS_ENTER_PROFILE(sname)					       \
-static int prof_sysenter_enable_##sname(struct ftrace_event_call *unused)      \
-{									       \
-	return reg_prof_syscall_enter("sys"#sname);			       \
-}									       \
-									       \
-static void prof_sysenter_disable_##sname(struct ftrace_event_call *unused)    \
-{									       \
-	unreg_prof_syscall_enter("sys"#sname);				       \
-}
-
-#define TRACE_SYS_EXIT_PROFILE(sname)					       \
-static int prof_sysexit_enable_##sname(struct ftrace_event_call *unused)       \
-{									       \
-	return reg_prof_syscall_exit("sys"#sname);			       \
-}									       \
-									       \
-static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
-{                                                                              \
-	unreg_prof_syscall_exit("sys"#sname);				       \
-}
 
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
 	.profile_count = ATOMIC_INIT(-1),				       \
-	.profile_enable = prof_sysenter_enable_##sname,			       \
-	.profile_disable = prof_sysenter_disable_##sname,
+	.profile_enable = prof_sysenter_enable,				       \
+	.profile_disable = prof_sysenter_disable,
 
 #define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
 	.profile_count = ATOMIC_INIT(-1),				       \
-	.profile_enable = prof_sysexit_enable_##sname,			       \
-	.profile_disable = prof_sysexit_disable_##sname,
+	.profile_enable = prof_sysexit_enable,				       \
+	.profile_disable = prof_sysexit_disable,
 #else
 #define TRACE_SYS_ENTER_PROFILE(sname)
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)
@@ -158,7 +137,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	struct trace_event enter_syscall_print_##sname = {		\
 		.trace                  = print_syscall_enter,		\
 	};								\
-	TRACE_SYS_ENTER_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -181,7 +159,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	struct trace_event exit_syscall_print_##sname = {		\
 		.trace                  = print_syscall_exit,		\
 	};								\
-	TRACE_SYS_EXIT_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index dff9371..961fda3 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -50,10 +50,10 @@ enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
 #ifdef CONFIG_EVENT_PROFILE
-int reg_prof_syscall_enter(char *name);
-void unreg_prof_syscall_enter(char *name);
-int reg_prof_syscall_exit(char *name);
-void unreg_prof_syscall_exit(char *name);
+int prof_sysenter_enable(struct ftrace_event_call *call);
+void prof_sysenter_disable(struct ftrace_event_call *call);
+int prof_sysexit_enable(struct ftrace_event_call *call);
+void prof_sysexit_disable(struct ftrace_event_call *call);
 
 #endif
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c651409..1e85b6c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -520,14 +520,12 @@ end_recursion:
 	local_irq_restore(flags);
 }
 
-int reg_prof_syscall_enter(char *name)
+int prof_sysenter_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
 
-	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_prof_refcount_enter)
@@ -543,13 +541,11 @@ int reg_prof_syscall_enter(char *name)
 	return ret;
 }
 
-void unreg_prof_syscall_enter(char *name)
+void prof_sysenter_disable(struct ftrace_event_call *call)
 {
 	int num;
 
-	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= NR_syscalls)
-		return;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_prof_refcount_enter--;
@@ -625,14 +621,12 @@ end_recursion:
 	local_irq_restore(flags);
 }
 
-int reg_prof_syscall_exit(char *name)
+int prof_sysexit_enable(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
 
-	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= NR_syscalls)
-		return -ENOSYS;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
 	if (!sys_prof_refcount_exit)
@@ -648,13 +642,11 @@ int reg_prof_syscall_exit(char *name)
 	return ret;
 }
 
-void unreg_prof_syscall_exit(char *name)
+void prof_sysexit_disable(struct ftrace_event_call *call)
 {
 	int num;
 
-	num = syscall_name_to_nr(name);
-	if (num < 0 || num >= NR_syscalls)
-		return;
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 
 	mutex_lock(&syscall_trace_lock);
 	sys_prof_refcount_exit--;


