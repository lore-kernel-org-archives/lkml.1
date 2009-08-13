Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbZHMUdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbZHMUdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756209AbZHMUdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:33:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58665 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756207AbZHMUdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:33:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v14 06/12] tracing: ftrace dynamic ftrace_event_call
	support
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 13 Aug 2009 16:34:53 -0400
Message-ID: <20090813203453.31965.71901.stgit@localhost.localdomain>
In-Reply-To: <20090813203403.31965.20973.stgit@localhost.localdomain>
References: <20090813203403.31965.20973.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dynamic ftrace_event_call support to ftrace. Trace engines can adds new
ftrace_event_call to ftrace on the fly. Each operator functions of the call
takes a ftrace_event_call data structure as an argument, because these
functions may be shared among several ftrace_event_calls.

Changes from v13:
 - Define remove_subsystem_dir() always (revirt a2ca5e03), because
   trace_remove_event_call() uses it.
 - Modify syscall tracer because of ftrace_event_call change.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 include/linux/ftrace_event.h  |   14 +++--
 include/linux/syscalls.h      |    4 +
 include/trace/ftrace.h        |   19 +++----
 include/trace/syscall.h       |    8 +--
 kernel/trace/trace_events.c   |  119 +++++++++++++++++++++++++++++------------
 kernel/trace/trace_export.c   |   23 ++++----
 kernel/trace/trace_syscalls.c |   16 +++---
 7 files changed, 125 insertions(+), 78 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 189806b..9af68ce 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -112,13 +112,13 @@ struct ftrace_event_call {
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
-	int			(*regfunc)(void *);
-	void			(*unregfunc)(void *);
+	int			(*regfunc)(struct ftrace_event_call *);
+	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
-	int			(*raw_init)(void);
-	int			(*show_format)(struct ftrace_event_call *call,
-					       struct trace_seq *s);
-	int			(*define_fields)(void);
+	int			(*raw_init)(struct ftrace_event_call *);
+	int			(*show_format)(struct ftrace_event_call *,
+					       struct trace_seq *);
+	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
 	struct event_filter	*filter;
@@ -142,6 +142,8 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
 			      char *name, int offset, int size, int is_signed);
+extern int trace_add_event_call(struct ftrace_event_call *call);
+extern void trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 87d06c1..be59d22 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -165,7 +165,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 	struct trace_event enter_syscall_print_##sname = {		\
 		.trace                  = print_syscall_enter,		\
 	};								\
-	static int init_enter_##sname(void)				\
+	static int init_enter_##sname(struct ftrace_event_call *call)	\
 	{								\
 		int num, id;						\
 		num = syscall_name_to_nr("sys"#sname);			\
@@ -201,7 +201,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 	struct trace_event exit_syscall_print_##sname = {		\
 		.trace                  = print_syscall_exit,		\
 	};								\
-	static int init_exit_##sname(void)				\
+	static int init_exit_##sname(struct ftrace_event_call *call)	\
 	{								\
 		int num, id;						\
 		num = syscall_name_to_nr("sys"#sname);			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b250b06..6c1b5b1 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -294,10 +294,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
 	struct ftrace_raw_##call field;					\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	int ret;							\
 									\
 	__common_field(int, type, 1);					\
@@ -411,7 +410,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
  * }
  *
- * static int ftrace_reg_event_<call>(void)
+ * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int ret;
  *
@@ -422,7 +421,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	unregister_trace_<call>(ftrace_event_<call>);
  * }
@@ -455,7 +454,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
  * }
  *
- * static int ftrace_raw_reg_event_<call>(void)
+ * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int ret;
  *
@@ -466,7 +465,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	unregister_trace_<call>(ftrace_raw_event_<call>);
  * }
@@ -475,7 +474,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
- * static int ftrace_raw_init_event_<call>(void)
+ * static int ftrace_raw_init_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int id;
  *
@@ -569,7 +568,7 @@ static void ftrace_raw_event_##call(proto)				\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 }									\
 									\
-static int ftrace_raw_reg_event_##call(void *ptr)			\
+static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 {									\
 	int ret;							\
 									\
@@ -580,7 +579,7 @@ static int ftrace_raw_reg_event_##call(void *ptr)			\
 	return ret;							\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(void *ptr)			\
+static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -589,7 +588,7 @@ static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
 };									\
 									\
