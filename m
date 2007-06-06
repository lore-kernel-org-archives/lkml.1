Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbXFFTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbXFFTSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934501AbXFFTQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 15:16:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:18125 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355AbXFFTQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 15:16:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="253987303"
Message-Id: <20070606190042.930671000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 06 Jun 2007 11:57:05 -0700
From: anil.s.keshavamurthy@intel.com
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com, davem@davemloft.net
Subject: [Intel-IOMMU 07/10] Intel iommu cmdline option - forcedac
Content-Disposition: inline; filename=dmar_forcedac.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Introduce intel_iommu=forcedac commandline option.
This option is helpful to verify the pci device capability
of handling physical dma'able address greater than 4G.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/pci/intel-iommu.c           |    6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc3/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/kernel-parameters.txt	2007-06-04 12:40:29.000000000 -0700
+++ linux-2.6.22-rc3/Documentation/kernel-parameters.txt	2007-06-04 12:40:41.000000000 -0700
@@ -785,6 +785,13 @@
 			bypassed by not enabling DMAR with this option. In
 			this case, gfx device will use physical address for
 			DMA.
+		forcedac
+			With this option iommu will not optimize to look
+			for io virtual address below 32 bit forcing dual
+			address cycle on pci bus for cards supporting greater
+			than 32 bit addressing. The default is to look
+			for translation below 32 bit and if not available
+			then look in the higher range.
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
Index: linux-2.6.22-rc3/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc3.orig/drivers/pci/intel-iommu.c	2007-06-04 12:40:29.000000000 -0700
+++ linux-2.6.22-rc3/drivers/pci/intel-iommu.c	2007-06-04 12:40:41.000000000 -0700
@@ -53,6 +53,7 @@
 
 static int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
+static int dmar_forcedac = 0;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -69,6 +70,9 @@
 		} else if (!strncmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
 			printk(KERN_INFO"Intel-IOMMU: disable GFX device mapping\n");
+ 		} else if (!strncmp(str, "forcedac", 8)) {
+			printk (KERN_INFO"Intel-IOMMU: Enabling DAC for PCI supporting > 32Bit DMA\n");
+			dmar_forcedac = 1;
 		}
 
 		str += strcspn(str, ",");
@@ -1500,7 +1504,7 @@
 
 	start_addr = IOVA_START_ADDR;
 
-	if (pdev->dma_mask <= DMA_32BIT_MASK) {
+	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
 		iova = iommu_alloc_iova(domain, addr, size, start_addr,
 			pdev->dma_mask);
 	} else  {

-- 
