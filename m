Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382Ab0AMKWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0AMKWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288Ab0AMKWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:22:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:37839 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab0AMKWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:22:51 -0500
Date: Wed, 13 Jan 2010 10:22:21 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, mhiramat@redhat.com,
       laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       mhiramat@redhat.com
In-Reply-To: <4B273D45.3080100@cn.fujitsu.com>
References: <4B273D45.3080100@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/kprobes: Init print_fmt for kprobe events
Message-ID: <tip-a342a0280b981c130e32dbb94dbd3a57959c4d04@git.kernel.org>
Git-Commit-ID: a342a0280b981c130e32dbb94dbd3a57959c4d04
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:22:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a342a0280b981c130e32dbb94dbd3a57959c4d04
Gitweb:     http://git.kernel.org/tip/a342a0280b981c130e32dbb94dbd3a57959c4d04
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 15 Dec 2009 15:39:49 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 6 Jan 2010 12:01:35 -0500

tracing/kprobes: Init print_fmt for kprobe events

This is part of a patch set that removes the show_format method
in the ftrace event macros.

Add the print_fmt initialization to the kprobe events.
The print_fmt is still not used, but will be in the follow up
patches.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B273D45.3080100@cn.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   64 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 6ea90c0..147491d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1250,6 +1250,62 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 					 ", REC->" FIELD_STRING_RETIP);
 }
 
+static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
+{
+	int i;
+	int pos = 0;
+
+	const char *fmt, *arg;
+
+	if (!probe_is_return(tp)) {
+		fmt = "(%lx)";
+		arg = "REC->" FIELD_STRING_IP;
+	} else {
+		fmt = "(%lx <- %lx)";
+		arg = "REC->" FIELD_STRING_FUNC ", REC->" FIELD_STRING_RETIP;
+	}
+
+	/* When len=0, we just calculate the needed length */
+#define LEN_OR_ZERO (len ? len - pos : 0)
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%%lx",
+				tp->args[i].name);
+	}
+
+	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
+
+	for (i = 0; i < tp->nr_args; i++) {
+		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+				tp->args[i].name);
+	}
+
+#undef LEN_OR_ZERO
+
+	/* return the length of print_fmt */
+	return pos;
+}
+
+static int set_print_fmt(struct trace_probe *tp)
+{
+	int len;
+	char *print_fmt;
+
+	/* First: called with 0 length to calculate the needed length */
+	len = __set_print_fmt(tp, NULL, 0);
+	print_fmt = kmalloc(len + 1, GFP_KERNEL);
+	if (!print_fmt)
+		return -ENOMEM;
+
+	/* Second: actually write the @print_fmt */
+	__set_print_fmt(tp, print_fmt, len + 1);
+	tp->call.print_fmt = print_fmt;
+
+	return 0;
+}
+
 #ifdef CONFIG_EVENT_PROFILE
 
 /* Kprobe profile handler */
@@ -1456,10 +1512,14 @@ static int register_probe_event(struct trace_probe *tp)
 		call->show_format = kprobe_event_show_format;
 		call->define_fields = kprobe_event_define_fields;
 	}
+	if (set_print_fmt(tp) < 0)
+		return -ENOMEM;
 	call->event = &tp->event;
 	call->id = register_ftrace_event(&tp->event);
-	if (!call->id)
+	if (!call->id) {
+		kfree(call->print_fmt);
 		return -ENODEV;
+	}
 	call->enabled = 0;
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
@@ -1472,6 +1532,7 @@ static int register_probe_event(struct trace_probe *tp)
 	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
+		kfree(call->print_fmt);
 		unregister_ftrace_event(&tp->event);
 	}
 	return ret;
@@ -1481,6 +1542,7 @@ static void unregister_probe_event(struct trace_probe *tp)
 {
 	/* tp->event is unregistered in trace_remove_event_call() */
 	trace_remove_event_call(&tp->call);
+	kfree(tp->call.print_fmt);
 }
 
 /* Make a debugfs interface for controling probe points */
