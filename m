Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYBAJme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYBAJme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYBAJm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:42:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:48163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbYBAJmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:42:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="373856712"
Subject: [PATCH 4/4] x86: efi update for set_memory_xx
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Feb 2008 17:35:00 +0800
Message-Id: <1201858500.4051.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 01 Feb 2008 09:33:55.0338 (UTC) FILETIME=[905496A0:01C864B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch updates EFI runtime memory mapping code according to the
changes to set_memory_xx.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |   48 +++++++++++++++++++++++------------------------
 arch/x86/kernel/efi_64.c |   40 ++++++++++++++++++++++++++-------------
 include/asm-x86/efi.h    |    8 +++++--
 3 files changed, 57 insertions(+), 39 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -379,31 +379,20 @@ void __init efi_init(void)
 #endif
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
-	unsigned long end;
+	unsigned long pages;
 	void *p;
 
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
-
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-		if (md->type == EFI_RUNTIME_SERVICES_CODE &&
-		    (end >> PAGE_SHIFT) <= max_pfn_mapped) {
-			set_memory_x(md->virt_addr, md->num_pages);
-			set_memory_uc(md->virt_addr, md->num_pages);
-		}
+		pages = (md->num_pages << EFI_PAGE_SHIFT) >> PAGE_SHIFT;
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			set_memory_x(md->virt_addr, md->phys_addr, pages);
 	}
-	__flush_tlb_all();
 }
-#else
-static inline void __init runtime_code_page_mkexec(void) { }
-#endif
 
 /*
  * This function will switch the EFI runtime services to virtual mode.
@@ -417,25 +406,35 @@ void __init efi_enter_virtual_mode(void)
 {
 	efi_memory_desc_t *md;
 	efi_status_t status;
-	unsigned long end;
+	unsigned long end, size, pages;
 	void *p;
+	int cache;
 
 	efi.systab = NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-		if ((md->attribute & EFI_MEMORY_WB) &&
-		    ((end >> PAGE_SHIFT) <= max_pfn_mapped))
+		size = md->num_pages << EFI_PAGE_SHIFT;
+		pages = size >> PAGE_SHIFT;
+		end = md->phys_addr + size;
+		cache = !!(md->attribute & EFI_MEMORY_WB);
+		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
 			md->virt_addr = (unsigned long)__va(md->phys_addr);
+			if (!cache)
+				set_memory_uc(md->virt_addr, md->phys_addr,
+					      pages);
+		} else if (cache)
+			md->virt_addr = (unsigned long)efi_ioremap_cache(
+				md->phys_addr, size);
 		else
-			md->virt_addr = (unsigned long)
-				efi_ioremap(md->phys_addr,
-					    md->num_pages << EFI_PAGE_SHIFT);
-		if (!md->virt_addr)
+			md->virt_addr = (unsigned long)efi_ioremap_nocache(
+				md->phys_addr, size);
+		if (!md->virt_addr) {
 			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
+			continue;
+		}
 		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
 		    ((unsigned long)efi_phys.systab < end))
 			efi.systab = (efi_system_table_t *)(unsigned long)
@@ -473,7 +472,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
-	runtime_code_page_mkexec();
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 }
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -54,10 +54,10 @@ static void __init early_mapping_set_exe
 		else
 			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
 					    __supported_pte_mask));
-		if (level == 4)
-			start = (start + PMD_SIZE) & PMD_MASK;
-		else
+		if (level == PG_LEVEL_4K)
 			start = (start + PAGE_SIZE) & PAGE_MASK;
+		else
+			start = (start + PMD_SIZE) & PMD_MASK;
 	}
 }
 
@@ -109,26 +109,40 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __iomem * __init efi_ioremap(unsigned long offset,
-				  unsigned long size)
+static void __iomem __init *__efi_ioremap(unsigned long phys_addr,
+					  unsigned long size,
+					  int cache)
 {
 	static unsigned pages_mapped;
-	unsigned long last_addr;
-	unsigned i, pages;
+	unsigned long addr, pages;
+	pgprot_t prot;
 
-	last_addr = offset + size - 1;
-	offset &= PAGE_MASK;
-	pages = (PAGE_ALIGN(last_addr) - offset) >> PAGE_SHIFT;
+	/* phys_addr and size must be page aligned */
+	if ((phys_addr & ~PAGE_MASK) || (size & ~PAGE_MASK))
+		return NULL;
+	pages = size >> PAGE_SHIFT;
 	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
 		return NULL;
 
-	for (i = 0; i < pages; i++) {
+	prot = cache ? PAGE_KERNEL : PAGE_KERNEL_NOCACHE;
+	for (addr = phys_addr; addr < phys_addr + size; addr += PAGE_SIZE) {
 		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     offset, PAGE_KERNEL_EXEC_NOCACHE);
-		offset += PAGE_SIZE;
+			     addr, prot);
 		pages_mapped++;
 	}
 
 	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
 					     (pages_mapped - pages));
 }
+
+void __iomem __init *efi_ioremap_cache(unsigned long phys_addr,
+				       unsigned long size)
+{
+	return __efi_ioremap(phys_addr, size, 1);
+}
+
+void __iomem __init *efi_ioremap_nocache(unsigned long phys_addr,
+					 unsigned long size)
+{
+	return __efi_ioremap(phys_addr, size, 0);
+}
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -33,7 +33,8 @@ extern unsigned long asmlinkage efi_call
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap(addr, size)
+#define efi_ioremap_cache(addr, size)		ioremap_cache(addr, size)
+#define efi_ioremap_nocache(addr, size)		ioremap_nocache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -86,7 +87,10 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void *efi_ioremap(unsigned long offset, unsigned long size);
+extern void __iomem *efi_ioremap_cache(unsigned long phys_addr,
+				       unsigned long size);
+extern void __iomem *efi_ioremap_nocache(unsigned long phys_addr,
+					 unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 

