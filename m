Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYHGSVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYHGSVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbYHGSVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:21:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37744 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYHGSVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:21:18 -0400
Message-Id: <20080807182117.136812885@goodmis.org>
References: <20080807182013.984175558@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 Aug 2008 14:20:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 3/5] ftrace: enable mcount recording for modules
Content-Disposition: inline; filename=ftrace-mcount-loc-modules.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the loading of the __mcount_section of modules and
changing all the callers of mcount into nops.

The modification is done before the init_module function is called, so
again, we do not need to use kstop_machine to make these changes.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    3 +++
 kernel/module.c        |   11 +++++++++++
 kernel/trace/ftrace.c  |    5 +++++
 3 files changed, 19 insertions(+)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-08-07 13:09:25.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-08-07 13:09:31.000000000 -0400
@@ -143,8 +143,11 @@ ftrace_special(unsigned long arg1, unsig
 
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 extern void ftrace_init(void);
+extern void ftrace_init_module(unsigned long *start, unsigned long *end);
 #else
 static inline void ftrace_init(void) { }
+static inline void
+ftrace_init_module(unsigned long *start, unsigned long *end) { }
 #endif
 
 #endif /* _LINUX_FTRACE_H */
Index: linux-tip.git/kernel/module.c
===================================================================
--- linux-tip.git.orig/kernel/module.c	2008-08-07 13:09:17.000000000 -0400
+++ linux-tip.git/kernel/module.c	2008-08-07 13:33:58.000000000 -0400
@@ -48,6 +48,7 @@
 #include <linux/license.h>
 #include <asm/sections.h>
 #include <linux/tracepoint.h>
+#include <linux/ftrace.h>
 
 #if 0
 #define DEBUGP printk
@@ -1835,6 +1836,7 @@ static struct module *load_module(void _
 	unsigned int markersstringsindex;
 	unsigned int tracepointsindex;
 	unsigned int tracepointsstringsindex;
+	unsigned int mcountindex;
 	struct module *mod;
 	long err = 0;
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
@@ -2125,6 +2127,9 @@ static struct module *load_module(void _
 	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
 					"__tracepoints_strings");
 
+	mcountindex = find_sec(hdr, sechdrs, secstrings,
+			       "__mcount_loc");
+
 	/* Now do relocations. */
 	for (i = 1; i < hdr->e_shnum; i++) {
 		const char *strtab = (char *)sechdrs[strindex].sh_addr;
@@ -2185,6 +2190,12 @@ static struct module *load_module(void _
 			mod->tracepoints + mod->num_tracepoints);
 #endif
 	}
+
+	if (mcountindex) {
+		void *mseg = (void *)sechdrs[mcountindex].sh_addr;
+		ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
+	}
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-08-07 13:09:25.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-08-07 13:09:31.000000000 -0400
@@ -1548,6 +1548,11 @@ static int ftrace_convert_nops(unsigned 
 	return 0;
 }
 
+void ftrace_init_module(unsigned long *start, unsigned long *end)
+{
+	ftrace_convert_nops(start, end);
+}
+
 extern unsigned long __start_mcount_loc[];
 extern unsigned long __stop_mcount_loc[];
 

-- 
