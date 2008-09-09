Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYIIBVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYIIBVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755028AbYIIBU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:20:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38310 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbYIIBU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:20:26 -0400
Message-Id: <20080909005116.532077779@polymtl.ca>
References: <20080909003403.836661865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 20:34:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Joe Perches <joe@perches.com>,
       Wei Weng <wweng@acedsl.com>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC PATCH 3/5] Priority Sifting Reader-Writer Lock x86_64 Optimised Call
Content-Disposition: inline; filename=psrwlock-x86_64-optimised-call.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  9 Sep 2008 00:55:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a specialized calling convention for x86_64 where the first argument is
passed in rax. Use a trampoline to move it to the rdi register. Useful to re-use
the return value of a cmpxchg without moving registers in-line.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Joe Perches <joe@perches.com>
CC: Wei Weng <wweng@acedsl.com>
---
 arch/x86/Kconfig                 |    1 
 arch/x86/kernel/Makefile         |    3 +
 arch/x86/kernel/call_64.S        |   45 +++++++++++++++++++++++++
 arch/x86/kernel/call_export_64.c |   36 ++++++++++++++++++++
 include/asm-x86/call_64.h        |   68 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 153 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/Makefile	2008-09-08 11:49:37.000000000 -0400
+++ linux-2.6-lttng/arch/x86/kernel/Makefile	2008-09-08 11:50:46.000000000 -0400
@@ -99,6 +99,9 @@ scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
 
