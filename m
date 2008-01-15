Return-Path: <linux-kernel-owner+w=401wt.eu-S1752485AbYAOFpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbYAOFpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 00:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYAOFpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 00:45:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:29322 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYAOFpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:45:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,285,1196668800"; 
   d="scan'208";a="253558485"
Subject: [PATCH -mm 2/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - remove boot_ioremap
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 15 Jan 2008 13:45:10 +0800
Message-Id: <1200375910.3505.31.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 15 Jan 2008 05:44:56.0871 (UTC) FILETIME=[C28B2370:01C85739]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces boot_ioremap invokation with bt_ioremap and
removes the boot_ioremap implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/Kconfig              |    4 -
 arch/x86/kernel/srat_32.c     |    8 +--
 arch/x86/mm/Makefile_32       |    1 
 arch/x86/mm/boot_ioremap_32.c |  100 ------------------------------------------
 include/asm-x86/efi.h         |    8 ---
 5 files changed, 5 insertions(+), 116 deletions(-)

--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -57,8 +57,6 @@ static struct node_memory_chunk_s node_m
 static int num_memory_chunks;		/* total number of memory chunks */
 static u8 __initdata apicid_to_pxm[MAX_APICID];
 
-extern void * boot_ioremap(unsigned long, unsigned long);
-
 /* Identify CPU proximity domains */
 static void __init parse_cpu_affinity_structure(char *p)
 {
@@ -299,7 +297,7 @@ int __init get_memcfg_from_srat(void)
 	}
 
 	rsdt = (struct acpi_table_rsdt *)
-	    boot_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
+	    bt_ioremap(rsdp->rsdt_physical_address, sizeof(struct acpi_table_rsdt));
 
 	if (!rsdt) {
 		printk(KERN_WARNING
@@ -339,11 +337,11 @@ int __init get_memcfg_from_srat(void)
 	for (i = 0; i < tables; i++) {
 		/* Map in header, then map in full table length. */
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
+			bt_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
 		if (!header)
 			break;
 		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
+			bt_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
 		if (!header)
 			break;
 
--- a/arch/x86/mm/boot_ioremap_32.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * arch/i386/mm/boot_ioremap.c
- *
- * Re-map functions for early boot-time before paging_init() when the
- * boot-time pagetables are still in use
- *
- * Written by Dave Hansen <haveblue@us.ibm.com>
- */
-
-
-/*
- * We need to use the 2-level pagetable functions, but CONFIG_X86_PAE
- * keeps that from happening.  If anyone has a better way, I'm listening.
- *
- * boot_pte_t is defined only if this all works correctly
- */
-
-#undef CONFIG_X86_PAE
-#undef CONFIG_PARAVIRT
-#include <asm/page.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
-#include <linux/init.h>
-#include <linux/stddef.h>
-
-/*
- * I'm cheating here.  It is known that the two boot PTE pages are
- * allocated next to each other.  I'm pretending that they're just
- * one big array.
- */
-
-#define BOOT_PTE_PTRS (PTRS_PER_PTE*2)
-
-static unsigned long boot_pte_index(unsigned long vaddr)
-{
-	return __pa(vaddr) >> PAGE_SHIFT;
-}
-
-static inline boot_pte_t* boot_vaddr_to_pte(void *address)
-{
-	boot_pte_t* boot_pg = (boot_pte_t*)pg0;
-	return &boot_pg[boot_pte_index((unsigned long)address)];
-}
-
-/*
- * This is only for a caller who is clever enough to page-align
- * phys_addr and virtual_source, and who also has a preference
- * about which virtual address from which to steal ptes
- */
-static void __boot_ioremap(unsigned long phys_addr, unsigned long nrpages,
-		    void* virtual_source)
-{
-	boot_pte_t* pte;
-	int i;
-	char *vaddr = virtual_source;
-
-	pte = boot_vaddr_to_pte(virtual_source);
-	for (i=0; i < nrpages; i++, phys_addr += PAGE_SIZE, pte++) {
-		set_pte(pte, pfn_pte(phys_addr>>PAGE_SHIFT, PAGE_KERNEL));
-		__flush_tlb_one((unsigned long) &vaddr[i*PAGE_SIZE]);
-	}
-}
-
-/* the virtual space we're going to remap comes from this array */
-#define BOOT_IOREMAP_PAGES 4
-#define BOOT_IOREMAP_SIZE (BOOT_IOREMAP_PAGES*PAGE_SIZE)
-static __initdata char boot_ioremap_space[BOOT_IOREMAP_SIZE]
-		       __attribute__ ((aligned (PAGE_SIZE)));
-
-/*
- * This only applies to things which need to ioremap before paging_init()
- * bt_ioremap() and plain ioremap() are both useless at this point.
- *
- * When used, we're still using the boot-time pagetables, which only
- * have 2 PTE pages mapping the first 8MB
- *
- * There is no unmap.  The boot-time PTE pages aren't used after boot.
- * If you really want the space back, just remap it yourself.
- * boot_ioremap(&ioremap_space-PAGE_OFFSET, BOOT_IOREMAP_SIZE)
- */
-__init void* boot_ioremap(unsigned long phys_addr, unsigned long size)
-{
-	unsigned long last_addr, offset;
-	unsigned int nrpages;
-
-	last_addr = phys_addr + size - 1;
-
-	/* page align the requested address */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
-
-	nrpages = size >> PAGE_SHIFT;
-	if (nrpages > BOOT_IOREMAP_PAGES)
-		return NULL;
-
-	__boot_ioremap(phys_addr, nrpages, boot_ioremap_space);
-
-	return &boot_ioremap_space[offset];
-}
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1022,10 +1022,6 @@ config IRQBALANCE
 	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.
 
-config BOOT_IOREMAP
-	def_bool y
-	depends on X86_32
-
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
--- a/arch/x86/mm/Makefile_32
+++ b/arch/x86/mm/Makefile_32
@@ -7,4 +7,3 @@ obj-y	:= init_32.o pgtable_32.o fault_32
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_HIGHMEM) += highmem_32.o
-obj-$(CONFIG_BOOT_IOREMAP) += boot_ioremap_32.o
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -32,13 +32,9 @@ extern unsigned long asmlinkage efi_call
 	efi_call_virt(f, a1, a2, a3, a4, a5)
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
-/*
- * We require an early boot_ioremap mapping mechanism initially
- */
-extern void *boot_ioremap(unsigned long, unsigned long);
 
-#define efi_early_ioremap(addr, size)		boot_ioremap(addr, size)
-#define efi_early_iounmap(vaddr, size)
+#define efi_early_ioremap(addr, size)		bt_ioremap(addr, size)
+#define efi_early_iounmap(vaddr, size)		bt_iounmap(vaddr, size)
 
 #define efi_ioremap(addr, size)			ioremap(addr, size)
 

