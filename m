Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYFQSn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYFQSn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbYFQSml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:42:41 -0400
Received: from gw.goop.org ([64.81.55.164]:51611 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758246AbYFQSmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:42:40 -0400
Message-ID: <48580577.2040505@goop.org>
Date: Tue, 17 Jun 2008 11:41:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86: implement set_pte_vaddr
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-name set_pte_pfn() to set_pte_vaddr(), taking a pte_t rather than
pfn/flags, and expose it.  This allows the pte to constructed in
arbitrary ways, rather than just via __pte(), which may be necessary
in a virtual environment.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/init_64.c     |    9 ++++-----
 arch/x86/mm/pgtable.c     |    2 +-
 arch/x86/mm/pgtable_32.c  |    6 +++---
 include/asm-x86/pgtable.h |    3 +++
 4 files changed, 11 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -136,15 +136,15 @@ static __init void *spp_getpage(void)
 	return ptr;
 }
 
-static void
-set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
+void
+set_pte_vaddr(unsigned long vaddr, pte_t new_pte)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte, new_pte;
+	pte_t *pte;
 
-	pr_debug("set_pte_phys %lx to %lx\n", vaddr, phys);
+	pr_debug("set_pte_vaddr %lx to %lx\n", vaddr, native_pte_val(new_pte));
 
 	pgd = pgd_offset_k(vaddr);
 	if (pgd_none(*pgd)) {
@@ -171,7 +171,6 @@ set_pte_phys(unsigned long vaddr, unsign
 			return;
 		}
 	}
-	new_pte = pfn_pte(phys >> PAGE_SHIFT, prot);
 
 	pte = pte_offset_kernel(pmd, vaddr);
 	if (!pte_none(*pte) && pte_val(new_pte) &&
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
===================================================================
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -285,6 +285,6 @@ void __set_fixmap (enum fixed_addresses 
 		BUG();
 		return;
 	}
-	set_pte_pfn(address, phys >> PAGE_SHIFT, flags);
+	set_pte_vaddr(address, pfn_pte(phys >> PAGE_SHIFT, flags));
 	fixmaps_set++;
 }
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
===================================================================
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -71,7 +71,7 @@ void show_mem(void)
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
  */ 
-static void set_pte_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
+void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -94,8 +94,8 @@ static void set_pte_pfn(unsigned long va
 		return;
 	}
 	pte = pte_offset_kernel(pmd, vaddr);
-	if (pgprot_val(flags))
-		set_pte_present(&init_mm, vaddr, pte, pfn_pte(pfn, flags));
+	if (pte_val(pteval))
+		set_pte_present(&init_mm, vaddr, pte, pteval);
 	else
 		pte_clear(&init_mm, vaddr, pte);
 
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
===================================================================
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -313,6 +313,9 @@ int phys_mem_access_prot_allowed(struct 
                               unsigned long size, pgprot_t *vma_prot);
 #endif
 
+/* Install a pte for a particular vaddr in kernel space. */
+void set_pte_vaddr(unsigned long vaddr, pte_t pte);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else  /* !CONFIG_PARAVIRT */


