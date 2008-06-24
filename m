Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYFXAKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYFXAKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYFXAJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:09:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:12969 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbYFXAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m4mqfXGVriOQJ/A2ZACZ/nLfn5ob096/CuhjhowizLXHMZFlyf63JhwVM/siKGAOMJ
         /rt3rqIjiD3PQObNTlLwU2Mut+UrpPLanRZ/VXGKLYg/p6ZHNpFIJ0ADjWJ6kdsTTR1B
         XP55ETO69dAw8gbELAuwl+yQ5m+AreoOLLY1Y=
Subject: [PATCH 3/6] byteorder: wire up arches to use new headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:09:08 -0700
Message-Id: <1214266148.21092.44.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
These can all go in separately without breaking anything, but patches 4 and
beyond depend on all arches being applied.

 include/asm-alpha/byteorder.h         |   13 ++----
 include/asm-arm/byteorder.h           |   25 +++++-------
 include/asm-avr32/byteorder.h         |   22 +++++++----
 include/asm-blackfin/byteorder.h      |   33 +++++++---------
 include/asm-cris/arch-v10/byteorder.h |    6 ++-
 include/asm-cris/arch-v32/byteorder.h |    6 ++-
 include/asm-cris/byteorder.h          |   18 +-------
 include/asm-frv/byteorder.h           |   10 +---
 include/asm-h8300/byteorder.h         |   10 +---
 include/asm-ia64/byteorder.h          |   26 +++++-------
 include/asm-m32r/byteorder.h          |   15 +++----
 include/asm-m68k/byteorder.h          |   16 ++-----
 include/asm-m68knommu/byteorder.h     |   10 +---
 include/asm-mips/byteorder.h          |   40 ++++++++-----------
 include/asm-mn10300/byteorder.h       |   23 +++--------
 include/asm-parisc/byteorder.h        |   37 ++++++------------
 include/asm-powerpc/byteorder.h       |   49 +++++++++---------------
 include/asm-s390/byteorder.h          |   68 +++++++++-----------------------
 include/asm-sh/byteorder.h            |   32 +++++++--------
 include/asm-sparc/byteorder.h         |   22 ++++-------
 include/asm-x86/byteorder.h           |   69 +++++++++++++--------------------
 include/asm-xtensa/byteorder.h        |   32 +++++++--------
 22 files changed, 223 insertions(+), 359 deletions(-)

diff --git a/include/asm-alpha/byteorder.h b/include/asm-alpha/byteorder.h
index 58e958f..cc9d368 100644
--- a/include/asm-alpha/byteorder.h
+++ b/include/asm-alpha/byteorder.h
@@ -5,9 +5,9 @@
 #include <linux/compiler.h>
 #include <asm/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	/*
 	 * Unfortunately, we can't use the 6 instruction sequence
@@ -35,13 +35,8 @@ static inline __attribute_const__ __u32 __arch__swab32(__u32 x)
 
 	return t1;
 }
+#define HAVE_ARCH_SWAB32
 
-#define __arch__swab32 __arch__swab32
-
-#endif /* __GNUC__ */
-
-#define __BYTEORDER_HAS_U64__
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ALPHA_BYTEORDER_H */
diff --git a/include/asm-arm/byteorder.h b/include/asm-arm/byteorder.h
index e6f7fcd..d88a5ce 100644
--- a/include/asm-arm/byteorder.h
+++ b/include/asm-arm/byteorder.h
@@ -18,7 +18,15 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __ARMEB__
+# define __BIG_ENDIAN
+#else
+# define __LITTLE_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 t;
 
