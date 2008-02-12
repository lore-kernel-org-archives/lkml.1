Return-Path: <linux-kernel-owner+w=401wt.eu-S1763903AbYBLUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763903AbYBLUKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYBLUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:10:27 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58195 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbYBLUK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:10:26 -0500
From: Andi Kleen <ak@suse.de>
References: <20080212910.912621456@suse.de>
In-Reply-To: <20080212910.912621456@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] Remove max_pfn_mapped
Message-Id: <20080212201021.E6FCF1B41B3@basil.firstfloor.org>
Date: Tue, 12 Feb 2008 21:10:21 +0100 (CET)
X-OriginalArrivalTime: 12 Feb 2008 20:04:00.0379 (UTC) FILETIME=[686F4CB0:01C86DB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that 32bit and 64bit have end_pfn_map always use end_pfn_map
directly instead of the max_pfn_mapped macro.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -424,7 +424,7 @@ void __init efi_enter_virtual_mode(void)
 		end = md->phys_addr + size;
 
 		/* RED-PEN does not handle overlapped areas */
-		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
+		if ((end >> PAGE_SHIFT) <= end_pfn_map) {
 			va = __va(md->phys_addr);
 			/* RED-PEN spec and ia64 have a lot more flags */
 			if (!(md->attribute & EFI_MEMORY_WB))
Index: linux/arch/x86/mm/ioremap.c
===================================================================
--- linux.orig/arch/x86/mm/ioremap.c
+++ linux/arch/x86/mm/ioremap.c
@@ -119,7 +119,7 @@ static void __iomem *__ioremap(unsigned 
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
-	for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
+	for (pfn = phys_addr >> PAGE_SHIFT; pfn < end_pfn_map &&
 	     (pfn << PAGE_SHIFT) < last_addr; pfn++) {
 		if (page_is_ram(pfn) && pfn_valid(pfn) &&
 		    !PageReserved(pfn_to_page(pfn)))
Index: linux/arch/x86/mm/pageattr-test.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr-test.c
+++ linux/arch/x86/mm/pageattr-test.c
@@ -46,7 +46,7 @@ static int print_split(struct split_stat
 	s->lpg = s->gpg = s->spg = s->exec = 0;
 	s->min_exec = ~0UL;
 	s->max_exec = 0;
-	for (i = 0; i < max_pfn_mapped; ) {
+	for (i = 0; i < end_pfn_map; ) {
 		unsigned long addr = (unsigned long)__va(i << PAGE_SHIFT);
 		unsigned int level;
 		pte_t *pte;
@@ -98,8 +98,8 @@ static int print_split(struct split_stat
 
 	expected = (s->gpg*GPS + s->lpg*LPS)/PAGE_SIZE + s->spg + missed;
 	if (expected != i) {
-		printk(KERN_ERR "CPA max_pfn_mapped %lu but expected %lu\n",
-			max_pfn_mapped, expected);
+		printk(KERN_ERR "CPA end_pfn_map %lu but expected %lu\n",
+			end_pfn_map, expected);
 		return 1;
 	}
 	return err;
@@ -122,22 +122,22 @@ static int pageattr_test(void)
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
 
-	bm = vmalloc((max_pfn_mapped + 7) / 8);
+	bm = vmalloc((end_pfn_map + 7) / 8);
 	if (!bm) {
 		printk(KERN_ERR "CPA Cannot vmalloc bitmap\n");
 		return -ENOMEM;
 	}
-	memset(bm, 0, (max_pfn_mapped + 7) / 8);
+	memset(bm, 0, (end_pfn_map + 7) / 8);
 
 	failed += print_split(&sa);
 	srandom32(100);
 
 	for (i = 0; i < NTEST; i++) {
-		unsigned long pfn = random32() % max_pfn_mapped;
+		unsigned long pfn = random32() % end_pfn_map;
 
 		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
 		len[i] = random32() % 100;
-		len[i] = min_t(unsigned long, len[i], max_pfn_mapped - pfn - 1);
+		len[i] = min_t(unsigned long, len[i], end_pfn_map - pfn - 1);
 
 		if (len[i] == 0)
 			len[i] = 1;
Index: linux/include/asm-x86/page.h
===================================================================
--- linux.orig/include/asm-x86/page.h
+++ linux/include/asm-x86/page.h
@@ -33,10 +33,8 @@
 
 #ifdef CONFIG_X86_64
 #include <asm/page_64.h>
-#define max_pfn_mapped		end_pfn_map
 #else
 #include <asm/page_32.h>
-#define max_pfn_mapped		end_pfn_map
 #endif	/* CONFIG_X86_64 */
 
 #define PAGE_OFFSET		((unsigned long)__PAGE_OFFSET)
