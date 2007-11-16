Return-Path: <linux-kernel-owner+w=401wt.eu-S933469AbXKPVnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbXKPVnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764486AbXKPVmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:42:51 -0500
Received: from [198.99.130.12] ([198.99.130.12]:59846 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXKPVmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:42:49 -0500
Date: Fri, 16 Nov 2007 16:42:27 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 7/8] UML - add virt_to_pte
Message-ID: <20071116214227.GA13877@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Turn um_virt_to_phys into virt_to_pte, cleaning up a horrid interface.

It's also made non-static and declared in pgtable.h because it'll be
needed when the stubs get a vma.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/skas/uaccess.c |   56 +++++++++++++++++-------------------------
 include/asm-um/pgtable.h      |    3 ++
 2 files changed, 26 insertions(+), 33 deletions(-)

Index: linux-2.6.22/arch/um/kernel/skas/uaccess.c
===================================================================
--- linux-2.6.22.orig/arch/um/kernel/skas/uaccess.c	2007-11-16 15:16:54.000000000 -0500
+++ linux-2.6.22/arch/um/kernel/skas/uaccess.c	2007-11-16 15:40:25.000000000 -0500
@@ -13,70 +13,60 @@
 #include "kern_util.h"
 #include "os.h"
 
-static void *um_virt_to_phys(struct task_struct *task, unsigned long addr,
-			     pte_t *pte_out)
+pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
-	pte_t ptent;
 
-	if (task->mm == NULL)
-		return ERR_PTR(-EINVAL);
-	pgd = pgd_offset(task->mm, addr);
+	if (mm == NULL)
+		return NULL;
+
+	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	pud = pud_offset(pgd, addr);
 	if (!pud_present(*pud))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd))
-		return ERR_PTR(-EINVAL);
-
-	pte = pte_offset_kernel(pmd, addr);
-	ptent = *pte;
-	if (!pte_present(ptent))
-		return ERR_PTR(-EINVAL);
+		return NULL;
 
-	if (pte_out != NULL)
-		*pte_out = ptent;
-	return (void *) (pte_val(ptent) & PAGE_MASK) + (addr & ~PAGE_MASK);
+	return pte_offset_kernel(pmd, addr);
 }
 
-static unsigned long maybe_map(unsigned long virt, int is_write)
+static pte_t *maybe_map(unsigned long virt, int is_write)
 {
-	pte_t pte;
-	int err;
+	pte_t *pte = virt_to_pte(current->mm, virt);
+	int err, dummy_code;
 
-	void *phys = um_virt_to_phys(current, virt, &pte);
-	int dummy_code;
-
-	if (IS_ERR(phys) || (is_write && !pte_write(pte))) {
+	if ((pte == NULL) || !pte_present(*pte) ||
+	    (is_write && !pte_write(*pte))) {
 		err = handle_page_fault(virt, 0, is_write, 1, &dummy_code);
 		if (err)
-			return -1UL;
-		phys = um_virt_to_phys(current, virt, NULL);
+			return NULL;
+		pte = virt_to_pte(current->mm, virt);
 	}
-	if (IS_ERR(phys))
-		phys = (void *) -1;
+	if (!pte_present(*pte))
+		pte = NULL;
 
-	return (unsigned long) phys;
+	return pte;
 }
 
 static int do_op_one_page(unsigned long addr, int len, int is_write,
 		 int (*op)(unsigned long addr, int len, void *arg), void *arg)
 {
 	struct page *page;
+	pte_t *pte;
 	int n;
 
-	addr = maybe_map(addr, is_write);
-	if (addr == -1UL)
+	pte = maybe_map(addr, is_write);
+	if (pte == NULL)
 		return -1;
 
-	page = phys_to_page(addr);
+	page = pte_page(*pte);
 	addr = (unsigned long) kmap_atomic(page, KM_UML_USERCOPY) +
 		(addr & ~PAGE_MASK);
 
Index: linux-2.6.22/include/asm-um/pgtable.h
===================================================================
--- linux-2.6.22.orig/include/asm-um/pgtable.h	2007-11-16 15:35:38.000000000 -0500
+++ linux-2.6.22/include/asm-um/pgtable.h	2007-11-16 15:39:44.000000000 -0500
@@ -323,6 +323,9 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_unmap(pte) do { } while (0)
 #define pte_unmap_nested(pte) do { } while (0)
 
+struct mm_struct;
+extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
+
 #define update_mmu_cache(vma,address,pte) do ; while (0)
 
 /* Encode and de-code a swap entry */
