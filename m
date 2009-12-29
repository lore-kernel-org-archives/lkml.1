Return-Path: <linux-kernel-owner+w=401wt.eu-S1753083AbZL2Q1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbZL2Q1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZL2Q0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:26:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZL2Q0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:26:42 -0500
X-Authority-Analysis: v=1.0 c=1 a=0kNr-XlY9JMA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=ISOVghPnLcDAFCdiTq8A:9 a=Kxr8f5aoWAqS2ErIJ32MkZjtrKQA:4 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091229162639.284761647@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 29 Dec 2009 11:22:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/10] tracing: Use defined fields and print_fmt to print formats
References: <20091229162231.441352392@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Use-defined-fields-and-print_fmt-to-print-fo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The calls ftrace_format_##call() and ftrace_define_fields_##call()
are almost duplicate in functionality. With the addition of the
print_fmt in previous patches, these two functions can be merged
into one.

The trace_define_field() defines the fields and links them into
the struct ftrace_event_call. The previous patches introduced
the print_fmt field and this can now be used with the trace_define_field()
to create the event format file fields and print_fmt field.

The struct ftrace_event_call->fields are used to print the fields
The struct ftrace_event_call->print_fmt is used to print
the "print fmt: XXXXXXXXXXX" line.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D49.5000006@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   66 +++++++++++++++++++++++++++---------------
 1 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..c9d52e5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -528,33 +528,16 @@ extern char *__bad_type_size(void);
 	#type, "common_" #name, offsetof(typeof(field), name),		\
 		sizeof(field.name), is_signed_type(type)
 
-static int trace_write_header(struct trace_seq *s)
-{
-	struct trace_entry field;
-
-	/* struct trace_entry */
-	return trace_seq_printf(s,
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\tfield:%s %s;\toffset:%zu;\tsize:%zu;\tsigned:%u;\n"
-			"\n",
-			FIELD(unsigned short, type),
-			FIELD(unsigned char, flags),
-			FIELD(unsigned char, preempt_count),
-			FIELD(int, pid),
-			FIELD(int, lock_depth));
-}
-
 static ssize_t
 event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
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
@@ -565,14 +548,49 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
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
+					(int)(array_descriptor - field->type),
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
-- 
1.6.5


