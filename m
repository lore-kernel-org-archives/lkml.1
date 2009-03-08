Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZCHS5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZCHS5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 14:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754676AbZCHS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 14:56:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:33742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZCHS4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 14:56:39 -0400
Date: Sun, 8 Mar 2009 18:54:49 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, penberg@cs.helsinki.fi,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B1C47C.5080401@kernel.org>
References: <49B1C47C.5080401@kernel.org>
Subject: [tip:kmemcheck] x86: introduce bootmem_state
Message-ID: <tip-4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e@git.kernel.org>
Git-Commit-ID: 4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 08 Mar 2009 18:54:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
Gitweb:     http://git.kernel.org/tip/4c76c04421dfe7be3e5a1d8ab1b2a3be0b02558e
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Fri, 6 Mar 2009 16:49:00 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Mar 2009 19:43:09 +0100

x86: introduce bootmem_state

Impact: cleanup

extend after_bootmem and after_init_bootmem to bootmem_state
and will have BEFORE_BOOTMEM, DURING_BOOTMEM, AFTER_BOOTMEM

v2: style changes according to ingo
v3: move bootmem_state declaring to arch/x86/include

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <49B1C47C.5080401@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/page_types.h |    8 ++++++++
 arch/x86/kernel/setup.c           |    1 +
 arch/x86/mm/init.c                |   13 +++++++------
 arch/x86/mm/init_32.c             |   28 ++++++++++++++++++++--------
 arch/x86/mm/init_64.c             |   33 +++++++++++++++++++--------------
 5 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 826ad37..f8b9c88 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -40,6 +40,14 @@
 
 #ifndef __ASSEMBLY__
 
+enum bootmem_state {
+	BEFORE_BOOTMEM,
+	DURING_BOOTMEM,
+	AFTER_BOOTMEM
+};
+
+extern enum bootmem_state bootmem_state;
+
 extern int page_is_ram(unsigned long pagenr);
 extern int devmem_is_allowed(unsigned long pagenr);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f28c56e..ce9e888 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -885,6 +885,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	initmem_init(0, max_pfn);
+	bootmem_state = DURING_BOOTMEM;
 
 #ifdef CONFIG_ACPI_SLEEP
 	/*
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index a8d2933..f98b501 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -14,7 +14,7 @@ unsigned long __initdata e820_table_start;
 unsigned long __meminitdata e820_table_end;
 unsigned long __meminitdata e820_table_top;
 
-int after_bootmem;
+enum bootmem_state bootmem_state = BEFORE_BOOTMEM;
 
 int direct_gbpages
 #ifdef CONFIG_DIRECT_GBPAGES
@@ -143,7 +143,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 
 	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
 
-	if (!after_bootmem)
+	if (bootmem_state == BEFORE_BOOTMEM)
 		init_gbpages();
 
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
@@ -283,7 +283,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * memory mapped. Unfortunately this is done currently before the
 	 * nodes are discovered.
 	 */
-	if (!after_bootmem)
+	if (bootmem_state == BEFORE_BOOTMEM)
 		find_early_table_space(end, use_pse, use_gbpages);
 
 #ifdef CONFIG_X86_32
@@ -304,16 +304,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 #endif
 
 #ifdef CONFIG_X86_64
-	if (!after_bootmem)
+	if (bootmem_state == BEFORE_BOOTMEM)
 		mmu_cr4_features = read_cr4();
 #endif
 	__flush_tlb_all();
 
-	if (!after_bootmem && e820_table_end > e820_table_start)
+	if (bootmem_state == BEFORE_BOOTMEM &&
+	    e820_table_end > e820_table_start)
 		reserve_early(e820_table_start << PAGE_SHIFT,
 				 e820_table_end << PAGE_SHIFT, "PGTABLE");
 
-	if (!after_bootmem)
+	if (bootmem_state == BEFORE_BOOTMEM)
 		early_memtest(start, end);
 
 	return ret >> PAGE_SHIFT;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index ccadfb1..34ef5c7 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -82,14 +82,20 @@ static __init void *alloc_low_page(void)
 static pmd_t * __init one_md_table_init(pgd_t *pgd)
 {
 	pud_t *pud;
-	pmd_t *pmd_table;
+	pmd_t *pmd_table = NULL;
 
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
-		if (after_bootmem)
+		switch (bootmem_state) {
+		case DURING_BOOTMEM:
 			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
-		else
+			break;
+		case BEFORE_BOOTMEM:
 			pmd_table = (pmd_t *)alloc_low_page();
+			break;
+		default:
+			panic("after bootmem call one_md_table_init\n");
+		}
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -113,15 +119,21 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
 		pte_t *page_table = NULL;
 
-		if (after_bootmem) {
+		switch (bootmem_state) {
+		case DURING_BOOTMEM:
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 			page_table = (pte_t *) alloc_bootmem_pages(PAGE_SIZE);
 #endif
 			if (!page_table)
 				page_table =
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
-		} else
+			break;
+		case BEFORE_BOOTMEM:
 			page_table = (pte_t *)alloc_low_page();
+			break;
+		default:
+			panic("after bootmem call one_page_table_init\n");
+		}
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
@@ -169,7 +181,7 @@ static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
 		pte_t *newpte;
 		int i;
 
-		BUG_ON(after_bootmem);
+		BUG_ON(bootmem_state != BEFORE_BOOTMEM);
 		newpte = alloc_low_page();
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			set_pte(newpte + i, pte[i]);
@@ -855,8 +867,6 @@ void __init setup_bootmem_allocator(void)
 		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
 						 bootmap);
 	}
