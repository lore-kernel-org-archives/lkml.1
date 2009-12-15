Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZLOHmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZLOHmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:42:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbZLOHls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:41:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55410 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbZLOHk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:40:29 -0500
Message-ID: <4B273D49.5000006@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/10] use defined fields and print_fmt to print formats
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that ftrace_format_##call() and ftrace_define_fields_##call()
are duplicate more or less.

trace_define_field() defines fields and links them into
strcut ftrace_event_call. And previous patches introduce
print_fmt, we reuse them all to print formats:

print name
print ID
print string "format:"
use struct ftrace_event_call->fields to print fields
use struct ftrace_event_call->print_fmt to print "print fmt: XXXXXXXXXXX"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..38c7fd0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -552,9 +552,11 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_field *field;
 	struct trace_seq *s;
+	int common_field_count = 5;
 	char *buf;
-	int r;
+	int r = 0;
 
 	if (*ppos)
 		return 0;
@@ -565,14 +567,49 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
 	trace_seq_init(s);
 
-	/* If any of the first writes fail, so will the show_format. */
-
 	trace_seq_printf(s, "name: %s\n", call->name);
 	trace_seq_printf(s, "ID: %d\n", call->id);
 	trace_seq_printf(s, "format:\n");
-	trace_write_header(s);
 
-	r = call->show_format(call, s);
+	list_for_each_entry_reverse(field, &call->fields, link) {
+		/*
+		 * Smartly shows the array type(except dynamic array).
+		 * Normal:
+		 *	field:TYPE VAR
+		 * If TYPE := TYPE[LEN], it is shown:
+		 *	field:TYPE VAR[LEN]
+		 */
+		const char *array_descriptor = strchr(field->type, '[');
+
+		if (!strncmp(field->type, "__data_loc", 10))
+			array_descriptor = NULL;
+
+		if (!array_descriptor) {
+			r = trace_seq_printf(s, "\tfield:%s %s;\toffset:%u;"
+					"\tsize:%u;\tsigned:%d;\n",
+					field->type, field->name, field->offset,
+					field->size, !!field->is_signed);
+		} else {
+			r = trace_seq_printf(s, "\tfield:%.*s %s%s;\toffset:%u;"
+					"\tsize:%u;\tsigned:%d;\n",
+					array_descriptor - field->type,
+					field->type, field->name,
+					array_descriptor, field->offset,
+					field->size, !!field->is_signed);
+		}
+
+		if (--common_field_count == 0)
+			r = trace_seq_printf(s, "\n");
+
+		if (!r)
+			break;
+	}
+
+	if (r) {
+		r = trace_seq_printf(s, "\nprint fmt: %s\n",
+				call->print_fmt);
+	}
+
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!


