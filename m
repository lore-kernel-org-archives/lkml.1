Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753465AbYLRBqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYLRBqf (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 20:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYLRBqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 20:46:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:45952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYLRBqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 20:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uk7vD6ZZQ8J312Au5QJWEmD0QVJmkqV4JpFe/oeeG1AE78WIzyAwZVpLkJ8jPVhahx
         S9XQcwPO20ilJogQ3AwtColGdirGDZLQ/JxZhTlH/PqECgfkKcO5V8GJsKN4UBiKzTtM
         8cpgUTeGoU2nO5eiqS3MFsd14iHNsrT9Ye+/s=
Subject: [PATCH-2.6.28 final] byteorder: fix new headers for userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: bluebird@gentoo.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
In-Reply-To: <20081216.011334.124918024.davem@davemloft.net>
References: <4943DAD6.7070402@gentoo.org>
	 <20081216.011334.124918024.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 17:46:19 -0800
Message-Id: <1229564779.6481.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

glibc headers define both __LITTLE_ENDIAN and __BIG_ENDIAN
which was tripping the check in linux/byteorder.h.  Let's
just stay out of userspace's way and use __KERN_{endian}

The old implementation got away with it as it kept the two
implementations in different headers and conditionally included
the right one.  The combined header does checks within each
function body and depends on only one being defined.

Converted the arches in mainline that have already moved to the
new header, as the other arches merge the will need simlar
fixups.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/avr32/include/asm/byteorder.h |    2 +-
 arch/mips/include/asm/byteorder.h  |    4 +-
 arch/sh/include/asm/byteorder.h    |    4 +-
 arch/sparc/include/asm/byteorder.h |    2 +-
 include/linux/byteorder.h          |   84 ++++++++++++++++++------------------
 5 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/arch/avr32/include/asm/byteorder.h b/arch/avr32/include/asm/byteorder.h
index 8e3af02..b7d6dd1 100644
--- a/arch/avr32/include/asm/byteorder.h
+++ b/arch/avr32/include/asm/byteorder.h
@@ -7,7 +7,7 @@
 #include <asm/types.h>
 #include <linux/compiler.h>
 
-#define __BIG_ENDIAN
+#define __KERN_BIG_ENDIAN
 #define __SWAB_64_THRU_32__
 
 #ifdef __CHECKER__
diff --git a/arch/mips/include/asm/byteorder.h b/arch/mips/include/asm/byteorder.h
index 2988d29..8ad8a5b 100644
--- a/arch/mips/include/asm/byteorder.h
+++ b/arch/mips/include/asm/byteorder.h
@@ -12,9 +12,9 @@
 #include <asm/types.h>
 
 #if defined(__MIPSEB__)
-# define __BIG_ENDIAN
+# define __KERN_BIG_ENDIAN
 #elif defined(__MIPSEL__)
-# define __LITTLE_ENDIAN
+# define __KERN_LITTLE_ENDIAN
 #else
 # error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
 #endif
diff --git a/arch/sh/include/asm/byteorder.h b/arch/sh/include/asm/byteorder.h
index f5fa065..4aa5f1d 100644
--- a/arch/sh/include/asm/byteorder.h
+++ b/arch/sh/include/asm/byteorder.h
@@ -9,9 +9,9 @@
 #include <linux/types.h>
 
 #ifdef __LITTLE_ENDIAN__
-# define __LITTLE_ENDIAN
+# define __KERN_LITTLE_ENDIAN
 #else
-# define __BIG_ENDIAN
+# define __KERN_BIG_ENDIAN
 #endif
 
 #define __SWAB_64_THRU_32__
diff --git a/arch/sparc/include/asm/byteorder.h b/arch/sparc/include/asm/byteorder.h
index 5a70f13..5b8347e 100644
--- a/arch/sparc/include/asm/byteorder.h
+++ b/arch/sparc/include/asm/byteorder.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 #include <asm/asi.h>
 
-#define __BIG_ENDIAN
+#define __KERN_BIG_ENDIAN
 
 #ifdef CONFIG_SPARC32
 #define __SWAB_64_THRU_32__
diff --git a/include/linux/byteorder.h b/include/linux/byteorder.h
index 29f002d..3599fbc 100644
--- a/include/linux/byteorder.h
+++ b/include/linux/byteorder.h
@@ -4,33 +4,33 @@
 #include <linux/types.h>
 #include <linux/swab.h>
 
-#if defined(__LITTLE_ENDIAN) && defined(__BIG_ENDIAN)
+#if defined(__KERN_LITTLE_ENDIAN) && defined(__KERN_BIG_ENDIAN)
 # error Fix asm/byteorder.h to define one endianness
 #endif
 
-#if !defined(__LITTLE_ENDIAN) && !defined(__BIG_ENDIAN)
+#if !defined(__KERN_LITTLE_ENDIAN) && !defined(__KERN_BIG_ENDIAN)
 # error Fix asm/byteorder.h to define arch endianness
 #endif
 
-#ifdef __LITTLE_ENDIAN
-# undef __LITTLE_ENDIAN
-# define __LITTLE_ENDIAN 1234
+#ifdef __KERN_LITTLE_ENDIAN
+# ifndef __LITTLE_ENDIAN
+#  define __LITTLE_ENDIAN 1234
+# endif
+# ifndef __LITTLE_ENDIAN_BITFIELD
+#  define __LITTLE_ENDIAN_BITFIELD
+# endif
 #endif
 
-#ifdef __BIG_ENDIAN
-# undef __BIG_ENDIAN
-# define __BIG_ENDIAN 4321
+#ifdef __KERN_BIG_ENDIAN
+# ifndef __BIG_ENDIAN
+#  define __BIG_ENDIAN 4321
+# endif
+# ifndef __BIG_ENDIAN_BITFIELD
+#  define __BIG_ENDIAN_BITFIELD
+# endif
 #endif
 
-#if defined(__LITTLE_ENDIAN) && !defined(__LITTLE_ENDIAN_BITFIELD)
-# define __LITTLE_ENDIAN_BITFIELD
-#endif
-
-#if defined(__BIG_ENDIAN) && !defined(__BIG_ENDIAN_BITFIELD)
-# define __BIG_ENDIAN_BITFIELD
-#endif
-
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 # define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
 # define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
 # define __le64_to_cpu(x) ((__force __u64)(__le64)(x))
@@ -46,7 +46,7 @@
 # define __cpu_to_be64(x) ((__force __be64)__swab64(x))
 #endif
 
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 # define __be16_to_cpu(x) ((__force __u16)(__be16)(x))
 # define __be32_to_cpu(x) ((__force __u32)(__be32)(x))
 # define __be64_to_cpu(x) ((__force __u64)(__be64)(x))
@@ -87,91 +87,91 @@
 
 static inline void __le16_to_cpus(__u16 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab16s(p);
 #endif
 }
 
 static inline void __cpu_to_le16s(__u16 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab16s(p);
 #endif
 }
 
 static inline void __le32_to_cpus(__u32 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab32s(p);
 #endif
 }
 
 static inline void __cpu_to_le32s(__u32 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab32s(p);
 #endif
 }
 
 static inline void __le64_to_cpus(__u64 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab64s(p);
 #endif
 }
 
 static inline void __cpu_to_le64s(__u64 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	__swab64s(p);
 #endif
 }
 
 static inline void __be16_to_cpus(__u16 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab16s(p);
 #endif
 }
 
 static inline void __cpu_to_be16s(__u16 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab16s(p);
 #endif
 }
 
 static inline void __be32_to_cpus(__u32 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab32s(p);
 #endif
 }
 
 static inline void __cpu_to_be32s(__u32 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab32s(p);
 #endif
 }
 
 static inline void __be64_to_cpus(__u64 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab64s(p);
 #endif
 }
 
 static inline void __cpu_to_be64s(__u64 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	__swab64s(p);
 #endif
 }
 
 static inline __u16 __le16_to_cpup(const __le16 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __u16)*p;
 #else
 	return __swab16p((__force __u16 *)p);
@@ -180,7 +180,7 @@ static inline __u16 __le16_to_cpup(const __le16 *p)
 
 static inline __u32 __le32_to_cpup(const __le32 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __u32)*p;
 #else
 	return __swab32p((__force __u32 *)p);
@@ -189,7 +189,7 @@ static inline __u32 __le32_to_cpup(const __le32 *p)
 
 static inline __u64 __le64_to_cpup(const __le64 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __u64)*p;
 #else
 	return __swab64p((__force __u64 *)p);
@@ -198,7 +198,7 @@ static inline __u64 __le64_to_cpup(const __le64 *p)
 
 static inline __le16 __cpu_to_le16p(const __u16 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __le16)*p;
 #else
 	return (__force __le16)__swab16p(p);
@@ -207,7 +207,7 @@ static inline __le16 __cpu_to_le16p(const __u16 *p)
 
 static inline __le32 __cpu_to_le32p(const __u32 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __le32)*p;
 #else
 	return (__force __le32)__swab32p(p);
@@ -216,7 +216,7 @@ static inline __le32 __cpu_to_le32p(const __u32 *p)
 
 static inline __le64 __cpu_to_le64p(const __u64 *p)
 {
-#ifdef __LITTLE_ENDIAN
+#ifdef __KERN_LITTLE_ENDIAN
 	return (__force __le64)*p;
 #else
 	return (__force __le64)__swab64p(p);
@@ -225,7 +225,7 @@ static inline __le64 __cpu_to_le64p(const __u64 *p)
 
 static inline __u16 __be16_to_cpup(const __be16 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __u16)*p;
 #else
 	return __swab16p((__force __u16 *)p);
@@ -234,7 +234,7 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 
 static inline __u32 __be32_to_cpup(const __be32 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __u32)*p;
 #else
 	return __swab32p((__force __u32 *)p);
@@ -243,7 +243,7 @@ static inline __u32 __be32_to_cpup(const __be32 *p)
 
 static inline __u64 __be64_to_cpup(const __be64 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __u64)*p;
 #else
 	return __swab64p((__force __u64 *)p);
@@ -252,7 +252,7 @@ static inline __u64 __be64_to_cpup(const __be64 *p)
 
 static inline __be16 __cpu_to_be16p(const __u16 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __be16)*p;
 #else
 	return (__force __be16)__swab16p(p);
@@ -261,7 +261,7 @@ static inline __be16 __cpu_to_be16p(const __u16 *p)
 
 static inline __be32 __cpu_to_be32p(const __u32 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __be32)*p;
 #else
 	return (__force __be32)__swab32p(p);
@@ -270,7 +270,7 @@ static inline __be32 __cpu_to_be32p(const __u32 *p)
 
 static inline __be64 __cpu_to_be64p(const __u64 *p)
 {
-#ifdef __BIG_ENDIAN
+#ifdef __KERN_BIG_ENDIAN
 	return (__force __be64)*p;
 #else
 	return (__force __be64)__swab64p(p);
-- 
1.6.1.rc2.316.geb2f0



