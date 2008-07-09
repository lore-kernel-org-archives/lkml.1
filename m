Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYGIPDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYGIPDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYGIPCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:02:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36502 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbYGIPCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:02:42 -0400
Message-Id: <20080709150045.664334888@polymtl.ca>
References: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 07/15] LTTng instrumentation - kernel
Content-Disposition: inline; filename=lttng-instrumentation-kernel.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrument the core kernel : module load/free and printk events. It helps the
tracer to keep track of module related events and to export valuable printk
information into the traces.

Those tracepoints are used by LTTng.

About the performance impact of tracepoints (which is comparable to markers),
even without immediate values optimizations, tests done by Hideo Aoki on ia64
show no regression. His test case was using hackbench on a kernel where
scheduler instrumentation (about 5 events in code scheduler code) was added.
See the "Tracepoints" patch header for performance result detail.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 kernel/kernel-trace.h |   19 +++++++++++++++++++
 kernel/module.c       |    5 +++++
 kernel/printk.c       |    6 ++++++
 3 files changed, 30 insertions(+)

Index: linux-2.6-lttng/kernel/printk.c
===================================================================
--- linux-2.6-lttng.orig/kernel/printk.c	2008-07-09 10:55:46.000000000 -0400
+++ linux-2.6-lttng/kernel/printk.c	2008-07-09 10:58:11.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include "kernel-trace.h"
 
 #include <asm/uaccess.h>
 
@@ -59,6 +60,7 @@ int console_printk[4] = {
 	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
+EXPORT_SYMBOL_GPL(console_printk);
 
 /*
  * Low level drivers may need that to know if they can schedule in
@@ -601,6 +603,7 @@ asmlinkage int printk(const char *fmt, .
 	int r;
 
 	va_start(args, fmt);
+	trace_kernel_printk(__builtin_return_address(0));
 	r = vprintk(fmt, args);
 	va_end(args);
 
@@ -677,6 +680,9 @@ asmlinkage int vprintk(const char *fmt, 
 	raw_local_irq_save(flags);
 	this_cpu = smp_processor_id();
 
+	trace_kernel_vprintk(__builtin_return_address(0),
+		printk_buf, printed_len);
+
 	/*
 	 * Ouch, printk recursed into itself!
 	 */
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2008-07-09 10:55:58.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2008-07-09 10:58:11.000000000 -0400
@@ -48,6 +48,7 @@
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
+#include "kernel-trace.h"
 
 #if 0
 #define DEBUGP printk
@@ -1422,6 +1423,8 @@ static int __unlink_module(void *_mod)
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
+	trace_kernel_module_free(mod);
+
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NULL);
 	remove_notes_attrs(mod);
@@ -2237,6 +2240,8 @@ static struct module *load_module(void _
 	/* Get rid of temporary copy */
 	vfree(hdr);
 
+	trace_kernel_module_load(mod);
+
 	/* Done! */
 	return mod;
 
Index: linux-2.6-lttng/kernel/kernel-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/kernel/kernel-trace.h	2008-07-09 10:58:11.000000000 -0400
@@ -0,0 +1,19 @@
+#ifndef _KERNEL_TRACE_H
+#define _KERNEL_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(kernel_printk,
+	TPPROTO(void *retaddr),
+	TPARGS(retaddr));
+DEFINE_TRACE(kernel_vprintk,
+	TPPROTO(void *retaddr, char *buf, int len),
+	TPARGS(retaddr, buf, len));
+DEFINE_TRACE(kernel_module_free,
+	TPPROTO(struct module *mod),
+	TPARGS(mod));
+DEFINE_TRACE(kernel_module_load,
+	TPPROTO(struct module *mod),
+	TPARGS(mod));
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
