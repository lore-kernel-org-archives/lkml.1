Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZLAIY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZLAIY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZLAIYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:24:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50931 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZLAIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:24:22 -0500
Message-ID: <4B14D293.6090800@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:23:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] trace_syscalls: add syscall_nr field to struct syscall_metadata
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add syscall_nr field to struct syscall_metadata,
it helps us to get syscall number easier.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b9af875..3c280d7 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -161,7 +161,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	static int init_enter_##sname(struct ftrace_event_call *call)	\
 	{								\
 		int num, id;						\
-		num = syscall_name_to_nr("sys"#sname);			\
+		num = __syscall_meta_##sname.syscall_nr;		\
 		if (num < 0)						\
 			return -ENOSYS;					\
 		id = register_ftrace_event(&enter_syscall_print_##sname);\
@@ -197,7 +197,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 	static int init_exit_##sname(struct ftrace_event_call *call)	\
 	{								\
 		int num, id;						\
-		num = syscall_name_to_nr("sys"#sname);			\
+		num = __syscall_meta_##sname.syscall_nr;		\
 		if (num < 0)						\
 			return -ENOSYS;					\
 		id = register_ftrace_event(&exit_syscall_print_##sname);\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index ca09561..1531eef 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -12,6 +12,7 @@
  * A syscall entry in the ftrace syscalls array.
  *
  * @name: name of the syscall
+ * @syscall_nr: number of the syscall
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
@@ -20,6 +21,7 @@
  */
 struct syscall_metadata {
 	const char	*name;
+	int		syscall_nr;
 	int		nb_args;
 	const char	**types;
 	const char	**args;
@@ -30,7 +32,6 @@ struct syscall_metadata {
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
-extern int syscall_name_to_nr(const char *name);
 
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 27eb18d..144cc14 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -51,7 +51,7 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
-int syscall_name_to_nr(const char *name)
+static int syscall_name_to_nr(const char *name)
 {
 	int i;
 
@@ -342,10 +342,8 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
-	const char *name;
 
-	name = ((struct syscall_metadata *)call->data)->name;
-	num = syscall_name_to_nr(name);
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
@@ -365,10 +363,8 @@ int reg_event_syscall_enter(struct ftrace_event_call *call)
 void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int num;
-	const char *name;
 
-	name = ((struct syscall_metadata *)call->data)->name;
-	num = syscall_name_to_nr(name);
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
@@ -383,10 +379,8 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
-	const char *name;
 
-	name = ((struct syscall_metadata *)call->data)->name;
-	num = syscall_name_to_nr(name);
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (num < 0 || num >= NR_syscalls)
 		return -ENOSYS;
 	mutex_lock(&syscall_trace_lock);
@@ -406,10 +400,8 @@ int reg_event_syscall_exit(struct ftrace_event_call *call)
 void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int num;
-	const char *name;
 
-	name = ((struct syscall_metadata *)call->data)->name;
-	num = syscall_name_to_nr(name);
+	num = ((struct syscall_metadata *)call->data)->syscall_nr;
 	if (num < 0 || num >= NR_syscalls)
 		return;
 	mutex_lock(&syscall_trace_lock);
@@ -436,6 +428,10 @@ int __init init_ftrace_syscalls(void)
 	for (i = 0; i < NR_syscalls; i++) {
 		addr = arch_syscall_addr(i);
 		meta = find_syscall_meta(addr);
+		if (!meta)
+			continue;
+
+		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
 


