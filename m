Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbXJOLvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbXJOLvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760127AbXJOLuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:50:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:51299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbXJOLuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:50:44 -0400
Message-Id: <20071015115042.958614570@strauss.suse.de>
References: <20071015115042.391348549@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Mon, 15 Oct 2007 13:50:43 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de
Subject: [patch 1/2] Add BSS to resource tree
Content-Disposition: inline; filename=add-bss-resource
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the BSS to the resource tree just as kernel text and kernel
data are in the resource tree. The main reason behind this is to avoid
crashkernel reservation in that area.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/x86/kernel/e820_32.c  |    8 ++++++++
 arch/x86/kernel/e820_64.c  |    3 ++-
 arch/x86/kernel/efi_32.c   |    3 +++
 arch/x86/kernel/setup_32.c |    4 ++++
 arch/x86/kernel/setup_64.c |    9 +++++++++
 5 files changed, 26 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -51,6 +51,13 @@ struct resource code_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
+struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
 	.start	= 0xf0000,
@@ -287,6 +294,7 @@ legacy_init_iomem_resources(struct resou
 			 */
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, &bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -47,7 +47,7 @@ unsigned long end_pfn_map; 
  */
 static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
-extern struct resource code_resource, data_resource;
+extern struct resource code_resource, data_resource, bss_resource;
 
 /* Check for some hardcoded bad areas that early boot is not allowed to touch */ 
 static inline int bad_addr(unsigned long *addrp, unsigned long size)
@@ -220,6 +220,7 @@ void __init e820_reserve_resources(void)
 			 */
 			request_resource(res, &code_resource);
 			request_resource(res, &data_resource);
+			request_resource(res, &bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -49,6 +49,8 @@ EXPORT_SYMBOL(efi);
 static struct efi efi_phys;
 struct efi_memory_map memmap;
 
+extern struct resource iomem_resource;
+
 /*
  * We require an early boot_ioremap mapping mechanism initially
  */
@@ -672,6 +674,7 @@ efi_initialize_iomem_resources(struct re
 		if (md->type == EFI_CONVENTIONAL_MEMORY) {
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, &bss_resource);
 #ifdef CONFIG_KEXEC
 			request_resource(res, &crashk_res);
 #endif
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -60,6 +60,7 @@
 #include <asm/vmi.h>
 #include <setup_arch.h>
 #include <bios_ebda.h>
+#include <asm/cacheflush.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -73,6 +74,7 @@ int disable_pse __devinitdata = 0;
  */
 extern struct resource code_resource;
 extern struct resource data_resource;
+extern struct resource bss_resource;
 
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
@@ -595,6 +597,8 @@ void __init setup_arch(char **cmdline_p)
 	code_resource.end = virt_to_phys(_etext)-1;
 	data_resource.start = virt_to_phys(_etext);
 	data_resource.end = virt_to_phys(_edata)-1;
+	bss_resource.start = virt_to_phys(&__bss_start);
+	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
 	parse_early_param();
 
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -59,6 +59,7 @@
 #include <asm/numa.h>
 #include <asm/sections.h>
 #include <asm/dmi.h>
+#include <asm/cacheflush.h>
 
 /*
  * Machine setup..
@@ -134,6 +135,12 @@ struct resource code_resource = {
 	.end = 0,
 	.flags = IORESOURCE_RAM,
 };
+struct resource bss_resource = {
+	.name = "Kernel bss",
+	.start = 0,
+	.end = 0,
+	.flags = IORESOURCE_RAM,
+};
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
@@ -276,6 +283,8 @@ void __init setup_arch(char **cmdline_p)
 	code_resource.end = virt_to_phys(&_etext)-1;
 	data_resource.start = virt_to_phys(&_etext);
 	data_resource.end = virt_to_phys(&_edata)-1;
+	bss_resource.start = virt_to_phys(&__bss_start);
+	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
 	early_identify_cpu(&boot_cpu_data);
 

-- 
