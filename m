Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYAYFyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYAYFyg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 00:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYAYFy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 00:54:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:31885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbYAYFy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 00:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,248,1199692800"; 
   d="scan'208";a="293040684"
Subject: [PATCH 6/6] x86: fixes some bugs about EFI memory map handling
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jan 2008 13:55:07 +0800
Message-Id: <1201240507.15972.48.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 25 Jan 2008 05:54:23.0824 (UTC) FILETIME=[BC9ACD00:01C85F16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some bugs of EFI memory handing code.

- On x86_64, it is possible that EFI memory map can not be mapped via
  identity map, so efi_map_memmap is removed, just use early_ioremap.

- On i386, the EFI memory map mapping take effect cross paging_init,
  so it is not necessary to use efi_map_memmap.

- EFI memory map is unmapped in efi_enter_virtual_mode to avoid
  early_ioremap leak.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c      |    2 ++
 arch/x86/kernel/efi_32.c   |   15 ---------------
 arch/x86/kernel/efi_64.c   |    9 ---------
 arch/x86/kernel/setup_32.c |    2 --
 arch/x86/kernel/setup_64.c |    4 +---
 5 files changed, 3 insertions(+), 29 deletions(-)

--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -103,15 +103,6 @@ void __init efi_call_phys_epilog(void)
 	local_irq_restore(efi_flags);
 }
 
-/*
- * We need to map the EFI memory map again after init_memory_mapping().
- */
-void __init efi_map_memmap(void)
-{
-	memmap.map = __va(memmap.phys_map);
-	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
-}
-
 void __init efi_reserve_bootmem(void)
 {
 	reserve_bootmem_generic((unsigned long)memmap.phys_map,
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -389,10 +389,8 @@ void __init setup_arch(char **cmdline_p)
        acpi_reserve_bootmem();
 #endif
 
-	if (efi_enabled) {
-		efi_map_memmap();
+	if (efi_enabled)
 		efi_reserve_bootmem();
-	}
 
        /*
 	* Find and reserve possible boot-time SMP configuration:
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -474,6 +474,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
 	runtime_code_page_mkexec();
+	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
+	memmap.map = NULL;
 }
 
 /*
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -109,18 +109,3 @@ void efi_call_phys_epilog(void)
 
 	local_irq_restore(efi_rt_eflags);
 }
-
-/*
- * We need to map the EFI memory map again after paging_init().
- */
-void __init efi_map_memmap(void)
-{
-	memmap.map = NULL;
-
-	memmap.map = early_ioremap((unsigned long) memmap.phys_map,
-			(memmap.nr_map * memmap.desc_size));
-	if (memmap.map == NULL)
-		printk(KERN_ERR "Could not remap the EFI memmap!\n");
-
-	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
-}
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -825,8 +825,6 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
 #endif
-	if (efi_enabled)
-		efi_map_memmap();
 
 #ifdef CONFIG_ACPI
 	/*

