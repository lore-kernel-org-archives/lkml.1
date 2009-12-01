Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbZLAQnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbZLAQnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZLAQno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:43:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:42298 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838AbZLAQnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:43:42 -0500
Date: Tue, 1 Dec 2009 16:42:49 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B14D282.7050709@cn.fujitsu.com>
References: <4B14D282.7050709@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Set event_enter_##sname->data to its metadata
Message-ID: <tip-31c16b13349970b2684248c7d8608d2a96ae135d@git.kernel.org>
Git-Commit-ID: 31c16b13349970b2684248c7d8608d2a96ae135d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31c16b13349970b2684248c7d8608d2a96ae135d
Gitweb:     http://git.kernel.org/tip/31c16b13349970b2684248c7d8608d2a96ae135d
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 16:23:30 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 17:33:28 +0100

trace_syscalls: Set event_enter_##sname->data to its metadata

Set event_enter_##sname->data to its metadata,
it makes codes simpler.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B14D282.7050709@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h      |    6 ++++--
 include/trace/syscall.h       |    2 +-
 kernel/trace/trace_syscalls.c |   36 +++++++++++-------------------------
 3 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2f7c539..d3c9fd0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -153,6 +153,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
+	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call event_enter_##sname;		\
 	struct trace_event enter_syscall_print_##sname = {		\
 		.trace                  = print_syscall_enter,		\
@@ -184,11 +185,12 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		.define_fields		= syscall_enter_define_fields,	\
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
-		.data			= "sys"#sname,			\
+		.data			= (void *)&__syscall_meta_##sname,\
 		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
+	static const struct syscall_metadata __syscall_meta_##sname;	\
 	static struct ftrace_event_call event_exit_##sname;		\
 	struct trace_event exit_syscall_print_##sname = {		\
 		.trace                  = print_syscall_exit,		\
@@ -220,7 +222,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		.define_fields		= syscall_exit_define_fields,	\
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
-		.data			= "sys"#sname,			\
+		.data			= (void *)&__syscall_meta_##sname,\
 		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
 	}
 
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 5f8827c..c5265c8 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -34,7 +34,7 @@ struct syscall_metadata {
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
-extern int syscall_name_to_nr(char *name);
+extern int syscall_name_to_nr(const char *name);
 void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 00d6e17..39649b1 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -51,7 +51,7 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
-int syscall_name_to_nr(char *name)
+int syscall_name_to_nr(const char *name)
 {
 	int i;
 
@@ -172,18 +172,11 @@ extern char *__bad_type_size(void);
 int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	int i;
-	int nr;
 	int ret;
-	struct syscall_metadata *entry;
+	struct syscall_metadata *entry = call->data;
 	struct syscall_trace_enter trace;
 	int offset = offsetof(struct syscall_trace_enter, args);
 
-	nr = syscall_name_to_nr(call->data);
-	entry = syscall_nr_to_meta(nr);
-
-	if (!entry)
-		return 0;
-
 	ret = trace_seq_printf(s, "\tfield:%s %s;\toffset:%zu;\tsize:%zu;"
 			       "\tsigned:%u;\n",
 			       SYSCALL_FIELD(int, nr));
@@ -245,18 +238,11 @@ int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 int syscall_enter_define_fields(struct ftrace_event_call *call)
 {
 	struct syscall_trace_enter trace;
-	struct syscall_metadata *meta;
+	struct syscall_metadata *meta = call->data;
 	int ret;
-	int nr;
 	int i;
 	int offset = offsetof(typeof(trace), args);
 
-	nr = syscall_name_to_nr(call->data);
-	meta = syscall_nr_to_meta(nr);
-
-	if (!meta)
-		return 0;
-
 	ret = trace_define_common_fields(call);
 	if (ret)
 		return ret;
@@ -366,9 +352,9 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
-	char *name;
+	const char *name;
 
-	name = (char *)call->data;
+	name = ((struct syscall_metadata *)call->data)->name;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
@@ -389,9 +375,9 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int num;
-	char *name;
+	const char *name;
 
-	name = (char *)call->data;
+	name = ((struct syscall_metadata *)call->data)->name;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= NR_syscalls)
 		return;
@@ -407,9 +393,9 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
-	char *name;
+	const char *name;
 
-	name = call->data;
+	name = ((struct syscall_metadata *)call->data)->name;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
@@ -430,9 +416,9 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int num;
-	char *name;
+	const char *name;
 
-	name = call->data;
+	name = ((struct syscall_metadata *)call->data)->name;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= NR_syscalls)
 		return;