@@ -40,19 +48,8 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
+#define HAVE_ARCH_SWAB32
 
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __ARMEB__
-#include <linux/byteorder/big_endian.h>
-#else
-#include <linux/byteorder/little_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif
-
diff --git a/include/asm-avr32/byteorder.h b/include/asm-avr32/byteorder.h
index d77b48b..15bd96a 100644
--- a/include/asm-avr32/byteorder.h
+++ b/include/asm-avr32/byteorder.h
@@ -7,6 +7,9 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
+
 #ifdef __CHECKER__
 extern unsigned long __builtin_bswap_32(unsigned long x);
 extern unsigned short __builtin_bswap_16(unsigned short x);
@@ -17,15 +20,18 @@ extern unsigned short __builtin_bswap_16(unsigned short x);
  * the result.
  */
 #if !(__GNUC__ == 4 && __GNUC_MINOR__ < 2)
-#define __arch__swab32(x) __builtin_bswap_32(x)
-#define __arch__swab16(x) __builtin_bswap_16(x)
-#endif
+static inline __attribute_const__ __u16 __arch_swab16(__u16 val)
+{
+	return __builtin_bswap_16(val);
+}
+#define HAVE_ARCH_SWAB16
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-# define __BYTEORDER_HAS_U64__
-# define __SWAB_64_THRU_32__
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	return __builtin_bswap_32(val);
+}
+#define HAVE_ARCH_SWAB32
 #endif
 
-#include <linux/byteorder/big_endian.h>
-
+#include <linux/byteorder.h>
 #endif /* __ASM_AVR32_BYTEORDER_H */
diff --git a/include/asm-blackfin/byteorder.h b/include/asm-blackfin/byteorder.h
index 6a673d4..68be8a2 100644
--- a/include/asm-blackfin/byteorder.h
+++ b/include/asm-blackfin/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahb32(__u32 xx)
 {
 	__u32 tmp;
 	__asm__("%1 = %0 >> 8 (V);\n\t"
@@ -15,34 +16,30 @@ static __inline__ __attribute_const__ __u32 ___arch__swahb32(__u32 xx)
 		: "+d"(xx), "=&d"(tmp));
 	return xx;
 }
+#define HAVE_ARCH_SWAHB32
 
-static __inline__ __attribute_const__ __u32 ___arch__swahw32(__u32 xx)
+static inline __attribute_const__ __u32 __arch_swahw32(__u32 xx)
 {
 	__u32 rv;
 	__asm__("%0 = PACK(%1.L, %1.H);\n\t": "=d"(rv): "d"(xx));
 	return rv;
 }
+#define HAVE_ARCH_SWAHW32
 
-#define __arch__swahb32(x) ___arch__swahb32(x)
-#define __arch__swahw32(x) ___arch__swahw32(x)
-#define __arch__swab32(x) ___arch__swahb32(___arch__swahw32(x))
+static inline __attribute_const__ __u32 __arch_swab32(__u32 xx)
+{
+	return __arch_swahb32(__arch_swahw32(x));
+}
+#define HAVE_ARCH_SWAB32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 xx)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 xx)
 {
 	__u32 xw = xx;
 	__asm__("%0 <<= 8;\n	%0.L = %0.L + %0.H (NS);\n": "+d"(xw));
 	return (__u16)xw;
 }
+#define HAVE_ARCH_SWAB16
 
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
-#endif				/* _BLACKFIN_BYTEORDER_H */
+#endif /* _BLACKFIN_BYTEORDER_H */
diff --git a/include/asm-cris/arch-v10/byteorder.h b/include/asm-cris/arch-v10/byteorder.h
index 255b646..8aed4e4 100644
--- a/include/asm-cris/arch-v10/byteorder.h
+++ b/include/asm-cris/arch-v10/byteorder.h
@@ -9,18 +9,20 @@
  * them together into ntohl etc.
  */
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__ ("swapwb %0" : "=r" (x) : "0" (x));
   
 	return(x);
 }
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__ ("swapb %0" : "=r" (x) : "0" (x));
 	
 	return(x);
 }
+#define HAVE_ARCH_SWAB16
 
 #endif
