Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390Ab0AMKW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab0AMKW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379Ab0AMKWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:22:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:37824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab0AMKWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:22:21 -0500
Date: Wed, 13 Jan 2010 10:22:05 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4B273D41.609@cn.fujitsu.com>
References: <4B273D41.609@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/syscalls: Init print_fmt for syscall events
Message-ID: <tip-50307a45f8515f6244e3b08e6b19824b9fbfe293@git.kernel.org>
Git-Commit-ID: 50307a45f8515f6244e3b08e6b19824b9fbfe293
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:22:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50307a45f8515f6244e3b08e6b19824b9fbfe293
Gitweb:     http://git.kernel.org/tip/50307a45f8515f6244e3b08e6b19824b9fbfe293
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:45 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 11:58:32 -0500

tracing/syscalls: Init print_fmt for syscall events

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
