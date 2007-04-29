Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbXD2LFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbXD2LFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 07:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbXD2LAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 07:00:53 -0400
Received: from mail.suse.de ([195.135.220.2]:52176 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbXD2Kx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:53:26 -0400
From: Andi Kleen <ak@suse.de>
References: <200704291252.514680000@suse.de>
In-Reply-To: <200704291252.514680000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [35/48] x86: tighten kernel image page access rights
Message-Id: <20070429105325.0B1A0151C5@wotan.suse.de>
Date: Sun, 29 Apr 2007 12:53:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On x86-64, kernel memory freed after init can be entirely unmapped instead
of just getting 'poisoned' by overwriting with a debug pattern.

On i386 and x86-64 (under CONFIG_DEBUG_RODATA), kernel text and bug table
can also be write-protected.

Compared to the first version, this one prevents re-creating deleted
mappings in the kernel image range on x86-64, if those got removed
previously. This, together with the original changes, prevents temporarily
having inconsistent mappings when cacheability attributes are being
changed on such pages (e.g. from AGP code). While on i386 such duplicate
mappings don't exist, the same change is done there, too, both for
consistency and because checking pte_present() before using various other
pte_XXX functions is a requirement anyway. At once, i386 code gets
adjusted to use pte_huge() instead of open coding this.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/vmlinux.lds.S   |    4 ++--
 arch/i386/mm/init.c              |   27 ++++++++++++++++++++-------
 arch/i386/mm/pageattr.c          |    6 ++++--
 arch/x86_64/kernel/head.S        |    1 -
 arch/x86_64/kernel/vmlinux.lds.S |    5 +++--
 arch/x86_64/mm/init.c            |   25 ++++++++++++++++---------
 arch/x86_64/mm/pageattr.c        |   18 +++++++++++++-----
 include/asm-i386/pgtable.h       |    2 ++
 include/linux/poison.h           |    3 ---
 9 files changed, 60 insertions(+), 31 deletions(-)

Index: linux/arch/i386/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/i386/kernel/vmlinux.lds.S
+++ linux/arch/i386/kernel/vmlinux.lds.S
@@ -61,8 +61,6 @@ SECTIONS
   	__stop___ex_table = .;
   }
 
-  RODATA
-
   BUG_TABLE
 
   . = ALIGN(4);
@@ -72,6 +70,8 @@ SECTIONS
   	__tracedata_end = .;
   }
 
+  RODATA
+
   /* writeable */
   . = ALIGN(4096);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
