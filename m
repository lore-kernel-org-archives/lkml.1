Return-Path: <linux-kernel-owner+w=401wt.eu-S1759949AbZCMRBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949AbZCMRBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758639AbZCMRAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:00:38 -0400
Received: from gw.goop.org ([64.81.55.164]:57363 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758111AbZCMRAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:00:37 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>, Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/27] xen: Allow unprivileged Xen domains to create iomap pages
Date: Fri, 13 Mar 2009 09:59:47 -0700
Message-Id: <1236963612-14287-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

PV DomU domains are allowed to map hardware MFNs for PCI passthrough,
but are not generally allowed to map raw machine pages.  In particular,
various pieces of code try to map DMI and ACPI tables in the ISA ROM
range.  We disallow _PAGE_IOMAP for those mappings, so that they are
redirected to a set of local zeroed pages we reserve for that purpose.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    6 +++---
 arch/x86/xen/mmu.c       |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f673cd8..0605f19 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -998,11 +998,11 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (xen_initial_domain())
-		__supported_pte_mask |= _PAGE_IOMAP;
-	else
+	if (!xen_initial_domain())
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
+	__supported_pte_mask |= _PAGE_IOMAP;
+
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 0a0cd61..58af0b0 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -49,6 +49,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/paravirt.h>
+#include <asm/e820.h>
 #include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
@@ -398,7 +399,7 @@ static bool xen_page_pinned(void *ptr)
 
 static bool xen_iomap_pte(pte_t pte)
 {
-	return xen_initial_domain() && (pte_flags(pte) & _PAGE_IOMAP);
+	return pte_flags(pte) & _PAGE_IOMAP;
 }
 
 static void xen_set_iomap_pte(pte_t *ptep, pte_t pteval)
@@ -600,10 +601,21 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
 pte_t xen_make_pte(pteval_t pte)
 {
-	if (unlikely(xen_initial_domain() && (pte & _PAGE_IOMAP)))
+	phys_addr_t addr = (pte & PTE_PFN_MASK);
+
+	/*
+	 * Unprivileged domains are allowed to do IOMAPpings for
+	 * PCI passthrough, but not map ISA space.  The ISA
+	 * mappings are just dummy local mappings to keep other
+	 * parts of the kernel happy.
+	 */
+	if (unlikely(pte & _PAGE_IOMAP) &&
+	    (xen_initial_domain() || addr >= ISA_END_ADDRESS)) {
 		pte = iomap_pte(pte);
-	else
+	} else {
+		pte &= ~_PAGE_IOMAP;
 		pte = pte_pfn_to_mfn(pte);
+	}
 
 	return native_make_pte(pte);
 }
-- 
1.6.0.6

