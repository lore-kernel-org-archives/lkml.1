Return-Path: <linux-kernel-owner+w=401wt.eu-S1030919AbXAZQ5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030919AbXAZQ5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030879AbXAZQ5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:57:02 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25746 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030786AbXAZQ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:56:25 -0500
Date: Fri, 26 Jan 2007 17:56:16 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [S390] Calibrate delay and bogomips.
Message-ID: <20070126165616.GB11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[S390] Calibrate delay and bogomips.

Preset the bogomips number to the cpu capacity value reported by
store system information in SYSIB 1.2.2. This value is constant
for a particular machine model and can be used to determine
relative performance differences between machines.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig             |    4 --
 arch/s390/lib/Makefile        |    2 -
 arch/s390/lib/qrnnd.S         |   77 ++++++++++++++++++++++++++++++++++++++++++
 arch/s390/math-emu/Makefile   |    2 -
 arch/s390/math-emu/math.c     |    2 -
 arch/s390/math-emu/qrnnd.S    |   77 ------------------------------------------
 arch/s390/math-emu/sfp-util.h |   66 ------------------------------------
 drivers/s390/Makefile         |    2 +
 drivers/s390/sysinfo.c        |   51 +++++++++++++++++++++++++++
 include/asm-s390/sfp-util.h   |   66 ++++++++++++++++++++++++++++++++++++
 10 files changed, 198 insertions(+), 151 deletions(-)

diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2007-01-26 17:29:31.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2007-01-26 17:29:37.000000000 +0100
@@ -34,10 +34,6 @@ config GENERIC_HWEIGHT
 	bool
 	default y
 
-config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
-
 config GENERIC_TIME
 	def_bool y
 
diff -urpN linux-2.6/arch/s390/lib/Makefile linux-2.6-patched/arch/s390/lib/Makefile
--- linux-2.6/arch/s390/lib/Makefile	2007-01-26 17:27:27.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/Makefile	2007-01-26 17:29:37.000000000 +0100
@@ -4,7 +4,7 @@
 
 EXTRA_AFLAGS := -traditional
 
-lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
+lib-y += delay.o string.o uaccess_std.o uaccess_pt.o qrnnd.o
 lib-$(CONFIG_32BIT) += div64.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
