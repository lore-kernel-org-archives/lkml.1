Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbXK1IIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbXK1IIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 03:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXK1IIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 03:08:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:8116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXK1IIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 03:08:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,223,1194249600"; 
   d="scan'208";a="327688979"
Subject: [PATCH -mm] x86_64 EFI runtime service support: EFI basic runtime
	service support fixes
From: "Huang, Ying" <ying.huang@intel.com>
To: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Nov 2007 16:08:34 +0800
Message-Id: <1196237314.18833.20.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 28 Nov 2007 08:04:19.0191 (UTC) FILETIME=[470BE870:01C83195]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes several issues of x86_64 EFI basic runtime service
support patch per comments from Andrew Moton.

- Delete efi_lock because it is used during system early boot, before
  smp is initialized. The global_flush_tlb() is changed to
  __flush_tlb_all for some reason.

- Revise some messages.

- Turn on debug by default.

- Remove unnecessary memset of static variable.


This patch has been tested against 2.6.24-rc3-mm1 kernel on Intel
platforms with 64-bit EFI1.10 and UEFI2.0 firmware.


Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c    |   24 ++++++++++--------------
 arch/x86/kernel/efi_64.c |   18 +++++-------------
 2 files changed, 15 insertions(+), 27 deletions(-)

--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -39,8 +39,6 @@
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
-/* efi_lock protects efi physical mode call */
-static __initdata DEFINE_SPINLOCK(efi_lock);
 
 static int __init setup_noefi(char *arg)
 {
@@ -86,33 +84,27 @@ static void __init early_runtime_code_ma
 	}
 }
 
-void __init efi_call_phys_prelog(void) __acquires(efi_lock)
+void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	/*
-	 * Lock sequence is different from normal case because
-	 * efi_flags is global
-	 */
-	spin_lock(&efi_lock);
 	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
 	vaddress = (unsigned long)__va(0x0UL);
 	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
-	global_flush_tlb();
+	__flush_tlb_all();
 }
 
-void __init efi_call_phys_epilog(void) __releases(efi_lock)
+void __init efi_call_phys_epilog(void)
 {
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
 	early_runtime_code_mapping_set_exec(0);
-	global_flush_tlb();
+	__flush_tlb_all();
 	local_irq_restore(efi_flags);
-	spin_unlock(&efi_lock);
 }
 
 /*
@@ -143,7 +135,7 @@ void __init runtime_code_page_mkexec(voi
 					      md->num_pages,
 					      PAGE_KERNEL_EXEC);
 	}
-	global_flush_tlb();
+	__flush_tlb_all();
 }
 
 void __iomem * __init efi_ioremap(unsigned long offset,
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -41,7 +41,8 @@
 #include <asm/efi.h>
 #include <asm/time.h>
 
-#define EFI_DEBUG	0
+#define EFI_DEBUG	1
+#define PFX 		"EFI: "
 
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
@@ -214,7 +215,7 @@ static void __init print_efi_memmap(void
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		printk(KERN_INFO "mem%02u: type=%u, attr=0x%llx, "
+		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
@@ -232,9 +233,6 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
-	memset(&efi, 0, sizeof(efi));
-	memset(&efi_phys, 0, sizeof(efi_phys));
-
 #ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
 	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
@@ -254,7 +252,7 @@ void __init efi_init(void)
 	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
 				       sizeof(efi_system_table_t));
 	if (efi.systab == NULL)
-		printk(KERN_ERR "Woah! Couldn't map the EFI systema table.\n");
+		printk(KERN_ERR "Couldn't map the EFI system table!\n");
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
 	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
@@ -263,11 +261,10 @@ void __init efi_init(void)
 	 * Verify the EFI Table
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "Woah! EFI system table "
-		       "signature incorrect\n");
+		printk(KERN_ERR "EFI system table signature incorrect!\n");
 	if ((efi.systab->hdr.revision >> 16) == 0)
 		printk(KERN_ERR "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater\n",
+		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
@@ -280,7 +277,7 @@ void __init efi_init(void)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
-		printk(KERN_ERR "Could not map the firmware vendor!\n");
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
 	efi_early_iounmap(tmp, 2);
 
 	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
@@ -404,7 +401,7 @@ void __init efi_enter_virtual_mode(void)
 				efi_ioremap(md->phys_addr,
 					    md->num_pages << EFI_PAGE_SHIFT);
 		if (!md->virt_addr)
-			printk(KERN_ERR "ioremap of 0x%llX failed!\n",
+			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
 		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
@@ -423,9 +420,8 @@ void __init efi_enter_virtual_mode(void)
 		memmap.phys_map);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ALERT "You are screwed! "
-		       "Unable to switch EFI into virtual mode "
-		       "(status=%lx)\n", status);
+		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
+		       "(status=%lx)!\n", status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