diff --git a/include/asm-cris/arch-v32/byteorder.h b/include/asm-cris/arch-v32/byteorder.h
index 6ef8fb4..6023146 100644
--- a/include/asm-cris/arch-v32/byteorder.h
+++ b/include/asm-cris/arch-v32/byteorder.h
@@ -4,17 +4,19 @@
 #include <asm/types.h>
 
 static inline __const__ __u32
-___arch__swab32(__u32 x)
+__arch_swab32(__u32 x)
 {
 	__asm__ __volatile__ ("swapwb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define HAVE_ARCH_SWAB32
 
 static inline __const__ __u16
-___arch__swab16(__u16 x)
+__arch_swab16(__u16 x)
 {
 	__asm__ __volatile__ ("swapb %0" : "=r" (x) : "0" (x));
 	return (x);
 }
+#define HAVE_ARCH_SWAB16
 
 #endif /* _ASM_CRIS_ARCH_BYTEORDER_H */
diff --git a/include/asm-cris/byteorder.h b/include/asm-cris/byteorder.h
index 0cd9db1..fb02930 100644
--- a/include/asm-cris/byteorder.h
+++ b/include/asm-cris/byteorder.h
@@ -1,26 +1,14 @@
 #ifndef _CRIS_BYTEORDER_H
 #define _CRIS_BYTEORDER_H
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
 #ifdef __KERNEL__
 #include <asm/arch/byteorder.h>
-
-/* defines are necessary because the other files detect the presence
- * of a defined __arch_swab32, not an inline
- */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#endif /* __KERNEL__ */
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
 #endif
 
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif
 
diff --git a/include/asm-frv/byteorder.h b/include/asm-frv/byteorder.h
index 411bec3..cb197c3 100644
--- a/include/asm-frv/byteorder.h
+++ b/include/asm-frv/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-h8300/byteorder.h b/include/asm-h8300/byteorder.h
index 36e597d..465b7af 100644
--- a/include/asm-h8300/byteorder.h
+++ b/include/asm-h8300/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _H8300_BYTEORDER_H
 #define _H8300_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _H8300_BYTEORDER_H */
diff --git a/include/asm-ia64/byteorder.h b/include/asm-ia64/byteorder.h
index 69bd41d..afd8ded 100644
--- a/include/asm-ia64/byteorder.h
+++ b/include/asm-ia64/byteorder.h
@@ -10,33 +10,29 @@
 #include <asm/intrinsics.h>
 #include <linux/compiler.h>
 
-static __inline__ __attribute_const__ __u64
-__ia64_swab64 (__u64 x)
+#define __LITTLE_ENDIAN
+
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	result = ia64_mux1(x, ia64_mux1_rev);
 	return result;
 }
+#define HAVE_ARCH_SWAB64
 
-static __inline__ __attribute_const__ __u32
-__ia64_swab32 (__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
-	return __ia64_swab64(x) >> 32;
+	return __arch_swab64(x) >> 32;
 }
+#define HAVE_ARCH_SWAB32
 
-static __inline__ __attribute_const__ __u16
-__ia64_swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
-	return __ia64_swab64(x) >> 48;
+	return __arch_swab64(x) >> 48;
 }
+#define HAVE_ARCH_SWAB16
 
-#define __arch__swab64(x) __ia64_swab64(x)
-#define __arch__swab32(x) __ia64_swab32(x)
-#define __arch__swab16(x) __ia64_swab16(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_IA64_BYTEORDER_H */
diff --git a/include/asm-m32r/byteorder.h b/include/asm-m32r/byteorder.h
index 10b2c1d..a99896f 100644
--- a/include/asm-m32r/byteorder.h
+++ b/include/asm-m32r/byteorder.h
@@ -1,17 +1,14 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
 #if defined(__LITTLE_ENDIAN__)
-#  include <linux/byteorder/little_endian.h>
+# define __LITTLE_ENDIAN
 #else
-#  include <linux/byteorder/big_endian.h>
+# define __BIG_ENDIAN
 #endif
 
