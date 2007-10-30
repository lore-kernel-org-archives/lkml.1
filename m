Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXJ3TV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXJ3TV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbXJ3TVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53722 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXJ3TVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:16 -0400
Message-Id: <20071030192105.244901260@polymtl.ca>
References: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:16:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 12/28] Add cmpxchg_local to h8300
Content-Disposition: inline; filename=add-cmpxchg-local-to-h8300.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
---
 include/asm-h8300/system.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6-lttng/include/asm-h8300/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-h8300/system.h	2007-07-20 18:36:09.000000000 -0400
+++ linux-2.6-lttng/include/asm-h8300/system.h	2007-07-20 19:27:23.000000000 -0400
@@ -139,6 +139,21 @@ static inline unsigned long __xchg(unsig
         asm("jmp @@0");			\
 })
 
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o), \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #define arch_align_stack(x) (x)
 
 #endif /* _H8300_SYSTEM_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
