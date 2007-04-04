Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbXDDGls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbXDDGls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbXDDGlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:41:47 -0400
Received: from ozlabs.org ([203.10.76.45]:50280 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbXDDGlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:41:46 -0400
Subject: Re: [PATCH] Expose range-checking functions from arch-specific
	uaccess.h
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070403202240.f212954b.randy.dunlap@oracle.com>
References: <1175653718.12230.566.camel@localhost.localdomain>
	 <20070403202240.f212954b.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 16:41:00 +1000
Message-Id: <1175668860.12230.580.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 20:22 -0700, Randy Dunlap wrote:
> > +/**
> > + * val_outside - is a value and length past a limit?
> > + * @val: the start value
> > + * @len: the length from the start
> > + * @limit: the first invalid value
> > + *
> > + * Like val + len > limit, except with overflow checking.
> > + */
> > +static inline bool val_outside(unsigned long val, unsigned long len,
> > +			       unsigned long limit)
> > +			       
> > +{
> > +	return val + len > limit || val + len < val;
> 
> why isn't that
> 	return val + len >= limit || val + len < val;

Hi Randy!

	Good question!  Mainly because that's what the existing __range_ok()
function does: limit is the first *invalid* value, not the last valid
value.

	Say your limit is 0xC000 0000.  You want to be able to write 1 byte to
0xBFFF FFFF.  So it's only outside if val + len > limit.

> > +#define __range_ok(addr,size) ({					      \
> > +	__chk_user_ptr(addr);						      \
> > +	val_outside((int)(addr),(size),current_thread_info()->addr_limit.seg); \
> 
> space after commas, please.

Yeah, I copied the existing code (but gladly: spaces pushes us onto
another line).  Fixed.
 
> > + * This is usually used for memory range testing.  The common cases of
> > + * constant 0 start and constant 0 len cases are optimized out.
> > + */
> 
> Where is constant 0 start optimized out?

The start < base is optimized out if base is known to be 0 (they're both
unsigned): gcc realizes that can never be true so kills that whole
branch.

> > +static inline bool range_within(unsigned long start, unsigned long len,
> > +				unsigned long base, unsigned long limit)
> > +{
> > +	if (start < base)
> > +		return false;
> > +	if (__builtin_constant_p(len) && len == 0)
> 
> I don't see what the builtin_constant_p() adds here.
> If len == 0, this return <expression> is still OK, isn't it?

We don't really want a branch in this code: __builtin_constant_p()
ensures we end up only with "start - base <= limit - base" or "!
val_outside(limit, start, len)" in the binary.

> > diff -r 4272a6d4f27c include/asm-arm/range.h
> > --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
> > +++ b/include/asm-arm/range.h	Wed Apr 04 12:14:45 2007 +1000
> > @@ -0,0 +1,6 @@
> > +#ifndef __ALPHA_RANGE_H
> > +#define __ALPHA_RANGE_H
> 
> why ALPHA ?

Oops.  Because I coded this with a "for d in include/asm-*...".

Fixed.

Thanks!
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

diff -r 4815a24d0254 include/linux/kernel.h
--- a/include/linux/kernel.h	Wed Apr 04 16:35:57 2007 +1000
+++ b/include/linux/kernel.h	Wed Apr 04 16:36:00 2007 +1000
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
 
diff -r 4815a24d0254 include/asm-i386/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-i386/range.h	Wed Apr 04 16:36:00 2007 +1000
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
diff -r 4815a24d0254 include/asm-i386/uaccess.h
--- a/include/asm-i386/uaccess.h	Wed Apr 04 16:35:57 2007 +1000
+++ b/include/asm-i386/uaccess.h	Wed Apr 04 16:36:34 2007 +1000
@@ -49,17 +49,13 @@ extern struct movsl_mask {
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
+#define __range_ok(addr, size) ({				\
+	__chk_user_ptr(addr);					\
+	val_outside((int)(addr), (size),			\
+		    current_thread_info()->addr_limit.seg);	\
+})
 
 /**
  * access_ok: - Checks if a user space pointer is valid
diff -r 4815a24d0254 include/asm-generic/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-generic/range.h	Wed Apr 04 16:36:00 2007 +1000
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
diff -r 4815a24d0254 include/asm-alpha/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-alpha/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-arm/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-arm/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-arm26/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-arm26/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-avr32/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-avr32/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-blackfin/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-blackfin/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-cris/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-cris/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-frv/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-frv/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-h8300/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-h8300/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-ia64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-ia64/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-m32r/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m32r/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-m68k/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m68k/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-m68knommu/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-m68knommu/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-mips/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-mips/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-parisc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-parisc/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-powerpc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-powerpc/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-ppc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-ppc/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-s390/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-s390/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-sh/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sh/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-sh64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sh64/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-sparc/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sparc/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-sparc64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-sparc64/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-um/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-um/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-v850/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-v850/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-x86_64/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-x86_64/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */
diff -r 4815a24d0254 include/asm-xtensa/range.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/asm-xtensa/range.h	Wed Apr 04 16:36:00 2007 +1000
@@ -0,0 +1,6 @@
+#ifndef __ASM_RANGE_H
+#define __ASM_RANGE_H
+
+#include <asm-generic/range.h>
+
+#endif /* __ASM_RANGE_H */


