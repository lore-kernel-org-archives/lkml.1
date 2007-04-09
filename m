Return-Path: <linux-kernel-owner+w=401wt.eu-S965983AbXDIWtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983AbXDIWtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDIWsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:48:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:49150 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXDIWsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:48:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,388,1170662400"; 
   d="scan'208"; a="210638798:sNHT23782437"
Message-Id: <20070409215723.795646000@intel.com>
References: <20070409215552.221374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 09 Apr 2007 14:55:56 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [patch 4/8] [Intel IOMMU] Supporting Zero Length Reads in Intel IOMMU.
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

Index: linux-2.6.21-rc5/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pci/intel-iommu.c	2007-04-09 03:05:25.000000000 -0700
+++ linux-2.6.21-rc5/drivers/pci/intel-iommu.c	2007-04-09 03:05:32.000000000 -0700
@@ -84,7 +84,7 @@
 	struct sys_device sysdev;
 };
 
-static int dmar_disabled;
+static int dmar_disabled, dmar_force_rw;
 
 static char *get_fault_reason(u8 fault_reason)
 {
@@ -102,6 +102,9 @@
 		if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
 			printk(KERN_INFO"Intel-IOMMU: disabled\n");
+		} else if (!strncmp(str, "forcerw", 7)) {
+			dmar_force_rw = 1;
+			printk(KERN_INFO"Intel-IOMMU: force R/W for W/O mapping\n");
 		}
 		str += strcspn(str, ",");
 		while (*str == ',')
@@ -1668,7 +1671,12 @@
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
Index: linux-2.6.21-rc5/include/linux/intel-iommu.h
===================================================================
--- linux-2.6.21-rc5.orig/include/linux/intel-iommu.h	2007-04-09 03:05:25.000000000 -0700
+++ linux-2.6.21-rc5/include/linux/intel-iommu.h	2007-04-09 03:05:32.000000000 -0700
@@ -79,6 +79,7 @@
 #define cap_max_fault_reg_offset(c) \
 	(cap_fault_reg_offset(c) + cap_num_fault_regs(c) * 16)
 
+#define cap_zlr(c)		(((c) >> 22) & 1)
 #define cap_isoch(c)		(((c) >> 23) & 1)
 #define cap_mgaw(c)		((((c) >> 16) & 0x3f) + 1)
 #define cap_sagaw(c)		(((c) >> 8) & 0x1f)

-- 