+#define __SWAB_64_THRU_32__
+
+#include <linux/byteorder.h>
+
 #endif /* _ASM_M32R_BYTEORDER_H */
diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
index 81d420b..4569d49 100644
--- a/include/asm-m68k/byteorder.h
+++ b/include/asm-m68k/byteorder.h
@@ -4,22 +4,16 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 val)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
 	return val;
 }
-#define __arch__swab32(x) ___arch__swab32(x)
+#define HAVE_ARCH_SWAB32
 
-#endif
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68K_BYTEORDER_H */
diff --git a/include/asm-m68knommu/byteorder.h b/include/asm-m68knommu/byteorder.h
index 8fcde90..a9231f8 100644
--- a/include/asm-m68knommu/byteorder.h
+++ b/include/asm-m68knommu/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _M68KNOMMU_BYTEORDER_H
 #define _M68KNOMMU_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _M68KNOMMU_BYTEORDER_H */
diff --git a/include/asm-mips/byteorder.h b/include/asm-mips/byteorder.h
index fe7dc2d..dfada7f 100644
--- a/include/asm-mips/byteorder.h
+++ b/include/asm-mips/byteorder.h
@@ -11,11 +11,19 @@
 #include <linux/compiler.h>
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#if defined(__MIPSEB__)
+# define __BIG_ENDIAN
+#elif defined(__MIPSEL__)
+# define __LITTLE_ENDIAN
+#else
+# error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
+#endif
+
+#define __SWAB_64_THRU_32__
 
 #ifdef CONFIG_CPU_MIPSR2
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -24,9 +32,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
-#define __arch__swab16(x)	___arch__swab16(x)
+#define HAVE_ARCH_SWAB16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 	"	wsbh	%0, %1			\n"
@@ -36,11 +44,10 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
-#define __arch__swab32(x)	___arch__swab32(x)
+#define HAVE_ARCH_SWAB32
 
 #ifdef CONFIG_CPU_MIPS64_R2
-
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
 {
 	__asm__(
 	"	dsbh	%0, %1			\n"
@@ -51,26 +58,11 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
 
 	return x;
 }
-
-#define __arch__swab64(x)	___arch__swab64(x)
-
+#define HAVE_ARCH_SWAB64
 #endif /* CONFIG_CPU_MIPS64_R2 */
 
 #endif /* CONFIG_CPU_MIPSR2 */
 
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
-#if defined(__MIPSEB__)
-#  include <linux/byteorder/big_endian.h>
-#elif defined(__MIPSEL__)
-#  include <linux/byteorder/little_endian.h>
-#else
-#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-mn10300/byteorder.h b/include/asm-mn10300/byteorder.h
index 3c993cc..3dd3e2a 100644
--- a/include/asm-mn10300/byteorder.h
+++ b/include/asm-mn10300/byteorder.h
@@ -13,34 +13,25 @@
 
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static inline __attribute__((const))
-__u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__u32 ret;
 	asm("swap %1,%0" : "=r" (ret) : "r" (x));
 	return ret;
 }
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute__((const))
-__u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__u16 ret;
 	asm("swaph %1,%0" : "=r" (ret) : "r" (x));
 	return ret;
 }
+#define HAVE_ARCH_SWAB16
 
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-parisc/byteorder.h b/include/asm-parisc/byteorder.h
index db14831..5e56b1b 100644
--- a/include/asm-parisc/byteorder.h
+++ b/include/asm-parisc/byteorder.h
@@ -4,9 +4,10 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
+#define __SWAB_64_THRU_32__
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__("dep %0, 15, 8, %0\n\t"		/* deposit 00ab -> 0bab */
 		"shd %%r0, %0, 8, %0"		/* shift 000000ab -> 00ba */
@@ -14,8 +15,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 		: "0" (x));
 	return x;
 }
