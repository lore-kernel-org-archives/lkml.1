Return-Path: <linux-kernel-owner+w=401wt.eu-S967587AbXGaDOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967587AbXGaDOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967356AbXGaDNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:13:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:24523 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967107AbXGaDNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,201,1183359600"; 
   d="scan'208";a="256697413"
Subject: [PATCH 2/5] x86_64 EFI support -v3: EFI boot support
From: "Huang, Ying" <ying.huang@intel.com>
To: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 31 Jul 2007 11:12:56 +0800
Message-Id: <1185851576.23149.27.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 31 Jul 2007 03:13:09.0547 (UTC) FILETIME=[B8C1C7B0:01C7D320]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds boot support for EFI x86_64 system.

Boot parameter setup file is updated for x86_64 EFI support. x86_64
EFI boot loader must conform to the EFI boot parameter offsets defined
in the file include/asm-x86_64/bootsetup.h (and x86_64 patches
submitted to ELILO bootloader conforms to this).

The EFI to E820 memory map conversion is done in bootloader. The ELILO
bootloader x86_64 support has been updated to pass E820 map to
kernel. To support EFI runtime service code memory segment, a new E820
memory segment type named E820_RUNTIME_CODE is added. NX bit is turned
off for EFI runtime service area so that EFI runtime code is
executable.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---

 arch/x86_64/kernel/aperture.c  |    5 +++++
 arch/x86_64/kernel/e820.c      |    8 ++++++++
 arch/x86_64/kernel/setup.c     |   16 +++++++++++++++-
 arch/x86_64/mm/init.c          |   30 ++++++++++++++++++++----------
 include/asm-x86_64/bootsetup.h |    6 ++++++
 include/asm-x86_64/e820.h      |    1 +
 6 files changed, 55 insertions(+), 11 deletions(-)

Index: linux-2.6.23-rc1/include/asm-x86_64/bootsetup.h
===================================================================
--- linux-2.6.23-rc1.orig/include/asm-x86_64/bootsetup.h	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/include/asm-x86_64/bootsetup.h	2007-07-30 14:53:58.000000000 +0800
@@ -17,6 +17,12 @@
 #define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
 #define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
 #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
+#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1b8)))
+#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
+#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
+#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
+#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
+#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
 #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
 #define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
 #define SAVED_VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
Index: linux-2.6.23-rc1/include/asm-x86_64/e820.h
===================================================================
--- linux-2.6.23-rc1.orig/include/asm-x86_64/e820.h	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/include/asm-x86_64/e820.h	2007-07-30 14:53:58.000000000 +0800
@@ -19,6 +19,7 @@
 #define E820_RESERVED	2
 #define E820_ACPI	3
 #define E820_NVS	4
+#define E820_RUNTIME_CODE	5	/* efi runtime code */
 
 #ifndef __ASSEMBLY__
 struct e820entry {
Index: linux-2.6.23-rc1/arch/x86_64/kernel/aperture.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/aperture.c	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/kernel/aperture.c	2007-07-30 14:53:58.000000000 +0800
@@ -94,6 +94,11 @@
 		printk("Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0; 
 	} 
+	if (e820_any_mapped(aper_base, aper_base + aper_size,
+			    E820_RUNTIME_CODE)) {
+		printk("Aperture pointing to runtime code. Ignoring.\n");
+		return 0;
+	}
 	return 1;
 } 
 
Index: linux-2.6.23-rc1/arch/x86_64/kernel/e820.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/e820.c	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/kernel/e820.c	2007-07-30 14:53:58.000000000 +0800
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/suspend.h>
 #include <linux/pfn.h>
+#include <linux/efi.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -206,6 +207,7 @@
 		case E820_RAM:	res->name = "System RAM"; break;
 		case E820_ACPI:	res->name = "ACPI Tables"; break;
 		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
+		case E820_RUNTIME_CODE:	res->name = "EFI runtime code"; break;
 		default:	res->name = "reserved";
 		}
 		res->start = e820.map[i].addr;
@@ -376,6 +378,9 @@
 		case E820_NVS:
 				printk("(ACPI NVS)\n");
 				break;
+		case E820_RUNTIME_CODE:
+				printk("(runtime code)\n");
+				break;
 		default:	printk("type %u\n", e820.map[i].type);
 				break;
 		}
