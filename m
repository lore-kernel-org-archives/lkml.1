Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbYDISV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbYDISV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 14:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYDISVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 14:21:51 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:28868 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbYDISVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 14:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sZdZ9K5ZS/MxRf0Ff9hkjL76AOp/j1G5pUk0MWyFXKwEIVKIPGDx3WGTCYrdFSciZ6q315iX7dnm3Si1eP1N++CiUK/Y6pl/etkYUodvwVPM9jRFZ0lBFxBdSXeep/DgeyhokkLEAGdPuaAJUcZ0RaNCSgZYNo9ouXyY2mdOCns=
Subject: [RFC PATCH] kernel: revamp handling of unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 11:22:01 -0700
Message-Id: <1207765322.16220.8.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a linux/unaligned folder similar in spirit to the linux/byteorder
folder to hold generic implementations collected from various arches.

Currently there are five implementations:
1) cpu_endian.h: C-struct based, from asm-generic/unaligned.h
2) little_endian.h: Open coded byte-swapping, taken from arm
3) big_endian.h: Open coded byte-swapping, taken from arm
4) no_builtin_memcpy.h: multiple implementations
5) access_ok.h: x86 and others, unaligned access is ok.

There is also the addition of some byteorder unaligned accesses api:

get_unaligned_{le16|le32|le64|be16|be32|be64}(p) which is meant to replace
code of the form:
le16_to_cpu(get_unaligned((__le16 *)p));

put_unaligned_{le16|le32|le64|be16|be32|be64}(val, pointer) which is meant to
replace code of the form:
put_unaligned(cpu_to_le16(val), (__le16 *)p);

Helpers to create these based on the selected implementation and define the
appropriate get_unaligned() and put_unaligned() macros are:

generic_le.h: Use the C-struct for get/put_unaligned and the le helpers, use the
opencoded be byteswapping implementation for be.

generic_be.h: Use the C-struct for get/put_unaligned and the be helpers, use the
opencoded le byteswapping implementation for le.

generic.h: Use opencoded byteswapping for all helpers, leaves it to the arch to
define get/put_unaligned

Only frv has a custom implementation that has not been included.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-alpha/unaligned.h               |    2 +-
 include/asm-arm/unaligned.h                 |  166 +--------------------------
 include/asm-avr32/unaligned.h               |    2 +-
 include/asm-blackfin/unaligned.h            |    2 +-
 include/asm-cris/unaligned.h                |    8 +-
 include/asm-generic/unaligned.h             |  124 --------------------
 include/asm-h8300/unaligned.h               |   11 +--
 include/asm-ia64/unaligned.h                |    2 +-
 include/asm-m32r/unaligned.h                |   15 +---
 include/asm-m68k/unaligned.h                |    9 +--
 include/asm-m68knommu/unaligned.h           |   10 +--
 include/asm-mips/unaligned.h                |   30 ++---
 include/asm-mn10300/unaligned.h             |  126 +--------------------
 include/asm-parisc/unaligned.h              |    2 +-
 include/asm-powerpc/unaligned.h             |    9 +--
 include/asm-s390/unaligned.h                |    9 +--
 include/asm-sh/unaligned.h                  |    6 +-
 include/asm-sparc/unaligned.h               |    2 +-
 include/asm-sparc64/unaligned.h             |    2 +-
 include/asm-v850/unaligned.h                |  111 +-----------------
 include/asm-x86/unaligned.h                 |   30 +-----
 include/asm-xtensa/unaligned.h              |   12 +--
 include/linux/unaligned/access_ok.h         |   70 +++++++++++
 include/linux/unaligned/big_endian.h        |   82 +++++++++++++
 include/linux/unaligned/cpu_endian.h        |   88 ++++++++++++++
 include/linux/unaligned/generic.h           |   67 +++++++++++
 include/linux/unaligned/generic_be.h        |   70 +++++++++++
 include/linux/unaligned/generic_le.h        |   70 +++++++++++
 include/linux/unaligned/little_endian.h     |   82 +++++++++++++
 include/linux/unaligned/no_builtin_memcpy.h |   79 +++++++++++++
 30 files changed, 647 insertions(+), 651 deletions(-)

diff --git a/include/asm-alpha/unaligned.h b/include/asm-alpha/unaligned.h
index a1d7284..18acc19 100644
--- a/include/asm-alpha/unaligned.h
+++ b/include/asm-alpha/unaligned.h
@@ -1,6 +1,6 @@
 #ifndef __ALPHA_UNALIGNED_H
 #define __ALPHA_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_le.h>
 
 #endif
diff --git a/include/asm-arm/unaligned.h b/include/asm-arm/unaligned.h
index 5db03cf..d5cf478 100644
--- a/include/asm-arm/unaligned.h
+++ b/include/asm-arm/unaligned.h
@@ -1,171 +1,7 @@
 #ifndef __ASM_ARM_UNALIGNED_H
 #define __ASM_ARM_UNALIGNED_H
 
