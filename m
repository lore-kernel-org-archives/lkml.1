Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZKQI0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZKQI0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbZKQI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:26:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:45391 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZKQIZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:25:59 -0500
Date: Tue, 17 Nov 2009 08:25:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, fujita.tomonori@lab.ntt.co.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] x86: gart: Clean up the code a bit
Message-ID: <tip-123bf0e2eddcda36a33bdfc87aa1fb07229f07b5@git.kernel.org>
Git-Commit-ID: 123bf0e2eddcda36a33bdfc87aa1fb07229f07b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  123bf0e2eddcda36a33bdfc87aa1fb07229f07b5
Gitweb:     http://git.kernel.org/tip/123bf0e2eddcda36a33bdfc87aa1fb07229f07b5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 15 Nov 2009 21:19:52 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 07:57:00 +0100

x86: gart: Clean up the code a bit

Clean up various small stylistic details in the GART code. No
functionality changed.

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: muli@il.ibm.com
Cc: joerg.roedel@amd.com
LKML-Reference: <1258287594-8777-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/pci-gart_64.c |  116 +++++++++++++++++++++-------------------
 1 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 61c4d1e..e6a0d40 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -95,7 +95,7 @@ static unsigned long alloc_iommu(struct device *dev, int size,
 
 	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
 			   PAGE_SIZE) >> PAGE_SHIFT;
-	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
+	boundary_size = ALIGN((u64)dma_get_seg_boundary(dev) + 1,
 			      PAGE_SIZE) >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
@@ -297,7 +297,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 	int i;
 
 #ifdef CONFIG_IOMMU_DEBUG
-	printk(KERN_DEBUG "dma_map_sg overflow\n");
+	pr_debug("dma_map_sg overflow\n");
 #endif
 
 	for_each_sg(sg, s, nents, i) {
@@ -392,12 +392,14 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	if (!dev)
 		dev = &x86_dma_fallback_dev;
 
-	out = 0;
-	start = 0;
-	start_sg = sgmap = sg;
-	seg_size = 0;
-	max_seg_size = dma_get_max_seg_size(dev);
-	ps = NULL; /* shut up gcc */
+	out		= 0;
+	start		= 0;
+	start_sg	= sg;
+	sgmap		= sg;
+	seg_size	= 0;
+	max_seg_size	= dma_get_max_seg_size(dev);
+	ps		= NULL; /* shut up gcc */
+
 	for_each_sg(sg, s, nents, i) {
 		dma_addr_t addr = sg_phys(s);
 
@@ -420,11 +422,12 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 						 sgmap, pages, need) < 0)
 					goto error;
 				out++;
-				seg_size = 0;
-				sgmap = sg_next(sgmap);
-				pages = 0;
-				start = i;
-				start_sg = s;
+
+				seg_size	= 0;
+				sgmap		= sg_next(sgmap);
+				pages		= 0;
+				start		= i;
+				start_sg	= s;
 			}
 		}
 
@@ -523,7 +526,7 @@ static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
 	iommu_size -= round_up(a, PMD_PAGE_SIZE) - a;
 
 	if (iommu_size < 64*1024*1024) {
-		printk(KERN_WARNING
+		pr_warning(
 			"PCI-DMA: Warning: Small IOMMU %luMB."
 			" Consider increasing the AGP aperture in BIOS\n",
 				iommu_size >> 20);
@@ -578,28 +581,32 @@ void set_up_gart_resume(u32 aper_order, u32 aper_alloc)
 	aperture_alloc = aper_alloc;
 }
 
-static int gart_resume(struct sys_device *dev)
+static void gart_fixup_northbridges(struct sys_device *dev)
 {
-	printk(KERN_INFO "PCI-DMA: Resuming GART IOMMU\n");
+	int i;
 
-	if (fix_up_north_bridges) {
-		int i;
+	if (!fix_up_north_bridges)
+		return;
 
-		printk(KERN_INFO "PCI-DMA: Restoring GART aperture settings\n");
+	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-		for (i = 0; i < num_k8_northbridges; i++) {
-			struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < num_k8_northbridges; i++) {
+		struct pci_dev *dev = k8_northbridges[i];
 
-			/*
-			 * Don't enable translations just yet.  That is the next
-			 * step.  Restore the pre-suspend aperture settings.
-			 */
-			pci_write_config_dword(dev, AMD64_GARTAPERTURECTL,
-						aperture_order << 1);
-			pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE,
-						aperture_alloc >> 25);
-		}
+		/*
+		 * Don't enable translations just yet.  That is the next
+		 * step.  Restore the pre-suspend aperture settings.
+		 */
+		pci_write_config_dword(dev, AMD64_GARTAPERTURECTL, aperture_order << 1);
+		pci_write_config_dword(dev, AMD64_GARTAPERTUREBASE, aperture_alloc >> 25);
 	}
+}
+
+static int gart_resume(struct sys_device *dev)
+{
+	pr_info("PCI-DMA: Resuming GART IOMMU\n");
+
+	gart_fixup_northbridges(dev);
 
 	enable_gart_translations();
 
@@ -612,15 +619,14 @@ static int gart_suspend(struct sys_device *dev, pm_message_t state)
 }
 
 static struct sysdev_class gart_sysdev_class = {
-	.name = "gart",
-	.suspend = gart_suspend,
-	.resume = gart_resume,
+	.name		= "gart",
+	.suspend	= gart_suspend,
+	.resume		= gart_resume,
 
 };
 
 static struct sys_device device_gart = {
-	.id	= 0,
-	.cls	= &gart_sysdev_class,
+	.cls		= &gart_sysdev_class,
 };
 
 /*
@@ -635,7 +641,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	void *gatt;
 	int i, error;
 
-	printk(KERN_INFO "PCI-DMA: Disabling AGP.\n");
+	pr_info("PCI-DMA: Disabling AGP.\n");
+
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
 	for (i = 0; i < num_k8_northbridges; i++) {
@@ -653,6 +660,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 	}
 	if (!aper_base)
 		goto nommu;
+
 	info->aper_base = aper_base;
 	info->aper_size = aper_size >> 20;
 
@@ -675,14 +683,14 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	flush_gart();
 
-	printk(KERN_INFO "PCI-DMA: aperture base @ %x size %u KB\n",
+	pr_info("PCI-DMA: aperture base @ %x size %u KB\n",
 	       aper_base, aper_size>>10);
 
 	return 0;
 
  nommu:
 	/* Should not happen anymore */
