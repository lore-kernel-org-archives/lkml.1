Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab0BAMo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:44:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab0BAMoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:44:24 -0500
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       eranian@google.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <1264868891.24455.76.camel@laptop>
References: <20100122155535.797688466@chello.nl>
	 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
	 <20100129020128.716af8fb.akpm@linux-foundation.org>
	 <1264763023.4283.2213.camel@laptop>  <4B636646.50605@zytor.com>
	 <1264868891.24455.76.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 13:43:44 +0100
Message-ID: <1265028224.24455.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-30 at 17:28 +0100, Peter Zijlstra wrote:
> On Fri, 2010-01-29 at 14:50 -0800, H. Peter Anvin wrote:
> 
> > I would personally say that the Right Way[TM] to do this is to call
> > these __constant_hweightX() -- so the name reflects the function -- and
> > then have
> > 
> > #define hweight(x) (__builtin_constant_p(x) ? __constant_hweight(x) :
> > __arch_hweight(x))
> 
> I actually considered that, but since I didn't have a full cross compile
> set around I wasn't sure.
> 
> The trouble is that asm/bitops.h used to be sufficient for hweightN(),
> but with such a scheme we'd need linux/bitops.h.
> 
> Anyway, something like the below, I'll try and run it through the cross
> compilers I have on monday or something.

Ok, that didn't compile, utter include dependency hell.

The below does work, but is still a tad ugly in that if you want to use
any of the HWEIGHT functions that use BUILD_BUG_ON_ZERO() you have to
have included linux/kernel.h yourself.

But at least it builds on x86_64, alpha and sparc64 (didn't have a ia64
compiler around).

FWIW I was tempted to change the return type of hweight64() from
unsigned long to unsigned int, its not as if it'll ever return a value
larger than 64.

---
 arch/alpha/include/asm/bitops.h            |   18 ++++++------
 arch/ia64/include/asm/bitops.h             |   11 ++++---
 arch/sparc/include/asm/bitops_64.h         |   11 ++++---
 include/asm-generic/bitops/arch_hweight.h  |   11 +++++++
 include/asm-generic/bitops/const_hweight.h |   42 +++++++++++++++++++++++++++++
 include/asm-generic/bitops/hweight.h       |    8 +----
 include/linux/bitops.h                     |   25 -----------------
 lib/hweight.c                              |   19 ++++++-------
 8 files changed, 87 insertions(+), 58 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/bitops.h
+++ linux-2.6/arch/alpha/include/asm/bitops.h
@@ -405,29 +405,31 @@ static inline int fls(int x)
 
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
 /* Whee.  EV67 can calculate it directly.  */
-static inline unsigned long hweight64(unsigned long w)
+static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_weight32(unsigned int w)
 {
-	return hweight64(w);
+	return __arch_hweight64(w);
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
-	return hweight64(w & 0xffff);
+	return __arch_hweight64(w & 0xffff);
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
-	return hweight64(w & 0xff);
+	return __arch_hweight64(w & 0xff);
 }
 #else
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 #endif
 
+#include <asm-generic/bitops/const_hweight.h>
+
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
Index: linux-2.6/arch/ia64/include/asm/bitops.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/bitops.h
+++ linux-2.6/arch/ia64/include/asm/bitops.h
@@ -437,17 +437,18 @@ __fls (unsigned long x)
  * hweightN: returns the hamming weight (i.e. the number
  * of bits set) of a N-bit word
  */
-static __inline__ unsigned long
-hweight64 (unsigned long x)
+static __inline__ unsigned long __arch_hweight64(unsigned long x)
 {
 	unsigned long result;
 	result = ia64_popcnt(x);
 	return result;
 }
 
