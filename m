Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXJJOos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXJJOos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 10:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXJJOom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 10:44:42 -0400
Received: from saeurebad.de ([85.214.36.134]:60487 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXJJOol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 10:44:41 -0400
Date: Wed, 10 Oct 2007 16:44:36 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] i386 memory initialization cleanup
Message-ID: <20071010144436.GC32677@saeurebad.de>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i386 memory init cleanup

This patch improves code readability in the i386 memory initialization code
by refactoring, removal of needless casts, fixing of line width exceedings,
macro->inline function replacement, some comments and indentation correction.

Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

---
Note: Functionality was modified in set_kernel_exec(): It bails out if
lookup_address() fails to prevent a NULL pointer dereference.

 arch/i386/mm/init.c |  211 +++++++++++++++++++++++++++------------------------
 1 files changed, 113 insertions(+), 98 deletions(-)

diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
index dc3c03f..15a109e 100644
--- a/arch/i386/mm/init.c
+++ b/arch/i386/mm/init.c
@@ -64,13 +64,12 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
-		pmd_table = (pmd_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+		pmd_table = alloc_bootmem_low_pages(PAGE_SIZE);
 
 		paravirt_alloc_pd(__pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
-		if (pmd_table != pmd_offset(pud, 0))
-			BUG();
+		BUG_ON(pmd_table != pmd_offset(pud, 0));
 	}
 #endif
 	pud = pud_offset(pgd, 0);
@@ -85,7 +84,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 static pte_t * __init one_page_table_init(pmd_t *pmd)
 {
 	if (!(pmd_val(*pmd) & _PAGE_PRESENT)) {
-		pte_t *page_table = (pte_t *) alloc_bootmem_low_pages(PAGE_SIZE);
+		pte_t *page_table = alloc_bootmem_low_pages(PAGE_SIZE);
 
 		paravirt_alloc_pt(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
@@ -106,27 +105,25 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
  * so we can cache the place of the first one and move around without
  * checking the pgd every time.
  */
-static void __init page_table_range_init (unsigned long start, unsigned long end, pgd_t *pgd_base)
-{
-	pgd_t *pgd;
-	pmd_t *pmd;
-	int pgd_idx, pmd_idx;
-	unsigned long vaddr;
-
-	vaddr = start;
-	pgd_idx = pgd_index(vaddr);
-	pmd_idx = pmd_index(vaddr);
-	pgd = pgd_base + pgd_idx;
-
-	for ( ; (pgd_idx < PTRS_PER_PGD) && (vaddr != end); pgd++, pgd_idx++) {
-		pmd = one_md_table_init(pgd);
-		pmd = pmd + pmd_index(vaddr);
-		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end); pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+static void __init page_table_range_init(unsigned long start,
+					 unsigned long end, pgd_t *pgd_base)
+{
+	unsigned long vaddr = start;
+	int pgd_idx = pgd_index(start);
+	int pmd_idx = pmd_index(start);
+	pgd_t *pgd = pgd_base + pgd_idx;
 
+	while (pgd_idx < PTRS_PER_PGD && vaddr != end) {
+		pmd_t *pmd = one_md_table_init(pgd) + pmd_index(vaddr);
+		while (pmd_idx < PTRS_PER_PMD && vaddr != end) {
+			one_page_table_init(pmd);
 			vaddr += PMD_SIZE;
+			pmd++;
+			pmd_idx++;
 		}
 		pmd_idx = 0;
+		pgd++;
+		pgd_idx++;
 	}
 }
 
@@ -137,6 +134,43 @@ static inline int is_kernel_text(unsigned long addr)
 	return 0;
 }
 
+static void __init kernel_pmd_init(pmd_t *pmd, unsigned long *pfnp)
+{
+	unsigned long pfn = *pfnp;
+	unsigned int addr = pfn * PAGE_SIZE + PAGE_OFFSET;
+
+	/* Map with big pages if possible, otherwise create normal
+	 * page tables. */
+	if (cpu_has_pse) {
+		unsigned int addr2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE +
+			PAGE_OFFSET + PAGE_SIZE - 1;
+
+		if (is_kernel_text(addr) || is_kernel_text(addr2))
+			set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+		else
+			set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
+
+		pfn += PTRS_PER_PTE;
+	} else {
+		int pte_ofs = 0;
+		pte_t *pte = one_page_table_init(pmd);
+
+		while (pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn) {
+			if (is_kernel_text(addr))
+				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
+			else
+				set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+
+			pte++;
+			pte_ofs++;
+			pfn++;
+			addr += PAGE_SIZE;
+		}
+	}
+
+	*pfnp = pfn;
+}
+
 /*
  * This maps the physical memory to kernel virtual address space, a total
  * of max_low_pfn pages, by creating page tables starting from address
@@ -144,45 +178,25 @@ static inline int is_kernel_text(unsigned long addr)
  */
 static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 {
-	unsigned long pfn;
-	pgd_t *pgd;
-	pmd_t *pmd;
-	pte_t *pte;
-	int pgd_idx, pmd_idx, pte_ofs;
+	unsigned long pfn = 0;
+	int pgd_idx = pgd_index(PAGE_OFFSET);
+	pgd_t *pgd = pgd_base + pgd_idx;
 
-	pgd_idx = pgd_index(PAGE_OFFSET);
-	pgd = pgd_base + pgd_idx;
-	pfn = 0;
+	while (pgd_idx < PTRS_PER_PGD) {
+		int pmd_idx = 0;
+		pmd_t *pmd = one_md_table_init(pgd);
 
-	for (; pgd_idx < PTRS_PER_PGD; pgd++, pgd_idx++) {
-		pmd = one_md_table_init(pgd);
 		if (pfn >= max_low_pfn)
 			continue;
-		for (pmd_idx = 0; pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn; pmd++, pmd_idx++) {
-			unsigned int address = pfn * PAGE_SIZE + PAGE_OFFSET;
-
-			/* Map with big pages if possible, otherwise create normal page tables. */
-			if (cpu_has_pse) {
-				unsigned int address2 = (pfn + PTRS_PER_PTE - 1) * PAGE_SIZE + PAGE_OFFSET + PAGE_SIZE-1;
-				if (is_kernel_text(address) || is_kernel_text(address2))
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
-				else
-					set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE));
-
-				pfn += PTRS_PER_PTE;
-			} else {
-				pte = one_page_table_init(pmd);
-
-				for (pte_ofs = 0;
-				     pte_ofs < PTRS_PER_PTE && pfn < max_low_pfn;
-				     pte++, pfn++, pte_ofs++, address += PAGE_SIZE) {
-					if (is_kernel_text(address))
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL_EXEC));
-					else
-						set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
-				}
-			}
+
+		while (pmd_idx < PTRS_PER_PMD && pfn < max_low_pfn) {
+			kernel_pmd_init(pmd, &pfn);
+			pmd++;
+			pmd_idx++;
 		}
+
+		pgd++;
+		pgd_idx++;
 	}
 }
 
@@ -236,36 +250,30 @@ int page_is_ram(unsigned long pagenr)
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
 
-#define kmap_get_fixmap_pte(vaddr)					\
-	pte_offset_kernel(pmd_offset(pud_offset(pgd_offset_k(vaddr), vaddr), (vaddr)), (vaddr))
+static inline pte_t kmap_get_pte(pgd_t *pgd, unsigned long addr)
+{
+	pud_t *pud = pud_offset(pgd, addr);
+	pmd_t *pmd = pmd_offset(pud, addr);
+
+	return pte_offset_kernel(pmd, addr);
+}
 
 static void __init kmap_init(void)
 {
-	unsigned long kmap_vstart;
+	unsigned long kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
 
 	/* cache the first kmap pte */
-	kmap_vstart = __fix_to_virt(FIX_KMAP_BEGIN);
-	kmap_pte = kmap_get_fixmap_pte(kmap_vstart);
-
+	kmap_pte = kmap_get_fixmap_pte(pgd_offset_k(kmap_vstart), kmap_vstart);
 	kmap_prot = PAGE_KERNEL;
 }
 
 static void __init permanent_kmaps_init(pgd_t *pgd_base)
 {
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long vaddr;
-
-	vaddr = PKMAP_BASE;
-	page_table_range_init(vaddr, vaddr + PAGE_SIZE*LAST_PKMAP, pgd_base);
-
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	pud = pud_offset(pgd, vaddr);
-	pmd = pmd_offset(pud, vaddr);
-	pte = pte_offset_kernel(pmd, vaddr);
-	pkmap_page_table = pte;
+	page_table_range_init(PKMAP_BASE,
+			      PKMAP_BASE + PAGE_SIZE * LAST_PKMAP,
+			      pgd_base);
+	pkmap_page_table = kmap_get_pte(swapper_pg_dir + pgd_index(PKMAP_BASE),
+					PKMAP_BASE);
 }
 
 static void __meminit free_new_highpage(struct page *page)
@@ -284,7 +292,8 @@ void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 		SetPageReserved(page);
 }
 
-static int __meminit add_one_highpage_hotplug(struct page *page, unsigned long pfn)
+static int __meminit add_one_highpage_hotplug(struct page *page,
+					      unsigned long pfn)
 {
 	free_new_highpage(page);
 	totalram_pages++;
@@ -527,16 +536,18 @@ static void __init set_nx(void)
 int __init set_kernel_exec(unsigned long vaddr, int enable)
 {
 	pte_t *pte;
-	int ret = 1;
+	int prev;
 
 	if (!nx_enabled)
-		goto out;
+		return 1;
 
 	pte = lookup_address(vaddr);
-	BUG_ON(!pte);
+	if (!pte) {
+		BUG();
+		return 1;
+	}
 
-	if (!pte_exec_kernel(*pte))
-		ret = 0;
+	prev = pte_exec_kernel(*pte);
 
 	if (enable)
 		pte->pte_high &= ~(1 << (_PAGE_BIT_NX - 32));
@@ -544,11 +555,11 @@ int __init set_kernel_exec(unsigned long vaddr, int enable)
 		pte->pte_high |= 1 << (_PAGE_BIT_NX - 32);
 	pte_update_defer(&init_mm, vaddr, pte);
 	__flush_tlb_all();
-out:
-	return ret;
+
+	return prev;
 }
 
-#endif
+#endif /* CONFIG_X86_PAE */
 
 /*
  * paging_init() sets up the page tables - note that the first 8MB are
@@ -591,7 +602,8 @@ void __init paging_init(void)
 
 static void __init test_wp_bit(void)
 {
-	printk("Checking if this processor honours the WP bit even in supervisor mode... ");
+	printk("Checking if this processor honours the WP bit "
+	       "even in supervisor mode... ");
 
 	/* Any page-aligned address will do, the test is non-destructive */
 	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
@@ -601,7 +613,8 @@ static void __init test_wp_bit(void)
 	if (!boot_cpu_data.wp_works_ok) {
 		printk("No.\n");
 #ifdef CONFIG_X86_WP_WORKS_OK
-		panic("This kernel doesn't support CPU's with broken WP. Recompile it for a 386!");
+		panic("This kernel doesn't support CPU's with broken WP. "
+		      "Recompile it for a 386!");
 #endif
 	} else {
 		printk("Ok.\n");
@@ -626,9 +639,11 @@ void __init mem_init(void)
 #ifdef CONFIG_HIGHMEM
 	/* check that fixmap and pkmap do not overlap */
 	if (PKMAP_BASE+LAST_PKMAP*PAGE_SIZE >= FIXADDR_START) {
-		printk(KERN_ERR "fixmap and kmap areas overlap - this will crash\n");
+		printk(KERN_ERR "fixmap and kmap areas overlap "
+		       "- this will crash\n");
 		printk(KERN_ERR "pkstart: %lxh pkend: %lxh fixstart %lxh\n",
-				PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE, FIXADDR_START);
+		       PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
+		       FIXADDR_START);
 		BUG();
 	}
 #endif
@@ -654,15 +669,15 @@ void __init mem_init(void)
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		   VMALLOC_END-VMALLOC_START);
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk reserved, %dk data, %dk init, %ldk highmem)\n",
-		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
-		num_physpages << (PAGE_SHIFT-10),
-		codesize >> 10,
-		reservedpages << (PAGE_SHIFT-10),
-		datasize >> 10,
-		initsize >> 10,
-		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10))
-	       );
+	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, "
+	       "%dk reserved, %dk data, %dk init, %ldk highmem)\n",
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       num_physpages << (PAGE_SHIFT-10),
+	       codesize >> 10,
+	       reservedpages << (PAGE_SHIFT-10),
+	       datasize >> 10,
+	       initsize >> 10,
+	       (unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
 
 #if 1 /* double-sanity-check paranoia */
 	printk("virtual kernel memory layout:\n"
@@ -826,7 +841,7 @@ void mark_rodata_ro(void)
 	 */
 	global_flush_tlb();
 }
-#endif
+#endif /* CONFIG_DEBUG_RODATA */
 
 void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
