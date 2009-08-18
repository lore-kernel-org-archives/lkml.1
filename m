Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbZHRPyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbZHRPyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZHRPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:54:20 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:46929 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZHRPyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:54:20 -0400
Message-Id: <4A8AEACD020000780001056D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 18 Aug 2009 16:54:21 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] don't use alloc_bootmem_low() where not strictly
	 needed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since alloc_bootmem() will never return inaccessible (via virtual
addressing) memory anyway, using the ..._low() variant only makes sense
when the physical address range of the allocated memory must fulfill
further constraints, espacially since on 64-bits (or more generally in
all cases where the pools the two variants allocate from are
different), the space available for ..._low() is more easily exhausted 
than the full available range.

Probably the use in alloc_tce_table() could also be eliminated (based
on code inspection of pci-calgary_64.c), but that seems too risky given
I know nothing about that hardware and have no way to test it.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/e820.c    |    2 +-
 arch/x86/mm/init_32.c     |    4 ++--
 drivers/firmware/memmap.c |    2 +-
 kernel/power/snapshot.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.31-rc6/arch/x86/kernel/e820.c	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-avoid-alloc_bootmem_low/arch/x86/kernel/e820.c	2009-07-29 12:58:44.000000000 +0200
@@ -1331,7 +1331,7 @@ void __init e820_reserve_resources(void)
 	struct resource *res;
 	u64 end;
 
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	res = alloc_bootmem(sizeof(struct resource) * e820.nr_map);
 	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
--- linux-2.6.31-rc6/arch/x86/mm/init_32.c	2009-08-18 15:31:16.000000000 +0200
+++ 2.6.31-rc6-avoid-alloc_bootmem_low/arch/x86/mm/init_32.c	2009-07-29 12:58:44.000000000 +0200
@@ -84,7 +84,7 @@ static pmd_t * __init one_md_table_init(
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		if (after_bootmem)
-			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+			pmd_table = (pmd_t *)alloc_bootmem_pages(PAGE_SIZE);
 		else
 			pmd_table = (pmd_t *)alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
@@ -116,7 +116,7 @@ static pte_t * __init one_page_table_ini
 #endif
 			if (!page_table)
 				page_table =
-				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+				(pte_t *)alloc_bootmem_pages(PAGE_SIZE);
 		} else
 			page_table = (pte_t *)alloc_low_page();
 
--- linux-2.6.31-rc6/drivers/firmware/memmap.c	2009-08-18 15:31:18.000000000 +0200
+++ 2.6.31-rc6-avoid-alloc_bootmem_low/drivers/firmware/memmap.c	2009-07-29 12:58:44.000000000 +0200
@@ -164,7 +164,7 @@ int __init firmware_map_add_early(u64 st
 {
 	struct firmware_map_entry *entry;
 
-	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
+	entry = alloc_bootmem(sizeof(struct firmware_map_entry));
 	if (WARN_ON(!entry))
 		return -ENOMEM;
 
--- linux-2.6.31-rc6/kernel/power/snapshot.c	2009-08-18 15:31:56.000000000 +0200
+++ 2.6.31-rc6-avoid-alloc_bootmem_low/kernel/power/snapshot.c	2009-07-29 12:58:44.000000000 +0200
@@ -619,7 +619,7 @@ __register_nosave_region(unsigned long s
 		BUG_ON(!region);
 	} else
 		/* This allocation cannot fail */
-		region = alloc_bootmem_low(sizeof(struct nosave_region));
+		region = alloc_bootmem(sizeof(struct nosave_region));
 	region->start_pfn = start_pfn;
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);



