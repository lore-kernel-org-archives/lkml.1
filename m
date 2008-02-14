Return-Path: <linux-kernel-owner+w=401wt.eu-S1765294AbYBNNNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765294AbYBNNNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 08:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYBNNN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 08:13:26 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:63781 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYBNNNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 08:13:25 -0500
Date: Thu, 14 Feb 2008 14:13:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, ying.huang@intel.com
Subject: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080214131317.GA27769@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 14 Feb 2008 13:07:00.0483 (UTC) FILETIME=[7C3DA530:01C86F0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix left over EFI cache mapping problems

[History: this was originally part of a larger patch that got
partially added earlier. This patch fixes the left-over bugs
and also fixes another bug I noticed while revising this]

cpa/set_memory_* does not properly support ioremap or fixmap
(efi_ioremap on 64bit returns fixmap) addresses. In particular 
it will not correctly change the alias in the direct mapping
and then cause illegal cache attribute aliases.

So using it for efi_ioremap is wrong at the current time
(it might be possible to fix cpa in the future to handle
this correctly, but that requires much more work is probably not i
appropiate for .25)

Fix efi_ioremap() instead to directly set the correct caching
attributes and then set the direct mapping manually.

There was also another problem I noticed: the previous call to 
set_memory_uc() passed in bytes as size, but set_memory_* 
requires pages. So it would always set far more memory
to uncached than really needed. Fixed that one too.
[This problem was not fixed in the earlier patchkit, but is now]

I also commented a few more potential (but likely not urgent)
corner cases.

Requires the generic ioremap attribute fix I sent earlier
to work correctly on 32bit.

Cc: ying.huang@intel.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/efi.c    |   14 ++++++++------
 arch/x86/kernel/efi_64.c |    6 ++++--
 include/asm-x86/efi.h    |    5 +++--
 3 files changed, 15 insertions(+), 10 deletions(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c
+++ linux/arch/x86/kernel/efi.c
@@ -413,17 +413,31 @@ void __init efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		int cached;
+		unsigned numpages;
+
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 
+		/*
+		 * RED-PEN The spec (and ia64) has a lot more memory
+		 *         attribute flags should we handle those too?
+		 */
+ 		cached = !!(md->attribute & EFI_MEMORY_WB);
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
+		numpages = ALIGN(size, PAGE_SIZE) >> PAGE_SHIFT;
 
-		if ((end >> PAGE_SHIFT) <= max_pfn_mapped)
+		/* RED-PEN does not handle overlapping */
+		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
 			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size);
+			/* RED-PEN someone else could UCed it. */
+			if (!cached)
+				set_memory_uc((unsigned long)va, numpages);
+		} else {
+			va = efi_ioremap(md->phys_addr, size, cached);
+		}
 
 		md->virt_addr = (u64) (unsigned long) va;
 
@@ -433,9 +447,6 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		if (!(md->attribute & EFI_MEMORY_WB))
-			set_memory_uc(md->virt_addr, size);
-
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
Index: linux/arch/x86/kernel/efi_64.c
===================================================================
--- linux.orig/arch/x86/kernel/efi_64.c
+++ linux/arch/x86/kernel/efi_64.c
@@ -103,7 +103,8 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size,
+				  int cache)
 {
 	static unsigned pages_mapped;
 	unsigned i, pages;
@@ -118,7 +119,8 @@ void __iomem * __init efi_ioremap(unsign
 
 	for (i = 0; i < pages; i++) {
 		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     phys_addr, PAGE_KERNEL);
+			     phys_addr,
+			     cache ? PAGE_KERNEL : PAGE_KERNEL_NOCACHE);
 		phys_addr += PAGE_SIZE;
 		pages_mapped++;
 	}
Index: linux/include/asm-x86/efi.h
===================================================================
--- linux.orig/include/asm-x86/efi.h
+++ linux/include/asm-x86/efi.h
@@ -33,7 +33,8 @@ extern unsigned long asmlinkage efi_call
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, cache)	\
+	(cache ? ioremap_cache(addr, size) : ioremap_nocache(addr, size))
 
 #else /* !CONFIG_X86_32 */
 
@@ -86,7 +87,7 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void *efi_ioremap(unsigned long addr, unsigned long size);
+extern void *efi_ioremap(unsigned long addr, unsigned long size, int cache);
 
 #endif /* CONFIG_X86_32 */
 
