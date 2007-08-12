Return-Path: <linux-kernel-owner+w=401wt.eu-S937032AbXHLPir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937032AbXHLPir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935998AbXHLPhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:37:34 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50242 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935735AbXHLPhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:37:21 -0400
Message-Id: <20070812145836.299998668@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       michael.frysinger@analog.com
Subject: [patch 05/23] Add cmpxchg_local to blackfin, replace __cmpxchg by generic cmpxchg
Content-Disposition: inline; filename=add-cmpxchg-local-to-blackfin.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:37:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set since nobody seems to know why __cmpxchg
has been implemented in assembly in the first place thather than in plain C.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: michael.frysinger@analog.com
---
 include/asm-blackfin/system.h |   59 ++++++++----------------------------------
 1 file changed, 12 insertions(+), 47 deletions(-)

Index: linux-2.6-lttng/include/asm-blackfin/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-blackfin/system.h	2007-08-07 14:31:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-blackfin/system.h	2007-08-07 14:47:31.000000000 -0400
@@ -176,55 +176,20 @@ static inline unsigned long __xchg(unsig
 	return tmp;
 }
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
  */
-static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
-				      unsigned long new, int size)
-{
-	unsigned long tmp = 0;
-	unsigned long flags = 0;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		__asm__ __volatile__
-			("%0 = b%3 (z);\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "b%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 2:
-		__asm__ __volatile__
-			("%0 = w%3 (z);\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "w%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	case 4:
-		__asm__ __volatile__
-			("%0 = %3;\n\t"
-			 "CC = %1 == %0;\n\t"
-			 "IF !CC JUMP 1f;\n\t"
-			 "%3 = %2;\n\t"
-			 "1:\n\t"
-			 : "=&d" (tmp) : "d" (old), "d" (new), "m" (*__xg(ptr)) : "memory");
-		break;
-	}
-	local_irq_restore(flags);
-	return tmp;
-}
-
-#define cmpxchg(ptr,o,n)\
-        ((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-                                        (unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 #define prepare_to_switch()     do { } while(0)
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
