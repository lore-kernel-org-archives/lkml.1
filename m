Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYBRUWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYBRUWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYBRUWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:22:06 -0500
Received: from www.tglx.de ([62.245.132.106]:58196 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYBRUWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:22:03 -0500
Date: Mon, 18 Feb 2008 21:21:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] x86 updates
Message-ID: <alpine.LFD.1.00.0802182108250.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 updates from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

The updates are:

    - fix the fallout of the CPA changes. This fixes the review issues
      and some other problems, which were discovered by extended
      testcases.

    - fix for NUMA systems were node 0 is not online

    - lguest build fix which Rusty asked us to merge

Thanks,
	tglx
---

Rusty Russell (1):
      x86: fix lguest build failure

Thomas Gleixner (4):
      x86: CPA, fix alias checks
      x86: zap invalid and unused pmds in early boot
      x86: CPA no alias checking for _NX
      x86: CPA: avoid double checking of alias ranges

Yinghai Lu (1):
      x86: reenable support for system without on node0

 arch/x86/kernel/asm-offsets_32.c |    6 +-
 arch/x86/kernel/head64.c         |    3 +
 arch/x86/kernel/head_64.S        |    7 +-
 arch/x86/mm/init_64.c            |   27 +++++
 arch/x86/mm/numa_64.c            |    5 +-
 arch/x86/mm/pageattr.c           |  208 ++++++++++++++++++++------------------
 include/asm-x86/pgtable_64.h     |    1 +
 7 files changed, 154 insertions(+), 103 deletions(-)
diff --git a/arch/x86/kernel/asm-offsets_32.c b/arch/x86/kernel/asm-offsets_32.c
index afd8446..a33d530 100644
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -20,10 +20,8 @@
 
 #include <xen/interface/xen.h>
 
-#ifdef CONFIG_LGUEST_GUEST
 #include <linux/lguest.h>
 #include "../../../drivers/lguest/lg.h"
-#endif
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -134,6 +132,10 @@ void foo(void)
 	BLANK();
 	OFFSET(LGUEST_DATA_irq_enabled, lguest_data, irq_enabled);
 	OFFSET(LGUEST_DATA_pgdir, lguest_data, pgdir);
+#endif
+
+#ifdef CONFIG_LGUEST
+	BLANK();
 	OFFSET(LGUEST_PAGES_host_gdt_desc, lguest_pages, state.host_gdt_desc);
 	OFFSET(LGUEST_PAGES_host_idt_desc, lguest_pages, state.host_idt_desc);
 	OFFSET(LGUEST_PAGES_host_cr3, lguest_pages, state.host_cr3);
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 24dbf56..ad24408 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -88,6 +88,9 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	/* Make NULL pointers segfault */
 	zap_identity_mappings();
 
+	/* Cleanup the over mapped high alias */
+	cleanup_highmap();
+
 	for (i = 0; i < IDT_ENTRIES; i++) {
 #ifdef CONFIG_EARLY_PRINTK
 		set_intr_gate(i, &early_idt_handlers[i]);
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 09b38d5..53e5820 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -107,8 +107,13 @@ startup_64:
 	movq	%rdx, 0(%rbx, %rax, 8)
 ident_complete:
 
-	/* Fixup the kernel text+data virtual addresses
+	/*
+	 * Fixup the kernel text+data virtual addresses. Note that
+	 * we might write invalid pmds, when the kernel is relocated
+	 * cleanup_highmap() fixes this up along with the mappings
+	 * beyond _end.
 	 */
+
 	leaq	level2_kernel_pgt(%rip), %rdi
 	leaq	4096(%rdi), %r8
 	/* See if it is a valid page table entry */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a4a9ccc..bb652f5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -171,6 +171,33 @@ set_pte_phys(unsigned long vaddr, unsigned long phys, pgprot_t prot)
 	__flush_tlb_one(vaddr);
 }
 
