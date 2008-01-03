Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYACR16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYACR16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYACR1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:27:03 -0500
Received: from ns2.suse.de ([195.135.220.15]:54713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbYACR1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:27:01 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103626.635376000@suse.de>
In-Reply-To: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [3/8] GBPAGES: Split LARGE_PAGE_SIZE/MASK into PUD_PAGE_SIZE/PMD_PAGE_SIZE
Message-Id: <20080103172659.D2D7814DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:26:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Split the existing LARGE_PAGE_SIZE/MASK macro into two new macros
PUD_PAGE_SIZE/MASK and PMD_PAGE_SIZE/MASK. 

Fix up all callers to use the new names.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/boot/compressed/head_64.S |    4 ++--
 arch/x86/kernel/head_64.S          |    4 ++--
 arch/x86/kernel/pci-gart_64.c      |    2 +-
 arch/x86/mm/init_64.c              |    6 +++---
 arch/x86/mm/pageattr_64.c          |    4 ++--
 include/asm-x86/page_64.h          |    7 +++++--
 6 files changed, 15 insertions(+), 12 deletions(-)

Index: linux/include/asm-x86/page_64.h
===================================================================
--- linux.orig/include/asm-x86/page_64.h
+++ linux/include/asm-x86/page_64.h
@@ -29,8 +29,11 @@
 #define MCE_STACK 5
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
-#define LARGE_PAGE_MASK (~(LARGE_PAGE_SIZE-1))
-#define LARGE_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
+#define PMD_PAGE_SIZE (_AC(1,UL) << PMD_SHIFT)
+#define PMD_PAGE_MASK (~(PMD_PAGE_SIZE-1))
+
+#define PUD_PAGE_SIZE (_AC(1,UL) << PUD_SHIFT)
+#define PUD_PAGE_MASK (~(PUD_PAGE_SIZE-1))
 
 #define HPAGE_SHIFT PMD_SHIFT
 #define HPAGE_SIZE	(_AC(1,UL) << HPAGE_SHIFT)
Index: linux/arch/x86/boot/compressed/head_64.S
===================================================================
--- linux.orig/arch/x86/boot/compressed/head_64.S
+++ linux/arch/x86/boot/compressed/head_64.S
@@ -80,8 +80,8 @@ startup_32:
 
 #ifdef CONFIG_RELOCATABLE
 	movl	%ebp, %ebx
-	addl	$(LARGE_PAGE_SIZE -1), %ebx
-	andl	$LARGE_PAGE_MASK, %ebx
+	addl	$(PMD_PAGE_SIZE -1), %ebx
+	andl	$PMD_PAGE_MASK, %ebx
 #else
 	movl	$CONFIG_PHYSICAL_START, %ebx
 #endif
Index: linux/arch/x86/kernel/pci-gart_64.c
===================================================================
--- linux.orig/arch/x86/kernel/pci-gart_64.c
+++ linux/arch/x86/kernel/pci-gart_64.c
@@ -501,7 +501,7 @@ static __init unsigned long check_iommu_
 	}
 
 	a = aper + iommu_size;
-	iommu_size -= round_up(a, LARGE_PAGE_SIZE) - a;
+	iommu_size -= round_up(a, PMD_PAGE_SIZE) - a;
 
 	if (iommu_size < 64*1024*1024) {
 		printk(KERN_WARNING
Index: linux/arch/x86/kernel/head_64.S
===================================================================
--- linux.orig/arch/x86/kernel/head_64.S
+++ linux/arch/x86/kernel/head_64.S
@@ -63,7 +63,7 @@ startup_64:
 
 	/* Is the address not 2M aligned? */
 	movq	%rbp, %rax
-	andl	$~LARGE_PAGE_MASK, %eax
+	andl	$~PMD_PAGE_MASK, %eax
 	testl	%eax, %eax
 	jnz	bad_address
 
@@ -88,7 +88,7 @@ startup_64:
 
 	/* Add an Identity mapping if I am above 1G */
 	leaq	_text(%rip), %rdi
-	andq	$LARGE_PAGE_MASK, %rdi
+	andq	$PMD_PAGE_MASK, %rdi
 
 	movq	%rdi, %rax
 	shrq	$PUD_SHIFT, %rax
Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -416,10 +416,10 @@ __clear_kernel_mapping(unsigned long add
 {
 	unsigned long end = address + size;
 
-	BUG_ON(address & ~LARGE_PAGE_MASK);
-	BUG_ON(size & ~LARGE_PAGE_MASK); 
+	BUG_ON(address & ~PMD_PAGE_MASK);
+	BUG_ON(size & ~PMD_PAGE_MASK);
 	
-	for (; address < end; address += LARGE_PAGE_SIZE) { 
+	for (; address < end; address += PMD_PAGE_SIZE) {
 		pgd_t *pgd = pgd_offset_k(address);
 		pud_t *pud;
 		pmd_t *pmd;
Index: linux/arch/x86/mm/pageattr_64.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr_64.c
+++ linux/arch/x86/mm/pageattr_64.c
@@ -70,7 +70,7 @@ static struct page *split_large_page(uns
 	page_private(base) = 0;
 
 	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK; 
+	addr = address & PMD_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
 		pbase[i] = pfn_pte(addr >> PAGE_SHIFT, 
@@ -150,7 +150,7 @@ static void revert_page(unsigned long ad
 	BUG_ON(pud_none(*pud));
 	pmd = pmd_offset(pud, address);
 	BUG_ON(pmd_val(*pmd) & _PAGE_PSE);
-	pfn = (__pa(address) & LARGE_PAGE_MASK) >> PAGE_SHIFT;
+	pfn = (__pa(address) & PMD_PAGE_MASK) >> PAGE_SHIFT;
 	large_pte = pfn_pte(pfn, ref_prot);
 	large_pte = pte_mkhuge(large_pte);
 	set_pte((pte_t *)pmd, large_pte);