Index: linux/arch/i386/mm/init.c
===================================================================
--- linux.orig/arch/i386/mm/init.c
+++ linux/arch/i386/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
@@ -751,13 +752,25 @@ static int noinline do_test_wp_bit(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long addr = (unsigned long)__start_rodata;
+	unsigned long start = PFN_ALIGN(_text);
+	unsigned long size = PFN_ALIGN(_etext) - start;
 
-	for (; addr < (unsigned long)__end_rodata; addr += PAGE_SIZE)
-		change_page_attr(virt_to_page(addr), 1, PAGE_KERNEL_RO);
-
-	printk("Write protecting the kernel read-only data: %uk\n",
-			(__end_rodata - __start_rodata) >> 10);
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() <= 1)
+#endif
+	{
+		change_page_attr(virt_to_page(start),
+		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
+		printk("Write protecting the kernel text: %luk\n", size >> 10);
+	}
+
+	start += size;
+	size = (unsigned long)__end_rodata - start;
+	change_page_attr(virt_to_page(start),
+	                 size >> PAGE_SHIFT, PAGE_KERNEL_RO);
+	printk("Write protecting the kernel read-only data: %luk\n",
+	       size >> 10);
 
 	/*
 	 * change_page_attr() requires a global_flush_tlb() call after it.
@@ -781,7 +794,7 @@ void free_init_pages(char *what, unsigne
 		__free_page(page);
 		totalram_pages++;
 	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 }
 
 void free_initmem(void)
Index: linux/arch/i386/mm/pageattr.c
===================================================================
--- linux.orig/arch/i386/mm/pageattr.c
+++ linux/arch/i386/mm/pageattr.c
@@ -140,9 +140,11 @@ __change_page_attr(struct page *page, pg
 	kpte = lookup_address(address);
 	if (!kpte)
 		return -EINVAL;
+	if (!pte_present(*kpte))
+		return 0;
 	kpte_page = virt_to_page(kpte);
 	if (pgprot_val(prot) != pgprot_val(PAGE_KERNEL)) { 
-		if ((pte_val(*kpte) & _PAGE_PSE) == 0) { 
+		if (!pte_huge(*kpte)) {
 			set_pte_atomic(kpte, mk_pte(page, prot)); 
 		} else {
 			pgprot_t ref_prot;
@@ -158,7 +160,7 @@ __change_page_attr(struct page *page, pg
 			kpte_page = split;
 		}
 		page_private(kpte_page)++;
-	} else if ((pte_val(*kpte) & _PAGE_PSE) == 0) { 
+	} else if (!pte_huge(*kpte)) {
 		set_pte_atomic(kpte, mk_pte(page, PAGE_KERNEL));
 		BUG_ON(page_private(kpte_page) == 0);
 		page_private(kpte_page)--;
Index: linux/arch/x86_64/kernel/head.S
===================================================================
--- linux.orig/arch/x86_64/kernel/head.S
+++ linux/arch/x86_64/kernel/head.S
@@ -280,7 +280,6 @@ early_idt_ripmsg:
 
 .balign PAGE_SIZE
 ENTRY(stext)
-ENTRY(_stext)
 
 #define NEXT_PAGE(name) \
 	.balign	PAGE_SIZE; \
Index: linux/arch/x86_64/kernel/vmlinux.lds.S
===================================================================
--- linux.orig/arch/x86_64/kernel/vmlinux.lds.S
+++ linux/arch/x86_64/kernel/vmlinux.lds.S
@@ -29,6 +29,7 @@ SECTIONS
   .text :  AT(ADDR(.text) - LOAD_OFFSET) {
 	/* First the code that has to be first for bootstrapping */
 	*(.bootstrap.text)
+	_stext = .;
 	/* Then all the functions that are "hot" in profiles, to group them
            onto the same hugetlb entry */
 	#include "functionlist"
@@ -50,10 +51,10 @@ SECTIONS
   __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) { *(__ex_table) }
   __stop___ex_table = .;
 
-  RODATA
-
   BUG_TABLE
 
+  RODATA
+
   . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
Index: linux/arch/x86_64/mm/init.c
===================================================================
--- linux.orig/arch/x86_64/mm/init.c
+++ linux/arch/x86_64/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
+#include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
@@ -563,21 +564,23 @@ void free_init_pages(char *what, unsigne
 	if (begin >= end)
 		return;
 
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		struct page *page = pfn_to_page(addr >> PAGE_SHIFT);
 		ClearPageReserved(page);
 		init_page_count(page);
 		memset(page_address(page), POISON_FREE_INITMEM, PAGE_SIZE);
+		if (addr >= __START_KERNEL_map)
+			change_page_attr_addr(addr, 1, __pgprot(0));
 		__free_page(page);
 		totalram_pages++;
 	}
