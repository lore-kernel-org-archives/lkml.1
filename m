Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbXBKT2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbXBKT2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXBKT2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:28:15 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:50225 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932103AbXBKT2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:28:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH 07/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to powerpc
Date: Sun, 11 Feb 2007 14:17:45 -0500
Message-Id: <11712214692483-git-send-email-mathieu.desnoyers@polymtl.ca>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

atomic.h : Add atomic64 cmpxchg, xchg and add_unless to powerpc

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-powerpc/atomic.h
+++ b/include/asm-powerpc/atomic.h
@@ -165,7 +165,7 @@ static __inline__ int atomic_dec_return(atomic_t *v)
 	return t;
 }
 
-#define atomic_cmpxchg(v, o, n) ((int)cmpxchg(&((v)->counter), (o), (n)))
+#define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
@@ -413,6 +413,42 @@ static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
 	return t;
 }
 
+#define atomic64_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long t;
+
+	__asm__ __volatile__ (
+	LWSYNC_ON_SMP
+"1:	ldarx	%0,0,%1		# atomic_add_unless\n\
+	cmpd	0,%0,%3 \n\
+	beq-	2f \n\
+	add	%0,%2,%0 \n"
+"	stdcx.	%0,0,%1 \n\
+	bne-	1b \n"
+	ISYNC_ON_SMP
+"	subf	%0,%2,%0 \n\
+2:"
+	: "=&r" (t)
+	: "r" (&v->counter), "r" (a), "r" (u)
+	: "cc", "memory");
+
+	return t != u;
+}
+
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
 #endif /* __powerpc64__ */
 
 #include <asm-generic/atomic.h>
--- a/include/asm-powerpc/bitops.h
+++ b/include/asm-powerpc/bitops.h
@@ -39,7 +39,6 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
-#include <asm/atomic.h>
 #include <asm/asm-compat.h>
 #include <asm/synch.h>
 
--- a/include/asm-powerpc/system.h
+++ b/include/asm-powerpc/system.h
@@ -7,7 +7,6 @@
 #include <linux/kernel.h>
 
 #include <asm/hw_irq.h>
-#include <asm/atomic.h>
 
 /*
  * Memory barrier.
@@ -226,6 +225,29 @@ __xchg_u32(volatile void *p, unsigned long val)
 	return prev;
 }
 
+/*
+ * Atomic exchange
+ *
+ * Changes the memory location '*ptr' to be val and returns
+ * the previous value stored there.
+ */
+static __inline__ unsigned long
+__xchg_u32_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	lwarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned int *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
+
 #ifdef CONFIG_PPC64
 static __inline__ unsigned long
 __xchg_u64(volatile void *p, unsigned long val)
@@ -245,6 +267,23 @@ __xchg_u64(volatile void *p, unsigned long val)
 
 	return prev;
 }
+
+static __inline__ unsigned long
+__xchg_u64_local(volatile void *p, unsigned long val)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__(
+"1:	ldarx	%0,0,%2 \n"
+	PPC405_ERR77(0,%2)
+"	stdcx.	%3,0,%2 \n\
+	bne-	1b"
+	: "=&r" (prev), "+m" (*(volatile unsigned long *)p)
+	: "r" (p), "r" (val)
+	: "cc", "memory");
+
+	return prev;
+}
 #endif
 
 /*
@@ -268,12 +307,33 @@ __xchg(volatile void *ptr, unsigned long x, unsigned int size)
 	return x;
 }
 
+static __inline__ unsigned long
+__xchg_local(volatile void *ptr, unsigned long x, unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __xchg_u32_local(ptr, x);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __xchg_u64_local(ptr, x);
+#endif
+	}
+	__xchg_called_with_bad_pointer();
+	return x;
+}
 #define xchg(ptr,x)							     \
   ({									     \
      __typeof__(*(ptr)) _x_ = (x);					     \
      (__typeof__(*(ptr))) __xchg((ptr), (unsigned long)_x_, sizeof(*(ptr))); \
   })
 
+#define xchg_local(ptr,x)						     \
+  ({									     \
+     __typeof__(*(ptr)) _x_ = (x);					     \
+     (__typeof__(*(ptr))) __xchg_local((ptr),				     \
+     		(unsigned long)_x_, sizeof(*(ptr))); 			     \
+  })
+
 #define tas(ptr) (xchg((ptr),1))
 
 /*
@@ -305,6 +365,28 @@ __cmpxchg_u32(volatile unsigned int *p, unsigned long old, unsigned long new)
 	return prev;
 }
 
+static __inline__ unsigned long
+__cmpxchg_u32_local(volatile unsigned int *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned int prev;
+
+	__asm__ __volatile__ (
+"1:	lwarx	%0,0,%2		# __cmpxchg_u32\n\
+	cmpw	0,%0,%3\n\
+	bne-	2f\n"
+	PPC405_ERR77(0,%2)
+"	stwcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
+
 #ifdef CONFIG_PPC64
 static __inline__ unsigned long
 __cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
@@ -327,6 +409,27 @@ __cmpxchg_u64(volatile unsigned long *p, unsigned long old, unsigned long new)
 
 	return prev;
 }
+
+static __inline__ unsigned long
+__cmpxchg_u64_local(volatile unsigned long *p, unsigned long old,
+			unsigned long new)
+{
+	unsigned long prev;
+
+	__asm__ __volatile__ (
+"1:	ldarx	%0,0,%2		# __cmpxchg_u64\n\
+	cmpd	0,%0,%3\n\
+	bne-	2f\n\
+	stdcx.	%4,0,%2\n\
+	bne-	1b"
+	"\n\
+2:"
+	: "=&r" (prev), "+m" (*p)
+	: "r" (p), "r" (old), "r" (new)
+	: "cc", "memory");
+
+	return prev;
+}
 #endif
 
 /* This function doesn't exist, so you'll get a linker error
@@ -349,6 +452,22 @@ __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
 	return old;
 }
 
+static __inline__ unsigned long
+__cmpxchg_local(volatile void *ptr, unsigned long old, unsigned long new,
+	  unsigned int size)
+{
+	switch (size) {
+	case 4:
+		return __cmpxchg_u32_local(ptr, old, new);
+#ifdef CONFIG_PPC64
+	case 8:
+		return __cmpxchg_u64_local(ptr, old, new);
+#endif
+	}
+	__cmpxchg_called_with_bad_pointer();
+	return old;
+}
+
 #define cmpxchg(ptr,o,n)						 \
   ({									 \
      __typeof__(*(ptr)) _o_ = (o);					 \
@@ -357,6 +476,15 @@ __cmpxchg(volatile void *ptr, unsigned long old, unsigned long new,
 				    (unsigned long)_n_, sizeof(*(ptr))); \
   })
 
+
+#define cmpxchg_local(ptr,o,n)						 \
+  ({									 \
+     __typeof__(*(ptr)) _o_ = (o);					 \
+     __typeof__(*(ptr)) _n_ = (n);					 \
+     (__typeof__(*(ptr))) __cmpxchg_local((ptr), (unsigned long)_o_,	 \
+				    (unsigned long)_n_, sizeof(*(ptr))); \
+  })
+
 #ifdef CONFIG_PPC64
 /*
  * We handle most unaligned accesses in hardware. On the other hand 
