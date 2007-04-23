Return-Path: <linux-kernel-owner+w=401wt.eu-S1161812AbXDXPI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161812AbXDXPI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161797AbXDXPI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:08:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:39941 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161801AbXDXPIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="233076172:sNHT22396766"
Message-Id: <20070423164957.130714000@linux.intel.com>
References: <20070423163837.447443000@linux.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 09:38:41 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 4/8] Supporting Zero Length Reads in Intel IOMMU.
Content-Disposition: inline; filename=rw-workaround.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PCI specs permit zero length reads (ZLR) even if the mapping for that region 
is write only. Support for this feature is indicated by the presence of a bit 
in the DMAR capability. If a particular DMAR does not support this capability
we map write-only regions as read-write.

This option can also provides a workaround for some drivers that request
a write-only mapping when they really should request a read-write.
(We ran into one such case in eepro100.c in handling rx_ring_dma)

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
----------------------------------
 drivers/pci/intel-iommu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: 2.6.21-rc6/drivers/pci/intel-iommu.c
===================================================================
--- 2.6.21-rc6.orig/drivers/pci/intel-iommu.c	2007-04-18 09:04:56.000000000 +0800
+++ 2.6.21-rc6/drivers/pci/intel-iommu.c	2007-04-18 09:04:59.000000000 +0800
@@ -84,7 +84,7 @@ struct iommu {
 	struct sys_device sysdev;
 };
 
-static int dmar_disabled;
+static int dmar_disabled, dmar_force_rw;
 
 static char *get_fault_reason(u8 fault_reason)
 {
@@ -102,6 +102,9 @@ static int __init intel_iommu_setup(char
 		if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
 			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+		} else if (!strncmp(str, "forcerw", 7)) {
+			dmar_force_rw = 1;
+			printk(KERN_INFO"Intel-IOMMU: force R/W for W/O mapping\n");
 		}
 		str += strcspn(str, ",");
 		while (*str == ',')
@@ -1720,7 +1723,12 @@ static dma_addr_t __intel_map_single(str
 			goto error;
 	}
 
-	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
+	/*
+	 * Check if DMAR supports zero-length reads on write only
+	 * mappings..
+	 */
+	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL || \
+			!cap_zlr(domain->iommu->cap) || dmar_force_rw)
 		prot |= DMA_PTE_READ;
 	if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)
 		prot |= DMA_PTE_WRITE;
Index: 2.6.21-rc6/include/linux/intel-iommu.h
===================================================================
--- 2.6.21-rc6.orig/include/linux/intel-iommu.h	2007-04-18 09:04:56.000000000 +0800
+++ 2.6.21-rc6/include/linux/intel-iommu.h	2007-04-18 09:04:59.000000000 +0800
@@ -79,6 +79,7 @@
 #define cap_max_fault_reg_offset(c) \
 	(cap_fault_reg_offset(c) + cap_num_fault_regs(c) * 16)
 
+#define cap_zlr(c)		(((c) >> 22) & 1)
 #define cap_isoch(c)		(((c) >> 23) & 1)
 #define cap_mgaw(c)		((((c) >> 16) & 0x3f) + 1)
 #define cap_sagaw(c)		(((c) >> 8) & 0x1f)

-- 
