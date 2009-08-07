Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbZHGCfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbZHGCfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 22:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZHGCfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 22:35:12 -0400
Received: from [222.73.24.84] ([222.73.24.84]:57709 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbZHGCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 22:35:09 -0400
Message-ID: <4A7B9287.90205@cn.fujitsu.com>
Date: Fri, 07 Aug 2009 10:33:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2 3/3] tracing/filters: Support filtering for char * strings
References: <4A7B9242.7010204@cn.fujitsu.com>
In-Reply-To: <4A7B9242.7010204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |    1 +
 kernel/trace/trace_events_filter.c |   26 +++++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f034e8f..fd5f329 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -140,6 +140,7 @@ enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
 	FILTER_DYN_STRING,
+	FILTER_PTR_STRING,
 };
 
 extern int trace_define_field(struct ftrace_event_call *call, char *type,
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 5e7f031..b16923e 100644
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
1.6.3

