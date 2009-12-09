Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbZLIHQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbZLIHQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965003AbZLIHQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:16:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52776 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935906AbZLIHQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:16:24 -0500
Message-ID: <4B1F4EA1.4080400@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/10] tracing: add print_fmt field
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add print_fmt field and the initialization codes.
It will be used for replacing ->show_format().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f883406..58db567 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -120,6 +120,7 @@ struct ftrace_event_call {
 	int			(*regfunc)(struct ftrace_event_call *);
 	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
+	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
 	int			(*show_format)(struct ftrace_event_call *,
 					       struct trace_seq *);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 54258a0..eb63c97 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -723,8 +723,20 @@ static struct trace_event ftrace_event_type_##call = {			\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
+#undef __entry
+#define __entry REC
+
+#undef __print_flags
+#undef __print_symbolic
+#undef __get_dynamic_array
+#undef __get_str
+
+#undef TP_printk
+#define TP_printk(fmt, args...) #fmt ", "  __stringify(args)
+
 #undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+static const char print_fmt_##call[] = print;
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -738,6 +750,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.print_fmt		= print_fmt_##template,			\
 	.show_format		= ftrace_format_##template,		\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
@@ -746,6 +759,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 									\
+static const char print_fmt_##call[] = print;				\
+									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
@@ -755,6 +770,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.print_fmt		= print_fmt_##call,			\
 	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
@@ -838,6 +854,16 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
 #ifdef CONFIG_EVENT_PROFILE
 
+#undef __entry
+#define __entry entry
+
+#undef __get_dynamic_array
+#define __get_dynamic_array(field)	\
+		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
+
+#undef __get_str
+#define __get_str(field) (char *)__get_dynamic_array(field)
+
 #undef __perf_addr
 #define __perf_addr(a) __addr = (a)
 
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 9978a4f..95d14b6 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -203,6 +203,9 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 	return 0;
 }
 
+#undef __entry
+#define __entry REC
+
 #undef __field
 #define __field(type, item)
 
@@ -218,6 +221,9 @@ static int ftrace_raw_init_event(struct ftrace_event_call *call)
 #undef __dynamic_array
 #define __dynamic_array(type, item)
 
+#undef F_printk
+#define F_printk(fmt, args...) #fmt ", "  __stringify(args)
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, type, tstruct, print)		\
 									\
@@ -228,6 +234,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.id			= type,					\
 	.system			= __stringify(TRACE_SYSTEM),		\
 	.raw_init		= ftrace_raw_init_event,		\
+	.print_fmt		= print,				\
 	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##call,		\
 };									\


