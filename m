Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbYHLVYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbYHLVYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYHLVX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:23:58 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:46149 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYHLVX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bz+6pGnK8byI2gdr801VctKsOhZHzPJ1Xz05cqAryLza7cuHl+9rJi55VI7sIIOPMk
         QSKTrIqu9V0p6TjBArHbH8CXUjMxoGd7ceC0Rm5DHr+YJ12vEZ7PBkOnkHL3CbB1F1jp
         +mac0XA07PxztDXru0mX2+D3l+7PO2SZHqLVY=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [PATCH] x86: fix section mismatch warning - spp_getpage()
Date: Tue, 12 Aug 2008 23:23:04 +0200
Message-Id: <1218576186-31442-2-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x17a3e): Section mismatch in reference from the function set_pte_vaddr_pud() to the function .init.text:spp_getpage()
The function set_pte_vaddr_pud() references
the function __init spp_getpage().
This is often because set_pte_vaddr_pud lacks a __init
annotation or the annotation of spp_getpage is wrong.

mark set_pte_vaddr_pud __init and all functions calling it

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/init_64.c    |    4 ++--
 arch/x86/mm/pgtable.c    |    4 ++--
 arch/x86/mm/pgtable_32.c |    2 +-
 arch/x86/xen/enlighten.c |    2 +-
 arch/x86/xen/mmu.c       |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 129618c..486c93c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -107,7 +107,7 @@ static __init void *spp_getpage(void)
 	return ptr;
 }
 
-void
+void __init
 set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 {
 	pud_t *pud;
@@ -147,7 +147,7 @@ set_pte_vaddr_pud(pud_t *pud_page, unsigned long vaddr, pte_t new_pte)
 	__flush_tlb_one(vaddr);
 }
 
-void
+void __init
 set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 {
 	pgd_t *pgd;
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index d503027..de44260 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -317,7 +317,7 @@ int ptep_clear_flush_young(struct vm_area_struct *vma,
 
 int fixmaps_set;
 
-void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
+void __init __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 {
 	unsigned long address = __fix_to_virt(idx);
 
@@ -329,7 +329,7 @@ void __native_set_fixmap(enum fixed_addresses idx, pte_t pte)
 	fixmaps_set++;
 }
 
-void native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
+void __init native_set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 {
 	__native_set_fixmap(idx, pfn_pte(phys >> PAGE_SHIFT, flags));
 }
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index cab0abb..62d4dd4 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -24,7 +24,7 @@
  * Associate a virtual page frame with a given physical page frame 
  * and protection flags for that frame.
  */ 
-void set_pte_vaddr(unsigned long vaddr, pte_t pteval)
+void __init set_pte_vaddr(unsigned long vaddr, pte_t pteval)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9ff6e3c..d7f8807 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1114,7 +1114,7 @@ static unsigned xen_patch(u8 type, u16 clobbers, void *insnbuf,
 	return ret;
 }
 
-static void xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
+static void __init xen_set_fixmap(unsigned idx, unsigned long phys, pgprot_t prot)
 {
 	pte_t pte;
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index aa37469..1f444c3 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -288,7 +288,7 @@ void xen_set_pmd(pmd_t *ptr, pmd_t val)
  * Associate a virtual page frame with a given physical page frame
  * and protection flags for that frame.
  */
-void set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
+void __init set_pte_mfn(unsigned long vaddr, unsigned long mfn, pgprot_t flags)
 {
 	set_pte_vaddr(vaddr, mfn_pte(mfn, flags));
 }
-- 
1.5.4.5

