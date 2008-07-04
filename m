Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYGDEM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYGDEM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 00:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYGDEMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 00:12:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:62826 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGDEMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 00:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iUeVgYde5cuQrarv1kFFC7Cj4xe+6fTQTFk9HKXhm5WJ0aBaCRD5oa9FRledKjJk6O
         ksJvozN41TfPa+RwhgdnKP7ADUZBzVvEnwxdnTzOQfEL+LuFyAOJa1xI0ZLBcSCnS4Po
         bfKruzjaMyvs7SaZBaepJNYthUdrrISbZoapQ=
Subject: [PATCH 1/5] byteorder: add a new include/linux/swab.h to define
	byteswapping functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 21:12:11 -0700
Message-Id: <1215144731.16647.67.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect the implementations from include/linux/byteorder/swab.h, swabb.h
in swab.h

The functionality provided covers:
u16 swab16(u16 val) - return a byteswapped 16 bit value
u32 swab32(u32 val) - return a byteswapped 32 bit value
u64 swab64(u64 val) - return a byteswapped 64 bit value
u32 swahw32(u32 val) - return a wordswapped 32 bit value
u32 swahb32(u32 val) - return a high/low byteswapped 32 bit value

The above 5 allow for compiler-time constant folding, and are implemented such
that they can be used in any context (defines, case statements, etc).

Similar to above, but return swapped value from a naturally-aligned pointer
u16 swab16p(u16 *p)
u32 swab32p(u32 *p)
u64 swab64p(u64 *p)
u32 swahw32p(u32 *p)
u32 swahb32p(u32 *p)

Similar to above, but swap the value in-place (in-situ)
void swab16s(u16 *p)
void swab32s(u32 *p)
void swab64s(u64 *p)
void swahw32s(u32 *p)
void swahb32s(u32 *p)

Arches can override any of these with an optimized version by defining an
inline in their asm/byteorder.h (example given for swab16()):

u16 __arch_swab16() {}

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/swab.h |  309 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 309 insertions(+), 0 deletions(-)

