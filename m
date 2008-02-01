Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbYBAJ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbYBAJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbYBAJx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:53:27 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58380 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbYBAJx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:53:26 -0500
From: Andi Kleen <ak@suse.de>
References: <200802011053.107168490@suse.de>
In-Reply-To: <200802011053.107168490@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/12] GBPAGES: Do kernel direct mapping at boot using GB pages
Message-Id: <20080201095324.5F1FF1B416F@basil.firstfloor.org>
Date: Fri,  1 Feb 2008 10:53:24 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 09:47:06.0874 (UTC) FILETIME=[681F65A0:01C864B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The AMD Fam10h CPUs support new Gigabyte page table entry for 
mapping 1GB at a time. Use this for the kernel direct mapping. 

Only done for 64bit because i386 does not support GB page tables.

This only applies to the data portion of the direct mapping; the
kernel text mapping stays with 2MB pages because the AMD Fam10h
microarchitecture does not support GB ITLBs and AMD recommends 
against using GB mappings for code.

GBpage are disabled when DEBUG_PAGEALLOC is enabled, because
DEBUG_PAGEALLOC causes recursion in cpa() and with gbpages
the potential max recursion depth is much deeper. 

Can be disabled with direct_gbpages=off

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_64.c |   35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

Index: linux/arch/x86/mm/init_64.c
===================================================================
--- linux.orig/arch/x86/mm/init_64.c
+++ linux/arch/x86/mm/init_64.c
@@ -339,7 +339,14 @@ phys_pud_init(pud_t *pud_page, unsigned 
 		}
 
 		if (pud_val(*pud)) {
-			phys_pmd_update(pud, addr, end);
+			if (!pud_large(*pud))
+				phys_pmd_update(pud, addr, end);
+			continue;
+		}
+
+		if (direct_gbpages == GBP_ON) {
+			set_pte((pte_t *)pud,
+				pfn_pte(addr >> PAGE_SHIFT, PAGE_KERNEL_LARGE));
 			continue;
 		}
 
@@ -360,9 +367,11 @@ static void __init find_early_table_spac
 	unsigned long puds, pmds, tables, start;
 
 	puds = (end + PUD_SIZE - 1) >> PUD_SHIFT;
-	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
-	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE) +
-		 round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	tables = round_up(puds * sizeof(pud_t), PAGE_SIZE);
+	if (direct_gbpages == GBP_ON) {
+		pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
+		tables += round_up(pmds * sizeof(pmd_t), PAGE_SIZE);
+	}
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
@@ -389,6 +398,20 @@ static void __init find_early_table_spac
 		(table_start << PAGE_SHIFT) + tables);
 }
 
+static void __init init_gbpages(void)
+{
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/* debug pagealloc causes too much recursion with gbpages */
+	if (direct_gbpages != GBP_DEFAULT)
+		return;
+#endif
+	if (direct_gbpages != GBP_OFF && cpu_has_gbpages) {
+		printk(KERN_INFO "Using GB pages for direct mapping\n");
+		direct_gbpages = GBP_ON;
+	} else
+		direct_gbpages = GBP_OFF;
+}
+
 /*
  * Setup the direct mapping of the physical memory at PAGE_OFFSET.
  * This runs before bootmem is initialized and gets pages directly from
@@ -407,8 +430,10 @@ void __init_refok init_memory_mapping(un
 	 * memory mapped. Unfortunately this is done currently before the
 	 * nodes are discovered.
 	 */
-	if (!after_bootmem)
+	if (!after_bootmem) {
+		init_gbpages();
 		find_early_table_space(end);
+	}
 
 	start = (unsigned long)__va(start);
 	end = (unsigned long)__va(end);