-	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
+	pr_warning("PCI-DMA: More than 4GB of RAM and no IOMMU\n"
 	       "falling back to iommu=soft.\n");
 	return -1;
 }
@@ -744,23 +752,23 @@ int __init gart_iommu_init(void)
 	    !gart_iommu_aperture ||
 	    (no_agp && init_k8_gatt(&info) < 0)) {
 		if (max_pfn > MAX_DMA32_PFN) {
-			printk(KERN_WARNING "More than 4GB of memory "
-			       "but GART IOMMU not available.\n");
-			printk(KERN_WARNING "falling back to iommu=soft.\n");
+			pr_warning("More than 4GB of memory but GART IOMMU not available.\n");
+			pr_warning("falling back to iommu=soft.\n");
 		}
 		return 0;
 	}
 
 	/* need to map that range */
-	aper_size = info.aper_size << 20;
-	aper_base = info.aper_base;
-	end_pfn = (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+	aper_size	= info.aper_size << 20;
+	aper_base	= info.aper_base;
+	end_pfn		= (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
+
 	if (end_pfn > max_low_pfn_mapped) {
 		start_pfn = (aper_base>>PAGE_SHIFT);
 		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
 	}
 
-	printk(KERN_INFO "PCI-DMA: using GART IOMMU.\n");
+	pr_info("PCI-DMA: using GART IOMMU.\n");
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
 	iommu_pages = iommu_size >> PAGE_SHIFT;
 
@@ -775,8 +783,7 @@ int __init gart_iommu_init(void)
 
 		ret = dma_debug_resize_entries(iommu_pages);
 		if (ret)
-			printk(KERN_DEBUG
-			       "PCI-DMA: Cannot trace all the entries\n");
+			pr_debug("PCI-DMA: Cannot trace all the entries\n");
 	}
 #endif
 
@@ -786,15 +793,14 @@ int __init gart_iommu_init(void)
 	 */
 	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
-	agp_memory_reserved = iommu_size;
-	printk(KERN_INFO
-	       "PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
+	pr_info("PCI-DMA: Reserving %luMB of IOMMU area in the AGP aperture\n",
 	       iommu_size >> 20);
 
-	iommu_start = aper_size - iommu_size;
-	iommu_bus_base = info.aper_base + iommu_start;
-	bad_dma_addr = iommu_bus_base;
-	iommu_gatt_base = agp_gatt_table + (iommu_start>>PAGE_SHIFT);
+	agp_memory_reserved	= iommu_size;
+	iommu_start		= aper_size - iommu_size;
+	iommu_bus_base		= info.aper_base + iommu_start;
+	bad_dma_addr		= iommu_bus_base;
+	iommu_gatt_base		= agp_gatt_table + (iommu_start>>PAGE_SHIFT);
 
 	/*
 	 * Unmap the IOMMU part of the GART. The alias of the page is
@@ -816,7 +822,7 @@ int __init gart_iommu_init(void)
 	 * the pages as Not-Present:
 	 */
 	wbinvd();
-	
+
 	/*
 	 * Now all caches are flushed and we can safely enable
 	 * GART hardware.  Doing it early leaves the possibility
