Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXGBUgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXGBUgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXGBUfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:35:32 -0400
Received: from mga06.intel.com ([134.134.136.21]:9397 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754950AbXGBUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,488,1175497200"; 
   d="scan'208";a="261451449"
Message-Id: <20070702170707.878565000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
Date: Mon, 02 Jul 2007 10:06:16 -0700
From: Chandramouli Narayanan <mouli@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@linux-foundation.org
Subject: [PATCH 2.6.21 2/3] x86_64 EFI64 support Try #2
Content-Disposition: inline; filename=patch2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EFI x86_64 support Patch 2 of 3 (try #2)
----------------------------------------
- E820 conversion integration implemented
- A way to override machine_emergency_restart is implemented so that
  EFI support can provide its own implementation.
- The variable efi_enabled is still retained as it is used across
  archictures with CONFIG_EFI option. 
  
Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/aperture.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/aperture.c
--- linux-2.6.21-orig/arch/x86_64/kernel/aperture.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/aperture.c	2007-06-25 13:59:54.000000000 -0700
@@ -95,6 +95,10 @@ static int __init aperture_valid(u64 ape
 		printk("Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0; 
 	} 
+	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RUNTIME_CODE)) {
+		printk("Aperture pointing to runtime code. Ignoring.\n");
+		return 0; 
+	} 
 	return 1;
 } 
 
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/e820.c linux-2.6.21-uefi64-finaltest4/arch/x86_64/kernel/e820.c
--- linux-2.6.21-orig/arch/x86_64/kernel/e820.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi64-finaltest4/arch/x86_64/kernel/e820.c	2007-06-29 15:20:37.000000000 -0700
@@ -17,6 +17,7 @@
 #include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <linux/efi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -234,6 +235,7 @@ void __init e820_reserve_resources(void)
 		case E820_RAM:	res->name = "System RAM"; break;
 		case E820_ACPI:	res->name = "ACPI Tables"; break;
 		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
+		case E820_RUNTIME_CODE:	res->name = "EFI runtime code"; break;
 		default:	res->name = "reserved";
 		}
 		res->start = e820.map[i].addr;
@@ -383,6 +385,9 @@ void __init e820_print_map(char *who)
 		case E820_NVS:
 				printk("(ACPI NVS)\n");
 				break;
+		case E820_RUNTIME_CODE:
+				printk("(runtime code)\n");
+				break;
 		default:	printk("type %u\n", e820.map[i].type);
 				break;
 		}
@@ -601,6 +606,8 @@ void __init setup_memory_region(void)
 	 * Otherwise fake a memory map; one section from 0k->640k,
 	 * the next section from 1mb->appropriate_mem_k
 	 */
+	if (efi_enabled)
+		efi_init();
 	sanitize_e820_map(E820_MAP, &E820_MAP_NR);
 	if (copy_e820_map(E820_MAP, E820_MAP_NR) < 0)
 		early_panic("Cannot find a valid memory map");
