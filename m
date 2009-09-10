Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbZIJXwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbZIJXwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbZIJXw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZIJXwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:52:24 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 5/7] tracing/kprobes: Add argument name support
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Date: Thu, 10 Sep 2009 19:53:38 -0400
Message-ID: <20090910235337.22412.77383.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add argument name assignment support and remove "alias" lines from format.
This allows user to assign unique name to each argument. For example,

$ echo p do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 > kprobe_events

This assigns dfd, filename, flags, and mode to 1st - 4th arguments
respectively. Trace buffer shows those names too.

	<...>-1439  [000] 1200885.933147: do_sys_open+0x0/0xdf: dfd=ffffff9c filename=bfa898ac flags=8000 mode=0

This helps users to know what each value means.

Users can filter each events by these names too. Note that you can not
filter by argN anymore.


Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
---

 Documentation/trace/kprobetrace.txt |   46 +++++--------
 kernel/trace/trace_kprobe.c         |  128 ++++++++++++++++++-----------------
 2 files changed, 84 insertions(+), 90 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 8f882eb..55a8034 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -42,7 +42,8 @@ Synopsis of kprobe_events
   aN	: Fetch function argument. (N >= 0)(*)
   rv	: Fetch return value.(**)
   ra	: Fetch return address.(**)
-  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)
+  +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(***)
+  NAME=FETCHARG: Set NAME as the argument name of FETCHARG.
 
   (*) aN may not correct on asmlinkaged functions and at the middle of
       function body.
@@ -62,12 +63,10 @@ enabled:
   You can enable/disable the probe by writing 1 or 0 on it.
 
 format:
-  This shows the format of this probe event. It also shows aliases of arguments
- which you specified to kprobe_events.
+  This shows the format of this probe event.
 
 filter:
-  You can write filtering rules of this event. And you can use both of aliase
- names and field names for describing filters.
+  You can write filtering rules of this event.
 
 id:
   This shows the id of this probe event.
@@ -85,10 +84,11 @@ Usage examples
 To add a probe as a new event, write a new definition to kprobe_events
 as below.
 
-  echo p:myprobe do_sys_open a0 a1 a2 a3 > /sys/kernel/debug/tracing/kprobe_events
+  echo p:myprobe do_sys_open dfd=a0 filename=a1 flags=a2 mode=a3 > /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kprobe on the top of do_sys_open() function with recording
-1st to 4th arguments as "myprobe" event.
+1st to 4th arguments as "myprobe" event. As this example shows, users can
+choose more familier name for each arguments.
 
   echo r:myretprobe do_sys_open rv ra >> /sys/kernel/debug/tracing/kprobe_events
 
@@ -99,7 +99,7 @@ recording return value and return address as "myretprobe" event.
 
   cat /sys/kernel/debug/tracing/events/kprobes/myprobe/format
 name: myprobe
-ID: 23
+ID: 75
 format:
 	field:unsigned short common_type;	offset:0;	size:2;
 	field:unsigned char common_flags;	offset:2;	size:1;
@@ -109,21 +109,15 @@ format:
 
 	field: unsigned long ip;	offset:16;tsize:8;
 	field: int nargs;	offset:24;tsize:4;
-	field: unsigned long arg0;	offset:32;tsize:8;
-	field: unsigned long arg1;	offset:40;tsize:8;
-	field: unsigned long arg2;	offset:48;tsize:8;
-	field: unsigned long arg3;	offset:56;tsize:8;
+	field: unsigned long dfd;	offset:32;tsize:8;
+	field: unsigned long filename;	offset:40;tsize:8;
+	field: unsigned long flags;	offset:48;tsize:8;
+	field: unsigned long mode;	offset:56;tsize:8;
 
-	alias: a0;	original: arg0;
-	alias: a1;	original: arg1;
-	alias: a2;	original: arg2;
-	alias: a3;	original: arg3;
+print fmt: "%lx: dfd=%lx filename=%lx flags=%lx mode=%lx", ip, REC->dfd, REC->filename, REC->flags, REC->mode
 
-print fmt: "%lx: 0x%lx 0x%lx 0x%lx 0x%lx", ip, arg0, arg1, arg2, arg3
 