diff -urpN linux-2.6/arch/s390/lib/qrnnd.S linux-2.6-patched/arch/s390/lib/qrnnd.S
--- linux-2.6/arch/s390/lib/qrnnd.S	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/arch/s390/lib/qrnnd.S	2007-01-26 17:29:37.000000000 +0100
@@ -0,0 +1,77 @@
+# S/390 __udiv_qrnnd
+
+# r2 : &__r
+# r3 : upper half of 64 bit word n
+# r4 : lower half of 64 bit word n
+# r5 : divisor d
+# the reminder r of the division is to be stored to &__r and
+# the quotient q is to be returned
+
+	.text
+	.globl __udiv_qrnnd
+__udiv_qrnnd:
+	st    %r2,24(%r15)	  # store pointer to reminder for later
+	lr    %r0,%r3		  # reload n
+	lr    %r1,%r4
+	ltr   %r2,%r5		  # reload and test divisor
+	jp    5f
+	# divisor >= 0x80000000
+	srdl  %r0,2		  # n/4
+	srl   %r2,1		  # d/2
+	slr   %r1,%r2		  # special case if last bit of d is set
+	brc   3,0f		  #  (n/4) div (n/2) can overflow by 1
+	ahi   %r0,-1		  #  trick: subtract n/2, then divide
+0:	dr    %r0,%r2		  # signed division
+	ahi   %r1,1		  #  trick part 2: add 1 to the quotient
+	# now (n >> 2) = (d >> 1) * %r1 + %r0
+	lhi   %r3,1
+	nr    %r3,%r1		  # test last bit of q
+	jz    1f
+	alr   %r0,%r2		  # add (d>>1) to r
+1:	srl   %r1,1		  # q >>= 1
+	# now (n >> 2) = (d&-2) * %r1 + %r0
+	lhi   %r3,1
+	nr    %r3,%r5		  # test last bit of d
+	jz    2f
+	slr   %r0,%r1		  # r -= q
+	brc   3,2f		  # borrow ?
+	alr   %r0,%r5		  # r += d
+	ahi   %r1,-1
+2:	# now (n >> 2) = d * %r1 + %r0
+	alr   %r1,%r1		  # q <<= 1
+	alr   %r0,%r0		  # r <<= 1
+	brc   12,3f		  # overflow on r ?
+	slr   %r0,%r5		  # r -= d
+	ahi   %r1,1		  # q += 1
+3:	lhi   %r3,2
+	nr    %r3,%r4		  # test next to last bit of n
+	jz    4f
+	ahi   %r0,1		  # r += 1
+4:	clr   %r0,%r5		  # r >= d ?
+	jl    6f
+	slr   %r0,%r5		  # r -= d
+	ahi   %r1,1		  # q += 1
+	# now (n >> 1) = d * %r1 + %r0
+	j     6f
+5:	# divisor < 0x80000000
+	srdl  %r0,1
+	dr    %r0,%r2		  # signed division
+	# now (n >> 1) = d * %r1 + %r0
+6:	alr   %r1,%r1		  # q <<= 1
+	alr   %r0,%r0		  # r <<= 1
+	brc   12,7f		  # overflow on r ?
+	slr   %r0,%r5		  # r -= d
+	ahi   %r1,1		  # q += 1
+7:	lhi   %r3,1
+	nr    %r3,%r4		  # isolate last bit of n
+	alr   %r0,%r3		  # r += (n & 1)
+	clr   %r0,%r5		  # r >= d ?
+	jl    8f
+	slr   %r0,%r5		  # r -= d
+	ahi   %r1,1		  # q += 1
+8:	# now n = d * %r1 + %r0
+	l     %r2,24(%r15)
+	st    %r0,0(%r2)
+	lr    %r2,%r1
+	br    %r14
+	.end	__udiv_qrnnd
diff -urpN linux-2.6/arch/s390/math-emu/Makefile linux-2.6-patched/arch/s390/math-emu/Makefile
--- linux-2.6/arch/s390/math-emu/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/math-emu/Makefile	2007-01-26 17:29:37.000000000 +0100
@@ -2,7 +2,7 @@
 # Makefile for the FPU instruction emulation.
 #
 
-obj-$(CONFIG_MATHEMU) := math.o qrnnd.o
+obj-$(CONFIG_MATHEMU) := math.o
 
 EXTRA_CFLAGS := -I$(src) -Iinclude/math-emu -w
 EXTRA_AFLAGS := -traditional
diff -urpN linux-2.6/arch/s390/math-emu/math.c linux-2.6-patched/arch/s390/math-emu/math.c
--- linux-2.6/arch/s390/math-emu/math.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/math-emu/math.c	2007-01-26 17:29:37.000000000 +0100
@@ -15,7 +15,7 @@
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
 
-#include "sfp-util.h"
+#include <asm/sfp-util.h>
 #include <math-emu/soft-fp.h>
 #include <math-emu/single.h>
 #include <math-emu/double.h>