-#define hweight32(x)	(unsigned int) hweight64((x) & 0xfffffffful)
-#define hweight16(x)	(unsigned int) hweight64((x) & 0xfffful)
-#define hweight8(x)	(unsigned int) hweight64((x) & 0xfful)
+#define __arch_hweight32(x) ((unsigned int) __arch_hweight64((x) & 0xfffffffful))
+#define __arch_hweight16(x) ((unsigned int) __arch_hweight64((x) & 0xfffful))
+#define __arch_hweight8(x)  ((unsigned int) __arch_hweight64((x) & 0xfful))
+
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/arch/sparc/include/asm/bitops_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/bitops_64.h
+++ linux-2.6/arch/sparc/include/asm/bitops_64.h
@@ -44,7 +44,7 @@ extern void change_bit(unsigned long nr,
 
 #ifdef ULTRA_HAS_POPULATION_COUNT
 
-static inline unsigned int hweight64(unsigned long w)
+static inline unsigned int __arch_hweight64(unsigned long w)
 {
 	unsigned int res;
 
@@ -52,7 +52,7 @@ static inline unsigned int hweight64(uns
 	return res;
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res;
 
@@ -60,7 +60,7 @@ static inline unsigned int hweight32(uns
 	return res;
 }
 
-static inline unsigned int hweight16(unsigned int w)
+static inline unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res;
 
@@ -68,7 +68,7 @@ static inline unsigned int hweight16(uns
 	return res;
 }
 
-static inline unsigned int hweight8(unsigned int w)
+static inline unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res;
 
@@ -78,9 +78,10 @@ static inline unsigned int hweight8(unsi
 
 #else
 
-#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/arch_hweight.h>
 
 #endif
+#include <asm-generic/bitops/const_hweight.h>
 #include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-generic/bitops/arch_hweight.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/bitops/arch_hweight.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_ARCH_HWEIGHT_H_
+
+#include <asm/types.h>
+
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
+
+#endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
Index: linux-2.6/include/asm-generic/bitops/const_hweight.h
===================================================================
--- /dev/null
+++ linux-2.6/include/asm-generic/bitops/const_hweight.h
@@ -0,0 +1,42 @@
+#ifndef _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+#define _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_
+
+/*
+ * Compile time versions of __arch_hweightN()
+ */
+#define __const_hweight8(w)		\
+      (	(!!((w) & (1ULL << 0))) +	\
+	(!!((w) & (1ULL << 1))) +	\
+	(!!((w) & (1ULL << 2))) +	\
+	(!!((w) & (1ULL << 3))) +	\
+	(!!((w) & (1ULL << 4))) +	\
+	(!!((w) & (1ULL << 5))) +	\
+	(!!((w) & (1ULL << 6))) +	\
+	(!!((w) & (1ULL << 7)))	)
+
+#define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
+#define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
+#define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
+
+/*
+ * Generic interface.
+ */
+#define hweight8(w)  (__builtin_constant_p(w) ? __const_hweight8(w)  : __arch_hweight8(w))
+#define hweight16(w) (__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
+#define hweight32(w) (__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
+#define hweight64(w) (__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
+
+/*
+ * Interface for known constant arguments
+ */
+#define HWEIGHT8(w)  (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight8(w))
+#define HWEIGHT16(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight16(w))
+#define HWEIGHT32(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight32(w))
+#define HWEIGHT64(w) (BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) + __const_hweight64(w))
+
+/*
+ * Type invariant interface to the compile time constant hweight functions.
+ */
+#define HWEIGHT(w)   HWEIGHT64((u64)w)
+
+#endif /* _ASM_GENERIC_BITOPS_CONST_HWEIGHT_H_ */
Index: linux-2.6/include/asm-generic/bitops/hweight.h
===================================================================
--- linux-2.6.orig/include/asm-generic/bitops/hweight.h
+++ linux-2.6/include/asm-generic/bitops/hweight.h
@@ -1,11 +1,7 @@
 #ifndef _ASM_GENERIC_BITOPS_HWEIGHT_H_
 #define _ASM_GENERIC_BITOPS_HWEIGHT_H_
 
-#include <asm/types.h>
-
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+#include <asm-generic/bitops/arch_hweight.h>
+#include <asm-generic/bitops/const_hweight.h>
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -45,31 +45,6 @@ static inline unsigned long hweight_long
 	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
 }
 
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
-      (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
-	(!!((w) & (1ULL << 0))) +			\
-	(!!((w) & (1ULL << 1))) +			\
-	(!!((w) & (1ULL << 2))) +			\
-	(!!((w) & (1ULL << 3))) +			\
-	(!!((w) & (1ULL << 4))) +			\
-	(!!((w) & (1ULL << 5))) +			\
-	(!!((w) & (1ULL << 6))) +			\
-	(!!((w) & (1ULL << 7)))	)
-
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
-
-/*
- * Type invariant version that simply casts things to the
- * largest type.
- */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
-
 /**
  * rol32 - rotate a 32-bit value left
  * @word: value to rotate
Index: linux-2.6/lib/hweight.c
===================================================================
--- linux-2.6.orig/lib/hweight.c
+++ linux-2.6/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int __arch_hweight32(unsigned int w)
 {
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x55555555;
@@ -24,29 +24,30 @@ unsigned int hweight32(unsigned int w)
 	return (res + (res >> 16)) & 0x000000FF;
 #endif
 }
-EXPORT_SYMBOL(hweight32);
+EXPORT_SYMBOL(__arch_hweight32);
 
-unsigned int hweight16(unsigned int w)
+unsigned int __arch_hweight16(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x5555);
 	res = (res & 0x3333) + ((res >> 2) & 0x3333);
 	res = (res + (res >> 4)) & 0x0F0F;
 	return (res + (res >> 8)) & 0x00FF;
 }
-EXPORT_SYMBOL(hweight16);
+EXPORT_SYMBOL(__arch_hweight16);
 
-unsigned int hweight8(unsigned int w)
+unsigned int __arch_hweight8(unsigned int w)
 {
 	unsigned int res = w - ((w >> 1) & 0x55);
 	res = (res & 0x33) + ((res >> 2) & 0x33);
 	return (res + (res >> 4)) & 0x0F;
 }
-EXPORT_SYMBOL(hweight8);
+EXPORT_SYMBOL(__arch_hweight8);
 
-unsigned long hweight64(__u64 w)
+unsigned long __arch_hweight64(__u64 w)
 {
 #if BITS_PER_LONG == 32
-	return hweight32((unsigned int)(w >> 32)) + hweight32((unsigned int)w);
+	return __arch_hweight32((unsigned int)(w >> 32)) +
+	       __arch_hweight32((unsigned int)w);
 #elif BITS_PER_LONG == 64
 #ifdef ARCH_HAS_FAST_MULTIPLIER
 	w -= (w >> 1) & 0x5555555555555555ul;
@@ -63,4 +64,4 @@ unsigned long hweight64(__u64 w)
 #endif
 #endif
 }
-EXPORT_SYMBOL(hweight64);
+EXPORT_SYMBOL(__arch_hweight64);


