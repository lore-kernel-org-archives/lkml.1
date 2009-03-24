Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZCXHOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZCXHOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 03:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZCXHOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 03:14:37 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:41951 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298AbZCXHOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 03:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rO+jPYYM8aW/fyk6RYUzllbP3hw+JFxXRM9lVhXS4WHe7xrkZ9cstFqbxeAEzwSXYB
         WrYw1L18AaJIsq677MZprFatHeuHa0PE6Tn3K9ppglz5OkI8+Vfu4Y23RADlahtPbNcx
         QeMpCXnZRlNeNt47+UlNBN/bd7MSntXpXkaH4=
Subject: [PATCH] tracing/filters: use trace_seq_printf() to print filters
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 02:14:31 -0500
Message-Id: <1237878871.8339.59.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just using the trace_seq buffer to print the filters, use
trace_seq_printf() as it was intended to be used.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>

---
 kernel/trace/trace.h               |    3 ++-
 kernel/trace/trace_events.c        |    8 ++++----
 kernel/trace/trace_events_filter.c |   25 +++++++++----------------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54fd9bc..90a848d 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -840,7 +840,8 @@ struct filter_pred {
 int trace_define_field(struct ftrace_event_call *call, char *type,
 		       char *name, int offset, int size);
 extern void filter_free_pred(struct filter_pred *pred);
-extern int filter_print_preds(struct filter_pred **preds, char *buf);
+extern void filter_print_preds(struct filter_pred **preds,
+			       struct trace_seq *s);
 extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a938138..d132997 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -481,8 +481,8 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	r = filter_print_preds(call->preds, s->buffer);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
+	filter_print_preds(call->preds, s);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
 
@@ -547,8 +547,8 @@ subsystem_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	r = filter_print_preds(system->preds, s->buffer);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, r);
+	filter_print_preds(system->preds, s);
+	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 3f0b79f..9fca8bb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -24,6 +24,7 @@
 #include <linux/ctype.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 static int filter_pred_64(struct filter_pred *pred, void *event)
 {
@@ -108,16 +109,15 @@ int filter_match_preds(struct ftrace_event_call *call, void *rec)
 	return 1;
 }
 
-int filter_print_preds(struct filter_pred **preds, char *buf)
+void filter_print_preds(struct filter_pred **preds, struct trace_seq *s)
 {
-	ssize_t this_len = 0;
 	char *field_name;
 	struct filter_pred *pred;
 	int i;
 
 	if (!preds) {
-		this_len += sprintf(buf + this_len, "none\n");
-		return this_len;
+		trace_seq_printf(s, "none\n");
+		return;
 	}
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
@@ -125,23 +125,16 @@ int filter_print_preds(struct filter_pred **preds, char *buf)
 			pred = preds[i];
 			field_name = pred->field_name;
 			if (i)
-				this_len += sprintf(buf + this_len,
-					    pred->or ? "|| " : "&& ");
-			this_len += sprintf(buf + this_len,
-					    "%s ", field_name);
-			this_len += sprintf(buf + this_len,
-					    pred->not ? "!= " : "== ");
+				trace_seq_printf(s, pred->or ? "|| " : "&& ");
+			trace_seq_printf(s, "%s ", field_name);
+			trace_seq_printf(s, pred->not ? "!= " : "== ");
 			if (pred->str_val)
-				this_len += sprintf(buf + this_len,
-						    "%s\n", pred->str_val);
+				trace_seq_printf(s, "%s\n", pred->str_val);
 			else
-				this_len += sprintf(buf + this_len,
-						    "%llu\n", pred->val);
+				trace_seq_printf(s, "%llu\n", pred->val);
 		} else
 			break;
 	}
-
-	return this_len;
 }
 
 static struct ftrace_event_field *
-- 
1.5.6.3