diff -urpN linux-2.6/arch/s390/math-emu/qrnnd.S linux-2.6-patched/arch/s390/math-emu/qrnnd.S
--- linux-2.6/arch/s390/math-emu/qrnnd.S	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/math-emu/qrnnd.S	1970-01-01 01:00:00.000000000 +0100
@@ -1,77 +0,0 @@
-# S/390 __udiv_qrnnd
-
-# r2 : &__r
-# r3 : upper half of 64 bit word n
-# r4 : lower half of 64 bit word n
-# r5 : divisor d
-# the reminder r of the division is to be stored to &__r and
-# the quotient q is to be returned
-
-        .text
-        .globl __udiv_qrnnd
-__udiv_qrnnd:
-        st    %r2,24(%r15)        # store pointer to reminder for later
-        lr    %r0,%r3             # reload n
-	lr    %r1,%r4
-	ltr   %r2,%r5             # reload and test divisor
-        jp    5f
-        # divisor >= 0x80000000
-	srdl  %r0,2               # n/4
-        srl   %r2,1               # d/2
-        slr   %r1,%r2             # special case if last bit of d is set
-        brc   3,0f                #  (n/4) div (n/2) can overflow by 1
-        ahi   %r0,-1              #  trick: subtract n/2, then divide
-0:      dr    %r0,%r2             # signed division
-        ahi   %r1,1               #  trick part 2: add 1 to the quotient
-        # now (n >> 2) = (d >> 1) * %r1 + %r0
-	lhi   %r3,1
-        nr    %r3,%r1             # test last bit of q
-        jz    1f
-        alr   %r0,%r2             # add (d>>1) to r
-1:      srl   %r1,1               # q >>= 1
-        # now (n >> 2) = (d&-2) * %r1 + %r0
-        lhi   %r3,1
-        nr    %r3,%r5             # test last bit of d
-        jz    2f
-        slr   %r0,%r1             # r -= q
-	brc   3,2f                # borrow ?
-	alr   %r0,%r5             # r += d
-	ahi   %r1,-1
-2:      # now (n >> 2) = d * %r1 + %r0
-        alr   %r1,%r1             # q <<= 1
-        alr   %r0,%r0             # r <<= 1
-        brc   12,3f               # overflow on r ?
-        slr   %r0,%r5             # r -= d
-        ahi   %r1,1               # q += 1
-3:      lhi   %r3,2
-        nr    %r3,%r4             # test next to last bit of n
-        jz    4f
-        ahi   %r0,1               # r += 1
-4:      clr   %r0,%r5             # r >= d ?
-        jl    6f
-        slr   %r0,%r5             # r -= d
-        ahi   %r1,1               # q += 1
-        # now (n >> 1) = d * %r1 + %r0
-        j     6f
-5:      # divisor < 0x80000000
-	srdl  %r0,1
-        dr    %r0,%r2             # signed division
-        # now (n >> 1) = d * %r1 + %r0
-6:      alr   %r1,%r1             # q <<= 1
-        alr   %r0,%r0             # r <<= 1
-        brc   12,7f               # overflow on r ?
-        slr   %r0,%r5             # r -= d
-        ahi   %r1,1               # q += 1
-7:      lhi   %r3,1
-        nr    %r3,%r4             # isolate last bit of n
-        alr   %r0,%r3             # r += (n & 1)
-        clr   %r0,%r5             # r >= d ?
-        jl    8f
-        slr   %r0,%r5             # r -= d
-        ahi   %r1,1               # q += 1
-8:      # now n = d * %r1 + %r0
-	l     %r2,24(%r15)
-        st    %r0,0(%r2)
-        lr    %r2,%r1
-        br    %r14
-	.end	__udiv_qrnnd
diff -urpN linux-2.6/arch/s390/math-emu/sfp-util.h linux-2.6-patched/arch/s390/math-emu/sfp-util.h
--- linux-2.6/arch/s390/math-emu/sfp-util.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/arch/s390/math-emu/sfp-util.h	1970-01-01 01:00:00.000000000 +0100
@@ -1,66 +0,0 @@
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
-#define add_ssaaaa(sh, sl, ah, al, bh, bl) ({		\
-	unsigned int __sh = (ah);			\
-	unsigned int __sl = (al);			\
-	asm volatile(					\
-		"	alr	%1,%3\n"		\
-		"	brc	12,0f\n"		\
-		"	ahi	%0,1\n"			\
-		"0:	alr  %0,%2"			\
-		: "+&d" (__sh), "+d" (__sl)		\
-		: "d" (bh), "d" (bl) : "cc");		\
-	(sh) = __sh;					\
-	(sl) = __sl;					\
-})
-
-#define sub_ddmmss(sh, sl, ah, al, bh, bl) ({		\
-	unsigned int __sh = (ah);			\
-	unsigned int __sl = (al);			\
-	asm volatile(					\
-		"	slr	%1,%3\n"		\
-		"	brc	3,0f\n"			\
-		"	ahi	%0,-1\n"		\
-		"0:	slr	%0,%2"			\
-		: "+&d" (__sh), "+d" (__sl)		\
-		: "d" (bh), "d" (bl) : "cc");		\
-	(sh) = __sh;					\
-	(sl) = __sl;					\
-})
-
-/* a umul b = a mul b + (a>=2<<31) ? b<<32:0 + (b>=2<<31) ? a<<32:0 */
-#define umul_ppmm(wh, wl, u, v) ({			\
-	unsigned int __wh = u;				\
-	unsigned int __wl = v;				\
-	asm volatile(					\
-		"	ltr	1,%0\n"			\
-		"	mr	0,%1\n"			\
-		"	jnm	0f\n"				\
-		"	alr	0,%1\n"			\
-		"0:	ltr	%1,%1\n"			\
-		"	jnm	1f\n"				\
-		"	alr	0,%0\n"			\
-		"1:	lr	%0,0\n"			\
-		"	lr	%1,1\n"			\
-		: "+d" (__wh), "+d" (__wl)		\
-		: : "0", "1", "cc");			\
-	wh = __wh;					\
-	wl = __wl;					\
-})
-
-#define udiv_qrnnd(q, r, n1, n0, d)			\
-  do { unsigned long __r;				\
-    (q) = __udiv_qrnnd (&__r, (n1), (n0), (d));		\
-    (r) = __r;						\
-  } while (0)
-extern unsigned long __udiv_qrnnd (unsigned long *, unsigned long,
-				   unsigned long , unsigned long);
-
-#define UDIV_NEEDS_NORMALIZATION 0
-
-#define abort() return 0
-
-#define __BYTE_ORDER __BIG_ENDIAN
diff -urpN linux-2.6/drivers/s390/Makefile linux-2.6-patched/drivers/s390/Makefile
--- linux-2.6/drivers/s390/Makefile	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/Makefile	2007-01-26 17:29:37.000000000 +0100
@@ -2,6 +2,8 @@
 # Makefile for the S/390 specific device drivers
 #
 
+CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
+
 obj-y += s390mach.o sysinfo.o s390_rdev.o
 obj-y += cio/ block/ char/ crypto/ net/ scsi/
 
diff -urpN linux-2.6/drivers/s390/sysinfo.c linux-2.6-patched/drivers/s390/sysinfo.c
--- linux-2.6/drivers/s390/sysinfo.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/sysinfo.c	2007-01-26 17:29:37.000000000 +0100
@@ -9,8 +9,14 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <asm/ebcdic.h>
 
+/* Sigh, math-emu. Don't ask. */
+#include <asm/sfp-util.h>
+#include <math-emu/soft-fp.h>
+#include <math-emu/single.h>
+
 struct sysinfo_1_1_1 {
 	char reserved_0[32];
 	char manufacturer[16];
@@ -198,7 +204,7 @@ static int stsi_1_2_2(struct sysinfo_1_2
 		 * if the higher order 8 bits are not zero. Printing
 		 * a floating point number in the kernel is a no-no,
 		 * always print the number as 32 bit unsigned integer.
-		 * The user-space needs to know about the stange
+		 * The user-space needs to know about the strange
 		 * encoding of the alternate cpu capability.
 		 */
 		len += sprintf(page + len, "Capability:           %u %u\n",
@@ -351,3 +357,46 @@ static __init int create_proc_sysinfo(vo
 
 __initcall(create_proc_sysinfo);
 
+/*
+ * calibrate the delay loop
+ */
+void __init calibrate_delay(void)
+{
+	struct sysinfo_1_2_2 *info = (void *) get_zeroed_page (GFP_KERNEL);
+	const unsigned int fmil = 0x4b189680;	/* 1e7 as 32-bit float. */
+	FP_DECL_S(SA); FP_DECL_S(SB); FP_DECL_S(SR);
+	FP_DECL_EX;
+	unsigned int capability;
+
+	if (stsi(info, 1, 2, 2) != -ENOSYS) {
+		/*
+		 * Major sigh. The cpu capability encoding is "special".
+		 * If the first 9 bits of info->capability are 0 then it
+		 * is a 32 bit unsigned integer in the range 0 .. 2^23.
+		 * If the first 9 bits are != 0 then it is a 32 bit float.
+		 * In addition a lower value indicates a proportionally
+		 * higher cpu capacity. Bogomips are the other way round.
+		 * To get to a halfway suitable number we divide 1e7
+		 * by the cpu capability number. Yes, that means a floating
+		 * point division .. math-emu here we come :-)
+		 */
+		FP_UNPACK_SP(SA, &fmil);
+		if ((info->capability >> 23) == 0)
+			FP_FROM_INT_S(SB, info->capability, 32, int);
+		else
+			FP_UNPACK_SP(SB, &info->capability);
+		FP_DIV_S(SR, SA, SB);
+		FP_TO_INT_S(capability, SR, 32, 0);
+	} else
+		/*
+		 * Really old machine without stsi block for basic
+		 * cpu information. Report 42.0 bogomips.
+		 */
+		capability = 42;
+	loops_per_jiffy = capability * (500000/HZ);
+	free_page((unsigned long) info);
+	/* Print the good old Bogomips line .. */
+	printk(KERN_DEBUG "Calibrating delay loop (skipped)... "
+	       "%lu.%02lu BogoMIPS preset\n", loops_per_jiffy/(500000/HZ),
+	       (loops_per_jiffy/(5000/HZ)) % 100);
+}
diff -urpN linux-2.6/include/asm-s390/sfp-util.h linux-2.6-patched/include/asm-s390/sfp-util.h
--- linux-2.6/include/asm-s390/sfp-util.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/sfp-util.h	2007-01-26 17:29:37.000000000 +0100
@@ -0,0 +1,66 @@
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+#define add_ssaaaa(sh, sl, ah, al, bh, bl) ({		\
+	unsigned int __sh = (ah);			\
+	unsigned int __sl = (al);			\
+	asm volatile(					\
+		"	alr	%1,%3\n"		\
+		"	brc	12,0f\n"		\
+		"	ahi	%0,1\n"			\
+		"0:	alr  %0,%2"			\
+		: "+&d" (__sh), "+d" (__sl)		\
+		: "d" (bh), "d" (bl) : "cc");		\
+	(sh) = __sh;					\
+	(sl) = __sl;					\
+})
+
+#define sub_ddmmss(sh, sl, ah, al, bh, bl) ({		\
+	unsigned int __sh = (ah);			\
+	unsigned int __sl = (al);			\
+	asm volatile(					\
+		"	slr	%1,%3\n"		\
+		"	brc	3,0f\n"			\
+		"	ahi	%0,-1\n"		\
+		"0:	slr	%0,%2"			\
+		: "+&d" (__sh), "+d" (__sl)		\
+		: "d" (bh), "d" (bl) : "cc");		\
+	(sh) = __sh;					\
+	(sl) = __sl;					\
+})
+
+/* a umul b = a mul b + (a>=2<<31) ? b<<32:0 + (b>=2<<31) ? a<<32:0 */
+#define umul_ppmm(wh, wl, u, v) ({			\
+	unsigned int __wh = u;				\
+	unsigned int __wl = v;				\
+	asm volatile(					\
+		"	ltr	1,%0\n"			\
+		"	mr	0,%1\n"			\
+		"	jnm	0f\n"				\
+		"	alr	0,%1\n"			\
+		"0:	ltr	%1,%1\n"			\
+		"	jnm	1f\n"				\
+		"	alr	0,%0\n"			\
+		"1:	lr	%0,0\n"			\
+		"	lr	%1,1\n"			\
+		: "+d" (__wh), "+d" (__wl)		\
+		: : "0", "1", "cc");			\
+	wh = __wh;					\
+	wl = __wl;					\
+})
+
+#define udiv_qrnnd(q, r, n1, n0, d)			\
+  do { unsigned int __r;				\
+    (q) = __udiv_qrnnd (&__r, (n1), (n0), (d));		\
+    (r) = __r;						\
+  } while (0)
+extern unsigned long __udiv_qrnnd (unsigned int *, unsigned int,
+				   unsigned int , unsigned int);
+
+#define UDIV_NEEDS_NORMALIZATION 0
+
+#define abort() return 0
+
+#define __BYTE_ORDER __BIG_ENDIAN
