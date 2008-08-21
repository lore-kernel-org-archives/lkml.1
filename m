Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYHUN01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYHUN01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYHUN0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:26:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37703 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYHUN0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:26:19 -0400
Message-Id: <48AD895A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 21 Aug 2008 14:27:22 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix 1:1 mapping init (hotplug case)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I don't have a hotplug capable system at hand, I think two issues need
fixing:
- pud_phys (in kernel_physical_ampping_init()) would remain uninitialized in
  the after_bootmem case
- the locking done just around phys_pmd_{init,update}() would leave out pgd
  updates, and it was needlessly covering code portions that do allocations
  (perhaps using a more friendly gfp value in alloc_low_page() would then be
  possible)

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_64.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

--- linux-2.6.27-rc4/arch/x86/mm/init_64.c	2008-08-21 15:02:41.000000000 +0200
+++ 2.6.27-rc4-x86_64-init-mem-map/arch/x86/mm/init_64.c	2008-08-21 11:49:44.000000000 +0200
@@ -336,9 +336,12 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		}
 
 		if (pmd_val(*pmd)) {
-			if (!pmd_large(*pmd))
+			if (!pmd_large(*pmd)) {
+				spin_lock(&init_mm.page_table_lock);
 				last_map_addr = phys_pte_update(pmd, address,
-								 end);
+								end);
+				spin_unlock(&init_mm.page_table_lock);
+			}
 			/* Count entries we're using from level2_ident_pgt */
 			if (start == 0)
 				pages++;
@@ -347,8 +350,10 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
+			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pmd,
 				pfn_pte(address >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = (address & PMD_MASK) + PMD_SIZE;
 			continue;
 		}
@@ -357,7 +362,9 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		last_map_addr = phys_pte_init(pte, address, end);
 		unmap_low_page(pte);
 
+		spin_lock(&init_mm.page_table_lock);
 		pmd_populate_kernel(&init_mm, pmd, __va(pte_phys));
+		spin_unlock(&init_mm.page_table_lock);
 	}
 	update_page_count(PG_LEVEL_2M, pages);
 	return last_map_addr;
@@ -370,9 +377,7 @@ phys_pmd_update(pud_t *pud, unsigned lon
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long last_map_addr;
 
-	spin_lock(&init_mm.page_table_lock);
 	last_map_addr = phys_pmd_init(pmd, address, end, page_size_mask);
-	spin_unlock(&init_mm.page_table_lock);
 	__flush_tlb_all();
 	return last_map_addr;
 }
@@ -408,20 +413,21 @@ phys_pud_init(pud_t *pud_page, unsigned 
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
+			spin_lock(&init_mm.page_table_lock);
 			set_pte((pte_t *)pud,
 				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
+			spin_unlock(&init_mm.page_table_lock);
 			last_map_addr = (addr & PUD_MASK) + PUD_SIZE;
 			continue;
 		}
 
 		pmd = alloc_low_page(&pmd_phys);
-
-		spin_lock(&init_mm.page_table_lock);
 		last_map_addr = phys_pmd_init(pmd, addr, end, page_size_mask);
 		unmap_low_page(pmd);
+
+		spin_lock(&init_mm.page_table_lock);
 		pud_populate(&init_mm, pud, __va(pmd_phys));
 		spin_unlock(&init_mm.page_table_lock);
-
 	}
 	__flush_tlb_all();
 	update_page_count(PG_LEVEL_1G, pages);
@@ -513,16 +519,14 @@ static unsigned long __init kernel_physi
 			continue;
 		}
 
-		if (after_bootmem)
-			pud = pud_offset(pgd, start & PGDIR_MASK);
-		else
-			pud = alloc_low_page(&pud_phys);
-
+		pud = alloc_low_page(&pud_phys);
 		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
 						 page_size_mask);
 		unmap_low_page(pud);
-		pgd_populate(&init_mm, pgd_offset_k(start),
-			     __va(pud_phys));
+
+		spin_lock(&init_mm.page_table_lock);
+		pgd_populate(&init_mm, pgd, __va(pud_phys));
+		spin_unlock(&init_mm.page_table_lock);
 	}
 
 	return last_map_addr;