-
- You can see that the event has 4 arguments and alias expressions
-corresponding to it.
+ You can see that the event has 4 arguments as expressions you specified.
 
   echo > /sys/kernel/debug/tracing/kprobe_events
 
@@ -135,12 +129,12 @@ corresponding to it.
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
-           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: 0x3 0x7fffd1ec4440 0x8000 0x0
-           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: 0xfffffffffffffffe 0xffffffff81367a3a
-           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: 0xffffff9c 0x40413c 0x8000 0x1b6
-           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a
-           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: 0xffffff9c 0x4041c6 0x98800 0x10
-           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <- do_sys_open: 0x3 0xffffffff81367a3a
+           <...>-1447  [001] 1038282.286875: do_sys_open+0x0/0xd6: dfd=3 filename=7fffd1ec4440 flags=8000 mode=0
+           <...>-1447  [001] 1038282.286878: sys_openat+0xc/0xe <- do_sys_open: rv=fffffffffffffffe ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286885: do_sys_open+0x0/0xd6: dfd=ffffff9c filename=40413c flags=8000 mode=1b6
+           <...>-1447  [001] 1038282.286915: sys_open+0x1b/0x1d <- do_sys_open: rv=3 ra=ffffffff81367a3a
+           <...>-1447  [001] 1038282.286969: do_sys_open+0x0/0xd6: dfd=ffffff9c filename=4041c6 flags=98800 mode=10
+           <...>-1447  [001] 1038282.286976: sys_open+0x1b/0x1d <- do_sys_open: rv=3 ra=ffffffff81367a3a
 
 
  Each line shows when the kernel hits a probe, and <- SYMBOL means kernel
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 21ffb5e..6b88acd 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -176,9 +176,14 @@ static __kprobes void free_indirect_fetch_data(struct indirect_fetch_data *data)
 }
 
 /**
- * kprobe_trace_core
+ * Kprobe tracer core functions
  */
 
+struct probe_arg {
+	struct fetch_func	fetch;
+	const char		*name;
+};
+
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -187,12 +192,12 @@ struct trace_probe {
 	struct ftrace_event_call	call;
 	struct trace_event		event;
 	unsigned int		nr_args;
-	struct fetch_func	args[];
+	struct probe_arg	args[];
 };
 
 #define SIZEOF_TRACE_PROBE(n)			\
 	(offsetof(struct trace_probe, args) +	\
-	(sizeof(struct fetch_func) * (n)))
+	(sizeof(struct probe_arg) * (n)))
 
 static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_trace_func(struct kretprobe_instance *ri,
@@ -301,15 +306,21 @@ error:
 	return ERR_PTR(-ENOMEM);
 }
 
