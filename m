Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXH0P4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXH0P4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756938AbXH0Pzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:55:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:41857 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbXH0Pzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:55:36 -0400
Message-Id: <20070827155526.831912786@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:52:44 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       starvik@axis.com
Subject: [patch 10/28] Add cmpxchg_local to cris
Content-Disposition: inline; filename=add-cmpxchg-local-to-cris.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 15:55:27 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: starvik@axis.com
---
 include/asm-cris/system.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6-lttng/include/asm-cris/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-cris/system.h	2007-08-07 14:31:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-cris/system.h	2007-08-07 14:48:53.000000000 -0400
@@ -66,6 +66,21 @@ static inline unsigned long __xchg(unsig
   return x;
 }
 
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
 
 void default_idle(void);

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
