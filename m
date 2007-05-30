Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbXE3ODK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbXE3ODK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbXE3OCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:02:35 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46329 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbXE3OCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:02:34 -0400
Message-Id: <20070530140228.693481183@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 30 May 2007 10:00:31 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 6/9] Conditional Calls - PowerPC Optimization
Content-Disposition: inline; filename=conditional-calls-powerpc-optimization.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 30 May 2007 14:02:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC optimization of the cond_calls which uses a li instruction, patched with
an immediate value 0 or 1 to enable/disable the cond_call.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/asm-powerpc/condcall.h |   68 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-powerpc/condcall.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/condcall.h	2007-05-29 11:55:58.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/condcall.h	2007-05-29 11:56:43.000000000 -0400
@@ -1 +1,67 @@
-#include <asm-generic/condcall.h>
+#ifndef _ASM_POWERPC_CONDCALL_H
+#define _ASM_POWERPC_CONDCALL_H
+
+/*
+ * Conditional function calls. PowerPC architecture optimizations.
+ *
+ * (C) Copyright 2006 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ */
+
+#include <asm/asm-compat.h>
+
+#ifdef CONFIG_COND_CALL
+
+#define CF_DEFAULT (CF_OPTIMIZED | CF_LOCKDEP | CF_PRINTK)
+
+/* Optimized version of the cond_call */
+#define cond_call_optimized(flags, name, func) \
+	({ \
+		static const char __cstrtab_name_##name[] \
+		__attribute__((section("__cond_call_strings"))) = #name; \
+		char condition; \
+		asm (	".section __cond_call, \"a\", @progbits;\n\t" \
+					PPC_LONG "%1, 0f, %2;\n\t" \
+					".previous;\n\t" \
+					".align 4\n\t" \
+					"0:\n\t" \
+					"li %0,%3;\n\t" \
+				: "=r" (condition) \
+				: "i" (__cstrtab_name_##name), \
+				  "i" (flags), \
+				  "i" ((flags) & CF_STATIC_ENABLE)); \
+		(unlikely(condition)) ? \
+			(func) : \
+			(__typeof__(func))0; \
+	})
+
+/* cond_call macro selecting the generic or optimized version of cond_call,
+ * depending on the flags specified. */
+#define _cond_call(flags, name, func) \
+({ \
+	((flags) & CF_OPTIMIZED) ? \
+		cond_call_optimized(flags, name, func) : \
+		cond_call_generic(flags, name, func); \
+})
+
+/* cond_call with default behavior */
+#define cond_call(name, func) _cond_call(CF_DEFAULT, name, func)
+
+/* Architecture dependant cond_call information, used internally for cond_call
+ * activation. */
+
+/* Offset of the immediate value from the start of the addi instruction (result
+ * of the li mnemonic), in bytes. */
+#define COND_CALL_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET 2
+#define COND_CALL_OPTIMIZED_ENABLE_TYPE unsigned short
+/* Dereference enable as lvalue from a pointer to its instruction */
+#define COND_CALL_OPTIMIZED_ENABLE(a) \
+	*(COND_CALL_OPTIMIZED_ENABLE_TYPE*) \
+		((char*)a+COND_CALL_OPTIMIZED_ENABLE_IMMEDIATE_OFFSET)
+
+extern int cond_call_optimized_set_enable(void *address, char enable);
+
+#endif
+#endif //_ASM_POWERPC_CONDCALL_H

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
