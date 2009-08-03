Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017AbZHCMja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbZHCMja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZHCMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:39:30 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:56383 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbZHCMj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:39:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19062.55858.533494.471153@cargo.ozlabs.ibm.com>
Date: Mon, 3 Aug 2009 22:38:10 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Make 64-bit efi_ioremap use ioremap on MMIO regions
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting current 64-bit x86 kernels on the latest Apple MacBook
(MacBook5,2) via EFI gives the following warning:

[    0.182209] ------------[ cut here ]------------
[    0.182222] WARNING: at arch/x86/mm/pageattr.c:581 __cpa_process_fault+0x44/0xa0()
[    0.182227] Hardware name: MacBook5,2
[    0.182231] CPA: called for zero pte. vaddr = ffff8800ffe00000 cpa->vaddr = ffff8800ffe00000
[    0.182236] Modules linked in:
[    0.182242] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #6
[    0.182246] Call Trace:
[    0.182254]  [<ffffffff8102c754>] ? __cpa_process_fault+0x44/0xa0
[    0.182261]  [<ffffffff81048668>] warn_slowpath_common+0x78/0xd0
[    0.182266]  [<ffffffff81048744>] warn_slowpath_fmt+0x64/0x70
[    0.182272]  [<ffffffff8102c7ec>] ? update_page_count+0x3c/0x50
[    0.182280]  [<ffffffff818d25c5>] ? phys_pmd_init+0x140/0x22e
[    0.182286]  [<ffffffff8102c754>] __cpa_process_fault+0x44/0xa0
[    0.182292]  [<ffffffff8102ce60>] __change_page_attr_set_clr+0x5f0/0xb40
[    0.182301]  [<ffffffff810d1035>] ? vm_unmap_aliases+0x175/0x190
[    0.182307]  [<ffffffff8102d4ae>] change_page_attr_set_clr+0xfe/0x3d0
[    0.182314]  [<ffffffff8102dcca>] _set_memory_uc+0x2a/0x30
[    0.182319]  [<ffffffff8102dd4b>] set_memory_uc+0x7b/0xb0
[    0.182327]  [<ffffffff818afe31>] efi_enter_virtual_mode+0x2ad/0x2c9
[    0.182334]  [<ffffffff818a1c66>] start_kernel+0x2db/0x3f4
[    0.182340]  [<ffffffff818a1289>] x86_64_start_reservations+0x99/0xb9
[    0.182345]  [<ffffffff818a1389>] x86_64_start_kernel+0xe0/0xf2
[    0.182357] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.182982] init_memory_mapping: 00000000ffffc000-0000000100000000
[    0.182993]  00ffffc000 - 0100000000 page 4k

This happens because the 64-bit version of efi_ioremap calls
init_memory_mapping for all addresses, regardless of whether they are
RAM or MMIO.  The EFI tables on this machine ask for runtime access to
some MMIO regions:

[    0.000000] EFI: mem195: type=11, attr=0x8000000000000000, range=[0x0000000093400000-0x0000000093401000) (0MB)
[    0.000000] EFI: mem196: type=11, attr=0x8000000000000000, range=[0x00000000ffc00000-0x00000000ffc40000) (0MB)
[    0.000000] EFI: mem197: type=11, attr=0x8000000000000000, range=[0x00000000ffc40000-0x00000000ffc80000) (0MB)
[    0.000000] EFI: mem198: type=11, attr=0x8000000000000000, range=[0x00000000ffc80000-0x00000000ffca4000) (0MB)
[    0.000000] EFI: mem199: type=11, attr=0x8000000000000000, range=[0x00000000ffca4000-0x00000000ffcb4000) (0MB)
[    0.000000] EFI: mem200: type=11, attr=0x8000000000000000, range=[0x00000000ffcb4000-0x00000000ffffc000) (3MB)
[    0.000000] EFI: mem201: type=11, attr=0x8000000000000000, range=[0x00000000ffffc000-0x0000000100000000) (0MB)

This arranges to pass the EFI memory type through to efi_ioremap, and
makes efi_ioremap use ioremap rather than init_memory_mapping if the
type is EFI_MEMORY_MAPPED_IO.  With this, the above warning goes away.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index edc90f2..8406ed7 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,7 +33,7 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
 	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
 
-#define efi_ioremap(addr, size)			ioremap_cache(addr, size)
+#define efi_ioremap(addr, size, type)		ioremap_cache(addr, size)
 
 #else /* !CONFIG_X86_32 */
 
@@ -84,7 +84,8 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
+				 u32 type);
 
 #endif /* CONFIG_X86_32 */
 
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 96f7ac0..19ccf6d 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -512,7 +512,7 @@ void __init efi_enter_virtual_mode(void)
 			&& end_pfn <= max_pfn_mapped))
 			va = __va(md->phys_addr);
 		else
-			va = efi_ioremap(md->phys_addr, size);
+			va = efi_ioremap(md->phys_addr, size, md->type);
 
 		md->virt_addr = (u64) (unsigned long) va;
 
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 22c3b78..ac0621a 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -98,10 +98,14 @@ void __init efi_call_phys_epilog(void)
 	early_runtime_code_mapping_set_exec(0);
 }
 
-void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
+				 u32 type)
 {
 	unsigned long last_map_pfn;
 
+	if (type == EFI_MEMORY_MAPPED_IO)
+		return ioremap(phys_addr, size);
+
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
 		return NULL;