+#define HAVE_ARCH_SWAB16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab24(__u32 x)
 {
 	__asm__("shd %0, %0, 8, %0\n\t"		/* shift xabcxabc -> cxab */
 		"dep %0, 15, 8, %0\n\t"		/* deposit cxab -> cbab */
@@ -25,7 +27,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
 	return x;
 }
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	unsigned int temp;
 	__asm__("shd %0, %0, 16, %1\n\t"	/* shift abcdabcd -> cdab */
@@ -35,7 +37,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 		: "0" (x));
 	return x;
 }
-
+#define HAVE_ARCH_SWAB32
 
 #if BITS_PER_LONG > 32
 /*
@@ -48,7 +50,8 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 **      HSHR    67452301 -> *6*4*2*0 into %0
 **      OR      %0 | %1  -> 76543210 into %0 (all done!)
 */
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
+static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
+{
 	__u64 temp;
 	__asm__("permh,3210 %0, %0\n\t"
 		"hshl %0, 8, %1\n\t"
@@ -58,25 +61,9 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
 		: "0" (x));
 	return x;
 }
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __BYTEORDER_HAS_U64__
-#elif !defined(__STRICT_ANSI__)
-static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
-	__u32 t1 = ___arch__swab32((__u32) x);
-	__u32 t2 = ___arch__swab32((__u32) (x >> 32));
-	return (((__u64) t1 << 32) | t2);
-}
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __BYTEORDER_HAS_U64__
-#endif
-
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab24(x) ___arch__swab24(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#endif /* __GNUC__ */
+#define HAVE_ARCH_SWAB64
+#endif /* BITS_PER_LONG > 32 */
 
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _PARISC_BYTEORDER_H */
diff --git a/include/asm-powerpc/byteorder.h b/include/asm-powerpc/byteorder.h
index b377522..9608169 100644
--- a/include/asm-powerpc/byteorder.h
+++ b/include/asm-powerpc/byteorder.h
@@ -11,36 +11,43 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
-#ifdef __KERNEL__
+#define __BIG_ENDIAN
 
-static __inline__ __u16 ld_le16(const volatile __u16 *addr)
+#ifndef __powerpc64__
+# define __SWAB_64_THRU_32__
+#endif
+
+static inline __u16 __arch_swab16p(const volatile __u16 *addr)
 {
 	__u16 val;
 
 	__asm__ __volatile__ ("lhbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define HAVE_ARCH_SWAB16P
 
-static __inline__ void st_le16(volatile __u16 *addr, const __u16 val)
+static inline void __arch_swab16s(volatile __u16 *addr, const __u16 val)
 {
 	__asm__ __volatile__ ("sthbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define HAVE_ARCH_SWAB16S
 
-static __inline__ __u32 ld_le32(const volatile __u32 *addr)
+static inline __u32 __arch_swab32p(const volatile __u32 *addr)
 {
 	__u32 val;
 
 	__asm__ __volatile__ ("lwbrx %0,0,%1" : "=r" (val) : "r" (addr), "m" (*addr));
 	return val;
 }
+#define HAVE_ARCH_SWAB32P
 
-static __inline__ void st_le32(volatile __u32 *addr, const __u32 val)
+static inline void __arch_swab32s(volatile __u32 *addr, const __u32 val)
 {
 	__asm__ __volatile__ ("stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
 }
+#define HAVE_ARCH_SWAB32S
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 value)
 {
 	__u16 result;
 
@@ -49,8 +56,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 value)
 	    : "r" (value), "0" (value >> 8));
 	return result;
 }
+#define HAVE_ARCH_SWAB16
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 value)
 {
 	__u32 result;
 
@@ -61,29 +69,8 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 value)
 	    : "r" (value), "0" (value >> 24));
 	return result;
 }
