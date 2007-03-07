Return-Path: <linux-kernel-owner+w=401wt.eu-S1422901AbXCGRRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422901AbXCGRRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422894AbXCGRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:17:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422885AbXCGRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:33 -0500
Message-Id: <20070307171554.426475884@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [patch 078/101] Revert "LOG2: Alter get_order() so that it can make use of ilog2() on a constant"
Content-Disposition: inline; filename=revert-log2-alter-get_order-so-that-it-can-make-use-of-ilog2-on-a-constant.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Revert "[PATCH] LOG2: Alter get_order() so that it can make use of ilog2() on a constant"

This reverts commit 39d61db0edb34d60b83c5e0d62d0e906578cc707.

The commit was buggy in multiple ways:
 - the conversion to ilog2() was incorrect to begin with
 - it tested the wrong #defines, so on all architectures but FRV you'd
   never see the bug except for constant arguments.
 - the new "get_order()" macro used its arguments multiple times, and
   didn't even parenthesize them properly
 - despite the comments, it was not true that you could use it for
   constant initializers, since not all architectures even use the
   generic page.h header file.

All of the problems are individually fixable, but it all boils down to:
better just revert it, and re-do it from scratch.

Cc: David Howells <dhowells@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@osdl.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-generic/page.h |   38 ++++----------------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

--- linux-2.6.20.1.orig/include/asm-generic/page.h
+++ linux-2.6.20.1/include/asm-generic/page.h
@@ -4,51 +4,21 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#include <linux/log2.h>
+#include <linux/compiler.h>
 
-/*
- * non-const pure 2^n version of get_order
- * - the arch may override these in asm/bitops.h if they can be implemented
- *   more efficiently than using the arch log2 routines
- * - we use the non-const log2() instead if the arch has defined one suitable
- */
-#ifndef ARCH_HAS_GET_ORDER
-static inline __attribute__((const))
-int __get_order(unsigned long size, int page_shift)
+/* Pure 2^n version of get_order */
+static __inline__ __attribute_const__ int get_order(unsigned long size)
 {
-#if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
-	int order = __ilog2_u32(size) - page_shift;
-	return order >= 0 ? order : 0;
-#elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
-	int order = __ilog2_u64(size) - page_shift;
-	return order >= 0 ? order : 0;
-#else
 	int order;
 
-	size = (size - 1) >> (page_shift - 1);
+	size = (size - 1) >> (PAGE_SHIFT - 1);
 	order = -1;
 	do {
 		size >>= 1;
 		order++;
 	} while (size);
 	return order;
-#endif
 }
-#endif
-
-/**
- * get_order - calculate log2(pages) to hold a block of the specified size
- * @n - size
- *
- * calculate allocation order based on the current page size
- * - this can be used to initialise global variables from constant data
- */
-#define get_order(n)							\
-(									\
-	__builtin_constant_p(n) ?					\
-	((n < (1UL << PAGE_SHIFT)) ? 0 : ilog2(n) - PAGE_SHIFT) :	\
-	__get_order(n, PAGE_SHIFT)					\
- )
 
 #endif	/* __ASSEMBLY__ */
 #endif	/* __KERNEL__ */

--
