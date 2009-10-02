Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZJBVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZJBVr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZJBVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:47:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbZJBVrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:47:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes v2 2/5] tracing/kprobes: Avoid field name
	confliction
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 02 Oct 2009 17:48:50 -0400
Message-ID: <20091002214850.30906.25919.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether the argument name is conflict with other field names.

Changes in v2:
 - Add common_lock_depth to reserved name list.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f63ead0..eb1fa0f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -38,6 +38,25 @@
 #define MAX_EVENT_NAME_LEN 64
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
+/* Reserved field names */
+#define FIELD_STRING_IP "ip"
+#define FIELD_STRING_NARGS "nargs"
+#define FIELD_STRING_RETIP "ret_ip"
+#define FIELD_STRING_FUNC "func"
+
+const char *reserved_field_names[] = {
+	"common_type",
+	"common_flags",
+	"common_preempt_count",
+	"common_pid",
+	"common_tgid",
+	"common_lock_depth",
+	FIELD_STRING_IP,
+	FIELD_STRING_NARGS,
+	FIELD_STRING_RETIP,
+	FIELD_STRING_FUNC,
+};
+
 /* currently, trace_kprobe only supports X86. */
 
 struct fetch_func {
@@ -551,6 +570,20 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 	return ret;
 }
 
+/* Return 1 if name is reserved or already used by another argument */
+static int conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
+		if (!strcmp(reserved_field_names[i], name))
+			return 1;
+	for (i = 0; i < narg; i++)
+		if (!strcmp(args[i].name, name))
+			return 1;
+	return 0;
+}
+
 static int create_trace_probe(int argc, char **argv)
 {
 	/*
@@ -652,6 +685,12 @@ static int create_trace_probe(int argc, char **argv)
 			*arg++ = '\0';
 		else
 			arg = argv[i];
+
+		if (conflict_field_name(argv[i], tp->args, i)) {
+			ret = -EINVAL;
+			goto error;
+		}
+
 		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
 
 		/* Parse fetch argument */
@@ -1054,8 +1093,8 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	if (!ret)
 		return ret;
 
-	DEFINE_FIELD(unsigned long, ip, "ip", 0);
-	DEFINE_FIELD(int, nargs, "nargs", 1);
+	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++)
 		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
@@ -1072,9 +1111,9 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	if (!ret)
 		return ret;
 
-	DEFINE_FIELD(unsigned long, func, "func", 0);
-	DEFINE_FIELD(unsigned long, ret_ip, "ret_ip", 0);
-	DEFINE_FIELD(int, nargs, "nargs", 1);
+	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
+	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
+	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++)
 		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
@@ -1123,15 +1162,16 @@ static int kprobe_event_show_format(struct ftrace_event_call *call,
 	int ret, i;
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
-	SHOW_FIELD(unsigned long, ip, "ip");
-	SHOW_FIELD(int, nargs, "nargs");
+	SHOW_FIELD(unsigned long, ip, FIELD_STRING_IP);
+	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
 
 	/* Show fields */
 	for (i = 0; i < tp->nr_args; i++)
 		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
 	trace_seq_puts(s, "\n");
 
-	return __probe_event_show_format(s, tp, "(%lx)", "REC->ip");
+	return __probe_event_show_format(s, tp, "(%lx)",
+					 "REC->" FIELD_STRING_IP);
 }
 
 static int kretprobe_event_show_format(struct ftrace_event_call *call,
@@ -1141,9 +1181,9 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 	int ret, i;
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
-	SHOW_FIELD(unsigned long, func, "func");
-	SHOW_FIELD(unsigned long, ret_ip, "ret_ip");
-	SHOW_FIELD(int, nargs, "nargs");
+	SHOW_FIELD(unsigned long, func, FIELD_STRING_FUNC);
+	SHOW_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP);
+	SHOW_FIELD(int, nargs, FIELD_STRING_NARGS);
 
 	/* Show fields */
 	for (i = 0; i < tp->nr_args; i++)
@@ -1151,7 +1191,8 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 	trace_seq_puts(s, "\n");
 
 	return __probe_event_show_format(s, tp, "(%lx <- %lx)",
-					  "REC->func, REC->ret_ip");
+					 "REC->" FIELD_STRING_FUNC
+					 ", REC->" FIELD_STRING_RETIP);
 }
 
 #ifdef CONFIG_EVENT_PROFILE


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
