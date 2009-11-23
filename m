Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZKWJIf (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Nov 2009 04:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756230AbZKWJIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:08:32 -0500
Received: from gw.wifiinternet.cz ([89.31.42.6]:49967 "EHLO monstr.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756215AbZKWJIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:08:30 -0500
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 04:08:12 EST
From: y@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: michal.simek@petalogix.com, wuzhangjin@gmail.com, mingo@elte.hu,
        rostedt@goodmis.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/5] microblaze: ftrace: add static function tracer
Date: Mon, 23 Nov 2009 09:41:19 +0100
Message-Id: <1258965683-21302-2-git-send-email-y>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1258965683-21302-1-git-send-email-y>
References: <y>
 <1258965683-21302-1-git-send-email-y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

If -pg of gcc is enabled with CONFIG_FUNCTION_TRACER=y. a calling to
_mcount will be inserted into each kernel function. so, there is a
possibility to trace the kernel functions in _mcount.

This patch add the specific _mcount support for static function
tracing. by default, ftrace_trace_function is initialized as
ftrace_stub(an empty function), so, the default _mcount will introduce
very little overhead. after enabling ftrace in user-space, it will jump
to a real tracing function and do static function tracing for us.

Commit message from Wu Zhangjin <wuzhangjin@gmail.com>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/Kconfig                   |    1 +
 arch/microblaze/include/asm/ftrace.h      |   14 ++++
 arch/microblaze/kernel/Makefile           |   11 +++
 arch/microblaze/kernel/cpu/Makefile       |    4 +
 arch/microblaze/kernel/mcount.S           |  105 +++++++++++++++++++++++++++++
 arch/microblaze/kernel/microblaze_ksyms.c |    5 ++
 6 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/mcount.S

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 57eeaa6..18003ca 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -6,6 +6,7 @@ mainmenu "Linux/Microblaze Kernel Configuration"
 config MICROBLAZE
 	def_bool y
 	select HAVE_LMB
+	select HAVE_FUNCTION_TRACER
 	select USB_ARCH_HAS_EHCI
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 
diff --git a/arch/microblaze/include/asm/ftrace.h b/arch/microblaze/include/asm/ftrace.h
index 8b13789..22beec5 100644
--- a/arch/microblaze/include/asm/ftrace.h
+++ b/arch/microblaze/include/asm/ftrace.h
@@ -1 +1,15 @@
+#ifndef _ASM_MICROBLAZE_FTRACE
+#define _ASM_MICROBLAZE_FTRACE
 
+#ifdef CONFIG_FUNCTION_TRACER
+
+#define MCOUNT_ADDR		((long)(_mcount))
+#define MCOUNT_INSN_SIZE	8 /* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void _mcount(void);
+extern void ftrace_call_graph(void);
+#endif
+
+#endif /* CONFIG_FUNCTION_TRACER */
+#endif /* _ASM_MICROBLAZE_FTRACE */
diff --git a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
index c465a5c..d5ee326 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -2,6 +2,16 @@
 # Makefile
 #
 
+ifdef CONFIG_FUNCTION_TRACER
+# Do not trace early boot code and low level code
+CFLAGS_REMOVE_timer.o = -pg
+CFLAGS_REMOVE_intc.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
+CFLAGS_REMOVE_selfmod.o = -pg
+CFLAGS_REMOVE_heartbeat.o = -pg
+CFLAGS_REMOVE_ftrace.o = -pg
+endif
+
 extra-y := head.o vmlinux.lds
 
 obj-y += exceptions.o \
@@ -17,5 +27,6 @@ obj-$(CONFIG_HEART_BEAT)	+= heartbeat.o
 obj-$(CONFIG_MODULES)		+= microblaze_ksyms.o module.o
 obj-$(CONFIG_MMU)		+= misc.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 
 obj-y	+= entry$(MMU).o
diff --git a/arch/microblaze/kernel/cpu/Makefile b/arch/microblaze/kernel/cpu/Makefile
index 20646e5..59cc7bc 100644
--- a/arch/microblaze/kernel/cpu/Makefile
+++ b/arch/microblaze/kernel/cpu/Makefile
@@ -2,6 +2,10 @@
 # Build the appropriate CPU version support
 #
 
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_cache.o = -pg
+endif
+
 EXTRA_CFLAGS += -DCPU_MAJOR=$(CPU_MAJOR) -DCPU_MINOR=$(CPU_MINOR) \
 		-DCPU_REV=$(CPU_REV)
 
diff --git a/arch/microblaze/kernel/mcount.S b/arch/microblaze/kernel/mcount.S
new file mode 100644
index 0000000..a257a1b
--- /dev/null
+++ b/arch/microblaze/kernel/mcount.S
@@ -0,0 +1,105 @@
+/*
+ * Low-level ftrace handling
+ *
+ * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2009 PetaLogix
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#include <linux/linkage.h>
+
+#define NOALIGN_ENTRY(name)	.globl name; name:
+
+/* FIXME MS: I think that I don't need to save all regs */
+#define SAVE_REGS		\
+	addik	r1, r1, -120;	\
+	swi	r2, r1, 4;	\
+	swi	r3, r1, 8;	\
+	swi	r4, r1, 12;	\
+	swi	r5, r1, 116;	\
+	swi	r6, r1, 16;	\
+	swi	r7, r1, 20;	\
+	swi	r8, r1, 24;	\
+	swi	r9, r1, 28;	\
+	swi	r10, r1, 32;	\
+	swi	r11, r1, 36;	\
+	swi	r12, r1, 40;	\
+	swi	r13, r1, 44;	\
+	swi	r14, r1, 48;	\
+	swi	r16, r1, 52;	\
+	swi	r17, r1, 56;	\
+	swi	r18, r1, 60;	\
+	swi	r19, r1, 64;	\
+	swi	r20, r1, 68;	\
+	swi	r21, r1, 72;	\
+	swi	r22, r1, 76;	\
+	swi	r23, r1, 80;	\
+	swi	r24, r1, 84;	\
+	swi	r25, r1, 88;	\
+	swi	r26, r1, 92;	\
+	swi	r27, r1, 96;	\
+	swi	r28, r1, 100;	\
+	swi	r29, r1, 104;	\
+	swi	r30, r1, 108;	\
+	swi	r31, r1, 112;
+
+#define RESTORE_REGS		\
+	lwi	r2, r1, 4;	\
+	lwi	r3, r1, 8;	\
+	lwi	r4, r1, 12;	\
+	lwi	r5, r1, 116;	\
+	lwi	r6, r1, 16;	\
+	lwi	r7, r1, 20;	\
+	lwi	r8, r1, 24;	\
+	lwi	r9, r1, 28;	\
+	lwi	r10, r1, 32;	\
+	lwi	r11, r1, 36;	\
+	lwi	r12, r1, 40;	\
+	lwi	r13, r1, 44;	\
+	lwi	r14, r1, 48;	\
+	lwi	r16, r1, 52;	\
+	lwi	r17, r1, 56;	\
+	lwi	r18, r1, 60;	\
+	lwi	r19, r1, 64;	\
+	lwi	r20, r1, 68;	\
+	lwi	r21, r1, 72;	\
+	lwi	r22, r1, 76;	\
+	lwi	r23, r1, 80;	\
+	lwi	r24, r1, 84;	\
+	lwi	r25, r1, 88;	\
+	lwi	r26, r1, 92;	\
+	lwi	r27, r1, 96;	\
+	lwi	r28, r1, 100;	\
+	lwi	r29, r1, 104;	\
+	lwi	r30, r1, 108;	\
+	lwi	r31, r1, 112;	\
+	addik	r1, r1, 120;
+
+ENTRY(ftrace_stub)
+	rtsd	r15, 8;
+	nop;
+
+ENTRY(_mcount)
+	SAVE_REGS
+	swi	r15, r1, 0;
+	/* MS: test function trace if is taken or not */
+	lwi	r20, r0, ftrace_trace_function;
+	addik	r6, r0, ftrace_stub;
+	cmpu	r5, r20, r6; /* ftrace_trace_function != ftrace_stub */
+	beqid	r5, end; /* MS: not taken -> jump over */
+	nop;
+/* static normal trace */
+	lwi	r6, r1, 120; /* MS: load parent addr */
+	addik	r5, r15, 0; /* MS: load current function addr */
+	/* MS: here is dependency on previous code */
+	brald	r15, r20; /* MS: jump to ftrace handler */
+	nop;
+end:
+	lwi	r15, r1, 0;
+	RESTORE_REGS
+
+	rtsd	r15, 8; /* MS: jump back */
+	nop;
diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
index 59ff20e..bc4dcb7 100644
--- a/arch/microblaze/kernel/microblaze_ksyms.c
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <asm/page.h>
 #include <asm/system.h>
+#include <linux/ftrace.h>
 #include <linux/uaccess.h>
 
 /*
@@ -47,3 +48,7 @@ extern void __umodsi3(void);
 EXPORT_SYMBOL(__umodsi3);
 extern char *_ebss;
 EXPORT_SYMBOL_GPL(_ebss);
+#ifdef CONFIG_FUNCTION_TRACER
+extern void _mcount(void);
+EXPORT_SYMBOL(_mcount);
+#endif
-- 
1.5.5.1