@@ -664,7 +671,7 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
-	if (userdef) {
+	if (userdef && !efi_enabled) {
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/reboot.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/reboot.c
--- linux-2.6.21-orig/arch/x86_64/kernel/reboot.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/reboot.c	2007-06-26 13:03:52.000000000 -0700
@@ -7,6 +7,7 @@
 #include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/pm.h>
+#include <linux/efi.h>
 #include <asm/io.h>
 #include <asm/kdebug.h>
 #include <asm/delay.h>
@@ -22,6 +23,14 @@
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
+/* machine_emergency_restart_func is set to the restart implementation here.
+ * The variable provides a way for overriding the implementation.
+ * For example, EFI initialization could set up an emergency restart
+ * function hiding its implementation from here.
+ */
+void (*machine_emergency_restart_func)(void) = machine_emergency_restart;
+EXPORT_SYMBOL(machine_emergency_restart_func);
+
 static long no_idt[3];
 static enum { 
 	BOOT_TRIPLE = 't',
@@ -147,7 +156,7 @@ void machine_restart(char * __unused)
 	if (!reboot_force) {
 		machine_shutdown();
 	}
-	machine_emergency_restart();
+	machine_emergency_restart_func();
 }
 
 void machine_halt(void)
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/setup.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/setup.c
--- linux-2.6.21-orig/arch/x86_64/kernel/setup.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/setup.c	2007-06-21 17:36:47.000000000 -0700
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
 
@@ -418,7 +429,8 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/kernel/time.c linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/time.c
--- linux-2.6.21-orig/arch/x86_64/kernel/time.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/time.c	2007-06-12 16:16:12.000000000 -0700
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
diff -uprN -X linux-2.6.21-orig/Documentation/dontdiff linux-2.6.21-orig/arch/x86_64/mm/init.c linux-2.6.21-uefi64-finaltest4/arch/x86_64/mm/init.c
--- linux-2.6.21-orig/arch/x86_64/mm/init.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.21-uefi64-finaltest4/arch/x86_64/mm/init.c	2007-06-27 17:30:46.000000000 -0700
@@ -26,6 +26,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
+#include <linux/efi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -50,6 +51,8 @@ struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
+/* Flag indicating EFI runtime executable code area */
+static int efi_runtime_code_area = 0;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
@@ -89,6 +92,7 @@ void show_mem(void)
 }
 
 int after_bootmem;
+EXPORT_SYMBOL(after_bootmem);
 
 static __init void *spp_getpage(void)
 { 
@@ -214,7 +218,7 @@ static __meminit void unmap_low_page(int
 { 
 	struct temp_map *ti;
 
-	if (after_bootmem)
+	if (after_bootmem || efi_runtime_code_area)
 		return;
 
 	ti = &temp_mappings[i];
@@ -258,16 +262,19 @@ phys_pmd_init(pmd_t *pmd_page, unsigned 
 		pmd_t *pmd = pmd_page + pmd_index(address);
 
 		if (address >= end) {
-			if (!after_bootmem)
+			if (!after_bootmem && !efi_runtime_code_area)
 				for (; i < PTRS_PER_PMD; i++, pmd++)
 					set_pmd(pmd, __pmd(0));
 			break;
 		}
 
-		if (pmd_val(*pmd))
+		if (pmd_val(*pmd) && !efi_runtime_code_area)
 			continue;
 
-		entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
+		if (efi_runtime_code_area) {
+			entry = pmd_val(*pmd);
+			entry &= ~_PAGE_NX;
+		} else entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
 		entry &= __supported_pte_mask;
 		set_pmd(pmd, __pmd(entry));
 	}
@@ -296,8 +303,8 @@ static void __meminit phys_pud_init(pud_
 
 		if (addr >= end)
 			break;
-
-		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
+		if (!after_bootmem && !efi_enabled &&
+			!e820_any_mapped(addr,addr+PUD_SIZE,0)) {
 			set_pud(pud, __pud(0)); 
 			continue;
 		} 
@@ -344,7 +351,8 @@ static void __init find_early_table_spac
 
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
    This runs before bootmem is initialized and gets pages directly from the 
-   physical memory. To access them they are temporarily mapped. */
+   physical memory. To access them they are temporarily mapped. 
+   This code can also be called to map EFI runtime code. */
 void __meminit init_memory_mapping(unsigned long start, unsigned long end)
 { 
 	unsigned long next; 
@@ -357,7 +365,8 @@ void __meminit init_memory_mapping(unsig
 	 * mapped.  Unfortunately this is done currently before the nodes are 
 	 * discovered.
 	 */
-	if (!after_bootmem)
+	efi_runtime_code_area = e820_all_mapped(start, end, E820_RUNTIME_CODE);
+	if (!after_bootmem && !efi_runtime_code_area)
 		find_early_table_space(end);
 
 	start = (unsigned long)__va(start);
@@ -369,7 +378,7 @@ void __meminit init_memory_mapping(unsig
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
-		if (after_bootmem)
+		if (after_bootmem || efi_runtime_code_area)
 			pud = pud_offset(pgd, start & PGDIR_MASK);
 		else
 			pud = alloc_low_page(&map, &pud_phys);
@@ -378,7 +387,7 @@ void __meminit init_memory_mapping(unsig
 		if (next > end) 
 			next = end; 
 		phys_pud_init(pud, __pa(start), __pa(next));
-		if (!after_bootmem)
+		if (!after_bootmem && !efi_runtime_code_area)
 			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(map);   
 	} 

--