-static int ftrace_raw_init_event_##call(void)				\
+static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
 {									\
 	int id;								\
 									\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 0cb0362..848b4ae 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -51,10 +51,10 @@ void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
 extern struct trace_event event_syscall_enter;
 extern struct trace_event event_syscall_exit;
-extern int reg_event_syscall_enter(void *ptr);
-extern void unreg_event_syscall_enter(void *ptr);
-extern int reg_event_syscall_exit(void *ptr);
-extern void unreg_event_syscall_exit(void *ptr);
+extern int reg_event_syscall_enter(struct ftrace_event_call *call);
+extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
+extern int reg_event_syscall_exit(struct ftrace_event_call *call);
+extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
 extern int
 ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index b568ade..be701d1 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -62,9 +62,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
-#ifdef CONFIG_MODULES
-
-static void trace_destroy_fields(struct ftrace_event_call *call)
+void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
 
@@ -76,8 +74,6 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
-#endif /* CONFIG_MODULES */
-
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
@@ -86,14 +82,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->enabled) {
 			call->enabled = 0;
 			tracing_stop_cmdline_record();
-			call->unregfunc(call->data);
+			call->unregfunc(call);
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc(call->data);
+			call->regfunc(call);
 		}
 		break;
 	}
@@ -941,7 +937,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 					  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields();
+		ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
@@ -961,27 +957,43 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
-#define for_each_event(event, start, end)			\
-	for (event = start;					\
-	     (unsigned long)event < (unsigned long)end;		\
-	     event++)
+static int __trace_add_event_call(struct ftrace_event_call *call)
+{
+	struct dentry *d_events;
+	int ret;
 
-#ifdef CONFIG_MODULES
+	if (!call->name)
+		return -EINVAL;
 
-static LIST_HEAD(ftrace_module_file_list);
+	if (call->raw_init) {
+		ret = call->raw_init(call);
+		if (ret < 0) {
+			if (ret != -ENOSYS)
+				pr_warning("Could not initialize trace "
+				"events/%s\n", call->name);
+			return ret;
+		}
+	}
 
-/*
- * Modules must own their file_operations to keep up with
- * reference counting.
- */
-struct ftrace_module_file_ops {
-	struct list_head		list;
-	struct module			*mod;
-	struct file_operations		id;
-	struct file_operations		enable;
-	struct file_operations		format;
-	struct file_operations		filter;
-};
+	d_events = event_trace_events_dir();
+	if (!d_events)
+		return -ENOENT;
+
+	list_add(&call->list, &ftrace_events);
+	return event_create_dir(call, d_events, &ftrace_event_id_fops,
+				&ftrace_enable_fops, &ftrace_event_filter_fops,
+				&ftrace_event_format_fops);
+}
+
+/* Add an additional event_call dynamically */
+int trace_add_event_call(struct ftrace_event_call *call)
+{
+	int ret;
+	mutex_lock(&event_mutex);
+	ret = __trace_add_event_call(call);
+	mutex_unlock(&event_mutex);
+	return ret;
+}
 
 static void remove_subsystem_dir(const char *name)
 {
@@ -1009,6 +1021,48 @@ static void remove_subsystem_dir(const char *name)
 	}
 }
 
