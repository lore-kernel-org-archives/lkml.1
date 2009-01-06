Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZAFVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZAFVcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZAFVcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZAFVb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:31:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dz79OUb2mJhSBgHbH5Sq/SBTsObKsBDepLsWZNMf6F99DMJ60vbDRkKfGH2pV/o0Jf
         fN/rEtemGN1zkHe7G3GbG/gA0KteTz/23VT1VF6CG0tGDgRMhP7m82am5ZCOBVgAyMVd
         wVaQcai+KDFQNSlL4noSh50H1CEmRFZvggxMg=
Subject: [PATCH 01/23] byteorder: only use linux/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Chris Zankel <chris@zankel.net>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Gerd Hoffmann <kraxel@redhat.com>, bluebird <bluebird@gentoo.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:44 -0800
Message-Id: <1231277444.964.258.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first step to make swab.h a regular header that will
include an asm/swab.h with arch overrides.

Avoid the gratuitous differences introduced in the new
linux/swab.h by naming the ___constant_swabXX bits and
__fswabXX bits exactly as found in the old implementation
in byteorder/swab[b].h

Use this new swab.h in byteorder/[big|little]_endian.h and
remove the two old swab headers.

This, and the trivial arch patches fix the problem introduced
with the consolidated linux/byteorder.h when included in userspace
that was defining both __LITTLE_ENDIAN and __BIG_ENDIAN.

Although the inclusion of asm/byteorder.h looks strange in
linux/swab.h, this will allow each arch to move the actual
arch overrides for the swab bits in an asm file and then
the includes can be cleaned up without requiring a flag day
for all arches at once.

Keep providing __fswabXX in case some userspace was using them
directly, but the revised __swabXX should be used instead in
any new code and will always do constant folding not dependent
on the optimization level, which means the __constant versions
can be phased out in-kernel.

Arches that use the old-style arch macros will lose their
optimized versions until they move to the new style, but at
least they will still compile.

Many arches have already moved and the patches to move the remaining
arches are trivial.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Linus, this series is vs. linux-next and is meant to be applied after
the following arches get pulled (all others I was waiting on have already
gone in):
parisc, cris (conversion to new arch style)
xtensa (headers being moved to arch/xtensa/ and conversion to new arch style)
sparc (additional changes to avoid leaking some symbols to userspace)

Patches 2-12 hit the arches that have already converted and are pure code
movements into an asm/swab.h

Patches 13-21 do the code movement _and_ conversion of arch-overrides.

Patches 22-23 clean up the swab.h additions to each arch's KBuild by adding
it to KBuild.asm and making asm/swab.h get included from linux/swab.h and
removes the conditional linux/byteorder.h that you objected to and caused the
userspace problems.


