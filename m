Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065AbZCSUDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbZCSUDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZCSUCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:02:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZCSUCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:02:04 -0400
Message-Id: <20090319200200.544322342@goodmis.org>
References: <20090319200122.512803803@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 16:01:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: make print_(b)printk_msg_only global
Content-Disposition: inline; filename=0004-tracing-make-print_-b-printk_msg_only-global.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch makes print_printk_msg_only and print_bprintk_msg_only
global for other functions to use. It also renames them by adding
a "trace_" to the beginning to avoid namespace collisions.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c        |   36 ++----------------------------------
 kernel/trace/trace_output.c |   32 ++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h |    5 +++++
 3 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8d981ab..c637cb6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1694,38 +1694,6 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
-static enum print_line_t print_bprintk_msg_only(struct trace_iterator *iter)
-{
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *entry = iter->ent;
-	struct bprint_entry *field;
-	int ret;
-
-	trace_assign_type(field, entry);
-
-	ret = trace_seq_bprintf(s, field->fmt, field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
-}
-
-static enum print_line_t print_printk_msg_only(struct trace_iterator *iter)
-{
-	struct trace_seq *s = &iter->seq;
-	struct trace_entry *entry = iter->ent;
-	struct print_entry *field;
-	int ret;
-
-	trace_assign_type(field, entry);
-
-	ret = trace_seq_printf(s, "%s", field->buf);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
-	return TRACE_TYPE_HANDLED;
-}
-
 static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
@@ -1787,12 +1755,12 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	if (iter->ent->type == TRACE_BPRINT &&
 			trace_flags & TRACE_ITER_PRINTK &&
 			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
-		return print_bprintk_msg_only(iter);
+		return trace_print_bprintk_msg_only(iter);
 
 	if (iter->ent->type == TRACE_PRINT &&
 			trace_flags & TRACE_ITER_PRINTK &&
 			trace_flags & TRACE_ITER_PRINTK_MSGONLY)
-		return print_printk_msg_only(iter);
+		return trace_print_printk_msg_only(iter);
 
 	if (trace_flags & TRACE_ITER_BIN)
 		return print_bin_fmt(iter);
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 6a4c9de..b451417 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -19,6 +19,38 @@ static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;
 
+enum print_line_t trace_print_bprintk_msg_only(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct bprint_entry *field;
+	int ret;
+
+	trace_assign_type(field, entry);
+
+	ret = trace_seq_bprintf(s, field->fmt, field->buf);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
+enum print_line_t trace_print_printk_msg_only(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry = iter->ent;
+	struct print_entry *field;
+	int ret;
+
+	trace_assign_type(field, entry);
+
+	ret = trace_seq_printf(s, "%s", field->buf);
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
+
+	return TRACE_TYPE_HANDLED;
+}
+
 /**
  * trace_seq_printf - sequence printing of trace information
  * @s: trace sequence descriptor
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 3b90e6a..35c422f 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -15,6 +15,11 @@ struct trace_event {
 	trace_print_func	binary;
 };
 
+extern enum print_line_t
+trace_print_bprintk_msg_only(struct trace_iterator *iter);
+extern enum print_line_t
+trace_print_printk_msg_only(struct trace_iterator *iter);
+
 extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern int
-- 
1.6.2

-- 
