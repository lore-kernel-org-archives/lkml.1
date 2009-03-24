Return-Path: <linux-kernel-owner+w=401wt.eu-S1763145AbZCXQ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763145AbZCXQ1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbZCXQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:25:56 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41650 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762950AbZCXQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:25:53 -0400
Message-Id: <20090324160148.872305963@polymtl.ca>
References: <20090324155625.420966314@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 24 Mar 2009 11:56:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [patch 7/9] LTTng instrumentation - kernel
Content-Disposition: inline; filename=lttng-instrumentation-kernel.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue, 24 Mar 2009 16:22:04 +0000
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
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Masami Hiramatsu <mhiramat@redhat.com>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
---
 include/trace/kernel.h |   19 +++++++++++++++++++
 kernel/module.c        |    8 ++++++++
 kernel/printk.c        |    7 +++++++
 3 files changed, 34 insertions(+)

Index: linux-2.6-lttng/kernel/printk.c
===================================================================
--- linux-2.6-lttng.orig/kernel/printk.c	2009-03-24 09:09:52.000000000 -0400
+++ linux-2.6-lttng/kernel/printk.c	2009-03-24 09:31:53.000000000 -0400
@@ -32,6 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
+#include <trace/kernel.h>
 
 #include <asm/uaccess.h>
 
@@ -59,6 +60,7 @@ int console_printk[4] = {
 	MINIMUM_CONSOLE_LOGLEVEL,	/* minimum_console_loglevel */
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
+EXPORT_SYMBOL_GPL(console_printk);
 
 /*
  * Low level drivers may need that to know if they can schedule in
@@ -128,6 +130,9 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 /* Flag: console code may call schedule() */
 static int console_may_schedule;
 
+DEFINE_TRACE(kernel_printk);
+DEFINE_TRACE(kernel_vprintk);
+
 #ifdef CONFIG_PRINTK
 
 static char __log_buf[__LOG_BUF_LEN];
@@ -560,6 +565,7 @@ asmlinkage int printk(const char *fmt, .
 	int r;
 
 	va_start(args, fmt);
+	trace_kernel_printk(_RET_IP_);
 	r = vprintk(fmt, args);
 	va_end(args);
 
@@ -667,6 +673,7 @@ asmlinkage int vprintk(const char *fmt, 
 	printed_len += vscnprintf(printk_buf + printed_len,
 				  sizeof(printk_buf) - printed_len, fmt, args);
 
+	trace_kernel_vprintk(_RET_IP_, printk_buf, printed_len);
 
 	/*
 	 * Copy the output into log_buf.  If the caller didn't provide
Index: linux-2.6-lttng/kernel/module.c
===================================================================
--- linux-2.6-lttng.orig/kernel/module.c	2009-03-24 09:09:59.000000000 -0400
+++ linux-2.6-lttng/kernel/module.c	2009-03-24 09:31:53.000000000 -0400
@@ -51,6 +51,7 @@
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
+#include <trace/kernel.h>
 
 #if 0
 #define DEBUGP printk
@@ -78,6 +79,9 @@ static BLOCKING_NOTIFIER_HEAD(module_not
 /* Bounds of module allocation, for speeding __module_text_address */
 static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
+DEFINE_TRACE(kernel_module_load);
+DEFINE_TRACE(kernel_module_free);
+
 int register_module_notifier(struct notifier_block * nb)
 {
 	return blocking_notifier_chain_register(&module_notify_list, nb);
@@ -1445,6 +1449,8 @@ static int __unlink_module(void *_mod)
 /* Free a module, remove from lists, etc (must hold module_mutex). */
 static void free_module(struct module *mod)
 {
+	trace_kernel_module_free(mod);
+
 	/* Delete from various lists */
 	stop_machine(__unlink_module, mod, NULL);
 	remove_notes_attrs(mod);
@@ -2276,6 +2282,8 @@ static noinline struct module *load_modu
 	vfree(hdr);
 
 	stop_machine_destroy();
+
+	trace_kernel_module_load(mod);
 	/* Done! */
 	return mod;
 
Index: linux-2.6-lttng/include/trace/kernel.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/trace/kernel.h	2009-03-24 09:32:03.000000000 -0400
@@ -0,0 +1,19 @@
+#ifndef _TRACE_KERNEL_H
+#define _TRACE_KERNEL_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_TRACE(kernel_printk,
+	TPPROTO(unsigned long retaddr),
+		TPARGS(retaddr));
+DECLARE_TRACE(kernel_vprintk,
+	TPPROTO(unsigned long retaddr, char *buf, int len),
+		TPARGS(retaddr, buf, len));
+DECLARE_TRACE(kernel_module_free,
+	TPPROTO(struct module *mod),
+		TPARGS(mod));
+DECLARE_TRACE(kernel_module_load,
+	TPPROTO(struct module *mod),
+		TPARGS(mod));
+
+#endif

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
