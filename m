Return-Path: <linux-kernel-owner+w=401wt.eu-S1763449AbYBLUbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763449AbYBLUbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYBLUbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:31:00 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:59437 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYBLUa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:30:59 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080212930.359942483@suse.de>
To: ying.huang@intel.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/1] RFC: Fix some EFI problems v2
Date: Tue, 12 Feb 2008 21:30:57 +0100 (CET)
X-OriginalArrivalTime: 12 Feb 2008 20:24:36.0299 (UTC) FILETIME=[4919B9B0:01C86DB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From code review the EFI memory map handling has a couple of problems:

- The test for _WB memory was reversed so it would set cache able memory
to uncached
- It would always set a wrong uninitialized zero address to uncached
(so I suspect it always set the first few pages in phys memory to uncached,
that is why it may have gone unnoticed) 
- It would call set_memory_x() on a fixmap address that it doesn't
handle correctly.
- Some other problems I commented in the code (but was unable to solve
for now) 

I changed the ioremaps to set the correct caching attributes
and also corrected the ordering so it looks roughly correct now.

This is an RFC, because I don't have a EFI system to test.

v2: Really fix the use before initialization problem. Thanks Thomas!
    Fix compiler warning
    Add one pair of brackets.

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
@@ -423,13 +423,16 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if ((end >> PAGE_SHIFT) <= max_pfn_mapped)
+		/* RED-PEN does not handle overlapped areas */
+		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
 			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size);
-
-		if (md->attribute & EFI_MEMORY_WB)
-			set_memory_uc(md->virt_addr, size);
+			/* RED-PEN spec and ia64 have a lot more flags */
+			if (!(md->attribute & EFI_MEMORY_WB))
+				set_memory_uc((unsigned long)va, size);
+		} else {
+			va = efi_ioremap(md->phys_addr, size,
+				!!(md->attribute & EFI_MEMORY_WB));
+		}
 
 		md->virt_addr = (u64) (unsigned long) va;
 
Index: linux/arch/x86/kernel/efi_64.c
===================================================================
--- linux.orig/arch/x86/kernel/efi_64.c
+++ linux/arch/x86/kernel/efi_64.c
@@ -109,7 +109,8 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size,
+				  int cache)
 {
 	static unsigned pages_mapped;
 	unsigned i, pages;
@@ -124,7 +125,8 @@ void __iomem * __init efi_ioremap(unsign
 
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
 
