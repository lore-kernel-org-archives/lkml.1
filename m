Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbYAIXcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbYAIXcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbYAIXaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:30:52 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:57470 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbYAIXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:48 -0500
Message-Id: <20080109233043.180392174@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:20 -0500
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
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 06/22 -v2] mcount based trace in the form of a header file library
Content-Disposition: inline; filename=mcount-simple-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The design is for mcount based tracers to be added thru the
lib/tracing/tracer_interface.h file, just like mcount users should add
themselves to lib/tracing/mcount.h. A Kconfig rule chooses the right MCOUNT and
MCOUNT_TRACER user.

This is to avoid function call costs for something that is supposed to be used
only in a debug kernel and that has to reduce to the bare minimum the per
function call overhead of mcount based tracing.

Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/Kconfig            |   12 +++
 lib/tracing/Makefile           |    2 
 lib/tracing/tracer.c           |  124 +++++++++++++++++++++++++++++++++++++++++
 lib/tracing/tracer.h           |   21 ++++++
 lib/tracing/tracer_interface.h |   14 ++++
 5 files changed, 173 insertions(+)
 create mode 100644 lib/tracing/tracer.c
 create mode 100644 lib/tracing/tracer.h
 create mode 100644 lib/tracing/tracer_interface.h

Index: linux-compile-i386.git/lib/tracing/Kconfig
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/Kconfig	2008-01-09 14:10:07.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/Kconfig	2008-01-09 15:17:22.000000000 -0500
@@ -5,3 +5,15 @@ config MCOUNT
 	bool
 	depends on DEBUG_KERNEL
 	select FRAME_POINTER
