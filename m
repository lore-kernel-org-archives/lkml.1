Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZINUr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZINUr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbZINUr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbZINUrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:47:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 4/6] tracing/kprobes: Add probe handler
	dispatcher for support perf and ftrace
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
Date: Mon, 14 Sep 2009 16:49:20 -0400
Message-ID: <20090914204920.18779.57555.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add kprobe_dispatcher and kretprobe_dispatcher for dispatching event
to both of profile handler and tracing handler.

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

 kernel/trace/trace_kprobe.c |   85 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index ea0db8e..70b632c 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -185,10 +185,15 @@ struct probe_arg {
 	const char		*name;
 };
 
+/* Flags for trace_probe */
+#define TP_FLAG_TRACE	1
+#define TP_FLAG_PROFILE	2
+
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
 	unsigned long 		nhit;
+	unsigned int		flags;	/* For TP_FLAG_* */
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
 	struct trace_event		event;
@@ -200,10 +205,6 @@ struct trace_probe {
 	(offsetof(struct trace_probe, args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
-static int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs);
-static int kretprobe_trace_func(struct kretprobe_instance *ri,
-				struct pt_regs *regs);
-
 static __kprobes int probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler != NULL;
@@ -263,6 +264,10 @@ static void unregister_probe_event(struct trace_probe *tp);
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
 
+static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
+static int kretprobe_dispatcher(struct kretprobe_instance *ri,
+				struct pt_regs *regs);
+
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -288,11 +293,10 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	} else
 		tp->rp.kp.addr = addr;
 
-	/* Set handler here for checking whether this probe is return or not. */
 	if (is_return)
-		tp->rp.handler = kretprobe_trace_func;
+		tp->rp.handler = kretprobe_dispatcher;
 	else
-		tp->rp.kp.pre_handler = kprobe_trace_func;
+		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
 	if (!event)
 		goto error;
@@ -379,6 +383,7 @@ static int register_trace_probe(struct trace_probe *tp)
 		goto end;
 	}
 
+	tp->flags = TP_FLAG_TRACE;
 	if (probe_is_return(tp))
 		ret = register_kretprobe(&tp->rp);
 	else
@@ -987,23 +992,24 @@ static int probe_event_enable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
-	if (probe_is_return(tp)) {
-		tp->rp.handler = kretprobe_trace_func;
+	tp->flags |= TP_FLAG_TRACE;
+	if (probe_is_return(tp))
 		return enable_kretprobe(&tp->rp);
-	} else {
-		tp->rp.kp.pre_handler = kprobe_trace_func;
+	else
 		return enable_kprobe(&tp->rp.kp);
-	}
 }
 
 static void probe_event_disable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
-	if (probe_is_return(tp))
-		disable_kretprobe(&tp->rp);
-	else
-		disable_kprobe(&tp->rp.kp);
+	tp->flags &= ~TP_FLAG_TRACE;
+	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
+		if (probe_is_return(tp))
+			disable_kretprobe(&tp->rp);
+		else
+			disable_kprobe(&tp->rp.kp);
+	}
 }
 
 static int probe_event_raw_init(struct ftrace_event_call *event_call)
@@ -1212,22 +1218,57 @@ static int probe_profile_enable(struct ftrace_event_call *call)
 	if (atomic_inc_return(&call->profile_count))
 		return 0;
 
-	if (probe_is_return(tp)) {
-		tp->rp.handler = kretprobe_profile_func;
+	tp->flags |= TP_FLAG_PROFILE;
+	if (probe_is_return(tp))
 		return enable_kretprobe(&tp->rp);
-	} else {
-		tp->rp.kp.pre_handler = kprobe_profile_func;
+	else
 		return enable_kprobe(&tp->rp.kp);
-	}
 }
 
 static void probe_profile_disable(struct ftrace_event_call *call)
 {
+	struct trace_probe *tp = (struct trace_probe *)call->data;
+
 	if (atomic_add_negative(-1, &call->profile_count))
-		probe_event_disable(call);
+		tp->flags &= ~TP_FLAG_PROFILE;
+
+	if (!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE))) {
+		if (probe_is_return(tp))
+			disable_kretprobe(&tp->rp);
+		else
+			disable_kprobe(&tp->rp.kp);
+	}
 }
+#endif	/* CONFIG_EVENT_PROFILE */
+
+
+static __kprobes
+int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 
+	if (tp->flags & TP_FLAG_TRACE)
+		kprobe_trace_func(kp, regs);
+#ifdef CONFIG_EVENT_PROFILE
+	if (tp->flags & TP_FLAG_PROFILE)
+		kprobe_profile_func(kp, regs);
 #endif	/* CONFIG_EVENT_PROFILE */
+	return 0;	/* We don't tweek kernel, so just return 0 */
+}
+
+static __kprobes
+int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+
+	if (tp->flags & TP_FLAG_TRACE)
+		kretprobe_trace_func(ri, regs);
+#ifdef CONFIG_EVENT_PROFILE
+	if (tp->flags & TP_FLAG_PROFILE)
+		kretprobe_profile_func(ri, regs);
+#endif	/* CONFIG_EVENT_PROFILE */
+	return 0;	/* We don't tweek kernel, so just return 0 */
+}
 
 static int register_probe_event(struct trace_probe *tp)
 {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
