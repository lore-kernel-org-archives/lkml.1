Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYAJSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYAJSzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 13:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbYAJSzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 13:55:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:4583 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589AbYAJSzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 13:55:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="320739376"
Message-Id: <20080110184854.557190000@intel.com>
References: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:41 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 01/11] PAT x86: Make acpi/other drivers map memory instead of assuming identity map
Content-Disposition: inline; filename=map_instead_of_va.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series is heavily derived from the PAT patchset by Eric Biederman and
Andi Kleen.
http://www.firstfloor.org/pub/ak/x86_64/pat/

This patchset is a followup of "PAT support for X86_64"
http://www.ussg.iu.edu/hypermail/linux/kernel/0712.1/2268.html

Things changed from the above (Dec 13 2007) version:
* PAT mappings now used are - (0,WB) (1,WT) (2,WC) (3,UC).
* Covers both i386 and x86_64.
* Resolve the /sysfs issue by exporting wc and uc interfaces.
* Piggyback PAT initialization on existing MTRR initialization as they
  have same setup rules.
* Avoid early table allocation problem for x86_64 by doing the reserved
  region pruning later in the boot. Handle both memory identity mapping and
  kernel test mapping.
* Handle fork() and /dev/mem mapping and unmapping cases.

This patch:

Some boot code has assumptions about entire memory being mapped in identity
mapping. Fix them to use some form of mapping instead. Places fixed below:
* Generic __acpi_map_table
* Looking for RSD PTR at boot time
* Looking for mp table
* get_bios_ebda and ebda size
* pci-calgary (Compile tested only. Will be great if someone who has this
               hardware can verify that this change works fine)
              (This patch is testable as a standalone patch)

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Patchset is against Ingo's x86 branch from 2 days ago. Will need some merging
effort with Andi's CPA changes and few other changes like pgtable.h unification.


Index: linux-2.6.git/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/acpi/boot.c	2008-01-08 03:31:31.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/acpi/boot.c	2008-01-08 03:43:46.000000000 -0800
@@ -105,16 +105,20 @@
 
 #ifdef	CONFIG_X86_64
 
-/* rely on all ACPI tables being in the direct mapping */
 char *__acpi_map_table(unsigned long phys_addr, unsigned long size)
 {
 	if (!phys_addr || !size)
 		return NULL;
 
-	if (phys_addr+size <= (end_pfn_map << PAGE_SHIFT) + PAGE_SIZE)
-		return __va(phys_addr);
+	return early_ioremap(phys_addr, size);
+}
 
-	return NULL;
+void __acpi_unmap_table(void * addr, unsigned long size)
+{
+	if (!addr || !size)
+		return;
+
+	early_iounmap(addr, size);
 }
 
 #else
@@ -158,6 +162,11 @@
 
 	return ((unsigned char *)base + offset);
 }
+
+void __acpi_unmap_table(void * addr, unsigned long size)
+{
+}
+
 #endif
 
 #ifdef CONFIG_PCI_MMCONFIG
@@ -586,17 +595,23 @@
 {
 	unsigned long offset = 0;
 	unsigned long sig_len = sizeof("RSD PTR ") - 1;
+	char * virt_addr;
 
+	virt_addr = __acpi_map_table(start, length);
+	if (!virt_addr)
+		return 0;
 	/*
 	 * Scan all 16-byte boundaries of the physical memory region for the
 	 * RSDP signature.
 	 */
 	for (offset = 0; offset < length; offset += 16) {
-		if (strncmp((char *)(phys_to_virt(start) + offset), "RSD PTR ", sig_len))
+		if (strncmp(virt_addr + offset, "RSD PTR ", sig_len))
 			continue;
+		__acpi_unmap_table(virt_addr, length);
 		return (start + offset);
 	}
 
+	__acpi_unmap_table(virt_addr, length);
 	return 0;
 }
 