+#define HAVE_ARCH_SWAB32
 
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-/* The same, but returns converted value from the location pointer by addr. */
-#define __arch__swab16p(addr) ld_le16(addr)
-#define __arch__swab32p(addr) ld_le32(addr)
-
-/* The same, but do the conversion in situ, ie. put the value back to addr. */
-#define __arch__swab16s(addr) st_le16(addr,*addr)
-#define __arch__swab32s(addr) st_le32(addr,*addr)
-
-#endif /* __KERNEL__ */
-
-#ifndef __STRICT_ANSI__
-#define __BYTEORDER_HAS_U64__
-#ifndef __powerpc64__
-#define __SWAB_64_THRU_32__
-#endif /* __powerpc64__ */
-#endif /* __STRICT_ANSI__ */
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_POWERPC_BYTEORDER_H */
diff --git a/include/asm-s390/byteorder.h b/include/asm-s390/byteorder.h
index 1fe2492..4cad6d3 100644
--- a/include/asm-s390/byteorder.h
+++ b/include/asm-s390/byteorder.h
@@ -11,32 +11,39 @@
 
 #include <asm/types.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
+
+#ifndef __s390x__
+# define __SWAB_64_THRU_32__
+#endif
 
 #ifdef __s390x__
-static inline __u64 ___arch__swab64p(const __u64 *x)
+static inline __u64 __arch_swab64p(const __u64 *x)
 {
 	__u64 result;
 
 	asm volatile("lrvg %0,%1" : "=d" (result) : "m" (*x));
 	return result;
 }
+#define HAVE_ARCH_SWAB64P
 
-static inline __u64 ___arch__swab64(__u64 x)
+static inline __u64 __arch_swab64(__u64 x)
 {
 	__u64 result;
 
 	asm volatile("lrvgr %0,%1" : "=d" (result) : "d" (x));
 	return result;
 }
+#define HAVE_ARCH_SWAB64
 
-static inline void ___arch__swab64s(__u64 *x)
+static inline void __arch_swab64s(__u64 *x)
 {
 	*x = ___arch__swab64p(x);
 }
+#define HAVE_ARCH_SWAB64S
 #endif /* __s390x__ */
 
-static inline __u32 ___arch__swab32p(const __u32 *x)
+static inline __u32 __arch_swab32p(const __u32 *x)
 {
 	__u32 result;
 	
@@ -53,25 +60,20 @@ static inline __u32 ___arch__swab32p(const __u32 *x)
 #endif /* __s390x__ */
 	return result;
 }
+#define HAVE_ARCH_SWAB32P
 
-static inline __u32 ___arch__swab32(__u32 x)
+#ifdef __s390x__
+static inline __u32 __arch_swab32(__u32 x)
 {
-#ifndef __s390x__
-	return ___arch__swab32p(&x);
-#else /* __s390x__ */
 	__u32 result;
 	
 	asm volatile("lrvr  %0,%1" : "=d" (result) : "d" (x));
 	return result;
-#endif /* __s390x__ */
-}
-
-static __inline__ void ___arch__swab32s(__u32 *x)
-{
-	*x = ___arch__swab32p(x);
 }
+#define HAVE_ARCH_SWAB32
+#endif /* __s390x__ */
 
-static __inline__ __u16 ___arch__swab16p(const __u16 *x)
+static inline __u16 __arch_swab16p(const __u16 *x)
 {
 	__u16 result;
 	
@@ -86,39 +88,7 @@ static __inline__ __u16 ___arch__swab16p(const __u16 *x)
 #endif /* __s390x__ */
 	return result;
 }
-
-static __inline__ __u16 ___arch__swab16(__u16 x)
-{
-	return ___arch__swab16p(&x);
-}
-
-static __inline__ void ___arch__swab16s(__u16 *x)
-{
-	*x = ___arch__swab16p(x);
-}
-
-#ifdef __s390x__
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
-#define __arch__swab64s(x) ___arch__swab64s(x)
-#endif /* __s390x__ */
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32s(x) ___arch__swab32s(x)
-#define __arch__swab16s(x) ___arch__swab16s(x)
-
-#ifndef __s390x__
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-#else /* __s390x__ */
-#define __BYTEORDER_HAS_U64__
-#endif /* __s390x__ */
-
-#endif /* __GNUC__ */
+#define HAVE_ARCH_SWAB16P
 
 #include <linux/byteorder/big_endian.h>
 
