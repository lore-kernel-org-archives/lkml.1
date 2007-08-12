Return-Path: <linux-kernel-owner+w=401wt.eu-S1764561AbXHLPAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764561AbXHLPAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbXHLO6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 10:58:49 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46490 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbXHLO6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 10:58:43 -0400
Message-Id: <20070812145837.708577781@polymtl.ca>
References: <20070812145434.520271946@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 10:54:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 08/23] Add cmpxchg_local to h8300
Content-Disposition: inline; filename=add-cmpxchg-local-to-h8300.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 14:58:38 +0000
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
