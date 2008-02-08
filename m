Return-Path: <linux-kernel-owner+w=401wt.eu-S1758458AbYBHN24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458AbYBHN24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbYBHN2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:28:03 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56871 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759240AbYBHN2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:28:00 -0500
From: Andi Kleen <ak@suse.de>
References: <20080208227.168531243@suse.de>
In-Reply-To: <20080208227.168531243@suse.de>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/5] Switch i386 early boot page table initilization over to use required_static_prot()
Message-Id: <20080208132748.3DA011B41BB@basil.firstfloor.org>
Date: Fri,  8 Feb 2008 14:27:48 +0100 (CET)
X-OriginalArrivalTime: 08 Feb 2008 13:21:27.0966 (UTC) FILETIME=[82D28BE0:01C86A55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This makes it use the same tests for this as pageattr.

Does not check advisory protections yet because that is not needed yet.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/mm/init_32.c        |   15 +++------------
 arch/x86/mm/pageattr.c       |    2 +-
 include/asm-x86/cacheflush.h |    3 +++
 3 files changed, 7 insertions(+), 13 deletions(-)

Index: linux/arch/x86/mm/init_32.c
===================================================================
--- linux.orig/arch/x86/mm/init_32.c
+++ linux/arch/x86/mm/init_32.c
@@ -140,13 +140,6 @@ page_table_range_init(unsigned long star
 	}
 }
 
-static inline int is_kernel_text(unsigned long addr)
-{
-	if (addr >= PAGE_OFFSET && addr <= (unsigned long)__init_end)
-		return 1;
-	return 0;
-}
-
 /*
  * This maps the physical memory to kernel virtual address space, a total
  * of max_low_pfn pages, by creating page tables starting from address
@@ -189,9 +182,7 @@ static void __init kernel_physical_mappi
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
 					PAGE_OFFSET + PAGE_SIZE-1;
 
-				if (is_kernel_text(addr) ||
-				    is_kernel_text(addr2))
-					prot = PAGE_KERNEL_LARGE_EXEC;
+				prot = required_static_prot(prot, addr, addr2);
 
 				set_pmd(pmd, pfn_pmd(pfn, prot));
 
@@ -205,8 +196,8 @@ static void __init kernel_physical_mappi
 			     pte++, pfn++, pte_ofs++, addr += PAGE_SIZE) {
 				pgprot_t prot = PAGE_KERNEL;
 
-				if (is_kernel_text(addr))
-					prot = PAGE_KERNEL_EXEC;
+				prot = required_static_prot(prot, addr,
+							addr + PAGE_SIZE - 1);
 
 				set_pte(pte, pfn_pte(pfn, prot));
 			}
Index: linux/include/asm-x86/cacheflush.h
===================================================================
--- linux.orig/include/asm-x86/cacheflush.h
+++ linux/include/asm-x86/cacheflush.h
@@ -45,6 +45,9 @@ int set_memory_4k(unsigned long addr, in
 
 void clflush_cache_range(void *addr, unsigned int size);
 
+pgprot_t required_static_prot(pgprot_t prot, unsigned long start,
+				unsigned long end);
+
 #ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void);
 #endif
Index: linux/arch/x86/mm/pageattr.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr.c
+++ linux/arch/x86/mm/pageattr.c
@@ -156,7 +156,7 @@ static unsigned long virt_to_highmap(voi
  * right (again, ioremap() on BIOS memory is not uncommon) so this function
  * checks and fixes these known static required protection bits.
  */
-static pgprot_t 
+pgprot_t
 required_static_prot(pgprot_t prot, unsigned long start, unsigned long end)
 {
 	pgprot_t forbidden = __pgprot(0);
