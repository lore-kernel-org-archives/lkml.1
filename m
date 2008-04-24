Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYDXPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYDXPYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbYDXPPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:15:40 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56488 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760034AbYDXPPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:15:39 -0400
Message-Id: <20080424151359.512672078@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org
Subject: [patch 17/37] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:13:59 +0000
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

Index: linux-2.6-sched-devel/include/asm-powerpc/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-sched-devel/include/asm-powerpc/immediate.h	2008-04-22 20:22:58.000000000 -0400
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
Index: linux-2.6-sched-devel/arch/powerpc/Kconfig
===================================================================
--- linux-2.6-sched-devel.orig/arch/powerpc/Kconfig	2008-04-22 20:04:01.000000000 -0400
+++ linux-2.6-sched-devel/arch/powerpc/Kconfig	2008-04-22 20:23:18.000000000 -0400
@@ -110,6 +110,7 @@ config PPC
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_LMB
+	select HAVE_IMMEDIATE
 
 config EARLY_PRINTK
 	bool

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