+static void free_probe_arg(struct probe_arg *arg)
+{
+	if (arg->fetch.func == fetch_symbol)
+		free_symbol_cache(arg->fetch.data);
+	else if (arg->fetch.func == fetch_indirect)
+		free_indirect_fetch_data(arg->fetch.data);
+	kfree(arg->name);
+}
+
 static void free_trace_probe(struct trace_probe *tp)
 {
 	int i;
 
 	for (i = 0; i < tp->nr_args; i++)
-		if (tp->args[i].func == fetch_symbol)
-			free_symbol_cache(tp->args[i].data);
-		else if (tp->args[i].func == fetch_indirect)
-			free_indirect_fetch_data(tp->args[i].data);
+		free_probe_arg(&tp->args[i]);
 
 	kfree(tp->call.name);
 	kfree(tp->symbol);
@@ -532,11 +543,13 @@ static int create_trace_probe(int argc, char **argv)
 	 *  %REG	: fetch register REG
 	 * Indirect memory fetch:
 	 *  +|-offs(ARG) : fetch memory at ARG +|- offs address.
+	 * Alias name of args:
+	 *  NAME=FETCHARG : set NAME as alias of FETCHARG.
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
 	int is_return = 0;
-	char *symbol = NULL, *event = NULL;
+	char *symbol = NULL, *event = NULL, *arg = NULL;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
@@ -596,12 +609,21 @@ static int create_trace_probe(int argc, char **argv)
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
-		if (strlen(argv[i]) > MAX_ARGSTR_LEN) {
-			pr_info("Argument%d(%s) is too long.\n", i, argv[i]);
+		/* Parse argument name */
+		arg = strchr(argv[i], '=');
+		if (arg)
+			*arg++ = '\0';
+		else
+			arg = argv[i];
+		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
+
+		/* Parse fetch argument */
+		if (strlen(arg) > MAX_ARGSTR_LEN) {
+			pr_info("Argument%d(%s) is too long.\n", i, arg);
 			ret = -ENOSPC;
 			goto error;
 		}
-		ret = parse_probe_arg(argv[i], &tp->args[i], is_return);
+		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
 		if (ret)
 			goto error;
 	}
@@ -664,12 +686,12 @@ static int probes_seq_show(struct seq_file *m, void *v)
 		seq_printf(m, " 0x%p", tp->rp.kp.addr);
 
 	for (i = 0; i < tp->nr_args; i++) {
-		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
+		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
 		if (ret < 0) {
 			pr_warning("Argument%d decoding error(%d).\n", i, ret);
 			return ret;
 		}
-		seq_printf(m, " %s", buf);
+		seq_printf(m, " %s=%s", tp->args[i].name, buf);
 	}
 	seq_printf(m, "\n");
 	return 0;
@@ -823,7 +845,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i], regs);
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	if (!filter_current_check_discard(call, entry, event))
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc);
@@ -856,7 +878,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i], regs);
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 
 	if (!filter_current_check_discard(call, entry, event))
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc);
@@ -870,9 +892,13 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 {
 	struct kprobe_trace_entry *field;
 	struct trace_seq *s = &iter->seq;
+	struct trace_event *event;
+	struct trace_probe *tp;
 	int i;
 
 	field = (struct kprobe_trace_entry *)iter->ent;
+	event = ftrace_find_event(field->ent.type);
+	tp = container_of(event, struct trace_probe, event);
 
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
@@ -881,7 +907,8 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 		goto partial;
 
 	for (i = 0; i < field->nargs; i++)
-		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
+		if (!trace_seq_printf(s, " %s=%lx",
+				      tp->args[i].name, field->args[i]))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -897,9 +924,13 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 {
 	struct kretprobe_trace_entry *field;
 	struct trace_seq *s = &iter->seq;
+	struct trace_event *event;
+	struct trace_probe *tp;
 	int i;
 
 	field = (struct kretprobe_trace_entry *)iter->ent;
+	event = ftrace_find_event(field->ent.type);
+	tp = container_of(event, struct trace_probe, event);
 
 	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
@@ -914,7 +945,8 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 		goto partial;
 
 	for (i = 0; i < field->nargs; i++)
-		if (!trace_seq_printf(s, " 0x%lx", field->args[i]))
+		if (!trace_seq_printf(s, " %s=%lx",
+				      tp->args[i].name, field->args[i]))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -970,7 +1002,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kprobe_trace_entry field;
-	char buf[MAX_ARGSTR_LEN + 1];
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
@@ -979,16 +1010,9 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 
 	DEFINE_FIELD(unsigned long, ip, "ip", 0);
 	DEFINE_FIELD(int, nargs, "nargs", 1);
-	for (i = 0; i < tp->nr_args; i++) {
-		/* Set argN as a field */
-		sprintf(buf, "arg%d", i);
-		DEFINE_FIELD(unsigned long, args[i], buf, 0);
-		/* Set argument string as an alias field */
-		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
-		if (ret < 0)
-			return ret;
-		DEFINE_FIELD(unsigned long, args[i], buf, 0);
-	}
+	/* Set argument names as fields */
+	for (i = 0; i < tp->nr_args; i++)
+		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
 	return 0;
 }
 
@@ -996,7 +1020,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
 	struct kretprobe_trace_entry field;
-	char buf[MAX_ARGSTR_LEN + 1];
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	ret = trace_define_common_fields(event_call);
@@ -1006,16 +1029,9 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	DEFINE_FIELD(unsigned long, func, "func", 0);
 	DEFINE_FIELD(unsigned long, ret_ip, "ret_ip", 0);
 	DEFINE_FIELD(int, nargs, "nargs", 1);
-	for (i = 0; i < tp->nr_args; i++) {
-		/* Set argN as a field */
-		sprintf(buf, "arg%d", i);
-		DEFINE_FIELD(unsigned long, args[i], buf, 0);
-		/* Set argument string as an alias field */
-		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
-		if (ret < 0)
-			return ret;
-		DEFINE_FIELD(unsigned long, args[i], buf, 0);
-	}
+	/* Set argument names as fields */
+	for (i = 0; i < tp->nr_args; i++)
+		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
 	return 0;
 }
 
