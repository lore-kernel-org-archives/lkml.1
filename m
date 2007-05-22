Return-Path: <linux-kernel-owner+w=401wt.eu-S935441AbXEVPXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441AbXEVPXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759237AbXEVPT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:28 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4997
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965426AbXEVPTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:13 -0400
Message-Id: <20070522141250.783758019@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:42 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 01/33] xen: paravirt: add an "mm" argument to alloc_pt
Content-Disposition: inline; filename=paravirt-add-mm-to-alloc_pt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful to know which mm is allocating a pagetable.  Xen uses this
to determine whether the pagetable being added to is pinned or not.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/vmi.c      |    2 +-
 arch/i386/mm/init.c         |    2 +-
 arch/i386/mm/pageattr.c     |    2 +-
 include/asm-i386/paravirt.h |    8 ++++----
 include/asm-i386/pgalloc.h  |    6 +++---
 5 files changed, 10 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -361,7 +361,7 @@ static void *vmi_kmap_atomic_pte(struct 
 }
 #endif
 
-static void vmi_allocate_pt(u32 pfn)
+static void vmi_allocate_pt(struct mm_struct *mm, u32 pfn)
 {
 	vmi_set_page_type(pfn, VMI_PAGE_L1);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
===================================================================
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -87,7 +87,7 @@ static pte_t * __init one_page_table_ini
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
 
-		paravirt_alloc_pt(__pa(page_table) >> PAGE_SHIFT);
+		paravirt_alloc_pt(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
 		BUG_ON(page_table != pte_offset_kernel(pmd, 0));
 	}
===================================================================
--- a/arch/i386/mm/pageattr.c
+++ b/arch/i386/mm/pageattr.c
@@ -60,7 +60,7 @@ static struct page *split_large_page(uns
 	address = __pa(address);
 	addr = address & LARGE_PAGE_MASK; 
 	pbase = (pte_t *)page_address(base);
-	paravirt_alloc_pt(page_to_pfn(base));
+	paravirt_alloc_pt(&init_mm, page_to_pfn(base));
 	for (i = 0; i < PTRS_PER_PTE; i++, addr += PAGE_SIZE) {
                set_pte(&pbase[i], pfn_pte(addr >> PAGE_SHIFT,
                                           addr == address ? prot : ref_prot));
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -173,7 +175,7 @@ struct paravirt_ops
 				 unsigned long va);
 
 	/* Hooks for allocating/releasing pagetable pages */
-	void (*alloc_pt)(u32 pfn);
+	void (*alloc_pt)(struct mm_struct *mm, u32 pfn);
 	void (*alloc_pd)(u32 pfn);
 	void (*alloc_pd_clone)(u32 pfn, u32 clonepfn, u32 start, u32 count);
 	void (*release_pt)(u32 pfn);
@@ -738,9 +746,9 @@ static inline void flush_tlb_others(cpum
 	PVOP_VCALL3(flush_tlb_others, &cpumask, mm, va);
 }
 
-static inline void paravirt_alloc_pt(unsigned pfn)
-{
-	PVOP_VCALL1(alloc_pt, pfn);
+static inline void paravirt_alloc_pt(struct mm_struct *mm, unsigned pfn)
+{
+	PVOP_VCALL2(alloc_pt, mm, pfn);
 }
 static inline void paravirt_release_pt(unsigned pfn)
 {
===================================================================
--- a/include/asm-i386/pgalloc.h
+++ b/include/asm-i386/pgalloc.h
@@ -7,7 +7,7 @@
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else
-#define paravirt_alloc_pt(pfn) do { } while (0)
+#define paravirt_alloc_pt(mm, pfn) do { } while (0)
 #define paravirt_alloc_pd(pfn) do { } while (0)
 #define paravirt_alloc_pd(pfn) do { } while (0)
 #define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) do { } while (0)
@@ -17,13 +17,13 @@
 
 #define pmd_populate_kernel(mm, pmd, pte)			\
 do {								\
-	paravirt_alloc_pt(__pa(pte) >> PAGE_SHIFT);		\
+	paravirt_alloc_pt(mm, __pa(pte) >> PAGE_SHIFT);		\
 	set_pmd(pmd, __pmd(_PAGE_TABLE + __pa(pte)));		\
 } while (0)
 
 #define pmd_populate(mm, pmd, pte) 				\
 do {								\
-	paravirt_alloc_pt(page_to_pfn(pte));			\
+	paravirt_alloc_pt(mm, page_to_pfn(pte));		\
 	set_pmd(pmd, __pmd(_PAGE_TABLE +			\
 		((unsigned long long)page_to_pfn(pte) <<	\
 			(unsigned long long) PAGE_SHIFT)));	\

-- 

