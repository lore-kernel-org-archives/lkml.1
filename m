Return-Path: <linux-kernel-owner+w=401wt.eu-S1752422AbZIVTjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422AbZIVTjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbZIVTjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:01 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZIVTi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HEaisnbw5+ZoLh7o8MZafav10P9HYx3PoEr0synLxyT/Ii4WRr0uVuuPlYp98CunK6
         nPTBB/m5mQ1ORy0kZ5yNHfaVvAOUbMm9Jgfp9d7BDJRAIeNXzkQcOr1Xx3j0Epcq+OYY
         lCm8/niT4XDSnAj7/E30XL82nzak2QBUxi558=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 13/24] tracing/kprobes: Cleanup kprobe tracer code.
Date: Tue, 22 Sep 2009 21:38:11 +0200
Message-Id: <1253648302-5771-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Simplify trace_probe to remove a union, and remove some redundant
wrappers.
And also, cleanup create_trace_probe() function.

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
LKML-Reference: <20090910235322.22412.52525.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |   81 ++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 47 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c24b7e9..4ce728c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -180,10 +180,7 @@ static __kprobes void free_indirect_fetch_data(struct indirect_fetch_data *data)
 
 struct trace_probe {
 	struct list_head	list;
-	union {
-		struct kprobe		kp;
-		struct kretprobe	rp;
-	};
+	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
 	unsigned long 		nhit;
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
@@ -202,7 +199,7 @@ static int kretprobe_trace_func(struct kretprobe_instance *ri,
 
 static __kprobes int probe_is_return(struct trace_probe *tp)
 {
-	return (tp->rp.handler == kretprobe_trace_func);
+	return tp->rp.handler != NULL;
 }
 
 static __kprobes const char *probe_symbol(struct trace_probe *tp)
@@ -210,16 +207,6 @@ static __kprobes const char *probe_symbol(struct trace_probe *tp)
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
-static __kprobes unsigned int probe_offset(struct trace_probe *tp)
-{
-	return (probe_is_return(tp)) ? tp->rp.kp.offset : tp->kp.offset;
-}
-
-static __kprobes void *probe_address(struct trace_probe *tp)
-{
-	return (probe_is_return(tp)) ? tp->rp.kp.addr : tp->kp.addr;
-}
-
 static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
 {
 	int ret = -EINVAL;
@@ -269,8 +256,14 @@ static void unregister_probe_event(struct trace_probe *tp);
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
 
-static struct trace_probe *alloc_trace_probe(const char *symbol,
-					     const char *event, int nargs)
+/*
+ * Allocate new trace_probe and initialize it (including kprobes).
+ */
+static struct trace_probe *alloc_trace_probe(const char *event,
+					     void *addr,
+					     const char *symbol,
+					     unsigned long offs,
+					     int nargs, int is_return)
 {
 	struct trace_probe *tp;
 
@@ -282,7 +275,16 @@ static struct trace_probe *alloc_trace_probe(const char *symbol,
 		tp->symbol = kstrdup(symbol, GFP_KERNEL);
 		if (!tp->symbol)
 			goto error;
-	}
+		tp->rp.kp.symbol_name = tp->symbol;
+		tp->rp.kp.offset = offs;
+	} else
+		tp->rp.kp.addr = addr;
+
+	if (is_return)
+		tp->rp.handler = kretprobe_trace_func;
+	else
+		tp->rp.kp.pre_handler = kprobe_trace_func;
+
 	if (!event)
 		goto error;
 	tp->call.name = kstrdup(event, GFP_KERNEL);
@@ -327,7 +329,7 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 	if (probe_is_return(tp))
 		unregister_kretprobe(&tp->rp);
 	else
-		unregister_kprobe(&tp->kp);
+		unregister_kprobe(&tp->rp.kp);
 }
 
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
@@ -349,14 +351,14 @@ static int register_trace_probe(struct trace_probe *tp)
 	if (probe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
-		ret = register_kprobe(&tp->kp);
+		ret = register_kprobe(&tp->rp.kp);
 
 	if (ret) {
 		pr_warning("Could not insert probe(%d)\n", ret);
 		if (ret == -EILSEQ) {
 			pr_warning("Probing address(0x%p) is not an "
 				   "instruction boundary.\n",
-				   probe_address(tp));
+				   tp->rp.kp.addr);
 			ret = -EINVAL;
 		}
 		goto end;
@@ -530,12 +532,12 @@ static int create_trace_probe(int argc, char **argv)
 	 *  +|-offs(ARG) : fetch memory at ARG +|- offs address.
 	 */
 	struct trace_probe *tp;
-	struct kprobe *kp;
 	int i, ret = 0;
 	int is_return = 0;
 	char *symbol = NULL, *event = NULL;
 	unsigned long offset = 0;
 	void *addr = NULL;
+	char buf[MAX_EVENT_NAME_LEN];
 
 	if (argc < 2)
 		return -EINVAL;
@@ -577,33 +579,18 @@ static int create_trace_probe(int argc, char **argv)
 	/* setup a probe */
 	if (!event) {
 		/* Make a new event name */
-		char buf[MAX_EVENT_NAME_LEN];
 		if (symbol)
 			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@%s%+ld",
 				 is_return ? 'r' : 'p', symbol, offset);
 		else
 			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@0x%p",
 				 is_return ? 'r' : 'p', addr);
-		tp = alloc_trace_probe(symbol, buf, argc);
-	} else
-		tp = alloc_trace_probe(symbol, event, argc);
+		event = buf;
+	}
+	tp = alloc_trace_probe(event, addr, symbol, offset, argc, is_return);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
-	if (is_return) {
-		kp = &tp->rp.kp;
-		tp->rp.handler = kretprobe_trace_func;
-	} else {
-		kp = &tp->kp;
-		tp->kp.pre_handler = kprobe_trace_func;
-	}
-
-	if (tp->symbol) {
-		kp->symbol_name = tp->symbol;
-		kp->offset = (unsigned int)offset;
-	} else
-		kp->addr = addr;
-
 	/* parse arguments */
 	ret = 0;
 	for (i = 0; i < argc && i < MAX_TRACE_ARGS; i++) {
@@ -670,9 +657,9 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	seq_printf(m, ":%s", tp->call.name);
 
 	if (tp->symbol)
-		seq_printf(m, " %s+%u", probe_symbol(tp), probe_offset(tp));
+		seq_printf(m, " %s+%u", probe_symbol(tp), tp->rp.kp.offset);
 	else
-		seq_printf(m, " 0x%p", probe_address(tp));
+		seq_printf(m, " 0x%p", tp->rp.kp.addr);
 
 	for (i = 0; i < tp->nr_args; i++) {
 		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i]);
