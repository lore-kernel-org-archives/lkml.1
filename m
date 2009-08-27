Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZH0Cco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZH0Cco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932132AbZH0Cck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:40 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:53185 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbZH0Cce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=IDKjY9HQQGgOWo7neu4gpjupxv2AxWP183R/spHpLV7ppTuVVTlipK6oyRYl6KYOi4
         OB7kkiT6dZ2YWTD75DvCzvGTf5/mSvo9+rfLYDVwyUTZOs7JIY0CosmfbGNqQoUtw61J
         OZPQI/Lqo5LgC8gWrvjPwA312Pjjcowl3u4Bs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/18] tracing: Ftrace dynamic ftrace_event_call support
Date: Thu, 27 Aug 2009 04:32:05 +0200
Message-Id: <1251340337-5640-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add dynamic ftrace_event_call support to ftrace. Trace engines can add
new ftrace_event_call to ftrace on the fly. Each operator function of
the call takes an ftrace_event_call data structure as an argument,
because these functions may be shared among several ftrace_event_calls.

Changes from v13:
 - Define remove_subsystem_dir() always (revirt a2ca5e03), because
   trace_remove_event_call() uses it.
 - Modify syscall tracer because of ftrace_event_call change.

[fweisbec@gmail.com: Fixed conflict against latest tracing/core]

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
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
LKML-Reference: <20090813203453.31965.71901.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/ftrace_event.h  |   19 ++++---
 include/linux/syscalls.h      |    4 +-
 include/trace/ftrace.h        |   16 +++---
 include/trace/syscall.h       |   11 +++--
 kernel/trace/trace_events.c   |  121 ++++++++++++++++++++++++++++-------------
 kernel/trace/trace_export.c   |   18 +++---
 kernel/trace/trace_syscalls.c |   20 ++++----
 7 files changed, 130 insertions(+), 79 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index ace2da9..1ab3089 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -112,12 +112,12 @@ struct ftrace_event_call {
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
+	int			(*raw_init)(struct ftrace_event_call *);
+	int			(*show_format)(struct ftrace_event_call *,
+					       struct trace_seq *);
 	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
@@ -147,11 +147,12 @@ enum {
 	FILTER_PTR_STRING,
 };
 
-extern int trace_define_field(struct ftrace_event_call *call,
-			      const char *type, const char *name,
-			      int offset, int size, int is_signed,
-			      int filter_type);
 extern int trace_define_common_fields(struct ftrace_event_call *call);
+extern int trace_define_field(struct ftrace_event_call *call, char *type,
+			      char *name, int offset, int size, int is_signed,
+			      int filter_type);
+extern int trace_add_event_call(struct ftrace_event_call *call);
+extern void trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index f124c89..646102e 100644
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
@@ -202,7 +202,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
 	struct trace_event exit_syscall_print_##sname = {		\
 		.trace                  = print_syscall_exit,		\
 	};								\
-	static int init_exit_##sname(void)				\
+	static int init_exit_##sname(struct ftrace_event_call *call)	\
 	{								\
 		int num, id;						\
 		num = syscall_name_to_nr("sys"#sname);			\
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 360a77a..f2bd7a8 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -434,7 +434,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
  * }
  *
- * static int ftrace_reg_event_<call>(void)
+ * static int ftrace_reg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int ret;
  *
@@ -445,7 +445,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	unregister_trace_<call>(ftrace_event_<call>);
  * }
@@ -478,7 +478,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
  * }
  *
- * static int ftrace_raw_reg_event_<call>(void)
+ * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int ret;
  *
@@ -489,7 +489,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *unused)
  * {
  *	unregister_trace_<call>(ftrace_raw_event_<call>);
  * }
@@ -498,7 +498,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *event_call)\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
- * static int ftrace_raw_init_event_<call>(void)
+ * static int ftrace_raw_init_event_<call>(struct ftrace_event_call *unused)
  * {
  *	int id;
  *
@@ -592,7 +592,7 @@ static void ftrace_raw_event_##call(proto)				\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 }									\
 									\
-static int ftrace_raw_reg_event_##call(void *ptr)			\
+static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 {									\
 	int ret;							\
 									\
@@ -603,7 +603,7 @@ static int ftrace_raw_reg_event_##call(void *ptr)			\
 	return ret;							\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(void *ptr)			\
+static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *unused)\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -612,7 +612,7 @@ static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
 };									\
 									\
