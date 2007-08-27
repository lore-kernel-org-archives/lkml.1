Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXH0P5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXH0P5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbXH0Pzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:39 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41870 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbXH0Pzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:38 -0400
Message-Id: <20070827155532.874031829@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:53:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com
Subject: [patch 28/28] Add cmpxchg_local to xtensa
Content-Disposition: inline; filename=add-cmpxchg-local-to-xtensa.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:33 +0000
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
--- linux-2.6-lttng.orig/include/asm-xtensa/system.h	2007-07-23 11:29:18.000000000 -0400
+++ linux-2.6-lttng/include/asm-xtensa/system.h	2007-07-23 11:32:32.000000000 -0400
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
