Return-Path: <linux-kernel-owner+w=401wt.eu-S933035Ab0AFXQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab0AFXQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637Ab0AFXPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:15:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab0AFXPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=TVosJ2UVz8QA:10 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=9J0ZoANnShLzYpGMiyUA:9 a=tyrUCX1U4RGAISQwv3oA:7 a=THgSez5UJ_RT6AAWNPYbMcd7YgoA:4 a=jeBq3FmKZ4MA:10 a=Dm_BvGC7yvwzINQc:21 a=WuN-gP5_TuSsIDp3:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231531.387844736@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/11] tracing/syscalls: Init print_fmt for syscall events
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-syscalls-Init-print_fmt-for-syscall-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

This is part of a patch set that removes the show_format method
in the ftrace event macros.

Add the print_fmt initialization to the syscall events.
The print_fmt is still not used, but will be in the follow up
patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D41.609@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_syscalls.c |   68 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 67 insertions(+), 1 deletions(-)

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
-- 
1.6.5