I will CC the arch maintainers on each patch, but they are all small enough
(at least with git diff -M -C that I hope you'll take them directly)

 include/linux/byteorder/Kbuild          |    2 -
 include/linux/byteorder/big_endian.h    |    3 +-
 include/linux/byteorder/little_endian.h |    3 +-
 include/linux/byteorder/swab.h          |  222 -------------------------------
 include/linux/byteorder/swabb.h         |  135 -------------------
 include/linux/swab.h                    |   50 ++++----
 6 files changed, 27 insertions(+), 388 deletions(-)

diff --git a/include/linux/byteorder/Kbuild b/include/linux/byteorder/Kbuild
index fbaa7f9..3843722 100644
--- a/include/linux/byteorder/Kbuild
+++ b/include/linux/byteorder/Kbuild
@@ -1,4 +1,2 @@
 unifdef-y += big_endian.h
 unifdef-y += little_endian.h
-unifdef-y += swab.h
-unifdef-y += swabb.h
diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 1cba3f3..3c80fd7 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -9,8 +9,7 @@
 #endif
 
 #include <linux/types.h>
-#include <linux/byteorder/swab.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 
 #define __constant_htonl(x) ((__force __be32)(__u32)(x))
 #define __constant_ntohl(x) ((__force __u32)(__be32)(x))
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index cedc1b5..83195fb 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -9,8 +9,7 @@
 #endif
 
 #include <linux/types.h>
-#include <linux/byteorder/swab.h>
-#include <linux/byteorder/swabb.h>
+#include <linux/swab.h>
 
 #define __constant_htonl(x) ((__force __be32)___constant_swab32((x)))
 #define __constant_ntohl(x) ___constant_swab32((__force __be32)(x))
diff --git a/include/linux/byteorder/swab.h b/include/linux/byteorder/swab.h
deleted file mode 100644
index 142134f..0000000
--- a/include/linux/byteorder/swab.h
+++ /dev/null
@@ -1,222 +0,0 @@
-#ifndef _LINUX_BYTEORDER_SWAB_H
-#define _LINUX_BYTEORDER_SWAB_H
-
-/*
- * linux/byteorder/swab.h
- * Byte-swapping, independently from CPU endianness
- *	swabXX[ps]?(foo)
- *
- * Francois-Rene Rideau <fare@tunes.org> 19971205
- *    separated swab functions from cpu_to_XX,
- *    to clean up support for bizarre-endian architectures.
- *
- * Trent Piepho <xyzzy@speakeasy.org> 2007114
- *    make constant-folding work, provide C versions that
- *    gcc can optimize better, explain different versions
- *
- * See asm-i386/byteorder.h and suches for examples of how to provide
- * architecture-dependent optimized versions
- *
- */
-
-#include <linux/compiler.h>
-
-/* Functions/macros defined, there are a lot:
- *
- * ___swabXX
- *    Generic C versions of the swab functions.
- *
- * ___constant_swabXX
- *    C versions that gcc can fold into a compile-time constant when
- *    the argument is a compile-time constant.
- *
- * __arch__swabXX[sp]?
- *    Architecture optimized versions of all the swab functions
- *    (including the s and p versions).  These can be defined in
- *    asm-arch/byteorder.h.  Any which are not, are defined here.
- *    __arch__swabXXs() is defined in terms of __arch__swabXXp(), which
- *    is defined in terms of __arch__swabXX(), which is in turn defined
- *    in terms of ___swabXX(x).
- *    These must be macros.  They may be unsafe for arguments with
- *    side-effects.
- *
- * __fswabXX
- *    Inline function versions of the __arch__ macros.  These _are_ safe
- *    if the arguments have side-effects.  Note there are no s and p
- *    versions of these.
- *
- * __swabXX[sb]
- *    There are the ones you should actually use.  The __swabXX versions
- *    will be a constant given a constant argument and use the arch
- *    specific code (if any) for non-constant arguments.  The s and p
- *    versions always use the arch specific code (constant folding
- *    doesn't apply).  They are safe to use with arguments with
- *    side-effects.
- *
- * swabXX[sb]
- *    Nicknames for __swabXX[sb] to use in the kernel.
- */
-
-/* casts are necessary for constants, because we never know how for sure
- * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
- */
-
-static __inline__ __attribute_const__ __u16 ___swab16(__u16 x)
-{
-	return x<<8 | x>>8;
-}
-static __inline__ __attribute_const__ __u32 ___swab32(__u32 x)
-{
-	return x<<24 | x>>24 |
-		(x & (__u32)0x0000ff00UL)<<8 |
-		(x & (__u32)0x00ff0000UL)>>8;
-}
-static __inline__ __attribute_const__ __u64 ___swab64(__u64 x)
-{
-	return x<<56 | x>>56 |
-		(x & (__u64)0x000000000000ff00ULL)<<40 |
-		(x & (__u64)0x0000000000ff0000ULL)<<24 |
-		(x & (__u64)0x00000000ff000000ULL)<< 8 |
-	        (x & (__u64)0x000000ff00000000ULL)>> 8 |
-		(x & (__u64)0x0000ff0000000000ULL)>>24 |
-		(x & (__u64)0x00ff000000000000ULL)>>40;
-}
-
-#define ___constant_swab16(x) \
-	((__u16)( \
-		(((__u16)(x) & (__u16)0x00ffU) << 8) | \
-		(((__u16)(x) & (__u16)0xff00U) >> 8) ))
-#define ___constant_swab32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x000000ffUL) << 24) | \
-		(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) | \
-		(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) | \
-		(((__u32)(x) & (__u32)0xff000000UL) >> 24) ))
-#define ___constant_swab64(x) \
-	((__u64)( \
-		(__u64)(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) | \
-		(__u64)(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00000000ff000000ULL) <<  8) | \
-	        (__u64)(((__u64)(x) & (__u64)0x000000ff00000000ULL) >>  8) | \
-		(__u64)(((__u64)(x) & (__u64)0x0000ff0000000000ULL) >> 24) | \
-		(__u64)(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) | \
-		(__u64)(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56) ))
-
-/*
- * provide defaults when no architecture-specific optimization is detected
- */
-#ifndef __arch__swab16
-#  define __arch__swab16(x) ___swab16(x)
-#endif
-#ifndef __arch__swab32
-#  define __arch__swab32(x) ___swab32(x)
-#endif
-#ifndef __arch__swab64
-#  define __arch__swab64(x) ___swab64(x)
-#endif
-
-#ifndef __arch__swab16p
-#  define __arch__swab16p(x) __arch__swab16(*(x))
-#endif
-#ifndef __arch__swab32p
-#  define __arch__swab32p(x) __arch__swab32(*(x))
-#endif
-#ifndef __arch__swab64p
-#  define __arch__swab64p(x) __arch__swab64(*(x))
-#endif
-
-#ifndef __arch__swab16s
-#  define __arch__swab16s(x) ((void)(*(x) = __arch__swab16p(x)))
-#endif
-#ifndef __arch__swab32s
-#  define __arch__swab32s(x) ((void)(*(x) = __arch__swab32p(x)))
-#endif
-#ifndef __arch__swab64s
-#  define __arch__swab64s(x) ((void)(*(x) = __arch__swab64p(x)))
-#endif
-
-
-/*
- * Allow constant folding
- */
-#if defined(__GNUC__) && defined(__OPTIMIZE__)
-#  define __swab16(x) \
-(__builtin_constant_p((__u16)(x)) ? \
- ___constant_swab16((x)) : \
- __fswab16((x)))
-#  define __swab32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___constant_swab32((x)) : \
- __fswab32((x)))
-#  define __swab64(x) \
-(__builtin_constant_p((__u64)(x)) ? \
- ___constant_swab64((x)) : \
- __fswab64((x)))
-#else
-#  define __swab16(x) __fswab16(x)
-#  define __swab32(x) __fswab32(x)
-#  define __swab64(x) __fswab64(x)
-#endif /* OPTIMIZE */
-
-
-static __inline__ __attribute_const__ __u16 __fswab16(__u16 x)
-{
-	return __arch__swab16(x);
-}
-static __inline__ __u16 __swab16p(const __u16 *x)
-{
-	return __arch__swab16p(x);
-}
-static __inline__ void __swab16s(__u16 *addr)
-{
-	__arch__swab16s(addr);
-}
-
-static __inline__ __attribute_const__ __u32 __fswab32(__u32 x)
-{
-	return __arch__swab32(x);
-}
-static __inline__ __u32 __swab32p(const __u32 *x)
-{
-	return __arch__swab32p(x);
-}
-static __inline__ void __swab32s(__u32 *addr)
-{
-	__arch__swab32s(addr);
-}
-
-#ifdef __BYTEORDER_HAS_U64__
-static __inline__ __attribute_const__ __u64 __fswab64(__u64 x)
-{
-#  ifdef __SWAB_64_THRU_32__
-	__u32 h = x >> 32;
-        __u32 l = x & ((1ULL<<32)-1);
-        return (((__u64)__swab32(l)) << 32) | ((__u64)(__swab32(h)));
-#  else
-	return __arch__swab64(x);
-#  endif
-}
-static __inline__ __u64 __swab64p(const __u64 *x)
-{
-	return __arch__swab64p(x);
-}
-static __inline__ void __swab64s(__u64 *addr)
-{
-	__arch__swab64s(addr);
-}
-#endif /* __BYTEORDER_HAS_U64__ */
-
-#if defined(__KERNEL__)
-#define swab16 __swab16
-#define swab32 __swab32
-#define swab64 __swab64
-#define swab16p __swab16p
-#define swab32p __swab32p
-#define swab64p __swab64p
-#define swab16s __swab16s
-#define swab32s __swab32s
-#define swab64s __swab64s
-#endif
-
-#endif /* _LINUX_BYTEORDER_SWAB_H */
diff --git a/include/linux/byteorder/swabb.h b/include/linux/byteorder/swabb.h
deleted file mode 100644
index 8c780c7..0000000
--- a/include/linux/byteorder/swabb.h
+++ /dev/null
@@ -1,135 +0,0 @@
-#ifndef _LINUX_BYTEORDER_SWABB_H
-#define _LINUX_BYTEORDER_SWABB_H
-
-/*
- * linux/byteorder/swabb.h
- * SWAp Bytes Bizarrely
- *	swaHHXX[ps]?(foo)
- *
- * Support for obNUXIous pdp-endian and other bizarre architectures.
- * Will Linux ever run on such ancient beasts? if not, this file
- * will be but a programming pearl. Still, it's a reminder that we
- * shouldn't be making too many assumptions when trying to be portable.
- *
- */
-
-/*
- * Meaning of the names I chose (vaxlinux people feel free to correct them):
- * swahw32	swap 16-bit half-words in a 32-bit word
- * swahb32	swap 8-bit halves of each 16-bit half-word in a 32-bit word
- *
- * No 64-bit support yet. I don't know NUXI conventions for long longs.
- * I guarantee it will be a mess when it's there, though :->
- * It will be even worse if there are conflicting 64-bit conventions.
- * Hopefully, no one ever used 64-bit objects on NUXI machines.
- *
- */
-
-#include <linux/types.h>
-
-#define ___swahw32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x0000ffffUL) << 16) | \
-		(((__u32)(__x) & (__u32)0xffff0000UL) >> 16) )); \
-})
-#define ___swahb32(x) \
-({ \
-	__u32 __x = (x); \
-	((__u32)( \
-		(((__u32)(__x) & (__u32)0x00ff00ffUL) << 8) | \
-		(((__u32)(__x) & (__u32)0xff00ff00UL) >> 8) )); \
-})
-
-#define ___constant_swahw32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x0000ffffUL) << 16) | \
-		(((__u32)(x) & (__u32)0xffff0000UL) >> 16) ))
-#define ___constant_swahb32(x) \
-	((__u32)( \
-		(((__u32)(x) & (__u32)0x00ff00ffUL) << 8) | \
-		(((__u32)(x) & (__u32)0xff00ff00UL) >> 8) ))
-
-/*
- * provide defaults when no architecture-specific optimization is detected
- */
-#ifndef __arch__swahw32
-#  define __arch__swahw32(x) ___swahw32(x)
-#endif
-#ifndef __arch__swahb32
-#  define __arch__swahb32(x) ___swahb32(x)
-#endif
-
-#ifndef __arch__swahw32p
-#  define __arch__swahw32p(x) __swahw32(*(x))
-#endif
-#ifndef __arch__swahb32p
-#  define __arch__swahb32p(x) __swahb32(*(x))
-#endif
-
-#ifndef __arch__swahw32s
-#  define __arch__swahw32s(x) do { *(x) = __swahw32p((x)); } while (0)
-#endif
-#ifndef __arch__swahb32s
-#  define __arch__swahb32s(x) do { *(x) = __swahb32p((x)); } while (0)
-#endif
-
-
-/*
- * Allow constant folding
- */
-#define __swahw32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___swahw32((x)) : \
- __fswahw32((x)))
-#define __swahb32(x) \
-(__builtin_constant_p((__u32)(x)) ? \
- ___swahb32((x)) : \
- __fswahb32((x)))
-
-
-static inline __u32 __fswahw32(__u32 x)
-{
-	return __arch__swahw32(x);
-}
-
-static inline __u32 __swahw32p(__u32 *x)
-{
-	return __arch__swahw32p(x);
-}
-
-static inline void __swahw32s(__u32 *addr)
-{
-	__arch__swahw32s(addr);
-}
-
-static inline __u32 __fswahb32(__u32 x)
-{
-	return __arch__swahb32(x);
-}
-
-static inline __u32 __swahb32p(__u32 *x)
-{
-	return __arch__swahb32p(x);
-}
-
-static inline void __swahb32s(__u32 *addr)
-{
-	__arch__swahb32s(addr);
-}
-
-#ifdef __BYTEORDER_HAS_U64__
-/*
- * Not supported yet
- */
-#endif /* __BYTEORDER_HAS_U64__ */
-
-#define swahw32 __swahw32
-#define swahb32 __swahb32
-#define swahw32p __swahw32p
-#define swahb32p __swahb32p
-#define swahw32s __swahw32s
-#define swahb32s __swahb32s
-
-#endif /* _LINUX_BYTEORDER_SWABB_H */
diff --git a/include/linux/swab.h b/include/linux/swab.h
index bbed279..9a2d33e 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -9,17 +9,17 @@
  * casts are necessary for constants, because we never know how for sure
  * how U/UL/ULL map to __u16, __u32, __u64. At least not in a portable way.
  */