Index: linux-2.6.git/drivers/acpi/osl.c
===================================================================
--- linux-2.6.git.orig/drivers/acpi/osl.c	2008-01-08 03:31:31.000000000 -0800
+++ linux-2.6.git/drivers/acpi/osl.c	2008-01-08 03:43:46.000000000 -0800
@@ -231,6 +231,8 @@
 {
 	if (acpi_gbl_permanent_mmap) {
 		iounmap(virt);
+	} else {
+		__acpi_unmap_table(virt, size);
 	}
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
Index: linux-2.6.git/include/linux/acpi.h
===================================================================
--- linux-2.6.git.orig/include/linux/acpi.h	2008-01-08 03:31:38.000000000 -0800
+++ linux-2.6.git/include/linux/acpi.h	2008-01-08 03:43:46.000000000 -0800
@@ -79,6 +79,7 @@
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __acpi_unmap_table (void * addr, unsigned long size);
 unsigned long acpi_find_rsdp (void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
Index: linux-2.6.git/arch/x86/kernel/mpparse_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/mpparse_64.c	2008-01-08 03:31:31.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/mpparse_64.c	2008-01-08 03:43:46.000000000 -0800
@@ -29,6 +29,7 @@
 #include <asm/io_apic.h>
 #include <asm/proto.h>
 #include <asm/acpi.h>
+#include <asm/bios_ebda.h>
 
 /* Have we found an MP table */
 int smp_found_config;
@@ -535,9 +536,12 @@
 static int __init smp_scan_config (unsigned long base, unsigned long length)
 {
 	extern void __bad_mpf_size(void); 
-	unsigned int *bp = phys_to_virt(base);
+	unsigned int *bp = (unsigned int *)__acpi_map_table(base, length);
 	struct intel_mp_floating *mpf;
 
+	if (!bp)
+		return 0;
+
 	Dprintk("Scan SMP from %p for %ld bytes.\n", bp,length);
 	if (sizeof(*mpf) != 16)
 		__bad_mpf_size();
@@ -555,11 +559,13 @@
 			if (mpf->mpf_physptr)
 				reserve_bootmem_generic(mpf->mpf_physptr, PAGE_SIZE);
 			mpf_found = mpf;
+			__acpi_unmap_table((char *)bp, length);
 			return 1;
 		}
 		bp += 4;
 		length -= 16;
 	}
+	__acpi_unmap_table((char *)bp, length);
 	return 0;
 }
 
@@ -592,11 +598,11 @@
 	 * should be fixed.
 	 */
 
-	address = *(unsigned short *)phys_to_virt(0x40E);
-	address <<= 4;
-	if (smp_scan_config(address, 0x1000))
+	address = get_bios_ebda();
+	if (address && smp_scan_config(address, 0x1000))
 		return;
 
+
 	/* If we have come this far, we did not find an MP table  */
 	 printk(KERN_INFO "No mptable found.\n");
 }
Index: linux-2.6.git/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-08 03:43:46.000000000 -0800
@@ -208,7 +208,7 @@
 } 
 
 /* Must run before zap_low_mappings */
-__meminit void *early_ioremap(unsigned long addr, unsigned long size)
+void *early_ioremap(unsigned long addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd, *last_pmd;
@@ -237,7 +237,7 @@
 }
 
 /* To avoid virtual aliases later */
