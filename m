Return-Path: <linux-kernel-owner+w=401wt.eu-S1761203AbXJaWrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761203AbXJaWrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760271AbXJaWmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51412 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759777AbXJaWm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:27 -0400
Message-Id: <20071031224217.736301231@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       lethal@linux-sh.org
Subject: [patch 23/28] Add cmpxchg_local to sh, use generic cmpxchg() instead of cmpxchg_u32
Content-Disposition: inline; filename=add-cmpxchg-local-to-sh.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new generic cmpxchg_local (disables interrupt). Also use the generic
cmpxchg as fallback if SMP is not set.

Since cmpxchg_u32 is _exactly_ the cmpxchg_local generic implementation, remove
it and use the generic version instead.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: lethal@linux-sh.org
---
 include/asm-sh/system.h |   52 ++++++++++++------------------------------------
 1 file changed, 14 insertions(+), 38 deletions(-)

Index: linux-2.6-lttng/include/asm-sh/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-sh/system.h	2007-10-31 17:32:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-sh/system.h	2007-10-31 18:27:24.000000000 -0400
@@ -199,47 +199,23 @@ extern void __xchg_called_with_bad_point
 	__xchg__res;					\
 })
 
-#define xchg(ptr,x)	\
-	((__typeof__(*(ptr)))__xchg((ptr),(unsigned long)(x), sizeof(*(ptr))))
+#define xchg(ptr, x)					\
+	((__typeof__(*(ptr)))__xchg((ptr), (unsigned long)(x), sizeof(*(ptr))))
 
-static inline unsigned long __cmpxchg_u32(volatile int * m, unsigned long old,
-	unsigned long new)
-{
-	__u32 retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	if (retval == old)
-		*m = new;
-	local_irq_restore(flags);       /* implies memory barrier  */
-	return retval;
-}
-
-/* This function doesn't exist, so you'll get a linker error
- * if something tries to do an invalid cmpxchg(). */
-extern void __cmpxchg_called_with_bad_pointer(void);
-
-#define __HAVE_ARCH_CMPXCHG 1
+#include <asm-generic/cmpxchg-local.h>
 
-static inline unsigned long __cmpxchg(volatile void * ptr, unsigned long old,
-		unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return __cmpxchg_u32(ptr, old, new);
-	}
-	__cmpxchg_called_with_bad_pointer();
-	return old;
-}
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
 
-#define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
 
 extern void die(const char *str, struct pt_regs *regs, long err) __attribute__ ((noreturn));
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