-#define __const_swab16(x) ((__u16)(				\
+#define ___constant_swab16(x) ((__u16)(				\
 	(((__u16)(x) & (__u16)0x00ffU) << 8) |			\
 	(((__u16)(x) & (__u16)0xff00U) >> 8)))
 
-#define __const_swab32(x) ((__u32)(				\
+#define ___constant_swab32(x) ((__u32)(				\
 	(((__u32)(x) & (__u32)0x000000ffUL) << 24) |		\
 	(((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |		\
 	(((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |		\
 	(((__u32)(x) & (__u32)0xff000000UL) >> 24)))
 
-#define __const_swab64(x) ((__u64)(				\
+#define ___constant_swab64(x) ((__u64)(				\
 	(((__u64)(x) & (__u64)0x00000000000000ffULL) << 56) |	\
 	(((__u64)(x) & (__u64)0x000000000000ff00ULL) << 40) |	\
 	(((__u64)(x) & (__u64)0x0000000000ff0000ULL) << 24) |	\
@@ -29,11 +29,11 @@
 	(((__u64)(x) & (__u64)0x00ff000000000000ULL) >> 40) |	\
 	(((__u64)(x) & (__u64)0xff00000000000000ULL) >> 56)))
 
-#define __const_swahw32(x) ((__u32)(				\
+#define ___constant_swahw32(x) ((__u32)(			\
 	(((__u32)(x) & (__u32)0x0000ffffUL) << 16) |		\
 	(((__u32)(x) & (__u32)0xffff0000UL) >> 16)))
 
