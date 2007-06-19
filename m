Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbXFSWTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbXFSWTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbXFSWSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:18:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:47200 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXFSWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:18:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,439,1175497200"; 
   d="scan'208";a="258836661"
Message-Id: <20070619213808.876799000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Jun 2007 14:37:08 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: ak@suse.de, gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, davem@davemloft.net,
       clameter@sgi.com, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Subject: [Intel IOMMU 07/10] Intel iommu cmdline option - forcedac
Content-Disposition: inline; filename=dmar_forcedac.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Introduce intel_iommu=forcedac commandline option.
This option is helpful to verify the pci device capability
of handling physical dma'able address greater than 4G.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/pci/intel-iommu.c           |    7 ++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.22-rc4-mm2.orig/Documentation/kernel-parameters.txt	2007-06-18 15:45:46.000000000 -0700
+++ linux-2.6.22-rc4-mm2/Documentation/kernel-parameters.txt	2007-06-18 15:45:46.000000000 -0700
@@ -788,6 +788,13 @@
 			bypassed by not enabling DMAR with this option. In
 			this case, gfx device will use physical address for
 			DMA.
+		forcedac [x86_64]
+			With this option iommu will not optimize to look
+			for io virtual address below 32 bit forcing dual
+			address cycle on pci bus for cards supporting greater
+			than 32 bit addressing. The default is to look
+			for translation below 32 bit and if not available
+			then look in the higher range.
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
Index: linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/intel-iommu.c	2007-06-18 15:45:46.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/intel-iommu.c	2007-06-19 13:09:06.000000000 -0700
@@ -53,6 +53,7 @@
 
 static int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
+static int dmar_forcedac;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -70,6 +71,10 @@
 			dmar_map_gfx = 0;
 			printk(KERN_INFO
 				"Intel-IOMMU: disable GFX device mapping\n");
+		} else if (!strncmp(str, "forcedac", 8)) {
+			printk (KERN_INFO
+				"Intel-IOMMU: Forcing DAC for PCI devices\n");
+			dmar_forcedac = 1;
 		}
 
 		str += strcspn(str, ",");
@@ -1557,7 +1562,7 @@
 
 	start_addr = IOVA_START_ADDR;
 
-	if (pdev->dma_mask <= DMA_32BIT_MASK) {
+	if ((pdev->dma_mask <= DMA_32BIT_MASK) || (dmar_forcedac)) {
 		iova = iommu_alloc_iova(domain, addr, size, start_addr,
 			pdev->dma_mask);
 	} else  {

-- 
