Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbYFUMMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbYFUMMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 08:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbYFUML6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 08:11:58 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:39925 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYFUML5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 08:11:57 -0400
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Date: Sat, 21 Jun 2008 17:41:43 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Muli Ben-Yehuda <muli@il.ibm.com>
References: <1191962414.24134.68.camel@chandru> <47D5359D.5000909@in.ibm.com> <20080310090912.b9f34d27.akpm@linux-foundation.org>
In-Reply-To: <20080310090912.b9f34d27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806211741.43703.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdump kernel fails to boot with calgary iommu and aacraid driver on a x366 
box. The ongoing dma's of aacraid from the first kernel continue to exist 
until the driver is loaded in the kdump kernel. Calgary is initialized prior 
to aacraid and creation of new tce tables causes wrong dma's to occur. Here 
we try to get the tce tables of the first kernel in kdump kernel and use 
them. While in the kdump kernel we do not allocate new tce tables but instead 
read the base address register contents of calgary iommu and use the tables 
that the registers point to. With these changes the kdump kernel and hence 
aacraid now boots normally. 

Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>
---

 arch/x86/kernel/pci-calgary_64.c |   91 ++++++++++++++++++++++++++---
 include/linux/crash_dump.h       |    8 ++
 2 files changed, 92 insertions(+), 7 deletions(-)

> > Hello Andrew,
> >
> > Could you pls consider the attached patch for inclusion in mainline.
>
> I can sort-of work out what the patch does from the above quote, but it
> would be nice to have a proper changelog description from yourself rather
> than having me try to write it, please.
> The patch was badly wordwrapped.  Please fix your email client for the next
> version.
Sorry for the much delayed response on this mail. The patch was tested with 
linux-2.6.26-rc6.  Pls consider it for inclusion. 
Thanks,



diff -Naurp linux-2.6.26-rc6-orig/arch/x86/kernel/pci-calgary_64.c 
linux-2.6.26-rc6/arch/x86/kernel/pci-calgary_64.c
--- linux-2.6.26-rc6-orig/arch/x86/kernel/pci-calgary_64.c	2008-06-21 
13:59:08.000000000 +0530
+++ linux-2.6.26-rc6/arch/x86/kernel/pci-calgary_64.c	2008-06-21 
13:59:45.000000000 +0530
@@ -36,6 +36,7 @@
 #include <linux/delay.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
+#include <linux/crash_dump.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
 #include <asm/tce.h>
