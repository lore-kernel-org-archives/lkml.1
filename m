Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZE2PDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZE2PDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbZE2PDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:03:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:11050 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760136AbZE2PDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=buvNou1wcIyQwYqL70aDLy1+sMpujiPsjGkmmODs3hxe636n6P66/AdLYOFRDQ0yaf
         ldk71U2ekYcL7bK6yOERBHxBm8x5UP8h2MjkNB4JLebIpJ6w5EJJBY9Qa64gHDMdAy87
         HGi1u9RV6QIkttHwdHZTMTjkpsn5eb3nMSxAs=
From: wuzhangjin@gmail.com
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Wu Zhangjin <wuzj@lemote.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 1/6] mips static function tracer support
Date: Fri, 29 May 2009 23:02:52 +0800
Message-Id: <470969a4d4dd0450830dcb5074d3a4283c645464.1243604390.git.wuzj@lemote.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1243604390.git.wuzj@lemote.com>
References: <cover.1243604390.git.wuzj@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

if -pg of gcc is enabled. a calling to _mcount will be inserted to each
kernel function. so, there is a possibility to trace the functions in
_mcount.

here is the implementation of mips specific _mcount for static function
tracer.

-ffunction-sections option not works with -pg, so disable it if enables
FUNCTION_TRACER.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/Kconfig              |    2 +
 arch/mips/Makefile             |    2 +
 arch/mips/include/asm/ftrace.h |   25 ++++++++++-
 arch/mips/kernel/Makefile      |    7 +++
 arch/mips/kernel/mcount.S      |   98 ++++++++++++++++++++++++++++++++++++++++
 arch/mips/kernel/mips_ksyms.c  |    5 ++
 6 files changed, 138 insertions(+), 1 deletions(-)
 create mode 100644 arch/mips/kernel/mcount.S

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 09b1287..d5c01ca 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -4,6 +4,8 @@ config MIPS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
+	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	# Horrible source of confusion.  Die, die, die ...
 	select EMBEDDED
 	select RTC_LIB
diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index c4cae9e..f86fb15 100644
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
index e961221..559a820 100644
--- a/arch/mips/kernel/Makefile
+++ b/arch/mips/kernel/Makefile
@@ -8,6 +8,11 @@ obj-y		+= cpu-probe.o branch.o entry.o genex.o irq.o process.o \
 		   ptrace.o reset.o setup.o signal.o syscall.o \
 		   time.o topology.o traps.o unaligned.o watch.o
 
+ifdef CONFIG_FUNCTION_TRACER
+# Do not profile debug and lowlevel utilities
+CFLAGS_REMOVE_early_printk.o = -pg
+endif
+
 obj-$(CONFIG_CEVT_BCM1480)	+= cevt-bcm1480.o
 obj-$(CONFIG_CEVT_R4K_LIB)	+= cevt-r4k.o
 obj-$(CONFIG_MIPS_MT_SMTC)	+= cevt-smtc.o
@@ -24,6 +29,8 @@ obj-$(CONFIG_SYNC_R4K)		+= sync-r4k.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-$(CONFIG_MODULES)		+= mips_ksyms.o module.o
 
+obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o
+
 obj-$(CONFIG_CPU_LOONGSON2)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS32)	+= r4k_fpu.o r4k_switch.o
 obj-$(CONFIG_CPU_MIPS64)	+= r4k_fpu.o r4k_switch.o
diff --git a/arch/mips/kernel/mcount.S b/arch/mips/kernel/mcount.S
new file mode 100644
index 0000000..268724e
--- /dev/null
+++ b/arch/mips/kernel/mcount.S
@@ -0,0 +1,98 @@
+/*
+ * the mips-specific _mcount implementation
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive for
+ * more details.
+ *
+ * Copyright (C) 2009 DSLab, Lanzhou University, China
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
+	/* since there is a "addiu sp,sp,-8" before "jal _mcount" in 32bit */
+	.macro RESTORE_SP_FOR_32BIT
+#ifdef CONFIG_32BIT
+	PTR_ADDIU	sp, 8
+#endif
+	.endm
+
+	.macro MCOUNT_SAVE_REGS
+	PTR_SUBU	sp, PT_SIZE
+	PTR_S	ra, PT_R31(sp)
+	PTR_S	$1, PT_R1(sp)
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
+	PTR_L	$1, PT_R1(sp)
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
+	PTR_ADDIU	sp, PT_SIZE
+.endm
+
+	.macro MCOUNT_SET_ARGS
+	move	a0, ra		/* arg1: next ip, selfaddr */
+	move	a1, $1		/* arg2: the caller's next ip, parent */
+	PTR_SUBU a0, MCOUNT_INSN_SIZE
+	.endm
+
+	.macro RETURN_BACK
+	jr ra
+	move ra, $1
+	.endm
+
+NESTED(_mcount, PT_SIZE, ra)
+	RESTORE_SP_FOR_32BIT
+	PTR_L	t0, function_trace_stop
+	bnez	t0, ftrace_stub
+	nop
+
+	PTR_LA	t0, ftrace_stub
+	PTR_L	t1, ftrace_trace_function /* please don't use t1 later, safe? */
+	bne	t0, t1, static_trace
+	nop
+
+	j	ftrace_stub
+	nop
+
+static_trace:
+	MCOUNT_SAVE_REGS
+
+	MCOUNT_SET_ARGS			/* call *ftrace_trace_function */
+	jalr	t1
+	nop
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
1.6.0.4