+/*
+ * The head.S code sets up the kernel high mapping from:
+ * __START_KERNEL_map to __START_KERNEL_map + KERNEL_TEXT_SIZE
+ *
+ * phys_addr holds the negative offset to the kernel, which is added
+ * to the compile time generated pmds. This results in invalid pmds up
+ * to the point where we hit the physaddr 0 mapping.
+ *
+ * We limit the mappings to the region from _text to _end.  _end is
+ * rounded up to the 2MB boundary. This catches the invalid pmds as
+ * well, as they are located before _text:
+ */
+void __init cleanup_highmap(void)
+{
+	unsigned long vaddr = __START_KERNEL_map;
+	unsigned long end = round_up((unsigned long)_end, PMD_SIZE) - 1;
+	pmd_t *pmd = level2_kernel_pgt;
+	pmd_t *last_pmd = pmd + PTRS_PER_PMD;
+
+	for (; pmd < last_pmd; pmd++, vaddr += PMD_SIZE) {
+		if (!pmd_present(*pmd))
+			continue;
+		if (vaddr < (unsigned long) _text || vaddr > end)
+			set_pmd(pmd, __pmd(0));
+	}
+}
+
 /* NOTE: this is meant to be run only at boot */
 void __init
 __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t prot)
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 1aecc65..59898fb 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -494,11 +494,13 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	int i;
 
 	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, end_pfn))
 		return;
 	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
@@ -506,6 +508,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 					  end_pfn << PAGE_SHIFT))
 		return;
 	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
@@ -513,6 +516,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 					end_pfn<<PAGE_SHIFT))
 		return;
 	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
 #endif
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
@@ -524,7 +528,6 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	memnode_shift = 63;
 	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
-	nodes_clear(node_online_map);
 	node_set_online(0);
 	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 4119379..3ee1499 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -16,6 +16,7 @@
 #include <asm/sections.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
+#include <asm/proto.h>
 
 /*
  * The current flushing context - we pass it instead of 5 arguments:
@@ -26,8 +27,23 @@ struct cpa_data {
 	pgprot_t	mask_clr;
 	int		numpages;
 	int		flushtlb;
+	unsigned long	pfn;
 };
 
+#ifdef CONFIG_X86_64
+
+static inline unsigned long highmap_start_pfn(void)
+{
+	return __pa(_text) >> PAGE_SHIFT;
+}
+
+static inline unsigned long highmap_end_pfn(void)
+{
+	return __pa(round_up((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
+}
+
+#endif
+
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -123,29 +139,14 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
 	}
 }
 
-#define HIGH_MAP_START	__START_KERNEL_map
-#define HIGH_MAP_END	(__START_KERNEL_map + KERNEL_TEXT_SIZE)
-
-
-/*
- * Converts a virtual address to a X86-64 highmap address
- */
-static unsigned long virt_to_highmap(void *address)
-{
-#ifdef CONFIG_X86_64
-	return __pa((unsigned long)address) + HIGH_MAP_START - phys_base;
-#else
-	return (unsigned long)address;
-#endif
-}
-
 /*
  * Certain areas of memory on x86 require very specific protection flags,
  * for example the BIOS area or kernel text. Callers don't always get this
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
+static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
+				   unsigned long pfn)
 {
 	pgprot_t forbidden = __pgprot(0);
 
@@ -153,30 +154,23 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address)
 	 * The BIOS area between 640k and 1Mb needs to be executable for
 	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
 	 */
