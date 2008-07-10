Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbYGJDTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbYGJDTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYGJDSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:18:42 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:48532 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYGJDSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:18:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=TtwMq3kwfLL0Dd8FVAIn25mcAxuOJJulEyD+LV10qaQFjWi0pzvbJb7XFopilrgbug
         2BMo9+UPd71U6fsZ0d1ADRegV1KTckVKvtXtn+M3H/28TKXg448I2q7pnvP/ytylBX87
         EKbxrjIbfcHq5uSsQOnXtoXXTiYtnyHz6hH40=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Date: Wed, 9 Jul 2008 20:15:02 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com>
In-Reply-To: <200807080143.27997.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092015.03004.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



fix phys_pmd_init to make sure not to return big value than end.

also print out range split:1G/2M/4K

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/mm/init_64.c |  106 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 34 deletions(-)

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -302,11 +302,13 @@ static __meminit void unmap_low_page(voi
 	early_iounmap(adr, PAGE_SIZE);
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
 {
 	unsigned pages = 0;
+	unsigned long last_map_addr = end;
 	int i;
+
 	pte_t *pte = pte_page + pte_index(addr);
 
 	for(i = pte_index(addr); i < PTRS_PER_PTE; i++, addr += PAGE_SIZE, pte++) {
@@ -326,17 +328,20 @@ phys_pte_init(pte_t *pte_page, unsigned
 			printk("   pte=%p addr=%lx pte=%016lx\n",
 			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
 		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
+		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
 		pages++;
 	}
 	update_page_count(PG_LEVEL_4K, pages);
+
+	return last_map_addr;
 }
 
-static void __meminit
+static unsigned long __meminit
 phys_pte_update(pmd_t *pmd, unsigned long address, unsigned long end)
 {
 	pte_t *pte = (pte_t *)pmd_page_vaddr(*pmd);
 
-	phys_pte_init(pte, address, end);
+	return phys_pte_init(pte, address, end);
 }
 
 static unsigned long __meminit
@@ -344,6 +349,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			 unsigned long page_size_mask)
 {
 	unsigned long pages = 0;
+	unsigned long last_map_addr = end;
 
 	int i = pmd_index(address);
 
@@ -362,7 +368,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 
 		if (pmd_val(*pmd)) {
 			if (!pmd_large(*pmd))
-				phys_pte_update(pmd, address, end);
+				last_map_addr = phys_pte_update(pmd, address,
+								 end);
 			continue;
 		}
 
@@ -370,17 +377,18 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			pages++;
 			set_pte((pte_t *)pmd,
 				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
 			continue;
 		}
 
 		pte = alloc_low_page(&pte_phys);
-		phys_pte_init(pte, address, end);
+		last_map_addr = phys_pte_init(pte, address, end);
 		unmap_low_page(pte);
 
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
 	}
 	update_page_count(PG_LEVEL_2M, pages);
-	return address;
+	return last_map_addr;
 }
 
 static unsigned long __meminit
@@ -673,6 +681,32 @@ static unsigned long __init kernel_physi
 
 	return last_map_addr;
 }
