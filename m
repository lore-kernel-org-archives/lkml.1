Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYFQDK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYFQDK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 23:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYFQDKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 23:10:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:26132 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYFQDKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 23:10:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=HrSblhjCLRqv2je+97XzHb8rnkYsLl8BR6QBTuJTSQ5+tTKANBwV0KDbUdYJzQDV/x
         5dX+IML8RmUZML3doP5hQU5o18e/ib6I3gQJ+PEnARsK7+LV0VLlkxCP+Xkse07jAxZ+
         p8qJSwsuhvkk1EGivcdCoNDIztk9N4oIfPEtM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Jan Engelhardt <jengelh@gmx.de>
Subject: RFC [PATCH] x86: try to remove arch_get_ram_range
Date: Mon, 16 Jun 2008 20:10:55 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806162010.55495.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

want to remove arch_get_ram_range, and use early_node_map instead.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -298,7 +298,7 @@ struct add_highpages_data {
 	unsigned long end_pfn;
 };
 
-static void __init add_highpages_work_fn(unsigned long start_pfn,
+static int __init add_highpages_work_fn(unsigned long start_pfn,
 					 unsigned long end_pfn, void *datax)
 {
 	int node_pfn;
@@ -311,7 +311,7 @@ static void __init add_highpages_work_fn
 	final_start_pfn = max(start_pfn, data->start_pfn);
 	final_end_pfn = min(end_pfn, data->end_pfn);
 	if (final_start_pfn >= final_end_pfn)
-		return;
+		return 0;
 
 	for (node_pfn = final_start_pfn; node_pfn < final_end_pfn;
 	     node_pfn++) {
@@ -321,6 +321,8 @@ static void __init add_highpages_work_fn
 		add_one_highpage_init(page, node_pfn);
 	}
 
+	return 0;
+
 }
 
 void __init add_highpages_with_active_regions(int nid, unsigned long start_pfn,
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -1637,12 +1637,43 @@ static inline int iommu_prepare_rmrr_dev
 }
 
 #ifdef CONFIG_DMAR_GFX_WA
-extern int arch_get_ram_range(int slot, u64 *addr, u64 *size);
+struct iommu_prepare_data {
+	struct pci_dev *pdev;
+	int ret;
+};
+
+static int __init iommu_prepare_work_fn(unsigned long start_pfn,
+					 unsigned long end_pfn, void *datax)
+{
+	struct iommu_prepare_data *data;
+
+	data = (struct iommu_prepare_data *)datax;
+
+	data->ret = iommu_prepare_identity_map(data->pdev,
+				start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+	return data->ret;
+
+}
+
+static int __init iommu_prepare_with_active_regions(struct pci_dev *pdev)
+{
+	int nid;
+	struct iommu_prepare_data data;
+
+	data.pdev = pdev;
+	data.ret = 0;
+
+	for_each_online_node(nid) {
+		work_with_active_regions(nid, iommu_prepare_work_fn, &data);
+		if (data.ret)
+			return data.ret;
+	}
+	return data.ret;
+}
+
 static void __init iommu_prepare_gfx_mapping(void)
 {
 	struct pci_dev *pdev = NULL;
-	u64 base, size;
-	int slot;
 	int ret;
 
 	for_each_pci_dev(pdev) {
@@ -1651,17 +1682,9 @@ static void __init iommu_prepare_gfx_map
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
 			pci_name(pdev));
-		slot = arch_get_ram_range(0, &base, &size);
-		while (slot >= 0) {
-			ret = iommu_prepare_identity_map(pdev,
-					base, base + size);
-			if (ret)
-				goto error;
-			slot = arch_get_ram_range(slot, &base, &size);
-		}
-		continue;
-error:
-		printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
+		ret = iommu_prepare_with_active_regions(pdev);
+		if (ret)
+			printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
 	}
 }
 #endif
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1011,7 +1011,7 @@ extern unsigned long find_min_pfn_with_a
 extern unsigned long find_max_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
-typedef void (*work_fn_t)(unsigned long, unsigned long, void *);
+typedef int (*work_fn_t)(unsigned long, unsigned long, void *);
 extern void work_with_active_regions(int nid, work_fn_t work_fn, void *data);
 extern void sparse_memory_present_with_active_regions(int nid);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -2942,10 +2942,14 @@ void __init free_bootmem_with_active_reg
 void __init work_with_active_regions(int nid, work_fn_t work_fn, void *data)
 {
 	int i;
+	int ret;
 
-	for_each_active_range_index_in_nid(i, nid)
-		work_fn(early_node_map[i].start_pfn, early_node_map[i].end_pfn,
-			data);
+	for_each_active_range_index_in_nid(i, nid) {
+		ret = work_fn(early_node_map[i].start_pfn,
+			      early_node_map[i].end_pfn, data);
+		if (ret)
+			break;
+	}
 }
 /**
  * sparse_memory_present_with_active_regions - Call memory_present for each active range
