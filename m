Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbYAaHiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbYAaHiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbYAaHhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:37:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:26792 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754521AbYAaHhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:37:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="510975867"
Subject: [PATCH 5/5] x86: EFI memory mapping changes according to changes
	to ioremap and c_p_a
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:36:08 +0800
Message-Id: <1201764968.12950.26.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:35:05.0777 (UTC) FILETIME=[CC5E2A10:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixes EFI runtime memory mapping code according to the
changes to ioremap() and change_page_attr().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |   53 ++++++++++++++++----------------------------
 arch/x86/kernel/efi_64.c |   56 ++++++++++++++++++++++++++++++++++-------------
 arch/x86/mm/ioremap.c    |    6 ++---
 include/asm-x86/efi.h    |   12 ++++++++--
 include/asm-x86/io_32.h  |    8 ++++++
 include/asm-x86/io_64.h  |    8 ++++++
 6 files changed, 90 insertions(+), 53 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -56,6 +56,7 @@ struct efi_memory_map memmap;
 
 struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
+int efi_rt_mapping_ready __initdata;
 
 static int __init setup_noefi(char *arg)
 {
@@ -379,32 +380,6 @@ void __init efi_init(void)
 #endif
 }
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-static void __init runtime_code_page_mkexec(void)
-{
-	efi_memory_desc_t *md;
-	unsigned long end;
-	void *p;
-
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
-
-	/* Make EFI runtime service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-		if (md->type == EFI_RUNTIME_SERVICES_CODE &&
-		    (end >> PAGE_SHIFT) <= max_pfn_mapped) {
-			set_memory_x(md->virt_addr, md->num_pages);
-			set_memory_uc(md->virt_addr, md->num_pages);
-		}
-	}
-	__flush_tlb_all();
-}
-#else
-static inline void __init runtime_code_page_mkexec(void) { }
-#endif
-
 /*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, look through the EFI memmap and map every region that
@@ -419,6 +394,8 @@ void __init efi_enter_virtual_mode(void)
 	efi_status_t status;
 	unsigned long end;
 	void *p;
+	enum ioremap_mode mode;
+	enum ioremap_xmode xmode;
 
 	efi.systab = NULL;
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -426,13 +403,23 @@ void __init efi_enter_virtual_mode(void)
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
-		if ((md->attribute & EFI_MEMORY_WB) &&
-		    ((end >> PAGE_SHIFT) <= max_pfn_mapped))
+		mode = (md->attribute & EFI_MEMORY_WB) ?
+			IOR_MODE_CACHED : IOR_MODE_UNCACHED;
+		xmode = md->type == EFI_RUNTIME_SERVICES_CODE ?
+			IOR_XMODE_EXEC : IOR_XMODE_UNEXEC;
+		if ((end >> PAGE_SHIFT) <= max_pfn_mapped) {
 			md->virt_addr = (unsigned long)__va(md->phys_addr);
-		else
-			md->virt_addr = (unsigned long)
-				efi_ioremap(md->phys_addr,
-					    md->num_pages << EFI_PAGE_SHIFT);
+			/* Assume pages are mapped as WB */
+			if (mode == IOR_MODE_UNCACHED)
+				set_memory_uc(md->virt_addr, md->num_pages);
+			/* Assume pages are mapped as unexecutable */
+			if ((__supported_pte_mask & _PAGE_NX) &&
+			    xmode == IOR_XMODE_EXEC)
+				set_memory_x(md->virt_addr, md->num_pages);
+		} else
+			md->virt_addr = (unsigned long)__efi_ioremap(
+				md->phys_addr, md->num_pages << EFI_PAGE_SHIFT,
+				mode, xmode);
 		if (!md->virt_addr)
 			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
@@ -442,6 +429,7 @@ void __init efi_enter_virtual_mode(void)
 				(md->virt_addr - md->phys_addr +
 				 (unsigned long)efi_phys.systab);
 	}
+	efi_rt_mapping_ready = 1;
 
 	BUG_ON(!efi.systab);
 
@@ -473,7 +461,6 @@ void __init efi_enter_virtual_mode(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
-	runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 }
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -23,9 +23,9 @@
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/io.h>
 #include <linux/efi.h>
 #include <linux/uaccess.h>
-#include <linux/io.h>
 #include <linux/reboot.h>
 
 #include <asm/setup.h>
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
 
@@ -66,7 +66,7 @@ static void __init early_runtime_code_ma
 	efi_memory_desc_t *md;
 	void *p;
 
-	if (!(__supported_pte_mask & _PAGE_NX))
+	if (!(__supported_pte_mask & _PAGE_NX) || efi_rt_mapping_ready)
 		return;
 
 	/* Make EFI runtime service code area executable */
