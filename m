Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbXJ3TWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbXJ3TWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756687AbXJ3TVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:25 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53824 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbXJ3TVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:24 -0400
Message-Id: <20071030192110.098891816@polymtl.ca>
References: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:16:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       sparclinux@vger.kernel.org, wli@holomorphy.com
Subject: [patch 26/28] Add cmpxchg_local to sparc64
Content-Disposition: inline; filename=add-cmpxchg-local-to-sparc64.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:10 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use cmpxchg_u32 and cmpxchg_u64 for cmpxchg_local and cmpxchg64_local. For other
type sizes, use the new generic cmpxchg_local (disables interrupt).

Change:
Since the header depends on local_irqsave/local_irqrestore, it must be
included after their declaration.

Actually, being below the
#include <linux/irqflags.h> should be enough, and on sparc64 it is
included at the beginning of system.h.

So it makes sense to move it up for sparc64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: sparclinux@vger.kernel.org
CC: wli@holomorphy.com
---
 include/asm-sparc64/system.h |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: linux-2.6-lttng/include/asm-sparc64/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sparc64/system.h	2007-08-20 17:40:57.000000000 -0400
+++ linux-2.6-lttng/include/asm-sparc64/system.h	2007-08-20 19:42:32.000000000 -0400
@@ -9,6 +9,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/irqflags.h>
+#include <asm-generic/cmpxchg-local.h>
 
 /*
  * Sparc (general) CPU types
@@ -314,6 +315,30 @@ __cmpxchg(volatile void *ptr, unsigned l
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+	case 8:	return __cmpxchg(ptr, old, new, size);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+#define cmpxchg_local(ptr,o,n)					  	\
+	(__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr), (o), (n))
+
 #endif /* !(__ASSEMBLY__) */
 
 #define arch_align_stack(x) (x)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
