Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYAOUxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYAOUxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbYAOUuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:39 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56883 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbYAOUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:32 -0500
Message-Id: <20080115205026.724839792@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:36 -0500
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
Subject: [RFC PATCH 29/30 v3] make varaible size buffers for traces
Content-Disposition: inline; filename=trace-variable-buffer-size.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each trace now can have the size of its trace entries modified
through command line arguments.

trace_fn_entries - function trace entries (default 65536)
trace_irq_entries - irq off trace entries (default 512)
trace_ctx_entries - schedule switch entries (default 16384)

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/trace_function.c     |   14 ++++++++++++--
 lib/tracing/trace_irqsoff.c      |   14 ++++++++++++--
 lib/tracing/trace_sched_switch.c |   14 ++++++++++++--
 lib/tracing/tracer.h             |    1 -
 4 files changed, 36 insertions(+), 7 deletions(-)

Index: linux-compile.git/lib/tracing/trace_function.c
===================================================================
--- linux-compile.git.orig/lib/tracing/trace_function.c	2008-01-15 15:13:59.000000000 -0500
+++ linux-compile.git/lib/tracing/trace_function.c	2008-01-15 15:15:00.000000000 -0500
@@ -18,6 +18,16 @@
 static struct tracing_trace function_trace __read_mostly;
 static DEFINE_PER_CPU(struct tracing_trace_cpu, function_trace_cpu);
 static int trace_enabled __read_mostly;
+static unsigned long trace_nr_entries = (65536UL);
+
+static int __init set_nr_entries(char *str)
+{
+	if (!str)
+		return 0;
+	trace_nr_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("trace_fn_entries=", set_nr_entries);
 
 static notrace void function_trace_reset(struct tracing_trace *tr)
 {
@@ -132,7 +142,7 @@ static void function_trace_close(struct 
 
 __init static int function_trace_alloc_buffers(void)
 {
-	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
+	const int order = page_order(trace_nr_entries * TRACING_ENTRY_SIZE);
 	const unsigned long size = (1UL << order) << PAGE_SHIFT;
 	struct tracing_entry *array;
 	int i;
@@ -156,7 +166,7 @@ __init static int function_trace_alloc_b
 	function_trace.entries = size / TRACING_ENTRY_SIZE;
 
 	pr_info("function tracer: %ld bytes allocated for %ld",
-		size, TRACING_NR_ENTRIES);
+		size, trace_nr_entries);
 	pr_info(" entries of %ld bytes\n", (long)TRACING_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", function_trace.entries);
 
Index: linux-compile.git/lib/tracing/trace_irqsoff.c
===================================================================
--- linux-compile.git.orig/lib/tracing/trace_irqsoff.c	2008-01-15 15:13:59.000000000 -0500
+++ linux-compile.git/lib/tracing/trace_irqsoff.c	2008-01-15 15:15:00.000000000 -0500
@@ -25,6 +25,16 @@ static unsigned long preempt_max_latency
 static unsigned long preempt_thresh;
 static __cacheline_aligned_in_smp DEFINE_MUTEX(max_mutex);
 static int trace_enabled __read_mostly;
+static unsigned long trace_nr_entries = (512UL);
+
+static int __init set_nr_entries(char *str)
+{
+	if (!str)
+		return 0;
+	trace_nr_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("trace_irq_entries=", set_nr_entries);
 
 /*
  * max trace is switched with this buffer.
@@ -497,7 +507,7 @@ static void notrace irqsoff_trace_close(
 
 __init static int trace_irqsoff_alloc_buffers(void)
 {
-	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
+	const int order = page_order(trace_nr_entries * TRACING_ENTRY_SIZE);
 	const unsigned long size = (1UL << order) << PAGE_SHIFT;
 	struct tracing_entry *array;
 	int i;
@@ -535,7 +545,7 @@ __init static int trace_irqsoff_alloc_bu
 	max_tr.stop = irqsoff_stop;
 
 	pr_info("irqs off tracer: %ld bytes allocated for %ld",
-		size, TRACING_NR_ENTRIES);
+		size, trace_nr_entries);
 	pr_info(" entries of %d bytes\n", (int)TRACING_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", irqsoff_trace.entries);
 
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-15 15:13:59.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-15 15:15:00.000000000 -0500
@@ -76,7 +76,6 @@ struct tracing_iterator {
 };
 
 #define TRACING_ENTRY_SIZE sizeof(struct tracing_entry)
-#define TRACING_NR_ENTRIES (65536UL)
 
 void notrace tracing_reset(struct tracing_trace_cpu *data);
 int tracing_open_generic(struct inode *inode, struct file *filp);
Index: linux-compile.git/lib/tracing/trace_sched_switch.c
===================================================================
--- linux-compile.git.orig/lib/tracing/trace_sched_switch.c	2008-01-15 15:13:59.000000000 -0500
+++ linux-compile.git/lib/tracing/trace_sched_switch.c	2008-01-15 15:15:00.000000000 -0500
@@ -18,6 +18,16 @@ static struct tracing_trace sched_switch
 static DEFINE_PER_CPU(struct tracing_trace_cpu, sched_switch_trace_cpu);
 
 static int trace_enabled __read_mostly;
+static unsigned long trace_nr_entries = (16384UL);
+
+static int __init set_nr_entries(char *str)
+{
+	if (!str)
+		return 0;
+	trace_nr_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+__setup("trace_ctx_entries=", set_nr_entries);
 
 static notrace void sched_switch_callback(const struct marker *mdata,
 					  void *private_data,
@@ -144,7 +154,7 @@ static void sched_switch_trace_close(str
 
 __init static int sched_switch_trace_alloc_buffers(void)
 {
-	const int order = page_order(TRACING_NR_ENTRIES * TRACING_ENTRY_SIZE);
+	const int order = page_order(trace_nr_entries * TRACING_ENTRY_SIZE);
 	const unsigned long size = (1UL << order) << PAGE_SHIFT;
 	struct tracing_entry *array;
 	int ret;
@@ -170,7 +180,7 @@ __init static int sched_switch_trace_all
 	sched_switch_trace.entries = size / TRACING_ENTRY_SIZE;
 
 	pr_info("sched_switch tracer: %ld bytes allocated for %ld",
-		size, TRACING_NR_ENTRIES);
+		size, trace_nr_entries);
 	pr_info(" entries of %ld bytes\n", (long)TRACING_ENTRY_SIZE);
 	pr_info("   actual entries %ld\n", sched_switch_trace.entries);
 

-- 