-__meminit void early_iounmap(void *addr, unsigned long size)
+void early_iounmap(void *addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd;
Index: linux-2.6.git/include/asm-x86/rio.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/rio.h	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/include/asm-x86/rio.h	2008-01-08 03:43:46.000000000 -0800
@@ -8,6 +8,8 @@
 #ifndef __ASM_RIO_H
 #define __ASM_RIO_H
 
+#include <asm/bios_ebda.h>
+
 #define RIO_TABLE_VERSION	3
 
 struct rio_table_hdr {
@@ -60,15 +62,4 @@
 	ALT_CALGARY	= 5,  /* Second Planar Calgary      */
 };
 
-/*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
- */
-static inline unsigned long get_bios_ebda(void)
-{
-	unsigned long address = *(unsigned short *)phys_to_virt(0x40EUL);
-	address <<= 4;
-	return address;
-}
-
 #endif /* __ASM_RIO_H */
Index: linux-2.6.git/arch/x86/kernel/mpparse_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/mpparse_32.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/mpparse_32.c	2008-01-08 03:43:46.000000000 -0800
@@ -27,11 +27,11 @@
 #include <asm/mtrr.h>
 #include <asm/mpspec.h>
 #include <asm/io_apic.h>
+#include <asm/bios_ebda.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
 #include <mach_mpparse.h>
-#include <bios_ebda.h>
 
 /* Have we found an MP table */
 int smp_found_config;
@@ -718,9 +718,12 @@
 
 static int __init smp_scan_config (unsigned long base, unsigned long length)
 {
-	unsigned long *bp = phys_to_virt(base);
+	unsigned long *bp = (unsigned long *)__acpi_map_table(base, length);
 	struct intel_mp_floating *mpf;
 
+	if (!bp)
+		return 0;
+
 	Dprintk("Scan SMP from %p for %ld bytes.\n", bp,length);
 	if (sizeof(*mpf) != 16)
 		printk("Error: MPF size\n");
@@ -755,11 +758,13 @@
 			}
 
 			mpf_found = mpf;
+			__acpi_unmap_table((char *)bp, length);
 			return 1;
 		}
 		bp += 4;
 		length -= 16;
 	}
+	__acpi_unmap_table((char *)bp, length);
 	return 0;
 }
 
Index: linux-2.6.git/arch/x86/kernel/pci-calgary_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/pci-calgary_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/pci-calgary_64.c	2008-01-08 03:43:46.000000000 -0800
@@ -1180,6 +1180,7 @@
 		}
 	}
 
+	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
 	return 0;
 
 error:
@@ -1188,6 +1189,7 @@
 		if (bus_info[bus].bbar)
 			iounmap(bus_info[bus].bbar);
 
+	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
 	return ret;
 }
 
@@ -1337,7 +1339,8 @@
 	int bus;
 	void *tbl;
 	int calgary_found = 0;
-	unsigned long ptr;
+	unsigned long addr;
+	unsigned short *ptr;
 	unsigned int offset, prev_offset;
 	int ret;
 
@@ -1356,7 +1359,9 @@
 
 	printk(KERN_DEBUG "Calgary: detecting Calgary via BIOS EBDA area\n");
 
-	ptr = (unsigned long)phys_to_virt(get_bios_ebda());
+	addr = get_bios_ebda();
+	if (!addr)
+		return;
 
 	rio_table_hdr = NULL;
 	prev_offset = 0;
@@ -1366,14 +1371,22 @@
 	 * Only parse up until the offset increases:
 	 */
 	while (offset > prev_offset) {
+		ptr = early_ioremap(addr + offset, 4);
+		if (!ptr)
+			break;
+
 		/* The block id is stored in the 2nd word */
-		if (*((unsigned short *)(ptr + offset + 2)) == 0x4752){
+		if (ptr[1] == 0x4752){
+			early_iounmap(ptr, 4);
 			/* set the pointer past the offset & block id */
-			rio_table_hdr = (struct rio_table_hdr *)(ptr + offset + 4);
+			ptr = early_ioremap(addr + offset + 4,
+			              sizeof(struct rio_table_hdr));
+			rio_table_hdr = (struct rio_table_hdr *)ptr;
 			break;
 		}
 		prev_offset = offset;
-		offset = *((unsigned short *)(ptr + offset));
+		offset = ptr[0];
+		early_iounmap(ptr, 4);
 	}
 	if (!rio_table_hdr) {
 		printk(KERN_DEBUG "Calgary: Unable to locate Rio Grande table "
@@ -1384,6 +1397,8 @@
 	ret = build_detail_arrays();
 	if (ret) {
 		printk(KERN_DEBUG "Calgary: build_detail_arrays ret %d\n", ret);
+		early_iounmap((void *)rio_table_hdr,
+		              sizeof(struct rio_table_hdr));
 		return;
 	}
 
@@ -1423,6 +1438,10 @@
 		printk(KERN_INFO "PCI-DMA: Calgary TCE table spec is %d, "
 		       "CONFIG_IOMMU_DEBUG is %s.\n", specified_table_size,
 		       debugging ? "enabled" : "disabled");
+		/* rio_table_hdr will be unmapped in calgary_locate_bbars() */
+	} else {
+		early_iounmap((void *)rio_table_hdr,
+		              sizeof(struct rio_table_hdr));
 	}
 	return;
 
@@ -1433,6 +1452,7 @@
 		if (info->tce_space)
 			free_tce_table(info->tce_space);
 	}
+	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
 }
 
 int __init calgary_iommu_init(void)
