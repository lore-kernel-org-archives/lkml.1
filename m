Return-Path: <linux-kernel-owner+w=401wt.eu-S933516AbZFLQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbZFLQc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764536AbZFLQZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39107 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761863AbZFLQZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 24/27] Blackfin: initial support for ftrace
Date: Fri, 12 Jun 2009 12:24:42 -0400
Message-Id: <1244823885-22410-25-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just the basic ftrace support here -- mcount and the ftrace stub.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig               |    1 +
 arch/blackfin/include/asm/ftrace.h  |   14 ++++++-
 arch/blackfin/kernel/Makefile       |    1 +
 arch/blackfin/kernel/bfin_ksyms.c   |    5 ++
 arch/blackfin/kernel/ftrace-entry.S |   72 +++++++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+), 1 deletions(-)
 create mode 100644 arch/blackfin/kernel/ftrace-entry.S

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index d03fd63..ea8d92c 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -19,6 +19,7 @@ config RWSEM_XCHGADD_ALGORITHM
 
 config BLACKFIN
 	def_bool y
+	select HAVE_FUNCTION_TRACER
 	select HAVE_IDE
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff --git a/arch/blackfin/include/asm/ftrace.h b/arch/blackfin/include/asm/ftrace.h
index 40a8c17..8643680 100644
--- a/arch/blackfin/include/asm/ftrace.h
+++ b/arch/blackfin/include/asm/ftrace.h
@@ -1 +1,13 @@
-/* empty */
+/*
+ * Blackfin ftrace code
+ *
+ * Copyright 2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __ASM_BFIN_FTRACE_H__
+#define __ASM_BFIN_FTRACE_H__
+
+#define MCOUNT_INSN_SIZE	8 /* sizeof mcount call: LINK + CALL */
+
+#endif
diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index a66dda4..d2ae285 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -15,6 +15,7 @@ else
     obj-y += time.o
 endif
 
+obj-$(CONFIG_FUNCTION_TRACER)        += ftrace-entry.o
 obj-$(CONFIG_IPIPE)                  += ipipe.o
 obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
 obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
diff --git a/arch/blackfin/kernel/bfin_ksyms.c b/arch/blackfin/kernel/bfin_ksyms.c
index 53e893f..aa05e63 100644
--- a/arch/blackfin/kernel/bfin_ksyms.c
+++ b/arch/blackfin/kernel/bfin_ksyms.c
@@ -103,3 +103,8 @@ EXPORT_SYMBOL(__raw_smp_mark_barrier_asm);
 EXPORT_SYMBOL(__raw_smp_check_barrier_asm);
 #endif
 #endif
+
+#ifdef CONFIG_FUNCTION_TRACER
+extern void _mcount(void);
+EXPORT_SYMBOL(_mcount);
+#endif
diff --git a/arch/blackfin/kernel/ftrace-entry.S b/arch/blackfin/kernel/ftrace-entry.S
new file mode 100644
index 0000000..ce71487
--- /dev/null
+++ b/arch/blackfin/kernel/ftrace-entry.S
@@ -0,0 +1,72 @@
+/*
+ * mcount and friends -- ftrace stuff
+ *
+ * Copyright (C) 2009 Analog Devices Inc.
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/linkage.h>
+#include <asm/ftrace.h>
+
+.text
+
+/* GCC will have called us before setting up the function prologue, so we
+ * can clobber the normal scratch registers, but we need to make sure to
+ * save/restore the registers used for argument passing (R0-R2) in case
+ * the profiled function is using them.  With data registers, R3 is the
+ * only one we can blow away.  With pointer registers, we have P0-P2.
+ *
+ * Upon entry, the RETS will point to the top of the current profiled
+ * function.  And since GCC setup the frame for us, the previous function
+ * will be waiting there.  mmmm pie.
+ */
+ENTRY(__mcount)
+	/* save third function arg early so we can do testing below */
+	[--sp] = r2;
+
+	/* load the function pointer to the tracer */
+	p0.l = _ftrace_trace_function;
+	p0.h = _ftrace_trace_function;
+	r3 = [p0];
+
+	/* optional micro optimization: don't call the stub tracer */
+	r2.l = _ftrace_stub;
+	r2.h = _ftrace_stub;
+	cc = r2 == r3;
+	if ! cc jump .Ldo_trace;
+
+	r2 = [sp++];
+	rts;
+
+.Ldo_trace:
+
+	/* save first/second function arg and the return register */
+	[--sp] = r0;
+	[--sp] = r1;
+	[--sp] = rets;
+
+	/* setup the tracer function */
+	p0 = r3;
+
+	/* tracer(ulong frompc, ulong selfpc):
+	 *  frompc: the pc that did the call to ...
+	 *  selfpc: ... this location
+	 * the selfpc itself will need adjusting for the mcount call
+	 */
+	r1 = rets;
+	r0 = [fp + 4];
+	r1 += -MCOUNT_INSN_SIZE;
+
+	/* call the tracer */
+	call (p0);
+
+	/* restore state and get out of dodge */
+	rets = [sp++];
+	r1 = [sp++];
+	r0 = [sp++];
+	r2 = [sp++];
+
+.globl _ftrace_stub
+_ftrace_stub:
+	rts;
+ENDPROC(__mcount)
-- 
1.6.3.1

