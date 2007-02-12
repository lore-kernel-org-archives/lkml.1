Return-Path: <linux-kernel-owner+w=401wt.eu-S964942AbXBLQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbXBLQnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964961AbXBLQnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:43:24 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:33573 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942AbXBLQnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:43:22 -0500
Date: Mon, 12 Feb 2007 11:43:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 10/10] atomic.h : Add atomic64 cmpxchg, xchg and add_unless to x86_64
Message-ID: <20070212164315.GD4518@Krystal>
References: <11712214684187-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214703522-git-send-email-mathieu.desnoyers@polymtl.ca> <p737iunhalo.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <p737iunhalo.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:34:34 up 10 days,  5:42,  5 users,  load average: 1.01, 1.09, 1.08
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> >  
> >  /**
> > @@ -402,7 +405,7 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
> >   */
> >  #define atomic_add_unless(v, a, u)				\
> >  ({								\
> > -	int c, old;						\
> > +	__typeof__((v)->counter) c, old;			\
> 
> This change seems useless. Please drop.
> 
> In general you should enforce atomic_t vs atomic64_t types on x86, otherwise
> people will write code that won't compile on other architectures 
> that have truly different implementations.
> 
> I would suggest using inlines.
> 
> -Andi

Hi Andi,

Yes, I agree this typeof is not needed and more error prone. All the
original atomic.h code that uses cmpxchg (which includes the
atomic_add_unless) uses defines instead of inline functions, probably to
circumvent a circular dependency between system.h and atomic.h on
powerpc (which my patch addresses). Therefore, it makes sense to use
inline functions that will provide type checking.

Digging into the FRV architecture shows me that it is also affected by
such a circular dependency. Here is the diff applying this against the
rest of my atomic.h patches.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

diff --git a/include/asm-alpha/atomic.h b/include/asm-alpha/atomic.h
index 7b4fba8..f5cb7b8 100644
--- a/include/asm-alpha/atomic.h
+++ b/include/asm-alpha/atomic.h
@@ -2,6 +2,7 @@
 #define _ALPHA_ATOMIC_H
 
 #include <asm/barrier.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -190,20 +191,21 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
@@ -215,20 +217,21 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
diff --git a/include/asm-arm/atomic.h b/include/asm-arm/atomic.h
index ea88aa6..b86b000 100644
--- a/include/asm-arm/atomic.h
+++ b/include/asm-arm/atomic.h
@@ -12,6 +12,7 @@
 #define __ASM_ARM_ATOMIC_H
 
 #include <linux/compiler.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 
diff --git a/include/asm-arm26/atomic.h b/include/asm-arm26/atomic.h
index 97e944f..d6dd423 100644
--- a/include/asm-arm26/atomic.h
+++ b/include/asm-arm26/atomic.h
@@ -20,7 +20,6 @@
 #ifndef __ASM_ARM_ATOMIC_H
 #define __ASM_ARM_ATOMIC_H
 
-
 #ifdef CONFIG_SMP
 #error SMP is NOT supported
 #endif
diff --git a/include/asm-avr32/atomic.h b/include/asm-avr32/atomic.h
diff --git a/include/asm-frv/atomic.h b/include/asm-frv/atomic.h
index 066386a..d425d8d 100644
--- a/include/asm-frv/atomic.h
+++ b/include/asm-frv/atomic.h
@@ -16,6 +16,7 @@
 
 #include <linux/types.h>
 #include <asm/spr-regs.h>
+#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
@@ -258,85 +259,23 @@ extern uint32_t __xchg_32(uint32_t i, volatile void *v);
 
 #define tas(ptr) (xchg((ptr), 1))
 
-/*****************************************************************************/
-/*
- * compare and conditionally exchange value with memory
- * - if (*ptr == test) then orig = *ptr; *ptr = test;
- * - if (*ptr != test) then orig = *ptr;
- */
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"0:						\n"	\
-			"	orcc		gr0,gr0,gr0,icc3	\n"	\
-			"	ckeq		icc3,cc7		\n"	\
-			"	ld.p		%M0,%1			\n"	\
-			"	orcr		cc7,cc7,cc3		\n"	\
-			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
-			"	bne		icc0,#0,1f		\n"	\
-			"	cst.p		%3,%M0		,cc3,#1	\n"	\
-			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
-			"	beq		icc3,#0,0b		\n"	\
-			"1:						\n"	\
-			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
-			: "r"(__xg_new), "NPr"(__xg_test)			\
-			: "memory", "cc7", "cc3", "icc3", "icc0"		\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = 0;							\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4: __xg_orig = __cmpxchg_32(__xg_ptr, __xg_test, __xg_new); break;	\
-	default:								\
-		__xg_orig = 0;							\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#endif
-
 #define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
diff --git a/include/asm-frv/bitops.h b/include/asm-frv/bitops.h
diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index 1166899..be303b3 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -13,7 +13,6 @@
 #define _ASM_SYSTEM_H
 
 #include <linux/linkage.h>
-#include <asm/atomic.h>
 
 struct thread_struct;
 
@@ -197,4 +196,73 @@ extern void free_initmem(void);
 
 #define arch_align_stack(x) (x)
 
+/*****************************************************************************/
+/*
+ * compare and conditionally exchange value with memory
+ * - if (*ptr == test) then orig = *ptr; *ptr = test;
+ * - if (*ptr != test) then orig = *ptr;
+ */
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"0:						\n"	\
+			"	orcc		gr0,gr0,gr0,icc3	\n"	\
+			"	ckeq		icc3,cc7		\n"	\
+			"	ld.p		%M0,%1			\n"	\
+			"	orcr		cc7,cc7,cc3		\n"	\
+			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
+			"	bne		icc0,#0,1f		\n"	\
+			"	cst.p		%3,%M0		,cc3,#1	\n"	\
+			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
+			"	beq		icc3,#0,0b		\n"	\
+			"1:						\n"	\
+			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
+			: "r"(__xg_new), "NPr"(__xg_test)			\
+			: "memory", "cc7", "cc3", "icc3", "icc0"		\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = 0;							\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4: __xg_orig = __cmpxchg_32(__xg_ptr, __xg_test, __xg_new); break;	\
+	default:								\
+		__xg_orig = 0;							\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#endif
+
+
 #endif /* _ASM_SYSTEM_H */
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 069576f..8cc36d8 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -9,7 +9,6 @@
  */
 
 #include <asm/types.h>
-#include <asm/system.h>
 
 /*
  * Suppport for atomic_long_t
@@ -123,8 +122,12 @@ static inline long atomic_long_dec_return(atomic_long_t *l)
 	return (long)atomic64_dec_return(v);
 }
 
-#define atomic_long_add_unless(l, a, u) \
-	atomic64_add_unless((atomic64_t *)(l), (a), (u))
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic64_t *v = (atomic64_t *)l;
+	
+	return (long)atomic64_add_unless(v, a, u);
+}
 
 #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
 
@@ -236,8 +239,12 @@ static inline long atomic_long_dec_return(atomic_long_t *l)
 	return (long)atomic_dec_return(v);
 }
 
-#define atomic_long_add_unless(l, a, u) \
-	atomic_add_unless((atomic_t *)(l), (a), (u))
+static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
+{
+	atomic_t *v = (atomic_t *)l;
+	
+	return (long)atomic_add_unless(v, a, u);
+}
 
 #define atomic_long_inc_not_zero(l) atomic_inc_not_zero((atomic_t *)(l))
 
diff --git a/include/asm-i386/atomic.h b/include/asm-i386/atomic.h
index 9bd1050..17e4376 100644
--- a/include/asm-i386/atomic.h
+++ b/include/asm-i386/atomic.h
@@ -219,20 +219,21 @@ static __inline__ int atomic_sub_return(int i, atomic_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_inc_return(v)  (atomic_add_return(1,v))
diff --git a/include/asm-ia64/atomic.h b/include/asm-ia64/atomic.h
index b16ad23..1fc3b83 100644
--- a/include/asm-ia64/atomic.h
+++ b/include/asm-ia64/atomic.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
+#include <asm/system.h>
 
 /*
  * On IA-64, counter must always be volatile to ensure that that the
@@ -95,36 +96,38 @@ ia64_atomic64_sub (__s64 i, atomic64_t *v)
 	(cmpxchg(&((v)->counter), old, new))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__(v->counter) c, old;				\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__(v->counter) c, old;				\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic_add_return(i,v)						\
diff --git a/include/asm-m32r/atomic.h b/include/asm-m32r/atomic.h
index 873e656..663ac88 100644
--- a/include/asm-m32r/atomic.h
+++ b/include/asm-m32r/atomic.h
@@ -253,14 +253,21 @@ static __inline__ int atomic_dec_return(atomic_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static __inline__ void atomic_clear_mask(unsigned long  mask, atomic_t *addr)
diff --git a/include/asm-m68k/atomic.h b/include/asm-m68k/atomic.h
index e2dfbde..a1b64a6 100644
--- a/include/asm-m68k/atomic.h
+++ b/include/asm-m68k/atomic.h
@@ -2,7 +2,7 @@
 #define __ARCH_M68K_ATOMIC__
 
 
-#include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -170,20 +170,21 @@ static inline void atomic_set_mask(unsigned long mask, unsigned long *v)
 	__asm__ __volatile__("orl %1,%0" : "+m" (*v) : "id" (mask));
 }
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
diff --git a/include/asm-m68knommu/atomic.h b/include/asm-m68knommu/atomic.h
index 18a2e3b..b20e2cb 100644
--- a/include/asm-m68knommu/atomic.h
+++ b/include/asm-m68knommu/atomic.h
@@ -1,7 +1,7 @@
 #ifndef __ARCH_M68KNOMMU_ATOMIC__
 #define __ARCH_M68KNOMMU_ATOMIC__
 
-#include <asm/system.h>	/* local_irq_XXX() */
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -131,14 +131,21 @@ static inline int atomic_sub_return(int i, atomic_t * v)
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
diff --git a/include/asm-mips/atomic.h b/include/asm-mips/atomic.h
index 01a0303..fa9f742 100644
--- a/include/asm-mips/atomic.h
+++ b/include/asm-mips/atomic.h
@@ -18,6 +18,7 @@
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 
@@ -303,14 +304,20 @@ static __inline__ int atomic_sub_if_positive(int i, atomic_t * v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
@@ -664,14 +671,21 @@ static __inline__ long atomic64_sub_if_positive(long i, atomic64_t * v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic64_dec_return(v) atomic64_sub_return(1,(v))
diff --git a/include/asm-parisc/atomic.h b/include/asm-parisc/atomic.h
index 09404ab..afb7cf5 100644
--- a/include/asm-parisc/atomic.h
+++ b/include/asm-parisc/atomic.h
@@ -6,6 +6,7 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
+#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -174,14 +175,21 @@ static __inline__ int atomic_read(const atomic_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic_add(i,v)	((void)(__atomic_add_return( ((int)i),(v))))
@@ -283,14 +291,21 @@ atomic64_read(const atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;						\
-	c = atomic64_read(v);					\
-	while (c != (u) && (old = atomic64_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 
diff --git a/include/asm-powerpc/atomic.h b/include/asm-powerpc/atomic.h
index 438a7fc..c44810b 100644
--- a/include/asm-powerpc/atomic.h
+++ b/include/asm-powerpc/atomic.h
@@ -11,6 +11,7 @@ typedef struct { volatile int counter; } atomic_t;
 #include <linux/compiler.h>
 #include <asm/synch.h>
 #include <asm/asm-compat.h>
+#include <asm/system.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
diff --git a/include/asm-ppc/system.h b/include/asm-ppc/system.h
index 7389435..56abe5e 100644
--- a/include/asm-ppc/system.h
+++ b/include/asm-ppc/system.h
@@ -6,7 +6,6 @@
 
 #include <linux/kernel.h>
 
-#include <asm/atomic.h>
 #include <asm/hw_irq.h>
 
 /*
diff --git a/include/asm-sparc64/atomic.h b/include/asm-sparc64/atomic.h
index c3feb3a..3fb4e1f 100644
--- a/include/asm-sparc64/atomic.h
+++ b/include/asm-sparc64/atomic.h
@@ -9,6 +9,7 @@
 #define __ARCH_SPARC64_ATOMIC__
 
 #include <linux/types.h>
+#include <asm/system.h>
 
 typedef struct { volatile int counter; } atomic_t;
 typedef struct { volatile __s64 counter; } atomic64_t;
@@ -73,40 +74,42 @@ extern int atomic64_sub_ret(int, atomic64_t *);
 #define atomic_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	likely(c != (u));					\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 #define atomic64_cmpxchg(v, o, n) \
 	((__typeof__((v)->counter))cmpxchg(&((v)->counter), (o), (n)))
 #define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
 
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	likely(c != (u));					\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* Atomic operations are already serializing */
diff --git a/include/asm-x86_64/atomic.h b/include/asm-x86_64/atomic.h
index 80e4fdb..19e0c60 100644
--- a/include/asm-x86_64/atomic.h
+++ b/include/asm-x86_64/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_X86_64_ATOMIC__
 
 #include <asm/alternative.h>
+#include <asm/system.h>
 
 /* atomic_t should be 32 bit signed type */
 
@@ -403,20 +404,21 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic_cmpxchg((v), c, c + (a));		\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 /**
@@ -428,20 +430,21 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t *v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic64_add_unless(v, a, u)				\
-({								\
-	__typeof__((v)->counter) c, old;			\
-	c = atomic64_read(v);					\
-	for (;;) {						\
-		if (unlikely(c == (u)))				\
-			break;					\
-		old = atomic64_cmpxchg((v), c, c + (a));	\
-		if (likely(old == c))				\
-			break;					\
-		c = old;					\
-	}							\
-	c != (u);						\
-})
+static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 /* These are x86-specific, used by some header files */
diff --git a/include/asm-xtensa/atomic.h b/include/asm-xtensa/atomic.h
index d73e0fe..9044303 100644
--- a/include/asm-xtensa/atomic.h
+++ b/include/asm-xtensa/atomic.h
@@ -234,14 +234,21 @@ static inline int atomic_sub_return(int i, atomic_t * v)
  * Atomically adds @a to @v, so long as it was not @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