+
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+#define NR_RANGE_MR 5
+
+static int save_mr(struct map_range *mr, int nr_range,
+		   unsigned long start_pfn, unsigned long end_pfn,
+		   unsigned long page_size_mask)
+{
+
+	if (start_pfn < end_pfn) {
+		if (nr_range >= NR_RANGE_MR)
+			panic("run out of range for init_memory_mapping\n");
+		mr[nr_range].start = start_pfn<<PAGE_SHIFT;
+		mr[nr_range].end   = end_pfn<<PAGE_SHIFT;
+		mr[nr_range].page_size_mask = page_size_mask;
+		nr_range++;
+	}
+
+	return nr_range;
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -681,10 +715,13 @@ static unsigned long __init kernel_physi
 unsigned long __init_refok init_memory_mapping(unsigned long start,
 					       unsigned long end)
 {
-	unsigned long last_map_addr = end;
+	unsigned long last_map_addr = 0;
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
 
+	struct map_range mr[NR_RANGE_MR];
+	int nr_range, i;
+
 	printk(KERN_INFO "init_memory_mapping\n");
 
 	/*
@@ -694,24 +731,22 @@ unsigned long __init_refok init_memory_m
 	 * memory mapped. Unfortunately this is done currently before the
 	 * nodes are discovered.
 	 */
-	if (!after_bootmem) {
+	if (!after_bootmem)
 		init_gbpages();
-		find_early_table_space(end);
-	}
 
 	if (direct_gbpages)
 		page_size_mask |= 1 << PG_LEVEL_1G;
 	if (cpu_has_pse)
 		page_size_mask |= 1 << PG_LEVEL_2M;
 
-	/* head if not big page aligment ?*/
+	memset(mr, 0, sizeof(mr));
+	nr_range = 0;
+
+	/* head if not big page alignment ?*/
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = ((start + (PMD_SIZE - 1)) >> PMD_SHIFT)
 			<< (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn)
-		last_map_addr = kernel_physical_mapping_init(
-					start_pfn<<PAGE_SHIFT,
-					end_pfn<<PAGE_SHIFT, 0);
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
 
 	/* big page (2M) range*/
 	start_pfn = ((start + (PMD_SIZE - 1))>>PMD_SHIFT)
@@ -720,37 +755,40 @@ unsigned long __init_refok init_memory_m
 			 << (PUD_SHIFT - PAGE_SHIFT);
 	if (end_pfn > ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT)))
 		end_pfn = ((end>>PUD_SHIFT)<<(PUD_SHIFT - PAGE_SHIFT));
-	if (start_pfn < end_pfn)
-		last_map_addr = kernel_physical_mapping_init(
-					     start_pfn<<PAGE_SHIFT,
-					     end_pfn<<PAGE_SHIFT,
-					     page_size_mask & (1<<PG_LEVEL_2M));
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+			page_size_mask & (1<<PG_LEVEL_2M));
 
 	/* big page (1G) range */
 	start_pfn = end_pfn;
 	end_pfn = (end>>PUD_SHIFT) << (PUD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn)
-		last_map_addr = kernel_physical_mapping_init(
-					     start_pfn<<PAGE_SHIFT,
-					     end_pfn<<PAGE_SHIFT,
-					     page_size_mask & ((1<<PG_LEVEL_2M)
-							 | (1<<PG_LEVEL_1G)));
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+				page_size_mask &
+				 ((1<<PG_LEVEL_2M)|(1<<PG_LEVEL_1G)));
 
 	/* tail is not big page (1G) alignment */
 	start_pfn = end_pfn;
 	end_pfn = (end>>PMD_SHIFT) << (PMD_SHIFT - PAGE_SHIFT);
-	if (start_pfn < end_pfn)
-		last_map_addr = kernel_physical_mapping_init(
-					     start_pfn<<PAGE_SHIFT,
-					     end_pfn<<PAGE_SHIFT,
-					     page_size_mask & (1<<PG_LEVEL_2M));
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn,
+			page_size_mask & (1<<PG_LEVEL_2M));
+
 	/* tail is not big page (2M) alignment */
 	start_pfn = end_pfn;
 	end_pfn = end>>PAGE_SHIFT;
-	if (start_pfn < end_pfn)
+	nr_range = save_mr(mr, nr_range, start_pfn, end_pfn, 0);
+
+	for (i = 0; i < nr_range; i++)
+		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
+				mr[i].start, mr[i].end,
+			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
+			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
+
+	if (!after_bootmem)
+		find_early_table_space(end);
+
+	for (i = 0; i < nr_range; i++)
 		last_map_addr = kernel_physical_mapping_init(
-					     start_pfn<<PAGE_SHIFT,
-					     end_pfn<<PAGE_SHIFT, 0);
+					mr[i].start, mr[i].end,
+					mr[i].page_size_mask);
 
 	if (!after_bootmem)
 		mmu_cr4_features = read_cr4();
