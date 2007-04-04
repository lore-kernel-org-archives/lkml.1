Return-Path: <linux-kernel-owner+w=401wt.eu-S966176AbXDDC3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966176AbXDDC3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966187AbXDDC3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:29:22 -0400
Received: from ozlabs.org ([203.10.76.45]:56576 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966176AbXDDC3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:29:21 -0400
Subject: [PATCH] Expose range-checking functions from arch-specific
	uaccess.h
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 12:28:38 +1000
Message-Id: <1175653718.12230.566.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest wants range checking, but unless there are other users I'm not
sure this is worth the pain.  Putting it out there in case it's useful.

Cheers,
Rusty.
==
There are some places where we want to check if a value + length is
within a range.  This can be tricky, so it's nice to have a single
routine.

Also, this can be done more efficiently (with arch-dependent) carry
bits, as shown by the __range_ok() implementation on several archs.

This patch exposes arch-specific "val_outside(val, len, limit)" and a
generic "range_within(start, len, base, limit)" function.  As a
side-effect, it fixes the comment in i386/uaccess.h: __range_ok
doesn't test "(u33)addr + (u33)size >= (u33)current->addr_limit.seg",
it tests "(u33)addr + (u33)size > (u33)current->addr_limit.seg".

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 4272a6d4f27c include/asm-generic/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-generic/range.h	Wed Apr 04 12:18:15 2007 +1000
@@ -0,0 +1,20 @@
+#ifndef _ASM_GENERIC_RANGE_H
+#define _ASM_GENERIC_RANGE_H
+
+/**
+ * val_outside - is a value and length past a limit?
+ * @val: the start value
+ * @len: the length from the start
+ * @limit: the first invalid value
+ *
+ * Like val + len > limit, except with overflow checking.
+ */
+static inline bool val_outside(unsigned long val, unsigned long len,
+			       unsigned long limit)
+			       
+{
+	return val + len > limit || val + len < val;
+}
+
+#endif	/* _ASM_GENERIC_RANGE_H */
+
diff -r 4272a6d4f27c include/asm-i386/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-i386/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,14 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+/* Is val + size > limit? This needs 33-bit arithmetic. We have a carry... */
+static inline bool val_outside(unsigned long val, unsigned long len,
+			       unsigned long limit)
+{
+	unsigned long flag, roksum;
+	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0"
+		:"=&r" (flag), "=r" (roksum)
+		:"1" (val), "g" (len), "rm" (limit));
+	return flag;
+}
+#endif	/* __ASM_RANGE_H */
diff -r 4272a6d4f27c include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h	Wed Apr 04 12:05:49 2007 +1000
+++ b/include/asm-i386/uaccess.h	Wed Apr 04 12:14:45 2007 +1000
@@ -49,17 +49,12 @@ extern struct movsl_mask {
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg
- *
- * This needs 33-bit arithmetic. We have a carry...
- */
-#define __range_ok(addr,size) ({ \
-	unsigned long flag,roksum; \
-	__chk_user_ptr(addr); \
-	asm("addl %3,%1 ; sbbl %0,%0; cmpl %1,%4; sbbl $0,%0" \
-		:"=&r" (flag), "=r" (roksum) \
-		:"1" (addr),"g" ((int)(size)),"rm" (current_thread_info()->addr_limit.seg)); \
-	flag; })
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg
+ */
+#define __range_ok(addr,size) ({					      \
+	__chk_user_ptr(addr);						      \
+	val_outside((int)(addr),(size),current_thread_info()->addr_limit.seg); \
+})
 
 /**
  * access_ok: - Checks if a user space pointer is valid
diff -r 4272a6d4f27c include/linux/kernel.h
--- a/include/linux/kernel.h	Wed Apr 04 12:05:49 2007 +1000
+++ b/include/linux/kernel.h	Wed Apr 04 12:22:52 2007 +1000
@@ -16,6 +16,7 @@
 #include <linux/log2.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
+#include <asm/range.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -311,6 +312,26 @@ static inline int __attribute__ ((format
 	(void)__tmp; \
 })
 
+/**
+ * range_within - is one range within another?
+ * @start: the start value
+ * @len: the length from the start
+ * @base: the first valid value
+ * @limit: the first invalid value
+ *
+ * This is usually used for memory range testing.  The common cases of
+ * constant 0 start and constant 0 len cases are optimized out.
+ */
+static inline bool range_within(unsigned long start, unsigned long len,
+				unsigned long base, unsigned long limit)
+{
+	if (start < base)
+		return false;
+	if (__builtin_constant_p(len) && len == 0)
+		return start - base <= limit - base;
+	return !val_outside(limit, start, len);
+}
+
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
diff -r 4272a6d4f27c include/asm-alpha/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-alpha/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-arm/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-arm/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-arm26/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-arm26/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-avr32/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-avr32/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-blackfin/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-blackfin/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-cris/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-cris/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-frv/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-frv/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-h8300/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-h8300/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-ia64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-ia64/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-m32r/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m32r/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-m68k/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m68k/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-m68knommu/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m68knommu/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-mips/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-mips/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-parisc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-parisc/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-powerpc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-powerpc/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-ppc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-ppc/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-s390/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-s390/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-sh/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sh/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-sh64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sh64/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-sparc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sparc/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-sparc64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sparc64/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-um/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-um/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-v850/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-v850/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-x86_64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-x86_64/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */
diff -r 4272a6d4f27c include/asm-xtensa/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-xtensa/range.h	Wed Apr 04 12:14:45 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ALPHA_RANGE_H
+#define __ALPHA_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ALPHA_RANGE_H */


