Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYAOU7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYAOU7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbYAOUvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:51:03 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:65124 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYAOUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:37 -0500
Message-Id: <20080115205023.242197006@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 12/30 v3] separate out the percpu date into a percpu struct
Content-Disposition: inline; filename=mcount-tracer-percpu-struct.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For better cacheline performance, this patch creates a separate
struct for each CPU with the percpu data grouped together.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   42 +++++++++++++++++++++++-------------------
 lib/tracing/tracer.h |   12 ++++++++----
 2 files changed, 31 insertions(+), 23 deletions(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-14 14:57:43.000000000 -0500
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/linkage.h>
 #include <linux/seq_file.h>
+#include <linux/percpu.h>
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
 #include <linux/uaccess.h>
@@ -25,6 +26,7 @@
 #include "tracer_interface.h"
 
 static struct mctracer_trace mctracer_trace;
+static DEFINE_PER_CPU(struct mctracer_trace_cpu, mctracer_trace_cpu);
 static int trace_enabled __read_mostly;
 
 static inline notrace void
@@ -36,21 +38,22 @@ mctracer_add_trace_entry(struct mctracer
 	unsigned long idx, idx_next;
 	struct mctracer_entry *entry;
 	struct task_struct *tsk = current;
+	struct mctracer_trace_cpu *data = tr->data[cpu];
 
-	idx = tr->trace_idx[cpu];
+	idx = data->trace_idx;
 	idx_next = idx + 1;
 
 	if (unlikely(idx_next >= tr->entries)) {
-		atomic_inc(&tr->underrun[cpu]);
+		atomic_inc(&data->underrun);
 		idx_next = 0;
 	}
 
-	tr->trace_idx[cpu] = idx_next;
+	data->trace_idx = idx_next;
 
-	if (unlikely(idx_next != 0 && atomic_read(&tr->underrun[cpu])))
-		atomic_inc(&tr->underrun[cpu]);
+	if (unlikely(idx_next != 0 && atomic_read(&data->underrun)))
+		atomic_inc(&data->underrun);
 
-	entry = tr->trace[cpu] + idx * MCTRACER_ENTRY_SIZE;
+	entry = data->trace + idx * MCTRACER_ENTRY_SIZE;
 	entry->idx	 = atomic_inc_return(&tr->cnt);
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
@@ -73,11 +76,11 @@ static notrace void trace_function(const
 
 	cpu = raw_smp_processor_id();
 
-	atomic_inc(&tr->disabled[cpu]);
-	if (likely(atomic_read(&tr->disabled[cpu]) == 1))
+	atomic_inc(&tr->data[cpu]->disabled);
+	if (likely(atomic_read(&tr->data[cpu]->disabled) == 1))
 		mctracer_add_trace_entry(tr, cpu, ip, parent_ip);
 
-	atomic_dec(&tr->disabled[cpu]);
+	atomic_dec(&tr->data[cpu]->disabled);
 
  out:
 	raw_local_irq_restore(flags);
@@ -93,8 +96,8 @@ static notrace void mctracer_reset(struc
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		tr->trace_idx[cpu] = 0;
-		atomic_set(&tr->underrun[cpu], 0);
+		tr->data[cpu]->trace_idx = 0;
+		atomic_set(&tr->data[cpu]->underrun, 0);
 	}
 }
 
@@ -115,16 +118,16 @@ static struct mctracer_entry *mctracer_e
 						 unsigned long idx,
 						 int cpu)
 {
-	struct mctracer_entry *array = tr->trace[cpu];
+	struct mctracer_entry *array = tr->data[cpu]->trace;
 	unsigned long underrun;
 
 	if (idx >= tr->entries)
 		return NULL;
 
-	underrun = atomic_read(&tr->underrun[cpu]);
+	underrun = atomic_read(&tr->data[cpu]->underrun);
 	if (underrun)
 		idx = ((underrun - 1) + idx) % tr->entries;
-	else if (idx >= tr->trace_idx[cpu])
+	else if (idx >= tr->data[cpu]->trace_idx)
 		return NULL;
 
 	return &array[idx];
@@ -139,7 +142,7 @@ static void *find_next_entry(struct mctr
 	int i;
 
 	for_each_possible_cpu(i) {
-		if (!tr->trace[i])
+		if (!tr->data[i]->trace)
 			continue;
 		ent = mctracer_entry_idx(tr, iter->next_idx[i], i);
 		if (ent && (!next || next->idx > ent->idx)) {
@@ -461,6 +464,7 @@ static notrace int mctracer_alloc_buffer
 	int i;
 
 	for_each_possible_cpu(i) {
+		mctracer_trace.data[i] = &per_cpu(mctracer_trace_cpu, i);
 		array = (struct mctracer_entry *)
 			  __get_free_pages(GFP_KERNEL, order);
 		if (array == NULL) {
@@ -468,7 +472,7 @@ static notrace int mctracer_alloc_buffer
 			       " %ld bytes for trace buffer!\n", size);
 			goto free_buffers;
 		}
-		mctracer_trace.trace[i] = array;
+		mctracer_trace.data[i]->trace = array;
 	}
 
 	/*
@@ -489,10 +493,10 @@ static notrace int mctracer_alloc_buffer
 
  free_buffers:
 	for (i-- ; i >= 0; i--) {
-		if (mctracer_trace.trace[i]) {
-			free_pages((unsigned long)mctracer_trace.trace[i],
+		if (mctracer_trace.data[i] && mctracer_trace.data[i]->trace) {
+			free_pages((unsigned long)mctracer_trace.data[i]->trace,
 				   order);
-			mctracer_trace.trace[i] = NULL;
+			mctracer_trace.data[i]->trace = NULL;
 		}
 	}
 	return -ENOMEM;
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-14 14:57:43.000000000 -0500
@@ -12,15 +12,19 @@ struct mctracer_entry {
 	pid_t pid;
 };
 
+struct mctracer_trace_cpu {
+	void *trace;
+	unsigned long trace_idx;
+	atomic_t      disabled;
+	atomic_t      underrun;
+};
+
 struct mctracer_trace {
-	void	      *trace[NR_CPUS];
-	unsigned long trace_idx[NR_CPUS];
 	unsigned long entries;
 	long	      ctrl;
 	unsigned long iter_flags;
 	atomic_t      cnt;
-	atomic_t      disabled[NR_CPUS];
-	atomic_t      underrun[NR_CPUS];
+	struct mctracer_trace_cpu *data[NR_CPUS];
 };
 
 #endif /* _LINUX_MCOUNT_TRACER_H */

-- 
