Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZE2AAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZE2AAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 20:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZE2AAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 20:00:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54027 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZE2AAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 20:00:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v8 6/7] tracing: ftrace dynamic ftrace_event_call support
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 28 May 2009 20:03:51 -0400
Message-ID: <20090529000350.17532.18182.stgit@localhost.localdomain>
In-Reply-To: <20090529000326.17532.70868.stgit@localhost.localdomain>
References: <20090529000326.17532.70868.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dynamic ftrace_event_call support to ftrace. Trace engines can adds new
ftrace_event_call to ftrace on the fly. Each operator functions of the call
takes a ftrace_event_call data structure as an argument, because these
functions may be shared among several ftrace_event_calls.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 include/linux/ftrace_event.h |   13 ++++++----
 include/trace/ftrace.h       |   22 +++++++++--------
 kernel/trace/trace_events.c  |   54 +++++++++++++++++++++++++++++-------------
 kernel/trace/trace_export.c  |   27 ++++++++++-----------
 4 files changed, 69 insertions(+), 47 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index bbf40f6..e25f3a4 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -108,12 +108,13 @@ struct ftrace_event_call {
 	struct dentry		*dir;
 	struct trace_event	*event;
 	int			enabled;
-	int			(*regfunc)(void);
-	void			(*unregfunc)(void);
+	int			(*regfunc)(struct ftrace_event_call *);
+	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
-	int			(*raw_init)(void);
-	int			(*show_format)(struct trace_seq *s);
-	int			(*define_fields)(void);
+	int			(*raw_init)(struct ftrace_event_call *);
+	int			(*show_format)(struct ftrace_event_call *,
+					       struct trace_seq *);
+	int			(*define_fields)(struct ftrace_event_call *);
 	struct list_head	fields;
 	int			filter_active;
 	void			*filter;
@@ -138,6 +139,8 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
 			      char *name, int offset, int size, int is_signed);
+extern int trace_add_event_call(struct ftrace_event_call *call);
+extern void trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < 0)
 
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index b4ec83a..de3ee7c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -229,7 +229,8 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
 #undef TRACE_EVENT
 #define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *event_call,		\
+		     struct trace_seq *s)				\
 {									\
 	struct ftrace_raw_##call field __attribute__((unused));		\
 	int ret = 0;							\
@@ -269,10 +270,9 @@ ftrace_format_##call(struct trace_seq *s)				\
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
@@ -298,7 +298,7 @@ ftrace_define_fields_##call(void)					\
  *	event_trace_printk(_RET_IP_, "<call>: " <fmt>);
  * }
  *
- * static int ftrace_reg_event_<call>(void)
+ * static int ftrace_reg_event_<call>(struct ftrace_event_call *dummy)
  * {
  *	int ret;
  *
@@ -309,7 +309,7 @@ ftrace_define_fields_##call(void)					\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *dummy)
  * {
  *	unregister_trace_<call>(ftrace_event_<call>);
  * }
@@ -342,7 +342,7 @@ ftrace_define_fields_##call(void)					\
  *	trace_current_buffer_unlock_commit(event, irq_flags, pc);
  * }
  *
- * static int ftrace_raw_reg_event_<call>(void)
+ * static int ftrace_raw_reg_event_<call>(struct ftrace_event_call *dummy)
  * {
  *	int ret;
  *
@@ -353,7 +353,7 @@ ftrace_define_fields_##call(void)					\
  *	return ret;
  * }
  *
- * static void ftrace_unreg_event_<call>(void)
+ * static void ftrace_unreg_event_<call>(struct ftrace_event_call *dummy)
  * {
  *	unregister_trace_<call>(ftrace_raw_event_<call>);
  * }
@@ -362,7 +362,7 @@ ftrace_define_fields_##call(void)					\
  *	.trace			= ftrace_raw_output_<call>, <-- stage 2
  * };
  *
- * static int ftrace_raw_init_event_<call>(void)
+ * static int ftrace_raw_init_event_<call>(struct ftrace_event_call *dummy)
  * {
  *	int id;
  *
@@ -477,7 +477,7 @@ static void ftrace_raw_event_##call(proto)				\
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
 }									\
 									\
-static int ftrace_raw_reg_event_##call(void)				\
+static int ftrace_raw_reg_event_##call(struct ftrace_event_call *dummy)	\
 {									\
 	int ret;							\
 									\
@@ -488,7 +488,7 @@ static int ftrace_raw_reg_event_##call(void)				\
 	return ret;							\
 }									\
 									\
