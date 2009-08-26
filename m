Return-Path: <linux-kernel-owner+w=401wt.eu-S1757119AbZHZHXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119AbZHZHXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZHZHXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:23:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:46808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757061AbZHZHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:23:28 -0400
Date: Wed, 26 Aug 2009 07:23:04 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4A7B925E.9030605@cn.fujitsu.com>
References: <4A7B925E.9030605@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/filters: Add filter_type to struct ftrace_event_field
Message-ID: <tip-aa38e9fc3ea804290efd3a39316d7f7e6c945800@git.kernel.org>
Git-Commit-ID: aa38e9fc3ea804290efd3a39316d7f7e6c945800
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 07:23:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aa38e9fc3ea804290efd3a39316d7f7e6c945800
Gitweb:     http://git.kernel.org/tip/aa38e9fc3ea804290efd3a39316d7f7e6c945800
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 7 Aug 2009 10:33:02 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 26 Aug 2009 00:32:06 -0400

tracing/filters: Add filter_type to struct ftrace_event_field

The type of a field is stored as a string in @type, and here
we add @filter_type which is an enum value.

This prepares for later patches, so we can specifically assign
different @filter_type for the same @type.

For example normally a "char *" field is treated as a ptr,
but we may want it to be treated as a string when doing filting.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A7B925E.9030605@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 kernel/trace/trace.h               |    2 ++
 kernel/trace/trace_events.c        |    2 ++
 kernel/trace/trace_events_filter.c |   23 ++++++++++++++---------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 300ef78..64dda57 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -755,6 +755,7 @@ struct ftrace_event_field {
 	struct list_head	link;
 	char			*name;
 	char			*type;
+	int			filter_type;
 	int			offset;
 	int			size;
 	int			is_signed;
@@ -800,6 +801,7 @@ extern int apply_subsystem_event_filter(struct event_subsystem *system,
 					char *filter_string);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
 					 struct trace_seq *s);
+extern int filter_assign_type(const char *type);
 
 static inline int
 filter_check_discard(struct ftrace_event_call *call, void *rec,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 79d3520..5740e90 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -44,9 +44,11 @@ int trace_define_field(struct ftrace_event_call *call, const char *type,
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
index 490337a..22e6d82 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -476,11 +476,12 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 }
 
 enum {
-	FILTER_STATIC_STRING = 1,
-	FILTER_DYN_STRING
+	FILTER_OTHER = 0,
+	FILTER_STATIC_STRING,
+	FILTER_DYN_STRING,
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
