Return-Path: <linux-kernel-owner+w=401wt.eu-S965611AbZLIHQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965611AbZLIHQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbZLIHQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:16:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52131 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965018AbZLIHQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:16:29 -0500
Message-ID: <4B1F4EA6.5080105@cn.fujitsu.com>
Date: Wed, 09 Dec 2009 15:15:50 +0800
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
It will be used for replacing ->show_format().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 75289f3..dcd8699 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -191,6 +191,61 @@ int syscall_enter_format(struct ftrace_event_call *call, struct trace_seq *s)
 	return trace_seq_putc(s, '\n');
 }
 
+static
+int  __set_enter_print_fmt(struct syscall_metadata *entry, char *buf, int len)
+{
+	int i;
+	int pos = 0;
+
+	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
+	for (i = 0; i < entry->nb_args; i++) {
+		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
+				"%s: 0x%%0%zulx%s", entry->args[i],
+				sizeof(unsigned long),
+				i == entry->nb_args - 1 ? "" : ", ");
+	}
+	pos += snprintf(buf + pos, len > pos ? len - pos : 0, "\"");
+
+	for (i = 0; i < entry->nb_args; i++) {
+		pos += snprintf(buf + pos, len > pos ? len - pos : 0,
+				", ((unsigned long)(REC->%s))", entry->args[i]);
+	}
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
+	len = __set_enter_print_fmt(entry, NULL, 0);
+
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
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
@@ -386,9 +441,14 @@ int init_syscall_trace(struct ftrace_event_call *call)
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