-static void ftrace_raw_unreg_event_##call(void)				\
+static void ftrace_raw_unreg_event_##call(struct ftrace_event_call *dummy)\
 {									\
 	unregister_trace_##call(ftrace_raw_event_##call);		\
 }									\
@@ -497,7 +497,7 @@ static struct trace_event ftrace_event_type_##call = {			\
 	.trace			= ftrace_raw_output_##call,		\
 };									\
 									\
-static int ftrace_raw_init_event_##call(void)				\
+static int ftrace_raw_init_event_##call(struct ftrace_event_call *dummy)\
 {									\
 	int id;								\
 									\
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6c81f9c..5d0a324 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -60,9 +60,7 @@ err:
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
-#ifdef CONFIG_MODULES
-
-static void trace_destroy_fields(struct ftrace_event_call *call)
+void trace_destroy_fields(struct ftrace_event_call *call)
 {
 	struct ftrace_event_field *field, *next;
 
@@ -74,8 +72,6 @@ static void trace_destroy_fields(struct ftrace_event_call *call)
 	}
 }
 
-#endif /* CONFIG_MODULES */
-
 static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 					int enable)
 {
@@ -84,14 +80,14 @@ static void ftrace_event_enable_disable(struct ftrace_event_call *call,
 		if (call->enabled) {
 			call->enabled = 0;
 			tracing_stop_cmdline_record();
-			call->unregfunc();
+			call->unregfunc(call);
 		}
 		break;
 	case 1:
 		if (!call->enabled) {
 			call->enabled = 1;
 			tracing_start_cmdline_record();
-			call->regfunc();
+			call->regfunc(call);
 		}
 		break;
 	}
@@ -558,7 +554,7 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 	trace_seq_printf(s, "format:\n");
 	trace_write_header(s);
 
-	r = call->show_format(s);
+	r = call->show_format(call, s);
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
@@ -905,7 +901,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		d_events = event_subsystem_dir(call->system, d_events);
 
 	if (call->raw_init) {
-		ret = call->raw_init();
+		ret = call->raw_init(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
@@ -929,7 +925,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 					  id);
 
 	if (call->define_fields) {
-		ret = call->define_fields();
+		ret = call->define_fields(call);
 		if (ret < 0) {
 			pr_warning("Could not initialize trace point"
 				   " events/%s\n", call->name);
@@ -949,6 +945,36 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 	return 0;
 }
 
+/* Add an additional event_call dynamically */
+int trace_add_event_call(struct ftrace_event_call *call)
+{
+	struct dentry *d_events;
+
+	if (!call->name)
+		return -EINVAL;
+
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
+/* Remove an event_call */
+void trace_remove_event_call(struct ftrace_event_call *event_call)
+{
+	ftrace_event_enable_disable(event_call, 0);
+	if (event_call->event)
+		unregister_ftrace_event(event_call->event);
+	debugfs_remove_recursive(event_call->dir);
+	list_del(&event_call->list);
+	trace_destroy_fields(event_call);
+	destroy_preds(event_call);
+}
+
 #define for_each_event(event, start, end)			\
 	for (event = start;					\
 	     (unsigned long)event < (unsigned long)end;		\
@@ -1053,13 +1079,7 @@ static void trace_module_remove_events(struct module *mod)
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
 			found = true;
-			ftrace_event_enable_disable(call, 0);
-			if (call->event)
-				unregister_ftrace_event(call->event);
-			debugfs_remove_recursive(call->dir);
-			list_del(&call->list);
-			trace_destroy_fields(call);
-			destroy_preds(call);
+			trace_remove_event_call(call);
 		}
 	}
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d06cf89..7cee79d 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -60,7 +60,7 @@ extern void __bad_type_size(void);
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *dummy, struct trace_seq *s)\
 {									\
 	struct args field;						\
 	int ret;							\
@@ -76,7 +76,7 @@ ftrace_format_##call(struct trace_seq *s)				\
 #define TRACE_EVENT_FORMAT_NOFILTER(call, proto, args, fmt, tstruct,	\
 				    tpfmt)				\
 static int								\
-ftrace_format_##call(struct trace_seq *s)				\
+ftrace_format_##call(struct ftrace_event_call *dummy, struct trace_seq *s)\
 {									\
 	struct args field;						\
 	int ret;							\
@@ -115,10 +115,16 @@ ftrace_format_##call(struct trace_seq *s)				\
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
@@ -126,16 +132,10 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
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
@@ -182,9 +182,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