@@ -109,26 +109,52 @@ void __init efi_reserve_bootmem(void)
 				memmap.nr_map * memmap.desc_size);
 }
 
-void __iomem * __init efi_ioremap(unsigned long offset,
-				  unsigned long size)
+void __iomem __init *__efi_ioremap(unsigned long phys_addr,
+				    unsigned long size,
+				    enum ioremap_mode mode,
+				    enum ioremap_xmode xmode)
 {
 	static unsigned pages_mapped;
-	unsigned long last_addr;
-	unsigned i, pages;
+	unsigned long addr, pages;
+	pgprot_t prot;
+
+	/* phys_addr and size must be page aligned */
+	if ((phys_addr & ~PAGE_MASK) || (size & ~PAGE_MASK))
+		return NULL;
 
-	last_addr = offset + size - 1;
-	offset &= PAGE_MASK;
-	pages = (PAGE_ALIGN(last_addr) - offset) >> PAGE_SHIFT;
+	switch (mode) {
+	case IOR_MODE_UNCACHED:
+	default:
+		prot = PAGE_KERNEL_NOCACHE;
+		break;
+	case IOR_MODE_CACHED:
+		prot = PAGE_KERNEL;
+		break;
+	}
+
+	if ((__supported_pte_mask & _PAGE_NX) && xmode == IOR_XMODE_EXEC)
+		prot = __pgprot(pgprot_val(prot) & ~_PAGE_NX);
+
+	pages = size >> PAGE_SHIFT;
 	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
 		return NULL;
 
-	for (i = 0; i < pages; i++) {
+	for (addr = phys_addr; addr < phys_addr + size; addr += PAGE_SIZE) {
 		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     offset, PAGE_KERNEL_EXEC_NOCACHE);
-		offset += PAGE_SIZE;
+			     addr, prot);
 		pages_mapped++;
 	}
 
+	if (ioremap_change_attr(phys_addr, size, mode, xmode) < 0) {
+		for (addr = phys_addr; addr < phys_addr + size;
+		     addr += PAGE_SIZE) {
+			pages_mapped--;
+			__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
+				     0, __pgprot(0));
+		}
+		return NULL;
+	}
+
 	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
 					     (pages_mapped - pages));
 }
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -33,7 +33,8 @@ extern unsigned long asmlinkage efi_call
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap(addr, size)
+#define __efi_ioremap(addr, size, mode, xmode)	\
+	__ioremap(addr, size, mode, xmode)
 
 #else /* !CONFIG_X86_32 */
 
@@ -86,7 +87,12 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void *efi_ioremap(unsigned long offset, unsigned long size);
+enum ioremap_mode;
+enum ioremap_xmode;
+extern void __iomem *__efi_ioremap(unsigned long phys_addr,
+				   unsigned long size,
+				   enum ioremap_mode mode,
+				   enum ioremap_xmode xmode);
 
 #endif /* CONFIG_X86_32 */
 
@@ -94,4 +100,6 @@ extern void efi_reserve_bootmem(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
+extern int efi_rt_mapping_ready;
+
 #endif
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -65,9 +65,9 @@ int page_is_ram(unsigned long pagenr)
  * Fix up the linear direct mapping of the kernel to avoid cache attribute
  * conflicts.
  */
-static int ioremap_change_attr(unsigned long paddr, unsigned long size,
-			       enum ioremap_mode mode,
-			       enum ioremap_xmode xmode)
+int ioremap_change_attr(unsigned long paddr, unsigned long size,
+			enum ioremap_mode mode,
+			enum ioremap_xmode xmode)
 {
 	unsigned long vaddr = (unsigned long)__va(paddr);
 	unsigned long nrpages = size >> PAGE_SHIFT;
--- a/include/asm-x86/io_32.h
+++ b/include/asm-x86/io_32.h
@@ -110,6 +110,14 @@ enum ioremap_xmode {
 	IOR_XMODE_UNEXEC,
 };
 
+/*
+ * Fix up the linear direct mapping of the kernel to avoid cache attribute
+ * conflicts.
+ */
+extern int ioremap_change_attr(unsigned long paddr, unsigned long size,
+			       enum ioremap_mode mode,
+			       enum ioremap_xmode xmode);
+
 extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 			       enum ioremap_mode mode,
 			       enum ioremap_xmode xmode);
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -163,6 +163,14 @@ enum ioremap_xmode {
 	IOR_XMODE_UNEXEC,
 };
 
+/*
+ * Fix up the linear direct mapping of the kernel to avoid cache attribute
+ * conflicts.
+ */
+extern int ioremap_change_attr(unsigned long paddr, unsigned long size,
+			       enum ioremap_mode mode,
+			       enum ioremap_xmode xmode);
+
 extern void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 			       enum ioremap_mode mode,
 			       enum ioremap_xmode xmode);