@@ -1023,31 +1039,21 @@ static int __probe_event_show_format(struct trace_seq *s,
 				     struct trace_probe *tp, const char *fmt,
 				     const char *arg)
 {
-	int i, ret;
-	char buf[MAX_ARGSTR_LEN + 1];
+	int i;
 
-	/* Show aliases */
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
-		if (ret < 0)
-			return ret;
-		if (!trace_seq_printf(s, "\talias: %s;\toriginal: arg%d;\n",
-				      buf, i))
-			return 0;
-	}
 	/* Show format */
 	if (!trace_seq_printf(s, "\nprint fmt: \"%s", fmt))
 		return 0;
 
 	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_puts(s, " 0x%lx"))
+		if (!trace_seq_printf(s, " %s=%%lx", tp->args[i].name))
 			return 0;
 
 	if (!trace_seq_printf(s, "\", %s", arg))
 		return 0;
 
 	for (i = 0; i < tp->nr_args; i++)
-		if (!trace_seq_printf(s, ", arg%d", i))
+		if (!trace_seq_printf(s, ", REC->%s", tp->args[i].name))
 			return 0;
 
 	return trace_seq_puts(s, "\n");
@@ -1069,17 +1075,14 @@ static int kprobe_event_show_format(struct ftrace_event_call *call,
 {
 	struct kprobe_trace_entry field __attribute__((unused));
 	int ret, i;
-	char buf[8];
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
 	SHOW_FIELD(unsigned long, ip, "ip");
 	SHOW_FIELD(int, nargs, "nargs");
 
 	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		sprintf(buf, "arg%d", i);
-		SHOW_FIELD(unsigned long, args[i], buf);
-	}
+	for (i = 0; i < tp->nr_args; i++)
+		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
 	trace_seq_puts(s, "\n");
 
 	return __probe_event_show_format(s, tp, "%lx:", "ip");
@@ -1090,7 +1093,6 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 {
 	struct kretprobe_trace_entry field __attribute__((unused));
 	int ret, i;
-	char buf[8];
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
 	SHOW_FIELD(unsigned long, func, "func");
@@ -1098,10 +1100,8 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 	SHOW_FIELD(int, nargs, "nargs");
 
 	/* Show fields */
-	for (i = 0; i < tp->nr_args; i++) {
-		sprintf(buf, "arg%d", i);
-		SHOW_FIELD(unsigned long, args[i], buf);
-	}
+	for (i = 0; i < tp->nr_args; i++)
+		SHOW_FIELD(unsigned long, args[i], tp->args[i].name);
 	trace_seq_puts(s, "\n");
 
 	return __probe_event_show_format(s, tp, "%lx <- %lx:",
@@ -1138,7 +1138,7 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 		entry->nargs = tp->nr_args;
 		entry->ip = (unsigned long)kp->addr;
 		for (i = 0; i < tp->nr_args; i++)
-			entry->args[i] = call_fetch(&tp->args[i], regs);
+			entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 		perf_tpcounter_event(call->id, entry->ip, 1, entry, size);
 	} while (0);
 	return 0;
@@ -1173,7 +1173,7 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 		entry->func = (unsigned long)tp->rp.kp.addr;
 		entry->ret_ip = (unsigned long)ri->ret_addr;
 		for (i = 0; i < tp->nr_args; i++)
-			entry->args[i] = call_fetch(&tp->args[i], regs);
+			entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
 		perf_tpcounter_event(call->id, entry->ret_ip, 1, entry, size);
 	} while (0);
 	return 0;


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
