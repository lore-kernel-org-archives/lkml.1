Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZLOHlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZLOHlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZLOHka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:40:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52049 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbZLOHkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:40:25 -0500
Message-ID: <4B273D45.3080100@cn.fujitsu.com>
Date: Tue, 15 Dec 2009 15:39:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 08/10] trace_kprobe: init print_fmt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init print_fmt for trace_kprobe.

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
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 83f1e6e..1ccf39f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1231,6 +1231,62 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
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
@@ -1437,10 +1493,14 @@ static int register_probe_event(struct trace_probe *tp)
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
@@ -1453,6 +1513,7 @@ static int register_probe_event(struct trace_probe *tp)
 	ret = trace_add_event_call(call);
 	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
+		kfree(call->print_fmt);
 		unregister_ftrace_event(&tp->event);
 	}
 	return ret;
@@ -1462,6 +1523,7 @@ static void unregister_probe_event(struct trace_probe *tp)
 {
 	/* tp->event is unregistered in trace_remove_event_call() */
 	trace_remove_event_call(&tp->call);
+	kfree(tp->call.print_fmt);
 }
 
 /* Make a debugfs interface for controling probe points */



