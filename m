Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbYFPUC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbYFPUC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYFPUCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:02:46 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36791 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYFPUCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=kr0Ds+8L4iOj1VawERBvV7Js54GBRU6igrrhrChOFg2cJu9muL1vSjfX6NwsqYfZl4
         lIV/3ENX8t6o7J42xC4sGpoU6Sp3MZZ3MnyjSYxpn/tkU55z51NhI/CPnZWn8czLLEYg
         4bTpiPhowzcXbI6t2wO0S3beIZG84ohLL2YSo=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: move e820_resource_resources to e820.c
Date: Mon, 16 Jun 2008 13:03:31 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806161303.31997.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and make 32bit resource register more like 64 bit.

also move probe_roms back to setup_32.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -965,3 +965,35 @@ void __init finish_e820_parsing(void)
 		e820_print_map("user");
 	}
 }
+
+/*
+ * Mark e820 reserved areas as busy for the resource manager.
+ */
+void __init e820_reserve_resources(void)
+{
+	int i;
+	struct resource *res;
+
+	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	for (i = 0; i < e820.nr_map; i++) {
+		switch (e820.map[i].type) {
+		case E820_RAM:	res->name = "System RAM"; break;
+		case E820_ACPI:	res->name = "ACPI Tables"; break;
+		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
+		default:	res->name = "reserved";
+		}
+		res->start = e820.map[i].addr;
+		res->end = res->start + e820.map[i].size - 1;
+#ifndef CONFIG_RESOURCES_64BIT
+		if (res->end > 0x100000000ULL) {
+			res++;
+			continue;
+		}
+#endif
+		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
+		insert_resource(&iomem_resource, res);
+		res++;
+	}
+}
+
+
Index: linux-2.6/arch/x86/kernel/e820_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_32.c
+++ linux-2.6/arch/x86/kernel/e820_32.c
@@ -15,198 +15,6 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
-static struct resource system_rom_resource = {
-	.name	= "System ROM",
-	.start	= 0xf0000,
-	.end	= 0xfffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-static struct resource extension_rom_resource = {
-	.name	= "Extension ROM",
-	.start	= 0xe0000,
-	.end	= 0xeffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-static struct resource adapter_rom_resources[] = { {
-	.name 	= "Adapter ROM",
-	.start	= 0xc8000,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-} };
-
-static struct resource video_rom_resource = {
-	.name 	= "Video ROM",
-	.start	= 0xc0000,
-	.end	= 0xc7fff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-#define ROMSIGNATURE 0xaa55
-
-static int __init romsignature(const unsigned char *rom)
-{
-	const unsigned short * const ptr = (const unsigned short *)rom;
-	unsigned short sig;
-
-	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
-}
-
-static int __init romchecksum(const unsigned char *rom, unsigned long length)
-{
-	unsigned char sum, c;
-
-	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
-		sum += c;
-	return !length && !sum;
-}
-
-static void __init probe_roms(void)
-{
-	const unsigned char *rom;
-	unsigned long start, length, upper;
-	unsigned char c;
-	int i;
-
-	/* video rom */
-	upper = adapter_rom_resources[0].start;
-	for (start = video_rom_resource.start; start < upper; start += 2048) {
-		rom = isa_bus_to_virt(start);
-		if (!romsignature(rom))
-			continue;
-
-		video_rom_resource.start = start;
-
-		if (probe_kernel_address(rom + 2, c) != 0)
-			continue;
-
-		/* 0 < length <= 0x7f * 512, historically */
-		length = c * 512;
-
-		/* if checksum okay, trust length byte */
-		if (length && romchecksum(rom, length))
-			video_rom_resource.end = start + length - 1;
-
-		request_resource(&iomem_resource, &video_rom_resource);
-		break;
-	}
-
-	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
-	if (start < upper)
-		start = upper;
-
-	/* system rom */
-	request_resource(&iomem_resource, &system_rom_resource);
-	upper = system_rom_resource.start;
-
-	/* check for extension rom (ignore length byte!) */
-	rom = isa_bus_to_virt(extension_rom_resource.start);
-	if (romsignature(rom)) {
-		length = extension_rom_resource.end - extension_rom_resource.start + 1;
-		if (romchecksum(rom, length)) {
-			request_resource(&iomem_resource, &extension_rom_resource);
-			upper = extension_rom_resource.start;
-		}
-	}
-
-	/* check for adapter roms on 2k boundaries */
-	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
-		rom = isa_bus_to_virt(start);
-		if (!romsignature(rom))
-			continue;
-
-		if (probe_kernel_address(rom + 2, c) != 0)
-			continue;
-
-		/* 0 < length <= 0x7f * 512, historically */
-		length = c * 512;
-
-		/* but accept any length that fits if checksum okay */
-		if (!length || start + length > upper || !romchecksum(rom, length))
-			continue;
-
-		adapter_rom_resources[i].start = start;
-		adapter_rom_resources[i].end = start + length - 1;
-		request_resource(&iomem_resource, &adapter_rom_resources[i]);
-
-		start = adapter_rom_resources[i++].end & ~2047UL;
-	}
-}
-
-/*
- * Request address space for all standard RAM and ROM resources
- * and also for regions reported as reserved by the e820.
- */
-void __init init_iomem_resources(struct resource *code_resource,
-		struct resource *data_resource,
-		struct resource *bss_resource)
-{
-	int i;
-
-	probe_roms();
-	for (i = 0; i < e820.nr_map; i++) {
-		struct resource *res;
-#ifndef CONFIG_RESOURCES_64BIT
-		if (e820.map[i].addr + e820.map[i].size > 0x100000000ULL)
-			continue;
-#endif
-		res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
-		switch (e820.map[i].type) {
-		case E820_RAM:	res->name = "System RAM"; break;
-		case E820_ACPI:	res->name = "ACPI Tables"; break;
-		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
-		default:	res->name = "reserved";
-		}
-		res->start = e820.map[i].addr;
-		res->end = res->start + e820.map[i].size - 1;
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		if (request_resource(&iomem_resource, res)) {
-			kfree(res);
-			continue;
-		}
-		if (e820.map[i].type == E820_RAM) {
-			/*
-			 *  We don't know which RAM region contains kernel data,
-			 *  so we try it repeatedly and let the resource manager
-			 *  test it.
-			 */
-			request_resource(res, code_resource);
-			request_resource(res, data_resource);
-			request_resource(res, bss_resource);
-#ifdef CONFIG_KEXEC
-			if (crashk_res.start != crashk_res.end)
-				request_resource(res, &crashk_res);
-#endif
-		}
-	}
-}
-
 /* Overridden in paravirt.c if CONFIG_PARAVIRT */
 char * __init __attribute__((weak)) memory_setup(void)
 {
Index: linux-2.6/arch/x86/kernel/e820_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820_64.c
+++ linux-2.6/arch/x86/kernel/e820_64.c
@@ -41,30 +41,6 @@ unsigned long end_pfn;
  */
 unsigned long max_pfn_mapped;
 
-/*
- * Mark e820 reserved areas as busy for the resource manager.
- */
-void __init e820_reserve_resources(void)
-{
-	int i;
-	struct resource *res;
-
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
-	for (i = 0; i < e820.nr_map; i++) {
-		switch (e820.map[i].type) {
-		case E820_RAM:	res->name = "System RAM"; break;
-		case E820_ACPI:	res->name = "ACPI Tables"; break;
-		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
-		default:	res->name = "reserved";
-		}
-		res->start = e820.map[i].addr;
-		res->end = res->start + e820.map[i].size - 1;
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
-		res++;
-	}
-}
-
 static void early_panic(char *msg)
 {
 	early_printk(msg);
Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -446,25 +446,28 @@ static void __init reserve_crashkernel(v
 	ret = parse_crashkernel(boot_command_line, total_mem,
 			&crash_size, &crash_base);
 	if (ret == 0 && crash_size > 0) {
-		if (crash_base > 0) {
-			printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
-					"for crashkernel (System RAM: %ldMB)\n",
-					(unsigned long)(crash_size >> 20),
-					(unsigned long)(crash_base >> 20),
-					(unsigned long)(total_mem >> 20));
+		if (crash_base <= 0) {
+			printk(KERN_INFO "crashkernel reservation failed - "
+					"you have to specify a base address\n");
+			return;
+		}
 
-			if (reserve_bootmem(crash_base, crash_size,
+		if (reserve_bootmem_generic(crash_base, crash_size,
 					BOOTMEM_EXCLUSIVE) < 0) {
-				printk(KERN_INFO "crashkernel reservation "
-					"failed - memory is in use\n");
-				return;
-			}
-
-			crashk_res.start = crash_base;
-			crashk_res.end   = crash_base + crash_size - 1;
-		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
-					"you have to specify a base address\n");
+					"memory is in use\n");
+			return;
+		}
+
+		printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
+				"for crashkernel (System RAM: %ldMB)\n",
+				(unsigned long)(crash_size >> 20),
+				(unsigned long)(crash_base >> 20),
+				(unsigned long)(total_mem >> 20));
+
+		crashk_res.start = crash_base;
+		crashk_res.end   = crash_base + crash_size - 1;
+		insert_resource(&iomem_resource, &crashk_res);
 	}
 }
 #else
@@ -682,6 +685,8 @@ char * __init __attribute__((weak)) memo
 	return machine_specific_memory_setup();
 }
 
+static void probe_roms(void);
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -691,6 +696,7 @@ char * __init __attribute__((weak)) memo
  */
 void __init setup_arch(char **cmdline_p)
 {
+	int i;
 	unsigned long max_low_pfn;
 
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
@@ -757,6 +763,13 @@ void __init setup_arch(char **cmdline_p)
 
 	finish_e820_parsing();
 
+	probe_roms();
+
+	/* after parse_early_param, so could debug it */
+	insert_resource(&iomem_resource, &code_resource);
+	insert_resource(&iomem_resource, &data_resource);
+	insert_resource(&iomem_resource, &bss_resource);
+
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
@@ -861,9 +874,16 @@ void __init setup_arch(char **cmdline_p)
 			"CONFIG_X86_GENERICARCH or CONFIG_X86_BIGSMP.\n");
 #endif
 
-	e820_setup_gap();
+	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
 
+	request_resource(&iomem_resource, &video_ram_resource);
+	/* request I/O space for devices used on all i[345]86 PCs */
+	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
+		request_resource(&ioport_resource, &standard_io_resources[i]);
+
+	e820_setup_gap();
+
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
 	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
@@ -874,25 +894,147 @@ void __init setup_arch(char **cmdline_p)
 #endif
 }
 
