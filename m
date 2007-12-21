Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXLUCF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXLUCF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 21:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762917AbXLUB7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:59:11 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:53351 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762525AbXLUB7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:59:06 -0500
Message-Id: <20071221015727.640689028@polymtl.ca>
References: <20071221015438.433195466@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 20 Dec 2007 20:54:54 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 16/24] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 21 Dec 2007 01:57:32 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC optimization of the immediate values which uses a li instruction,
patched with an immediate value.

Changelog:
- Put imv_set and _imv_set in the architecture independent header.
- Pack the __imv section. Use smallest types required for size (char).
- Remove architecture specific update code : now handled by architecture
  agnostic code.
- Use imv_* instead of immediate_*.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Christoph Hellwig <hch@infradead.org>
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/Kconfig            |    1 
 include/asm-powerpc/immediate.h |   55 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2007-11-19 12:26:16.000000000 -0500
@@ -0,0 +1,55 @@
+#ifndef _ASM_POWERPC_IMMEDIATE_H
+#define _ASM_POWERPC_IMMEDIATE_H
+
+/*
+ * Immediate values. PowerPC architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+/**
+ * imv_read - read immediate variable
+ * @name: immediate value name
+ *
+ * Reads the value of @name.
+ * Optimized version of the immediate.
+ * Do not use in __init and __exit functions. Use _imv_read() instead.
+ */
+#define imv_read(name)							\
+	({								\
+		__typeof__(name##__imv) value;				\
+		BUILD_BUG_ON(sizeof(value) > 8);			\
+		switch (sizeof(value)) {				\
+		case 1:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+					PPC_LONG "%c1, ((1f)-1)\n\t"	\
+					".byte 1\n\t"			\
+					".previous\n\t"			\
+					"li %0,0\n\t"			\
+					"1:\n\t"			\
+				: "=r" (value)				\
+				: "i" (&name##__imv));			\
+			break;						\
+		case 2:							\
+			asm(".section __imv,\"a\",@progbits\n\t"	\
+					PPC_LONG "%c1, ((1f)-2)\n\t"	\
+					".byte 2\n\t"			\
+					".previous\n\t"			\
+					"li %0,0\n\t"			\
+					"1:\n\t"			\
+				: "=r" (value)				\
+				: "i" (&name##__imv));			\
+			break;						\
+		case 4:							\
+		case 8:	value = name##__imv;				\
+			break;						\
+		};							\
+		value;							\
+	})
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux-2.6-lttng/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2007-11-19 12:25:21.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2007-11-19 12:26:01.000000000 -0500
@@ -81,6 +81,7 @@ config PPC
 	default y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_IMMEDIATE
 
 config EARLY_PRINTK
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
