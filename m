Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbYIKVfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbYIKVfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 17:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYIKVdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 17:33:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:31403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756944AbYIKVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 17:33:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,383,1217833200"; 
   d="scan'208";a="615332296"
Message-Id: <20080911204150.717626000@linux-os.sc.intel.com>
References: <20080911203048.929515000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Sep 2008 13:30:51 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/7] x86, cpa: make the kernel physical mapping initialization a two pass sequence
Content-Disposition: inline; filename=fix_large_small_page_identity_mappings.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the first pass, kernel physical mapping will be setup using large or
small pages but uses the same PTE attributes as that of the early
PTE attributes setup by early boot code in head_[32|64].S

After flushing TLB's, we go through the second pass, which setups the
direct mapped PTE's with the appropriate attributes (like NX, GLOBAL etc)
which are runtime detectable.

This two pass mechanism conforms to the TLB app note which says:

"Software should not write to a paging-structure entry in a way that would
 change, for any linear address, both the page size and either the page frame
 or attributes."

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/mm/init_32.c
===================================================================
--- tip.orig/arch/x86/mm/init_32.c	2008-09-11 12:59:35.000000000 -0700
+++ tip/arch/x86/mm/init_32.c	2008-09-11 13:02:34.000000000 -0700
@@ -196,11 +196,30 @@
 	pgd_t *pgd;
 	pmd_t *pmd;
 	pte_t *pte;
-	unsigned pages_2m = 0, pages_4k = 0;
+	unsigned pages_2m, pages_4k;
+	int mapping_iter;
+
+	/*
+	 * First iteration will setup identity mapping using large/small pages
+	 * based on use_pse, with other attributes same as set by
+	 * the early code in head_32.S
+	 *
+	 * Second iteration will setup the appropriate attributes (NX, GLOBAL..)
+	 * as desired for the kernel identity mapping.
+	 *
+	 * This two pass mechanism conforms to the TLB app note which says:
+	 *
+	 *     "Software should not write to a paging-structure entry in a way
+	 *      that would change, for any linear address, both the page size
+	 *      and either the page frame or attributes."
+	 */
+	mapping_iter = 1;
 
 	if (!cpu_has_pse)
 		use_pse = 0;
 
+repeat:
+	pages_2m = pages_4k = 0;
 	pfn = start_pfn;
 	pgd_idx = pgd_index((pfn<<PAGE_SHIFT) + PAGE_OFFSET);
 	pgd = pgd_base + pgd_idx;
@@ -226,6 +245,13 @@
 			if (use_pse) {
 				unsigned int addr2;
 				pgprot_t prot = PAGE_KERNEL_LARGE;
+				/*
+				 * first pass will use the same initial
+				 * identity mapping attribute + _PAGE_PSE.
+				 */
+				pgprot_t init_prot =
+					__pgprot(PTE_IDENT_ATTR |
+						 _PAGE_PSE);
 
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
@@ -235,7 +261,10 @@
 					prot = PAGE_KERNEL_LARGE_EXEC;
 
 				pages_2m++;
-				set_pmd(pmd, pfn_pmd(pfn, prot));
+				if (mapping_iter == 1)
+					set_pmd(pmd, pfn_pmd(pfn, init_prot));
+				else
+					set_pmd(pmd, pfn_pmd(pfn, prot));
 
 				pfn += PTRS_PER_PTE;
 				continue;
@@ -247,17 +276,43 @@
 			for (; pte_ofs < PTRS_PER_PTE && pfn < end_pfn;
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
+				/*
+				 * first pass will use the same initial
+				 * identity mapping attribute.
+				 */
+				pgprot_t init_prot = __pgprot(PTE_IDENT_ATTR);
 
 				if (is_kernel_text(addr))
 					prot = PAGE_KERNEL_EXEC;
 
 				pages_4k++;
-				set_pte(pte, pfn_pte(pfn, prot));
+				if (mapping_iter == 1)
+					set_pte(pte, pfn_pte(pfn, init_prot));
+				else
+					set_pte(pte, pfn_pte(pfn, prot));
 			}
 		}
 	}
-	update_page_count(PG_LEVEL_2M, pages_2m);
-	update_page_count(PG_LEVEL_4K, pages_4k);
+	if (mapping_iter == 1) {
+		/*
+		 * update direct mapping page count only in the first
+		 * iteration.
+		 */
+		update_page_count(PG_LEVEL_2M, pages_2m);
+		update_page_count(PG_LEVEL_4K, pages_4k);
+
+		/*
+		 * local global flush tlb, which will flush the previous
+		 * mappings present in both small and large page TLB's.
+		 */
+		__flush_tlb_all();
+
+		/*
+		 * Second iteration will set the actual desired PTE attributes.
+		 */
+		mapping_iter = 2;
+		goto repeat;
+	}
 }
 
 /*
Index: tip/arch/x86/mm/init_64.c
===================================================================
--- tip.orig/arch/x86/mm/init_64.c	2008-09-11 12:59:35.000000000 -0700
+++ tip/arch/x86/mm/init_64.c	2008-09-11 13:00:04.000000000 -0700
@@ -326,6 +326,8 @@
 	early_iounmap(adr, PAGE_SIZE);
 }
 
+static int physical_mapping_iter;
+
 static unsigned long __meminit
 phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end)
 {
@@ -346,16 +348,19 @@
 		}
 
 		if (pte_val(*pte))
-			continue;
+			goto repeat_set_pte;
 
 		if (0)
 			printk("   pte=%p addr=%lx pte=%016lx\n",
 			       pte, addr, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL).pte);
+		pages++;
+repeat_set_pte:
 		set_pte(pte, pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL));
 		last_map_addr = (addr & PAGE_MASK) + PAGE_SIZE;
-		pages++;
 	}
-	update_page_count(PG_LEVEL_4K, pages);
+
+	if (physical_mapping_iter == 1)
+		update_page_count(PG_LEVEL_4K, pages);
 
 	return last_map_addr;
 }
@@ -374,7 +379,6 @@
 {
 	unsigned long pages = 0;
 	unsigned long last_map_addr = end;
-	unsigned long start = address;
 
 	int i = pmd_index(address);
 
@@ -397,15 +401,14 @@
 				last_map_addr = phys_pte_update(pmd, address,
 								end);
 				spin_unlock(&init_mm.page_table_lock);
+				continue;
 			}
-			/* Count entries we're using from level2_ident_pgt */
-			if (start == 0)
-				pages++;
-			continue;
+			goto repeat_set_pte;
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
+repeat_set_pte:
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
 				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
