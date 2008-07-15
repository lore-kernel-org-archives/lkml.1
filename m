Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYGOIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYGOIqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbYGOIqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:46:00 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:45483 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753761AbYGOIp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:45:59 -0400
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables in kdump
Date: Tue, 15 Jul 2008 14:15:27 +0530
User-Agent: KMail/1.9.9
Cc: Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org,
       Alexis Bruemmer <alexisb@us.ibm.com>
References: <1191962414.24134.68.camel@chandru> <200806211741.43703.chandru@in.ibm.com> <20080623192918.GB6989@il.ibm.com>
In-Reply-To: <20080623192918.GB6989@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151415.27845.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdump kernel fails to boot with calgary iommu and aacraid driver on a x366 
box. The ongoing dma's of aacraid from the first kernel continue to exist 
until the driver is loaded in the kdump kernel. Calgary is initialized prior 
to aacraid and creation of new tce tables causes wrong dma's to occur. Here 
we try to get the tce tables of the first kernel in kdump kernel and use 
them. While in the kdump kernel we do not allocate new tce tables but instead 
read the base addres register contents of calgary iommu and use the tables 
that the registers point to. With these changes the kdump kernel and hence 
aacraid now boots normally.

Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>
---

patch taken on top of linux-2.6.26 stable. Comments from Muli Ben-Yehuda taken 
into consideration. Pls apply it as a stop-gap patch until we can come up 
with a more stable patch for this issue. Thanks,

 arch/x86/kernel/pci-calgary_64.c |   87 ++++++++++++++++++++++++++---
 include/linux/crash_dump.h       |    8 ++
 2 files changed, 88 insertions(+), 7 deletions(-)

diff -Narup linux-2.6.26-orig/arch/x86/kernel/pci-calgary_64.c 
linux-2.6.26/arch/x86/kernel/pci-calgary_64.c
--- linux-2.6.26-orig/arch/x86/kernel/pci-calgary_64.c	2008-07-15 
13:36:00.000000000 +0530
+++ linux-2.6.26/arch/x86/kernel/pci-calgary_64.c	2008-07-15 
13:45:36.000000000 +0530
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
@@ -1209,6 +1216,10 @@ static int __init calgary_init(void)
 	if (ret)
 		return ret;
 
+	/* Purely for kdump kernel case  */
+	if (is_kdump_kernel())
+		get_tce_space_from_tar();
+
 	do {
 		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
@@ -1256,6 +1267,23 @@ error:
 	return ret;
 }
 
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
+		if (*tp != 0x0)
+			set_bit(index, tbl->it_map);
+		tp++;
+	}
+}
+
 static inline int __init determine_tce_table_size(u64 ram)
 {
 	int ret;
@@ -1339,12 +1367,50 @@ static int __init calgary_bus_has_device
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
 
@@ -1394,7 +1460,8 @@ void __init detect_calgary(void)
 		return;
 	}
 
-	specified_table_size = determine_tce_table_size(end_pfn * PAGE_SIZE);
+	max_pfn = is_kdump_kernel() ? saved_max_pfn : end_pfn ;
+	specified_table_size = determine_tce_table_size(max_pfn * PAGE_SIZE);
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
@@ -1412,10 +1479,16 @@ void __init detect_calgary(void)
 
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
diff -Narup linux-2.6.26-orig/include/linux/crash_dump.h 
linux-2.6.26/include/linux/crash_dump.h
--- linux-2.6.26-orig/include/linux/crash_dump.h	2008-07-15 13:36:09.000000000 
+0530
+++ linux-2.6.26/include/linux/crash_dump.h	2008-07-15 13:36:37.000000000 
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
