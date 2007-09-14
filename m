Return-Path: <linux-kernel-owner+w=401wt.eu-S1759653AbXINU3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbXINU3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbXINU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:28:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52784 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854AbXINU26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:28:58 -0400
Date: Fri, 14 Sep 2007 22:30:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] i386: fix section mismatch warning in intel.c
Message-ID: <20070914203022.GB4554@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
diff --git a/arch/i386/kernel/cpu/intel.c b/arch/i386/kernel/cpu/intel.c
index dc4e081..ced6cea 100644
--- a/arch/i386/kernel/cpu/intel.c
+++ b/arch/i386/kernel/cpu/intel.c
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
@@ -95,6 +94,20 @@ static int __cpuinit num_cpu_cores(struct cpuinfo_x86 *c)
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
diff --git a/arch/i386/kernel/traps.c b/arch/i386/kernel/traps.c
index 47b0bef..5c499e2 100644
--- a/arch/i386/kernel/traps.c
+++ b/arch/i386/kernel/traps.c
@@ -1114,20 +1114,6 @@ asmlinkage void math_emulate(long arg)
 
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
