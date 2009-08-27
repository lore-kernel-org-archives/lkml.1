Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbZH0Cc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbZH0Cc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 22:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbZH0Ccu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 22:32:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:42091 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206AbZH0Ccs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 22:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=N9Ai2yqnND6qCP0U6GCqmYThssVLpT43G1RsOwW268lCNYq3LpYJxh8WDuYyxpO+r6
         vxWG07jSxblzeCJ55Y5v8Cgt0KDcC4XrJ4e0am5iiWlW+cnbs/Ajhss++n8/zIWsT4nn
         sUsS1lNu8Yobk+j+vmvKDKjNCkdFE4m3jHORk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Avi Kivity <avi@redhat.com>, Andi Kleen <ak@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       =?utf-8?q?Przemys=C5=82aw=20Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/18] tracing: Generate names for each kprobe event automatically
Date: Thu, 27 Aug 2009 04:32:10 +0200
Message-Id: <1251340337-5640-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Generate names for each kprobe event based on the probe point.
(SYMBOL+offs or MEMADDR).

Also remove generic k*probe event types because there is no user
of those types.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
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
LKML-Reference: <20090813203526.31965.56672.stgit@localhost.localdomain>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |    3 +-
 kernel/trace/trace_event_types.h    |   18 ----------
 kernel/trace/trace_kprobe.c         |   64 ++++++++++++++++++-----------------
 3 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index c9c09b4..5e59e85 100644
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
index 6d488ef..8aeb24c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -34,6 +34,7 @@
 
 #define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
 
 /* currently, trace_kprobe only supports X86. */
 
@@ -280,11 +281,11 @@ static struct trace_probe *alloc_trace_probe(const char *symbol,
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
@@ -314,7 +315,7 @@ static struct trace_probe *find_probe_event(const char *event)
 	struct trace_probe *tp;
 
 	list_for_each_entry(tp, &probe_list, list)
-		if (tp->call.name && !strcmp(tp->call.name, event))
+		if (!strcmp(tp->call.name, event))
 			return tp;
 	return NULL;
 }
@@ -330,8 +331,7 @@ static void __unregister_trace_probe(struct trace_probe *tp)
 /* Unregister a trace_probe and probe_event: call with locking probe_lock */
 static void unregister_trace_probe(struct trace_probe *tp)
 {
-	if (tp->call.name)
-		unregister_probe_event(tp);
+	unregister_probe_event(tp);
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
 }
@@ -360,18 +360,16 @@ static int register_trace_probe(struct trace_probe *tp)
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
@@ -580,7 +578,18 @@ static int create_trace_probe(int argc, char **argv)
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
 
@@ -661,8 +670,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	char buf[MAX_ARGSTR_LEN + 1];
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
-	if (tp->call.name)
-		seq_printf(m, ":%s", tp->call.name);
+	seq_printf(m, ":%s", tp->call.name);
 
 	if (tp->symbol)
 		seq_printf(m, " %s%+ld", probe_symbol(tp), probe_offset(tp));
@@ -780,10 +788,7 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
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
@@ -815,10 +820,7 @@ static __kprobes int kretprobe_trace_func(struct kretprobe_instance *ri,
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
1.6.2.3

