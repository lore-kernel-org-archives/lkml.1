Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYKPKkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYKPKkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYKPKjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:39:48 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40118 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYKPKjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:39:46 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: Add dump iteator
Date: Sun, 16 Nov 2008 16:08:03 +0530
Message-Id: <1226831883-26362-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4.735.gea4f
In-Reply-To: <1226831883-26362-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1226831883-26362-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1226831883-26362-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This iteator doesn't print headers and tracer information in
the ouput trace file. This can be obtained to get a dmesg style
trace output file. Also can be used to dump binary data to via
trace

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 kernel/trace/trace.c |   92 ++++++++++++++++++++++++++++++++++++++++++--------
 kernel/trace/trace.h |    1 +
 2 files changed, 79 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f6e21d8..c0d1170 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -263,6 +263,7 @@ static const char *trace_options[] = {
 	"branch",
 #endif
 	"annotate",
+	"dump",
 	NULL
 };
 
@@ -2038,6 +2039,77 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	return 1;
 }
 
+static enum print_line_t print_dump_fmt(struct trace_iterator *iter)
+{
+	struct trace_seq *s = &iter->seq;
+	struct trace_entry *entry;
+
+	entry = iter->ent;
+
+	if (entry->type == TRACE_CONT)
+		return TRACE_TYPE_HANDLED;
+
+
+	switch (entry->type) {
+	case TRACE_FN: {
+		struct ftrace_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, entry->pid);
+		SEQ_PUT_FIELD_RET(s, iter->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->ts);
+
+		SEQ_PUT_FIELD_RET(s, field->ip);
+		SEQ_PUT_FIELD_RET(s, field->parent_ip);
+		break;
+	}
+	case TRACE_CTX: {
+		struct ctx_switch_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, entry->pid);
+		SEQ_PUT_FIELD_RET(s, iter->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->ts);
+
+		SEQ_PUT_FIELD_RET(s, field->prev_pid);
+		SEQ_PUT_FIELD_RET(s, field->prev_prio);
+		SEQ_PUT_FIELD_RET(s, field->prev_state);
+		SEQ_PUT_FIELD_RET(s, field->next_pid);
+		SEQ_PUT_FIELD_RET(s, field->next_prio);
+		SEQ_PUT_FIELD_RET(s, field->next_state);
+		break;
+	}
+	case TRACE_SPECIAL:
+	case TRACE_STACK: {
+		struct special_entry *field;
+
+		trace_assign_type(field, entry);
+
+		SEQ_PUT_FIELD_RET(s, entry->pid);
+		SEQ_PUT_FIELD_RET(s, iter->cpu);
+		SEQ_PUT_FIELD_RET(s, iter->ts);
+
+		SEQ_PUT_FIELD_RET(s, field->arg1);
+		SEQ_PUT_FIELD_RET(s, field->arg2);
+		SEQ_PUT_FIELD_RET(s, field->arg3);
+		break;
+	}
+	case TRACE_PRINT: {
+		struct print_entry *field;
+
+		trace_assign_type(field, entry);
+
+		trace_seq_printf(s, "%s", field->buf);
+		if (entry->flags & TRACE_FLAG_CONT)
+			trace_seq_print_cont(s, iter);
+		break;
+	}
+	}
+	return TRACE_TYPE_HANDLED;
+}
+
 static int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
@@ -2074,6 +2146,9 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 	if (trace_flags & TRACE_ITER_RAW)
 		return print_raw_fmt(iter);
 
+	if (trace_flags & TRACE_ITER_DUMP)
+		return print_dump_fmt(iter);
+
 	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
 		return print_lat_fmt(iter, iter->idx, iter->cpu);
 
@@ -2083,24 +2158,12 @@ static enum print_line_t print_trace_line(struct trace_iterator *iter)
 static int s_bin_show(struct seq_file *m, void *v)
 {
 	int len;
-	enum print_line_t ret;
 	struct trace_iterator *iter = v;
 
 	if (iter->ent == NULL)
 		return 0;
 
-	if (iter->trace && iter->trace->print_line) {
-		ret = iter->trace->print_line(iter);
-		if (ret != TRACE_TYPE_UNHANDLED)
-			goto trace_handled;
-	}
-	/*
-	 * If  trace type is unhandled or if we don't have
-	 * a print_line call the standard bin_fmt callback
-	 */
-	print_bin_fmt(iter);
-
-trace_handled:
+	print_trace_line(iter);
 	/* copy the trace buffer to seq file buffer */
 	if (iter->seq.len >= PAGE_SIZE)
 		len = PAGE_SIZE - 1;
@@ -2122,7 +2185,8 @@ static int s_show(struct seq_file *m, void *v)
 {
 	struct trace_iterator *iter = v;
 
-	if (trace_flags & TRACE_ITER_BIN)
+	if ((trace_flags & TRACE_ITER_BIN) ||
+			(trace_flags & TRACE_ITER_DUMP))
 		return s_bin_show(m, v);
 
 	if (iter->ent == NULL) {
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 790ea8c..358d2a6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -474,6 +474,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_BRANCH		= 0x1000,
 #endif
 	TRACE_ITER_ANNOTATE		= 0x2000,
+	TRACE_ITER_DUMP			= 0x4000,
 };
 
 /*
-- 
tg: (47b0062..) an/ftrace-dump-iterator.patch (depends on: an/ftrace-bin-iterator.patch)
