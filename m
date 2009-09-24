Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbZIXOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbZIXOnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZIXOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:43:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:48402 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698AbZIXOnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:43:33 -0400
Message-Id: <20090924133359.890562163@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Sep 2009 09:26:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, akpm@osdl.org
Subject: [patch 06/12] Immediate Values - Powerpc Optimization
Content-Disposition: inline; filename=immediate-values-powerpc-optimization.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Thu, 24 Sep 2009 14:07:32 +0000
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
 arch/powerpc/Kconfig                 |    1 
 arch/powerpc/include/asm/immediate.h |   56 +++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

Index: linux.trees.git/arch/powerpc/include/asm/immediate.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux.trees.git/arch/powerpc/include/asm/immediate.h	2009-09-24 09:00:33.000000000 -0400
@@ -0,0 +1,56 @@
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
+		case 8:							\
+			value = name##__imv;				\
+			break;						\
+		};							\
+		value;							\
+	})
+
+#endif /* _ASM_POWERPC_IMMEDIATE_H */
Index: linux.trees.git/arch/powerpc/Kconfig
===================================================================
--- linux.trees.git.orig/arch/powerpc/Kconfig	2009-09-24 08:52:40.000000000 -0400
+++ linux.trees.git/arch/powerpc/Kconfig	2009-09-24 09:00:51.000000000 -0400
@@ -130,6 +130,7 @@ config PPC
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_PERF_EVENTS
+	select HAVE_IMMEDIATE
 
 config EARLY_PRINTK
 	bool

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
