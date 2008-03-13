Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYCMBC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYCMBC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYCMBBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53898 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313004902.808083566@linux-m68k.org>
References: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:36 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/4] introduce explicit signed/unsigned 64bit divide
Content-Disposition: inline; filename=div64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current do_div doesn't explicitly say that it's unsigned and the
signed counterpart is missing, which is e.g. needed when dealing with
time values.
This introduces 64bit signed/unsigned divide functions which also
attempts to cleanup the somewhat awkward calling API, which often
requires the use of temporary variables for the dividend. To avoid the
need for temporary variables everywhere for the remainder, each divide
variant also provides a version which doesn't return the remainder.

Each architecture can now provide optimized versions of these function,
otherwise generic fallback implementations will be used.

As an example I provided an alternative for the current x86 divide,
which avoids the asm casts and using an union allows gcc to generate
better code. It also avoids the upper divde in a few more cases, where
the result is known (i.e. upper quotient is zero).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/asm-x86/div64.h |   20 +++++++++++++
 include/linux/math64.h  |   72 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/div64.c             |   23 ++++++++++++++-
 3 files changed, 113 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-x86/div64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/div64.h	2008-03-11 17:15:21.000000000 +0100
+++ linux-2.6/include/asm-x86/div64.h	2008-03-12 21:21:26.000000000 +0100
@@ -50,6 +50,26 @@ div_ll_X_l_rem(long long divs, long div,
 
 }
 
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	union {
+		u64 v64;
+		u32 v32[2];
+	} d = { dividend };
+	u32 upper;
+
+	upper = d.v32[1];
+	d.v32[1] = 0;
+	if (upper >= divisor) {
+		d.v32[1] = upper / divisor;
+		upper %= divisor;
+	}
+	asm ("divl %2" : "=a" (d.v32[0]), "=d" (*remainder) :
+		"rm" (divisor), "0" (d.v32[0]), "1" (upper));
+	return d.v64;
+}
+#define div_u64_rem	div_u64_rem
+
 extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
 
 #else
Index: linux-2.6/lib/div64.c
===================================================================
--- linux-2.6.orig/lib/div64.c	2008-03-11 17:15:21.000000000 +0100
+++ linux-2.6/lib/div64.c	2008-03-12 21:21:26.000000000 +0100
@@ -16,9 +16,8 @@
  * assembly versions such as arch/ppc/lib/div64.S and arch/sh/lib/div64.S.
  */
 
-#include <linux/types.h>
 #include <linux/module.h>
-#include <asm/div64.h>
+#include <linux/math64.h>
 
 /* Not needed on 64bit architectures */
 #if BITS_PER_LONG == 32
@@ -58,6 +57,26 @@ uint32_t __attribute__((weak)) __div64_3
 
 EXPORT_SYMBOL(__div64_32);
 
+#ifndef div_s64_rem
+s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
+{
+	u64 quotient;
+
+	if (dividend < 0) {
+		quotient = div_u64_rem(-dividend, abs(divisor), (u32 *)remainder);
+		*remainder = -*remainder;
+		if (divisor > 0)
+			quotient = -quotient;
+	} else {
+		quotient = div_u64_rem(dividend, abs(divisor), (u32 *)remainder);
+		if (divisor < 0)
+			quotient = -quotient;
+	}
+	return quotient;
+}
+EXPORT_SYMBOL(div_s64_rem);
+#endif
+
 /* 64bit divisor, dividend and result. dynamic precision */
 uint64_t div64_64(uint64_t dividend, uint64_t divisor)
 {
Index: linux-2.6/include/linux/math64.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/linux/math64.h	2008-03-12 21:21:26.000000000 +0100
@@ -0,0 +1,72 @@
+#ifndef _LINUX_MATH64_H
+#define _LINUX_MATH64_H
+
+#include <linux/types.h>
+#include <asm/div64.h>
+
+#if BITS_PER_LONG == 64
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
+ * div_s64_rem - signed 64bit divide with 32bit divisor with remainder
+ */
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+#elif BITS_PER_LONG == 32
+
+#ifndef div_u64_rem
+static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
+{
+	*remainder = do_div(dividend, divisor);
+	return dividend;
+}
+#endif
+
+#ifndef div_s64_rem
+extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
+#endif
+
+#endif /* BITS_PER_LONG */
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+#ifndef div_u64
+static inline u64 div_u64(u64 dividend, u32 divisor)
+{
+	u32 remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+#endif
+
+/**
+ * div_s64 - signed 64bit divide with 32bit divisor
+ */
+#ifndef div_u64
+static inline s64 div_s64(s64 dividend, s32 divisor)
+{
+	s32 remainder;
+	return div_s64_rem(dividend, divisor, &remainder);
+}
+#endif
+
+#endif /* _LINUX_MATH64_H */

-- 