+static void __trace_remove_event_call(struct ftrace_event_call *call)
+{
+	ftrace_event_enable_disable(call, 0);
+	if (call->event)
+		__unregister_ftrace_event(call->event);
+	debugfs_remove_recursive(call->dir);
+	list_del(&call->list);
+	trace_destroy_fields(call);
+	destroy_preds(call);
+	remove_subsystem_dir(call->system);
+}
+
+/* Remove an event_call */
+void trace_remove_event_call(struct ftrace_event_call *call)
+{
+	mutex_lock(&event_mutex);
+	__trace_remove_event_call(call);
+	mutex_unlock(&event_mutex);
+}
+
+#define for_each_event(event, start, end)			\
+	for (event = start;					\
+	     (unsigned long)event < (unsigned long)end;		\
+	     event++)
+
+#ifdef CONFIG_MODULES
+
+static LIST_HEAD(ftrace_module_file_list);
+
+/*
+ * Modules must own their file_operations to keep up with
+ * reference counting.
+ */
+struct ftrace_module_file_ops {
+	struct list_head		list;
+	struct module			*mod;
+	struct file_operations		id;
+	struct file_operations		enable;
+	struct file_operations		format;
+	struct file_operations		filter;
+};
+
 static struct ftrace_module_file_ops *
 trace_create_file_ops(struct module *mod)
 {
@@ -1066,7 +1120,7 @@ static void trace_module_add_events(struct module *mod)
 		if (!call->name)
 			continue;
 		if (call->raw_init) {
-			ret = call->raw_init();
+			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
@@ -1101,14 +1155,7 @@ static void trace_module_remove_events(struct module *mod)
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
 			found = true;
-			ftrace_event_enable_disable(call, 0);
-			if (call->event)
-				__unregister_ftrace_event(call->event);
-			debugfs_remove_recursive(call->dir);
-			list_del(&call->list);
-			trace_destroy_fields(call);
-			destroy_preds(call);
-			remove_subsystem_dir(call->system);
+			__trace_remove_event_call(call);
 		}
 	}
 
@@ -1226,7 +1273,7 @@ static __init int event_trace_init(void)
 		if (!call->name)
 			continue;
 		if (call->raw_init) {
-			ret = call->raw_init();
+			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 956d4bc..71c8d7f 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -117,10 +117,16 @@ ftrace_format_##call(struct ftrace_event_call *unused,			\
 #define TRACE_FIELD_SPECIAL(type_item, item, len, cmd)	\
 	cmd;
 
+static int ftrace_raw_init_event(struct ftrace_event_call *event_call)
+{
+	INIT_LIST_HEAD(&event_call->fields);
+	init_preds(event_call);
+	return 0;
+}
+
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
-int ftrace_define_fields_##call(void);					\
-static int ftrace_raw_init_event_##call(void);				\
+int ftrace_define_fields_##call(struct ftrace_event_call *c);		\
 									\
 struct ftrace_event_call __used						\
 __attribute__((__aligned__(4)))						\
@@ -128,16 +134,10 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.name			= #call,				\
 	.id			= proto,				\
 	.system			= __stringify(TRACE_SYSTEM),		\
-	.raw_init		= ftrace_raw_init_event_##call,		\
+	.raw_init		= ftrace_raw_init_event,		\
 	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##call,		\
-};									\
-static int ftrace_raw_init_event_##call(void)				\
-{									\
-	INIT_LIST_HEAD(&event_##call.fields);				\
-	init_preds(&event_##call);					\
-	return 0;							\
-}									\
+};
 
 #undef TRACE_EVENT_FORMAT_NOFILTER
 #define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
@@ -184,9 +184,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 int									\
-ftrace_define_fields_##call(void)					\
+ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 {									\
-	struct ftrace_event_call *event_call = &event_##call;		\
 	struct args field;						\
 	int ret;							\
 									\
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f837ccc..3451621 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -210,13 +210,13 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	trace_wake_up();
 }
 
-int reg_event_syscall_enter(void *ptr)
+int reg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
 	char *name;
 
-	name = (char *)ptr;
+	name = (char *)call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return -ENOSYS;
@@ -234,12 +234,12 @@ int reg_event_syscall_enter(void *ptr)
 	return ret;
 }
 
-void unreg_event_syscall_enter(void *ptr)
+void unreg_event_syscall_enter(struct ftrace_event_call *call)
 {
 	int num;
 	char *name;
 
-	name = (char *)ptr;
+	name = (char *)call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return;
@@ -251,13 +251,13 @@ void unreg_event_syscall_enter(void *ptr)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-int reg_event_syscall_exit(void *ptr)
+int reg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int ret = 0;
 	int num;
 	char *name;
 
-	name = (char *)ptr;
+	name = (char *)call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return -ENOSYS;
@@ -275,12 +275,12 @@ int reg_event_syscall_exit(void *ptr)
 	return ret;
 }
 
-void unreg_event_syscall_exit(void *ptr)
+void unreg_event_syscall_exit(struct ftrace_event_call *call)
 {
 	int num;
 	char *name;
 
-	name = (char *)ptr;
+	name = (char *)call->data;
 	num = syscall_name_to_nr(name);
 	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
 		return;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
