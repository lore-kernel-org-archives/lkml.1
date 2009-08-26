Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZHZFA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZHZFA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756629AbZHZFA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58585 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbZHZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:50 -0400
Message-Id: <20090826050051.799023110@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/8] tracing/filters: Support filtering for char patches prog prog2 quilt-mail x strings
Content-Disposition: inline; filename=0005-tracing-filters-Support-filtering-for-char-strings.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

Usually, char * entries are dangerous in traces because the string
can be released whereas a pointer to it can still wait to be read from
the ring buffer.

But sometimes we can assume it's safe, like in case of RO data
(eg: __file__ or __line__, used in bkl trace event). If these RO data
are in a module and so is the call to the trace event, then it's safe,
because the ring buffer will be flushed once this module get unloaded.

To allow char * to be treated as a string:

	TRACE_EVENT(...,

		TP_STRUCT__entry(
			__field_ext(const char *, name, FILTER_PTR_STRING)
			...
		)

		...
	);

The filtering will not dereference "char *" unless the developer
explicitly sets FILTER_PTR_STR in __field_ext.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
LKML-Reference: <4A7B9287.90205@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace_events_filter.c |   26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0440bea..ace2da9 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -144,6 +144,7 @@ enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
+	FILTER_PTR_STRING,
 };
 
 extern int trace_define_field(struct ftrace_event_call *call,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8a8e576..9f03082 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -163,6 +163,20 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 	return match;
 }
 
+/* Filter predicate for char * pointers */
+static int filter_pred_pchar(struct filter_pred *pred, void *event,
+			     int val1, int val2)
+{
+	char **addr = (char **)(event + pred->offset);
+	int cmp, match;
+
+	cmp = strncmp(*addr, pred->str_val, pred->str_len);
+
+	match = (!cmp) ^ pred->not;
+
+	return match;
+}
+
 /*
  * Filter predicate for dynamic sized arrays of characters.
  * These are implemented through a list of strings at the end
@@ -489,7 +503,8 @@ int filter_assign_type(const char *type)
 static bool is_string_field(struct ftrace_event_field *field)
 {
 	return field->filter_type == FILTER_DYN_STRING ||
-	       field->filter_type == FILTER_STATIC_STRING;
+	       field->filter_type == FILTER_STATIC_STRING ||
+	       field->filter_type == FILTER_PTR_STRING;
 }
 
 static int is_legal_op(struct ftrace_event_field *field, int op)
@@ -579,11 +594,16 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	}
 
 	if (is_string_field(field)) {
+		pred->str_len = field->size;
+
 		if (field->filter_type == FILTER_STATIC_STRING)
 			fn = filter_pred_string;
-		else
+		else if (field->filter_type == FILTER_DYN_STRING)
 			fn = filter_pred_strloc;
-		pred->str_len = field->size;
+		else {
+			fn = filter_pred_pchar;
+			pred->str_len = strlen(pred->str_val);
+		}
 	} else {
 		if (field->is_signed)
 			ret = strict_strtoll(pred->str_val, 0, &val);
-- 
1.6.3.3

-- 
