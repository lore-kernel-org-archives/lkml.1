Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309Ab0AFXR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0AFXR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410Ab0AFXRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:17:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab0AFXPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:15:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=Mz6Vv-AoDKoA:10 a=omOdbC7AAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Co2WapulWY7qBtz4zQMA:9 a=MBRF23BYHM4U5ngJUX4A:7 a=6gRmhpxRMC_eu2AXYsHAUrE1xsUA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=5u5uM2dSxY1KoppG:21 a=r_fO2SUAsaaRQgNk:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100106231531.727948498@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 18:13:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 04/11] tracing/kprobes: Init print_fmt for kprobe events
References: <20100106231349.107649729@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-kprobes-Init-print_fmt-for-kprobe-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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
-- 
1.6.5


