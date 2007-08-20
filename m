Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbXHTUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbXHTUXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762405AbXHTUTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:19:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53809 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762385AbXHTUTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:19:17 -0400
Message-Id: <20070820201823.412705838@polymtl.ca>
References: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       rmk@arm.linux.org.uk
Subject: [patch 03/23] Add cmpxchg_local to arm
Content-Disposition: inline; filename=add-cmpxchg-local-to-arm.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:18:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: rmk@arm.linux.org.uk
---
 include/asm-arm/system.h |   43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

Index: linux-2.6-lttng/include/asm-arm/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-arm/system.h	2007-08-07 11:03:37.000000000 -0400
+++ linux-2.6-lttng/include/asm-arm/system.h	2007-08-07 11:19:40.000000000 -0400
@@ -350,40 +350,19 @@ static inline unsigned long __xchg(unsig
 extern void disable_hlt(void);
 extern void enable_hlt(void);
 
-#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg-local.h>
+
 /*
- * Atomic compare and exchange.
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * then available.
  */
-#define __HAVE_ARCH_CMPXCHG	1
-
-extern unsigned long wrong_size_cmpxchg(volatile void *ptr);
-
-static inline unsigned long __cmpxchg(volatile void *ptr,
-				    unsigned long old,
-				    unsigned long new, int size)
-{
-	unsigned long flags, prev;
-	volatile unsigned long *p = ptr;
-
-	if (size == 4) {
-		local_irq_save(flags);
-		prev = *p;
-		if (prev == old)
-			*p = new;
-		local_irq_restore(flags);
-		return prev;
-	} else
-		return wrong_size_cmpxchg(ptr);
-}
-
-#define cmpxchg(ptr, o, n)					  	\
-({									\
-     __typeof__(*(ptr)) _o_ = (o);					\
-     __typeof__(*(ptr)) _n_ = (n);					\
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		\
-		(unsigned long)_n_, sizeof(*(ptr)));	\
-})
-
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
 #endif
 
 #endif /* __ASSEMBLY__ */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
