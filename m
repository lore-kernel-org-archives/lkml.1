Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYCLCx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYCLCx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYCLCxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:32 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:25921 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbYCLCxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080312353.598285931@firstfloor.org>
In-Reply-To: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/7] Account overlapped mappings in end_pfn_map
Message-Id: <20080312025328.A29741B41D1@basil.firstfloor.org>
Date: Wed, 12 Mar 2008 03:53:28 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:46:56.0535 (UTC) FILETIME=[561CF270:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[old patch repost, needed for further patches in the series)

When end_pfn is not aligned to 2MB (or 1GB) then the kernel might
map more memory than end_pfn. Account this in end_pfn_mapped.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/setup_64.c |    2 +-
 arch/x86/mm/init_64.c      |   33 +++++++++++++++++++++++----------
 include/asm-x86/proto.h    |    3 ++-
 3 files changed, 26 insertions(+), 12 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -296,7 +296,7 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb_all();
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
 	int i = pmd_index(address);
@@ -318,21 +318,25 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		set_pte((pte_t *)pmd,
 			pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 	}
+	return address;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
 {
+	unsigned long true_end;
 	pmd_t *pmd = pmd_offset(pud, 0);
 	spin_lock(&init_mm.page_table_lock);
-	phys_pmd_init(pmd, address, end);
+	true_end = phys_pmd_init(pmd, address, end);
 	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
+	return true_end;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
 {
+	unsigned long true_end = end;
 	int i = pud_index(addr);
 
 	for (; i < PTRS_PER_PUD; i++, addr = (addr & PUD_MASK) + PUD_SIZE) {
@@ -351,13 +355,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
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
 
@@ -365,12 +370,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
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
@@ -415,9 +422,10 @@ static void __init init_gbpages(void)
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
 
@@ -449,7 +457,7 @@ void __init_refok init_memory_mapping(un
 		next = start + PGDIR_SIZE;
 		if (next > end)
 			next = end;
-		phys_pud_init(pud, __pa(start), __pa(next));
+		true_end = phys_pud_init(pud, __pa(start), __pa(next));
 		if (!after_bootmem)
 			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
@@ -462,6 +470,8 @@ void __init_refok init_memory_mapping(un
 	if (!after_bootmem)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
+
+	return true_end;
 }
 
 #ifndef CONFIG_NUMA
@@ -503,9 +513,12 @@ int arch_add_memory(int nid, u64 start, 
 	struct zone *zone = pgdat->node_zones + ZONE_NORMAL;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	unsigned long true_end_pfn;
 	int ret;
 
-	init_memory_mapping(start, start + size-1);
+	true_end_pfn = init_memory_mapping(start, start + size-1);
+	if (true_end_pfn > end_pfn_map)
+		end_pfn_map = true_end_pfn;
 
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
 
