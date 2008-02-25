Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYBYHSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYBYHSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 02:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYBYHRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 02:17:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:33072 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYBYHRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 02:17:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,399,1199692800"; 
   d="scan'208";a="259424198"
Subject: [PATCH] x86: EFI_PAGE_SHIFT fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Feb 2008 15:18:37 +0800
Message-Id: <1203923917.4707.58.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 25 Feb 2008 07:17:07.0898 (UTC) FILETIME=[6E3AA1A0:01C8777E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make x86 EFI code works when EFI_PAGE_SHIFT != PAGE_SHIFT. The
memrage_efi_to_native() provided in this patch can be used on other
EFI platform such as IA64 too.

This patch has been tested on Intel x86_64 platform with EFI 64/32
firmware.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |   18 +++++++++++++-----
 arch/x86/kernel/efi_64.c |   12 ++++++------
 include/linux/efi.h      |    7 +++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -383,6 +383,7 @@ static void __init runtime_code_page_mke
 {
 	efi_memory_desc_t *md;
 	void *p;
+	u64 addr, npages;
 
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -391,7 +392,10 @@ static void __init runtime_code_page_mke
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
-		set_memory_x(md->virt_addr, md->num_pages);
+		addr = md->virt_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&addr, &npages);
+		set_memory_x(addr, npages);
 	}
 }
 
@@ -408,7 +412,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab;
+	u64 end, systab, addr, npages;
 	void *p, *va;
 
 	efi.systab = NULL;
@@ -420,7 +424,7 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if ((end >> PAGE_SHIFT) <= max_pfn_mapped)
+		if (PFN_UP(end) <= max_pfn_mapped)
 			va = __va(md->phys_addr);
 		else
 			va = efi_ioremap(md->phys_addr, size);
@@ -433,8 +437,12 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
-		if (!(md->attribute & EFI_MEMORY_WB))
-			set_memory_uc(md->virt_addr, md->num_pages);
+		if (!(md->attribute & EFI_MEMORY_WB)) {
+			addr = md->virt_addr;
+			npages = md->num_pages;
+			memrange_efi_to_native(&addr, &npages);
+			set_memory_uc(addr, npages);
+		}
 
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -105,14 +105,14 @@ void __init efi_reserve_bootmem(void)
 
 void __iomem * __init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
-	static unsigned pages_mapped;
+	static unsigned pages_mapped __initdata;
 	unsigned i, pages;
+	unsigned long offset;
 
-	/* phys_addr and size must be page aligned */
-	if ((phys_addr & ~PAGE_MASK) || (size & ~PAGE_MASK))
-		return NULL;
+	pages = PFN_UP(phys_addr + size) - PFN_DOWN(phys_addr);
+	offset = phys_addr & ~PAGE_MASK;
+	phys_addr &= PAGE_MASK;
 
-	pages = size >> PAGE_SHIFT;
 	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
 		return NULL;
 
@@ -124,5 +124,5 @@ void __iomem * __init efi_ioremap(unsign
 	}
 
 	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
-					     (pages_mapped - pages));
+					     (pages_mapped - pages)) + offset;
 }
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -18,6 +18,7 @@
 #include <linux/proc_fs.h>
 #include <linux/rtc.h>
 #include <linux/ioport.h>
+#include <linux/pfn.h>
 
 #include <asm/page.h>
 #include <asm/system.h>
@@ -394,4 +395,10 @@ struct efi_generic_dev_path {
 	u16 length;
 } __attribute ((packed));
 
+static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
+{
+	*npages = PFN_UP(*addr + (*npages<<EFI_PAGE_SHIFT)) - PFN_DOWN(*addr);
+	*addr &= PAGE_MASK;
+}
+
 #endif /* _LINUX_EFI_H */

