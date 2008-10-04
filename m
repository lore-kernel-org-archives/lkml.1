Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbYJDGYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbYJDGYM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYJDGYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:24:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:11979 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYJDGX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Lvs+516A1B5R2wJaq5VSHGPpWethqFfVat2FY8JKjLwYTm1chIN5L0vix/BnhdQuIO
         efNB1RlsOwg6s/y7ZcR5wCB/VVxyf7jtruu8b3GsJ8YziYOvTt3gTxgnOqutoFzppXQ5
         N0qrK0rxewlkcNMRISajEqfXf0Ni4W4hjOCGs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
Date: Fri,  3 Oct 2008 23:23:20 -0700
Message-Id: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/efi.c       |    5 +----
 arch/x86/kernel/efi_64.c    |   27 ++-------------------------
 include/asm-x86/efi.h       |    8 ++------
 include/asm-x86/fixmap_64.h |    3 ---
 4 files changed, 5 insertions(+), 38 deletions(-)

Index: linux-2.6/arch/x86/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi.c
+++ linux-2.6/arch/x86/kernel/efi.c
@@ -475,10 +475,7 @@ void __init efi_enter_virtual_mode(void)
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
 
-		if (PFN_UP(end) <= max_low_pfn_mapped)
-			va = __va(md->phys_addr);
-		else
-			va = efi_ioremap(md->phys_addr, size);
+		va = efi_ioremap(md->phys_addr, size);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
Index: linux-2.6/arch/x86/kernel/efi_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/efi_64.c
+++ linux-2.6/arch/x86/kernel/efi_64.c
@@ -46,8 +46,8 @@ static void __init early_mapping_set_exe
 {
 	unsigned long num_pages;
 
-	start &= PMD_MASK;
-	end = (end + PMD_SIZE - 1) & PMD_MASK;
+	start &= PAGE_MASK;
+	end = (end + PAGE_SIZE - 1) & PAGE_MASK;
 	num_pages = (end - start) >> PAGE_SHIFT;
 	if (executable)
 		set_memory_x((unsigned long)__va(start), num_pages);
@@ -97,26 +97,3 @@ void __init efi_call_phys_epilog(void)
 	early_runtime_code_mapping_set_exec(0);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
-{
-	static unsigned pages_mapped __initdata;
-	unsigned i, pages;
-	unsigned long offset;
-
-	pages = PFN_UP(phys_addr + size) - PFN_DOWN(phys_addr);
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-
-	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
-		return NULL;
-
-	for (i = 0; i < pages; i++) {
-		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     phys_addr, PAGE_KERNEL);
-		phys_addr += PAGE_SIZE;
-		pages_mapped++;
-	}
-
-	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
-					     (pages_mapped - pages)) + offset;
-}
Index: linux-2.6/include/asm-x86/efi.h
===================================================================
--- linux-2.6.orig/include/asm-x86/efi.h
+++ linux-2.6/include/asm-x86/efi.h
@@ -33,12 +33,8 @@ extern unsigned long asmlinkage efi_call
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap_cache(addr, size)
-
 #else /* !CONFIG_X86_32 */
 
-#define MAX_EFI_IO_PAGES	100
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
@@ -86,10 +82,10 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
-
 #endif /* CONFIG_X86_32 */
 
+#define efi_ioremap(addr, size)			ioremap_cache(addr, size)
+
 extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
Index: linux-2.6/include/asm-x86/fixmap_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/fixmap_64.h
+++ linux-2.6/include/asm-x86/fixmap_64.h
@@ -43,9 +43,6 @@ enum fixed_addresses {
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
-	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
-				  + MAX_EFI_IO_PAGES - 1,
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
