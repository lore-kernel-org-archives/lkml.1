Return-Path: <linux-kernel-owner+w=401wt.eu-S933485AbYDPVok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbYDPVok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYDPVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:37:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53533 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754896AbYDPVhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:37:33 -0400
Message-Id: <20080416213552.554633473@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org
Subject: [RFC patch 14/27] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:53 +0000
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
CC: Adrian Bunk <bunk@stusta.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu
CC: akpm@osdl.org
---
 arch/powerpc/Kconfig            |    1 
 include/asm-powerpc/immediate.h |   55 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-powerpc/immediate.h	2008-03-06 08:55:54.000000000 -0500
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
--- linux-2.6-lttng.orig/arch/powerpc/Kconfig	2008-03-06 08:45:31.000000000 -0500
+++ linux-2.6-lttng/arch/powerpc/Kconfig	2008-03-06 08:56:14.000000000 -0500
@@ -91,6 +91,7 @@ config PPC
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_IMMEDIATE
 
 config EARLY_PRINTK
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
