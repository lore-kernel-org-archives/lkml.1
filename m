Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZF3LUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZF3LUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZF3LUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:20:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:44859 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZF3LUY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:20:24 -0400
Message-Id: <4A4A111A020000780000831A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:20:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, <bernhard.walle@gmx.de>,
       "Thomas Gleixner" <tglx@linutronix.de>, <hpa@zytor.com>
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

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/e820.c    |    2 +-
 arch/x86/mm/init_32.c     |    4 ++--
 drivers/firmware/memmap.c |    2 +-
 kernel/power/snapshot.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.31-rc1/arch/x86/kernel/e820.c	2009-06-26 17:49:43.000000000 +0200
+++ 2.6.31-rc1-avoid-alloc_bootmem_low/arch/x86/kernel/e820.c	2009-05-06 11:35:49.000000000 +0200
@@ -1332,7 +1332,7 @@ void __init e820_reserve_resources(void)
 	struct resource *res;
 	u64 end;
 
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	res = alloc_bootmem(sizeof(struct resource) * e820.nr_map);
 	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
--- linux-2.6.31-rc1/arch/x86/mm/init_32.c	2009-06-26 17:49:43.000000000 +0200
+++ 2.6.31-rc1-avoid-alloc_bootmem_low/arch/x86/mm/init_32.c	2009-04-27 12:30:18.000000000 +0200
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
 
--- linux-2.6.31-rc1/drivers/firmware/memmap.c	2009-06-26 17:49:44.000000000 +0200
+++ 2.6.31-rc1-avoid-alloc_bootmem_low/drivers/firmware/memmap.c	2009-04-27 12:29:07.000000000 +0200
@@ -164,7 +164,7 @@ int __init firmware_map_add_early(u64 st
 {
 	struct firmware_map_entry *entry;
 
-	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
+	entry = alloc_bootmem(sizeof(struct firmware_map_entry));
 	if (WARN_ON(!entry))
 		return -ENOMEM;
 



