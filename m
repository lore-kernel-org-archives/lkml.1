Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083Ab0A3Q2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0A3Q2c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964Ab0A3Q2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 11:28:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0A3Q2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 11:28:30 -0500
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       eranian@google.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <4B636646.50605@zytor.com>
References: <20100122155535.797688466@chello.nl>
	 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
	 <20100129020128.716af8fb.akpm@linux-foundation.org>
	 <1264763023.4283.2213.camel@laptop>  <4B636646.50605@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 17:28:11 +0100
Message-ID: <1264868891.24455.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 14:50 -0800, H. Peter Anvin wrote:

> I would personally say that the Right Way[TM] to do this is to call
> these __constant_hweightX() -- so the name reflects the function -- and
> then have
> 
> #define hweight(x) (__builtin_constant_p(x) ? __constant_hweight(x) :
> __arch_hweight(x))

I actually considered that, but since I didn't have a full cross compile
set around I wasn't sure.

The trouble is that asm/bitops.h used to be sufficient for hweightN(),
but with such a scheme we'd need linux/bitops.h.

Anyway, something like the below, I'll try and run it through the cross
compilers I have on monday or something.


---
 arch/alpha/include/asm/bitops.h      |   14 +++++++-------
 arch/sparc/include/asm/bitops_64.h   |    8 ++++----
 include/asm-generic/bitops/hweight.h |    8 ++++----
 include/linux/bitops.h               |   33 +++++++++++++++++++--------------
 lib/hweight.c                        |   19 ++++++++++---------
 5 files changed, 44 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/alpha/include/asm/bitops.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/bitops.h
+++ linux-2.6/arch/alpha/include/asm/bitops.h
@@ -405,24 +405,24 @@ static inline int fls(int x)
 
 #if defined(CONFIG_ALPHA_EV6) && defined(CONFIG_ALPHA_EV67)
 /* Whee.  EV67 can calculate it directly.  */
-static inline unsigned long hweight64(unsigned long w)
+static inline unsigned long __arch_hweight64(unsigned long w)
 {
 	return __kernel_ctpop(w);
 }
 
-static inline unsigned int hweight32(unsigned int w)
+static inline unsigned int __arch_hweight32(unsigned int w)
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
 #include <asm-generic/bitops/hweight.h>
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
 
Index: linux-2.6/include/asm-generic/bitops/hweight.h
===================================================================
--- linux-2.6.orig/include/asm-generic/bitops/hweight.h
+++ linux-2.6/include/asm-generic/bitops/hweight.h
@@ -3,9 +3,9 @@
 
 #include <asm/types.h>
 
-extern unsigned int hweight32(unsigned int w);
-extern unsigned int hweight16(unsigned int w);
-extern unsigned int hweight8(unsigned int w);
-extern unsigned long hweight64(__u64 w);
+extern unsigned int __arch_hweight32(unsigned int w);
+extern unsigned int __arch_hweight16(unsigned int w);
+extern unsigned int __arch_hweight8(unsigned int w);
+extern unsigned long __arch_hweight64(__u64 w);
 
 #endif /* _ASM_GENERIC_BITOPS_HWEIGHT_H_ */
Index: linux-2.6/include/linux/bitops.h
===================================================================
--- linux-2.6.orig/include/linux/bitops.h
+++ linux-2.6/include/linux/bitops.h
@@ -40,16 +40,7 @@ static __inline__ int get_count_order(un
 	return order;
 }
 
-static inline unsigned long hweight_long(unsigned long w)
-{
-	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
-}
-
-/*
- * Clearly slow versions of the hweightN() functions, their benefit is
- * of course compile time evaluation of constant arguments.
- */
-#define HWEIGHT8(w)					\
+#define __const_hweight8(w)				\
       (	BUILD_BUG_ON_ZERO(!__builtin_constant_p(w)) +	\
 	(!!((w) & (1ULL << 0))) +			\
 	(!!((w) & (1ULL << 1))) +			\
@@ -60,15 +51,29 @@ static inline unsigned long hweight_long
 	(!!((w) & (1ULL << 6))) +			\
 	(!!((w) & (1ULL << 7)))	)
 
-#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8((w) >> 8))
-#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16((w) >> 16))
-#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32((w) >> 32))
+#define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w) >> 8))
+#define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
+#define __const_hweight64(w) (__const_hweight32(w) + __const_hweight32((w) >> 32))
+
+#define hweight8(w)	\
+	(__builtin_constant_p(w) ? __const_hweight8(w) : __arch_hweight8(w))
+#define hweight16(w)	\
+	(__builtin_constant_p(w) ? __const_hweight16(w) : __arch_hweight16(w))
+#define hweight32(w)	\
+	(__builtin_constant_p(w) ? __const_hweight32(w) : __arch_hweight32(w))
+#define hweight64(w)	\
+	(__builtin_constant_p(w) ? __const_hweight64(w) : __arch_hweight64(w))
 
 /*
  * Type invariant version that simply casts things to the
  * largest type.
  */
-#define HWEIGHT(w)   HWEIGHT64((u64)(w))
+#define HWEIGHT(w)   __const_hweight64((u64)(w))
+
+static inline unsigned long hweight_long(unsigned long w)
+{
+	return sizeof(w) == 4 ? hweight32(w) : hweight64(w);
+}
 
 /**
  * rol32 - rotate a 32-bit value left
Index: linux-2.6/lib/hweight.c
===================================================================
--- linux-2.6.orig/lib/hweight.c
+++ linux-2.6/lib/hweight.c
@@ -9,7 +9,7 @@
  * The Hamming Weight of a number is the total number of bits set in it.
  */
 
-unsigned int hweight32(unsigned int w)
+unsigned int __arhc_hweight32(unsigned int w)
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


