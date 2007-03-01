Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXCAKsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXCAKsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964936AbXCAKsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:48:18 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47443 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964935AbXCAKsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:48:17 -0500
Date: Thu, 1 Mar 2007 11:48:17 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] arch/i386/xen/: possible cleanups
Message-ID: <20070301104817.GB10921@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- every file should #include the headers containing the prototypes for
  it's global functions
  - the xen_set_pud() prototype mismatch gcc was now able to detect
    is corrected
- make the following needlessly global variable static:
  - events.c: virq_to_irq[]
- make the following needlessly global functions static:
  - setup.c: xen_idle()
  - events.c: mask_evtchn()
  - events.c: unmask_evtchn()
  - mmu.c: xen_pgd_unpin()
- remove the following unused variables:
  - setup.c: pfn_to_mfn_frame_list
  - setup.c: pfn_to_mfn_frame_list_list
- #if 0 the following unused global function:
  - mmu.c: xen_set_pte_atomic()
- remove the following empty unused global functions:
  - mmu.c: xen_pte_update()
  - mmu.c: xen_pte_update_defer()
- remove the following unused EXPORT_SYMBOL:
  - setup.c: HYPERVISOR_shared_info

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: Can we get a MAINTAINERS entry for Xen?

 arch/i386/xen/events.c |    9 ++++-----
 arch/i386/xen/mmu.c    |   16 ++++++----------
 arch/i386/xen/mmu.h    |    4 ----
 arch/i386/xen/setup.c  |    6 +++---
 4 files changed, 13 insertions(+), 22 deletions(-)

--- linux-2.6.20-mm2/arch/i386/xen/setup.c.old	2007-02-26 23:15:34.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/xen/setup.c	2007-02-28 01:04:40.000000000 +0100
@@ -14,6 +14,8 @@
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
 
+#include "xen-ops.h"
+
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
@@ -25,10 +27,8 @@
  * page as soon as fixmap is up and running.
  */
 struct shared_info *HYPERVISOR_shared_info = &init_shared;
-EXPORT_SYMBOL(HYPERVISOR_shared_info);
 
 unsigned long *phys_to_machine_mapping;
-unsigned long *pfn_to_mfn_frame_list_list, *pfn_to_mfn_frame_list[16];
 EXPORT_SYMBOL(phys_to_machine_mapping);
 
 /**
@@ -45,7 +45,7 @@
 	return "Xen";
 }
 
-void xen_idle(void)
+static void xen_idle(void)
 {
 	local_irq_disable();
 
--- linux-2.6.20-mm2/arch/i386/xen/events.c.old	2007-03-01 01:12:52.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/xen/events.c	2007-03-01 01:14:38.000000000 +0100
@@ -8,6 +8,7 @@
 #include <asm/irq.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/events.h>
 #include <xen/interface/xen.h>
@@ -22,7 +23,7 @@
 static DEFINE_SPINLOCK(irq_mapping_update_lock);
 
 /* IRQ <-> VIRQ mapping. */
-DEFINE_PER_CPU(int, virq_to_irq[NR_VIRQS]) = {[0 ... NR_VIRQS-1] = -1};
+static DEFINE_PER_CPU(int, virq_to_irq[NR_VIRQS]) = {[0 ... NR_VIRQS-1] = -1};
 
 /* Packed IRQ information: binding type, sub-type index, and event channel. */
 struct packed_irq
@@ -158,14 +159,13 @@
 }
 EXPORT_SYMBOL_GPL(notify_remote_via_irq);
 
-void mask_evtchn(int port)
+static void mask_evtchn(int port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
 	sync_set_bit(port, &s->evtchn_mask[0]);
 }
-EXPORT_SYMBOL_GPL(mask_evtchn);
 
-void unmask_evtchn(int port)
+static void unmask_evtchn(int port)
 {
 	struct shared_info *s = HYPERVISOR_shared_info;
 	unsigned int cpu = smp_processor_id();
@@ -192,7 +192,6 @@
 				   &vcpu_info->evtchn_pending_sel))
 		vcpu_info->evtchn_upcall_pending = 1;
 }
-EXPORT_SYMBOL_GPL(unmask_evtchn);
 
 static int find_unbound_irq(void)
 {
--- linux-2.6.20-mm2/arch/i386/xen/mmu.h.old	2007-03-01 01:22:08.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/xen/mmu.h	2007-03-01 01:23:27.000000000 +0100
@@ -9,8 +9,6 @@
 void fastcall xen_set_pte_at(struct mm_struct *mm, u32 addr,
 			     pte_t *ptep, pte_t pteval);
 void fastcall xen_set_pmd(pmd_t *pmdp, pmd_t pmdval);
-void fastcall xen_pte_update(struct mm_struct *mm, u32 addr, pte_t *ptep);
-void fastcall xen_pte_update_defer(struct mm_struct *mm, u32 addr, pte_t *ptep);
 
 fastcall void xen_activate_mm(struct mm_struct *prev, struct mm_struct *next);
 fastcall void xen_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm);
@@ -19,7 +17,6 @@
 fastcall pte_t xen_ptep_get_and_clear(pte_t *ptep);
 
 void xen_pgd_pin(pgd_t *pgd);
-void xen_pgd_unpin(pgd_t *pgd);
 
 #ifdef CONFIG_X86_PAE
 fastcall unsigned long long xen_pte_val(pte_t);
@@ -32,7 +29,6 @@
 
 fastcall void xen_set_pte_at(struct mm_struct *mm, u32 addr,
 			     pte_t *ptep, pte_t pteval);
-fastcall void xen_set_pte_atomic(pte_t *ptep, pte_t pte);
 fastcall void xen_set_pud(pud_t *ptr, pud_t val);
 fastcall void xen_pte_clear(struct mm_struct *mm, u32 addr,pte_t *ptep);
 fastcall void xen_pmd_clear(pmd_t *pmdp);
--- linux-2.6.20-mm2/arch/i386/xen/mmu.c.old	2007-03-01 01:16:08.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/xen/mmu.c	2007-03-01 01:23:33.000000000 +0100
@@ -11,6 +11,8 @@
 #include <xen/page.h>
 #include <xen/interface/xen.h>
 
+#include "mmu.h"
+
 xmaddr_t arbitrary_virt_to_machine(unsigned long address)
 {
 	pte_t *pte = lookup_address(address);
@@ -83,7 +85,7 @@
 }
 
 #ifdef CONFIG_X86_PAE
-fastcall void xen_set_pud(pmd_t *ptr, pud_t val)
+fastcall void xen_set_pud(pud_t *ptr, pud_t val)
 {
 	struct mmu_update u;
 
@@ -139,19 +141,13 @@
 		xen_set_pte(ptep, pteval);
 }
 
-void fastcall xen_pte_update(struct mm_struct *mm, u32 addr, pte_t *ptep)
-{
-}
-
-void fastcall xen_pte_update_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
-{
-}
-
 #ifdef CONFIG_X86_PAE
+#if 0
 void fastcall xen_set_pte_atomic(pte_t *ptep, pte_t pte)
 {
 	set_64bit((u64 *)ptep, pte_val_ma(pte));
 }
+#endif  /*  0  */
 
 void fastcall xen_pte_clear(struct mm_struct *mm, u32 addr,pte_t *ptep)
 {
@@ -369,7 +365,7 @@
 }
 
 /* Release a pagetables pages back as normal RW */
-void xen_pgd_unpin(pgd_t *pgd)
+static void xen_pgd_unpin(pgd_t *pgd)
 {
 	struct mmuext_op op;
 