-/*
- * Request address space for all standard resources
- *
- * This is called just before pcibios_init(), which is also a
- * subsys_initcall, but is linked in later (in arch/i386/pci/common.c).
- */
-static int __init request_standard_resources(void)
+static struct resource system_rom_resource = {
+	.name	= "System ROM",
+	.start	= 0xf0000,
+	.end	= 0xfffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+static struct resource extension_rom_resource = {
+	.name	= "Extension ROM",
+	.start	= 0xe0000,
+	.end	= 0xeffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+static struct resource adapter_rom_resources[] = { {
+	.name 	= "Adapter ROM",
+	.start	= 0xc8000,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+} };
+
+static struct resource video_rom_resource = {
+	.name 	= "Video ROM",
+	.start	= 0xc0000,
+	.end	= 0xc7fff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+#define ROMSIGNATURE 0xaa55
+
+static int __init romsignature(const unsigned char *rom)
 {
+	const unsigned short * const ptr = (const unsigned short *)rom;
+	unsigned short sig;
+
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
+}
+
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
+{
+	unsigned char sum, c;
+
+	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
+		sum += c;
+	return !length && !sum;
+}
+
+static void __init probe_roms(void)
+{
+	const unsigned char *rom;
+	unsigned long start, length, upper;
+	unsigned char c;
 	int i;
 
-	printk(KERN_INFO "Setting up standard PCI resources\n");
-	init_iomem_resources(&code_resource, &data_resource, &bss_resource);
+	/* video rom */
+	upper = adapter_rom_resources[0].start;
+	for (start = video_rom_resource.start; start < upper; start += 2048) {
+		rom = isa_bus_to_virt(start);
+		if (!romsignature(rom))
+			continue;
+
+		video_rom_resource.start = start;
+
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
+		/* 0 < length <= 0x7f * 512, historically */
+		length = c * 512;
+
+		/* if checksum okay, trust length byte */
+		if (length && romchecksum(rom, length))
+			video_rom_resource.end = start + length - 1;
 
-	request_resource(&iomem_resource, &video_ram_resource);
+		request_resource(&iomem_resource, &video_rom_resource);
+		break;
+	}
 
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
-	return 0;
+	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
+	if (start < upper)
+		start = upper;
+
+	/* system rom */
+	request_resource(&iomem_resource, &system_rom_resource);
+	upper = system_rom_resource.start;
+
+	/* check for extension rom (ignore length byte!) */
+	rom = isa_bus_to_virt(extension_rom_resource.start);
+	if (romsignature(rom)) {
+		length = extension_rom_resource.end - extension_rom_resource.start + 1;
+		if (romchecksum(rom, length)) {
+			request_resource(&iomem_resource, &extension_rom_resource);
+			upper = extension_rom_resource.start;
+		}
+	}
+
+	/* check for adapter roms on 2k boundaries */
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
+		rom = isa_bus_to_virt(start);
+		if (!romsignature(rom))
+			continue;
+
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
+		/* 0 < length <= 0x7f * 512, historically */
+		length = c * 512;
+
+		/* but accept any length that fits if checksum okay */
+		if (!length || start + length > upper || !romchecksum(rom, length))
+			continue;
+
+		adapter_rom_resources[i].start = start;
+		adapter_rom_resources[i].end = start + length - 1;
+		request_resource(&iomem_resource, &adapter_rom_resources[i]);
+
+		start = adapter_rom_resources[i++].end & ~2047UL;
+	}
 }
 
-subsys_initcall(request_standard_resources);
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -98,6 +98,7 @@ extern void e820_register_active_regions
 					 unsigned long end_pfn);
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
+extern void e820_reserve_resources(void);
 
 #endif /* __ASSEMBLY__ */
 
Index: linux-2.6/include/asm-x86/e820_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_32.h
+++ linux-2.6/include/asm-x86/e820_32.h
@@ -20,9 +20,5 @@
 
 extern void setup_memory_map(void);
 
-extern void init_iomem_resources(struct resource *code_resource,
-				 struct resource *data_resource,
-				 struct resource *bss_resource);
-
 #endif/*!__ASSEMBLY__*/
 #endif/*__E820_HEADER*/
Index: linux-2.6/include/asm-x86/e820_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820_64.h
+++ linux-2.6/include/asm-x86/e820_64.h
@@ -16,7 +16,6 @@
 #ifndef __ASSEMBLY__
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void);
-extern void e820_reserve_resources(void);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
