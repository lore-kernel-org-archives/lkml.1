Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYFBGZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYFBGZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 02:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYFBGYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 02:24:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:22599 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYFBGYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 02:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="334832519"
Subject: [PATCH 3/5] x86_64 boot: reserve EFI memory map with reserve_early
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Jun 2008 14:26:21 +0800
Message-Id: <1212387981.301.28.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 02 Jun 2008 06:24:33.0517 (UTC) FILETIME=[528DC9D0:01C8C479]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reserves the EFI memory map with reserve_early(). Because EFI
memory map is allocated by bootloader, if it is not reserved by
reserved_early(), it may be overwritten through address returned by
find_e820_area().

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/efi.c      |   33 ++++++++++++++++++++-------------
 arch/x86/kernel/efi_64.c   |    6 ------
 arch/x86/kernel/setup_32.c |    5 ++++-
 arch/x86/kernel/setup_64.c |    7 +++----
 include/asm-x86/efi.h      |    2 +-
 5 files changed, 28 insertions(+), 25 deletions(-)

--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -316,8 +316,10 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4))
+		     "EL64", 4)) {
 		efi_enabled = 1;
+		efi_reserve_early();
+	}
 #endif
 
 	ARCH_SETUP
@@ -431,9 +433,6 @@ void __init setup_arch(char **cmdline_p)
        acpi_reserve_bootmem();
 #endif
 
-	if (efi_enabled)
-		efi_reserve_bootmem();
-
 #ifdef CONFIG_X86_MPPARSE
        /*
 	* Find and reserve possible boot-time SMP configuration:
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -97,12 +97,6 @@ void __init efi_call_phys_epilog(void)
 	early_runtime_code_mapping_set_exec(0);
 }
 
-void __init efi_reserve_bootmem(void)
-{
-	reserve_bootmem_generic((unsigned long)memmap.phys_map,
-				memmap.nr_map * memmap.desc_size);
-}
-
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size)
 {
 	static unsigned pages_mapped __initdata;
--- a/include/asm-x86/efi.h
+++ b/include/asm-x86/efi.h
@@ -90,7 +90,7 @@ extern void *efi_ioremap(unsigned long a
 
 #endif /* CONFIG_X86_32 */
 
-extern void efi_reserve_bootmem(void);
+extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -238,6 +238,23 @@ static void __init add_efi_memmap(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+void __init efi_reserve_early(void)
+{
+	unsigned long pmap;
+
+	pmap = boot_params.efi_info.efi_memmap;
+#ifdef CONFIG_X86_64
+	pmap += (__u64)boot_params.efi_info.efi_memmap_hi << 32;
+#endif
+	memmap.phys_map = (void *)pmap;
+	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
+		boot_params.efi_info.efi_memdesc_size;
+	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
+	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
+	reserve_early(pmap, pmap + memmap.nr_map * memmap.desc_size,
+		      "EFI memmap");
+}
+
 #if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
@@ -267,21 +284,11 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
-#ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
-	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
-#else
-	efi_phys.systab = (efi_system_table_t *)
-		(boot_params.efi_info.efi_systab |
-		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
-	memmap.phys_map = (void *)
-		(boot_params.efi_info.efi_memmap |
-		 ((__u64)boot_params.efi_info.efi_memmap_hi<<32));
+#ifdef CONFIG_X86_64
+	efi_phys.systab = (void *)efi_phys.systab +
+		((__u64)boot_params.efi_info.efi_systab_hi<<32);
 #endif
-	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
-		boot_params.efi_info.efi_memdesc_size;
-	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
-	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
 
 	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
 				   sizeof(efi_system_table_t));
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -67,6 +67,7 @@
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
+#include <asm/efi.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -682,8 +683,10 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4))
+		     "EL32", 4)) {
 		efi_enabled = 1;
+		efi_reserve_early();
+	}
 #endif
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);