diff --git a/include/linux/swab.h b/include/linux/swab.h
new file mode 100644
index 0000000..8f955b2
--- /dev/null
+++ b/include/linux/swab.h
@@ -0,0 +1,309 @@
+#ifndef _LINUX_SWAB_H
+#define _LINUX_SWAB_H
+
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <asm/byteorder.h>
+
+/*
+ * casts are necessary for constants, because we never know how for sure
+ * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
+ */
+#define __const_swab16(x) ((__u16)(				\
+	(((__u16)(x) & (__u16)0x00ffU) << 8) |			\
+	(((__u16)(x) & (__u16)0xff00U) >> 8)))
+
+#define __const_swab32(x) ((__u32)(				\
+	(((__u32)(x) & (__u32)0x000000ffUL) << 24) |		\
+	(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |		\
+	(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |		\
+	(((__u32)(x) & (__u32)0xff000000UL) >> 24)))
+
+#define __const_swab64(x) ((__u64)(				\
+	(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) |	\
+	(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) |	\
+	(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) |	\
+	(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) |	\
+	(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) |	\
+	(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) |	\
+	(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) |	\
+	(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56)))
+
+#define __const_swahw32(x) ((__u32)(				\
+	(((__u32)(x) & (__u32)0x0000ffffUL) << 16) |		\
+	(((__u32)(x) & (__u32)0xffff0000UL) >> 16)))
+
+#define __const_swahb32(x) ((__u32)(				\
+	(((__u32)(x) & (__u32)0x00ff00ffUL) << 8) |		\
+	(((__u32)(x) & (__u32)0xff00ff00UL) >> 8)))
+
+/*
+ * Implement the following as inlines, but define the interface using
+ * macros to allow constant folding when possible:
+ * ___swab16, ___swab32, ___swab64, ___swahw32, ___swahb32
+ */
+
+static inline __attribute_const__ __u16 ___swab16(__u16 val)
+{
+#ifdef HAVE_ARCH_SWAB16
+	return __arch_swab16(val);
+#elif defined(HAVE_ARCH_SWAB16P)
+	return __arch_swab16p(&val);
+#else
+	return __const_swab16(val);
+#endif
+}
+
+static inline __attribute_const__ __u32 ___swab32(__u32 val)
+{
+#ifdef HAVE_ARCH_SWAB32
+	return __arch_swab32(val);
+#elif defined(HAVE_ARCH_SWAB32P)
+	return __arch_swab32p(&val);
+#else
+	return __const_swab32(val);
+#endif
+}
+
+static inline __attribute_const__ __u64 ___swab64(__u64 val)
+{
+#ifdef HAVE_ARCH_SWAB64
+	return __arch_swab64(val);
+#elif defined(HAVE_ARCH_SWAB64P)
+	return __arch_swab64p(&val);
+#elif defined(__SWAB_64_THRU_32__)
+	__u32 h = val >> 32;
+	__u32 l = val & ((1ULL << 32) - 1);
+	return (((__u64)___swab32(l)) << 32) | ((__u64)(___swab32(h)));
+#else
+	return __const_swab64(val);
+#endif
+}
+
+static inline __attribute_const__ __u32 ___swahw32(__u32 val)
+{
+#ifdef HAVE_ARCH_SWAHW32
+	return __arch_swahw32(val);
+#elif defined(HAVE_ARCH_SWAHW32P)
+	return __arch_swahw32p(&val);
+#else
+	return __const_swahw32(val);
+#endif
+}
+
+static inline __attribute_const__ __u32 ___swahb32(__u32 val)
+{
+#ifdef HAVE_ARCH_SWAHB32
+	return __arch_swahb32(val);
+#elif defined(HAVE_ARCH_SWAHB32P)
+	return __arch_swahb32p(&val);
+#else
+	return __const_swahb32(val);
+#endif
+}
+
+/**
+ * __swab16 - return a byteswapped 16-bit value
+ * @x: value to byteswap
+ */
+#define __swab16(x)				\
+	(__builtin_constant_p((__u16)(x)) ?	\
+	__const_swab16((x)) :			\
+	___swab16((x)))
+
+/**
+ * __swab32 - return a byteswapped 32-bit value
+ * @x: value to byteswap
+ */
+#define __swab32(x)				\
+	(__builtin_constant_p((__u32)(x)) ?	\
+	__const_swab32((x)) :			\
+	___swab32((x)))
+
+/**
+ * __swab64 - return a byteswapped 64-bit value
+ * @x: value to byteswap
+ */
+#define __swab64(x)				\
+	(__builtin_constant_p((__u64)(x)) ?	\
+	__const_swab64((x)) :			\
+	___swab64((x)))
+
+/**
+ * __swahw32 - return a word-swapped 32-bit value
+ * @x: value to wordswap
+ *
+ * __swahw32(0x12340000) is 0x00001234
+ */
+#define __swahw32(x)				\
+	(__builtin_constant_p((__u32)(x)) ?	\
+	__const_swahw32((x)) :			\
+	___swahw32((x)))
+
+/**
+ * __swahb32 - return a high and low byte-swapped 32-bit value
+ * @x: value to byteswap
+ *
+ * __swahb32(0x12345678) is 0x34127856
+ */
+#define __swahb32(x)				\
+	(__builtin_constant_p((__u32)(x)) ?	\
+	__const_swahb32((x)) :			\
+	___swahb32((x)))
+
+/**
+ * __swab16p - return a byteswapped 16-bit value from a pointer
+ * @p: pointer to a naturally-aligned 16-bit value
+ */
+static inline __u16 __swab16p(const __u16 *p)
+{
+#ifdef HAVE_ARCH_SWAB16P
+	return __arch_swab16p(p);
+#else
+	return __swab16(*p);
+#endif
+}
+
+/**
+ * __swab32p - return a byteswapped 32-bit value from a pointer
+ * @p: pointer to a naturally-aligned 32-bit value
+ */
+static inline __u32 __swab32p(const __u32 *p)
+{
+#ifdef HAVE_ARCH_SWAB32P
+	return __arch_swab32p(p);
+#else
+	return __swab32(*p);
+#endif
+}
+
+/**
+ * __swab64p - return a byteswapped 64-bit value from a pointer
+ * @p: pointer to a naturally-aligned 64-bit value
+ */
+static inline __u64 __swab64p(const __u64 *p)
+{
+#ifdef HAVE_ARCH_SWAB64P
+	return __arch_swab64p(p);
+#else
+	return __swab64(*p);
+#endif
+}
+
+/**
+ * __swahw32p - return a wordswapped 32-bit value from a pointer
+ * @p: pointer to a naturally-aligned 32-bit value
+ *
+ * See __swahw32() for details of wordswapping.
+ */
+static inline __u32 __swahw32p(const __u32 *p)
+{
+#ifdef HAVE_ARCH_SWAHW32P
+	return __arch_swahw32p(p);
+#else
+	return __swahw32(*p);
+#endif
+}
+
+/**
+ * __swahb32p - return a high and low byteswapped 32-bit value from a pointer
+ * @p: pointer to a naturally-aligned 32-bit value
+ *
+ * See __swahb32() for details of high/low byteswapping.
+ */
+static inline __u32 __swahb32p(const __u32 *p)
+{
+#ifdef HAVE_ARCH_SWAHB32P
+	return __arch_swahb32p(p);
+#else
+	return __swahb32(*p);
+#endif
+}
+
+/**
+ * __swab16s - byteswap a 16-bit value in-place
+ * @p: pointer to a naturally-aligned 16-bit value
+ */
+static inline void __swab16s(__u16 *p)
+{
+#ifdef HAVE_ARCH_SWAB16S
+	__arch_swab16s(p);
+#else
+	*p = __swab16p(p);
+#endif
+}
+/**
+ * __swab32s - byteswap a 32-bit value in-place
+ * @p: pointer to a naturally-aligned 32-bit value
+ */
+static inline void __swab32s(__u32 *p)
+{
+#ifdef HAVE_ARCH_SWAB32S
+	__arch_swab32s(p);
+#else
+	*p = __swab32p(p);
+#endif
+}
+
+/**
+ * __swab64s - byteswap a 64-bit value in-place
+ * @p: pointer to a naturally-aligned 64-bit value
+ */
+static inline void __swab64s(__u64 *p)
+{
+#ifdef HAVE_ARCH_SWAB64S
+	__arch_swab64s(p);
+#else
+	*p = __swab64p(p);
+#endif
+}
+
+/**
+ * __swahw32s - wordswap a 32-bit value in-place
+ * @p: pointer to a naturally-aligned 32-bit value
+ *
+ * See __swahw32() for details of wordswapping
+ */
+static inline void __swahw32s(__u32 *p)
+{
+#ifdef HAVE_ARCH_SWAHW32S
+	__arch_swahw32s(p);
+#else
+	*p = __swahw32p(p);
+#endif
+}
+
+/**
+ * __swahb32s - high and low byteswap a 32-bit value in-place
+ * @p: pointer to a naturally-aligned 32-bit value
+ *
+ * See __swahb32() for details of high and low byte swapping
+ */
+static inline void __swahb32s(__u32 *p)
+{
+#ifdef HAVE_ARCH_SWAHB32S
+	__arch_swahb32s(p);
+#else
+	*p = __swahb32p(p);
+#endif
+}
+
+#ifdef __KERNEL__
+# define swab16 __swab16
+# define swab32 __swab32
+# define swab64 __swab64
+# define swahw32 __swahw32
+# define swahb32 __swahb32
+# define swab16p __swab16p
+# define swab32p __swab32p
+# define swab64p __swab64p
+# define swahw32p __swahw32p
+# define swahb32p __swahb32p
+# define swab16s __swab16s
+# define swab32s __swab32s
+# define swab64s __swab64s
+# define swahw32s __swahw32s
+# define swahb32s __swahb32s
+#endif /* __KERNEL__ */
+
+#endif /* _LINUX_SWAB_H */
-- 
1.5.6.1.281.g1087e