@@ -783,7 +770,7 @@ static int probes_profile_seq_show(struct seq_file *m, void *v)
 	struct trace_probe *tp = v;
 
 	seq_printf(m, "  %-44s %15lu %15lu\n", tp->call.name, tp->nhit,
-		   probe_is_return(tp) ? tp->rp.kp.nmissed : tp->kp.nmissed);
+		   tp->rp.kp.nmissed);
 
 	return 0;
 }
@@ -811,7 +798,7 @@ static const struct file_operations kprobe_profile_ops = {
 /* Kprobe handler */
 static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
-	struct trace_probe *tp = container_of(kp, struct trace_probe, kp);
+	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct kprobe_trace_entry *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
@@ -866,7 +853,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	entry = ring_buffer_event_data(event);
 	entry->nargs = tp->nr_args;
-	entry->func = (unsigned long)probe_address(tp);
+	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	for (i = 0; i < tp->nr_args; i++)
 		entry->args[i] = call_fetch(&tp->args[i], regs);
@@ -945,7 +932,7 @@ static int probe_event_enable(struct ftrace_event_call *call)
 	if (probe_is_return(tp))
 		return enable_kretprobe(&tp->rp);
 	else
-		return enable_kprobe(&tp->kp);
+		return enable_kprobe(&tp->rp.kp);
 }
 
 static void probe_event_disable(struct ftrace_event_call *call)
@@ -955,7 +942,7 @@ static void probe_event_disable(struct ftrace_event_call *call)
 	if (probe_is_return(tp))
 		disable_kretprobe(&tp->rp);
 	else
-		disable_kprobe(&tp->kp);
+		disable_kprobe(&tp->rp.kp);
 }
 
 static int probe_event_raw_init(struct ftrace_event_call *event_call)
-- 
1.6.2.3