-
-	after_bootmem = 1;
 }
 
 /*
@@ -923,6 +933,8 @@ void __init mem_init(void)
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
+	bootmem_state = AFTER_BOOTMEM;
+
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
 		/*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e127f2e..20ade92 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -140,20 +140,26 @@ __setup("noexec32=", nonx32_setup);
 
 /*
  * NOTE: This function is marked __ref because it calls __init function
- * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
+ * (alloc_bootmem_pages). It's safe to do it ONLY when DURING_BOOTMEM.
  */
 static __ref void *spp_getpage(void)
 {
-	void *ptr;
+	void *ptr = NULL;
 
-	if (after_bootmem)
+	switch (bootmem_state) {
+	case AFTER_BOOTMEM:
 		ptr = (void *) get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
-	else
+		break;
+	case DURING_BOOTMEM:
 		ptr = alloc_bootmem_pages(PAGE_SIZE);
+		break;
+	default:
+		panic("calling spp_getpage before bootmem\n");
+	}
 
 	if (!ptr || ((unsigned long)ptr & ~PAGE_MASK)) {
 		panic("set_pte_phys: cannot allocate page data %s\n",
-			after_bootmem ? "after bootmem" : "");
+			bootmem_state == AFTER_BOOTMEM ? "after bootmem" : "");
 	}
 
 	pr_debug("spp_getpage %p\n", ptr);
@@ -320,16 +326,17 @@ void __init cleanup_highmap(void)
 
 static __ref void *alloc_low_page(unsigned long *phys)
 {
-	unsigned long pfn = e820_table_end++;
+	unsigned long pfn;
 	void *adr;
 
-	if (after_bootmem) {
+	if (bootmem_state == AFTER_BOOTMEM) {
 		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
 		*phys = __pa(adr);
 
 		return adr;
 	}
 
+	pfn = e820_table_end++;
 	if (pfn >= e820_table_top)
 		panic("alloc_low_page: ran out of memory");
 
@@ -341,7 +348,7 @@ static __ref void *alloc_low_page(unsigned long *phys)
 
 static __ref void unmap_low_page(void *adr)
 {
-	if (after_bootmem)
+	if (bootmem_state == AFTER_BOOTMEM)
 		return;
 
 	early_iounmap(adr, PAGE_SIZE);
@@ -360,7 +367,7 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
 
 		if (addr >= end) {
-			if (!after_bootmem) {
+			if (bootmem_state != AFTER_BOOTMEM) {
 				for(; i < PTRS_PER_PTE; i++, pte++)
 					set_pte(pte, __pte(0));
 			}
@@ -416,7 +423,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 		pgprot_t new_prot = prot;
 
 		if (address >= end) {
-			if (!after_bootmem) {
+			if (bootmem_state != AFTER_BOOTMEM) {
 				for (; i < PTRS_PER_PMD; i++, pmd++)
 					set_pmd(pmd, __pmd(0));
 			}
@@ -502,7 +509,7 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 		if (addr >= end)
 			break;
 
-		if (!after_bootmem &&
+		if (bootmem_state != AFTER_BOOTMEM &&
 				!e820_any_mapped(addr, addr+PUD_SIZE, 0)) {
 			set_pud(pud, __pud(0));
 			continue;
@@ -693,8 +700,6 @@ void __init mem_init(void)
 
 	/* clear_bss() already clear the empty_zero_page */
 
-	reservedpages = 0;
-
 	/* this will put all low memory onto the freelists */
 #ifdef CONFIG_NUMA
 	totalram_pages = numa_free_all_bootmem();
@@ -702,9 +707,9 @@ void __init mem_init(void)
 	totalram_pages = free_all_bootmem();
 #endif
 
+	bootmem_state = AFTER_BOOTMEM;
 	absent_pages = absent_pages_in_range(0, max_pfn);
 	reservedpages = max_pfn - totalram_pages - absent_pages;
-	after_bootmem = 1;
 
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
