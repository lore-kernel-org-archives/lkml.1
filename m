Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbZEHAOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbZEHAOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZEHAKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:05 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52708
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbZEHAJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:55 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/11] xen: Allow unprivileged Xen domains to create iomap pages
Date: Thu,  7 May 2009 14:45:28 -0700
Message-Id: <1241732737-7669-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Impact: prep for pcifront

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
index 2d0341f..a4e78ae 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1000,11 +1000,11 @@ asmlinkage void __init xen_start_kernel(void)
 
 	/* Prevent unwanted bits from being set in PTEs. */
 	__supported_pte_mask &= ~_PAGE_GLOBAL;
-	if (xen_initial_domain())
-		__supported_pte_mask |= _PAGE_IOMAP;
-	else
+	if (!xen_initial_domain())
 		__supported_pte_mask &= ~(_PAGE_PWT | _PAGE_PCD);
 
+	__supported_pte_mask |= _PAGE_IOMAP;
+
 #ifdef CONFIG_X86_64
 	/* Work out if we support NX */
 	check_efer();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 55da7f9..d673b03 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -49,6 +49,7 @@
 #include <asm/mmu_context.h>
 #include <asm/setup.h>
 #include <asm/paravirt.h>
+#include <asm/e820.h>
 #include <asm/linkage.h>
 
 #include <asm/xen/hypercall.h>
@@ -378,7 +379,7 @@ static bool xen_page_pinned(void *ptr)
 
 static bool xen_iomap_pte(pte_t pte)
 {
-	return xen_initial_domain() && (pte_flags(pte) & _PAGE_IOMAP);
+	return pte_flags(pte) & _PAGE_IOMAP;
 }
 
 static void xen_set_iomap_pte(pte_t *ptep, pte_t pteval)
@@ -580,10 +581,21 @@ PV_CALLEE_SAVE_REGS_THUNK(xen_pgd_val);
 
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

