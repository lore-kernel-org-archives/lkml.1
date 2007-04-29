Return-Path: <linux-kernel-owner+w=401wt.eu-S1161619AbXD2Xss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161619AbXD2Xss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161595AbXD2XrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161582AbXD2XqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:21 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [11/26] i386: clean up identify_cpu
Message-Id: <20070429234620.6FFCD150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
identify_cpu() is used to identify both the boot CPU and secondary
CPUs, but it performs some actions which only apply to the boot CPU.
Those functions are therefore really __init functions, but because
they're called by identify_cpu(), they must be marked __cpuinit.

This patch splits identify_cpu() into identify_boot_cpu() and
identify_secondary_cpu(), and calls the appropriate init functions
from each.  Also, identify_boot_cpu() and all the functions it
dominates are marked __init.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/common.c |   21 ++++++++++++++-------
 arch/i386/kernel/smpboot.c    |    2 +-
 arch/i386/kernel/sysenter.c   |    2 +-
 include/asm-i386/processor.h  |    3 ++-
 4 files changed, 18 insertions(+), 10 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/common.c
+++ linux/arch/i386/kernel/cpu/common.c
@@ -394,7 +394,7 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
@@ -505,15 +505,22 @@ void __cpuinit identify_cpu(struct cpuin
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
+}
 
-	if (c == &boot_cpu_data)
-		sysenter_setup();
+void __init identify_boot_cpu(void)
+{
+	identify_cpu(&boot_cpu_data);
+	sysenter_setup();
 	enable_sep_cpu();
+	mtrr_bp_init();
+}
 
-	if (c == &boot_cpu_data)
-		mtrr_bp_init();
-	else
-		mtrr_ap_init();
+void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+{
+	BUG_ON(c == &boot_cpu_data);
+	identify_cpu(c);
+	enable_sep_cpu();
+	mtrr_ap_init();
 }
 
 #ifdef CONFIG_X86_HT
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -155,7 +155,7 @@ static void __cpuinit smp_store_cpu_info
 
 	*c = boot_cpu_data;
 	if (id!=0)
-		identify_cpu(c);
+		identify_secondary_cpu(c);
 	/*
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
Index: linux/arch/i386/kernel/sysenter.c
===================================================================
--- linux.orig/arch/i386/kernel/sysenter.c
+++ linux/arch/i386/kernel/sysenter.c
@@ -72,7 +72,7 @@ extern const char vsyscall_int80_start, 
 extern const char vsyscall_sysenter_start, vsyscall_sysenter_end;
 static struct page *syscall_pages[1];
 
-int __cpuinit sysenter_setup(void)
+int __init sysenter_setup(void)
 {
 	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -116,7 +116,8 @@ extern char ignore_fpu_irq;
 
 void __init cpu_detect(struct cpuinfo_x86 *c);
 
-extern void identify_cpu(struct cpuinfo_x86 *);
+extern void identify_boot_cpu(void);
+extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
