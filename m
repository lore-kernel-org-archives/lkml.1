Return-Path: <linux-kernel-owner+w=401wt.eu-S1766879AbXEBUDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766879AbXEBUDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766884AbXEBUDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:03:00 -0400
Received: from mga05.intel.com ([192.55.52.89]:51458 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766879AbXEBUC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:02:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,482,1170662400"; 
   d="scan'208";a="240876166"
Message-Id: <20070501190110.958988000@em64tdvp.jf.intel.com>
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
Date: Tue, 01 May 2007 11:59:47 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 2/3] x86_64: EFI64 support 
Content-Disposition: inline; filename=patch2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EFI x86_64 support Patch 2 of 3
-------------------------------
The patch depends on EFI x86_64 patch 1/3.

EFI initialization and memory map set up are done. It should be noted
that support for user-defined memory is not yet implemented. Time
and reboot services go through the EFI service call for x86_64.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/e820.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/e820.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/e820.c	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/e820.c	2007-04-19 13:01:02.000000000 -0700
@@ -17,6 +17,7 @@
 #include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/efi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -97,11 +98,40 @@ static inline int bad_addr(unsigned long
 /*
  * This function checks if any part of the range <start,end> is mapped
  * with type.
+ * FIXME: here only handle E820_RAM and 0 memory type condition
  */
 int __meminit
 e820_any_mapped(unsigned long start, unsigned long end, unsigned type)
 { 
 	int i;
+	if (efi_enabled) {
+		efi_memory_desc_t *md;
+		void *p;
+		unsigned long map_start, map_end;
+
+		for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+			md = p;
+			map_start = md->phys_addr;
+			map_end = map_start + (md->num_pages << EFI_PAGE_SHIFT);
+			if (type == E820_RAM) {
+				switch (md->type) {
+				case EFI_CONVENTIONAL_MEMORY:
+				case EFI_BOOT_SERVICES_DATA:
+				case EFI_BOOT_SERVICES_CODE:
+				case EFI_LOADER_DATA:
+				case EFI_LOADER_CODE:
+					if (map_start >= end || map_end <= start)
+						continue;
+					return 1;
+					break;
+				default:
+					continue;
+				}
+			}
+		}
+		return 0;
+	}
+
 	for (i = 0; i < e820.nr_map; i++) { 
 		struct e820entry *ei = &e820.map[i]; 
 		if (type && ei->type != type) 
@@ -148,6 +178,29 @@ int __init e820_all_mapped(unsigned long
 unsigned long __init find_e820_area(unsigned long start, unsigned long end, unsigned size) 
 { 
 	int i; 
+	if (efi_enabled) {
+		efi_memory_desc_t *md;
+		void *p;
+		unsigned long map_start, map_end, last;
+		for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+			md = p;
+			if (md->type != EFI_CONVENTIONAL_MEMORY)
+				continue;
+			map_start = md->phys_addr;
+			map_end = map_start + (md->num_pages << EFI_PAGE_SHIFT);
+			if (map_start < start)
+				map_start = start;
+			if (map_start > map_end)
+				continue;
+			while (bad_addr(&map_start, size) && map_start+size <= map_end)
+				;
+			last = PAGE_ALIGN(map_start) + size;
+			if (last > map_end || last > end)
+				continue;
+			return map_start;
+		}
+		return -1UL;		
+	}
 	for (i = 0; i < e820.nr_map; i++) { 
 		struct e820entry *ei = &e820.map[i]; 
 		unsigned long addr = ei->addr, last; 
@@ -186,7 +239,7 @@ unsigned long __init e820_end_of_ram(voi
 	if (end_pfn > end_pfn_map) 
 		end_pfn = end_pfn_map; 
 
-	printk("end_pfn_map = %lu\n", end_pfn_map);
+	printk("e820_end_of_ram: end_pfn_map = %lu\n", end_pfn_map);
 	return end_pfn;	
 }
 
@@ -309,6 +362,28 @@ e820_register_active_regions(int nid, un
 {
 	int i;
 	unsigned long ei_startpfn, ei_endpfn;
+	if (efi_enabled) {
+		efi_memory_desc_t *md;
+		void *p;
+		for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+			md = p;
+			/* add runtime date & runtime service to memory space */
+			if (md->type >= EFI_MEMORY_MAPPED_IO)
+				continue;
+			ei_startpfn = md->phys_addr >> PAGE_SHIFT;
+			ei_endpfn = ei_startpfn + md->num_pages;
+			if (ei_endpfn > end_pfn_map)
+				end_pfn_map = ei_endpfn;
+			/* Obey end_user_pfn to save on memmap */
+			if (ei_startpfn >= end_user_pfn)
+				continue;
+			if (ei_endpfn > end_user_pfn)
+				ei_endpfn = end_user_pfn;
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+		}
+		return;
+	}
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		ei_startpfn = round_up(ei->addr, PAGE_SIZE) >> PAGE_SHIFT;
@@ -595,6 +670,11 @@ void early_panic(char *msg)
 
 void __init setup_memory_region(void)
 {
+	if (efi_enabled) {
+		efi_init();
+		return;
+	}
+	
 	/*
 	 * Try to copy the BIOS-supplied E820-map.
 	 *
@@ -664,7 +744,7 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
-	if (userdef) {
+	if (userdef && !efi_enabled) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
@@ -685,15 +765,31 @@ __init void e820_setup_gap(void)
 	unsigned long last;
 	int i;
 	int found = 0;
+	efi_memory_desc_t *md;
+	void *p;
 
 	last = 0x100000000ull;
 	gapstart = 0x10000000;
 	gapsize = 0x400000;
-	i = e820.nr_map;
+	if (efi_enabled) {
+		i = memmap.nr_map;
+		p = (void *)memmap.map + i * memmap.desc_size;
+	}
+	else
+		i = e820.nr_map;
 	while (--i >= 0) {
-		unsigned long long start = e820.map[i].addr;
-		unsigned long long end = start + e820.map[i].size;
-
+		unsigned long start;
+		unsigned long end;
+		if (efi_enabled) {
+			p -= memmap.desc_size;
+			md = p;
+			start = md->phys_addr;
+			end = start + (md->num_pages << EFI_PAGE_SHIFT);
+		} else {
+			start = e820.map[i].addr;
+			end = start + e820.map[i].size;
+		}
+		
 		/*
 		 * Since "last" is at most 4GB, we know we'll
 		 * fit in 32 bits if this condition is true
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/reboot.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/reboot.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/reboot.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/reboot.c	2007-04-19 13:01:02.000000000 -0700
@@ -7,6 +7,7 @@
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/pm.h>
+#include <linux/efi.h>
 #include <asm/io.h>
 #include <asm/kdebug.h>
 #include <asm/delay.h>
@@ -116,9 +117,15 @@ void machine_emergency_restart(void)
 {
 	int i;
 
+	/* If EFI enabled, reset system through EFI protocol. */
+	if (efi_enabled) {
+		efi.reset_system(EFI_RESET_WARM, EFI_SUCCESS, 0, NULL);
+		return;
+	}
+
 	/* Tell the BIOS if we want cold or warm reboot */
 	*((unsigned short *)__va(0x472)) = reboot_mode;
-       
+
 	for (;;) {
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) { 
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/setup.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/setup.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/setup.c	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/setup.c	2007-04-19 13:01:02.000000000 -0700
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -69,6 +70,10 @@
  * Machine setup..
  */
 
+#ifdef CONFIG_EFI
+int efi_enabled = 0;
+EXPORT_SYMBOL(efi_enabled);
+#endif
 struct cpuinfo_x86 boot_cpu_data __read_mostly;
 EXPORT_SYMBOL(boot_cpu_data);
 
@@ -234,6 +239,10 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
 #endif
+#ifdef CONFIG_EFI
+	if (!strncmp(EFI_LOADER_SIG, "EFIL", 4))
+		efi_enabled = 1;
+#endif
 	setup_memory_region();
 	copy_edd();
 
@@ -271,6 +280,8 @@ void __init setup_arch(char **cmdline_p)
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	if (efi_enabled)
+		efi_map_memmap();
 
 	dmi_scan_machine();
 
@@ -373,6 +384,8 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 
+	if (efi_enabled)
+		reserve_efi_runtime();
 	paging_init();
 
 #ifdef CONFIG_PCI
@@ -404,8 +417,12 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * We trust e820 completely. No explicit ROM probing in memory.
  	 */
-	e820_reserve_resources(); 
-	e820_mark_nosave_regions();
+	if (efi_enabled)
+		efi_initialize_iomem_resources(&code_resource, &data_resource);
+	else {
+		e820_reserve_resources(); 
+		e820_mark_nosave_regions();
+	}
 
 	{
 	unsigned i;
@@ -418,7 +435,8 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/time.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/time.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/kernel/time.c	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/kernel/time.c	2007-04-19 13:01:02.000000000 -0700
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/kallsyms.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #ifdef CONFIG_ACPI
 #include <acpi/achware.h>	/* for PM timer frequency */
@@ -92,6 +93,11 @@ static void set_rtc_mmss(unsigned long n
  */
 
 	spin_lock(&rtc_lock);
+	if (efi_enabled) {
+		efi_set_rtc_mmss(nowtime);
+		spin_unlock(&rtc_lock);
+		return;
+	}
 
 /*
  * Tell the clock it's being set and stop it.
@@ -204,10 +210,15 @@ static irqreturn_t timer_interrupt(int i
 static unsigned long get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
-	unsigned long flags;
+	unsigned long flags, retval;
 	unsigned century = 0;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+	if (efi_enabled) {
+		retval = efi_get_time();
+		spin_unlock_irqrestore(&rtc_lock, flags);
+		return retval;
+	}
 
 	do {
 		sec = CMOS_READ(RTC_SECONDS);
diff -uprN -X linux-2.6.21rc7-git2-orig/Documentation/dontdiff linux-2.6.21rc7-git2-orig/arch/x86_64/mm/init.c linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/mm/init.c
--- linux-2.6.21rc7-git2-orig/arch/x86_64/mm/init.c	2007-04-19 12:39:39.000000000 -0700
+++ linux-2.6.21rc7-git2-uefi-finaltest/arch/x86_64/mm/init.c	2007-04-19 13:01:02.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/efi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -296,8 +297,8 @@ static void __meminit phys_pud_init(pud_
 
 		if (addr >= end)
 			break;
-
-		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
+		if (!after_bootmem && !efi_enabled && 
+			!e820_any_mapped(addr,addr+PUD_SIZE,0)) {
 			set_pud(pud, __pud(0)); 
 			continue;
 		} 
@@ -659,6 +660,8 @@ void __init reserve_bootmem_generic(unsi
 			return;
 		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
 				phys, len);
+		printk(KERN_ERR "reserve_bootmem: pfn (%lx) end_pfn_map (%u)\n",
+			pfn,end_pfn_map);
 		return;
 	}

--
