Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXBNVmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXBNVmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbXBNVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:42:31 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:56154 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbXBNVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:42:30 -0500
Date: Wed, 14 Feb 2007 21:42:26 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Optimize generic get_unaligned / put_unaligned implementations.
Message-ID: <20070214214226.GA17899@linux-mips.org>
References: <20050830104056.GA4710@linux-mips.org> <20060306.203218.69025300.nemoto@toshiba-tops.co.jp> <20060306170552.0aab29c5.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20060306170552.0aab29c5.akpm@osdl.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Time for a little bit of dead horse flogging.

On Mon, Mar 06, 2006 at 05:05:52PM -0800, Andrew Morton wrote:

> > --- a/include/asm-generic/unaligned.h
> > +++ b/include/asm-generic/unaligned.h
> > @@ -78,7 +78,7 @@ static inline void __ustw(__u16 val, __u
> >  
> >  #define __get_unaligned(ptr, size) ({		\
> >  	const void *__gu_p = ptr;		\
> > -	__typeof__(*(ptr)) val;			\
> > +	__u64 val;				\
> >  	switch (size) {				\
> >  	case 1:					\
> >  		val = *(const __u8 *)__gu_p;	\
> > @@ -95,7 +95,7 @@ static inline void __ustw(__u16 val, __u
> >  	default:				\
> >  		bad_unaligned_access_length();	\
> >  	};					\
> > -	val;					\
> > +	(__typeof__(*(ptr)))val;		\
> >  })
> >  
> >  #define __put_unaligned(val, ptr, size)		\
> 
> I worry about what impact that change might have on code generation. 
> Hopefully none, if gcc is good enough.
> 
> But I cannot think of a better fix.

It does inflate the code but back then we agreed to go for Atsushi's patch
because it was fairly obviously correct.  This patch obviously is less
obvious but generates fairly decent, works for arbitrary data types and
cuts down the size of unaligned.h from 122 lines to 44 so it must be good.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/asm-generic/unaligned.h b/include/asm-generic/unaligned.h
index 09ec447..d7fda33 100644
--- a/include/asm-generic/unaligned.h
+++ b/include/asm-generic/unaligned.h
@@ -1,122 +1,44 @@
-#ifndef _ASM_GENERIC_UNALIGNED_H_
-#define _ASM_GENERIC_UNALIGNED_H_
-
 /*
- * For the benefit of those who are trying to port Linux to another
- * architecture, here are some C-language equivalents. 
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
  *
- * This is based almost entirely upon Richard Henderson's
- * asm-alpha/unaligned.h implementation.  Some comments were
- * taken from David Mosberger's asm-ia64/unaligned.h header.
+ * Copyright (C) 2006 MIPS Technologies, Inc.
+ *   written by Ralf Baechle <ralf@linux-mips.org>
  */
+#ifndef __ASM_GENERIC_UNALIGNED_H
+#define __ASM_GENERIC_UNALIGNED_H
 
 #include <linux/types.h>
 
-/* 
- * The main single-value unaligned transfer routines.
- */
-#define get_unaligned(ptr) \
-	__get_unaligned((ptr), sizeof(*(ptr)))
-#define put_unaligned(x,ptr) \
-	__put_unaligned((__u64)(x), (ptr), sizeof(*(ptr)))
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
 /*
- * Elemental unaligned stores 
+ * The unused member __un_foo is there to suppress "warning: ´packed´
+ * attribute ignored for field of type ´union <anonymous>´" messages if
+ * ptr is char *.
  */
 
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
-	__u64 val;				\
-	switch (size) {				\
-	case 1:					\
-		val = *(const __u8 *)__gu_p;	\
-		break;				\
-	case 2:					\
-		val = __uldw(__gu_p);		\
-		break;				\
-	case 4:					\
-		val = __uldl(__gu_p);		\
-		break;				\
-	case 8:					\
-		val = __uldq(__gu_p);		\
-		break;				\
-	default:				\
-		bad_unaligned_access_length();	\
-	};					\
-	(__typeof__(*(ptr)))val;		\
+#define get_unaligned(ptr)						\
+({									\
+	const struct {							\
+		union {							\
+			const int __un_foo[0];				\
+			const __typeof__(*(ptr)) __un;			\
+		} __un __attribute__ ((packed));			\
+	} * const __gu_p = (void *) (ptr);				\
+									\
+	__gu_p->__un.__un;						\
 })
 
-#define __put_unaligned(val, ptr, size)		\
-do {						\
-	void *__gu_p = ptr;			\
-	switch (size) {				\
-	case 1:					\
-		*(__u8 *)__gu_p = val;		\
-	        break;				\
-	case 2:					\
-		__ustw(val, __gu_p);		\
-		break;				\
-	case 4:					\
-		__ustl(val, __gu_p);		\
-		break;				\
-	case 8:					\
-		__ustq(val, __gu_p);		\
-		break;				\
-	default:				\
-	    	bad_unaligned_access_length();	\
-	};					\
+#define put_unaligned(val, ptr)						\
+do {									\
+	struct {							\
+		union {							\
+			const int __un_foo[0];				\
+			__typeof__(*(ptr)) __un;			\
+		} __un __attribute__ ((packed));			\
+	} * const __gu_p = (void *) (ptr);				\
+									\
+	__gu_p->__un.__un = (val);					\
 } while(0)
 
-#endif /* _ASM_GENERIC_UNALIGNED_H */
+#endif /* __ASM_GENERIC_UNALIGNED_H */