+	if (addr > __START_KERNEL_map)
+		global_flush_tlb();
 }
 
 void free_initmem(void)
 {
-	memset(__initdata_begin, POISON_FREE_INITDATA,
-		__initdata_end - __initdata_begin);
 	free_init_pages("unused kernel memory",
 			__pa_symbol(&__init_begin),
 			__pa_symbol(&__init_end));
@@ -587,14 +590,18 @@ void free_initmem(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long addr = (unsigned long)__va(__pa_symbol(&__start_rodata));
-	unsigned long end  = (unsigned long)__va(__pa_symbol(&__end_rodata));
+	unsigned long start = PFN_ALIGN(__va(__pa_symbol(&_stext))), size;
 
-	for (; addr < end; addr += PAGE_SIZE)
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() > 1)
+		start = PFN_ALIGN(__va(__pa_symbol(&_etext)));
+#endif
+	size = (unsigned long)__va(__pa_symbol(&__end_rodata)) - start;
+	change_page_attr_addr(start, size >> PAGE_SHIFT, PAGE_KERNEL_RO);
 
-	printk ("Write protecting the kernel read-only data: %luk\n",
-			(__end_rodata - __start_rodata) >> 10);
+	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
+	       size >> 10);
 
 	/*
 	 * change_page_attr_addr() requires a global_flush_tlb() call after it.
Index: linux/arch/x86_64/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86_64/mm/pageattr.c
+++ linux/arch/x86_64/mm/pageattr.c
@@ -126,7 +126,7 @@ __change_page_attr(unsigned long address
 	struct page *kpte_page;
 	pgprot_t ref_prot2;
 	kpte = lookup_address(address);
-	if (!kpte) return 0;
+	if (!kpte || !pte_present(*kpte)) return 0;
 	kpte_page = virt_to_page(((unsigned long)kpte) & PAGE_MASK);
 	if (pgprot_val(prot) != pgprot_val(ref_prot)) { 
 		if (!pte_huge(*kpte)) {
@@ -179,16 +179,24 @@ __change_page_attr(unsigned long address
 int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 {
 	unsigned long phys_base_pfn = __pa_symbol(__START_KERNEL_map) >> PAGE_SHIFT;
-	int err = 0; 
+	int err = 0, kernel_map = 0;
 	int i; 
 
+	if (address >= __START_KERNEL_map
+	    && address < __START_KERNEL_map + KERNEL_TEXT_SIZE) {
+		address = (unsigned long)__va(__pa(address));
+		kernel_map = 1;
+	}
+
 	down_write(&init_mm.mmap_sem);
 	for (i = 0; i < numpages; i++, address += PAGE_SIZE) {
 		unsigned long pfn = __pa(address) >> PAGE_SHIFT;
 
-		err = __change_page_attr(address, pfn, prot, PAGE_KERNEL);
-		if (err) 
-			break; 
+		if (!kernel_map || pte_present(pfn_pte(0, prot))) {
+			err = __change_page_attr(address, pfn, prot, PAGE_KERNEL);
+			if (err)
+				break;
+		}
 		/* Handle kernel mapping too which aliases part of the
 		 * lowmem */
 		if ((pfn >= phys_base_pfn) &&
Index: linux/include/asm-i386/pgtable.h
===================================================================
--- linux.orig/include/asm-i386/pgtable.h
+++ linux/include/asm-i386/pgtable.h
@@ -159,6 +159,7 @@ void paging_init(void);
 
 extern unsigned long long __PAGE_KERNEL, __PAGE_KERNEL_EXEC;
 #define __PAGE_KERNEL_RO		(__PAGE_KERNEL & ~_PAGE_RW)
+#define __PAGE_KERNEL_RX		(__PAGE_KERNEL_EXEC & ~_PAGE_RW)
 #define __PAGE_KERNEL_NOCACHE		(__PAGE_KERNEL | _PAGE_PCD)
 #define __PAGE_KERNEL_LARGE		(__PAGE_KERNEL | _PAGE_PSE)
 #define __PAGE_KERNEL_LARGE_EXEC	(__PAGE_KERNEL_EXEC | _PAGE_PSE)
@@ -166,6 +167,7 @@ extern unsigned long long __PAGE_KERNEL,
 #define PAGE_KERNEL		__pgprot(__PAGE_KERNEL)
 #define PAGE_KERNEL_RO		__pgprot(__PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC	__pgprot(__PAGE_KERNEL_EXEC)
+#define PAGE_KERNEL_RX		__pgprot(__PAGE_KERNEL_RX)
 #define PAGE_KERNEL_NOCACHE	__pgprot(__PAGE_KERNEL_NOCACHE)
 #define PAGE_KERNEL_LARGE	__pgprot(__PAGE_KERNEL_LARGE)
 #define PAGE_KERNEL_LARGE_EXEC	__pgprot(__PAGE_KERNEL_LARGE_EXEC)
Index: linux/include/linux/poison.h
===================================================================
--- linux.orig/include/linux/poison.h
+++ linux/include/linux/poison.h
@@ -26,9 +26,6 @@
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
-/********** arch/x86_64/mm/init.c **********/
-#define	POISON_FREE_INITDATA	0xba
-
 /********** arch/ia64/hp/common/sba_iommu.c **********/
 /*
  * arch/ia64/hp/common/sba_iommu.c uses a 16-byte poison string with a