-static int ftrace_raw_init_event_##call(void)				\
+static int ftrace_raw_init_event_##call(struct ftrace_event_call *unused)\
 {									\
 	int id;								\
 									\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 5dc283b..e290b86 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -39,16 +39,19 @@ void set_syscall_enter_id(int num, int id);
 void set_syscall_exit_id(int num, int id);
 extern struct trace_event event_syscall_enter;
 extern struct trace_event event_syscall_exit;
-extern int reg_event_syscall_enter(void *ptr);
-extern void unreg_event_syscall_enter(void *ptr);
-extern int reg_event_syscall_exit(void *ptr);
-extern void unreg_event_syscall_exit(void *ptr);
+
 extern int syscall_enter_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
 extern int syscall_exit_format(struct ftrace_event_call *call,
 				struct trace_seq *s);
 extern int syscall_enter_define_fields(struct ftrace_event_call *call);
 extern int syscall_exit_define_fields(struct ftrace_event_call *call);
+extern int reg_event_syscall_enter(struct ftrace_event_call *call);
+extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
+extern int reg_event_syscall_exit(struct ftrace_event_call *call);
+extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
+extern int
+ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index d33bcde..8079bb5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -27,8 +27,8 @@ DEFINE_MUTEX(event_mutex);
 
 LIST_HEAD(ftrace_events);
 
-int trace_define_field(struct ftrace_event_call *call, const char *type,
-		       const char *name, int offset, int size, int is_signed,
+int trace_define_field(struct ftrace_event_call *call, char *type,
+		       char *name, int offset, int size, int is_signed,
 		       int filter_type)
 {
 	struct ftrace_event_field *field;
@@ -92,9 +92,7 @@ int trace_define_common_fields(struct ftrace_event_call *call)
 }
 EXPORT_SYMBOL_GPL(trace_define_common_fields);
 
-#ifdef CONFIG_MODULES
-
-static void trace_destroy_fields(struct ftrace_event_call *call)
+void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
 
@@ -106,8 +104,6 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
-#endif /* CONFIG_MODULES */
-
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
@@ -116,14 +112,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
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
@@ -991,27 +987,43 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
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
@@ -1039,6 +1051,48 @@ static void remove_subsystem_dir(const char *name)
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
@@ -1096,7 +1150,7 @@ static void trace_module_add_events(struct module *mod)
 		if (!call->name)
 			continue;
 		if (call->raw_init) {
-			ret = call->raw_init();
+			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
@@ -1131,14 +1185,7 @@ static void trace_module_remove_events(struct module *mod)
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
 
@@ -1256,7 +1303,7 @@ static __init int event_trace_init(void)
 		if (!call->name)
 			continue;
 		if (call->raw_init) {
-			ret = call->raw_init();
+			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
 					pr_warning("Could not initialize trace "
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 029a91f..9cbe7f1 100644
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
 int ftrace_define_fields_##call(struct ftrace_event_call *event_call);	\
-static int ftrace_raw_init_event_##call(void);				\
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
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 85291c4..5931933 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -193,8 +193,8 @@ int syscall_enter_define_fields(struct ftrace_event_call *call)
 		return ret;
 
 	for (i = 0; i < meta->nb_args; i++) {
-		ret = trace_define_field(call, meta->types[i],
-					 meta->args[i], offset,
+		ret = trace_define_field(call, (char *)meta->types[i],
+					 (char *)meta->args[i], offset,
 					 sizeof(unsigned long), 0,
 					 FILTER_OTHER);
 		offset += sizeof(unsigned long);
@@ -277,13 +277,13 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 		trace_current_buffer_unlock_commit(event, 0, 0);
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
@@ -301,12 +301,12 @@ int reg_event_syscall_enter(void *ptr)
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
@@ -318,13 +318,13 @@ void unreg_event_syscall_enter(void *ptr)
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
@@ -342,12 +342,12 @@ int reg_event_syscall_exit(void *ptr)
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
1.6.2.3