+
+
+config MCOUNT_TRACER
+	bool "Profiler instrumentation based tracer"
+	depends on DEBUG_KERNEL && ARCH_HAS_MCOUNT
+	default n
+	select MCOUNT
+	help
+	  Use profiler instrumentation, adding -pg to CFLAGS. This will
+	  insert a call to an architecture specific __mcount routine,
+	  that the debugging mechanism using this facility will hook by
+	  providing a set of inline routines.
Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:45.000000000 -0500
@@ -0,0 +1,124 @@
+/*
+ * ring buffer based mcount tracer
+ *
+ * Copyright (C) 2007 Arnaldo Carvalho de Melo <acme@redhat.com>
+ * 		      Steven Rostedt <srostedt@redhat.com>
+ *
+ * From code in the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/seq_file.h>
+#include <linux/mcount.h>
+
+#include "tracer.h"
+#include "tracer_interface.h"
+
+static struct mctracer_trace mctracer_trace;
+
+static inline notrace void
+mctracer_add_trace_entry(struct mctracer_trace *tr,
+			 int cpu,
+			 const unsigned long ip,
+			 const unsigned long parent_ip)
+{
+	unsigned long idx, idx_next;
+	struct mctracer_entry *entry;
+
+	idx = tr->trace_idx[cpu];
+	idx_next = idx + 1;
+
+	if (unlikely(idx_next >= tr->entries)) {
+		atomic_inc(&tr->underrun[cpu]);
+		idx_next = 0;
+	}
+
+	tr->trace_idx[cpu] = idx_next;
+
+	if (unlikely(idx_next != 0 && atomic_read(&tr->underrun[cpu])))
+		atomic_inc(&tr->underrun[cpu]);
+
+	entry = tr->trace[cpu] + idx * MCTRACER_ENTRY_SIZE;
+	entry->idx	 = atomic_inc_return(&tr->cnt);
+	entry->ip	 = ip;
+	entry->parent_ip = parent_ip;
+}
+
+static notrace void trace_function(const unsigned long ip,
+				   const unsigned long parent_ip)
+{
+	unsigned long flags;
+	struct mctracer_trace *tr;
+	int cpu;
+
+	raw_local_irq_save(flags);
+	cpu = raw_smp_processor_id();
+
+	tr = &mctracer_trace;
+
+	atomic_inc(&tr->disabled[cpu]);
+	if (likely(atomic_read(&tr->disabled[cpu]) == 1))
+		mctracer_add_trace_entry(tr, cpu, ip, parent_ip);
+
+	atomic_dec(&tr->disabled[cpu]);
+
+	raw_local_irq_restore(flags);
+}
+
+
+static notrace int page_order(const unsigned long size)
+{
+	const unsigned long nr_pages = DIV_ROUND_UP(size, PAGE_SIZE);
+	return ilog2(roundup_pow_of_two(nr_pages));
+}
+
+static notrace int mctracer_alloc_buffers(void)
+{
+	const int order = page_order(MCTRACER_NR_ENTRIES * MCTRACER_ENTRY_SIZE);
+	const unsigned long size = (1UL << order) << PAGE_SHIFT;
+	struct mctracer_entry *array;
+	int i;
+
+	for_each_possible_cpu(i) {
+		array = (struct mctracer_entry *)
+			  __get_free_pages(GFP_KERNEL, order);
+		if (array == NULL) {
+			printk(KERN_ERR "mctracer: failed to allocate"
+			       " %ld bytes for trace buffer!\n", size);
+			goto free_buffers;
+		}
+		mctracer_trace.trace[i] = array;
+	}
+
+	/*
+	 * Since we allocate by orders of pages, we may be able to
+	 * round up a bit.
+	 */
+	mctracer_trace.entries = size / MCTRACER_ENTRY_SIZE;
+
+	pr_info("mctracer: %ld bytes allocated for %ld entries of %d bytes\n",
+		size, MCTRACER_NR_ENTRIES, MCTRACER_ENTRY_SIZE);
+	pr_info("   actual entries %ld\n", mctracer_trace.entries);
+
+	register_mcount_function(trace_function);
+
+	return 0;
+
+ free_buffers:
+	for (i-- ; i >= 0; i--) {
+		if (mctracer_trace.trace[i]) {
+			free_pages((unsigned long)mctracer_trace.trace[i],
+				   order);
+			mctracer_trace.trace[i] = NULL;
+		}
+	}
+	return -ENOMEM;
+}
+
+device_initcall(mctracer_alloc_buffers);
Index: linux-compile-i386.git/lib/tracing/tracer.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile-i386.git/lib/tracing/tracer.h	2008-01-09 15:17:45.000000000 -0500
@@ -0,0 +1,21 @@
+#ifndef _LINUX_MCOUNT_TRACER_H
+#define _LINUX_MCOUNT_TRACER_H
+
+#include <asm/atomic.h>
+
+struct mctracer_entry {
+	unsigned long idx;
+	unsigned long ip;
+	unsigned long parent_ip;
+};
+
+struct mctracer_trace {
+	void	      *trace[NR_CPUS];
+	unsigned long trace_idx[NR_CPUS];
+	unsigned long entries;
+	atomic_t      cnt;
+	atomic_t      disabled[NR_CPUS];
+	atomic_t      underrun[NR_CPUS];
+};
+
+#endif /* _LINUX_MCOUNT_TRACER_H */
Index: linux-compile-i386.git/lib/tracing/tracer_interface.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-compile-i386.git/lib/tracing/tracer_interface.h	2008-01-09 15:17:22.000000000 -0500
@@ -0,0 +1,14 @@
+#ifndef _LINUX_MCTRACER_INTERFACE_H
+#define _LINUX_MCTRACER_INTERFACE_H
+
+#include "tracer.h"
+
+/*
+ * Will be at least sizeof(struct mctracer_entry), but callers can request more
+ * space for private stuff, such as a timestamp, preempt_count, etc.
+ */
+#define MCTRACER_ENTRY_SIZE sizeof(struct mctracer_entry)
+
+#define MCTRACER_NR_ENTRIES (65536UL)
+
+#endif /* _LINUX_MCTRACER_INTERFACE_H */
Index: linux-compile-i386.git/lib/tracing/Makefile
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/Makefile	2008-01-09 14:10:07.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/Makefile	2008-01-09 15:17:22.000000000 -0500
@@ -1,3 +1,5 @@
 obj-$(CONFIG_MCOUNT) += libmcount.o
 
+obj-$(CONFIG_MCOUNT_TRACER) += tracer.o
+
 libmcount-y := mcount.o

-- 
