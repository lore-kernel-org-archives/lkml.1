Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXCZOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXCZOOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXCZOOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:14:18 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:23007
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbXCZOOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:14:17 -0400
Message-Id: <4607F177.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 26 Mar 2007 15:14:47 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: [PATCH] x86: tighten kernel image page access rights
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, kernel memory freed after init can be entirely unmapped instead
of just getting 'poisoned' by overwriting with a debug pattern.

On i386 and x86-64 (under CONFIG_DEBUG_RODATA), kernel text and bug table
can also be write-protected. On x86-64, in addition to that, also make sure
that both mappings (kernel image and 1:1 mapping) get updated here.

(Not sure what the symbol 'stext' is good for; can it be removed?)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

--- linux-2.6.21-rc5/arch/i386/kernel/vmlinux.lds.S	2007-03-26 15:20:02.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/i386/kernel/vmlinux.lds.S	2007-03-21 12:29:00.000000000 +0100
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
--- linux-2.6.21-rc5/arch/i386/mm/init.c	2007-03-26 15:20:02.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/i386/mm/init.c	2007-03-21 12:29:00.000000000 +0100
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
@@ -780,7 +793,7 @@ void free_init_pages(char *what, unsigne
 		free_page(addr);
 		totalram_pages++;
 	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 }
 
 void free_initmem(void)
--- linux-2.6.21-rc5/arch/x86_64/kernel/head.S	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/x86_64/kernel/head.S	2007-03-21 12:29:00.000000000 +0100
@@ -258,7 +258,6 @@ ljumpvector:
 	.word	__KERNEL_CS
 
 ENTRY(stext)
-ENTRY(_stext)
 
 	$page = 0
 #define NEXT_PAGE(name) \
--- linux-2.6.21-rc5/arch/x86_64/kernel/vmlinux.lds.S	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/x86_64/kernel/vmlinux.lds.S	2007-03-21 12:29:00.000000000 +0100
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
--- linux-2.6.21-rc5/arch/x86_64/mm/init.c	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/x86_64/mm/init.c	2007-03-21 12:29:00.000000000 +0100
@@ -22,6 +22,7 @@
 #include <linux/bootmem.h>
 #include <linux/proc_fs.h>
 #include <linux/pci.h>
+#include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
@@ -597,21 +598,23 @@ void free_init_pages(char *what, unsigne
 	if (begin >= end)
 		return;
 
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		memset((void *)(addr & ~(PAGE_SIZE-1)),
 			POISON_FREE_INITMEM, PAGE_SIZE);
+		if (addr >= __START_KERNEL_map)
+			change_page_attr_addr(addr, 1, __pgprot(0));
 		free_page(addr);
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
 			(unsigned long)(&__init_begin),
 			(unsigned long)(&__init_end));
@@ -621,13 +624,18 @@ void free_initmem(void)
 
 void mark_rodata_ro(void)
 {
-	unsigned long addr = (unsigned long)__start_rodata;
+	unsigned long start = PFN_ALIGN(_stext), size;
 
-	for (; addr < (unsigned long)__end_rodata; addr += PAGE_SIZE)
-		change_page_attr_addr(addr, 1, PAGE_KERNEL_RO);
+#ifdef CONFIG_HOTPLUG_CPU
+	/* It must still be possible to apply SMP alternatives. */
+	if (num_possible_cpus() > 1)
+		start = PFN_ALIGN(_etext);
+#endif
+	size = (unsigned long)__end_rodata - start;
+	change_page_attr_addr(start, size >> PAGE_SHIFT, PAGE_KERNEL_RO);
 
-	printk ("Write protecting the kernel read-only data: %luk\n",
-			(__end_rodata - __start_rodata) >> 10);
+	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
+	       size >> 10);
 
 	/*
 	 * change_page_attr_addr() requires a global_flush_tlb() call after it.
--- linux-2.6.21-rc5/arch/x86_64/mm/pageattr.c	2007-03-26 15:20:12.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/arch/x86_64/mm/pageattr.c	2007-03-21 12:29:00.000000000 +0100
@@ -180,16 +180,24 @@ __change_page_attr(unsigned long address
  */
 int change_page_attr_addr(unsigned long address, int numpages, pgprot_t prot)
 {
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
 		if (__pa(address) < KERNEL_TEXT_SIZE) {
--- linux-2.6.21-rc5/include/asm-i386/pgtable.h	2007-03-26 15:20:49.000000000 +0200
+++ 2.6.21-rc5-x86-init-page-attribs/include/asm-i386/pgtable.h	2007-03-21 12:29:00.000000000 +0100
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
--- linux-2.6.21-rc5/include/linux/poison.h	2007-02-04 19:44:54.000000000 +0100
+++ 2.6.21-rc5-x86-init-page-attribs/include/linux/poison.h	2007-03-21 12:29:00.000000000 +0100
@@ -26,9 +26,6 @@
 /********** arch/$ARCH/mm/init.c **********/
 #define POISON_FREE_INITMEM	0xcc
 
-/********** arch/x86_64/mm/init.c **********/
-#define	POISON_FREE_INITDATA	0xba
-
 /********** arch/ia64/hp/common/sba_iommu.c **********/
 /*
  * arch/ia64/hp/common/sba_iommu.c uses a 16-byte poison string with a


