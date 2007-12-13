Return-Path: <linux-kernel-owner+w=401wt.eu-S934831AbXLNAFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831AbXLNAFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934797AbXLNAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:04:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:58030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934788AbXLNAEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:04:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340710601"
Message-Id: <20071213235713.287720000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:53 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 10/12] PAT 64b: Make acpi use early map instead of assuming identity map
Content-Disposition: inline; filename=acpi_use_early_ioremap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI boot code has assumptions about entire memory being mapped in identity
mapping at:
* Generic __acpi_map_table
* Looking for RSD PTR at boot time
* Looking for mp table

Fix all these to use early_ioremap and early_iounmap.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6.24-rc/arch/x86/kernel/acpi/boot.c
@@ -105,16 +105,20 @@ enum acpi_irq_model_id acpi_irq_model = 
 
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
@@ -158,6 +162,11 @@ char *__acpi_map_table(unsigned long phy
 
 	return ((unsigned char *)base + offset);
 }
+
+void __acpi_unmap_table(void * addr, unsigned long size)
+{
+}
+
 #endif
 
 #ifdef CONFIG_PCI_MMCONFIG
@@ -586,17 +595,23 @@ acpi_scan_rsdp(unsigned long start, unsi
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
 
Index: linux-2.6.24-rc/drivers/acpi/osl.c
===================================================================
--- linux-2.6.24-rc.orig/drivers/acpi/osl.c
+++ linux-2.6.24-rc/drivers/acpi/osl.c
@@ -231,6 +231,8 @@ void acpi_os_unmap_memory(void __iomem *
 {
 	if (acpi_gbl_permanent_mmap) {
 		iounmap(virt);
+	} else {
+		__acpi_unmap_table(virt, size);
 	}
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
Index: linux-2.6.24-rc/include/linux/acpi.h
===================================================================
--- linux-2.6.24-rc.orig/include/linux/acpi.h
+++ linux-2.6.24-rc/include/linux/acpi.h
@@ -79,6 +79,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __acpi_unmap_table (void * addr, unsigned long size);
 unsigned long acpi_find_rsdp (void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
Index: linux-2.6.24-rc/arch/x86/kernel/mpparse_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/kernel/mpparse_64.c
+++ linux-2.6.24-rc/arch/x86/kernel/mpparse_64.c
@@ -535,9 +535,12 @@ void __init get_smp_config (void)
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
@@ -555,17 +558,20 @@ static int __init smp_scan_config (unsig
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
 
 void __init find_smp_config(void)
 {
 	unsigned int address;
+	unsigned short *bp;
 
 	/*
 	 * FIXME: Linux assumes you have 640K of base ram..
@@ -592,11 +598,17 @@ void __init find_smp_config(void)
 	 * should be fixed.
 	 */
 
-	address = *(unsigned short *)phys_to_virt(0x40E);
+	bp = (unsigned short *)__acpi_map_table(0x40E, 2);
+	if (!bp)
+		return;
+
+	address = *bp;
 	address <<= 4;
 	if (smp_scan_config(address, 0x1000))
 		return;
 
+	__acpi_unmap_table((char *)bp, 2);
+
 	/* If we have come this far, we did not find an MP table  */
 	 printk(KERN_INFO "No mptable found.\n");
 }
Index: linux-2.6.24-rc/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.24-rc.orig/arch/x86/mm/init_64.c
+++ linux-2.6.24-rc/arch/x86/mm/init_64.c
@@ -206,7 +206,7 @@ static __meminit void unmap_low_page(voi
 } 
 
 /* Must run before zap_low_mappings */
-__meminit void *early_ioremap(unsigned long addr, unsigned long size)
+void *early_ioremap(unsigned long addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd, *last_pmd;
@@ -235,7 +235,7 @@ __meminit void *early_ioremap(unsigned l
 }
 
 /* To avoid virtual aliases later */
-__meminit void early_iounmap(void *addr, unsigned long size)
+void early_iounmap(void *addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd;

-- 