-#include <asm/types.h>
-
-extern int __bug_unaligned_x(const void *ptr);
-
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2_le(__p)					\
-	(unsigned int)(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_2_be(__p)					\
-	(unsigned int)(__p[0] << 8 | __p[1])
-
-#define __get_unaligned_4_le(__p)					\
-	(unsigned int)(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define __get_unaligned_4_be(__p)					\
-	(unsigned int)(__p[0] << 24 | __p[1] << 16 | __p[2] << 8 | __p[3])
-
-#define __get_unaligned_8_le(__p)					\
-	((unsigned long long)__get_unaligned_4_le((__p+4)) << 32 |	\
-		__get_unaligned_4_le(__p))
-
-#define __get_unaligned_8_be(__p)					\
-	((unsigned long long)__get_unaligned_4_be(__p) << 32 |		\
-		__get_unaligned_4_be((__p+4)))
-
-#define __get_unaligned_le(ptr)						\
-	((__force typeof(*(ptr)))({					\
-		const __u8 *__p = (const __u8 *)(ptr);			\
-		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_le(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_le(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_le(__p),	\
-		    (void)__bug_unaligned_x(__p)))));			\
-	}))
-
-#define __get_unaligned_be(ptr)						\
-	((__force typeof(*(ptr)))({					\
-		const __u8 *__p = (const __u8 *)(ptr);			\
-		__builtin_choose_expr(sizeof(*(ptr)) == 1, *__p,	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 2, __get_unaligned_2_be(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 4, __get_unaligned_4_be(__p),	\
-		  __builtin_choose_expr(sizeof(*(ptr)) == 8, __get_unaligned_8_be(__p),	\
-		    (void)__bug_unaligned_x(__p)))));			\
-	}))
-
-
-static inline void __put_unaligned_2_le(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_2_be(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v >> 8;
-	*__p++ = __v;
-}
-
-static inline void __put_unaligned_4_le(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2_le(__v >> 16, __p + 2);
-	__put_unaligned_2_le(__v, __p);
-}
-
-static inline void __put_unaligned_4_be(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2_be(__v >> 16, __p);
-	__put_unaligned_2_be(__v, __p + 2);
-}
-
-static inline void __put_unaligned_8_le(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4_le(__v >> 32, __p+4);
-	__put_unaligned_4_le(__v, __p);
-}
-
-static inline void __put_unaligned_8_be(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4_be(__v >> 32, __p);
-	__put_unaligned_4_be(__v, __p+4);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define __put_unaligned_le(val,ptr)					\
-	({							\
-		(void)sizeof(*(ptr) = (val));			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2_le((__force u16)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4_le((__force u32)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8_le((__force u64)(val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
-
-#define __put_unaligned_be(val,ptr)					\
-	({							\
-		(void)sizeof(*(ptr) = (val));			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2_be((__force u16)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4_be((__force u32)(val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8_be((__force u64)(val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
+#include <linux/unaligned/generic.h>
 
 /*
  * Select endianness
diff --git a/include/asm-avr32/unaligned.h b/include/asm-avr32/unaligned.h
index 36f5fd4..28fa20e 100644
--- a/include/asm-avr32/unaligned.h
+++ b/include/asm-avr32/unaligned.h
@@ -11,6 +11,6 @@
  * optimize word loads in general.
  */
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_be.h>
 
 #endif /* __ASM_AVR32_UNALIGNED_H */
diff --git a/include/asm-blackfin/unaligned.h b/include/asm-blackfin/unaligned.h
index 10081dc..25861cd 100644
--- a/include/asm-blackfin/unaligned.h
+++ b/include/asm-blackfin/unaligned.h
@@ -1,6 +1,6 @@
 #ifndef __BFIN_UNALIGNED_H
 #define __BFIN_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_le.h>
 
 #endif				/* __BFIN_UNALIGNED_H */
diff --git a/include/asm-cris/unaligned.h b/include/asm-cris/unaligned.h
index 7fbbb39..8bd3555 100644
--- a/include/asm-cris/unaligned.h
+++ b/include/asm-cris/unaligned.h
@@ -3,14 +3,8 @@
 
 /*
  * CRIS can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
 
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif
diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
deleted file mode 100644
index 2fe1b2e..0000000
--- a/include/asm-generic/unaligned.h
+++ /dev/null
@@ -1,124 +0,0 @@
-#ifndef _ASM_GENERIC_UNALIGNED_H_
-#define _ASM_GENERIC_UNALIGNED_H_
-
-/*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents. 
- *
- * This is based almost entirely upon Richard Henderson's
- * asm-alpha/unaligned.h implementation.  Some comments were
- * taken from David Mosberger's asm-ia64/unaligned.h header.
- */
-
-#include <linux/types.h>
-
-/* 
- * The main single-value unaligned transfer routines.
- */
-#define get_unaligned(ptr) \
-	__get_unaligned((ptr), sizeof(*(ptr)))
-#define put_unaligned(x,ptr) \
-	((void)sizeof(*(ptr)=(x)),\
-	__put_unaligned((__force __u64)(x), (ptr), sizeof(*(ptr))))
-
-/*
- * This function doesn't actually exist.  The idea is that when
- * someone uses the macros below with an unsupported size (datatype),
- * the linker will alert us to the problem via an unresolved reference
- * error.
- */
-extern void bad_unaligned_access_length(void) __attribute__((noreturn));
-
-struct __una_u64 { __u64 x __attribute__((packed)); };
-struct __una_u32 { __u32 x __attribute__((packed)); };
-struct __una_u16 { __u16 x __attribute__((packed)); };
-
-/*
- * Elemental unaligned loads 
- */
-
-static inline __u64 __uldq(const __u64 *addr)
-{
-	const struct __una_u64 *ptr = (const struct __una_u64 *) addr;
-	return ptr->x;
-}
-
-static inline __u32 __uldl(const __u32 *addr)
-{
-	const struct __una_u32 *ptr = (const struct __una_u32 *) addr;
-	return ptr->x;
-}
-
-static inline __u16 __uldw(const __u16 *addr)
-{
-	const struct __una_u16 *ptr = (const struct __una_u16 *) addr;
-	return ptr->x;
-}
-
-/*
- * Elemental unaligned stores 
- */
-
-static inline void __ustq(__u64 val, __u64 *addr)
-{
-	struct __una_u64 *ptr = (struct __una_u64 *) addr;
-	ptr->x = val;
-}
-
-static inline void __ustl(__u32 val, __u32 *addr)
-{
-	struct __una_u32 *ptr = (struct __una_u32 *) addr;
-	ptr->x = val;
-}
-
-static inline void __ustw(__u16 val, __u16 *addr)
-{
-	struct __una_u16 *ptr = (struct __una_u16 *) addr;
-	ptr->x = val;
-}
-
-#define __get_unaligned(ptr, size) ({		\
-	const void *__gu_p = ptr;		\
-	__u64 __val;				\
-	switch (size) {				\
-	case 1:					\
-		__val = *(const __u8 *)__gu_p;	\
-		break;				\
-	case 2:					\
-		__val = __uldw(__gu_p);		\
-		break;				\
-	case 4:					\
-		__val = __uldl(__gu_p);		\
-		break;				\
-	case 8:					\
-		__val = __uldq(__gu_p);		\
-		break;				\
-	default:				\
-		bad_unaligned_access_length();	\
-	};					\
-	(__force __typeof__(*(ptr)))__val;	\
-})
-
-#define __put_unaligned(val, ptr, size)		\
-({						\
-	void *__gu_p = ptr;			\
-	switch (size) {				\
-	case 1:					\
-		*(__u8 *)__gu_p = (__force __u8)val;		\
-	        break;				\
-	case 2:					\
-		__ustw((__force __u16)val, __gu_p);		\
-		break;				\
-	case 4:					\
-		__ustl((__force __u32)val, __gu_p);		\
-		break;				\
-	case 8:					\
-		__ustq(val, __gu_p);		\
-		break;				\
-	default:				\
-	    	bad_unaligned_access_length();	\
-	};					\
-	(void)0;				\
-})
-
-#endif /* _ASM_GENERIC_UNALIGNED_H */
diff --git a/include/asm-h8300/unaligned.h b/include/asm-h8300/unaligned.h
index ffb67f4..e8ff49d 100644
--- a/include/asm-h8300/unaligned.h
+++ b/include/asm-h8300/unaligned.h
@@ -1,15 +1,6 @@
 #ifndef __H8300_UNALIGNED_H
 #define __H8300_UNALIGNED_H
 
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
+#include <linux/unaligned/no_builtin_memcpy.h>
 
 #endif
diff --git a/include/asm-ia64/unaligned.h b/include/asm-ia64/unaligned.h
index bb85598..2134205 100644
--- a/include/asm-ia64/unaligned.h
+++ b/include/asm-ia64/unaligned.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_IA64_UNALIGNED_H
 #define _ASM_IA64_UNALIGNED_H
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_le.h>
 
 #endif /* _ASM_IA64_UNALIGNED_H */
diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index fccc180..5a4c931 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -1,19 +1,6 @@
 #ifndef _ASM_M32R_UNALIGNED_H
 #define _ASM_M32R_UNALIGNED_H
 
-/*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents.
- */
-
-#include <asm/string.h>
-
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
+#include <linux/unaligned/no_builtin_memcpy.h>
 
 #endif /* _ASM_M32R_UNALIGNED_H */
diff --git a/include/asm-m68k/unaligned.h b/include/asm-m68k/unaligned.h
index 804cb3f..94b4a77 100644
--- a/include/asm-m68k/unaligned.h
+++ b/include/asm-m68k/unaligned.h
@@ -3,14 +3,7 @@
 
 /*
  * The m68k can do unaligned accesses itself.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
-
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif
diff --git a/include/asm-m68knommu/unaligned.h b/include/asm-m68knommu/unaligned.h
index 869e9dd..6b5c7a2 100644
--- a/include/asm-m68knommu/unaligned.h
+++ b/include/asm-m68knommu/unaligned.h
@@ -4,19 +4,13 @@
 
 #ifdef CONFIG_COLDFIRE
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_be.h>
 
 #else
 /*
  * The m68k can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
-
-#define get_unaligned(ptr) (*(ptr))
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif
 
diff --git a/include/asm-mips/unaligned.h b/include/asm-mips/unaligned.h
index 3249049..bddbbfb 100644
--- a/include/asm-mips/unaligned.h
+++ b/include/asm-mips/unaligned.h
@@ -5,25 +5,15 @@
  *
  * Copyright (C) 2007 Ralf Baechle (ralf@linux-mips.org)
  */
-#ifndef __ASM_GENERIC_UNALIGNED_H
-#define __ASM_GENERIC_UNALIGNED_H
+#ifndef __ASM_MIPS_UNALIGNED_H
+#define __ASM_MIPS_UNALIGNED_H
 
-#include <linux/compiler.h>
+#if defined(__MIPSEB__)
+#  include <linux/unaligned/generic_be.h>
+#elif defined(__MIPSEL__)
+#  include <linux/unaligned/generic_le.h>
+#else
+#  error "MIPS, but neither __MIPSEB__, nor __MIPSEL__???"
+#endif
 
-#define get_unaligned(ptr)					\
-({								\
-	struct __packed {					\
-		typeof(*(ptr)) __v;				\
-	} *__p = (void *) (ptr);				\
-	__p->__v;						\
-})
-
-#define put_unaligned(val, ptr)					\
-do {								\
-	struct __packed {					\
-		typeof(*(ptr)) __v;				\
-	} *__p = (void *) (ptr);				\
-	__p->__v = (val);					\
-} while(0)
-
-#endif /* __ASM_GENERIC_UNALIGNED_H */
+#endif /* __ASM_MIPS_UNALIGNED_H */
diff --git a/include/asm-mn10300/unaligned.h b/include/asm-mn10300/unaligned.h
index cad3afb..c377ba0 100644
--- a/include/asm-mn10300/unaligned.h
+++ b/include/asm-mn10300/unaligned.h
@@ -8,129 +8,9 @@
  * as published by the Free Software Foundation; either version
  * 2 of the Licence, or (at your option) any later version.
  */
-#ifndef _ASM_UNALIGNED_H
-#define _ASM_UNALIGNED_H
+#ifndef _ASM_MN10300_UNALIGNED_H
+#define _ASM_MN10300_UNALIGNED_H
 
-#include <asm/types.h>
-
-#if 0
-extern int __bug_unaligned_x(void *ptr);
-
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2(__p)					\
-	(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_4(__p)					\
-	(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define get_unaligned(ptr)					\
-({								\
-	unsigned int __v1, __v2;				\
-	__typeof__(*(ptr)) __v;					\
-	__u8 *__p = (__u8 *)(ptr);				\
-								\
-	switch (sizeof(*(ptr))) {				\
-	case 1:	__v = *(ptr);			break;		\
-	case 2: __v = __get_unaligned_2(__p);	break;		\
-	case 4: __v = __get_unaligned_4(__p);	break;		\
-	case 8:							\
-		__v2 = __get_unaligned_4((__p+4));		\
-		__v1 = __get_unaligned_4(__p);			\
-		__v = ((unsigned long long)__v2 << 32 | __v1);	\
-		break;						\
-	default: __v = __bug_unaligned_x(__p);	break;		\
-	}							\
-	__v;							\
-})
-
-
-static inline void __put_unaligned_2(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_4(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2(__v >> 16, __p + 2);
-	__put_unaligned_2(__v, __p);
-}
-
-static inline void __put_unaligned_8(const unsigned long long __v, __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4(__v >> 32, __p + 4);
-	__put_unaligned_4(__v, __p);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define put_unaligned(val, ptr)						\
-	({								\
-		switch (sizeof(*(ptr))) {				\
-		case 1:							\
-			*(ptr) = (val);					\
-			break;						\
-		case 2:							\
-			__put_unaligned_2((val), (__u8 *)(ptr));	\
-			break;						\
-		case 4:							\
-			__put_unaligned_4((val), (__u8 *)(ptr));	\
-			break;						\
-		case 8:							\
-			__put_unaligned_8((val), (__u8 *)(ptr));	\
-			break;						\
-		default:						\
-			__bug_unaligned_x(ptr);				\
-			break;						\
-		}							\
-		(void) 0;						\
-	})
-
-
-#else
-
-#define get_unaligned(ptr) (*(ptr))
-#define put_unaligned(val, ptr) ({ *(ptr) = (val); (void) 0; })
-
-#endif
+#include <linux/unaligned/access_ok.h>
 
 #endif
diff --git a/include/asm-parisc/unaligned.h b/include/asm-parisc/unaligned.h
index 53c9058..865867c 100644
--- a/include/asm-parisc/unaligned.h
+++ b/include/asm-parisc/unaligned.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_PARISC_UNALIGNED_H_
 #define _ASM_PARISC_UNALIGNED_H_
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_be.h>
 
 #ifdef __KERNEL__
 struct pt_regs;
diff --git a/include/asm-powerpc/unaligned.h b/include/asm-powerpc/unaligned.h
index 6c95dfa..59bcc21 100644
--- a/include/asm-powerpc/unaligned.h
+++ b/include/asm-powerpc/unaligned.h
@@ -5,15 +5,8 @@
 
 /*
  * The PowerPC can do unaligned accesses itself in big endian mode.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
-
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_UNALIGNED_H */
diff --git a/include/asm-s390/unaligned.h b/include/asm-s390/unaligned.h
index 8ee86db..1d4a684 100644
--- a/include/asm-s390/unaligned.h
+++ b/include/asm-s390/unaligned.h
@@ -11,14 +11,7 @@
 
 /*
  * The S390 can do unaligned accesses itself. 
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
-
-#define get_unaligned(ptr) (*(ptr))
-
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif
diff --git a/include/asm-sh/unaligned.h b/include/asm-sh/unaligned.h
index 5250e30..391da8d 100644
--- a/include/asm-sh/unaligned.h
+++ b/include/asm-sh/unaligned.h
@@ -2,6 +2,10 @@
 #define __ASM_SH_UNALIGNED_H
 
 /* SH can't handle unaligned accesses. */
-#include <asm-generic/unaligned.h>
+#ifdef __LITTLE_ENDIAN__
+#include <linux/unaligned/generic_le.h>
+#else
+#include <linux/unaligned/generic_be.h>
+#endif
 
 #endif /* __ASM_SH_UNALIGNED_H */
diff --git a/include/asm-sparc/unaligned.h b/include/asm-sparc/unaligned.h
index b6f8edd..9f1bb56 100644
--- a/include/asm-sparc/unaligned.h
+++ b/include/asm-sparc/unaligned.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_SPARC_UNALIGNED_H_
 #define _ASM_SPARC_UNALIGNED_H_
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_be.h>
 
 #endif /* _ASM_SPARC_UNALIGNED_H */
diff --git a/include/asm-sparc64/unaligned.h b/include/asm-sparc64/unaligned.h
index 1ed3ba5..faa18cd 100644
--- a/include/asm-sparc64/unaligned.h
+++ b/include/asm-sparc64/unaligned.h
@@ -1,6 +1,6 @@
 #ifndef _ASM_SPARC64_UNALIGNED_H_
 #define _ASM_SPARC64_UNALIGNED_H_
 
-#include <asm-generic/unaligned.h>
+#include <linux/unaligned/generic_be.h>
 
 #endif /* _ASM_SPARC64_UNALIGNED_H */
diff --git a/include/asm-v850/unaligned.h b/include/asm-v850/unaligned.h
index e30b186..09fc37c 100644
--- a/include/asm-v850/unaligned.h
+++ b/include/asm-v850/unaligned.h
@@ -17,114 +17,9 @@
 #ifndef __V850_UNALIGNED_H__
 #define __V850_UNALIGNED_H__
 
-#include <asm/types.h>
-
-extern int __bug_unaligned_x(void *ptr);
-
-/*
- * What is the most efficient way of loading/storing an unaligned value?
- *
- * That is the subject of this file.  Efficiency here is defined as
- * minimum code size with minimum register usage for the common cases.
- * It is currently not believed that long longs are common, so we
- * trade efficiency for the chars, shorts and longs against the long
- * longs.
- *
- * Current stats with gcc 2.7.2.2 for these functions:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	3		7	3
- *	8		20	6		16	6
- *
- * gcc 2.95.1 seems to code differently:
- *
- *	ptrsize	get:	code	regs	put:	code	regs
- *	1		1	1		1	2
- *	2		3	2		3	2
- *	4		7	4		7	4
- *	8		19	8		15	6
- *
- * which may or may not be more efficient (depending upon whether
- * you can afford the extra registers).  Hopefully the gcc 2.95
- * is inteligent enough to decide if it is better to use the
- * extra register, but evidence so far seems to suggest otherwise.
- *
- * Unfortunately, gcc is not able to optimise the high word
- * out of long long >> 32, or the low word from long long << 32
- */
-
-#define __get_unaligned_2(__p)					\
-	(__p[0] | __p[1] << 8)
-
-#define __get_unaligned_4(__p)					\
-	(__p[0] | __p[1] << 8 | __p[2] << 16 | __p[3] << 24)
-
-#define get_unaligned(ptr)					\
-	({							\
-		__typeof__(*(ptr)) __v;				\
-		__u8 *__p = (__u8 *)(ptr);			\
-		switch (sizeof(*(ptr))) {			\
-		case 1:	__v = *(ptr);			break;	\
-		case 2: __v = __get_unaligned_2(__p);	break;	\
-		case 4: __v = __get_unaligned_4(__p);	break;	\
-		case 8: {					\
-				unsigned int __v1, __v2;	\
-				__v2 = __get_unaligned_4((__p+4)); \
-				__v1 = __get_unaligned_4(__p);	\
-				__v = ((unsigned long long)__v2 << 32 | __v1);	\
-			}					\
-			break;					\
-		default: __v = __bug_unaligned_x(__p);	break;	\
-		}						\
-		__v;						\
-	})
-
-
-static inline void __put_unaligned_2(__u32 __v, register __u8 *__p)
-{
-	*__p++ = __v;
-	*__p++ = __v >> 8;
-}
-
-static inline void __put_unaligned_4(__u32 __v, register __u8 *__p)
-{
-	__put_unaligned_2(__v >> 16, __p + 2);
-	__put_unaligned_2(__v, __p);
-}
-
-static inline void __put_unaligned_8(const unsigned long long __v, register __u8 *__p)
-{
-	/*
-	 * tradeoff: 8 bytes of stack for all unaligned puts (2
-	 * instructions), or an extra register in the long long
-	 * case - go for the extra register.
-	 */
-	__put_unaligned_4(__v >> 32, __p+4);
-	__put_unaligned_4(__v, __p);
-}
-
-/*
- * Try to store an unaligned value as efficiently as possible.
- */
-#define put_unaligned(val,ptr)					\
-	({							\
-		switch (sizeof(*(ptr))) {			\
-		case 1:						\
-			*(ptr) = (val);				\
-			break;					\
-		case 2: __put_unaligned_2((val),(__u8 *)(ptr));	\
-			break;					\
-		case 4:	__put_unaligned_4((val),(__u8 *)(ptr));	\
-			break;					\
-		case 8:	__put_unaligned_8((val),(__u8 *)(ptr)); \
-			break;					\
-		default: __bug_unaligned_x(ptr);		\
-			break;					\
-		}						\
-		(void) 0;					\
-	})
+#include <linux/unaligned/generic.h>
 
+#define get_unaligned	__get_unaligned_le
+#define put_unaligned	__put_unaligned_le
 
 #endif /* __V850_UNALIGNED_H__ */
diff --git a/include/asm-x86/unaligned.h b/include/asm-x86/unaligned.h
index 913598d..7ba2e1a 100644
--- a/include/asm-x86/unaligned.h
+++ b/include/asm-x86/unaligned.h
@@ -3,35 +3,7 @@
 
 /*
  * The x86 can do unaligned accesses itself.
- *
- * The strange macros are there to make sure these can't
- * be misused in a way that makes them not work on other
- * architectures where unaligned accesses aren't as simple.
  */
-
-/**
- * get_unaligned - get value from possibly mis-aligned location
- * @ptr: pointer to value
- *
- * This macro should be used for accessing values larger in size than
- * single bytes at locations that are expected to be improperly aligned,
- * e.g. retrieving a u16 value from a location not u16-aligned.
- *
- * Note that unaligned accesses can be very expensive on some architectures.
- */
-#define get_unaligned(ptr) (*(ptr))
-
-/**
- * put_unaligned - put value to a possibly mis-aligned location
- * @val: value to place
- * @ptr: pointer to location
- *
- * This macro should be used for placing values larger in size than
- * single bytes at locations that are expected to be improperly aligned,
- * e.g. writing a u16 value to a location not u16-aligned.
- *
- * Note that unaligned accesses can be very expensive on some architectures.
- */
-#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+#include <linux/unaligned/access_ok.h>
 
 #endif /* _ASM_X86_UNALIGNED_H */
diff --git a/include/asm-xtensa/unaligned.h b/include/asm-xtensa/unaligned.h
index 2822089..45eb203 100644
--- a/include/asm-xtensa/unaligned.h
+++ b/include/asm-xtensa/unaligned.h
@@ -13,16 +13,6 @@
 #ifndef _XTENSA_UNALIGNED_H
 #define _XTENSA_UNALIGNED_H
 
-#include <linux/string.h>
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-#define get_unaligned(ptr) \
-  ({ __typeof__(*(ptr)) __tmp; memmove(&__tmp, (ptr), sizeof(*(ptr))); __tmp; })
-
-#define put_unaligned(val, ptr)				\
-  ({ __typeof__(*(ptr)) __tmp = (val);			\
-     memmove((ptr), &__tmp, sizeof(*(ptr)));		\
-     (void)0; })
+#include <linux/unaligned/no_builtin_memcpy.h>
 
 #endif	/* _XTENSA_UNALIGNED_H */
diff --git a/include/linux/unaligned/access_ok.h b/include/linux/unaligned/access_ok.h
new file mode 100644
index 0000000..e9d8ff4
--- /dev/null
+++ b/include/linux/unaligned/access_ok.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_ACCESS_OK_H_
+#define _LINUX_UNALIGNED_ACCESS_OK_H_
+
+#include <linux/kernel.h>
+#include <asm/byteorder.h>
+
+#define get_unaligned(ptr) (*(ptr))
+#define put_unaligned(val, ptr) ((void)( *(ptr) = (val) ))
+
+static inline u16 get_unaligned_le16(const __le16 *p)
+{
+	return le16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_le32(const __le32 *p)
+{
+	return le32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_le64(const __le64 *p)
+{
+	return le64_to_cpup(p);
+}
+
+static inline u16 get_unaligned_be16(const __be16 *p)
+{
+	return be16_to_cpup(p);
+}
+
+static inline u32 get_unaligned_be32(const __be32 *p)
+{
+	return be32_to_cpup(p);
+}
+
+static inline u64 get_unaligned_be64(const __be64 *p)
+{
+	return be64_to_cpup(p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	*((__le16 *)p) = cpu_to_le16(val);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	*((__le32 *)p) = cpu_to_le32(val);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	*((__le64 *)p) = cpu_to_le64(val);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	*((__be16 *)p) = cpu_to_be16(val);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	*((__be32 *)p) = cpu_to_be32(val);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	*((__be64 *)p) = cpu_to_be64(val);
+}
+
+#endif /* _LINUX_UNALIGNED_ACCESS_OK_H_ */
diff --git a/include/linux/unaligned/big_endian.h b/include/linux/unaligned/big_endian.h
new file mode 100644
index 0000000..b59fbbc
--- /dev/null
+++ b/include/linux/unaligned/big_endian.h
@@ -0,0 +1,82 @@
+#ifndef _LINUX_UNALIGNED_BIG_ENDIAN_H_
+#define _LINUX_UNALIGNED_BIG_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+static inline u16 __get_unaligned_be16(const u8 *p)
+{
+	return (u16)(p[0] << 8 | p[1]);
+}
+
+static inline u32 __get_unaligned_be32(const u8 *p)
+{
+	return (u32)(p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3]);
+}
+
+static inline u64 __get_unaligned_be64(const u8 *p)
+{
+	return ((u64)__get_unaligned_be32(p) << 32) |
+	       __get_unaligned_be32(p + 4);
+}
+
+#define __get_unaligned_be(ptr) ({					\
+	const void *__gu_p = (ptr);					\
+	u64 __val;							\
+	switch (sizeof(*(ptr)) {					\
+	case 1:								\
+		__val = *(const u8 *)__gu_p;				\
+		break;							\
+	case 2:								\
+		__val = __get_unaligned_be16((const u8 *)__gu_p);	\
+		break;							\
+	case 4:								\
+		__val = __get_unaligned_be32((const u8 *)__gu_p);	\
+		break;							\
+	case 8:								\
+		__val = __get_unaligned_be64((const u8 *)__gu_p);	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+	};								\
+	(__force __typeof__(*(ptr)))__val; })
+
+static inline void __put_unaligned_be16(u16 val, u8 *p)
+{
+	*p++ = val >> 8;
+	*p++ = val;
+}
+
+static inline void __put_unaligned_be32(u32 val, u8 *p)
+{
+	__put_unaligned_be16(val >> 16, p);
+	__put_unaligned_be16(val, p + 2);
+}
+
+static inline void __put_unaligned_be64(u64 val, u8 *p)
+{
+	__put_unaligned_be32(val >> 32, p);
+	__put_unaligned_be32(val, p + 4);
+}
+
+#define __put_unaligned_be(val, ptr) ({					\
+	(void)sizeof(*(ptr) = (val));					\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(ptr) = (val);						\
+		break;							\
+	case 2:								\
+		__put_unaligned_be16((__force u16)(val), (u8 *)(ptr));	\
+		break;							\
+	case 4:								\
+		__put_unaligned_be32((__force u32)(val), (u8 *)(ptr));	\
+		break;							\
+	case 8:								\
+		__put_unaligned_be64((__force u64)(val), (u8 *)(ptr));	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_BIG_ENDIAN_H_ */
diff --git a/include/linux/unaligned/cpu_endian.h b/include/linux/unaligned/cpu_endian.h
new file mode 100644
index 0000000..35fe430
--- /dev/null
+++ b/include/linux/unaligned/cpu_endian.h
@@ -0,0 +1,88 @@
+#ifndef _LINUX_UNALIGNED_CPU_ENDIAN_H_
+#define _LINUX_UNALIGNED_CPU_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+struct __una_u16 { u16 x __attribute__((packed)); };
+struct __una_u32 { u32 x __attribute__((packed)); };
+struct __una_u64 { u64 x __attribute__((packed)); };
+
+static inline u16 __get_unaligned_cpu16(const u8 *p)
+{
+	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
+	return ptr->x;
+}
+
+static inline u32 __get_unaligned_cpu32(const u8 *p)
+{
+	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
+	return ptr->x;
+}
+
+static inline u64 __get_unaligned_cpu64(const u8 *p)
+{
+	const struct __una_u64 *ptr = (const struct __una_u64 *)p;
+	return ptr->x;
+}
+
+#define __get_unaligned_cpu(ptr) ({					\
+	const void *__gu_p = (ptr);					\
+	u64 __val;							\
+	switch (sizeof(*(ptr)) {					\
+	case 1:								\
+		__val = *(const u8 *)__gu_p;				\
+		break;							\
+	case 2:								\
+		__val = __get_unaligned_cpu16((const u8 *)__gu_p);	\
+		break;							\
+	case 4:								\
+		__val = __get_unaligned_cpu32((const u8 *)__gu_p);	\
+		break;							\
+	case 8:								\
+		__val = __get_unaligned_cpu64((const u8 *)__gu_p);	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+	};								\
+	(__force __typeof__(*(ptr)))__val; })
+
+static inline void __put_unaligned_cpu16(u16 val, u8 *p)
+{
+	struct __una_u16 *ptr = (struct __una_u16 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu32(u32 val, u8 *p)
+{
+	struct __una_u32 *ptr = (struct __una_u32 *)p;
+	ptr->x = val;
+}
+
+static inline void __put_unaligned_cpu64(u64 val, u8 *p)
+{
+	struct __una_u64 *ptr = (struct __una_u64 *)p;
+	ptr->x = val;
+}
+
+#define __put_unaligned_cpu(val, ptr) ({				\
+	(void)sizeof(*(ptr) = (val));					\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(ptr) = (val);						\
+		break;							\
+	case 2:								\
+		__put_unaligned_cpu16((__force u16)(val), (u8 *)(ptr));	\
+		break;							\
+	case 4:								\
+		__put_unaligned_cpu32((__force u32)(val), (u8 *)(ptr));	\
+		break;							\
+	case 8:								\
+		__put_unaligned_cpu64((__force u64)(val), (u8 *)(ptr));	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_CPU_ENDIAN_H_ */
diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
new file mode 100644
index 0000000..9cd3fab
--- /dev/null
+++ b/include/linux/unaligned/generic.h
@@ -0,0 +1,67 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_H_
+#define _LINUX_UNALIGNED_GENERIC_H_
+
+#include <linux/unaligned/little_endian.h>
+#include <linux/unaligned/big_endian.h>
+
+static inline u16 get_unaligned_le16(const __le16 *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const __le32 *p)
+{
+	return __get_unaligned_le32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const __le64 *p)
+{
+	return __get_unaligned_le64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const __be16 *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const __be32 *p)
+{
+	return __get_unaligned_be32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const __be64 *p)
+{
+	return __get_unaligned_be64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_H_ */
diff --git a/include/linux/unaligned/generic_be.h b/include/linux/unaligned/generic_be.h
new file mode 100644
index 0000000..ce42487
--- /dev/null
+++ b/include/linux/unaligned/generic_be.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_BE_H_
+#define _LINUX_UNALIGNED_GENERIC_BE_H_
+
+#include <linux/unaligned/generic.h>
+#include <linux/unaligned/little_endian.h>
+
+#define get_unaligned	__get_unaligned_cpu
+#define put_unaligned	__put_unaligned_cpu
+
+static inline u16 get_unaligned_le16(const __le16 *p)
+{
+	return __get_unaligned_le16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const __le32 *p)
+{
+	return __get_unaligned_le32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const __le64 *p)
+{
+	return __get_unaligned_le64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const __be16 *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const __be32 *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const __be64 *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_le16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_le32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_le64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_BE_H_ */
diff --git a/include/linux/unaligned/generic_le.h b/include/linux/unaligned/generic_le.h
new file mode 100644
index 0000000..b57c818
--- /dev/null
+++ b/include/linux/unaligned/generic_le.h
@@ -0,0 +1,70 @@
+#ifndef _LINUX_UNALIGNED_GENERIC_LE_H_
+#define _LINUX_UNALIGNED_GENERIC_LE_H_
+
+#include <linux/unaligned/generic.h>
+#include <linux/unaligned/big_endian.h>
+
+#define get_unaligned	__get_unaligned_cpu
+#define put_unaligned	__put_unaligned_cpu
+
+static inline u16 get_unaligned_le16(const __le16 *p)
+{
+	return __get_unaligned_cpu16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_le32(const __le32 *p)
+{
+	return __get_unaligned_cpu32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_le64(const __le64 *p)
+{
+	return __get_unaligned_cpu64((const u8 *)p);
+}
+
+static inline u16 get_unaligned_be16(const __be16 *p)
+{
+	return __get_unaligned_be16((const u8 *)p);
+}
+
+static inline u32 get_unaligned_be32(const __be32 *p)
+{
+	return __get_unaligned_be32((const u8 *)p);
+}
+
+static inline u64 get_unaligned_be64(const __be64 *p)
+{
+	return __get_unaligned_be64((const u8 *)p);
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	__put_unaligned_cpu16(val, p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	__put_unaligned_cpu32(val, p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	__put_unaligned_cpu64(val, p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	__put_unaligned_be16(val, p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	__put_unaligned_be32(val, p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	__put_unaligned_be64(val, p);
+}
+
+#endif /* _LINUX_UNALIGNED_GENERIC_LE_H_ */
diff --git a/include/linux/unaligned/little_endian.h b/include/linux/unaligned/little_endian.h
new file mode 100644
index 0000000..43f46c3
--- /dev/null
+++ b/include/linux/unaligned/little_endian.h
@@ -0,0 +1,82 @@
+#ifndef _LINUX_UNALIGNED_LITTLE_ENDIAN_H_
+#define _LINUX_UNALIGNED_LITTLE_ENDIAN_H_
+
+#include <linux/kernel.h>
+
+static inline u16 __get_unaligned_le16(const u8 *p)
+{
+	return (u16)(p[0] | p[1] << 8);
+}
+
+static inline u32 __get_unaligned_le32(const u8 *p)
+{
+	return (u32)(p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24);
+}
+
+static inline u64 __get_unaligned_le64(const u8 *p)
+{
+	return ((u64)__get_unaligned_le32(p + 4) << 32) |
+	       __get_unaligned_le32(p);
+}
+
+#define __get_unaligned_le(ptr) ({					\
+	const void *__gu_p = (ptr);					\
+	u64 __val;							\
+	switch (sizeof(*(ptr)) {					\
+	case 1:								\
+		__val = *(const u8 *)__gu_p;				\
+		break;							\
+	case 2:								\
+		__val = __get_unaligned_le16((const u8 *)__gu_p);	\
+		break;							\
+	case 4:								\
+		__val = __get_unaligned_le32((const u8 *)__gu_p);	\
+		break;							\
+	case 8:								\
+		__val = __get_unaligned_le64((const u8 *)__gu_p);	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+	};								\
+	(__force __typeof__(*(ptr)))__val; })
+
+static inline void __put_unaligned_le16(u16 val, u8 *p)
+{
+	*p++ = val;
+	*p++ = val >> 8;
+}
+
+static inline void __put_unaligned_le32(u32 val, u8 *p)
+{
+	__put_unaligned_le16(val >> 16, p + 2);
+	__put_unaligned_le16(val, p);
+}
+
+static inline void __put_unaligned_le64(u64 val, u8 *p)
+{
+	__put_unaligned_le32(val >> 32, p + 4);
+	__put_unaligned_le32(val, p);
+}
+
+#define __put_unaligned_le(val, ptr) ({					\
+	(void)sizeof(*(ptr) = (val));					\
+	switch (sizeof(*(ptr))) {					\
+	case 1:								\
+		*(ptr) = (val);						\
+		break;							\
+	case 2:								\
+		__put_unaligned_le16((__force u16)(val), (u8 *)(ptr));	\
+		break;							\
+	case 4:								\
+		__put_unaligned_le32((__force u32)(val), (u8 *)(ptr));	\
+		break;							\
+	case 8:								\
+		__put_unaligned_le64((__force u64)(val), (u8 *)(ptr));	\
+		break;							\
+	default:							\
+		BUILD_BUG_ON(1);					\
+		break;							\
+	}								\
+	(void)0; })
+
+#endif /* _LINUX_UNALIGNED_LITTLE_ENDIAN_H_ */
diff --git a/include/linux/unaligned/no_builtin_memcpy.h b/include/linux/unaligned/no_builtin_memcpy.h
new file mode 100644
index 0000000..17a6e21
--- /dev/null
+++ b/include/linux/unaligned/no_builtin_memcpy.h
@@ -0,0 +1,79 @@
+#ifndef _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
+#define _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
+
+#include <asm/byteorder.h>
+#include <asm/string.h>
+
+/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
+
+#define get_unaligned(ptr) ({				\
+	__typeof__(*(ptr)) __tmp;			\
+	memmove(&__tmp, (ptr), sizeof(*(ptr)));		\
+	__tmp; })
+
+#define put_unaligned(val, ptr) ({			\
+	__typeof__(*(ptr)) __tmp = (val);		\
+	memmove((ptr), &__tmp, sizeof(*(ptr)));		\
+	(void)0; })
+
+static inline u16 get_unaligned_le16(const __le16 *p)
+{
+	return le16_to_cpu(get_unaligned(p));
+}
+
+static inline u32 get_unaligned_le32(const __le32 *p)
+{
+	return le32_to_cpu(get_unaligned(p));
+}
+
+static inline u64 get_unaligned_le64(const __le64 *p)
+{
+	return le64_to_cpu(get_unaligned(p));
+}
+
+static inline u16 get_unaligned_be16(const __be16 *p)
+{
+	return be16_to_cpu(get_unaligned(p));
+}
+
+static inline u32 get_unaligned_be32(const __be32 *p)
+{
+	return be32_to_cpu(get_unaligned(p));
+}
+
+static inline u64 get_unaligned_be64(const __be64 *p)
+{
+	return be64_to_cpu(get_unaligned(p));
+}
+
+static inline void put_unaligned_le16(u16 val, void *p)
+{
+	return put_unaligned(cpu_to_le16(val), (__le16 *)p);
+}
+
+static inline void put_unaligned_le32(u32 val, void *p)
+{
+	return put_unaligned(cpu_to_le32(val), (__le32 *)p);
+}
+
+static inline void put_unaligned_le64(u64 val, void *p)
+{
+	return put_unaligned(cpu_to_le64(val), (__le64 *)p);
+}
+
+static inline void put_unaligned_be16(u16 val, void *p)
+{
+	return put_unaligned(cpu_to_be16(val), (__be16 *)p);
+}
+
+static inline void put_unaligned_be32(u32 val, void *p)
+{
+	return put_unaligned(cpu_to_be32(val), (__be32 *)p);
+}
+
+static inline void put_unaligned_be64(u64 val, void *p)
+{
+	return put_unaligned(cpu_to_be64(val), (__be64 *)p);
+}
+
+#endif
-- 
1.5.5.144.g3e42