@@ -422,7 +425,8 @@
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
 		spin_unlock(&init_mm.page_table_lock);
 	}
-	update_page_count(PG_LEVEL_2M, pages);
+	if (physical_mapping_iter == 1)
+		update_page_count(PG_LEVEL_2M, pages);
 	return last_map_addr;
 }
 
@@ -461,14 +465,18 @@
 		}
 
 		if (pud_val(*pud)) {
-			if (!pud_large(*pud))
+			if (!pud_large(*pud)) {
 				last_map_addr = phys_pmd_update(pud, addr, end,
 							 page_size_mask);
-			continue;
+				continue;
+			}
+
+			goto repeat_set_pte;
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
+repeat_set_pte:
 			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
@@ -486,7 +494,9 @@
 		spin_unlock(&init_mm.page_table_lock);
 	}
 	__flush_tlb_all();
-	update_page_count(PG_LEVEL_1G, pages);
+
+	if (physical_mapping_iter == 1)
+		update_page_count(PG_LEVEL_1G, pages);
 
 	return last_map_addr;
 }
@@ -550,15 +560,54 @@
 		direct_gbpages = 0;
 }
 
+static int is_kernel(unsigned long pfn)
+{
+	unsigned long pg_addresss = pfn << PAGE_SHIFT;
+
+	if (pg_addresss >= (unsigned long) __pa(_text) &&
+	    pg_addresss <= (unsigned long) __pa(_end))
+		return 1;
+
+	return 0;
+}
+
 static unsigned long __init kernel_physical_mapping_init(unsigned long start,
 						unsigned long end,
 						unsigned long page_size_mask)
 {
 
-	unsigned long next, last_map_addr = end;
+	unsigned long next, last_map_addr;
+	u64 cached_supported_pte_mask = __supported_pte_mask;
+	unsigned long cache_start = start;
+	unsigned long cache_end = end;
+
+	/*
+	 * First iteration will setup identity mapping using large/small pages
+	 * based on page_size_mask, with other attributes same as set by
+	 * the early code in head_64.S
+	 *
+	 * Second iteration will setup the appropriate attributes
+	 * as desired for the kernel identity mapping.
+	 *
+	 * This two pass mechanism conforms to the TLB app note which says:
+	 *
+	 *     "Software should not write to a paging-structure entry in a way
+	 *      that would change, for any linear address, both the page size
+	 *      and either the page frame or attributes."
+	 *
+	 * For now, only difference between very early PTE attributes used in
+	 * head_64.S and here is _PAGE_NX.
+	 */
+	BUILD_BUG_ON((__PAGE_KERNEL_LARGE & ~__PAGE_KERNEL_IDENT_LARGE_EXEC)
+		     != _PAGE_NX);
+	__supported_pte_mask &= ~(_PAGE_NX);
+	physical_mapping_iter = 1;
 
-	start = (unsigned long)__va(start);
-	end = (unsigned long)__va(end);
+repeat:
+	last_map_addr = end;
+
+	start = (unsigned long)__va(cache_start);
+	end = (unsigned long)__va(cache_end);
 
 	for (; start < end; start = next) {
 		pgd_t *pgd = pgd_offset_k(start);
@@ -570,11 +619,21 @@
 			next = end;
 
 		if (pgd_val(*pgd)) {
+			/*
+			 * Static identity mappings will be overwritten
+			 * with run-time mappings. For example, this allows
+			 * the static 0-1GB identity mapping to be mapped
+			 * non-executable with this.
+			 */
+			if (is_kernel(pte_pfn(*((pte_t *) pgd))))
+				goto realloc;
+
 			last_map_addr = phys_pud_update(pgd, __pa(start),
 						 __pa(end), page_size_mask);
 			continue;
 		}
 
+realloc:
 		pud = alloc_low_page(&pud_phys);
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
 						 page_size_mask);
@@ -584,6 +643,16 @@
 		pgd_populate(&init_mm, pgd, __va(pud_phys));
 		spin_unlock(&init_mm.page_table_lock);
 	}
+	__flush_tlb_all();
+
+	if (physical_mapping_iter == 1) {
+		physical_mapping_iter = 2;
+		/*
+		 * Second iteration will set the actual desired PTE attributes.
+		 */
+		__supported_pte_mask = cached_supported_pte_mask;
+		goto repeat;
+	}
 
 	return last_map_addr;
 }

-- 

