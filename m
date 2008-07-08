Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbYGHIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbYGHIoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYGHIoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:44:07 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:54805 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYGHIoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ldRSFBeChs+JPGxKq9S/PUKXXqN55VO/3ItyOY/nEL0jDkn7kHqmQbZnqdYPcqDdgu
         yR0VXy1z0lbEt7zlRk2zosw/GR2Wdt4zwIqzo4hXCcSkJaZ8TNbxjwHSLZ7sDtrmIUJM
         eQ0Nmh25BpgeAa6IyA4w3d9eIEcniJInNJm0w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: introduce page_size_mask for 64bit
Date: Tue, 8 Jul 2008 01:41:05 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080141.05436.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare for overmapped patch

also printout last_map_addr together with end

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_64.c |   98 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 35 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -300,7 +300,8 @@ phys_pte_update(pmd_t *pmd, unsigned lon
 }
 
 static unsigned long __meminit
-phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
+phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
+			 unsigned long page_size_mask)
 {
 	unsigned long pages = 0;
 
@@ -325,7 +326,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			continue;
 		}
 
-		if (cpu_has_pse) {
+		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
 			set_pte((pte_t *)pmd,
 				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
@@ -343,20 +344,22 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 }
 
 static unsigned long __meminit
-phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end)
+phys_pmd_update(pud_t *pud, unsigned long address, unsigned long end,
+			 unsigned long page_size_mask)
 {
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long last_map_addr;
 
 	spin_lock(&init_mm.page_table_lock);
-	last_map_addr = phys_pmd_init(pmd, address, end);
+	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask);
 	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
 	return last_map_addr;
 }
 
 static unsigned long __meminit
-phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end)
+phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
+			 unsigned long page_size_mask)
 {
 	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
@@ -378,11 +381,12 @@ phys_pud_init(pud_t *pud_page, unsigned
 
 		if (pud_val(*pud)) {
 			if (!pud_large(*pud))
-				last_map_addr = phys_pmd_update(pud, addr, end);
+				last_map_addr = phys_pmd_update(pud, addr, end,
+							 page_size_mask);
 			continue;
 		}
 
-		if (direct_gbpages) {
+		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
@@ -393,7 +397,7 @@ phys_pud_init(pud_t *pud_page, unsigned
 		pmd = alloc_low_page(&pmd_phys);
 
 		spin_lock(&init_mm.page_table_lock);
-		last_map_addr = phys_pmd_init(pmd, addr, end);
+		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask);
 		unmap_low_page(pmd);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
 		spin_unlock(&init_mm.page_table_lock);
@@ -406,13 +410,14 @@ phys_pud_init(pud_t *pud_page, unsigned
 }
 
 static unsigned long __meminit
-phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end)
+phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
+		 unsigned long page_size_mask)
 {
 	pud_t *pud;
 
 	pud = (pud_t *)pgd_page_vaddr(*pgd);
 
-	return phys_pud_init(pud, addr, end);
+	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
 static void __init find_early_table_space(unsigned long end)
@@ -582,29 +587,12 @@ static void __init early_memtest(unsigne
 }
 #endif
 
-/*
- * Setup the direct mapping of the physical memory at PAGE_OFFSET.
- * This runs before bootmem is initialized and gets pages directly from
- * the physical memory. To access them they are temporarily mapped.
- */
-unsigned long __init_refok init_memory_mapping(unsigned long start, unsigned long end)
+static unsigned long __init kernel_physical_mapping_init(unsigned long start,
+						unsigned long end,
+						unsigned long page_size_mask)
 {
-	unsigned long next, last_map_addr = end;
-	unsigned long start_phys = start, end_phys = end;
 
-	printk(KERN_INFO "init_memory_mapping\n");
-
-	/*
-	 * Find space for the kernel direct mapping tables.
-	 *
-	 * Later we should allocate these tables in the local node of the
-	 * memory mapped. Unfortunately this is done currently before the
-	 * nodes are discovered.
-	 */
-	if (!after_bootmem) {
-		init_gbpages();
-		find_early_table_space(end);
-	}
+	unsigned long next, last_map_addr = end;
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
@@ -619,7 +607,8 @@ unsigned long __init_refok init_memory_m
 			next = end;
 
 		if (pgd_val(*pgd)) {
-			last_map_addr = phys_pud_update(pgd, __pa(start), __pa(end));
+			last_map_addr = phys_pud_update(pgd, __pa(start),
+						 __pa(end), page_size_mask);
 			continue;
 		}
 
@@ -628,22 +617,61 @@ unsigned long __init_refok init_memory_m
 		else
 			pud = alloc_low_page(&pud_phys);
 
-		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next));
+		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
+						 page_size_mask);
 		unmap_low_page(pud);
 		pgd_populate(&init_mm, pgd_offset_k(start),
 			     __va(pud_phys));
 	}
 
+	return last_map_addr;
+}
+/*
+ * Setup the direct mapping of the physical memory at PAGE_OFFSET.
+ * This runs before bootmem is initialized and gets pages directly from
+ * the physical memory. To access them they are temporarily mapped.
+ */
+unsigned long __init_refok init_memory_mapping(unsigned long start,
+					       unsigned long end)
+{
+	unsigned long last_map_addr;
+	unsigned long page_size_mask = 0;
+
+	printk(KERN_INFO "init_memory_mapping\n");
+
+	/*
+	 * Find space for the kernel direct mapping tables.
+	 *
+	 * Later we should allocate these tables in the local node of the
+	 * memory mapped. Unfortunately this is done currently before the
+	 * nodes are discovered.
+	 */
+	if (!after_bootmem) {
+		init_gbpages();
+		find_early_table_space(end);
+	}
+
+	if (direct_gbpages)
+		page_size_mask |= 1 << PG_LEVEL_1G;
+	if (cpu_has_pse)
+		page_size_mask |= 1 << PG_LEVEL_2M;
+
+	last_map_addr = kernel_physical_mapping_init(start, end,
+							 page_size_mask);
+
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
 	__flush_tlb_all();
 
-	if (!after_bootmem)
+	if (!after_bootmem && table_end > table_start)
 		reserve_early(table_start << PAGE_SHIFT,
 				 table_end << PAGE_SHIFT, "PGTABLE");
 
+	printk(KERN_INFO "last_map_addr: %lx end: %lx\n",
+			 last_map_addr, end);
+
 	if (!after_bootmem)
-		early_memtest(start_phys, end_phys);
+		early_memtest(start, end);
 
 	return last_map_addr >> PAGE_SHIFT;
 }
