Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZLAQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZLAQoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZLAQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:44:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:42334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZLAQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:44:14 -0500
Date: Tue, 1 Dec 2009 16:43:44 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B14D2A1.8060304@cn.fujitsu.com>
References: <4B14D2A1.8060304@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Simplify syscall profile
Message-ID: <tip-3bbe84e9d385205d638035ee9dcc4db1b486ea08@git.kernel.org>
Git-Commit-ID: 3bbe84e9d385205d638035ee9dcc4db1b486ea08
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bbe84e9d385205d638035ee9dcc4db1b486ea08
Gitweb:     http://git.kernel.org/tip/3bbe84e9d385205d638035ee9dcc4db1b486ea08
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 16:24:01 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 17:33:30 +0100

trace_syscalls: Simplify syscall profile

use only one prof_sysenter_enable() instead of
prof_sysenter_enable_##sname()

use only one prof_sysenter_disable() instead of
prof_sysenter_disable_##sname()

use only one prof_sysexit_enable() instead of
prof_sysexit_enable_##sname()

use only one prof_sysexit_disable() instead of
prof_sysexit_disable_##sname()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B14D2A1.8060304@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h      |   31 ++++---------------------------
 include/trace/syscall.h       |    8 ++++----
 kernel/trace/trace_syscalls.c |   24 ++++++++----------------
 3 files changed, 16 insertions(+), 47 deletions(-)

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
