Return-Path: <linux-kernel-owner+w=401wt.eu-S1764631AbXJTLvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764631AbXJTLvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbXJTLvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXJTLvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:51:36 -0400
Date: Sat, 20 Oct 2007 07:51:29 -0400
From: Chris Snook <csnook@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: unify div64{,_32,_64}.h
Message-ID: <20071020115129.GA11073@shell.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <csnook@redhat.com>

Unify x86 div64.h headers.

Signed-off-by: Chris Snook <csnook@redhat.com>

diff -Nurp a/include/asm-x86/div64_32.h b/include/asm-x86/div64_32.h
--- a/include/asm-x86/div64_32.h	2007-10-20 07:33:53.000000000 -0400
+++ b/include/asm-x86/div64_32.h	1969-12-31 19:00:00.000000000 -0500
@@ -1,52 +0,0 @@
-#ifndef __I386_DIV64
-#define __I386_DIV64
-
-#include <linux/types.h>
-
-/*
- * do_div() is NOT a C function. It wants to return
- * two values (the quotient and the remainder), but
- * since that doesn't work very well in C, what it
- * does is:
- *
- * - modifies the 64-bit dividend _in_place_
- * - returns the 32-bit remainder
- *
- * This ends up being the most efficient "calling
- * convention" on x86.
- */
-#define do_div(n,base) ({ \
-	unsigned long __upper, __low, __high, __mod, __base; \
-	__base = (base); \
-	asm("":"=a" (__low), "=d" (__high):"A" (n)); \
-	__upper = __high; \
-	if (__high) { \
-		__upper = __high % (__base); \
-		__high = __high / (__base); \
-	} \
-	asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (__base), "0" (__low), "1" (__upper)); \
-	asm("":"=A" (n):"a" (__low),"d" (__high)); \
-	__mod; \
-})
-
-/*
- * (long)X = ((long long)divs) / (long)div
- * (long)rem = ((long long)divs) % (long)div
- *
- * Warning, this will do an exception if X overflows.
- */
-#define div_long_long_rem(a,b,c) div_ll_X_l_rem(a,b,c)
-
-static inline long
-div_ll_X_l_rem(long long divs, long div, long *rem)
-{
-	long dum2;
-      __asm__("divl %2":"=a"(dum2), "=d"(*rem)
-      :	"rm"(div), "A"(divs));
-
-	return dum2;
-
-}
-
-extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
-#endif
diff -Nurp a/include/asm-x86/div64_64.h b/include/asm-x86/div64_64.h
--- a/include/asm-x86/div64_64.h	2007-10-20 07:33:53.000000000 -0400
+++ b/include/asm-x86/div64_64.h	1969-12-31 19:00:00.000000000 -0500
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff -Nurp a/include/asm-x86/div64.h b/include/asm-x86/div64.h
--- a/include/asm-x86/div64.h	2007-10-20 07:33:53.000000000 -0400
+++ b/include/asm-x86/div64.h	2007-10-20 07:32:34.000000000 -0400
@@ -1,5 +1,58 @@
+#ifndef _ASM_X86_DIV64_H
+#define _ASM_X86_DIV64_H
+
 #ifdef CONFIG_X86_32
-# include "div64_32.h"
-#else
-# include "div64_64.h"
-#endif
+
+#include <linux/types.h>
+
+/*
+ * do_div() is NOT a C function. It wants to return
+ * two values (the quotient and the remainder), but
+ * since that doesn't work very well in C, what it
+ * does is:
+ *
+ * - modifies the 64-bit dividend _in_place_
+ * - returns the 32-bit remainder
+ *
+ * This ends up being the most efficient "calling
+ * convention" on x86.
+ */
+#define do_div(n,base) ({ \
+	unsigned long __upper, __low, __high, __mod, __base; \
+	__base = (base); \
+	asm("":"=a" (__low), "=d" (__high):"A" (n)); \
+	__upper = __high; \
+	if (__high) { \
+		__upper = __high % (__base); \
+		__high = __high / (__base); \
+	} \
+	asm("divl %2":"=a" (__low), "=d" (__mod):"rm" (__base), "0" (__low), "1" (__upper)); \
+	asm("":"=A" (n):"a" (__low),"d" (__high)); \
+	__mod; \
+})
+
+/*
+ * (long)X = ((long long)divs) / (long)div
+ * (long)rem = ((long long)divs) % (long)div
+ *
+ * Warning, this will do an exception if X overflows.
+ */
+#define div_long_long_rem(a,b,c) div_ll_X_l_rem(a,b,c)
+
+static inline long
+div_ll_X_l_rem(long long divs, long div, long *rem)
+{
+	long dum2;
+      __asm__("divl %2":"=a"(dum2), "=d"(*rem)
+      :	"rm"(div), "A"(divs));
+
+	return dum2;
+
+}
+
+extern uint64_t div64_64(uint64_t dividend, uint64_t divisor);
+
+# else
+#  include <asm-generic/div64.h>
+# endif /* CONFIG_X86_32 */
+#endif /* _ASM_X86_DIV64_H */