+obj-y				+= call_64.o
+obj-y				+= call_export_64.o
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
Index: linux-2.6-lttng/arch/x86/kernel/call_64.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/kernel/call_64.S	2008-09-08 11:53:47.000000000 -0400
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/x86/kernel/call_64.S -- special 64-bits calling conventions
+ *
+ * Copyright (C) 2008 Mathieu Desnoyers
+ */
+
+#include <linux/linkage.h>
+
+/*
+ * Called by call_rax_rsi().
+ *
+ * Move rax to rdi and proceed to the standard call.
+ */
+.macro TRAMPOLINE_RAX_RSI symbol
+ENTRY(asm_\symbol)
+	movq	%rax, %rdi
+	jmp	_\symbol
+END(asm_\symbol)
+.endm
+
+/*
+ * Called by call_rbx_rsi().
+ *
+ * Move rbx to rdi and proceed to the standard call.
+ */
+.macro TRAMPOLINE_RBX_RSI symbol
+ENTRY(asm_\symbol)
+	movq	%rbx, %rdi
+	jmp	_\symbol
+END(asm_\symbol)
+.endm
+
+TRAMPOLINE_RAX_RSI psread_lock_slow_irq
+TRAMPOLINE_RAX_RSI psread_trylock_slow_irq
+TRAMPOLINE_RAX_RSI psread_lock_slow_bh
+TRAMPOLINE_RAX_RSI psread_trylock_slow_bh
+TRAMPOLINE_RAX_RSI psread_lock_slow_inatomic
+TRAMPOLINE_RAX_RSI psread_trylock_slow_inatomic
+TRAMPOLINE_RAX_RSI psread_lock_slow
+TRAMPOLINE_RAX_RSI psread_trylock_slow
+
+TRAMPOLINE_RAX_RSI pswrite_lock_slow
+TRAMPOLINE_RAX_RSI pswrite_trylock_slow
+TRAMPOLINE_RAX_RSI pswrite_unlock_slow
+TRAMPOLINE_RBX_RSI psrwlock_wakeup
Index: linux-2.6-lttng/arch/x86/kernel/call_export_64.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/arch/x86/kernel/call_export_64.c	2008-09-08 11:50:46.000000000 -0400
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/x86/kernel/call_64.c -- special 64-bits calling conventions
+ *
+ * Export function symbols of special calling convention functions.
+ *
+ * Copyright (C) 2008 Mathieu Desnoyers
+ */
+
+#include <linux/module.h>
+#include <asm/call_64.h>
+
+void asm_psread_lock_slow_irq(void);
+EXPORT_SYMBOL_GPL(asm_psread_lock_slow_irq);
+void asm_psread_trylock_slow_irq(void);
+EXPORT_SYMBOL_GPL(asm_psread_trylock_slow_irq);
+void asm_psread_lock_slow_bh(void);
+EXPORT_SYMBOL_GPL(asm_psread_lock_slow_bh);
+void asm_psread_trylock_slow_bh(void);
+EXPORT_SYMBOL_GPL(asm_psread_trylock_slow_bh);
+void asm_psread_lock_slow_inatomic(void);
+EXPORT_SYMBOL_GPL(asm_psread_lock_slow_inatomic);
+void asm_psread_trylock_slow_inatomic(void);
+EXPORT_SYMBOL_GPL(asm_psread_trylock_slow_inatomic);
+void asm_psread_lock_slow(void);
+EXPORT_SYMBOL_GPL(asm_psread_lock_slow);
+void asm_psread_trylock_slow(void);
+EXPORT_SYMBOL_GPL(asm_psread_trylock_slow);
+
+void asm_pswrite_lock_slow(void);
+EXPORT_SYMBOL_GPL(asm_pswrite_lock_slow);
+void asm_pswrite_trylock_slow(void);
+EXPORT_SYMBOL_GPL(asm_pswrite_trylock_slow);
+void asm_pswrite_unlock_slow(void);
+EXPORT_SYMBOL_GPL(asm_pswrite_unlock_slow);
+void asm_psrwlock_wakeup(void);
+EXPORT_SYMBOL_GPL(asm_psrwlock_wakeup);
Index: linux-2.6-lttng/include/asm-x86/call_64.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/call_64.h	2008-09-08 11:52:07.000000000 -0400
@@ -0,0 +1,68 @@
+#ifndef __ASM_X86_CALL_64_H
+#define __ASM_X86_CALL_64_H
+
+/*
+ * asm-x86/call_64.h
+ *
+ * Use rax as first argument for the call. Useful when already returned by the
+ * previous instruction, such as cmpxchg.
+ * Leave rdi free to mov rax to rdi in the trampoline.
+ * Return value in rax.
+ *
+ * Saving the registers in the original caller because we cannot restore them in
+ * the trampoline. Save the same as "SAVE_ARGS".
+ *
+ * Copyright (C) 2008 Mathieu Desnoyers
+ */
+
+#define call_rax_rsi(symbol, rax, rsi)				\
+	({							\
+		unsigned long ret, modrsi;			\
+		asm volatile("callq asm_" #symbol "\n\t"	\
+			     : "=a" (ret), "=S" (modrsi)	\
+			     : "a" (rax), "S" (rsi)		\
+			     : "rdi", "rcx", "rdx",		\
+			       "%r8", "%r9", "%r10", "%r11",	\
+			       "cc", "memory");			\
+		ret;						\
+	})
+
+#define call_rbx_rsi(symbol, rbx, rsi)				\
+	({							\
+		unsigned long ret, modrsi;			\
+		asm volatile("callq asm_" #symbol "\n\t"	\
+			     : "=a" (ret), "=S" (modrsi)	\
+			     : "b" (rbx), "S" (rsi)		\
+			     : "rdi", "rcx", "rdx",		\
+			       "%r8", "%r9", "%r10", "%r11",	\
+			       "cc", "memory");			\
+		ret;						\
+	})
+
+#define psread_lock_slow_irq(v, rwlock)				\
+	call_rax_rsi(psread_lock_slow_irq, v, rwlock)
+#define psread_trylock_slow_irq(v, rwlock)			\
+	call_rax_rsi(psread_trylock_slow_irq, v, rwlock)
+#define psread_lock_slow_bh(v, rwlock)				\
+	call_rax_rsi(psread_lock_slow_bh, v, rwlock)
+#define psread_trylock_slow_bh(v, rwlock)			\
+	call_rax_rsi(psread_trylock_slow_bh, v, rwlock)
+#define psread_lock_slow_inatomic(v, rwlock)			\
+	call_rax_rsi(psread_lock_slow_inatomic, v, rwlock)
+#define psread_trylock_slow_inatomic(v, rwlock)			\
+	call_rax_rsi(psread_trylock_slow_inatomic, v, rwlock)
+#define psread_lock_slow(v, rwlock)				\
+	call_rax_rsi(psread_lock_slow, v, rwlock)
+#define psread_trylock_slow(v, rwlock)				\
+	call_rax_rsi(psread_trylock_slow, v, rwlock)
+
+#define pswrite_lock_slow(v, rwlock)				\
+	call_rax_rsi(pswrite_lock_slow, v, rwlock)
+#define pswrite_trylock_slow(v, rwlock)				\
+	call_rax_rsi(pswrite_trylock_slow, v, rwlock)
+#define pswrite_unlock_slow(v, rwlock)				\
+	call_rax_rsi(pswrite_unlock_slow, v, rwlock)
+#define psrwlock_wakeup(v, rwlock)				\
+	call_rbx_rsi(psrwlock_wakeup, v, rwlock)
+
+#endif
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2008-09-08 11:49:37.000000000 -0400
+++ linux-2.6-lttng/arch/x86/Kconfig	2008-09-08 11:50:46.000000000 -0400
@@ -31,6 +31,7 @@ config X86
 	select HAVE_ARCH_KGDB if !X86_VOYAGER
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_PSRWLOCK_ASM_CALL
 
 config ARCH_DEFCONFIG
 	string

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
