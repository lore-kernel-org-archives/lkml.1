Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZIVTjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZIVTjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZIVTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:39:30 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49576 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZIVTj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ReGGqlJMx8JXDhX1BfXc8TG7W4nrakzt5sqndz/LFyHPFc5IZKnxvkfPidq9NbwyTR
         j5w5/Ji/SY+ASssroySGmwBAtOlVHOFDF0AZZbdf2HH7/xdjOWpmJgGLmUVJA3nuLD/V
         SuK5e4/p1Nb6CSNTa+jSaHIeDOrPr3px/koBQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 21/24] tracing/kprobes: Add probe handler dispatcher to support perf and ftrace concurrent use
Date: Tue, 22 Sep 2009 21:38:19 +0200
Message-Id: <1253648302-5771-22-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add kprobe_dispatcher and kretprobe_dispatcher to dispatch event
in both profile and tracing handlers.

This allows simultaneous kprobe uses by ftrace and perf.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090914204920.18779.57555.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
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
1.6.2.3

