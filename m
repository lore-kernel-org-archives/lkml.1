Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXDEATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXDEATi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXDEARw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:52 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36895 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932212AbXDEARC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:02 -0400
Message-Id: <20070404191204.943212070@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:11:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 03/20] use paravirt_nop to consistently mark no-op operations
Content-Disposition: inline; filename=paravirt-nop.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a _paravirt_nop function for use as a stub for no-op operations,
and paravirt_nop #defined void * version to make using it easier
(since all its uses are as a void *).

This is useful to allow the patcher to automatically identify noop
operations so it can simply nop out the callsite.


Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
[mingo] but only as a cleanup of the current open-coded (void *) casts.
My problem with this is that it loses the types. Not that there is much
to check for, but still, this adds some assumptions about how function
calls look like

---
 arch/i386/kernel/paravirt.c |   26 +++++++++++++-------------
 include/asm-i386/paravirt.h |    3 +++
 2 files changed, 16 insertions(+), 13 deletions(-)

===================================================================
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -35,7 +35,7 @@
 #include <asm/timer.h>
 
 /* nop stub */
-static void native_nop(void)
+void _paravirt_nop(void)
 {
 }
 
@@ -490,7 +490,7 @@ struct paravirt_ops paravirt_ops = {
 
  	.patch = native_patch,
 	.banner = default_banner,
-	.arch_setup = native_nop,
+	.arch_setup = paravirt_nop,
 	.memory_setup = machine_specific_memory_setup,
 	.get_wallclock = native_get_wallclock,
 	.set_wallclock = native_set_wallclock,
@@ -546,25 +546,25 @@ struct paravirt_ops paravirt_ops = {
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
 #endif
-	.set_lazy_mode = (void *)native_nop,
+	.set_lazy_mode = paravirt_nop,
 
 	.flush_tlb_user = native_flush_tlb,
 	.flush_tlb_kernel = native_flush_tlb_global,
 	.flush_tlb_single = native_flush_tlb_single,
 
-	.map_pt_hook = (void *)native_nop,
-
-	.alloc_pt = (void *)native_nop,
-	.alloc_pd = (void *)native_nop,
-	.alloc_pd_clone = (void *)native_nop,
-	.release_pt = (void *)native_nop,
-	.release_pd = (void *)native_nop,
+	.map_pt_hook = paravirt_nop,
+
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
@@ -576,7 +576,7 @@ struct paravirt_ops paravirt_ops = {
 	.irq_enable_sysexit = native_irq_enable_sysexit,
 	.iret = native_iret,
 
-	.startup_ipi_hook = (void *)native_nop,
+	.startup_ipi_hook = paravirt_nop,
 };
 
 /*
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -430,6 +430,9 @@ static inline void pmd_clear(pmd_t *pmdp
 #define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
 
+void _paravirt_nop(void);
+#define paravirt_nop	((void *)_paravirt_nop)
+
 /* These all sit in the .parainstructions section to tell us what to patch. */
 struct paravirt_patch {
 	u8 *instr; 		/* original instructions */

-- 

