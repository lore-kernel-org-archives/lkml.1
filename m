Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbXJaWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbXJaWut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760535AbXJaWmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:42:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:51477 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517AbXJaWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:42:35 -0400
Message-Id: <20071031224217.445923204@polymtl.ca>
References: <20071031223710.099558229@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 18:37:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, clameter@sgi.com,
       schwidefsky@de.ibm.com, linux390@de.ibm.com
Subject: [patch 22/28] Add cmpxchg_local to s390
Content-Disposition: inline; filename=add-cmpxchg-local-to-s390.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 22:42:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard __cmpxchg for every type that can be updated atomically.
Use the new generic cmpxchg_local (disables interrupt) for other types.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: clameter@sgi.com
CC: schwidefsky@de.ibm.com
CC: linux390@de.ibm.com
---
 include/asm-s390/system.h |   44 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

Index: linux-2.6-lttng/include/asm-s390/system.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-s390/system.h	2007-10-31 17:32:43.000000000 -0400
+++ linux-2.6-lttng/include/asm-s390/system.h	2007-10-31 18:26:02.000000000 -0400
@@ -201,9 +201,9 @@ static inline unsigned long __xchg(unsig
 
 #define __HAVE_ARCH_CMPXCHG 1
 
-#define cmpxchg(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
-					(unsigned long)(n),sizeof(*(ptr))))
+#define cmpxchg(ptr, o, n)						\
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	\
+					(unsigned long)(n), sizeof(*(ptr))))
 
 extern void __cmpxchg_called_with_bad_pointer(void);
 
@@ -355,6 +355,44 @@ __cmpxchg(volatile void *ptr, unsigned l
 
 #include <linux/irqflags.h>
 
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+#ifdef __s390x__
+	case 8:
+#endif
+		return __cmpxchg(ptr, old, new, size);
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
+#define cmpxchg_local(ptr, o, n)					\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#ifdef __s390x__
+#define cmpxchg64_local(ptr, o, n)					\
+  ({									\
+	BUILD_BUG_ON(sizeof(*(ptr)) != 8);				\
+	cmpxchg_local((ptr), (o), (n));					\
+  })
+#else
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+#endif
+
 /*
  * Use to set psw mask except for the first byte which
  * won't be changed by this function.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
