Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbYAYFz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbYAYFz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYAYFzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:55:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:17699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbYAYFzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:55:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="507933391"
Subject: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:55:01 +0800
Message-Id: <1201240501.15972.46.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:18.0355 (UTC) FILETIME=[B9584C30:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some bugs of making EFI runtime code executable.

- Use change_page_attr in i386 too. Because the runtime code may be
  mapped not through ioremap.

- If there is no _PAGE_NX in __supported_pte_mask, the change_page_attr
  is not called.

- Make efi_ioremap map pages as PAGE_KERNEL_EXEC, because EFI runtime
  code may be mapped through efi_ioremap.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |   35 ++++++++++++++++++++++++++++++-----
 arch/x86/kernel/efi_64.c |   26 ++++++--------------------
 include/asm-x86/efi.h    |    1 -
 3 files changed, 36 insertions(+), 26 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -40,6 +40,8 @@
 #include <asm/setup.h>
 #include <asm/efi.h>
 #include <asm/time.h>
+#include <asm/cacheflush.h>
+#include <asm/tlbflush.h>
 
 #define EFI_DEBUG	1
 #define PFX 		"EFI: "
@@ -379,6 +381,32 @@ void __init efi_init(void)
 #endif
 }
 
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static void __init runtime_code_page_mkexec(void)
+{
+	efi_memory_desc_t *md;
+	unsigned long end;
+	void *p;
+
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return;
+
+	/* Make EFI runtime service code area executable */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if (md->type == EFI_RUNTIME_SERVICES_CODE &&
+		    (end >> PAGE_SHIFT) <= end_pfn_map)
+			change_page_attr_addr(md->virt_addr,
+					      md->num_pages,
+					      PAGE_KERNEL_EXEC);
+	}
+	__flush_tlb_all();
+}
+#else
+static inline void __init runtime_code_page_mkexec(void) { }
+#endif
+
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -399,9 +427,9 @@ void __init efi_enter_virtual_mode(void)
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		if ((md->attribute & EFI_MEMORY_WB) &&
-		    (((md->phys_addr + (md->num_pages<<EFI_PAGE_SHIFT)) >>
-		      PAGE_SHIFT) < end_pfn_map))
+		    ((end >> PAGE_SHIFT) <= end_pfn_map))
 			md->virt_addr = (unsigned long)__va(md->phys_addr);
 		else
 			md->virt_addr = (unsigned long)
@@ -410,7 +438,6 @@ void __init efi_enter_virtual_mode(void)
 		if (!md->virt_addr)
 			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
 		    ((unsigned long)efi_phys.systab < end))
 			efi.systab = (efi_system_table_t *)(unsigned long)
@@ -448,9 +475,7 @@ void __init efi_enter_virtual_mode(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
-#ifdef CONFIG_X86_64
 	runtime_code_page_mkexec();
-#endif
 }
 
 /*
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -33,7 +33,6 @@
 #include <asm/e820.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
-#include <asm/cacheflush.h>
 #include <asm/proto.h>
 #include <asm/efi.h>
 
@@ -55,7 +54,7 @@ static void __init early_mapping_set_exe
 		else
 			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
 					    __supported_pte_mask));
-		if (pte_huge(*kpte))
+		if (level == 4)
 			start = (start + PMD_SIZE) & PMD_MASK;
 		else
 			start = (start + PAGE_SIZE) & PAGE_MASK;
@@ -67,6 +66,9 @@ static void __init early_runtime_code_ma
 	efi_memory_desc_t *md;
 	void *p;
 
+	if (!(__supported_pte_mask & _PAGE_NX))
+		return;
+
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -116,22 +118,6 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __init runtime_code_page_mkexec(void)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	/* Make EFI runtime service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if (md->type == EFI_RUNTIME_SERVICES_CODE)
-			change_page_attr_addr(md->virt_addr,
-					      md->num_pages,
-					      PAGE_KERNEL_EXEC);
-	}
-	__flush_tlb_all();
-}
-
 void __iomem * __init efi_ioremap(unsigned long offset,
 				  unsigned long size)
 {
@@ -146,8 +132,8 @@ void __iomem * __init efi_ioremap(unsign
 		return NULL;
 
 	for (i = 0; i < pages; i++) {
-		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-				   offset);
+		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
+			     offset, PAGE_KERNEL_EXEC);
 		offset += PAGE_SIZE;
 		pages_mapped++;
 	}
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -95,6 +95,5 @@ extern void *efi_ioremap(unsigned long o
 extern void efi_reserve_bootmem(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
-extern void runtime_code_page_mkexec(void);
 
 #endif

