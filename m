Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbYAIXgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbYAIXgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbYAIXbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:11 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37810 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYAIXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:54 -0500
Message-Id: <20080109233044.934722953@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:31 -0500
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
Subject: [RFC PATCH 17/22 -v2] Add timestamps to tracer
Content-Disposition: inline; filename=mcount-tracer-timestamp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add timestamps to trace entries.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |   16 ++++++++++++++++
 lib/tracing/tracer.h |    1 +
 2 files changed, 17 insertions(+)

Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:16:05.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:27.000000000 -0500
@@ -19,12 +19,18 @@
 #include <linux/percpu.h>
 #include <linux/debugfs.h>
 #include <linux/kallsyms.h>
+#include <linux/clocksource.h>
 #include <linux/uaccess.h>
 #include <linux/mcount.h>
 
 #include "tracer.h"
 #include "tracer_interface.h"
 
+static inline notrace cycle_t now(void)
+{
+	return get_monotonic_cycles();
+}
+
 static struct mctracer_trace mctracer_trace;
 static DEFINE_PER_CPU(struct mctracer_trace_cpu, mctracer_trace_cpu);
 
@@ -57,6 +63,7 @@ mctracer_add_trace_entry(struct mctracer
 	entry->ip	 = ip;
 	entry->parent_ip = parent_ip;
 	entry->pid	 = tsk->pid;
+	entry->t	 = now();
 	memcpy(entry->comm, tsk->comm, TASK_COMM_LEN);
 }
 
@@ -240,6 +247,15 @@ static int s_show(struct seq_file *m, vo
 	if (iter->ent == NULL) {
 		seq_printf(m, "mctracer:\n");
 	} else {
+		unsigned long long t;
+		unsigned long usec_rem;
+		unsigned long secs;
+
+		t = cycles_to_usecs(iter->ent->t);
+		usec_rem = do_div(t, 1000000ULL);
+		secs = (unsigned long)t;
+
+		seq_printf(m, "[%5lu.%06lu] ", secs, usec_rem);
 		seq_printf(m, "CPU %d: ", iter->cpu);
 		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
 		seq_print_ip_sym(m, iter->ent->ip, sym_only);
Index: linux-compile-i386.git/lib/tracing/tracer.h
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.h	2008-01-09 14:16:05.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.h	2008-01-09 15:17:27.000000000 -0500
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 
 struct mctracer_entry {
+	unsigned long long t;
 	unsigned long idx;
 	unsigned long ip;
 	unsigned long parent_ip;

-- 
