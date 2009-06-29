Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZF2ETl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZF2ETl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbZF2ETb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:19:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:48407 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZF2ETa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:19:30 -0400
Date: Mon, 29 Jun 2009 04:18:58 GMT
From: tip-bot for Akinobu Mita <akinobu.mita@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akinobu.mita@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akinobu.mita@gmail.com, mingo@elte.hu
In-Reply-To: <20090627063514.GA2834@localhost.localdomain>
References: <20090627063514.GA2834@localhost.localdomain>
Subject: [tip:x86/mm] x86: Clean up dump_pagetable()
Message-ID: <tip-087975b06b00af9bf888fab6f94ae113c5cd80bd@git.kernel.org>
Git-Commit-ID: 087975b06b00af9bf888fab6f94ae113c5cd80bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 04:18:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  087975b06b00af9bf888fab6f94ae113c5cd80bd
Gitweb:     http://git.kernel.org/tip/087975b06b00af9bf888fab6f94ae113c5cd80bd
Author:     Akinobu Mita <akinobu.mita@gmail.com>
AuthorDate: Sat, 27 Jun 2009 15:35:15 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 06:14:42 +0200

x86: Clean up dump_pagetable()

Use pgtable access helpers for 32-bit version dump_pagetable()
and get rid of __typeof__() operators. This needs to make
pmd_pfn() available for 2-level pgtable.

Also, remove some casts for 64-bit version dump_pagetable().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
LKML-Reference: <20090627063514.GA2834@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pgtable.h |   10 ++++----
 arch/x86/mm/fault.c            |   51 ++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..af5481e 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -134,6 +134,11 @@ static inline unsigned long pte_pfn(pte_t pte)
 	return (pte_val(pte) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
+static inline unsigned long pmd_pfn(pmd_t pmd)
+{
+	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)
@@ -422,11 +427,6 @@ static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 	return (pmd_t *)pud_page_vaddr(*pud) + pmd_index(address);
 }
 
-static inline unsigned long pmd_pfn(pmd_t pmd)
-{
-	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
-}
-
 static inline int pud_large(pud_t pud)
 {
 	return (pud_val(pud) & (_PAGE_PSE | _PAGE_PRESENT)) ==
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 78a5fff..9bf7e52 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -285,26 +285,25 @@ check_v8086_mode(struct pt_regs *regs, unsigned long address,
 		tsk->thread.screen_bitmap |= 1 << bit;
 }
 
-static void dump_pagetable(unsigned long address)
+static bool low_pfn(unsigned long pfn)
 {
-	__typeof__(pte_val(__pte(0))) page;
+	return pfn < max_low_pfn;
+}
 
-	page = read_cr3();
-	page = ((__typeof__(page) *) __va(page))[address >> PGDIR_SHIFT];
+static void dump_pagetable(unsigned long address)
+{
+	pgd_t *base = __va(read_cr3());
+	pgd_t *pgd = &base[pgd_index(address)];
+	pmd_t *pmd;
+	pte_t *pte;
 
 #ifdef CONFIG_X86_PAE
-	printk("*pdpt = %016Lx ", page);
-	if ((page >> PAGE_SHIFT) < max_low_pfn
-	    && page & _PAGE_PRESENT) {
-		page &= PAGE_MASK;
-		page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
-							& (PTRS_PER_PMD - 1)];
-		printk(KERN_CONT "*pde = %016Lx ", page);
-		page &= ~_PAGE_NX;
-	}
-#else
-	printk("*pde = %08lx ", page);
+	printk("*pdpt = %016Lx ", pgd_val(*pgd));
+	if (!low_pfn(pgd_val(*pgd) >> PAGE_SHIFT) || !pgd_present(*pgd))
+		goto out;
 #endif
+	pmd = pmd_offset(pud_offset(pgd, address), address);
+	printk(KERN_CONT "*pde = %0*Lx ", sizeof(*pmd) * 2, (u64)pmd_val(*pmd));
 
 	/*
 	 * We must not directly access the pte in the highpte
@@ -312,16 +311,12 @@ static void dump_pagetable(unsigned long address)
 	 * And let's rather not kmap-atomic the pte, just in case
 	 * it's allocated already:
 	 */
-	if ((page >> PAGE_SHIFT) < max_low_pfn
-	    && (page & _PAGE_PRESENT)
-	    && !(page & _PAGE_PSE)) {
-
-		page &= PAGE_MASK;
-		page = ((__typeof__(page) *) __va(page))[(address >> PAGE_SHIFT)
-							& (PTRS_PER_PTE - 1)];
-		printk("*pte = %0*Lx ", sizeof(page)*2, (u64)page);
-	}
+	if (!low_pfn(pmd_pfn(*pmd)) || !pmd_present(*pmd) || pmd_large(*pmd))
+		goto out;
 
+	pte = pte_offset_kernel(pmd, address);
+	printk("*pte = %0*Lx ", sizeof(*pte) * 2, (u64)pte_val(*pte));
+out:
 	printk("\n");
 }
 
@@ -449,16 +444,12 @@ static int bad_address(void *p)
 
 static void dump_pagetable(unsigned long address)
 {
-	pgd_t *pgd;
+	pgd_t *base = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+	pgd_t *pgd = base + pgd_index(address);
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 
-	pgd = (pgd_t *)read_cr3();
-
-	pgd = __va((unsigned long)pgd & PHYSICAL_PAGE_MASK);
-
-	pgd += pgd_index(address);
 	if (bad_address(pgd))
 		goto bad;
 
