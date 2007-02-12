Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXBLHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXBLHmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933091AbXBLHmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105AbXBLHiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:25 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [35/39] x86_64: Don't reserve ROMs 
Message-Id: <20070212073823.999D513DA0@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


We trust the e820 table, so explicitely reserving ROMs shouldn't 
be needed.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/setup.c |  130 ---------------------------------------------
 1 file changed, 2 insertions(+), 128 deletions(-)

Index: linux/arch/x86_64/kernel/setup.c
===================================================================
--- linux.orig/arch/x86_64/kernel/setup.c
+++ linux/arch/x86_64/kernel/setup.c
@@ -138,128 +138,6 @@ struct resource code_resource = {
 	.flags = IORESOURCE_RAM,
 };
 
-#define IORESOURCE_ROM (IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM)
-
-static struct resource system_rom_resource = {
-	.name = "System ROM",
-	.start = 0xf0000,
-	.end = 0xfffff,
-	.flags = IORESOURCE_ROM,
-};
-
-static struct resource extension_rom_resource = {
-	.name = "Extension ROM",
-	.start = 0xe0000,
-	.end = 0xeffff,
-	.flags = IORESOURCE_ROM,
-};
-
-static struct resource adapter_rom_resources[] = {
-	{ .name = "Adapter ROM", .start = 0xc8000, .end = 0,
-		.flags = IORESOURCE_ROM },
-	{ .name = "Adapter ROM", .start = 0, .end = 0,
-		.flags = IORESOURCE_ROM },
-	{ .name = "Adapter ROM", .start = 0, .end = 0,
-		.flags = IORESOURCE_ROM },
-	{ .name = "Adapter ROM", .start = 0, .end = 0,
-		.flags = IORESOURCE_ROM },
-	{ .name = "Adapter ROM", .start = 0, .end = 0,
-		.flags = IORESOURCE_ROM },
-	{ .name = "Adapter ROM", .start = 0, .end = 0,
-		.flags = IORESOURCE_ROM }
-};
-
-static struct resource video_rom_resource = {
-	.name = "Video ROM",
-	.start = 0xc0000,
-	.end = 0xc7fff,
-	.flags = IORESOURCE_ROM,
-};
-
-static struct resource video_ram_resource = {
-	.name = "Video RAM area",
-	.start = 0xa0000,
-	.end = 0xbffff,
-	.flags = IORESOURCE_RAM,
-};
-
-#define romsignature(x) (*(unsigned short *)(x) == 0xaa55)
-
-static int __init romchecksum(unsigned char *rom, unsigned long length)
-{
-	unsigned char *p, sum = 0;
-
-	for (p = rom; p < rom + length; p++)
-		sum += *p;
-	return sum == 0;
-}
-
-static void __init probe_roms(void)
-{
-	unsigned long start, length, upper;
-	unsigned char *rom;
-	int	      i;
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
-		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
-
-		/* if checksum okay, trust length byte */
-		if (length && romchecksum(rom, length))
-			video_rom_resource.end = start + length - 1;
-
-		request_resource(&iomem_resource, &video_rom_resource);
-		break;
-			}
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
-	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper;
-	     start += 2048) {
-		rom = isa_bus_to_virt(start);
-		if (!romsignature(rom))
-			continue;
-
-		/* 0 < length <= 0x7f * 512, historically */
-		length = rom[2] * 512;
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
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
  * stored by the crashed kernel. This option will be passed
@@ -524,15 +402,11 @@ void __init setup_arch(char **cmdline_p)
 	init_apic_mappings();
 
 	/*
-	 * Request address space for all standard RAM and ROM resources
-	 * and also for regions reported as reserved by the e820.
-	 */
-	probe_roms();
+	 * We trust e820 completely. No explicit ROM probing in memory.
+ 	 */
 	e820_reserve_resources(); 
 	e820_mark_nosave_regions();
 
-	request_resource(&iomem_resource, &video_ram_resource);
-
 	{
 	unsigned i;
 	/* request I/O space for devices used on all i[345]86 PCs */
