Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZIXOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZIXOp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZIXOp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:45:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54201 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZIXOp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:45:26 -0400
Message-Id: <20090924133359.577986342@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Adrian Bunk <bunk@stusta.de>,
       akpm@osdl.org
Subject: [patch 04/12] Immediate Values - x86 Optimization
Content-Disposition: inline; filename=immediate-values-x86-optimization.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Note : a movb needs to get its value froma =q constraint.

Quoting "H. Peter Anvin" <hpa@zytor.com>

Using =r for single-byte values is incorrect for 32-bit code -- that would 
permit %spl, %bpl, %sil, %dil which are illegal in 32-bit mode.

Changelog:
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the imv_mutex).
- Put imv_set and _imv_set in the architecture independent header.
- Use $0 instead of %2 with (0) operand.
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.
- Bugfix : 8 bytes 64 bits immediate value was declared as "4 bytes" in the
  immediate structure.
- Change the immediate.c update code to support variable length opcodes.
- Vastly simplified, using a busy looping IPI with interrupts disabled.
  Does not protect against NMI nor MCE.
- Pack the __imv section. Use smallest types required for size (char).
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Adrian Bunk <bunk@stusta.de>
CC: akpm@osdl.org
---
 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/immediate.h |   77 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

Index: linux.trees.git/arch/x86/include/asm/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/x86/include/asm/immediate.h	2009-09-24 09:00:27.000000000 -0400
@@ -0,0 +1,77 @@
+#ifndef _ASM_X86_IMMEDIATE_H
+#define _ASM_X86_IMMEDIATE_H
+
+/*
+ * Immediate values. x86 architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm.h>
+
+/**
+ * imv_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _imv_read() instead.
+ * If size is bigger than the architecture long size, fall back on a memory
+ * read.
+ *
+ * Make sure to populate the initial static 64 bits opcode with a value
+ * what will generate an instruction with 8 bytes immediate value (not the REX.W
+ * prefixed one that loads a sign extended 32 bits immediate value in a r64
+ * register).
+ */
+#define imv_read(name)							\
+	({								\
+		__typeof__(name##__imv) value;				\
+		BUILD_BUG_ON(sizeof(value) > 8);			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=q" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 2:							\
+		case 4:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0,%0\n\t"				\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		case 8:							\
+			if (sizeof(long) < 8) {				\
+				value = name##__imv;			\
+				break;					\
+			}						\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+				_ASM_PTR "%c1, (3f)-%c2\n\t"		\
+				".byte %c2\n\t"				\
+				".previous\n\t"				\
+				"mov $0xFEFEFEFE01010101,%0\n\t" 	\
+				"3:\n\t"				\
+				: "=r" (value)				\
+				: "i" (&name##__imv),			\
+				  "i" (sizeof(value)));			\
+			break;						\
+		};							\
+		value;							\
+	})
+
+#endif /* _ASM_X86_IMMEDIATE_H */
Index: linux.trees.git/arch/x86/Kconfig
===================================================================
--- linux.trees.git.orig/arch/x86/Kconfig	2009-09-24 08:52:41.000000000 -0400
+++ linux.trees.git/arch/x86/Kconfig	2009-09-24 09:00:27.000000000 -0400
@@ -45,6 +45,7 @@ config X86
 	select HAVE_GENERIC_DMA_COHERENT if X86_32
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select USER_STACKTRACE_SUPPORT
+	select HAVE_IMMEDIATE
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
