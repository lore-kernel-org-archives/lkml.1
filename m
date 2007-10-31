Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbXJaWok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbXJaWok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759792AbXJaWm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:26 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51382 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759000AbXJaWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:23 -0400
Message-Id: <20071031224211.814532139@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [patch 05/28] Add cmpxchg64 and cmpxchg64_local to powerpc
Content-Disposition: inline; filename=add-cmpxchg64-to-powerpc.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that at least cmpxchg64_local is available on all architectures to use
for unsigned long long values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Paul Mackerras <paulus@samba.org>
CC: linuxppc-dev@ozlabs.org
---
 include/asm-powerpc/system.h |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/include/asm-powerpc/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/system.h	2007-10-31 17:32:44.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/system.h	2007-10-31 17:56:25.000000000 -0400
@@ -461,7 +461,7 @@ __cmpxchg_local(volatile void *ptr, unsi
 	return old;
 }
 
-#define cmpxchg(ptr,o,n)						 \
+#define cmpxchg(ptr, o, n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
@@ -470,7 +470,7 @@ __cmpxchg_local(volatile void *ptr, unsi
   })
 
 
-#define cmpxchg_local(ptr,o,n)						 \
+#define cmpxchg_local(ptr, o, n)					 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
      __typeof__(*(ptr)) _n_ = (n);					 \
@@ -490,6 +490,20 @@ __cmpxchg_local(volatile void *ptr, unsi
  */
 #define NET_IP_ALIGN	0
 #define NET_SKB_PAD	L1_CACHE_BYTES
+
+#define cmpxchg64(ptr, o, n)						\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg((ptr), (o), (n));					\
+  })
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#include <asm-generic/cmpxchg-local.h>
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 #endif
 
 #define arch_align_stack(x) (x)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
