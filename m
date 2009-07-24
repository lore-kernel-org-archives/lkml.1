Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbZGXUEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbZGXUEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754132AbZGXUEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:04:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55352 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbZGXUD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:03:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v13 10/11] tracing: Generate names for each kprobe event
	automatically
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Date: Fri, 24 Jul 2009 16:06:27 -0400
Message-ID: <20090724200627.25904.68559.stgit@localhost.localdomain>
In-Reply-To: <20090724200527.25904.2562.stgit@localhost.localdomain>
References: <20090724200527.25904.2562.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate names for each kprobe event based on the probe point,
and remove generic k*probe event types because there is no user
of those types.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---

 Documentation/trace/kprobetrace.txt |    3 +-
 kernel/trace/trace_event_types.h    |   18 ----------
 kernel/trace/trace_kprobe.c         |   64 ++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index b29a54b..437ad49 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -28,7 +28,8 @@ Synopsis of kprobe_events
   p[:EVENT] SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: Set a probe
   r[:EVENT] SYMBOL[+0] [FETCHARGS]			: Set a return probe
 
- EVENT			: Event name.
+ EVENT			: Event name. If omitted, the event name is generated
+			  based on SYMBOL+offs or MEMADDR.
  SYMBOL[+offs|-offs]	: Symbol+offset where the probe is inserted.
  MEMADDR		: Address where the probe is inserted.
 
diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
index 186b598..e74f090 100644
--- a/kernel/trace/trace_event_types.h
+++ b/kernel/trace/trace_event_types.h
@@ -175,22 +175,4 @@ TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
 	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
 );
 
-TRACE_EVENT_FORMAT(kprobe, TRACE_KPROBE, kprobe_trace_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, ip, ip)
-		TRACE_FIELD(int, nargs, nargs)
-		TRACE_FIELD_ZERO(unsigned long, args)
-	),
-	TP_RAW_FMT("%08lx: args:0x%lx ...")
-);
-
-TRACE_EVENT_FORMAT(kretprobe, TRACE_KRETPROBE, kretprobe_trace_entry, ignore,
-	TRACE_STRUCT(
-		TRACE_FIELD(unsigned long, func, func)
-		TRACE_FIELD(unsigned long, ret_ip, ret_ip)
-		TRACE_FIELD(int, nargs, nargs)
-		TRACE_FIELD_ZERO(unsigned long, args)
-	),
-	TP_RAW_FMT("%08lx <- %08lx: args:0x%lx ...")
-);
 #undef TRACE_SYSTEM
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e78c4ea..9f9f161 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -34,6 +34,7 @@
 
 #define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
 
 /* currently, trace_kprobe only supports X86. */
 
@@ -272,11 +273,11 @@ static struct trace_probe *alloc_trace_probe(const char *symbol,
 		if (!tp->symbol)
 			goto error;
 	}
-	if (event) {
-		tp->call.name = kstrdup(event, GFP_KERNEL);
-		if (!tp->call.name)
-			goto error;
-	}
+	if (!event)
+		goto error;
+	tp->call.name = kstrdup(event, GFP_KERNEL);
+	if (!tp->call.name)
+		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
 	return tp;
@@ -306,7 +307,7 @@ static struct trace_probe *find_probe_event(const char *event)
 	struct trace_probe *tp;
 
 	list_for_each_entry(tp, &probe_list, list)
-		if (tp->call.name && !strcmp(tp->call.name, event))
+		if (!strcmp(tp->call.name, event))
 			return tp;
 	return NULL;
 }
@@ -322,8 +323,7 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static void unregister_trace_probe(struct trace_probe *tp)
 {
-	if (tp->call.name)
-		unregister_probe_event(tp);
+	unregister_probe_event(tp);
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 }
@@ -352,18 +352,16 @@ static int register_trace_probe(struct trace_probe *tp)
 		goto end;
 	}
 	/* register as an event */
-	if (tp->call.name) {
-		old_tp = find_probe_event(tp->call.name);
-		if (old_tp) {
-			/* delete old event */
-			unregister_trace_probe(old_tp);
-			free_trace_probe(old_tp);
-		}
-		ret = register_probe_event(tp);
-		if (ret) {
-			pr_warning("Faild to register probe event(%d)\n", ret);
-			__unregister_trace_probe(tp);
-		}
+	old_tp = find_probe_event(tp->call.name);
+	if (old_tp) {
+		/* delete old event */
+		unregister_trace_probe(old_tp);
+		free_trace_probe(old_tp);
+	}
+	ret = register_probe_event(tp);
+	if (ret) {
+		pr_warning("Faild to register probe event(%d)\n", ret);
+		__unregister_trace_probe(tp);
 	}
 	list_add_tail(&tp->list, &probe_list);
 end:
@@ -566,7 +564,18 @@ static int create_trace_probe(int argc, char **argv)
 	argc -= 2; argv += 2;
 
 	/* setup a probe */
-	tp = alloc_trace_probe(symbol, event, argc);
+	if (!event) {
+		/* Make a new event name */
+		char buf[MAX_EVENT_NAME_LEN];
+		if (symbol)
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@%s%+ld",
+				 is_return ? 'r' : 'p', symbol, offset);
+		else
+			snprintf(buf, MAX_EVENT_NAME_LEN, "%c@0x%p",
+				 is_return ? 'r' : 'p', addr);
+		tp = alloc_trace_probe(symbol, buf, argc);
+	} else
+		tp = alloc_trace_probe(symbol, event, argc);
 	if (IS_ERR(tp))
 		return PTR_ERR(tp);
 
@@ -647,8 +656,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char buf[MAX_ARGSTR_LEN + 1];
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	if (tp->call.name)
-		seq_printf(m, ":%s", tp->call.name);
+	seq_printf(m, ":%s", tp->call.name);
 
 	if (tp->symbol)
 		seq_printf(m, " %s%+ld", probe_symbol(tp), probe_offset(tp));
@@ -766,10 +774,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	struct ring_buffer_event *event;
 	int size, i, pc;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &event_kprobe;
-
-	if (&tp->call.name)
-		call = &tp->call;
+	struct ftrace_event_call *call = &tp->call;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
@@ -801,10 +806,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
 	struct ring_buffer_event *event;
 	int size, i, pc;
 	unsigned long irq_flags;
-	struct ftrace_event_call *call = &event_kretprobe;
-
-	if (&tp->call.name)
-		call = &tp->call;
+	struct ftrace_event_call *call = &tp->call;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
