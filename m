Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYBKJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYBKJgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYBKJej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:34:39 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:27392 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbYBKJeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:34:37 -0500
From: Andi Kleen <ak@suse.de>
References: <200802111034.764275766@suse.de>
In-Reply-To: <200802111034.764275766@suse.de>
To: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [6/8] Account overlapped mappings in end_pfn_map
Message-Id: <20080211093434.E30961B41CE@basil.firstfloor.org>
Date: Mon, 11 Feb 2008 10:34:34 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:28:14.0084 (UTC) FILETIME=[6D0EDC40:01C86C90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When end_pfn is not aligned to 2MB (or 1GB) then the kernel might
map more memory than end_pfn. Account this in end_pfn_mapped.

This is needed for other code that needs to know the true
mapping alias state (in this case EFI).

But it's also more correct in general

Cc: ying.huang@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/setup_64.c |    4 +++-
 arch/x86/mm/init_64.c      |   33 +++++++++++++++++++++++----------
 include/asm-x86/proto.h    |    2 +-
 3 files changed, 27 insertions(+), 12 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -287,7 +287,7 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb_all();
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
 	int i = pmd_index(address);
@@ -309,21 +309,25 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
+	return address;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
 {
+	unsigned long r;
 	pmd_t *pmd = pmd_offset(pud, 0);
 	spin_lock(&init_mm.page_table_lock);
-	phys_pmd_init(pmd, address, end);
+	r = phys_pmd_init(pmd, address, end);
 	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
+	return r;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 {
+	unsigned long true_end = end;
 	int i = pud_index(addr);
 
 	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
@@ -342,13 +346,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud))
-				phys_pmd_update(pud, addr, end);
+				true_end = phys_pmd_update(pud, addr, end);
 			continue;
 		}
 
 		if (direct_gbpages) {
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			true_end = (addr & PUD_MASK) + PUD_SIZE;
 			continue;
 		}
 
@@ -356,12 +361,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
 		spin_lock(&init_mm.page_table_lock);
 		set_pud(pud, __pud(pmd_phys | _KERNPG_TABLE));
-		phys_pmd_init(pmd, addr, end);
+		true_end = phys_pmd_init(pmd, addr, end);
 		spin_unlock(&init_mm.page_table_lock);
 
 		unmap_low_page(pmd);
 	}
 	__flush_tlb_all();
+
+	return true_end >> PAGE_SHIFT;
 }
 
 static void __init find_early_table_space(unsigned long end)
@@ -406,9 +413,10 @@ static void __init init_gbpages(void)
  * This runs before bootmem is initialized and gets pages directly from
  * the physical memory. To access them they are temporarily mapped.
  */
-void __init_refok init_memory_mapping(unsigned long start, unsigned long end)
+unsigned long __init_refok
+init_memory_mapping(unsigned long start, unsigned long end)
 {
-	unsigned long next;
+	unsigned long next, true_end = end;
 
 	pr_debug("init_memory_mapping\n");
 
@@ -446,7 +454,7 @@ void __init_refok init_memory_mapping(un
 		next = start + PGDIR_SIZE;
 		if (next > end)
 			next = end;
-		phys_pud_init(pud, __pa(start), __pa(next));
+		true_end = phys_pud_init(pud, __pa(start), __pa(next));
 		set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
 	}
@@ -458,6 +466,8 @@ void __init_refok init_memory_mapping(un
 	if (!after_bootmem)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	return true_end;
 }
 
 #ifndef CONFIG_NUMA
@@ -499,9 +509,12 @@ int arch_add_memory(int nid, u64 start, 
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long r;
 	int ret;
 
-	init_memory_mapping(start, start + size-1);
+	r = init_memory_mapping(start, start + size-1);
+	if (r > end_pfn_map)
+		end_pfn_map = r;
 
 	ret = __add_pages(zone, start_pfn, nr_pages);
 	WARN_ON(1);
Index: linux/include/asm-x86/proto.h
===================================================================
--- linux.orig/include/asm-x86/proto.h
+++ linux/include/asm-x86/proto.h
@@ -7,7 +7,8 @@
 
 extern void early_idt_handler(void);
 
-extern void init_memory_mapping(unsigned long start, unsigned long end);
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
 
 extern void system_call(void);
 extern void syscall_init(void);
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -341,7 +341,7 @@ void __init setup_arch(char **cmdline_p)
 
 	check_efer();
 
-	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	end_pfn_map = init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
 	if (efi_enabled)
 		efi_init();
 