-#define __const_swahb32(x) ((__u32)(				\
+#define ___constant_swahb32(x) ((__u32)(			\
 	(((__u32)(x) & (__u32)0x00ff00ffUL) << 8) |		\
 	(((__u32)(x) & (__u32)0xff00ff00UL) >> 8)))
 
@@ -43,25 +43,25 @@
  * ___swab16, ___swab32, ___swab64, ___swahw32, ___swahb32
  */
 
-static inline __attribute_const__ __u16 ___swab16(__u16 val)
+static inline __attribute_const__ __u16 __fswab16(__u16 val)
 {
 #ifdef __arch_swab16
 	return __arch_swab16(val);
 #else
-	return __const_swab16(val);
+	return ___constant_swab16(val);
 #endif
 }
 
-static inline __attribute_const__ __u32 ___swab32(__u32 val)
+static inline __attribute_const__ __u32 __fswab32(__u32 val)
 {
 #ifdef __arch_swab32
 	return __arch_swab32(val);
 #else
-	return __const_swab32(val);
+	return ___constant_swab32(val);
 #endif
 }
 
-static inline __attribute_const__ __u64 ___swab64(__u64 val)
+static inline __attribute_const__ __u64 __fswab64(__u64 val)
 {
 #ifdef __arch_swab64
 	return __arch_swab64(val);
@@ -70,25 +70,25 @@ static inline __attribute_const__ __u64 ___swab64(__u64 val)
 	__u32 l = val & ((1ULL << 32) - 1);
 	return (((__u64)___swab32(l)) << 32) | ((__u64)(___swab32(h)));
 #else
-	return __const_swab64(val);
+	return ___constant_swab64(val);
 #endif
 }
 
