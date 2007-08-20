Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbXHTUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbXHTUVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbXHTUSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:18:45 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53640 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757858AbXHTUSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:18:41 -0400
Message-Id: <20070820201826.481712944@polymtl.ca>
References: <20070820201519.512791382@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:15:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
Subject: [patch 10/23] New cmpxchg_local (optimized for UP case) for m32r
Content-Disposition: inline; filename=add-cmpxchg-local-to-m32r.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:18:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add __xchg_local, xchg_local (define), __cmpxchg_local_u32, __cmpxchg_local,
cmpxchg_local(macro).

cmpxchg_local and cmpxchg64_local will use the architecture specific
__cmpxchg_local_u32 for 32 bits arguments, and use the generic
__cmpxchg_local_generic for 8, 16 and 64 bits arguments.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: takata@linux-m32r.org
CC: linux-m32r@ml.linux-m32r.org
---
 include/asm-m32r/system.h |  103 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 97 insertions(+), 6 deletions(-)

Index: linux-2.6-lttng/include/asm-m32r/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-m32r/system.h	2007-08-07 14:31:52.000000000 -0400
+++ linux-2.6-lttng/include/asm-m32r/system.h	2007-08-07 14:55:02.000000000 -0400
@@ -123,6 +123,9 @@ static inline void local_irq_disable(voi
 
 #define xchg(ptr,x) \
 	((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+#define xchg_local(ptr,x) \
+	((__typeof__(*(ptr)))__xchg_local((unsigned long)(x),(ptr), \
+			sizeof(*(ptr))))
 
 #ifdef CONFIG_SMP
 extern void  __xchg_called_with_bad_pointer(void);
@@ -196,6 +199,42 @@ __xchg(unsigned long x, volatile void * 
 	return (tmp);
 }
 
+static __always_inline unsigned long
+__xchg_local(unsigned long x, volatile void * ptr, int size)
+{
+	unsigned long flags;
+	unsigned long tmp = 0;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		__asm__ __volatile__ (
+			"ldb	%0, @%2 \n\t"
+			"stb	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 2:
+		__asm__ __volatile__ (
+			"ldh	%0, @%2 \n\t"
+			"sth	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	case 4:
+		__asm__ __volatile__ (
+			"ld	%0, @%2 \n\t"
+			"st	%1, @%2 \n\t"
+			: "=&r" (tmp) : "r" (x), "r" (ptr) : "memory");
+		break;
+	default:
+		__xchg_called_with_bad_pointer();
+	}
+
+	local_irq_restore(flags);
+
+	return (tmp);
+}
+
 #define __HAVE_ARCH_CMPXCHG	1
 
 static inline unsigned long
@@ -228,6 +267,37 @@ __cmpxchg_u32(volatile unsigned int *p, 
 	return retval;
 }
 
+static inline unsigned long
+__cmpxchg_local_u32(volatile unsigned int *p, unsigned int old,
+			unsigned int new)
+{
+	unsigned long flags;
+	unsigned int retval;
+
+	local_irq_save(flags);
+	__asm__ __volatile__ (
+			DCACHE_CLEAR("%0", "r4", "%1")
+			"ld %0, @%1;		\n"
+		"	bne	%0, %2, 1f;	\n"
+			"st %3, @%1;		\n"
+		"	bra	2f;		\n"
+                "       .fillinsn		\n"
+		"1:"
+			"st %0, @%1;		\n"
+                "       .fillinsn		\n"
+		"2:"
+			: "=&r" (retval)
+			: "r" (p), "r" (old), "r" (new)
+			: "cbit", "memory"
+#ifdef CONFIG_CHIP_M32700_TS1
+			, "r4"
+#endif  /* CONFIG_CHIP_M32700_TS1 */
+		);
+	local_irq_restore(flags);
+
+	return retval;
+}
+
 /* This function doesn't exist, so you'll get a linker error
    if something tries to do an invalid cmpxchg().  */
 extern void __cmpxchg_called_with_bad_pointer(void);
@@ -248,12 +318,33 @@ __cmpxchg(volatile void *ptr, unsigned l
 }
 
 #define cmpxchg(ptr,o,n)						 \
-  ({									 \
-     __typeof__(*(ptr)) _o_ = (o);					 \
-     __typeof__(*(ptr)) _n_ = (n);					 \
-     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)_o_,		 \
-				    (unsigned long)_n_, sizeof(*(ptr))); \
-  })
+     (__typeof__(*(ptr))) __cmpxchg((ptr), (unsigned long)(o),		 \
+				    (unsigned long)(n), sizeof(*(ptr)))
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_local_u32(ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr,o,n)					  	    \
+     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	    \
+			   	 (unsigned long)(n), sizeof(*(ptr)))
+#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
 
 #endif  /* __KERNEL__ */
 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
