Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZCQGYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZCQGYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 02:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762777AbZCQGXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 02:23:38 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:52357 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762766AbZCQGXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 02:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uzjAj12nkrkSUr6mmq0OoKNEFiJ0gujDiQEjrrRY0NIKCrL1MzaJveVJfZXmkVf0UB
         8/9snMtu/v1ZFTt02RU5cAadC62vB0Vk5Gp2xn1+TsxB8sk2GguBozmUD7PGh2t8xlra
         EJr8CtTJgh8MMBxNdH+e+FiBbiCoe0tctF6XA=
Subject: [RFC][PATCH 1/4] tracing: add run-time field descriptions for
	event filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 01:23:32 -0500
Message-Id: <1237271012.8033.149.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the field descriptions defined for event tracing
available at run-time, for the event-filtering mechanism introduced in a
subsequent patch.

NOTE: Because of the way the common event fields are implemented (pid,
tgid, etc), there can be two fields of the same name for an event, as
shown in the output of the event format.  For now, to allow the user to
unambiguously specify one or the other, the common field names are
prepended with an underscore, although they don't show up that way in
the format output.  So for an event that defines its own pid field in
addition to the common pid field, to filter on the common field, a
filter on the common field would be specified as:

_pid != 0

while a filter on the event-specific pid field would be:

pid != 0

One way to fix this would be to make the common field names unique, or
make the field names in the format match the names used in the run-time
definition.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

---
 kernel/trace/trace.h                |   32 +++++++++++++++++-------
 kernel/trace/trace_events.c         |   37 ++++++++++++++++++++++++++++
 kernel/trace/trace_events_stage_2.h |   45 +++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events_stage_3.h |    2 +
 4 files changed, 106 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f561628..6981e28 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -776,18 +776,30 @@ enum {
 	TRACE_EVENT_TYPE_RAW		= 2,
 };
 
-struct ftrace_event_call {
-	char		*name;
-	char		*system;
-	struct dentry	*dir;
-	int		enabled;
-	int		(*regfunc)(void);
-	void		(*unregfunc)(void);
-	int		id;
-	int		(*raw_init)(void);
-	int		(*show_format)(struct trace_seq *s);
+struct ftrace_event_field {
+	struct list_head	link;
+	char			*name;
+	char			*type;
+	int			offset;
+	int			size;
 };
 
+struct ftrace_event_call {
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
+};
+
+int trace_define_field(struct ftrace_event_call *call, char *type,
+		       char *name, int offset, int size);
 void event_trace_printk(unsigned long ip, const char *fmt, ...);
 extern struct ftrace_event_call __start_ftrace_events[];
 extern struct ftrace_event_call __stop_ftrace_events[];
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c88227b..8b74570 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -24,6 +24,34 @@ static DEFINE_MUTEX(event_mutex);
 	     (unsigned long)event < (unsigned long)__stop_ftrace_events; \
 	     event++)
 
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
@@ -550,6 +578,15 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
 				   "'%s/enable' entry\n", call->name);
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
index 5117c43..3e4f7a9 100644
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
+	ret = trace_define_field(event_call, #type, "_" #item,		\
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
index ae2e323..30627d8 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -202,6 +202,7 @@ static int ftrace_raw_init_event_##call(void)				\
 	if (!id)							\
 		return -ENODEV;						\
 	event_##call.id = id;						\
+	INIT_LIST_HEAD(&event_##call.fields);				\
 	return 0;							\
 }									\
 									\
@@ -214,4 +215,5 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
 	.regfunc		= ftrace_raw_reg_event_##call,		\
 	.unregfunc		= ftrace_raw_unreg_event_##call,	\
 	.show_format		= ftrace_format_##call,			\
+	.define_fields		= ftrace_define_fields_##call,		\
 }
-- 
1.5.6.3






