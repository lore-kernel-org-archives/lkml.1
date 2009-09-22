Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZIVTlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZIVTlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZIVTl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:41:29 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:39120 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZIVTi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GJllO2MAwdZN8unscWUDqGUcHeqX62wZgC1kzCiuQPe21/i4kEGv340nrZQYJQHOx5
         ZHPypi7zMA4GvFUAmxBaC2NdTyMj5/eCp7leeNanfobSwKmGDb0tvRPzXFTIPBWgkY6E
         UUKiEB5tuB9xfwr2z8nP6xNv5lnmZf47Kyq+g=
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
Subject: [PATCH 14/24] tracing/kprobes: Add event profiling support
Date: Tue, 22 Sep 2009 21:38:12 +0200
Message-Id: <1253648302-5771-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add *probe_profile_enable/disable to support kprobes raw events
sampling from perf counters, like other ftrace events, when
CONFIG_PROFILE_EVENT=y.

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
LKML-Reference: <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 Documentation/trace/kprobetrace.txt |    4 +-
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
index 4ce728c..730e992 100644
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
@@ -929,10 +931,13 @@ static int probe_event_enable(struct ftrace_event_call *call)
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
@@ -1105,6 +1110,101 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
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
@@ -1130,6 +1230,12 @@ static int register_probe_event(struct trace_probe *tp)
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
1.6.2.3

