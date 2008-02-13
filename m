Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbYBMJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbYBMJff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbYBMJez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:34:55 -0500
Received: from mga03.intel.com ([143.182.124.21]:3447 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763435AbYBMJev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:34:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,345,1199692800"; 
   d="scan'208";a="378434916"
Subject: [PATCH] x86: EFI runtime code mapping enhancement
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, ThomasGleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Feb 2008 17:22:41 +0800
Message-Id: <1202894561.5026.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 13 Feb 2008 09:21:44.0845 (UTC) FILETIME=[D9E133D0:01C86E21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances EFI runtime code memory mapping as following:

- Move __supported_pte_mask & _PAGE_NX checking before invoking
  runtime_code_page_mkexec(). This makes it possible for compiler to
  eliminate runtime_code_page_mkexec() on machine without NX support.

- Use set_memory_x/nx in early_mapping_set_exec(). This eliminates the
  duplicated implementation.

This patch has been tested on Intel x86_64 platform with EFI64/32
firmware.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |    6 ++----
 arch/x86/kernel/efi_64.c |   30 ++++++++++++------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -384,9 +384,6 @@ static void __init runtime_code_page_mke
 	efi_memory_desc_t *md;
 	void *p;
 
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
-
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -476,7 +473,8 @@ void __init efi_enter_virtual_mode(void)
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
@@ -35,6 +35,7 @@
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
 #include <asm/efi.h>
+#include <asm/cacheflush.h>
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
@@ -43,22 +44,15 @@ static void __init early_mapping_set_exe
 					  unsigned long end,
 					  int executable)
 {
-	pte_t *kpte;
-	unsigned int level;
+	unsigned long num_pages;
 
-	while (start < end) {
-		kpte = lookup_address((unsigned long)__va(start), &level);
-		BUG_ON(!kpte);
-		if (executable)
-			set_pte(kpte, pte_mkexec(*kpte));
-		else
-			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
-					    __supported_pte_mask));
-		if (level == PG_LEVEL_4K)
-			start = (start + PAGE_SIZE) & PAGE_MASK;
-		else
-			start = (start + PMD_SIZE) & PMD_MASK;
-	}
+	start &= PMD_MASK;
+	end = (end + PMD_SIZE - 1) & PMD_MASK;
+	num_pages = (end - start) >> PAGE_SHIFT;
+	if (executable)
+		set_memory_x((unsigned long)__va(start), num_pages);
+	else
+		set_memory_nx((unsigned long)__va(start), num_pages);
 }
 
 static void __init early_runtime_code_mapping_set_exec(int executable)
@@ -74,7 +68,7 @@ static void __init early_runtime_code_ma
 		md = p;
 		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
 			unsigned long end;
-			end = md->phys_addr + (md->num_pages << PAGE_SHIFT);
+			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 			early_mapping_set_exec(md->phys_addr, end, executable);
 		}
 	}
@@ -84,8 +78,8 @@ void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
+	local_irq_save(efi_flags);
 	vaddress = (unsigned long)__va(0x0UL);
 	save_pgd = *pgd_offset_k(0x0UL);
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
@@ -98,9 +92,9 @@ void __init efi_call_phys_epilog(void)
 	 * After the lock is released, the original page table is restored.
 	 */
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
-	early_runtime_code_mapping_set_exec(0);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
+	early_runtime_code_mapping_set_exec(0);
 }
 
 void __init efi_reserve_bootmem(void)

