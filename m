Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZIJXwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZIJXwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZIJXwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:52:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbZIJXwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:52:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event profiling
	support
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
Date: Thu, 10 Sep 2009 19:53:30 -0400
Message-ID: <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add *probe_profile_enable/disable for supporting perf tool
when CONFIG_PROFILE_EVENT=y.

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

 Documentation/trace/kprobetrace.txt |    4 +
 kernel/trace/trace_kprobe.c         |  110 ++++++++++++++++++++++++++++++++++-
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index db55318..8f882eb 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -62,13 +62,15 @@ enabled:
   You can enable/disable the probe by writing 1 or 0 on it.
 
 format:
-  It shows the format of this probe event. It also shows aliases of arguments
+  This shows the format of this probe event. It also shows aliases of arguments
  which you specified to kprobe_events.
 
 filter:
   You can write filtering rules of this event. And you can use both of aliase
  names and field names for describing filters.
 
+id:
+  This shows the id of this probe event.
 
 Event Profiling
 ---------------
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 902a148..21ffb5e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -28,6 +28,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/ptrace.h>
+#include <linux/perf_counter.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -280,6 +281,7 @@ static struct trace_probe *alloc_trace_probe(const char *event,
 	} else
 		tp->rp.kp.addr = addr;
 
+	/* Set handler here for checking whether this probe is return or not. */
 	if (is_return)
 		tp->rp.handler = kretprobe_trace_func;
 	else
@@ -927,10 +929,13 @@ static int probe_event_enable(struct ftrace_event_call *call)
 {
 	struct trace_probe *tp = (struct trace_probe *)call->data;
 
-	if (probe_is_return(tp))
+	if (probe_is_return(tp)) {
+		tp->rp.handler = kretprobe_trace_func;
 		return enable_kretprobe(&tp->rp);
-	else
+	} else {
+		tp->rp.kp.pre_handler = kprobe_trace_func;
 		return enable_kprobe(&tp->rp.kp);
+	}
 }
 
 static void probe_event_disable(struct ftrace_event_call *call)
@@ -1103,6 +1108,101 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 					  "func, ret_ip");
 }
 
+#ifdef CONFIG_EVENT_PROFILE
+
+/* Kprobe profile handler */
+static __kprobes int kprobe_profile_func(struct kprobe *kp,
+					 struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
+	struct ftrace_event_call *call = &tp->call;
+	struct kprobe_trace_entry *entry;
+	int size, i, pc;
+	unsigned long irq_flags;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+
+	do {
+		char raw_data[size];
+		struct trace_entry *ent;
+
+		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+		entry = (struct kprobe_trace_entry *)raw_data;
+		ent = &entry->ent;
+
+		tracing_generic_entry_update(ent, irq_flags, pc);
+		ent->type = call->id;
+		entry->nargs = tp->nr_args;
+		entry->ip = (unsigned long)kp->addr;
+		for (i = 0; i < tp->nr_args; i++)
+			entry->args[i] = call_fetch(&tp->args[i], regs);
+		perf_tpcounter_event(call->id, entry->ip, 1, entry, size);
+	} while (0);
+	return 0;
+}
+
+/* Kretprobe profile handler */
+static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
+					    struct pt_regs *regs)
+{
+	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
+	struct ftrace_event_call *call = &tp->call;
+	struct kretprobe_trace_entry *entry;
+	int size, i, pc;
+	unsigned long irq_flags;
+
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
+	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+
+	do {
+		char raw_data[size];
+		struct trace_entry *ent;
+
+		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+		entry = (struct kretprobe_trace_entry *)raw_data;
+		ent = &entry->ent;
+
+		tracing_generic_entry_update(ent, irq_flags, pc);
+		ent->type = call->id;
+		entry->nargs = tp->nr_args;
+		entry->func = (unsigned long)tp->rp.kp.addr;
+		entry->ret_ip = (unsigned long)ri->ret_addr;
+		for (i = 0; i < tp->nr_args; i++)
+			entry->args[i] = call_fetch(&tp->args[i], regs);
+		perf_tpcounter_event(call->id, entry->ret_ip, 1, entry, size);
+	} while (0);
+	return 0;
+}
+
+static int probe_profile_enable(struct ftrace_event_call *call)
+{
+	struct trace_probe *tp = (struct trace_probe *)call->data;
+
+	if (atomic_inc_return(&call->profile_count))
+		return 0;
+
+	if (probe_is_return(tp)) {
+		tp->rp.handler = kretprobe_profile_func;
+		return enable_kretprobe(&tp->rp);
+	} else {
+		tp->rp.kp.pre_handler = kprobe_profile_func;
+		return enable_kprobe(&tp->rp.kp);
+	}
+}
+
+static void probe_profile_disable(struct ftrace_event_call *call)
+{
+	if (atomic_add_negative(-1, &call->profile_count))
+		probe_event_disable(call);
+}
+
+#endif	/* CONFIG_EVENT_PROFILE */
+
 static int register_probe_event(struct trace_probe *tp)
 {
 	struct ftrace_event_call *call = &tp->call;
@@ -1128,6 +1228,12 @@ static int register_probe_event(struct trace_probe *tp)
 	call->enabled = 1;
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
+
+#ifdef CONFIG_EVENT_PROFILE
+	atomic_set(&call->profile_count, -1);
+	call->profile_enable = probe_profile_enable;
+	call->profile_disable = probe_profile_disable;
+#endif
 	call->data = tp;
 	ret = trace_add_event_call(call);
 	if (ret) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
