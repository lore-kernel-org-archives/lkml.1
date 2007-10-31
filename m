Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbXJaWs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbXJaWs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760377AbXJaWmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:43 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51436 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760021AbXJaWma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:30 -0400
Message-Id: <20071031224216.184809684@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: [patch 18/28] Add cmpxchg_local to m86k
Content-Disposition: inline; filename=add-cmpxchg-local-to-m68k.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:16 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: zippel@linux-m68k.org
CC: linux-m68k@lists.linux-m68k.org
---
 include/asm-m68k/system.h |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-m68k/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/system.h	2007-10-31 17:32:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/system.h	2007-10-31 18:17:03.000000000 -0400
@@ -154,6 +154,10 @@ static inline unsigned long __xchg(unsig
 }
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
@@ -185,9 +189,26 @@ static inline unsigned long __cmpxchg(vo
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)					    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#else
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #endif
 
 #define arch_align_stack(x) (x)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
