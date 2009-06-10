Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZFJFoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZFJFoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbZFJFm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42351 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZFJFmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:52 -0400
Message-Id: <20090610054254.213236598@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 07/11] tracing: add test for strings in event tag format
Content-Disposition: inline; filename=0007-tracing-add-test-for-strings-in-event-tag-format.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

To protect against any disaster if a format uses a string when it
should have used something else, this code puts in test to make sure
the output will not cause any harm.

The entry size is passed to the format parser and checks are made
to ensure that the string read into the trace_seq at least has an
ending '\0' character within the range of the entry record.

[ Impact: prevent unpredictable results with bad formats ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h     |    3 +-
 include/trace/ftrace.h           |    2 +-
 kernel/trace/trace_read_binary.c |   43 +++++++++++++++++++++++++++++++++----
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 1802459..26fed99 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -142,7 +142,8 @@ extern int filter_current_check_discard(struct ftrace_event_call *call,
 
 extern char *ftrace_read_binary(struct trace_seq *p,
 				struct ftrace_event_call *event,
-				struct trace_entry *entry);
+				struct trace_entry *entry,
+				int entry_size);
 extern int ftrace_initialize_print(struct ftrace_event_call *event,
 				   const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e3370c5..d250cb9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -126,7 +126,7 @@
 
 #undef TP_FORMAT
 #define TP_FORMAT(fmt, args...) \
-	"%s\n", ftrace_read_binary(p, event_call, entry)
+	"%s\n", ftrace_read_binary(p, event_call, entry, iter->ent_size)
 
 #undef __get_dynamic_array
 #define __get_dynamic_array(field)	\
diff --git a/kernel/trace/trace_read_binary.c b/kernel/trace/trace_read_binary.c
index d005138..f3fdac8 100644
--- a/kernel/trace/trace_read_binary.c
+++ b/kernel/trace/trace_read_binary.c
@@ -738,9 +738,22 @@ get_val(void *p, int size, unsigned long long *mask)
 	return val;
 }
 
+/* make sure string pointer has an end */
+static int test_string(const char *str, int size)
+{
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (!str[i])
+			return 0;
+	}
+
+	return -1;
+}
+
 char *
 ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
-		   struct trace_entry *entry)
+		   struct trace_entry *entry, int entry_size)
 {
 	unsigned long long val, mask;
 	struct print_info *info;
@@ -748,6 +761,7 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 	struct ftrace_event_field *field;
 	unsigned long divisor, rem;
 	void *p;
+	int len;
 
 	if (!event->print_text) {
 		trace_seq_puts(s, "UNDEFINED EVENT\n");
@@ -834,18 +848,37 @@ ftrace_read_binary(struct trace_seq *s, struct ftrace_event_call *event,
 			break;
 
 		case FIELD_IS_STRING:
-			p += info->data.field->offset;
+			field = info->data.field;
+			p += field->offset;
 			/* indexes are expected to be unsigned short */
-			if (info->data.field->size != 2) {
-				trace_seq_puts(s, "BAD FIELD SIZE\n");
+			if (field->size != 2) {
+				trace_seq_printf(s, "BAD FIELD SIZE %d\n",
+						 field->size);
 				return start;
 			}
+			if (*(unsigned short *)p > entry_size) {
+				trace_seq_puts(s, "BAD STRING POINTER\n");
+				return start;
+			}
+			len = entry_size - *(unsigned short *)p;
 			p = (void *)entry + *(unsigned short *)p;
+
+			/* make sure that the string has an end */
+			if (test_string(p, len)) {
+				trace_seq_puts(s, "BAD STRING CONTENT\n");
+				return start;
+			}
+
 			trace_seq_puts(s, p);
 			break;
 
 		case FIELD_IS_STRARRAY:
-			p += info->data.field->offset;
+			field = info->data.field;
+			p += field->offset;
+			if (test_string(p, field->size)) {
+				trace_seq_puts(s, "BAD STRING CONTENT\n");
+				return start;
+			}
 			trace_seq_puts(s, p);
 			break;
 
-- 
1.6.3.1

-- 
