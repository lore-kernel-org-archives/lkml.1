Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbZLAQnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbZLAQnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZLAQnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:43:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:42286 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbZLAQni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:43:38 -0500
Date: Tue, 1 Dec 2009 16:43:03 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <4B14D288.7030001@cn.fujitsu.com>
References: <4B14D288.7030001@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] trace_syscalls: Remove enter_id exit_id
Message-ID: <tip-fcc19438dda38dacc8c144e2db3ebc6b9fd4f8b8@git.kernel.org>
Git-Commit-ID: fcc19438dda38dacc8c144e2db3ebc6b9fd4f8b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fcc19438dda38dacc8c144e2db3ebc6b9fd4f8b8
Gitweb:     http://git.kernel.org/tip/fcc19438dda38dacc8c144e2db3ebc6b9fd4f8b8
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 1 Dec 2009 16:23:36 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 1 Dec 2009 17:33:29 +0100

trace_syscalls: Remove enter_id exit_id

use ->enter_event->id instead of ->enter_id
use ->exit_event->id instead of ->exit_id

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B14D288.7030001@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/syscalls.h      |    2 --
 include/trace/syscall.h       |    6 ------
 kernel/trace/trace_syscalls.c |   30 ++++++++++--------------------
 3 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d3c9fd0..b9af875 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -168,7 +168,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		if (!id)						\
 			return -ENODEV;					\
 		event_enter_##sname.id = id;				\
-		set_syscall_enter_id(num, id);				\
 		INIT_LIST_HEAD(&event_enter_##sname.fields);		\
 		return 0;						\
 	}								\
@@ -205,7 +204,6 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 		if (!id)						\
 			return -ENODEV;					\
 		event_exit_##sname.id = id;				\
-		set_syscall_exit_id(num, id);				\
 		INIT_LIST_HEAD(&event_exit_##sname.fields);		\
 		return 0;						\
 	}								\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index c5265c8..ca09561 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -15,8 +15,6 @@
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
- * @enter_id: associated ftrace enter event id
- * @exit_id: associated ftrace exit event id
  * @enter_event: associated syscall_enter trace event
  * @exit_event: associated syscall_exit trace event
  */
@@ -25,8 +23,6 @@ struct syscall_metadata {
 	int		nb_args;
 	const char	**types;
 	const char	**args;
-	int		enter_id;
-	int		exit_id;
 
 	struct ftrace_event_call *enter_event;
 	struct ftrace_event_call *exit_event;
@@ -35,8 +31,6 @@ struct syscall_metadata {
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
 extern int syscall_name_to_nr(const char *name);
-void set_syscall_enter_id(int num, int id);
-void set_syscall_exit_id(int num, int id);
 
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 39649b1..27eb18d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -67,16 +67,6 @@ int syscall_name_to_nr(const char *name)
 	return -1;
 }
 
-void set_syscall_enter_id(int num, int id)
-{
-	syscalls_metadata[num]->enter_id = id;
-}
-
-void set_syscall_exit_id(int num, int id)
-{
-	syscalls_metadata[num]->exit_id = id;
-}
-
 enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags)
 {
@@ -93,7 +83,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 	if (!entry)
 		goto end;
 
-	if (entry->enter_id != ent->type) {
+	if (entry->enter_event->id != ent->type) {
 		WARN_ON_ONCE(1);
 		goto end;
 	}
@@ -148,7 +138,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 		return TRACE_TYPE_HANDLED;
 	}
 
-	if (entry->exit_id != ent->type) {
+	if (entry->exit_event->id != ent->type) {
 		WARN_ON_ONCE(1);
 		return TRACE_TYPE_UNHANDLED;
 	}
@@ -302,8 +292,8 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	event = trace_current_buffer_lock_reserve(&buffer, sys_data->enter_id,
-						  size, 0, 0);
+	event = trace_current_buffer_lock_reserve(&buffer,
+			sys_data->enter_event->id, size, 0, 0);
 	if (!event)
 		return;
 
@@ -334,8 +324,8 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	event = trace_current_buffer_lock_reserve(&buffer, sys_data->exit_id,
-				sizeof(*entry), 0, 0);
+	event = trace_current_buffer_lock_reserve(&buffer,
+			sys_data->exit_event->id, sizeof(*entry), 0, 0);
 	if (!event)
 		return;
 
@@ -510,11 +500,11 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 
 	rec = (struct syscall_trace_enter *) raw_data;
 	tracing_generic_entry_update(&rec->ent, 0, 0);
-	rec->ent.type = sys_data->enter_id;
+	rec->ent.type = sys_data->enter_event->id;
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-	perf_tp_event(sys_data->enter_id, 0, 1, rec, size);
+	perf_tp_event(sys_data->enter_event->id, 0, 1, rec, size);
 
 end:
 	perf_swevent_put_recursion_context(rctx);
@@ -615,11 +605,11 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	rec = (struct syscall_trace_exit *)raw_data;
 
 	tracing_generic_entry_update(&rec->ent, 0, 0);
-	rec->ent.type = sys_data->exit_id;
+	rec->ent.type = sys_data->exit_event->id;
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
 
-	perf_tp_event(sys_data->exit_id, 0, 1, rec, size);
+	perf_tp_event(sys_data->exit_event->id, 0, 1, rec, size);
 
 end:
 	perf_swevent_put_recursion_context(rctx);
