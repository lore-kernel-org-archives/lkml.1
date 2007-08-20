Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbXHTUza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbXHTUza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764720AbXHTUwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:52:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:32902 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764623AbXHTUwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:52:01 -0400
Message-Id: <20070820201828.126257914@polymtl.ca>
References: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       gerg@uclinux.org
Subject: [patch 14/23] Add cmpxchg_local to m68knommu
Content-Disposition: inline; filename=add-cmpxchg-local-to-m68knommu.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:51:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: gerg@uclinux.org
---
 include/asm-m68knommu/system.h |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

Index: linux-2.6-lttng/include/asm-m68knommu/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68knommu/system.h	2007-07-20 18:36:08.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68knommu/system.h	2007-07-20 19:37:02.000000000 -0400
@@ -187,26 +187,20 @@ static inline unsigned long __xchg(unsig
 }
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
  */
-#define __HAVE_ARCH_CMPXCHG	1
-
-static __inline__ unsigned long
-cmpxchg(volatile int *p, int old, int new)
-{
-	unsigned long flags;
-	int prev;
-
-	local_irq_save(flags);
-	if ((prev = *p) == old)
-		*p = new;
-	local_irq_restore(flags);
-	return(prev);
-}
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 #ifdef CONFIG_M68332
 #define HARD_RESET_NOW() ({		\

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