@@ -648,6 +653,9 @@
 	} else if (*p == '$') {
 		start_at = memparse(p+1, &p);
 		add_memory_region(start_at, mem_size, E820_RESERVED);
+	} else if (*p == '%') {
+		start_at = memparse(p+1, &p);
+		add_memory_region(start_at, mem_size, E820_RUNTIME_CODE);
 	} else {
 		end_user_pfn = (mem_size >> PAGE_SHIFT);
 	}
Index: linux-2.6.23-rc1/arch/x86_64/kernel/setup.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/kernel/setup.c	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/kernel/setup.c	2007-07-30 14:54:09.000000000 +0800
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
+int efi_enabled;
+EXPORT_SYMBOL(efi_enabled);
+#endif
 struct cpuinfo_x86 boot_cpu_data __read_mostly;
 EXPORT_SYMBOL(boot_cpu_data);
 
@@ -236,6 +241,12 @@
 	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
 #endif
+#ifdef CONFIG_EFI
+	if (!strncmp(EFI_LOADER_SIG, "EFIL", 4)) {
+		efi_enabled = 1;
+		efi_init();
+	}
+#endif
 	setup_memory_region();
 	copy_edd();
 
@@ -273,6 +284,8 @@
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	if (efi_enabled)
+		efi_map_memmap();
 
 	dmi_scan_machine();
 
@@ -411,7 +424,8 @@
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
Index: linux-2.6.23-rc1/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6.23-rc1.orig/arch/x86_64/mm/init.c	2007-07-30 14:51:31.000000000 +0800
+++ linux-2.6.23-rc1/arch/x86_64/mm/init.c	2007-07-30 14:53:58.000000000 +0800
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/memory_hotplug.h>
 #include <linux/nmi.h>
+#include <linux/efi.h>
 
 #include <asm/processor.h>
 #include <asm/system.h>
@@ -52,6 +53,8 @@
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
+/* Flag indicating EFI runtime executable code area */
+static int efi_runtime_code_area;
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
@@ -199,7 +202,7 @@
 static __meminit void unmap_low_page(void *adr)
 { 
 
-	if (after_bootmem)
+	if (after_bootmem || efi_runtime_code_area)
 		return;
 
 	early_iounmap(adr, PAGE_SIZE);
@@ -259,16 +262,21 @@
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
+		} else
+			entry = _PAGE_NX | _PAGE_PSE | _KERNPG_TABLE | \
+				_PAGE_GLOBAL | address;
 		entry &= __supported_pte_mask;
 		set_pmd(pmd, __pmd(entry));
 	}
@@ -296,8 +304,8 @@
 
 		if (addr >= end)
 			break;
-
-		if (!after_bootmem && !e820_any_mapped(addr,addr+PUD_SIZE,0)) {
+		if (!after_bootmem && !efi_enabled &&
+			!e820_any_mapped(addr, addr+PUD_SIZE, 0)) {
 			set_pud(pud, __pud(0)); 
 			continue;
 		} 
@@ -344,7 +352,8 @@
 
 /* Setup the direct mapping of the physical memory at PAGE_OFFSET.
    This runs before bootmem is initialized and gets pages directly from the 
-   physical memory. To access them they are temporarily mapped. */
+   physical memory. To access them they are temporarily mapped.
+   This code can also be called to map EFI runtime code. */
 void __meminit init_memory_mapping(unsigned long start, unsigned long end)
 { 
 	unsigned long next; 
@@ -357,7 +366,8 @@
 	 * mapped.  Unfortunately this is done currently before the nodes are 
 	 * discovered.
 	 */
-	if (!after_bootmem)
+	efi_runtime_code_area = e820_all_mapped(start, end, E820_RUNTIME_CODE);
+	if (!after_bootmem && !efi_runtime_code_area)
 		find_early_table_space(end);
 
 	start = (unsigned long)__va(start);
@@ -368,7 +378,7 @@
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
-		if (after_bootmem)
+		if (after_bootmem || efi_runtime_code_area)
 			pud = pud_offset(pgd, start & PGDIR_MASK);
 		else
 			pud = alloc_low_page(&pud_phys);
@@ -377,7 +387,7 @@
 		if (next > end) 
 			next = end; 
 		phys_pud_init(pud, __pa(start), __pa(next));
-		if (!after_bootmem)
+		if (!after_bootmem && !efi_runtime_code_area)
 			set_pgd(pgd_offset_k(start), mk_kernel_pgd(pud_phys));
 		unmap_low_page(pud);
 	} 
