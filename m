Return-Path: <linux-kernel-owner+w=401wt.eu-S935412AbXHLPEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935412AbXHLPEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764921AbXHLO7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:59:09 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46560 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764540AbXHLO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:59:03 -0400
Message-Id: <20070812145841.066026604@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>, Gunnar Larisch <gl@denx.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       benh@kernel.crashing.org
Subject: [patch 16/23] Add cmpxchg_local to ppc
Content-Disposition: inline; filename=add-cmpxchg-local-to-ppc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a local processor version of cmpxchg for ppc.

Implements __cmpxchg_u32_local and uses it for 32 bits cmpxchg_local.
It uses the non NMI safe cmpxchg_local_generic for 1, 2 and 8 bytes
cmpxchg_local.

From: Gunnar Larisch <gl@denx.de>
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Gunnar Larisch <gl@denx.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: benh@kernel.crashing.org
---
 include/asm-ppc/system.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-ppc/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-ppc/system.h	2007-08-07 14:31:51.000000000 -0400
+++ linux-2.6-lttng/include/asm-ppc/system.h	2007-08-07 15:03:51.000000000 -0400
@@ -208,12 +208,34 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return prev;
 }
 
+static __inline__ unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned int old,
+	unsigned int new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ ("\n\
+1:	lwarx	%0,0,%2 \n\
+	cmpw	0,%0,%3 \n\
+	bne	2f \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2 \n\
+	bne-	1b\n"
+"2:"
+	: "=&r" (prev), "=m" (*p)
+	: "r" (p), "r" (old), "r" (new), "m" (*p)
+	: "cc", "memory");
+
+	return prev;
+}
+
 /* This function doesn't exist, so you'll get a linker error
    if something tries to do an invalid cmpxchg().  */
 extern void __cmpxchg_called_with_bad_pointer(void);
 
 static __inline__ unsigned long
-__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new, int size)
+__cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
+	unsigned int size)
 {
 	switch (size) {
 	case 4:
@@ -235,6 +257,31 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
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
+
 #define arch_align_stack(x) (x)
 
 #endif /* __KERNEL__ */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
