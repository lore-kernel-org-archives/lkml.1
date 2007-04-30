Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXD3Kav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXD3Kav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXD3K3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:42933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbXD3K1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:43 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/40] i386: use paravirt_nop to consistently mark no-op operations
Message-Id: <20070430102735.DA522151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Add a _paravirt_nop function for use as a stub for no-op operations,
and paravirt_nop #defined void * version to make using it easier
(since all its uses are as a void *).

This is useful to allow the patcher to automatically identify noop
operations so it can simply nop out the callsite.


Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
[mingo] but only as a cleanup of the current open-coded (void *) casts.
My problem with this is that it loses the types. Not that there is much
to check for, but still, this adds some assumptions about how function
calls look like

---
 arch/i386/kernel/paravirt.c |   24 ++++++++++++------------
 include/asm-i386/paravirt.h |    3 +++
 2 files changed, 15 insertions(+), 12 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -35,7 +35,7 @@
 #include <asm/timer.h>
 
 /* nop stub */
-static void native_nop(void)
+void _paravirt_nop(void)
 {
 }
 
@@ -207,7 +207,7 @@ struct paravirt_ops paravirt_ops = {
 
  	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = native_nop,
+	.arch_setup = paravirt_nop,
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
@@ -263,25 +263,25 @@ struct paravirt_ops paravirt_ops = {
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 #endif
-	.set_lazy_mode = (void *)native_nop,
+	.set_lazy_mode = paravirt_nop,
 
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 
-	.map_pt_hook = (void *)native_nop,
+	.map_pt_hook = paravirt_nop,
 
-	.alloc_pt = (void *)native_nop,
-	.alloc_pd = (void *)native_nop,
-	.alloc_pd_clone = (void *)native_nop,
-	.release_pt = (void *)native_nop,
-	.release_pd = (void *)native_nop,
+	.alloc_pt = paravirt_nop,
+	.alloc_pd = paravirt_nop,
+	.alloc_pd_clone = paravirt_nop,
+	.release_pt = paravirt_nop,
+	.release_pd = paravirt_nop,
 
 	.set_pte = native_set_pte,
 	.set_pte_at = native_set_pte_at,
 	.set_pmd = native_set_pmd,
-	.pte_update = (void *)native_nop,
-	.pte_update_defer = (void *)native_nop,
+	.pte_update = paravirt_nop,
+	.pte_update_defer = paravirt_nop,
 #ifdef CONFIG_X86_PAE
 	.set_pte_atomic = native_set_pte_atomic,
 	.set_pte_present = native_set_pte_present,
@@ -293,7 +293,7 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
-	.startup_ipi_hook = (void *)native_nop,
+	.startup_ipi_hook = paravirt_nop,
 };
 
 /*
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -434,6 +434,9 @@ static inline void pmd_clear(pmd_t *pmdp
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
 #define arch_flush_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_FLUSH)
 
+void _paravirt_nop(void);
+#define paravirt_nop	((void *)_paravirt_nop)
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
 	u8 *instr; 		/* original instructions */
