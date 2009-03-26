Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZCZMDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZCZMDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbZCZMCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:02:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:52719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbZCZMCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:02:52 -0400
Subject: [PATCH -tip] x86: unification of cpu/bugs.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 17:32:09 +0530
Message-Id: <1238068930.2507.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on -tip x86/core:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Thu, 26 Mar 2009 17:14:38 +0530
Subject: [PATCH] x86: unification of cpu/bugs.c

Impact: Unification, cleanup

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/Makefile  |    5 +--
 arch/x86/kernel/cpu/bugs.c    |   74 ++++++++++++++++++++++++++--------------
 arch/x86/kernel/cpu/bugs_64.c |   33 ------------------
 3 files changed, 50 insertions(+), 62 deletions(-)
 delete mode 100644 arch/x86/kernel/cpu/bugs_64.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 4e242f9..90a96ee 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -9,10 +9,9 @@ endif
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o
+obj-y			+= vmware.o hypervisor.o bugs.o
 
-obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
-obj-$(CONFIG_X86_64)	+= bugs_64.o
+obj-$(CONFIG_X86_32)			+= cmpxchg.o
 
 obj-$(CONFIG_X86_CPU_DEBUG)		+= cpu_debug.o
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index c8e315f..05ec583 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -6,17 +6,23 @@
  *        <rreilova@ececs.uc.edu>
  *	- Channing Corn (tests & fixes),
  *	- Andrew D. Balsa (code cleanup).
+ *
+ *  Copyright (C) 2000 SuSE
  */
-#include <linux/init.h>
+
 #include <linux/utsname.h>
-#include <asm/bugs.h>
-#include <asm/processor.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+
 #include <asm/processor-flags.h>
+#include <asm/alternative.h>
+#include <asm/processor.h>
+#include <asm/paravirt.h>
 #include <asm/i387.h>
+#include <asm/bugs.h>
 #include <asm/msr.h>
-#include <asm/paravirt.h>
-#include <asm/alternative.h>
 
+#ifdef CONFIG_X86_32
 static int __init no_halt(char *s)
 {
 	boot_cpu_data.hlt_works_ok = 0;
@@ -56,7 +62,8 @@ static void __init check_fpu(void)
 #ifndef CONFIG_MATH_EMULATION
 		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
 		printk(KERN_EMERG "Giving up.\n");
-		for (;;) ;
+		for (;;)
+			;
 #endif
 		return;
 	}
@@ -67,21 +74,21 @@ static void __init check_fpu(void)
 	 *
 	 * Test for the divl bug..
 	 */
-	__asm__("fninit\n\t"
-		"fldl %1\n\t"
-		"fdivl %2\n\t"
-		"fmull %2\n\t"
-		"fldl %1\n\t"
-		"fsubp %%st,%%st(1)\n\t"
-		"fistpl %0\n\t"
-		"fwait\n\t"
+	__asm__("fninit			\n\t"
+		"fldl	%1		\n\t"
+		"fdivl	%2		\n\t"
+		"fmull	%2		\n\t"
+		"fldl	%1		\n\t"
+		"fsubp	%%st,%%st(1)	\n\t"
+		"fistpl	%0		\n\t"
+		"fwait			\n\t"
 		"fninit"
 		: "=m" (*&fdiv_bug)
 		: "m" (*&x), "m" (*&y));
 
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
-		printk("Hmm, FPU with FDIV bug.\n");
+		printk(KERN_INFO "Hmm, FPU with FDIV bug.\n");
 }
 
 static void __init check_hlt(void)
@@ -91,14 +98,14 @@ static void __init check_hlt(void)
 
 	printk(KERN_INFO "Checking 'hlt' instruction... ");
 	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
+		printk(KERN_INFO "disabled\n");
 		return;
 	}
 	halt();
 	halt();
 	halt();
 	halt();
-	printk("OK.\n");
+	printk(KERN_INFO "OK.\n");
 }
 
 /*
@@ -122,9 +129,9 @@ static void __init check_popad(void)
 	 * CPU hard. Too bad.
 	 */
 	if (res != 12345678)
-		printk("Buggy.\n");
+		printk(KERN_INFO "Buggy.\n");
 	else
-		printk("OK.\n");
+		printk(KERN_INFO "OK.\n");
 #endif
 }
 
@@ -149,21 +156,36 @@ static void __init check_config(void)
 	if (boot_cpu_data.x86 == 3)
 		panic("Kernel requires i486+ for 'invlpg' and other features");
 #endif
+	check_fpu();
+	check_hlt();
+	check_popad();
+	init_utsname()->machine[1] =
+		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 }
-
+#else /* CONFIG_X86_32 */
+static inline void __init check_config(void) {}
+#endif /* CONFIG_X86_32 */
 
 void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #ifndef CONFIG_SMP
-	printk("CPU: ");
+	printk(KERN_INFO "CPU: ");
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
-	check_fpu();
-	check_hlt();
-	check_popad();
-	init_utsname()->machine[1] =
-		'0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
 	alternative_instructions();
+
+#ifdef CONFIG_X86_64
+	/*
+	 * Make sure the first 2MB area is not mapped by huge pages
+	 * There are typically fixed size MTRRs in there and overlapping
+	 * MTRRs into large pages causes slow downs.
+	 *
+	 * Right now we don't do that with gbpages because there seems
+	 * very little benefit for that case.
+	 */
+	if (!direct_gbpages)
+		set_memory_4k((unsigned long)__va(0), 1);
+#endif /* CONFIG_X86_64 */
 }
diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
deleted file mode 100644
index 9a3ed06..0000000
--- a/arch/x86/kernel/cpu/bugs_64.c
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *  Copyright (C) 1994  Linus Torvalds
- *  Copyright (C) 2000  SuSE
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <asm/alternative.h>
-#include <asm/bugs.h>
-#include <asm/processor.h>
-#include <asm/mtrr.h>
-#include <asm/cacheflush.h>
-
-void __init check_bugs(void)
-{
-	identify_boot_cpu();
-#if !defined(CONFIG_SMP)
-	printk("CPU: ");
-	print_cpu_info(&boot_cpu_data);
-#endif
-	alternative_instructions();
-
-	/*
-	 * Make sure the first 2MB area is not mapped by huge pages
-	 * There are typically fixed size MTRRs in there and overlapping
-	 * MTRRs into large pages causes slow downs.
-	 *
-	 * Right now we don't do that with gbpages because there seems
-	 * very little benefit for that case.
-	 */
-	if (!direct_gbpages)
-		set_memory_4k((unsigned long)__va(0), 1);
-}
-- 
1.6.0.6



