Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZFLQd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZFLQd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763922AbZFLQZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39104 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764391AbZFLQZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 25/27] Blackfin: initial support for ftrace grapher
Date: Fri, 12 Jun 2009 12:24:43 -0400
Message-Id: <1244823885-22410-26-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig               |    1 +
 arch/blackfin/kernel/Makefile       |    3 ++
 arch/blackfin/kernel/ftrace-entry.S |   68 +++++++++++++++++++++++++++++++++++
 arch/blackfin/kernel/ftrace.c       |   42 +++++++++++++++++++++
 arch/blackfin/kernel/vmlinux.lds.S  |    1 +
 5 files changed, 115 insertions(+), 0 deletions(-)
 create mode 100644 arch/blackfin/kernel/ftrace.c

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index ea8d92c..5bc1360 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -19,6 +19,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config BLACKFIN
 	def_bool y
+	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
 	select HAVE_KERNEL_GZIP
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index d2ae285..3731088 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -16,6 +16,9 @@ else
 endif
 
 obj-$(CONFIG_FUNCTION_TRACER)        += ftrace-entry.o
+obj-$(CONFIG_FUNCTION_GRAPH_TRACER)  += ftrace.o
+CFLAGS_REMOVE_ftrace.o = -pg
+
 obj-$(CONFIG_IPIPE)                  += ipipe.o
 obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
 obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
diff --git a/arch/blackfin/kernel/ftrace-entry.S b/arch/blackfin/kernel/ftrace-entry.S
index ce71487..6980b7a 100644
--- a/arch/blackfin/kernel/ftrace-entry.S
+++ b/arch/blackfin/kernel/ftrace-entry.S
@@ -35,6 +35,28 @@ ENTRY(__mcount)
 	cc = r2 == r3;
 	if ! cc jump .Ldo_trace;
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* if the ftrace_graph_return function pointer is not set to
+	 * the ftrace_stub entry, call prepare_ftrace_return().
+	 */
+	p0.l = _ftrace_graph_return;
+	p0.h = _ftrace_graph_return;
+	r3 = [p0];
+	cc = r2 == r3;
+	if ! cc jump _ftrace_graph_caller;
+
+	/* similarly, if the ftrace_graph_entry function pointer is not
+	 * set to the ftrace_graph_entry_stub entry, ...
+	 */
+	p0.l = _ftrace_graph_entry;
+	p0.h = _ftrace_graph_entry;
+	r2.l = _ftrace_graph_entry_stub;
+	r2.h = _ftrace_graph_entry_stub;
+	r3 = [p0];
+	cc = r2 == r3;
+	if ! cc jump _ftrace_graph_caller;
+#endif
+
 	r2 = [sp++];
 	rts;
 
@@ -61,6 +83,7 @@ ENTRY(__mcount)
 	call (p0);
 
 	/* restore state and get out of dodge */
+.Lfinish_trace:
 	rets = [sp++];
 	r1 = [sp++];
 	r0 = [sp++];
@@ -70,3 +93,48 @@ ENTRY(__mcount)
 _ftrace_stub:
 	rts;
 ENDPROC(__mcount)
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+/* The prepare_ftrace_return() function is similar to the trace function
+ * except it takes a pointer to the location of the frompc.  This is so
+ * the prepare_ftrace_return() can hijack it temporarily for probing
+ * purposes.
+ */
+ENTRY(_ftrace_graph_caller)
+	/* save first/second function arg and the return register */
+	[--sp] = r0;
+	[--sp] = r1;
+	[--sp] = rets;
+
+	r0 = fp;
+	r1 = rets;
+	r0 += 4;
+	r1 += -MCOUNT_INSN_SIZE;
+	call _prepare_ftrace_return;
+
+	jump .Lfinish_trace;
+ENDPROC(_ftrace_graph_caller)
+
+/* Undo the rewrite caused by ftrace_graph_caller().  The common function
+ * ftrace_return_to_handler() will return the original rets so we can
+ * restore it and be on our way.
+ */
+ENTRY(_return_to_handler)
+	/* make sure original return values are saved */
+	[--sp] = p0;
+	[--sp] = r0;
+	[--sp] = r1;
+
+	/* get original return address */
+	call _ftrace_return_to_handler;
+	rets = r0;
+
+	/* anomaly 05000371 - make sure we have at least three instructions
+	 * between rets setting and the return
+	 */
+	r1 = [sp++];
+	r0 = [sp++];
+	p0 = [sp++];
+	rts;
+ENDPROC(_return_to_handler)
+#endif
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
new file mode 100644
index 0000000..905bfc4
--- /dev/null
+++ b/arch/blackfin/kernel/ftrace.c
@@ -0,0 +1,42 @@
+/*
+ * ftrace graph code
+ *
+ * Copyright (C) 2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/ftrace.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+/*
+ * Hook the return address and push it in the stack of return addrs
+ * in current thread info.
+ */
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
+{
+	struct ftrace_graph_ent trace;
+	unsigned long return_hooker = (unsigned long)&return_to_handler;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	if (ftrace_push_return_trace(*parent, self_addr, &trace.depth) == -EBUSY)
+		return;
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		return;
+	}
+
+	/* all is well in the world !  hijack RETS ... */
+	*parent = return_hooker;
+}
+
+#endif
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 119fbdb..6ac307c 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -54,6 +54,7 @@ SECTIONS
 		SCHED_TEXT
 #endif
 		LOCK_TEXT
+		IRQENTRY_TEXT
 		KPROBES_TEXT
 		*(.text.*)
 		*(.fixup)
-- 
1.6.3.1