Index: linux-2.6.git/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup_32.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/setup_32.c	2008-01-08 03:43:46.000000000 -0800
@@ -61,7 +61,7 @@
 #include <asm/io.h>
 #include <asm/vmi.h>
 #include <setup_arch.h>
-#include <bios_ebda.h>
+#include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
 
 /* This value is set up by the early boot code to point to the value
Index: linux-2.6.git/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/setup_64.c	2008-01-08 03:41:30.000000000 -0800
+++ linux-2.6.git/arch/x86/kernel/setup_64.c	2008-01-08 03:47:57.000000000 -0800
@@ -62,6 +62,7 @@
 #include <asm/sections.h>
 #include <asm/dmi.h>
 #include <asm/cacheflush.h>
+#include <asm/bios_ebda.h>
 #include <asm/mce.h>
 #include <asm/ds.h>
 
@@ -243,31 +244,36 @@
 {}
 #endif
 
-#define EBDA_ADDR_POINTER 0x40E
-
 unsigned __initdata ebda_addr;
 unsigned __initdata ebda_size;
 
 static void discover_ebda(void)
 {
+	unsigned short *ptr;
 	/*
 	 * there is a real-mode segmented pointer pointing to the
 	 * 4K EBDA area at 0x40E
 	 */
-	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
 	/*
 	 * There can be some situations, like paravirtualized guests,
 	 * in which there is no available ebda information. In such
 	 * case, just skip it
 	 */
+
+	ebda_addr = get_bios_ebda();
 	if (!ebda_addr) {
 		ebda_size = 0;
 		return;
 	}
 
-	ebda_addr <<= 4;
-
-	ebda_size = *(unsigned short *)__va(ebda_addr);
+	ptr = (unsigned short *)__acpi_map_table(ebda_addr, 2);
+	if (!ptr) {
+		ebda_addr = 0;
+		ebda_size = 0;
+		return;
+	}
+	ebda_size = *(unsigned short *)ptr;
+	__acpi_unmap_table((char *)ptr, 2);
 
 	/* Round EBDA up to pages */
 	if (ebda_size == 0)
Index: linux-2.6.git/include/asm-x86/bios_ebda.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.git/include/asm-x86/bios_ebda.h	2008-01-08 03:43:46.000000000 -0800
@@ -0,0 +1,26 @@
+
+#ifndef _BIOS_EBDA_H
+#define _BIOS_EBDA_H
+
+#include <linux/acpi.h>
+
+/*
+ * there is a real-mode segmented pointer pointing to the
+ * 4K EBDA area at 0x40E.
+ */
+static inline unsigned long get_bios_ebda(void)
+{
+	unsigned short	*bp;
+	unsigned long address;
+	bp = (unsigned short *)__acpi_map_table(0x40EUL, 2);
+	if (!bp)
+		return 0;
+
+	address = *bp;
+	address <<= 4;
+	__acpi_unmap_table((char *)bp, 2);
+
+	return address;
+}
+
+#endif /* _MACH_BIOS_EBDA_H */
Index: linux-2.6.git/include/asm-x86/mach-default/bios_ebda.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/mach-default/bios_ebda.h	2008-01-08 03:31:38.000000000 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,15 +0,0 @@
-#ifndef _MACH_BIOS_EBDA_H
-#define _MACH_BIOS_EBDA_H
-
-/*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
- */
-static inline unsigned int get_bios_ebda(void)
-{
-	unsigned int address = *(unsigned short *)phys_to_virt(0x40E);
-	address <<= 4;
-	return address;	/* 0 means none */
-}
-
-#endif /* _MACH_BIOS_EBDA_H */

-- 