diff --git a/include/asm-sh/byteorder.h b/include/asm-sh/byteorder.h
index 4c13e61..2259210 100644
--- a/include/asm-sh/byteorder.h
+++ b/include/asm-sh/byteorder.h
@@ -8,7 +8,15 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __LITTLE_ENDIAN__
+# define __LITTLE_ENDIAN
+#else
+# define __BIG_ENDIAN
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -24,8 +32,9 @@ static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
 
 	return x;
 }
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
 	__asm__(
 #ifdef __SH5__
@@ -39,8 +48,9 @@ static inline __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
 	return x;
 }
+#define HAVE_ARCH_SWAB16
 
-static inline __u64 ___arch__swab64(__u64 val)
+static inline __u64 __arch_swab64(__u64 val)
 {
 	union {
 		struct { __u32 a,b; } s;
@@ -51,20 +61,8 @@ static inline __u64 ___arch__swab64(__u64 val)
 	w.s.a = ___arch__swab32(v.s.b);
 	return w.u;
 }
+#define HAVE_ARCH_SWAB64
 
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __LITTLE_ENDIAN__
-#include <linux/byteorder/little_endian.h>
-#else
-#include <linux/byteorder/big_endian.h>
-#endif
+#include <linux/byteorder.h>
 
 #endif /* __ASM_SH_BYTEORDER_H */
diff --git a/include/asm-sparc/byteorder.h b/include/asm-sparc/byteorder.h
index bcd83aa..9195613 100644
--- a/include/asm-sparc/byteorder.h
+++ b/include/asm-sparc/byteorder.h
@@ -4,15 +4,14 @@
 #include <asm/types.h>
 #include <asm/asi.h>
 
-#ifdef __GNUC__
+#define __BIG_ENDIAN
 
 #ifdef CONFIG_SPARC32
 #define __SWAB_64_THRU_32__
 #endif
 
 #ifdef CONFIG_SPARC64
-
-static inline __u16 ___arch__swab16p(const __u16 *addr)
+static inline __u16 __arch_swab16p(const __u16 *addr)
 {
 	__u16 ret;
 
@@ -21,8 +20,9 @@ static inline __u16 ___arch__swab16p(const __u16 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define HAVE_ARCH_SWAB16P
 
-static inline __u32 ___arch__swab32p(const __u32 *addr)
+static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
@@ -31,8 +31,9 @@ static inline __u32 ___arch__swab32p(const __u32 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
+#define HAVE_ARCH_SWAB32P
 
-static inline __u64 ___arch__swab64p(const __u64 *addr)
+static inline __u64 __arch_swab64p(const __u64 *addr)
 {
 	__u64 ret;
 
@@ -41,17 +42,10 @@ static inline __u64 ___arch__swab64p(const __u64 *addr)
 			      : "r" (addr), "i" (ASI_PL));
 	return ret;
 }
-
-#define __arch__swab16p(x) ___arch__swab16p(x)
-#define __arch__swab32p(x) ___arch__swab32p(x)
-#define __arch__swab64p(x) ___arch__swab64p(x)
+#define HAVE_ARCH_SWAB64P
 
 #endif /* CONFIG_SPARC64 */
 
-#define __BYTEORDER_HAS_U64__
-
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _SPARC_BYTEORDER_H */
diff --git a/include/asm-x86/byteorder.h b/include/asm-x86/byteorder.h
index e02ae2d..79220a9 100644
--- a/include/asm-x86/byteorder.h
+++ b/include/asm-x86/byteorder.h
@@ -4,26 +4,33 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#ifdef __GNUC__
+#define __LITTLE_ENDIAN
 
-#ifdef __i386__
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
-#ifdef CONFIG_X86_BSWAP
-	asm("bswap %0" : "=r" (x) : "0" (x));
-#else
+#ifdef __i386__
+# ifdef CONFIG_X86_BSWAP
+	asm("bswap %0" : "=r" (val) : "0" (val));
+# else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
 	    "rorl $16,%0\n\t"	/* swap words		*/
 	    "xchgb %b0,%h0"	/* swap higher bytes	*/
-	    : "=q" (x)
-	    : "0" (x));
+	    : "=q" (val)
+	    : "0" (val));
+# endif
+
+#else /* __i386__ */
+	asm("bswapl %0"
+	    : "=r" (val)
+	    : "0" (val));
 #endif
-	return x;
+	return val;
 }
