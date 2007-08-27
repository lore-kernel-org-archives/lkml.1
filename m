Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbXH0QiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbXH0QiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXH0Qhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:37:52 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54141 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbXH0Qhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:37:51 -0400
Message-Id: <20070827155527.139338334@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com
Subject: [patch 11/28] Add cmpxchg_local to frv
Content-Disposition: inline; filename=add-cmpxchg-local-to-frv.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:37:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt) for 8, 16 and 64 bits
arguments. Use the 32 bits cmpxchg available on the architecture for 32 bits
arguments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
---
 include/asm-frv/system.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6-lttng/include/asm-frv/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-frv/system.h	2007-08-07 14:51:22.000000000 -0400
+++ linux-2.6-lttng/include/asm-frv/system.h	2007-08-07 14:51:39.000000000 -0400
@@ -265,5 +265,29 @@ extern uint32_t __cmpxchg_32(uint32_t *v
 
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return cmpxchg(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	\
+     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 #endif /* _ASM_SYSTEM_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
