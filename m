Return-Path: <linux-kernel-owner+w=401wt.eu-S933248AbXIUWsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbXIUWsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764140AbXIUWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:49 -0400
Received: from ns.suse.de ([195.135.220.2]:57113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763785AbXIUWcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:42 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: sam@ravnborg.org, frankvm@frankvm.com, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [41/50] i386: fix section mismatch warning in intel.c
Message-Id: <20070921223241.785631479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sam Ravnborg <sam@ravnborg.org>
Fix following section mismatch warning:
WARNING: vmlinux.o(.text+0xc88c): Section mismatch: reference to .init.text:trap_init_f00f_bug (between 'init_intel' and 'cpuid4_cache_lookup')

init_intel are __cpuint where trap_init_f00f_bug is __init.
Fixed by declaring trap_init_f00f_bug __cpuinit.

Moved the defintion of trap_init_f00f_bug to the sole user in init.c
so the ugly prototype in intel.c could get killed.

Frank van Maarseveen <frankvm@frankvm.com> supplied the .config used
to reproduce the warning.

Cc: Frank van Maarseveen <frankvm@frankvm.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---
---
 arch/i386/kernel/cpu/intel.c |   17 +++++++++++++++--
 arch/i386/kernel/traps.c     |   14 --------------
 2 files changed, 15 insertions(+), 16 deletions(-)

Index: linux/arch/i386/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel.c
+++ linux/arch/i386/kernel/cpu/intel.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 
 #include <asm/processor.h>
+#include <asm/pgtable.h>
 #include <asm/msr.h>
 #include <asm/uaccess.h>
 
@@ -19,8 +20,6 @@
 #include <mach_apic.h>
 #endif
 
-extern int trap_init_f00f_bug(void);
-
 #ifdef CONFIG_X86_INTEL_USERCOPY
 /*
  * Alignment at which movsl is preferred for bulk memory copies.
@@ -95,6 +94,20 @@ static int __cpuinit num_cpu_cores(struc
 		return 1;
 }
 
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
+
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
Index: linux/arch/i386/kernel/traps.c
===================================================================
--- linux.orig/arch/i386/kernel/traps.c
+++ linux/arch/i386/kernel/traps.c
@@ -1180,20 +1180,6 @@ asmlinkage void math_emulate(long arg)
 
 #endif /* CONFIG_MATH_EMULATION */
 
-#ifdef CONFIG_X86_F00F_BUG
-void __init trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 /*
  * This needs to use 'idt_table' rather than 'idt', and
  * thus use the _nonmapped_ version of the IDT, as the
