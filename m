Return-Path: <linux-kernel-owner+w=401wt.eu-S937566AbXHLPkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937566AbXHLPkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964819AbXHLPhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:37:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50256 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935947AbXHLPh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:37:27 -0400
Message-Id: <20070812145839.832092314@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, zippel@linux-m68k.org,
       linux-m68k@vger.kernel.org
Subject: [patch 13/23] Add cmpxchg_local to m86k
Content-Disposition: inline; filename=add-cmpxchg-local-to-m68k.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:37:08 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: zippel@linux-m68k.org
CC: linux-m68k@lists.linux-m68k.org
---
 include/asm-m68k/system.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6-lttng/include/asm-m68k/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m68k/system.h	2007-08-07 14:31:51.000000000 -0400
+++ linux-2.6-lttng/include/asm-m68k/system.h	2007-08-07 15:01:41.000000000 -0400
@@ -154,6 +154,10 @@ static inline unsigned long __xchg(unsig
 }
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
@@ -188,6 +192,23 @@ static inline unsigned long __cmpxchg(vo
 #define cmpxchg(ptr,o,n)\
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg_local(ptr,o,n)\
+	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(*(ptr))))
+#else
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
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
