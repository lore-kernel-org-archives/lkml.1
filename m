Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZJCCbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZJCCbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZJCCbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:31:34 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60874 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZJCCbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JuI3AAqvTFWdAsI0SHvfRDBLDVETvgwPWZM4L+Zr+EQxBEWFq1HxiwZ8caWtE2DpoM
         qyU8MI7UEmca8l9zsWTPhOzbIeGCfayAsPcPf6VZ4FB8PPKfokgOxzuoF/ta3sSgUd7C
         Wknu+WVJRh6fPY4UhEtOH8fIt4hRXCUbXk5Ng=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] tracing/kprobes: Use global event perf buffers in kprobe tracer
Date: Sat,  3 Oct 2009 04:31:29 +0200
Message-Id: <1254537091-4993-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
References: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Use new percpu global event buffer instead of stack in kprobe
tracer while tracing through perf.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090925182011.10157.60140.stgit@omoto>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_kprobe.c |  115 +++++++++++++++++++++++++++----------------
 1 files changed, 73 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 09cba27..97309d4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1149,35 +1149,49 @@ static __kprobes int kprobe_profile_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry *entry;
-	int size, __size, i, pc;
+	struct trace_entry *ent;
+	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
+	char *raw_data;
 
-	local_save_flags(irq_flags);
 	pc = preempt_count();
-
 	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
+	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+		     "profile buffer not large enough"))
+		return 0;
 
-	do {
-		char raw_data[size];
-		struct trace_entry *ent;
-		/*
-		 * Zero dead bytes from alignment to avoid stack leak
-		 * to userspace
-		 */
-		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
-		entry = (struct kprobe_trace_entry *)raw_data;
-		ent = &entry->ent;
-
-		tracing_generic_entry_update(ent, irq_flags, pc);
-		ent->type = call->id;
-		entry->nargs = tp->nr_args;
-		entry->ip = (unsigned long)kp->addr;
-		for (i = 0; i < tp->nr_args; i++)
-			entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
-		perf_tp_event(call->id, entry->ip, 1, entry, size);
-	} while (0);
+	/*
+	 * Protect the non nmi buffer
+	 * This also protects the rcu read side
+	 */
+	local_irq_save(irq_flags);
+	__cpu = smp_processor_id();
+
+	if (in_nmi())
+		raw_data = rcu_dereference(trace_profile_buf_nmi);
+	else
+		raw_data = rcu_dereference(trace_profile_buf);
+
+	if (!raw_data)
+		goto end;
+
+	raw_data = per_cpu_ptr(raw_data, __cpu);
+	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
+	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+	entry = (struct kprobe_trace_entry *)raw_data;
+	ent = &entry->ent;
+
+	tracing_generic_entry_update(ent, irq_flags, pc);
+	ent->type = call->id;
+	entry->nargs = tp->nr_args;
+	entry->ip = (unsigned long)kp->addr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+	perf_tp_event(call->id, entry->ip, 1, entry, size);
+end:
+	local_irq_restore(irq_flags);
 	return 0;
 }
 
@@ -1188,33 +1202,50 @@ static __kprobes int kretprobe_profile_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry *entry;
-	int size, __size, i, pc;
+	struct trace_entry *ent;
+	int size, __size, i, pc, __cpu;
 	unsigned long irq_flags;
+	char *raw_data;
 
-	local_save_flags(irq_flags);
 	pc = preempt_count();
-
 	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
+	if (WARN_ONCE(size > FTRACE_MAX_PROFILE_SIZE,
+		     "profile buffer not large enough"))
+		return 0;
+
+	/*
+	 * Protect the non nmi buffer
+	 * This also protects the rcu read side
+	 */
+	local_irq_save(irq_flags);
+	__cpu = smp_processor_id();
+
+	if (in_nmi())
+		raw_data = rcu_dereference(trace_profile_buf_nmi);
+	else
+		raw_data = rcu_dereference(trace_profile_buf);
+
+	if (!raw_data)
+		goto end;
+
+	raw_data = per_cpu_ptr(raw_data, __cpu);
+	/* Zero dead bytes from alignment to avoid buffer leak to userspace */
+	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+	entry = (struct kretprobe_trace_entry *)raw_data;
+	ent = &entry->ent;
 
-	do {
-		char raw_data[size];
-		struct trace_entry *ent;
-
-		*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
-		entry = (struct kretprobe_trace_entry *)raw_data;
-		ent = &entry->ent;
-
-		tracing_generic_entry_update(ent, irq_flags, pc);
-		ent->type = call->id;
-		entry->nargs = tp->nr_args;
-		entry->func = (unsigned long)tp->rp.kp.addr;
-		entry->ret_ip = (unsigned long)ri->ret_addr;
-		for (i = 0; i < tp->nr_args; i++)
-			entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
-		perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
-	} while (0);
+	tracing_generic_entry_update(ent, irq_flags, pc);
+	ent->type = call->id;
+	entry->nargs = tp->nr_args;
+	entry->func = (unsigned long)tp->rp.kp.addr;
+	entry->ret_ip = (unsigned long)ri->ret_addr;
+	for (i = 0; i < tp->nr_args; i++)
+		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+	perf_tp_event(call->id, entry->ret_ip, 1, entry, size);
+end:
+	local_irq_restore(irq_flags);
 	return 0;
 }
 
-- 
1.6.2.3

