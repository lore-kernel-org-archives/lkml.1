Return-Path: <linux-kernel-owner+w=401wt.eu-S1161581AbXD2XrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161581AbXD2XrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161622AbXD2XrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:38455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161581AbXD2XqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:21 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [10/26] i386: Clean up asm-i386/bugs.h
Message-Id: <20070429234619.5DE57150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Most of asm-i386/bugs.h is code which should be in a C file, so put it there.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/i386/kernel/cpu/Makefile  |    2 
 arch/i386/kernel/cpu/bugs.c    |  191 ++++++++++++++++++++++++++++++++++++++++
 include/asm-i386/alternative.h |    1 
 include/asm-i386/bugs.h        |  194 -----------------------------------------
 4 files changed, 197 insertions(+), 191 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/cpu/Makefile
===================================================================
--- linux.orig/arch/i386/kernel/cpu/Makefile
+++ linux/arch/i386/kernel/cpu/Makefile
@@ -2,7 +2,7 @@
 # Makefile for x86-compatible CPU details and quirks
 #
 
-obj-y	:=	common.o proc.o
+obj-y	:=	common.o proc.o bugs.o
 
 obj-y	+=	amd.o
 obj-y	+=	cyrix.o
Index: linux/arch/i386/kernel/cpu/bugs.c
===================================================================
--- /dev/null
+++ linux/arch/i386/kernel/cpu/bugs.c
@@ -0,0 +1,191 @@
+/*
+ *  arch/i386/cpu/bugs.c
+ *
+ *  Copyright (C) 1994  Linus Torvalds
+ *
+ *  Cyrix stuff, June 1998 by:
+ *	- Rafael R. Reilova (moved everything from head.S),
+ *        <rreilova@ececs.uc.edu>
+ *	- Channing Corn (tests & fixes),
+ *	- Andrew D. Balsa (code cleanup).
+ */
+#include <linux/init.h>
+#include <linux/utsname.h>
+#include <asm/processor.h>
+#include <asm/i387.h>
+#include <asm/msr.h>
+#include <asm/paravirt.h>
+#include <asm/alternative.h>
+
+static int __init no_halt(char *s)
+{
+	boot_cpu_data.hlt_works_ok = 0;
+	return 1;
+}
+
+__setup("no-hlt", no_halt);
+
+static int __init mca_pentium(char *s)
+{
+	mca_pentium_flag = 1;
+	return 1;
+}
+
+__setup("mca-pentium", mca_pentium);
+
+static int __init no_387(char *s)
+{
+	boot_cpu_data.hard_math = 0;
+	write_cr0(0xE | read_cr0());
+	return 1;
+}
+
+__setup("no387", no_387);
+
+static double __initdata x = 4195835.0;
+static double __initdata y = 3145727.0;
+
+/*
+ * This used to check for exceptions..
+ * However, it turns out that to support that,
+ * the XMM trap handlers basically had to
+ * be buggy. So let's have a correct XMM trap
+ * handler, and forget about printing out
+ * some status at boot.
+ *
+ * We should really only care about bugs here
+ * anyway. Not features.
+ */
+static void __init check_fpu(void)
+{
+	if (!boot_cpu_data.hard_math) {
+#ifndef CONFIG_MATH_EMULATION
+		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
+		printk(KERN_EMERG "Giving up.\n");
+		for (;;) ;
+#endif
+		return;
+	}
+
+/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
+	/* Test for the divl bug.. */
+	__asm__("fninit\n\t"
+		"fldl %1\n\t"
+		"fdivl %2\n\t"
+		"fmull %2\n\t"
+		"fldl %1\n\t"
+		"fsubp %%st,%%st(1)\n\t"
+		"fistpl %0\n\t"
+		"fwait\n\t"
+		"fninit"
+		: "=m" (*&boot_cpu_data.fdiv_bug)
+		: "m" (*&x), "m" (*&y));
+	if (boot_cpu_data.fdiv_bug)
+		printk("Hmm, FPU with FDIV bug.\n");
+}
+
+static void __init check_hlt(void)
+{
+	if (paravirt_enabled())
+		return;
+
+	printk(KERN_INFO "Checking 'hlt' instruction... ");
+	if (!boot_cpu_data.hlt_works_ok) {
+		printk("disabled\n");
+		return;
+	}
+	halt();
+	halt();
+	halt();
+	halt();
+	printk("OK.\n");
+}
+
+/*
+ *	Most 386 processors have a bug where a POPAD can lock the
+ *	machine even from user space.
+ */
+
+static void __init check_popad(void)
+{
+#ifndef CONFIG_X86_POPAD_OK
+	int res, inp = (int) &res;
+
+	printk(KERN_INFO "Checking for popad bug... ");
+	__asm__ __volatile__(
+	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
+	  : "=&a" (res)
+	  : "d" (inp)
+	  : "ecx", "edi" );
+	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
+	if (res != 12345678) printk( "Buggy.\n" );
+		        else printk( "OK.\n" );
+#endif
+}
+
+/*
+ * Check whether we are able to run this kernel safely on SMP.
+ *
+ * - In order to run on a i386, we need to be compiled for i386
+ *   (for due to lack of "invlpg" and working WP on a i386)
+ * - In order to run on anything without a TSC, we need to be
+ *   compiled for a i486.
+ * - In order to support the local APIC on a buggy Pentium machine,
+ *   we need to be compiled with CONFIG_X86_GOOD_APIC disabled,
+ *   which happens implicitly if compiled for a Pentium or lower
+ *   (unless an advanced selection of CPU features is used) as an
+ *   otherwise config implies a properly working local APIC without
+ *   the need to do extra reads from the APIC.
+*/
+
+static void __init check_config(void)
+{
+/*
+ * We'd better not be a i386 if we're configured to use some
+ * i486+ only features! (WP works in supervisor mode and the
+ * new "invlpg" and "bswap" instructions)
+ */
+#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
+	if (boot_cpu_data.x86 == 3)
+		panic("Kernel requires i486+ for 'invlpg' and other features");
+#endif
+
+/*
+ * If we configured ourselves for a TSC, we'd better have one!
+ */
+#ifdef CONFIG_X86_TSC
+	if (!cpu_has_tsc && !tsc_disable)
+		panic("Kernel compiled for Pentium+, requires TSC feature!");
+#endif
+
+/*
+ * If we were told we had a good local APIC, check for buggy Pentia,
+ * i.e. all B steppings and the C2 stepping of P54C when using their
+ * integrated APIC (see 11AP erratum in "Pentium Processor
+ * Specification Update").
+ */
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_GOOD_APIC)
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL
+	    && cpu_has_apic
+	    && boot_cpu_data.x86 == 5
+	    && boot_cpu_data.x86_model == 2
+	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
+		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
+#endif
+}
+
+
+void __init check_bugs(void)
+{
+	identify_boot_cpu();
+#ifndef CONFIG_SMP
+	printk("CPU: ");
+	print_cpu_info(&boot_cpu_data);
+#endif
+	check_config();
+	check_fpu();
+	check_hlt();
+	check_popad();
+	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
+	alternative_instructions();
+}
Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -16,6 +16,7 @@ struct alt_instr {
 	u8  pad;
 };
 
+extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
 struct module;
Index: linux/include/asm-i386/bugs.h
===================================================================
--- linux.orig/include/asm-i386/bugs.h
+++ linux/include/asm-i386/bugs.h
@@ -1,198 +1,12 @@
 /*
- *  include/asm-i386/bugs.h
- *
- *  Copyright (C) 1994  Linus Torvalds
- *
- *  Cyrix stuff, June 1998 by:
- *	- Rafael R. Reilova (moved everything from head.S),
- *        <rreilova@ececs.uc.edu>
- *	- Channing Corn (tests & fixes),
- *	- Andrew D. Balsa (code cleanup).
- */
-
-/*
  * This is included by init/main.c to check for architecture-dependent bugs.
  *
  * Needs:
  *	void check_bugs(void);
  */
+#ifndef _ASM_I386_BUG_H
+#define _ASM_I386_BUG_H
 
-#include <linux/init.h>
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/msr.h>
-#include <asm/paravirt.h>
-
-static int __init no_halt(char *s)
-{
-	boot_cpu_data.hlt_works_ok = 0;
-	return 1;
-}
-
-__setup("no-hlt", no_halt);
-
-static int __init mca_pentium(char *s)
-{
-	mca_pentium_flag = 1;
-	return 1;
-}
-
-__setup("mca-pentium", mca_pentium);
-
-static int __init no_387(char *s)
-{
-	boot_cpu_data.hard_math = 0;
-	write_cr0(0xE | read_cr0());
-	return 1;
-}
-
-__setup("no387", no_387);
-
-static double __initdata x = 4195835.0;
-static double __initdata y = 3145727.0;
-
-/*
- * This used to check for exceptions.. 
- * However, it turns out that to support that,
- * the XMM trap handlers basically had to
- * be buggy. So let's have a correct XMM trap
- * handler, and forget about printing out
- * some status at boot.
- *
- * We should really only care about bugs here
- * anyway. Not features.
- */
-static void __init check_fpu(void)
-{
-	if (!boot_cpu_data.hard_math) {
-#ifndef CONFIG_MATH_EMULATION
-		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
-		printk(KERN_EMERG "Giving up.\n");
-		for (;;) ;
-#endif
-		return;
-	}
-
-/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
-	/* Test for the divl bug.. */
-	__asm__("fninit\n\t"
-		"fldl %1\n\t"
-		"fdivl %2\n\t"
-		"fmull %2\n\t"
-		"fldl %1\n\t"
-		"fsubp %%st,%%st(1)\n\t"
-		"fistpl %0\n\t"
-		"fwait\n\t"
-		"fninit"
-		: "=m" (*&boot_cpu_data.fdiv_bug)
-		: "m" (*&x), "m" (*&y));
-	if (boot_cpu_data.fdiv_bug)
-		printk("Hmm, FPU with FDIV bug.\n");
-}
-
-static void __init check_hlt(void)
-{
-	if (paravirt_enabled())
-		return;
-
-	printk(KERN_INFO "Checking 'hlt' instruction... ");
-	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
-		return;
-	}
-	halt();
-	halt();
-	halt();
-	halt();
-	printk("OK.\n");
-}
-
-/*
- *	Most 386 processors have a bug where a POPAD can lock the 
- *	machine even from user space.
- */
- 
-static void __init check_popad(void)
-{
-#ifndef CONFIG_X86_POPAD_OK
-	int res, inp = (int) &res;
-
-	printk(KERN_INFO "Checking for popad bug... ");
-	__asm__ __volatile__( 
-	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
-	  : "=&a" (res)
-	  : "d" (inp)
-	  : "ecx", "edi" );
-	/* If this fails, it means that any user program may lock the CPU hard. Too bad. */
-	if (res != 12345678) printk( "Buggy.\n" );
-		        else printk( "OK.\n" );
-#endif
-}
-
-/*
- * Check whether we are able to run this kernel safely on SMP.
- *
- * - In order to run on a i386, we need to be compiled for i386
- *   (for due to lack of "invlpg" and working WP on a i386)
- * - In order to run on anything without a TSC, we need to be
- *   compiled for a i486.
- * - In order to support the local APIC on a buggy Pentium machine,
- *   we need to be compiled with CONFIG_X86_GOOD_APIC disabled,
- *   which happens implicitly if compiled for a Pentium or lower
- *   (unless an advanced selection of CPU features is used) as an
- *   otherwise config implies a properly working local APIC without
- *   the need to do extra reads from the APIC.
-*/
-
-static void __init check_config(void)
-{
-/*
- * We'd better not be a i386 if we're configured to use some
- * i486+ only features! (WP works in supervisor mode and the
- * new "invlpg" and "bswap" instructions)
- */
-#if defined(CONFIG_X86_WP_WORKS_OK) || defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_BSWAP)
-	if (boot_cpu_data.x86 == 3)
-		panic("Kernel requires i486+ for 'invlpg' and other features");
-#endif
-
-/*
- * If we configured ourselves for a TSC, we'd better have one!
- */
-#ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc && !tsc_disable)
-		panic("Kernel compiled for Pentium+, requires TSC feature!");
-#endif
-
-/*
- * If we were told we had a good local APIC, check for buggy Pentia,
- * i.e. all B steppings and the C2 stepping of P54C when using their
- * integrated APIC (see 11AP erratum in "Pentium Processor
- * Specification Update").
- */
-#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_GOOD_APIC)
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL
-	    && cpu_has_apic
-	    && boot_cpu_data.x86 == 5
-	    && boot_cpu_data.x86_model == 2
-	    && (boot_cpu_data.x86_mask < 6 || boot_cpu_data.x86_mask == 11))
-		panic("Kernel compiled for PMMX+, assumes a local APIC without the read-before-write bug!");
-#endif
-}
-
-extern void alternative_instructions(void);
+extern void __init check_bugs(void);
 
-static void __init check_bugs(void)
-{
-	identify_cpu(&boot_cpu_data);
-#ifndef CONFIG_SMP
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	check_config();
-	check_fpu();
-	check_hlt();
-	check_popad();
-	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
-	alternative_instructions(); 
-}
+#endif	/* _ASM_I386_BUG_H */
