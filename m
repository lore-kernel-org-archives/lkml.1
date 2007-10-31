Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbXJaWqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbXJaWqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbXJaWme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:34 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51410 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517AbXJaWm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:26 -0400
Message-Id: <20071031224216.791887244@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       parisc-linux@parisc-linux.org
Subject: [patch 20/28] Add cmpxchg_local to parisc
Content-Disposition: inline; filename=add-cmpxchg-local-to-parisc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: parisc-linux@parisc-linux.org
---
 include/asm-parisc/atomic.h |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

Index: linux-2.6-lttng/include/asm-parisc/atomic.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-parisc/atomic.h	2007-10-31 17:32:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-parisc/atomic.h	2007-10-31 18:19:15.000000000 -0400
@@ -122,6 +122,39 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new_, int size)
+{
+	switch (size) {
+#ifdef CONFIG_64BIT
+	case 8:	return __cmpxchg_u64((unsigned long *)ptr, old, new_);
+#endif
+	case 4:	return __cmpxchg_u32(ptr, old, new_);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new_, size);
+	}
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#ifdef CONFIG_64BIT
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /* Note that we need not lock read accesses - aligned word writes/reads
  * are atomic, so a reader never sees unconsistent values.
  *

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
