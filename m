Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374Ab0AMKWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0AMKWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363Ab0AMKWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:22:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:37822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab0AMKWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:22:16 -0500
Date: Wed, 13 Jan 2010 10:21:50 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B273D3E.2000704@cn.fujitsu.com>
References: <4B273D3E.2000704@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add print_fmt field
Message-ID: <tip-509e760cd91c831983097ae174cb6c0b8c6c8e6b@git.kernel.org>
Git-Commit-ID: 509e760cd91c831983097ae174cb6c0b8c6c8e6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  509e760cd91c831983097ae174cb6c0b8c6c8e6b
Gitweb:     http://git.kernel.org/tip/509e760cd91c831983097ae174cb6c0b8c6c8e6b
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:42 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 11:41:54 -0500

tracing: Add print_fmt field

This is part of a patch set that removes the show_format method
in the ftrace event macros.

The print_fmt field is added to hold the string that shows
the print_fmt in the event format files. This patch only adds
the field but it is currently not used. Later patches will use
this field to enable us to remove the show_format field
and function.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D3E.2000704@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    1 +
 include/trace/ftrace.h       |   28 +++++++++++++++++++++++++++-
 kernel/trace/trace_export.c  |    7 +++++++
 3 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2233c98..bd23d8e 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -121,6 +121,7 @@ struct ftrace_event_call {
 	int			(*regfunc)(struct ftrace_event_call *);
 	void			(*unregfunc)(struct ftrace_event_call *);
 	int			id;
+	const char		*print_fmt;
 	int			(*raw_init)(struct ftrace_event_call *);
 	int			(*show_format)(struct ftrace_event_call *,
 					       struct trace_seq *);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index c6fe03e..3351d85 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -722,8 +722,20 @@ static struct trace_event ftrace_event_type_##call = {			\
 
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
+#define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
+
 #undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)
+#define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
+static const char print_fmt_##call[] = print;
 
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
@@ -737,6 +749,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.print_fmt		= print_fmt_##template,			\
 	.show_format		= ftrace_format_##template,		\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
@@ -745,6 +758,8 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 									\
+static const char print_fmt_##call[] = print;				\
+									\
 static struct ftrace_event_call __used					\
 __attribute__((__aligned__(4)))						\
 __attribute__((section("_ftrace_events"))) event_##call = {		\
@@ -754,6 +769,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.raw_init		= trace_event_raw_init,			\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
+	.print_fmt		= print_fmt_##call,			\
 	.show_format		= ftrace_format_##call,			\
 	.define_fields		= ftrace_define_fields_##template,	\
 	_TRACE_PROFILE_INIT(call)					\
@@ -837,6 +853,16 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 
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
