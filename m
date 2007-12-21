Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXLUCIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXLUCIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760909AbXLUB7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:59:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53379 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762985AbXLUB7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:59:15 -0500
Message-Id: <20071221015726.909058404@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@muc.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 14/24] Immediate Values - x86 Optimization
Content-Disposition: inline; filename=immediate-values-x86-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 optimization of the immediate values which uses a movl with code patching
to set/unset the value used to populate the register used as variable source.

Changelog:
- Use text_poke_early with cr0 WP save/restore to patch the bypass. We are doing
  non atomic writes to a code region only touched by us (nobody can execute it
  since we are protected by the imv_mutex).
- Put imv_set and _imv_set in the architecture independent header.
- Use $0 instead of %2 with (0) operand.
- Add x86_64 support, ready for i386+x86_64 -> x86 merge.
- Use asm-x86/asm.h.

Ok, so the most flexible solution that I see, that should fit for both
i386 and x86_64 would be :
1 byte  : "=Q" : Any register accessible as rh: a, b, c, and d.
2, 4 bytes : "=R" : Legacy register—the eight integer registers available
                 on all i386 processors (a, b, c, d, si, di, bp, sp). 8
bytes : (only for x86_64)
          "=r" : A register operand is allowed provided that it is in a
                 general register.
That should make sure x86_64 won't try to use REX prefixed opcodes for
1, 2 and 4 bytes values.

- Create the instruction in a discarded section to calculate its size. This is
  how we can align the beginning of the instruction on an address that will
  permit atomic modificatino of the immediate value without knowing the size of
  the opcode used by the compiler.
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
---
 arch/x86/Kconfig            |    1 
 include/asm-x86/immediate.h |   77 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

Index: linux-2.6-lttng/include/asm-x86/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-x86/immediate.h	2007-11-21 11:04:33.000000000 -0500
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
Index: linux-2.6-lttng/arch/x86/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/x86/Kconfig	2007-11-21 11:04:06.000000000 -0500
+++ linux-2.6-lttng/arch/x86/Kconfig	2007-11-21 11:04:33.000000000 -0500
@@ -21,6 +21,7 @@ config X86
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_IMMEDIATE
 
 config GENERIC_TIME
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
