Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbZHMUee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbZHMUee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932505AbZHMUeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:34:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33163 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZHMUda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:33:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v14 11/12] tracing: Kprobe tracer assigns new event ids
	for each event
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 13 Aug 2009 16:35:34 -0400
Message-ID: <20090813203534.31965.49105.stgit@localhost.localdomain>
In-Reply-To: <20090813203403.31965.20973.stgit@localhost.localdomain>
References: <20090813203403.31965.20973.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigns new event ids for each kprobes event. This doesn't clear ring_buffer
when unregistering each kprobe event. Thus, if you mind 'Unknown event'
messages, clear the buffer manually after changing kprobe events.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
---

 kernel/trace/trace.h        |    6 -----
 kernel/trace/trace_kprobe.c |   51 +++++++++++++------------------------------
 2 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4ce4525..0b78d76 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -43,8 +43,6 @@ enum trace_type {
 	TRACE_POWER,
 	TRACE_BLK,
 	TRACE_KSYM,
-	TRACE_KPROBE,
-	TRACE_KRETPROBE,
 
 	__TRACE_LAST_TYPE,
 };
@@ -358,10 +356,6 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
 			  TRACE_KMEM_FREE);	\
 		IF_ASSIGN(var, ent, struct ksym_trace_entry, TRACE_KSYM);\
-		IF_ASSIGN(var, ent, struct kprobe_trace_entry,		\
-			  TRACE_KPROBE);				\
-		IF_ASSIGN(var, ent, struct kretprobe_trace_entry,	\
-			  TRACE_KRETPROBE);				\
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ec137ed..0e8498e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -186,6 +186,7 @@ struct trace_probe {
 	};
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
+	struct trace_event		event;
 	unsigned int		nr_args;
 	struct fetch_func	args[];
 };
@@ -795,7 +796,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 
-	event = trace_current_buffer_lock_reserve(TRACE_KPROBE, size,
+	event = trace_current_buffer_lock_reserve(call->id, size,
 						  irq_flags, pc);
 	if (!event)
 		return 0;
@@ -827,7 +828,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 
 	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 
-	event = trace_current_buffer_lock_reserve(TRACE_KRETPROBE, size,
+	event = trace_current_buffer_lock_reserve(call->id, size,
 						  irq_flags, pc);
 	if (!event)
 		return 0;
@@ -853,7 +854,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 	struct trace_seq *s = &iter->seq;
 	int i;
 
-	trace_assign_type(field, iter->ent);
+	field = (struct kprobe_trace_entry *)iter->ent;
 
 	if (!seq_print_ip_sym(s, field->ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
@@ -880,7 +881,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 	struct trace_seq *s = &iter->seq;
 	int i;
 
-	trace_assign_type(field, iter->ent);
+	field = (struct kretprobe_trace_entry *)iter->ent;
 
 	if (!seq_print_ip_sym(s, field->ret_ip, flags | TRACE_ITER_SYM_OFFSET))
 		goto partial;
@@ -906,16 +907,6 @@ partial:
 	return TRACE_TYPE_PARTIAL_LINE;
 }
 
-static struct trace_event kprobe_trace_event = {
-	.type	 	= TRACE_KPROBE,
-	.trace		= print_kprobe_event,
-};
-
-static struct trace_event kretprobe_trace_event = {
-	.type	 	= TRACE_KRETPROBE,
-	.trace		= print_kretprobe_event,
-};
-
 static int probe_event_enable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
@@ -1107,35 +1098,35 @@ static int register_probe_event(struct trace_probe *tp)
 	/* Initialize ftrace_event_call */
 	call->system = "kprobes";
 	if (probe_is_return(tp)) {
-		call->event = &kretprobe_trace_event;
-		call->id = TRACE_KRETPROBE;
+		tp->event.trace = print_kretprobe_event;
 		call->raw_init = probe_event_raw_init;
 		call->show_format = kretprobe_event_show_format;
 		call->define_fields = kretprobe_event_define_fields;
 	} else {
-		call->event = &kprobe_trace_event;
-		call->id = TRACE_KPROBE;
+		tp->event.trace = print_kprobe_event;
 		call->raw_init = probe_event_raw_init;
 		call->show_format = kprobe_event_show_format;
 		call->define_fields = kprobe_event_define_fields;
 	}
+	call->event = &tp->event;
+	call->id = register_ftrace_event(&tp->event);
+	if (!call->id)
+		return -ENODEV;
 	call->enabled = 1;
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
 	call->data = tp;
 	ret = trace_add_event_call(call);
-	if (ret)
+	if (ret) {
 		pr_info("Failed to register kprobe event: %s\n", call->name);
+		unregister_ftrace_event(&tp->event);
+	}
 	return ret;
 }
 
 static void unregister_probe_event(struct trace_probe *tp)
 {
-	/*
-	 * Prevent to unregister event itself because the event is shared
-	 * among other probes.
-	 */
-	tp->call.event = NULL;
+	/* tp->event is unregistered in trace_remove_event_call() */
 	trace_remove_event_call(&tp->call);
 }
 
@@ -1144,18 +1135,6 @@ static __init int init_kprobe_trace(void)
 {
 	struct dentry *d_tracer;
 	struct dentry *entry;
-	int ret;
-
-	ret = register_ftrace_event(&kprobe_trace_event);
-	if (!ret) {
-		pr_warning("Could not register kprobe_trace_event type.\n");
-		return 0;
-	}
-	ret = register_ftrace_event(&kretprobe_trace_event);
-	if (!ret) {
-		pr_warning("Could not register kretprobe_trace_event type.\n");
-		return 0;
-	}
 
 	d_tracer = tracing_init_dentry();
 	if (!d_tracer)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