-	if (within(__pa(address), BIOS_BEGIN, BIOS_END))
+	if (within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_NX;
 
 	/*
 	 * The kernel text needs to be executable for obvious reasons
-	 * Does not cover __inittext since that is gone later on
+	 * Does not cover __inittext since that is gone later on. On
+	 * 64bit we do not enforce !NX on the low mapping
 	 */
 	if (within(address, (unsigned long)_text, (unsigned long)_etext))
 		pgprot_val(forbidden) |= _PAGE_NX;
-	/*
-	 * Do the same for the x86-64 high kernel mapping
-	 */
-	if (within(address, virt_to_highmap(_text), virt_to_highmap(_etext)))
-		pgprot_val(forbidden) |= _PAGE_NX;
 
-	/* The .rodata section needs to be read-only */
-	if (within(address, (unsigned long)__start_rodata,
-				(unsigned long)__end_rodata))
-		pgprot_val(forbidden) |= _PAGE_RW;
 	/*
-	 * Do the same for the x86-64 high kernel mapping
+	 * The .rodata section needs to be read-only. Using the pfn
+	 * catches all aliases.
 	 */
-	if (within(address, virt_to_highmap(__start_rodata),
-				virt_to_highmap(__end_rodata)))
+	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
+		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
 		pgprot_val(forbidden) |= _PAGE_RW;
 
 	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
@@ -253,7 +247,7 @@ static int
 try_preserve_large_page(pte_t *kpte, unsigned long address,
 			struct cpa_data *cpa)
 {
-	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr;
+	unsigned long nextpage_addr, numpages, pmask, psize, flags, addr, pfn;
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot;
 	int i, do_split = 1;
@@ -301,7 +295,15 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 
 	pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
-	new_prot = static_protections(new_prot, address);
+
+	/*
+	 * old_pte points to the large page base address. So we need
+	 * to add the offset of the virtual address:
+	 */
+	pfn = pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
+	cpa->pfn = pfn;
+
+	new_prot = static_protections(new_prot, address, pfn);
 
 	/*
 	 * We need to check the full range, whether
@@ -309,8 +311,9 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * the pages in the range we try to preserve:
 	 */
 	addr = address + PAGE_SIZE;
-	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE) {
-		pgprot_t chk_prot = static_protections(new_prot, addr);
+	pfn++;
+	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
+		pgprot_t chk_prot = static_protections(new_prot, addr, pfn);
 
 		if (pgprot_val(chk_prot) != pgprot_val(new_prot))
 			goto out_unlock;
@@ -505,46 +508,51 @@ out_unlock:
 	return 0;
 }
 
-static int __change_page_attr(unsigned long address, struct cpa_data *cpa)
+static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
+	unsigned long address = cpa->vaddr;
 	int do_split, err;
 	unsigned int level;
 	struct page *kpte_page;
-	pte_t *kpte;
+	pte_t *kpte, old_pte;
 
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
+		return primary ? -EINVAL : 0;
+
+	old_pte = *kpte;
+	if (!pte_val(old_pte)) {
+		if (!primary)
+			return 0;
+		printk(KERN_WARNING "CPA: called for zero pte. "
+		       "vaddr = %lx cpa->vaddr = %lx\n", address,
+		       cpa->vaddr);
+		WARN_ON(1);
 		return -EINVAL;
+	}
 
 	kpte_page = virt_to_page(kpte);
 	BUG_ON(PageLRU(kpte_page));
 	BUG_ON(PageCompound(kpte_page));
 
 	if (level == PG_LEVEL_4K) {
-		pte_t new_pte, old_pte = *kpte;
+		pte_t new_pte;
 		pgprot_t new_prot = pte_pgprot(old_pte);
-
-		if(!pte_val(old_pte)) {
-			printk(KERN_WARNING "CPA: called for zero pte. "
-			       "vaddr = %lx cpa->vaddr = %lx\n", address,
-				cpa->vaddr);
-			WARN_ON(1);
-			return -EINVAL;
-		}
+		unsigned long pfn = pte_pfn(old_pte);
 
 		pgprot_val(new_prot) &= ~pgprot_val(cpa->mask_clr);
 		pgprot_val(new_prot) |= pgprot_val(cpa->mask_set);
 
-		new_prot = static_protections(new_prot, address);
+		new_prot = static_protections(new_prot, address, pfn);
 
 		/*
 		 * We need to keep the pfn from the existing PTE,
 		 * after all we're only going to change it's attributes
 		 * not the memory it points to
 		 */
-		new_pte = pfn_pte(pte_pfn(old_pte), canon_pgprot(new_prot));
-
+		new_pte = pfn_pte(pfn, canon_pgprot(new_prot));
+		cpa->pfn = pfn;
 		/*
 		 * Do we really change anything ?
 		 */
@@ -581,67 +589,59 @@ repeat:
 	return err;
 }
 
-/**
- * change_page_attr_addr - Change page table attributes in linear mapping
- * @address: Virtual address in linear mapping.
- * @prot:    New page table attribute (PAGE_*)
- *
- * Change page attributes of a page in the direct mapping. This is a variant
- * of change_page_attr() that also works on memory holes that do not have
- * mem_map entry (pfn_valid() is false).
- *
- * See change_page_attr() documentation for more details.
- *
- * Modules and drivers should use the set_memory_* APIs instead.
- */
-static int change_page_attr_addr(struct cpa_data *cpa)
+static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias);
+
+static int cpa_process_alias(struct cpa_data *cpa)
 {
-	int err;
-	unsigned long address = cpa->vaddr;
+	struct cpa_data alias_cpa;
+	int ret = 0;
 
-#ifdef CONFIG_X86_64
-	unsigned long phys_addr = __pa(address);
+	if (cpa->pfn > max_pfn_mapped)
+		return 0;
 
 	/*
-	 * If we are inside the high mapped kernel range, then we
-	 * fixup the low mapping first. __va() returns the virtual
-	 * address in the linear mapping:
+	 * No need to redo, when the primary call touched the direct
+	 * mapping already:
 	 */
-	if (within(address, HIGH_MAP_START, HIGH_MAP_END))
-		address = (unsigned long) __va(phys_addr);
-#endif
+	if (!within(cpa->vaddr, PAGE_OFFSET,
+		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+
+		alias_cpa = *cpa;
+		alias_cpa.vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
 
-	err = __change_page_attr(address, cpa);
-	if (err)
-		return err;
+		ret = __change_page_attr_set_clr(&alias_cpa, 0);
+	}
 
 #ifdef CONFIG_X86_64
+	if (ret)
+		return ret;
+	/*
+	 * No need to redo, when the primary call touched the high
+	 * mapping already:
+	 */
+	if (within(cpa->vaddr, (unsigned long) _text, (unsigned long) _end))
+		return 0;
+
 	/*
 	 * If the physical address is inside the kernel map, we need
 	 * to touch the high mapped kernel as well:
 	 */
-	if (within(phys_addr, 0, KERNEL_TEXT_SIZE)) {
-		/*
-		 * Calc the high mapping address. See __phys_addr()
-		 * for the non obvious details.
-		 *
-		 * Note that NX and other required permissions are
-		 * checked in static_protections().
-		 */
-		address = phys_addr + HIGH_MAP_START - phys_base;
+	if (!within(cpa->pfn, highmap_start_pfn(), highmap_end_pfn()))
+		return 0;
 
-		/*
-		 * Our high aliases are imprecise, because we check
-		 * everything between 0 and KERNEL_TEXT_SIZE, so do
-		 * not propagate lookup failures back to users:
-		 */
-		__change_page_attr(address, cpa);
-	}
+	alias_cpa = *cpa;
+	alias_cpa.vaddr =
+		(cpa->pfn << PAGE_SHIFT) + __START_KERNEL_map - phys_base;
+
+	/*
+	 * The high mapping range is imprecise, so ignore the return value.
+	 */
+	__change_page_attr_set_clr(&alias_cpa, 0);
 #endif
-	return err;
+	return ret;
 }
 
-static int __change_page_attr_set_clr(struct cpa_data *cpa)
+static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 {
 	int ret, numpages = cpa->numpages;
 
@@ -651,10 +651,17 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 		 * preservation check.
 		 */
 		cpa->numpages = numpages;
-		ret = change_page_attr_addr(cpa);
+
+		ret = __change_page_attr(cpa, checkalias);
 		if (ret)
 			return ret;
 
+		if (checkalias) {
+			ret = cpa_process_alias(cpa);
+			if (ret)
+				return ret;
+		}
+
 		/*
 		 * Adjust the number of pages with the result of the
 		 * CPA operation. Either a large page has been
@@ -677,7 +684,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr)
 {
 	struct cpa_data cpa;
-	int ret, cache;
+	int ret, cache, checkalias;
 
 	/*
 	 * Check, if we are requested to change a not supported
@@ -703,7 +710,10 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	cpa.mask_clr = mask_clr;
 	cpa.flushtlb = 0;
 
-	ret = __change_page_attr_set_clr(&cpa);
+	/* No alias checking for _NX bit modifications */
+	checkalias = (pgprot_val(mask_set) | pgprot_val(mask_clr)) != _PAGE_NX;
+
+	ret = __change_page_attr_set_clr(&cpa, checkalias);
 
 	/*
 	 * Check whether we really changed something:
@@ -841,7 +851,7 @@ static int __set_pages_p(struct page *page, int numpages)
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0)};
 
-	return __change_page_attr_set_clr(&cpa);
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 static int __set_pages_np(struct page *page, int numpages)
@@ -851,7 +861,7 @@ static int __set_pages_np(struct page *page, int numpages)
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW)};
 
-	return __change_page_attr_set_clr(&cpa);
+	return __change_page_attr_set_clr(&cpa, 1);
 }
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index bd4740a..7fd5e0e 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -246,6 +246,7 @@ static inline int pud_large(pud_t pte)
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
 extern int kern_addr_valid(unsigned long addr); 
+extern void cleanup_highmap(void);
 
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
