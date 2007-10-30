Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbXJ3TWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbXJ3TWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbXJ3TV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:26 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53830 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbXJ3TVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:25 -0400
Message-Id: <20071030192110.860968002@polymtl.ca>
References: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:16:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 28/28] Add cmpxchg_local to xtensa
Content-Disposition: inline; filename=add-cmpxchg-local-to-xtensa.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the architecture specific __cmpxchg_u32 for 32 bits cmpxchg)_local. Else,
use the new generic cmpxchg_local (disables interrupt).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
chris@zankel.net
---
 include/asm-xtensa/system.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

Index: linux-2.6-lttng/include/asm-xtensa/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-xtensa/system.h	2007-09-18 10:05:15.000000000 -0400
+++ linux-2.6-lttng/include/asm-xtensa/system.h	2007-09-18 13:39:38.000000000 -0400
@@ -156,8 +156,30 @@ __cmpxchg(volatile void *ptr, unsigned l
 	   			        (unsigned long)_n_, sizeof (*(ptr))); \
 	})
 
+#include <asm-generic/cmpxchg-local.h>
 
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
 
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 /*
  * xchg_u32

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
