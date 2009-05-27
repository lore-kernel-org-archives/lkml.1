Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbZE0HZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbZE0HZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762109AbZE0HY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:24:58 -0400
Received: from claw.goop.org ([74.207.240.146]:33555 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762094AbZE0HY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:24:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/10] xen: Allow unprivileged Xen domains to create iomap pages
Date: Wed, 27 May 2009 00:24:34 -0700
Message-Id: <1243409082-21349-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409082-21349-1-git-send-email-jeremy@goop.org>
References: <1243409082-21349-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

PV DomU domains are allowed to map hardware MFNs for PCI passthrough,
but are not generally allowed to map raw machine pages.  In particular,
various pieces of code try to map DMI and ACPI tables in the ISA ROM
range.  We disallow _PAGE_IOMAP for those mappings, so that they are
redirected to a set of local zeroed pages we reserve for that purpose.

[ Impact: prevent passthrough of ISA space, as we only allow PCI ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |    6 +++---
 arch/x86/xen/mmu.c       |   18 +++++++++++++++---
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 12e4d9c..adb4fe0 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1051,11 +1051,11 @@ asmlinkage void __init xen_start_kernel(void)
 
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
index 331e52d..370e1b8 100644
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

