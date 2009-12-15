Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZLOHke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZLOHke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZLOHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:40:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64775 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZLOHkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:40:21 -0500
Message-ID: <4B273D41.609@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 07/10] trace_syscalls: init print_fmt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Init print_fmt for trace_syscalls.

But this field is still not used now,
the next patches will use it and replace the ->show_format().

It is preparing patch for new way of printing format files which
uses defined fields and a defined print_fmt to print formats.

How will the new way works(and how print_fmt will be used)?
print name
print ID
print string "format:"
use struct ftrace_event_call->fields to print fields
use struct ftrace_event_call->print_fmt to print "print fmt: XXXXXXXXXXX"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 75289f3..1352b0a 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -191,6 +191,67 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 	return trace_seq_putc(s, '\n');
 }
 
+static
+int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
+{
+	int i;
+	int pos = 0;
+
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
+	for (i = 0; i < entry->nb_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, "%s: 0x%%0%zulx%s",
+				entry->args[i], sizeof(unsigned long),
+				i == entry->nb_args - 1 ? "" : ", ");
+	}
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"");
+
+	for (i = 0; i < entry->nb_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO,
+				", ((unsigned long)(REC->%s))", entry->args[i]);
+	}
+
+#undef LEN_OR_ZERO
+
+	/* return the length of print_fmt */
+	return pos;
+}
+
+static int set_syscall_print_fmt(struct ftrace_event_call *call)
+{
+	char *print_fmt;
+	int len;
+	struct syscall_metadata *entry = call->data;
+
+	if (entry->enter_event != call) {
+		call->print_fmt = "\"0x%lx\", REC->ret";
+		return 0;
+	}
+
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_enter_print_fmt(entry, NULL, 0);
+
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_enter_print_fmt(entry, print_fmt, len + 1);
+	call->print_fmt = print_fmt;
+
+	return 0;
+}
+
+static void free_syscall_print_fmt(struct ftrace_event_call *call)
+{
+	struct syscall_metadata *entry = call->data;
+
+	if (entry->enter_event == call)
+		kfree(call->print_fmt);
+}
+
 int syscall_exit_format(struct ftrace_event_call *call, struct trace_seq *s)
 {
 	int ret;
@@ -386,9 +447,14 @@ int init_syscall_trace(struct ftrace_event_call *call)
 {
 	int id;
 
+	if (set_syscall_print_fmt(call) < 0)
+		return -ENOMEM;
+
 	id = register_ftrace_event(call->event);
-	if (!id)
+	if (!id) {
+		free_syscall_print_fmt(call);
 		return -ENODEV;
+	}
 	call->id = id;
 	INIT_LIST_HEAD(&call->fields);
 	return 0;



