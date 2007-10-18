Return-Path: <linux-kernel-owner+w=401wt.eu-S1764042AbXJRLRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764042AbXJRLRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 07:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763485AbXJRLPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 07:15:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:60729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763324AbXJRLPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:15:42 -0400
Message-Id: <20071018111535.883533731@strauss.suse.de>
References: <20071018111535.356215664@strauss.suse.de>
User-Agent: quilt/0.46-60
Date: Thu, 18 Oct 2007 13:15:36 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, ak@suse.de, vgoyal@in.ibm.com
Subject: [patch 1/3] Add BSS to resource tree
Content-Disposition: inline; filename=add-bss-resource
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the BSS to the resource tree just as kernel text and kernel
data are in the resource tree. The main reason behind this is to avoid
crashkernel reservation in that area.

While it's not strictly necessary to have the BSS in the resource tree
(the actual collision detection is done in the reserve_bootmem() function
before), the usage of the BSS resource should be presented to the user
in /proc/iomem just as Kernel data and Kernel code.

Note: The patch currently is only implemented for x86 and ia64 (because
efi_initialize_iomem_resources() has the same signature on i386 and
ia64).


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 arch/ia64/kernel/efi.c     |    4 +++-
 arch/ia64/kernel/setup.c   |   14 +++++++++++---
 arch/x86/kernel/e820_32.c  |   18 +++++++++++++++---
 arch/x86/kernel/e820_64.c  |    3 ++-
 arch/x86/kernel/efi_32.c   |    4 +++-
 arch/x86/kernel/setup_32.c |    4 ++++
 arch/x86/kernel/setup_64.c |    9 +++++++++
 include/linux/efi.h        |    2 +-
 8 files changed, 48 insertions(+), 10 deletions(-)

--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -1090,7 +1090,8 @@ efi_memmap_init(unsigned long *s, unsign
 
 void
 efi_initialize_iomem_resources(struct resource *code_resource,
-			       struct resource *data_resource)
+			       struct resource *data_resource,
+			       struct resource *bss_resource)
 {
 	struct resource *res;
 	void *efi_map_start, *efi_map_end, *p;
@@ -1171,6 +1172,7 @@ efi_initialize_iomem_resources(struct re
 			 */
 			insert_resource(res, code_resource);
 			insert_resource(res, data_resource);
+			insert_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
                         insert_resource(res, &efi_memmap_res);
                         insert_resource(res, &boot_param_res);
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -90,7 +90,12 @@ static struct resource code_resource = {
 	.name	= "Kernel code",
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
-extern char _text[], _end[], _etext[];
+
+static struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+extern char _text[], _end[], _etext[], _edata[], _bss[];
 
 unsigned long ia64_max_cacheline_size;
 
@@ -200,8 +205,11 @@ static int __init register_memory(void)
 	code_resource.start = ia64_tpa(_text);
 	code_resource.end   = ia64_tpa(_etext) - 1;
 	data_resource.start = ia64_tpa(_etext);
-	data_resource.end   = ia64_tpa(_end) - 1;
-	efi_initialize_iomem_resources(&code_resource, &data_resource);
+	data_resource.end   = ia64_tpa(_edata) - 1;
+	bss_resource.start  = ia64_tpa(_bss);
+	bss_resource.end    = ia64_tpa(_end) - 1;
+	efi_initialize_iomem_resources(&code_resource, &data_resource,
+			&bss_resource);
 
 	return 0;
 }
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
@@ -254,7 +261,9 @@ static void __init probe_roms(void)
  * and also for regions reported as reserved by the e820.
  */
 static void __init
-legacy_init_iomem_resources(struct resource *code_resource, struct resource *data_resource)
+legacy_init_iomem_resources(struct resource *code_resource,
+			    struct resource *data_resource,
+			    struct resource *bss_resource)
 {
 	int i;
 
@@ -287,6 +296,7 @@ legacy_init_iomem_resources(struct resou
 			 */
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
@@ -307,9 +317,11 @@ static int __init request_standard_resou
 
 	printk("Setting up standard PCI resources\n");
 	if (efi_enabled)
-		efi_initialize_iomem_resources(&code_resource, &data_resource);
+		efi_initialize_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
 	else
-		legacy_init_iomem_resources(&code_resource, &data_resource);
+		legacy_init_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
 
 	/* EFI systems may still have VGA */
 	request_resource(&iomem_resource, &video_ram_resource);
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
@@ -600,7 +600,8 @@ void __init efi_enter_virtual_mode(void)
 
 void __init
 efi_initialize_iomem_resources(struct resource *code_resource,
-			       struct resource *data_resource)
+                               struct resource *data_resource,
+			       struct resource *bss_resource)
 {
 	struct resource *res;
 	efi_memory_desc_t *md;
@@ -672,6 +673,7 @@ efi_initialize_iomem_resources(struct re
 		if (md->type == EFI_CONVENTIONAL_MEMORY) {
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, bss_resource);
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
 
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -298,7 +298,7 @@ extern int efi_mem_attribute_range (unsi
 				    u64 attr);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
-					struct resource *data_resource);
+		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern int is_available_memory(efi_memory_desc_t * md);

-- 
