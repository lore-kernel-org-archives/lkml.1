Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbXHLO7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbXHLO7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 10:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXHLO6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:58:44 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46473 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbXHLO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:58:43 -0400
Message-Id: <20070812145835.032973955@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 02/23] Add cmpxchg_local to asm-generic for per cpu atomic operations
Content-Disposition: inline; filename=add-cmpxchg-local-to-generic-for-up.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Emulates the cmpxchg_local by disabling interrupts around variable modification.
This is not reentrant wrt NMIs and MCEs. It is only protected against normal
interrupts, but this is enough for architectures without such interrupt sources
or if used in a context where the data is not shared with such handlers.

It can be used as a fallback for architectures lacking a real cmpxchg
instruction.

For architectures that have a real cmpxchg but does not have NMIs or MCE,
testing which of the generic vs architecture specific cmpxchg is the fastest
should be done.

asm-generic/cmpxchg.h defines a cmpxchg that uses cmpxchg_local. It is meant to
be used as a cmpxchg fallback for architectures that do not support SMP.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
---
 include/asm-generic/cmpxchg-local.h |   60 ++++++++++++++++++++++++++++++++++++
 include/asm-generic/cmpxchg.h       |   21 ++++++++++++
 2 files changed, 81 insertions(+)

Index: linux-2.6-lttng/include/asm-generic/cmpxchg.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/cmpxchg.h	2007-08-12 09:33:41.000000000 -0400
@@ -0,0 +1,21 @@
+#ifndef __ASM_GENERIC_CMPXCHG_H
+#define __ASM_GENERIC_CMPXCHG_H
+
+/*
+ * Generic cmpxchg
+ *
+ * Uses the local cmpxchg. Does not support SMP.
+ */
+#ifdef CONFIG_SMP
+#error "Cannot use generic cmpxchg on SMP"
+#endif
+
+/*
+ * Atomic compare and exchange.
+ */
+#define __HAVE_ARCH_CMPXCHG	1
+
+#define cmpxchg(ptr,o,n)	cmpxchg_local((ptr), (o), (n))
+#define cmpxchg64(ptr,o,n)	cmpxchg64_local((ptr), (o), (n))
+
+#endif
Index: linux-2.6-lttng/include/asm-generic/cmpxchg-local.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-lttng/include/asm-generic/cmpxchg-local.h	2007-08-12 09:19:22.000000000 -0400
@@ -0,0 +1,60 @@
+#ifndef __ASM_GENERIC_CMPXCHG_LOCAL_H
+#define __ASM_GENERIC_CMPXCHG_LOCAL_H
+
+#include <linux/types.h>
+
+extern unsigned long wrong_size_cmpxchg(volatile void *ptr);
+
+/*
+ * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned
+ * long parameter, supporting various types of architectures.
+ */
+static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
+				    unsigned long old,
+				    unsigned long new, int size)
+{
+	unsigned long flags, prev;
+
+	/*
+	 * Sanity checking, compile-time.
+	 */
+	if (size == 8 && sizeof(unsigned long) != 8)
+		wrong_size_cmpxchg(ptr);
+
+	local_irq_save(flags);
+	switch (size) {
+	case 1: if ((prev = *(u8*)ptr) == old)
+			*(u8*)ptr = (u8)new;
+		break;
+	case 2: if ((prev = *(u16*)ptr) == old)
+			*(u16*)ptr = (u16)new;
+		break;
+	case 4: if ((prev = *(u32*)ptr) == old)
+			*(u32*)ptr = (u32)new;
+		break;
+	case 8: if ((prev = *(u64*)ptr) == old)
+			*(u64*)ptr = (u64)new;
+		break;
+	default:
+		wrong_size_cmpxchg(ptr);
+	}
+	local_irq_restore(flags);
+	return prev;
+}
+
+/*
+ * Generic version of __cmpxchg64_local. Takes an u64 parameter.
+ */
+static inline u64 __cmpxchg64_local_generic(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if ((prev = *(u64*)ptr) == old)
+		*(u64*)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+
+#endif

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
