Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbZLAIYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbZLAIYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZLAIYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:24:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZLAIYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:24:11 -0500
Message-ID: <4B14D288.7030001@cn.fujitsu.com>
Date: Tue, 01 Dec 2009 16:23:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] trace_syscalls: remove enter_id exit_id
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use ->enter_event->id instead of ->enter_id
use ->exit_event->id instead of ->exit_id

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
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


