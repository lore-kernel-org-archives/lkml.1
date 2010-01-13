Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387Ab0AMKXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0AMKXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346Ab0AMKXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:23:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:37854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0AMKXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:23:06 -0500
Date: Wed, 13 Jan 2010 10:22:52 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B273D49.5000006@cn.fujitsu.com>
References: <4B273D49.5000006@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Use defined fields and print_fmt to print formats
Message-ID: <tip-5a65e956220efc2421e21ee56d6153fd5c533a95@git.kernel.org>
Git-Commit-ID: 5a65e956220efc2421e21ee56d6153fd5c533a95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:22:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a65e956220efc2421e21ee56d6153fd5c533a95
Gitweb:     http://git.kernel.org/tip/5a65e956220efc2421e21ee56d6153fd5c533a95
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:53 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 12:08:20 -0500

tracing: Use defined fields and print_fmt to print formats

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
 kernel/trace/trace_events.c |   65 +++++++++++++++++++++++++++----------------
 1 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 189b09b..250ec86 100644
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
@@ -565,14 +548,48 @@ event_format_read(struct file *filp, char __user *ubuf, size_t cnt,
 
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
+	if (r)
+		r = trace_seq_printf(s, "\nprint fmt: %s\n",
+				call->print_fmt);
+
 	if (!r) {
 		/*
 		 * ug!  The format output is bigger than a PAGE!!
