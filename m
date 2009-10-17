Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbZJQKDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbZJQKDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbZJQKDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:03:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:36554 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbZJQKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:03:10 -0400
Date: Sat, 17 Oct 2009 10:02:24 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090925182011.10157.60140.stgit@omoto>
References: <20090925182011.10157.60140.stgit@omoto>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] tracing/kprobes: Use global event perf buffers in kprobe tracer
Message-ID: <tip-a1a138d05fa060ac4238c19a1e890aacc25ed3ba@git.kernel.org>
Git-Commit-ID: a1a138d05fa060ac4238c19a1e890aacc25ed3ba
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:02:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1a138d05fa060ac4238c19a1e890aacc25ed3ba
Gitweb:     http://git.kernel.org/tip/a1a138d05fa060ac4238c19a1e890aacc25ed3ba
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 25 Sep 2009 11:20:12 -0700
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 3 Oct 2009 02:21:39 +0200

tracing/kprobes: Use global event perf buffers in kprobe tracer

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
 