-static inline __attribute_const__ __u32 ___swahw32(__u32 val)
+static inline __attribute_const__ __u32 __fswahw32(__u32 val)
 {
 #ifdef __arch_swahw32
 	return __arch_swahw32(val);
 #else
-	return __const_swahw32(val);
+	return ___constant_swahw32(val);
 #endif
 }
 
-static inline __attribute_const__ __u32 ___swahb32(__u32 val)
+static inline __attribute_const__ __u32 __fswahb32(__u32 val)
 {
 #ifdef __arch_swahb32
 	return __arch_swahb32(val);
 #else
-	return __const_swahb32(val);
+	return ___constant_swahb32(val);
 #endif
 }
 
@@ -98,8 +98,8 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 #define __swab16(x)				\
 	(__builtin_constant_p((__u16)(x)) ?	\
-	__const_swab16((x)) :			\
-	___swab16((x)))
+	___constant_swab16(x) :			\
+	__fswab16(x))
 
 /**
  * __swab32 - return a byteswapped 32-bit value
@@ -107,8 +107,8 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 #define __swab32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
-	__const_swab32((x)) :			\
-	___swab32((x)))
+	___constant_swab32(x) :			\
+	__fswab32(x))
 
 /**
  * __swab64 - return a byteswapped 64-bit value
@@ -116,8 +116,8 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 #define __swab64(x)				\
 	(__builtin_constant_p((__u64)(x)) ?	\
-	__const_swab64((x)) :			\
-	___swab64((x)))
+	___constant_swab64(x) :			\
+	__fswab64(x))
 
 /**
  * __swahw32 - return a word-swapped 32-bit value
@@ -127,8 +127,8 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 #define __swahw32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
-	__const_swahw32((x)) :			\
-	___swahw32((x)))
+	___constant_swahw32(x) :		\
+	__fswahw32(x))
 
 /**
  * __swahb32 - return a high and low byte-swapped 32-bit value
@@ -138,8 +138,8 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 #define __swahb32(x)				\
 	(__builtin_constant_p((__u32)(x)) ?	\
-	__const_swahb32((x)) :			\
-	___swahb32((x)))
+	___constant_swahb32(x) :		\
+	__fswahb32(x))
 
 /**
  * __swab16p - return a byteswapped 16-bit value from a pointer
-- 
1.6.1.94.g9388


