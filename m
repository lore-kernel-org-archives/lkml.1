Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYBAJfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYBAJfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbYBAJej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:34:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:29228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbYBAJea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="511603859"
Subject: [PATCH 2/4] x86: set_memory_xx enhancement
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Feb 2008 17:34:52 +0800
Message-Id: <1201858492.4051.18.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 01 Feb 2008 09:33:46.0796 (UTC) FILETIME=[8B3D2EC0:01C864B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes set_memory_xx can be used on arbitrary memory mapping
(besides identity mapping), such as memory mapped with ioremap. The
physical address is added to the set_memory_xx functions as another
parameter.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/pageattr-test.c  |    4 -
 arch/x86/mm/pageattr.c       |  164 ++++++++++++++++++++++++-------------------
 include/asm-x86/cacheflush.h |   21 +++--
 3 files changed, 109 insertions(+), 80 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -128,7 +128,9 @@ static unsigned long virt_to_highmap(voi
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
+static inline pgprot_t static_protections(pgprot_t prot,
+					  unsigned long virt_addr,
+					  unsigned long phys_addr)
 {
 	pgprot_t forbidden = __pgprot(0);
 
@@ -136,31 +138,31 @@ static inline pgprot_t static_protection
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(__pa(address), BIOS_BEGIN, BIOS_END))
+	if (within(phys_addr, BIOS_BEGIN, BIOS_END))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
 	 * Does not cover __inittext since that is gone later on
 	 */
-	if (within(address, (unsigned long)_text, (unsigned long)_etext))
+	if (within(virt_addr, (unsigned long)_text, (unsigned long)_etext))
 		pgprot_val(forbidden) |= _PAGE_NX;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within(address, virt_to_highmap(_text), virt_to_highmap(_etext)))
+	if (within(virt_addr, virt_to_highmap(_text), virt_to_highmap(_etext)))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 
 #ifdef CONFIG_DEBUG_RODATA
 	/* The .rodata section needs to be read-only */
-	if (within(address, (unsigned long)__start_rodata,
+	if (within(virt_addr, (unsigned long)__start_rodata,
 				(unsigned long)__end_rodata))
 		pgprot_val(forbidden) |= _PAGE_RW;
 	/*
 	 * Do the same for the x86-64 high kernel mapping
 	 */
-	if (within(address, virt_to_highmap(__start_rodata),
+	if (within(virt_addr, virt_to_highmap(__start_rodata),
 				virt_to_highmap(__end_rodata)))
 		pgprot_val(forbidden) |= _PAGE_RW;
 #endif
@@ -217,7 +219,8 @@ static void __set_pmd_pte(pte_t *kpte, u
 #endif
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(pte_t *kpte, unsigned long virt_addr,
+			    unsigned long phys_addr)
 {
 	pgprot_t ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 	gfp_t gfp_flags = GFP_KERNEL;
@@ -240,14 +243,13 @@ static int split_large_page(pte_t *kpte,
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = lookup_address(virt_addr, &level);
 	if (tmp != kpte) {
 		WARN_ON_ONCE(1);
 		goto out_unlock;
 	}
 
-	address = __pa(address);
-	addr = address & LARGE_PAGE_MASK;
+	addr = phys_addr & LARGE_PAGE_MASK;
 	pbase = (pte_t *)page_address(base);
 #ifdef CONFIG_X86_32
 	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
@@ -265,7 +267,7 @@ static int split_large_page(pte_t *kpte,
 	 * Architectures Software Developer's Manual).
 	 */
 	ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
-	__set_pmd_pte(kpte, address, mk_pte(base, ref_prot));
+	__set_pmd_pte(kpte, virt_addr, mk_pte(base, ref_prot));
 	base = NULL;
 
 out_unlock:
@@ -278,19 +280,16 @@ out_unlock:
 }
 
 static int
-__change_page_attr(unsigned long address, unsigned long pfn,
+__change_page_attr(unsigned long virt_addr, unsigned long phys_addr,
 		   pgprot_t mask_set, pgprot_t mask_clr)
 {
 	struct page *kpte_page;
+	unsigned long pfn = phys_addr >> PAGE_SHIFT;
 	int level, err = 0;
 	pte_t *kpte;
 
-#ifdef CONFIG_X86_32
-	BUG_ON(pfn > max_low_pfn);
-#endif
-
 repeat:
-	kpte = lookup_address(address, &level);
+	kpte = lookup_address(virt_addr, &level);
 	if (!kpte)
 		return -EINVAL;
 
@@ -305,14 +304,14 @@ repeat:
 		pgprot_val(new_prot) &= ~pgprot_val(mask_clr);
 		pgprot_val(new_prot) |= pgprot_val(mask_set);
 
-		new_prot = static_protections(new_prot, address);
+		new_prot = static_protections(new_prot, virt_addr, phys_addr);
 
 		new_pte = pfn_pte(pfn, canon_pgprot(new_prot));
 		BUG_ON(pte_pfn(new_pte) != pte_pfn(old_pte));
 
 		set_pte_atomic(kpte, new_pte);
 	} else {
-		err = split_large_page(kpte, address);
+		err = split_large_page(kpte, virt_addr, phys_addr);
 		if (!err)
 			goto repeat;
 	}
@@ -321,7 +320,7 @@ repeat:
 
 /**
  * change_page_attr_addr - Change page table attributes in linear mapping
- * @address: Virtual address in linear mapping.
+ * @virt_addr: Virtual address in linear mapping.
  * @prot:    New page table attribute (PAGE_*)
  *
  * Change page attributes of a page in the direct mapping. This is a variant
@@ -335,11 +334,9 @@ repeat:
 
 
 static int
-change_page_attr_addr(unsigned long address, pgprot_t mask_set,
-		      pgprot_t mask_clr)
+change_page_attr_addr(unsigned long virt_addr, unsigned long phys_addr,
+		      pgprot_t mask_set, pgprot_t mask_clr)
 {
-	unsigned long phys_addr = __pa(address);
-	unsigned long pfn = phys_addr >> PAGE_SHIFT;
 	int err;
 
 #ifdef CONFIG_X86_64
@@ -348,20 +345,21 @@ change_page_attr_addr(unsigned long addr
 	 * fixup the low mapping first. __va() returns the virtual
 	 * address in the linear mapping:
 	 */
-	if (within(address, HIGH_MAP_START, HIGH_MAP_END))
-		address = (unsigned long) __va(phys_addr);
+	if (within(virt_addr, HIGH_MAP_START, HIGH_MAP_END))
+		virt_addr = (unsigned long) __va(phys_addr);
 #endif
 
-	err = __change_page_attr(address, pfn, mask_set, mask_clr);
+	err = __change_page_attr(virt_addr, phys_addr, mask_set, mask_clr);
 	if (err)
 		return err;
 
 #ifdef CONFIG_X86_64
 	/*
-	 * If the physical address is inside the kernel map, we need
-	 * to touch the high mapped kernel as well:
+	 * If the virtual address is inside the linear mapped kernel
+	 * range, we need to touch the high mapped kernel as well:
 	 */
-	if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
+	if (within(virt_addr, (unsigned long)__va(0),
+		   (unsigned long)__va(KERNEL_TEXT_SIZE))) {
 		/*
 		 * Calc the high mapping address. See __phys_addr()
 		 * for the non obvious details.
@@ -369,27 +367,30 @@ change_page_attr_addr(unsigned long addr
 		 * Note that NX and other required permissions are
 		 * checked in static_protections().
 		 */
-		address = phys_addr + HIGH_MAP_START - phys_base;
+		virt_addr = phys_addr + HIGH_MAP_START - phys_base;
 
 		/*
 		 * Our high aliases are imprecise, because we check
 		 * everything between 0 and KERNEL_TEXT_SIZE, so do
 		 * not propagate lookup failures back to users:
 		 */
-		__change_page_attr(address, pfn, mask_set, mask_clr);
+		__change_page_attr(virt_addr, phys_addr, mask_set, mask_clr);
 	}
 #endif
 	return err;
 }
 
-static int __change_page_attr_set_clr(unsigned long addr, int numpages,
+static int __change_page_attr_set_clr(unsigned long virt_addr,
+				      unsigned long phys_addr, int numpages,
 				      pgprot_t mask_set, pgprot_t mask_clr)
 {
 	unsigned int i;
 	int ret;
 
-	for (i = 0; i < numpages ; i++, addr += PAGE_SIZE) {
-		ret = change_page_attr_addr(addr, mask_set, mask_clr);
+	for (i = 0; i < numpages ;
+	     i++, virt_addr += PAGE_SIZE, phys_addr += PAGE_SIZE) {
+		ret = change_page_attr_addr(virt_addr, phys_addr,
+					    mask_set, mask_clr);
 		if (ret)
 			return ret;
 	}
@@ -397,11 +398,12 @@ static int __change_page_attr_set_clr(un
 	return 0;
 }
 
-static int change_page_attr_set_clr(unsigned long addr, int numpages,
+static int change_page_attr_set_clr(unsigned long virt_addr,
+				    unsigned long phys_addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr)
 {
-	int ret = __change_page_attr_set_clr(addr, numpages, mask_set,
-					     mask_clr);
+	int ret = __change_page_attr_set_clr(virt_addr, phys_addr, numpages,
+					     mask_set, mask_clr);
 
 	/*
 	 * On success we use clflush, when the CPU supports it to
@@ -410,79 +412,93 @@ static int change_page_attr_set_clr(unsi
 	 * wbindv):
 	 */
 	if (!ret && cpu_has_clflush)
-		cpa_flush_range(addr, numpages);
+		cpa_flush_range(virt_addr, numpages);
 	else
 		cpa_flush_all();
 
 	return ret;
 }
 
-static inline int change_page_attr_set(unsigned long addr, int numpages,
-				       pgprot_t mask)
+static inline int change_page_attr_set(unsigned long virt_addr,
+				       unsigned long phys_addr,
+				       int numpages, pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0));
+	return change_page_attr_set_clr(virt_addr, phys_addr, numpages,
+					mask, __pgprot(0));
 }
 
-static inline int change_page_attr_clear(unsigned long addr, int numpages,
-					 pgprot_t mask)
+static inline int change_page_attr_clear(unsigned long virt_addr,
+					 unsigned long phys_addr,
+					 int numpages, pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
+	return change_page_attr_set_clr(virt_addr,  phys_addr, numpages,
+					__pgprot(0), mask);
 }
 
-int set_memory_uc(unsigned long addr, int numpages)
+int set_memory_uc(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
-	return change_page_attr_set(addr, numpages,
+	return change_page_attr_set(virt_addr, phys_addr, numpages,
 				    __pgprot(_PAGE_PCD | _PAGE_PWT));
 }
 EXPORT_SYMBOL(set_memory_uc);
 
-int set_memory_wb(unsigned long addr, int numpages)
+int set_memory_wb(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
-	return change_page_attr_clear(addr, numpages,
+	return change_page_attr_clear(virt_addr, phys_addr, numpages,
 				      __pgprot(_PAGE_PCD | _PAGE_PWT));
 }
 EXPORT_SYMBOL(set_memory_wb);
 
-int set_memory_x(unsigned long addr, int numpages)
+int set_memory_x(unsigned long virt_addr, unsigned long phys_addr,
+		 int numpages)
 {
 	if (__supported_pte_mask & _PAGE_NX)
-		return change_page_attr_clear(addr, numpages,
+		return change_page_attr_clear(virt_addr, phys_addr, numpages,
 					      __pgprot(_PAGE_NX));
 	else
 		return 0;
 }
 EXPORT_SYMBOL(set_memory_x);
 
-int set_memory_nx(unsigned long addr, int numpages)
+int set_memory_nx(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
 	if (__supported_pte_mask & _PAGE_NX)
-		return change_page_attr_set(addr, numpages,
+		return change_page_attr_set(virt_addr, phys_addr, numpages,
 					    __pgprot(_PAGE_NX));
 	else
 		return 0;
 }
 EXPORT_SYMBOL(set_memory_nx);
 
-int set_memory_ro(unsigned long addr, int numpages)
+int set_memory_ro(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_clear(virt_addr, phys_addr, numpages,
+				      __pgprot(_PAGE_RW));
 }
 
-int set_memory_rw(unsigned long addr, int numpages)
+int set_memory_rw(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
+	return change_page_attr_set(virt_addr, phys_addr, numpages,
+				    __pgprot(_PAGE_RW));
 }
 
-int set_memory_np(unsigned long addr, int numpages)
+int set_memory_np(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_PRESENT));
+	return change_page_attr_clear(virt_addr, phys_addr, numpages,
+				      __pgprot(_PAGE_PRESENT));
 }
 
 int set_pages_uc(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_uc(addr, numpages);
+	return set_memory_uc(addr, __pa(addr), numpages);
 }
 EXPORT_SYMBOL(set_pages_uc);
 
@@ -490,7 +506,7 @@ int set_pages_wb(struct page *page, int 
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_wb(addr, numpages);
+	return set_memory_wb(addr, __pa(addr), numpages);
 }
 EXPORT_SYMBOL(set_pages_wb);
 
@@ -498,7 +514,7 @@ int set_pages_x(struct page *page, int n
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_x(addr, numpages);
+	return set_memory_x(addr, __pa(addr), numpages);
 }
 EXPORT_SYMBOL(set_pages_x);
 
@@ -506,7 +522,7 @@ int set_pages_nx(struct page *page, int 
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_nx(addr, numpages);
+	return set_memory_nx(addr, __pa(addr), numpages);
 }
 EXPORT_SYMBOL(set_pages_nx);
 
@@ -514,28 +530,34 @@ int set_pages_ro(struct page *page, int 
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_ro(addr, numpages);
+	return set_memory_ro(addr, __pa(addr), numpages);
 }
 
 int set_pages_rw(struct page *page, int numpages)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return set_memory_rw(addr, numpages);
+	return set_memory_rw(addr, __pa(addr), numpages);
 }
 
 
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_CPA_DEBUG)
-static inline int __change_page_attr_set(unsigned long addr, int numpages,
+static inline int __change_page_attr_set(unsigned long virt_addr,
+					 unsigned long phys_addr,
+					 int numpages,
 					 pgprot_t mask)
 {
-	return __change_page_attr_set_clr(addr, numpages, mask, __pgprot(0));
+	return __change_page_attr_set_clr(virt_addr, phys_addr, numpages,
+					  mask, __pgprot(0));
 }
 
-static inline int __change_page_attr_clear(unsigned long addr, int numpages,
+static inline int __change_page_attr_clear(unsigned long virt_addr,
+					   unsigned long phys_addr,
+					   int numpages,
 					   pgprot_t mask)
 {
-	return __change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
+	return __change_page_attr_set_clr(virt_addr, phys_addr, numpages,
+					  __pgprot(0), mask);
 }
 #endif
 
@@ -545,7 +567,7 @@ static int __set_pages_p(struct page *pa
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return __change_page_attr_set(addr, numpages,
+	return __change_page_attr_set(addr, __pa(addr), numpages,
 				      __pgprot(_PAGE_PRESENT | _PAGE_RW));
 }
 
@@ -553,7 +575,7 @@ static int __set_pages_np(struct page *p
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
-	return __change_page_attr_clear(addr, numpages,
+	return __change_page_attr_clear(addr, __pa(addr), numpages,
 					__pgprot(_PAGE_PRESENT));
 }
 
--- a/include/asm-x86/cacheflush.h
+++ b/include/asm-x86/cacheflush.h
@@ -34,13 +34,20 @@ int set_pages_nx(struct page *page, int 
 int set_pages_ro(struct page *page, int numpages);
 int set_pages_rw(struct page *page, int numpages);
 
-int set_memory_uc(unsigned long addr, int numpages);
-int set_memory_wb(unsigned long addr, int numpages);
-int set_memory_x(unsigned long addr, int numpages);
-int set_memory_nx(unsigned long addr, int numpages);
-int set_memory_ro(unsigned long addr, int numpages);
-int set_memory_rw(unsigned long addr, int numpages);
-int set_memory_np(unsigned long addr, int numpages);
+int set_memory_uc(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
+int set_memory_wb(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
+int set_memory_x(unsigned long virt_addr, unsigned long phys_addr,
+		 int numpages);
+int set_memory_nx(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
+int set_memory_ro(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
+int set_memory_rw(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
+int set_memory_np(unsigned long virt_addr, unsigned long phys_addr,
+		  int numpages);
 
 void clflush_cache_range(void *addr, unsigned int size);
 
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -161,7 +161,7 @@ static __init int exercise_pageattr(void
 			continue;
 		}
 
-		err = change_page_attr_clear(addr[i], len[i],
+		err = __change_page_attr_clear(addr[i], __pa(addr[i]), len[i],
 					       __pgprot(_PAGE_GLOBAL));
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
@@ -195,7 +195,7 @@ static __init int exercise_pageattr(void
 			failed++;
 			continue;
 		}
-		err = change_page_attr_set(addr[i], len[i],
+		err = __change_page_attr_set(addr[i], __pa(addr[i]), len[i],
 					     __pgprot(_PAGE_GLOBAL));
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);

