Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZJQKEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZJQKEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZJQKEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:04:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:32950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbZJQKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:04:29 -0400
Date: Sat, 17 Oct 2009 10:03:56 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, paulus@samba.org, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, fche@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, acme@redhat.com, jkenisto@us.ibm.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, hch@infradead.org,
       ananth@in.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Avoid field name confliction
Message-ID: <tip-a703d946e883d8e447d0597de556e2effd110372@git.kernel.org>
Git-Commit-ID: a703d946e883d8e447d0597de556e2effd110372
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:03:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a703d946e883d8e447d0597de556e2effd110372
Gitweb:     http://git.kernel.org/tip/a703d946e883d8e447d0597de556e2effd110372
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 7 Oct 2009 18:28:07 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Mon, 12 Oct 2009 23:31:49 +0200

tracing/kprobes: Avoid field name confliction

Check whether the argument name is in conflict with other field names
while creating a kprobe through the debugfs interface.

Changes in v3:
 - Check strcmp() == 0 instead of !strcmp().

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
LKML-Reference: <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   65 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3313fa7..bb6cb2b 100644
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
@@ -537,6 +556,20 @@ static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 	return ret;
 }
 
+/* Return 1 if name is reserved or already used by another argument */
+static int conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
+		if (strcmp(reserved_field_names[i], name) == 0)
+			return 1;
+	for (i = 0; i < narg; i++)
+		if (strcmp(args[i].name, name) == 0)
+			return 1;
+	return 0;
+}
+
 static int create_trace_probe(int argc, char **argv)
 {
 	/*
@@ -637,6 +670,12 @@ static int create_trace_probe(int argc, char **argv)
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
@@ -1039,8 +1078,8 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	if (!ret)
 		return ret;
 
-	DEFINE_FIELD(unsigned long, ip, "ip", 0);
-	DEFINE_FIELD(int, nargs, "nargs", 1);
+	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
+	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++)
 		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
@@ -1057,9 +1096,9 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
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
@@ -1108,15 +1147,16 @@ static int kprobe_event_show_format(struct ftrace_event_call *call,
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
@@ -1126,9 +1166,9 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
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
@@ -1136,7 +1176,8 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 	trace_seq_puts(s, "\n");
 
 	return __probe_event_show_format(s, tp, "(%lx <- %lx)",
-					  "REC->func, REC->ret_ip");
+					 "REC->" FIELD_STRING_FUNC
+					 ", REC->" FIELD_STRING_RETIP);
 }
 
 #ifdef CONFIG_EVENT_PROFILE
