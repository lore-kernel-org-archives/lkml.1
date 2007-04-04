Return-Path: <linux-kernel-owner+w=401wt.eu-S1946051AbXDDBiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946051AbXDDBiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966247AbXDDBfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:35:53 -0400
Received: from 250.sub-75-209-50.myvzw.com ([75.209.50.250]:34559 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966251AbXDDBfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:35:34 -0400
Message-Id: <20070404011453.344346341@goop.org>
References: <20070404010655.400913479@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 03 Apr 2007 18:06:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2/6] Remove noreplacement option
Content-Disposition: inline; filename=remove-noreplacement.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

noreplacement is dangerous on modern systems because it will not replace the
context switch FNSAVE with SSE aware FXSAVE. But other places in the kernel still assume
SSE and do FXSAVE and the CPU will then access FXSAVE information with
FNSAVE and cause corruption.

Easiest way to avoid this is to remove the option. It was mostly for paranoia
reasons anyways and alternative()s have been stable for some time.

Thanks to Jeremy F. for reporting and helping debug it.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/x86_64/boot-options.txt |    4 ----
 arch/i386/kernel/alternative.c        |   21 ++-------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

===================================================================
--- a/Documentation/x86_64/boot-options.txt
+++ b/Documentation/x86_64/boot-options.txt
@@ -305,7 +305,3 @@ Debugging
 			stuck (default)
 
 Miscellaneous
-
-  noreplacement  Don't replace instructions with more appropriate ones
-		 for the CPU. This may be useful on asymmetric MP systems
-		 where some CPUs have less capabilities than others.
===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -5,15 +5,9 @@
 #include <asm/alternative.h>
 #include <asm/sections.h>
 
-static int no_replacement    = 0;
 static int smp_alt_once      = 0;
 static int debug_alternative = 0;
 
-static int __init noreplacement_setup(char *s)
-{
-	no_replacement = 1;
-	return 1;
-}
 static int __init bootonly(char *str)
 {
 	smp_alt_once = 1;
@@ -25,7 +19,6 @@ static int __init debug_alt(char *str)
 	return 1;
 }
 
-__setup("noreplacement", noreplacement_setup);
 __setup("smp-alt-boot", bootonly);
 __setup("debug-alternative", debug_alt);
 
@@ -252,9 +245,6 @@ void alternatives_smp_module_add(struct 
 	struct smp_alt_module *smp;
 	unsigned long flags;
 
-	if (no_replacement)
-		return;
-
 	if (smp_alt_once) {
 		if (boot_cpu_has(X86_FEATURE_UP))
 			alternatives_smp_unlock(locks, locks_end,
@@ -289,7 +279,7 @@ void alternatives_smp_module_del(struct 
 	struct smp_alt_module *item;
 	unsigned long flags;
 
-	if (no_replacement || smp_alt_once)
+	if (smp_alt_once)
 		return;
 
 	spin_lock_irqsave(&smp_alt, flags);
@@ -320,7 +310,7 @@ void alternatives_smp_switch(int smp)
 	return;
 #endif
 
-	if (no_replacement || smp_alt_once)
+	if (smp_alt_once)
 		return;
 	BUG_ON(!smp && (num_online_cpus() > 1));
 
@@ -374,13 +364,6 @@ void __init alternative_instructions(voi
 void __init alternative_instructions(void)
 {
 	unsigned long flags;
-	if (no_replacement) {
-		printk(KERN_INFO "(SMP-)alternatives turned off\n");
-		free_init_pages("SMP alternatives",
-				__pa_symbol(&__smp_alt_begin),
-				__pa_symbol(&__smp_alt_end));
-		return;
-	}
 
 	local_irq_save(flags);
 	apply_alternatives(__alt_instructions, __alt_instructions_end);

-- 

