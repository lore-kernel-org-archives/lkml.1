Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZHFGHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZHFGHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZHFGHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:07:35 -0400
Received: from [222.73.24.84] ([222.73.24.84]:57812 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbZHFGHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:07:33 -0400
Message-ID: <4A7A72CF.9070808@cn.fujitsu.com>
Date: Thu, 06 Aug 2009 14:06:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <f.weisbecker@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] tracing/filters: Add filter_type to struct ftrace_event_field
References: <4A7A72BD.5030201@cn.fujitsu.com>
In-Reply-To: <4A7A72BD.5030201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type of a field is stored as a string in @type, and here
we add @filter_type which is an enum value.

This prepares for later patches, so we can specifically assign
different @filter_type for the same @type.

For example normally a "char *" field is treated as a ptr,
but we may want it to be treated as a string when doing filting.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h               |    2 ++
 kernel/trace/trace_events.c        |    2 ++
 kernel/trace/trace_events_filter.c |   21 +++++++++++++--------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3a87d46..b168927 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -759,6 +759,7 @@ struct ftrace_event_field {
 	struct list_head	link;
 	char			*name;
 	char			*type;
+	int			filter_type;
 	int			offset;
 	int			size;
 	int			is_signed;
@@ -804,6 +805,7 @@ extern int apply_subsystem_event_filter(struct event_subsystem *system,
 					char *filter_string);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
+extern int filter_assign_type(const char *type);
 
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 90cdec5..71b2085 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -44,9 +44,11 @@ int trace_define_field(struct ftrace_event_call *call, char *type,
 	if (!field->type)
 		goto err;
 
+	field->filter_type = filter_assign_type(type);
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
+
 	list_add(&field->link, &call->fields);
 
 	return 0;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 27c2dbe..4c8c5fd 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -477,10 +477,11 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 
 enum {
 	FILTER_STATIC_STRING = 1,
-	FILTER_DYN_STRING
+	FILTER_DYN_STRING,
+	FILTER_OTHER,
 };
 
-static int is_string_field(const char *type)
+int filter_assign_type(const char *type)
 {
 	if (strstr(type, "__data_loc") && strstr(type, "char"))
 		return FILTER_DYN_STRING;
@@ -488,12 +489,18 @@ static int is_string_field(const char *type)
 	if (strchr(type, '[') && strstr(type, "char"))
 		return FILTER_STATIC_STRING;
 
-	return 0;
+	return FILTER_OTHER;
+}
+
+static bool is_string_field(struct ftrace_event_field *field)
+{
+	return field->filter_type == FILTER_DYN_STRING ||
+	       field->filter_type == FILTER_STATIC_STRING;
 }
 
 static int is_legal_op(struct ftrace_event_field *field, int op)
 {
-	if (is_string_field(field->type) && (op != OP_EQ && op != OP_NE))
+	if (is_string_field(field) && (op != OP_EQ && op != OP_NE))
 		return 0;
 
 	return 1;
@@ -550,7 +557,6 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	struct ftrace_event_field *field;
 	filter_pred_fn_t fn;
 	unsigned long long val;
-	int string_type;
 	int ret;
 
 	pred->fn = filter_pred_none;
@@ -578,9 +584,8 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		return -EINVAL;
 	}
 
-	string_type = is_string_field(field->type);
-	if (string_type) {
-		if (string_type == FILTER_STATIC_STRING)
+	if (is_string_field(field)) {
+		if (field->filter_type == FILTER_STATIC_STRING)
 			fn = filter_pred_string;
 		else
 			fn = filter_pred_strloc;
-- 
1.6.3

