Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZCVTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZCVTk3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZCVTkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:40:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:40799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZCVTkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:40:14 -0400
Date: Sun, 22 Mar 2009 19:39:38 GMT
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, tzanussi@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1237710639.7703.46.camel@charm-linux>
References: <1237710639.7703.46.camel@charm-linux>
Subject: [tip:tracing/filters] tracing: add run-time field descriptions for event filtering
Message-ID: <tip-cf027f645e6aee4f0ca6197a6b6a57f327fdb13f@git.kernel.org>
Git-Commit-ID: cf027f645e6aee4f0ca6197a6b6a57f327fdb13f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 22 Mar 2009 19:39:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf027f645e6aee4f0ca6197a6b6a57f327fdb13f
Gitweb:     http://git.kernel.org/tip/cf027f645e6aee4f0ca6197a6b6a57f327fdb13f
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Sun, 22 Mar 2009 03:30:39 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 Mar 2009 18:11:22 +0100

tracing: add run-time field descriptions for event filtering

This patch makes the field descriptions defined for event tracing
available at run-time, for the event-filtering mechanism introduced
in a subsequent patch.

The common event fields are prepended with 'common_' in the format
display, allowing them to be distinguished from the other fields
that might internally have same name and can therefore be
unambiguously used in filters.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1237710639.7703.46.camel@charm-linux>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace.h                |   30 ++++++++++++++++-------
 kernel/trace/trace_events.c         |   40 ++++++++++++++++++++++++++++++-
 kernel/trace/trace_events_stage_2.h |   45 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events_stage_3.h |    2 +
 4 files changed, 107 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 7cfb741..9288dc7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -775,16 +775,26 @@ enum {
 	TRACE_EVENT_TYPE_RAW		= 2,
 };
 
+struct ftrace_event_field {
+	struct list_head	link;
+	char			*name;
+	char			*type;
+	int			offset;
+	int			size;
+};
+
 struct ftrace_event_call {
-	char		*name;
-	char		*system;
-	struct dentry	*dir;
-	int		enabled;
-	int		(*regfunc)(void);
-	void		(*unregfunc)(void);
-	int		id;
-	int		(*raw_init)(void);
-	int		(*show_format)(struct trace_seq *s);
+	char			*name;
+	char			*system;
+	struct dentry		*dir;
+	int			enabled;
+	int			(*regfunc)(void);
+	void			(*unregfunc)(void);
+	int			id;
+	int			(*raw_init)(void);
+	int			(*show_format)(struct trace_seq *s);
+	int			(*define_fields)(void);
+	struct list_head	fields;
 
 #ifdef CONFIG_EVENT_PROFILE
 	atomic_t	profile_count;
@@ -793,6 +803,8 @@ struct ftrace_event_call {
 #endif
 };
 
+int trace_define_field(struct ftrace_event_call *call, char *type,
+		       char *name, int offset, int size);
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3047b56..961b057 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -19,6 +19,34 @@
 
 static DEFINE_MUTEX(event_mutex);
 
+int trace_define_field(struct ftrace_event_call *call, char *type,
+		       char *name, int offset, int size)
+{
+	struct ftrace_event_field *field;
+
+	field = kmalloc(sizeof(*field), GFP_KERNEL);
+	if (!field)
+		goto err;
+	field->name = kstrdup(name, GFP_KERNEL);
+	if (!field->name)
+		goto err;
+	field->type = kstrdup(type, GFP_KERNEL);
+	if (!field->type)
+		goto err;
+	field->offset = offset;
+	field->size = size;
+	list_add(&field->link, &call->fields);
+
+	return 0;
+err:
+	if (field) {
+		kfree(field->name);
+		kfree(field->type);
+	}
+	kfree(field);
+	return -ENOMEM;
+}
+
 static void ftrace_clear_events(void)
 {
 	struct ftrace_event_call *call = (void *)__start_ftrace_events;
@@ -343,7 +371,8 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 
 #undef FIELD
 #define FIELD(type, name)						\
-	#type, #name, offsetof(typeof(field), name), sizeof(field.name)
+	#type, "common_" #name, offsetof(typeof(field), name),		\
+		sizeof(field.name)
 
 static int trace_write_header(struct trace_seq *s)
 {
@@ -581,6 +610,15 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 					call->name);
 	}
 
+	if (call->define_fields) {
+		ret = call->define_fields();
+		if (ret < 0) {
+			pr_warning("Could not initialize trace point"
+				   " events/%s\n", call->name);
+			return ret;
+		}
+	}
+
 	/* A trace may not want to export its format */
 	if (!call->show_format)
 		return 0;
diff --git a/kernel/trace/trace_events_stage_2.h b/kernel/trace/trace_events_stage_2.h
index 5117c43..30743f7 100644
--- a/kernel/trace/trace_events_stage_2.h
+++ b/kernel/trace/trace_events_stage_2.h
@@ -129,3 +129,48 @@ ftrace_format_##call(struct trace_seq *s)				\
 }
 
 #include <trace/trace_event_types.h>
+
+#undef __field
+#define __field(type, item)						\
+	ret = trace_define_field(event_call, #type, #item,		\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#undef __array
+#define __array(type, item, len)					\
+	ret = trace_define_field(event_call, #type "[" #len "]", #item,	\
+				 offsetof(typeof(field), item),		\
+				 sizeof(field.item));			\
+	if (ret)							\
+		return ret;
+
+#define __common_field(type, item)					\
+	ret = trace_define_field(event_call, #type, "common_" #item,	\
+				 offsetof(typeof(field.ent), item),	\
+				 sizeof(field.ent.item));		\
+	if (ret)							\
+		return ret;
+
+#undef TRACE_EVENT
+#define TRACE_EVENT(call, proto, args, tstruct, func, print)		\
+int									\
+ftrace_define_fields_##call(void)					\
+{									\
+	struct ftrace_raw_##call field;					\
+	struct ftrace_event_call *event_call = &event_##call;		\
+	int ret;							\
+									\
+	__common_field(unsigned char, type);				\
+	__common_field(unsigned char, flags);				\
+	__common_field(unsigned char, preempt_count);			\
+	__common_field(int, pid);					\
+	__common_field(int, tgid);					\
+									\
+	tstruct;							\
+									\
+	return ret;							\
+}
+
+#include <trace/trace_event_types.h>
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index 6b3261c..468938f 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -252,6 +252,7 @@ static int ftrace_raw_init_event_##call(void)				\
 	if (!id)							\
 		return -ENODEV;						\
 	event_##call.id = id;						\
+	INIT_LIST_HEAD(&event_##call.fields);				\
 	return 0;							\
 }									\
 									\
@@ -264,6 +265,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
 	_TRACE_PROFILE_INIT(call)					\
 }
 