+#define HAVE_ARCH_SWAB32
 
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
+static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 {
+#ifdef __i386__
 	union {
 		struct {
 			__u32 a;
@@ -32,50 +39,28 @@ static inline __attribute_const__ __u64 ___arch__swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-#ifdef CONFIG_X86_BSWAP
+# ifdef CONFIG_X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#else
+# else
 	v.s.a = ___arch__swab32(v.s.a);
 	v.s.b = ___arch__swab32(v.s.b);
 	asm("xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
-#endif
+# endif
 	return v.u;
-}
 
 #else /* __i386__ */
-
-static inline __attribute_const__ __u64 ___arch__swab64(__u64 x)
-{
 	asm("bswapq %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
-static inline __attribute_const__ __u32 ___arch__swab32(__u32 x)
-{
-	asm("bswapl %0"
-	    : "=r" (x)
-	    : "0" (x));
-	return x;
-}
-
+	    : "=r" (val)
+	    : "0" (val));
+	return val;
 #endif
+}
+#define HAVE_ARCH_SWAB64
 
-/* Do not define swab16.  Gcc is smart enough to recognize "C" version and
-   convert it into rotation or exhange.  */
-
-#define __arch__swab64(x) ___arch__swab64(x)
-#define __arch__swab32(x) ___arch__swab32(x)
-
-#define __BYTEORDER_HAS_U64__
-
-#endif /* __GNUC__ */
-
-#include <linux/byteorder/little_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_X86_BYTEORDER_H */
diff --git a/include/asm-xtensa/byteorder.h b/include/asm-xtensa/byteorder.h
index 765edf1..9a5928b 100644
--- a/include/asm-xtensa/byteorder.h
+++ b/include/asm-xtensa/byteorder.h
@@ -14,7 +14,17 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
+#ifdef __XTENSA_EL__
+# define __LITTLE_ENDIAN
+#elif defined(__XTENSA_EB__)
+# define __BIG_ENDIAN
+#else
+# error processor byte order undefined!
+#endif
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 {
     __u32 res;
     /* instruction sequence from Xtensa ISA release 2/2000 */
@@ -28,8 +38,9 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
 	    );
     return res;
 }
+#define HAVE_ARCH_SWAB32
 
-static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
+static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
 {
     /* Given that 'short' values are signed (i.e., can be negative),
      * we cannot assume that the upper 16-bits of the register are
@@ -62,21 +73,8 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
 
     return res;
 }
+#define HAVE_ARCH_SWAB16
 
-#define __arch__swab32(x) ___arch__swab32(x)
-#define __arch__swab16(x) ___arch__swab16(x)
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#ifdef __XTENSA_EL__
-# include <linux/byteorder/little_endian.h>
-#elif defined(__XTENSA_EB__)
-# include <linux/byteorder/big_endian.h>
-#else
-# error processor byte order undefined!
-#endif
+#include <linux/byteorder.h>
 
 #endif /* _XTENSA_BYTEORDER_H */
-- 
1.5.6.290.gc4e15