@@ -167,6 +168,8 @@ static void calgary_dump_error_regs(stru
 static void calioc2_handle_quirks(struct iommu_table *tbl, struct pci_dev 
*dev);
 static void calioc2_tce_cache_blast(struct iommu_table *tbl);
 static void calioc2_dump_error_regs(struct iommu_table *tbl);
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl);
+static void get_tce_space_from_tar(void);
 
 static struct cal_chipset_ops calgary_chip_ops = {
 	.handle_quirks = calgary_handle_quirks,
@@ -830,7 +833,11 @@ static int __init calgary_setup_tar(stru
 
 	tbl = pci_iommu(dev->bus);
 	tbl->it_base = (unsigned long)bus_info[dev->bus->number].tce_space;
-	tce_free(tbl, 0, tbl->it_size);
+
+	if (is_kdump_kernel())
+		calgary_init_bitmap_from_tce_table(tbl);
+	else
+		tce_free(tbl, 0, tbl->it_size);
 
 	if (is_calgary(dev->device))
 		tbl->chip_ops = &calgary_chip_ops;
@@ -1206,9 +1213,14 @@ static int __init calgary_init(void)
 	struct calgary_bus_info *info;
 
 	ret = calgary_locate_bbars();
+
 	if (ret)
 		return ret;
 
+	/* Purely for kdump kernel case  */
+	if (is_kdump_kernel())
+		get_tce_space_from_tar();
+
 	do {
 		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
@@ -1256,6 +1268,24 @@ error:
 	return ret;
 }
 
+
+/*
+ * calgary_init_bitmap_from_tce_table():
+ * Funtion for kdump case. In the second/kdump kernel initialize
+ * the bitmap based on the tce table entries obtained from first kernel
+ */
+static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
+{
+	u64 *tp;
+	unsigned int index;
+	tp = ((u64 *)tbl->it_base);
+	for (index = 0 ; index < tbl->it_size; index++) {
+	if (*tp != 0x0)
+		set_bit(index, tbl->it_map);
+		tp++;
+	}
+}
+
 static inline int __init determine_tce_table_size(u64 ram)
 {
 	int ret;
@@ -1318,6 +1348,8 @@ static int __init build_detail_arrays(vo
 	return 0;
 }
 
+
+
 static int __init calgary_bus_has_devices(int bus, unsigned short pci_dev)
 {
 	int dev;
@@ -1339,12 +1371,50 @@ static int __init calgary_bus_has_device
 	return (val != 0xffffffff);
 }
 
+/*
+ * get_tce_space_from_tar():
+ * Function for kdump case. Get the tce tables from first kernel
+ * by reading the contents of the base adress register of calgary iommu
+ */
+static void get_tce_space_from_tar()
+{
+	int bus;
+	void __iomem *target;
+	unsigned long tce_space;
+
+	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
+		struct calgary_bus_info *info = &bus_info[bus];
+		unsigned short pci_device;
+		u32 val;
+
+		val = read_pci_config(bus, 0, 0, 0);
+		pci_device = (val & 0xFFFF0000) >> 16;
+
+		if (!is_cal_pci_dev(pci_device))
+			continue;
+		if (info->translation_disabled)
+			continue;
+
+		if (calgary_bus_has_devices(bus, pci_device) ||
+			translate_empty_slots) {
+			target = calgary_reg(bus_info[bus].bbar,
+				tar_offset(bus));
+			tce_space = be64_to_cpu(readq(target));
+			tce_space = tce_space & TAR_SW_BITS;
+
+			tce_space = tce_space & (~specified_table_size);
+			info->tce_space = (u64 *)__va(tce_space);
+		}
+	}
+	return;
+}
+
 void __init detect_calgary(void)
 {
 	int bus;
 	void *tbl;
 	int calgary_found = 0;
-	unsigned long ptr;
+	unsigned long ptr, max_pfn;
 	unsigned int offset, prev_offset;
 	int ret;
 
@@ -1394,7 +1464,8 @@ void __init detect_calgary(void)
 		return;
 	}
 
-	specified_table_size = determine_tce_table_size(end_pfn * PAGE_SIZE);
+	max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
+	specified_table_size = determine_tce_table_size(max_pfn * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
@@ -1412,10 +1483,16 @@ void __init detect_calgary(void)
 
 		if (calgary_bus_has_devices(bus, pci_device) ||
 		    translate_empty_slots) {
-			tbl = alloc_tce_table();
-			if (!tbl)
-				goto cleanup;
-			info->tce_space = tbl;
+			/*
+			 * If it is kdump kernel, find and use tce tables
+			 * from first kernel, else allocate tce tables here
+			 */
+			if (!is_kdump_kernel()) {
+				tbl = alloc_tce_table();
+				if (!tbl)
+					goto cleanup;
+				info->tce_space = tbl;
+			}
 			calgary_found = 1;
 		}
 	}
diff -Naurp linux-2.6.26-rc6-orig/include/linux/crash_dump.h 
linux-2.6.26-rc6/include/linux/crash_dump.h
--- linux-2.6.26-rc6-orig/include/linux/crash_dump.h	2008-06-21 
13:59:18.000000000 +0530
+++ linux-2.6.26-rc6/include/linux/crash_dump.h	2008-06-21 14:00:42.000000000 
+0530
@@ -22,5 +22,13 @@ extern struct proc_dir_entry *proc_vmcor
 
 #define vmcore_elf_check_arch(x) (elf_check_arch(x) || 
vmcore_elf_check_arch_cross(x))
 
+static inline int is_kdump_kernel(void)
+{
+	return (elfcorehdr_addr != ELFCORE_ADDR_MAX) ? 1 : 0 ;
+}
+#else /* !CONFIG_CRASH_DUMP */
+static inline int is_kdump_kernel(void) { return 0; }
 #endif /* CONFIG_CRASH_DUMP */
+
+extern unsigned long saved_max_pfn;
 #endif /* LINUX_CRASHDUMP_H */
