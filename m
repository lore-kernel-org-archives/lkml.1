Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZKNGe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZKNGe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 01:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZKNGeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 01:34:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42859 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZKNGeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 01:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HJcCQrPhox5R9WRkqGWmGX7/bOveF7TDTgBCixi/Tw4rXOt6eNOnqZkUYIIo4DBAdi
         GolTRwyIrwUVZesvRzHSRaMVnCobQqqqm8u6VVKjeeTWPlJVqID6u5fFuLvugY7VvFL9
         /OTwmIJhkFdtnRbNsY3pqyl7I+SrTnTk4F+wI=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
Subject: [PATCH v8 04/16] tracing: add static function tracer support for MIPS
Date: Sat, 14 Nov 2009 14:33:19 +0800
Message-Id: <ea337742d3ca7eec2825416041a6d4fa917d5cc4.1258177321.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1258177321.git.wuzhangjin@gmail.com>
 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1258177321.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1258177321.git.wuzhangjin@gmail.com>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

If -pg of gcc is enabled with CONFIG_FUNCTION_TRACER=y. a calling to
_mcount will be inserted into each kernel function. so, there is a
possibility to trace the kernel functions in _mcount.

This patch add the MIPS specific _mcount support for static function
tracing. by default, ftrace_trace_function is initialized as
ftrace_stub(an empty function), so, the default _mcount will introduce
very little overhead. after enabling ftrace in user-space, it will jump
to a real tracing function and do static function tracing for us.

and -ffunction-sections is incompatible with -pg, so, disable it when
ftracer is enabled.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 arch/mips/Kconfig              |    1 +
 arch/mips/Makefile             |    2 +
 arch/mips/include/asm/ftrace.h |   25 +++++++++++-
 arch/mips/kernel/Makefile      |    2 +
 arch/mips/kernel/mcount.S      |   83 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 ++
 6 files changed, 117 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/kernel/mcount.S

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 03bd56a..6b33e88 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,6 +4,7 @@ config MIPS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
+	select HAVE_FUNCTION_TRACER
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB if !LEMOTE_FULOONG2E
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 77f5021..0a2073e 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -48,7 +48,9 @@ ifneq ($(SUBARCH),$(ARCH))
   endif
 endif
 
+ifndef CONFIG_FUNCTION_TRACER
 cflags-y := -ffunction-sections
+endif
 cflags-y += $(call cc-option, -mno-check-zero-division)
 
 ifdef CONFIG_32BIT
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
index 40a8c17..5f8ebcf 100644
--- a/arch/mips/include/asm/ftrace.h
+++ b/arch/mips/include/asm/ftrace.h
@@ -1 +1,24 @@
-/* empty */
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive for
+ * more details.
+ *
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#ifndef _ASM_MIPS_FTRACE_H
+#define _ASM_MIPS_FTRACE_H
+
+#ifdef CONFIG_FUNCTION_TRACER
+
+#define MCOUNT_ADDR ((unsigned long)(_mcount))
+#define MCOUNT_INSN_SIZE 4		/* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void _mcount(void);
+#define mcount _mcount
+
+#endif /* __ASSEMBLY__ */
+#endif /* CONFIG_FUNCTION_TRACER */
+#endif /* _ASM_MIPS_FTRACE_H */
diff --git a/arch/mips/kernel/Makefile b/arch/mips/kernel/Makefile
index f228868..38e704a 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_trace_clock.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
@@ -29,6 +30,7 @@ obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
 obj-$(CONFIG_FTRACE)		+= trace_clock.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
 
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
new file mode 100644
index 0000000..cebcc3c
--- /dev/null
+++ b/arch/mips/kernel/mcount.S
@@ -0,0 +1,83 @@
+/*
+ * MIPS specific _mcount support
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive for
+ * more details.
+ *
+ * Copyright (C) 2009 Lemote Inc. & DSLab, Lanzhou University, China
+ * Author: Wu Zhangjin <wuzj@lemote.com>
+ */
+
+#include <asm/regdef.h>
+#include <asm/stackframe.h>
+#include <asm/ftrace.h>
+
+	.text
+	.set noreorder
+	.set noat
+
+	.macro MCOUNT_SAVE_REGS
+	PTR_SUBU	sp, PT_SIZE
+	PTR_S	ra, PT_R31(sp)
+	PTR_S	AT, PT_R1(sp)
+	PTR_S	a0, PT_R4(sp)
+	PTR_S	a1, PT_R5(sp)
+	PTR_S	a2, PT_R6(sp)
+	PTR_S	a3, PT_R7(sp)
+#ifdef CONFIG_64BIT
+	PTR_S	a4, PT_R8(sp)
+	PTR_S	a5, PT_R9(sp)
+	PTR_S	a6, PT_R10(sp)
+	PTR_S	a7, PT_R11(sp)
+#endif
+	.endm
+
+	.macro MCOUNT_RESTORE_REGS
+	PTR_L	ra, PT_R31(sp)
+	PTR_L	AT, PT_R1(sp)
+	PTR_L	a0, PT_R4(sp)
+	PTR_L	a1, PT_R5(sp)
+	PTR_L	a2, PT_R6(sp)
+	PTR_L	a3, PT_R7(sp)
+#ifdef CONFIG_64BIT
+	PTR_L	a4, PT_R8(sp)
+	PTR_L	a5, PT_R9(sp)
+	PTR_L	a6, PT_R10(sp)
+	PTR_L	a7, PT_R11(sp)
+#endif
+#ifdef CONFIG_64BIT
+	PTR_ADDIU	sp, PT_SIZE
+#else
+	PTR_ADDIU	sp, (PT_SIZE + 8)
+#endif
+.endm
+
+	.macro RETURN_BACK
+	jr ra
+	 move ra, AT
+	.endm
+
+NESTED(_mcount, PT_SIZE, ra)
+	PTR_LA	t0, ftrace_stub
+	PTR_L	t1, ftrace_trace_function /* Prepare t1 for (1) */
+	bne	t0, t1, static_trace
+	 nop
+	b	ftrace_stub
+	 nop
+
+static_trace:
+	MCOUNT_SAVE_REGS
+
+	move	a0, ra		/* arg1: next ip, selfaddr */
+	jalr	t1	/* (1) call *ftrace_trace_function */
+	 move	a1, AT		/* arg2: the caller's next ip, parent */
+
+	MCOUNT_RESTORE_REGS
+	.globl ftrace_stub
+ftrace_stub:
+	RETURN_BACK
+	END(_mcount)
+
+	.set at
+	.set reorder
diff --git a/arch/mips/kernel/mips_ksyms.c b/arch/mips/kernel/mips_ksyms.c
index 225755d..1d04807 100644
--- a/arch/mips/kernel/mips_ksyms.c
+++ b/arch/mips/kernel/mips_ksyms.c
@@ -13,6 +13,7 @@
 #include <asm/checksum.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
+#include <asm/ftrace.h>
 
 extern void *__bzero(void *__s, size_t __count);
 extern long __strncpy_from_user_nocheck_asm(char *__to,
@@ -51,3 +52,7 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
 EXPORT_SYMBOL(__csum_partial_copy_user);
 
 EXPORT_SYMBOL(invalid_pte_table);
+#ifdef CONFIG_FUNCTION_TRACER
+/* _mcount is defined in arch/mips/kernel/mcount.S */
+EXPORT_SYMBOL(_mcount);
+#endif
-- 
1.6.2.1

