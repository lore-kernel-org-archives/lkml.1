Return-Path: <linux-kernel-owner+w=401wt.eu-S1422642AbXDXPKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422642AbXDXPKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422654AbXDXPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:10:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:48777 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161799AbXDXPIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,448,1170662400"; 
   d="scan'208"; a="218705962:sNHT57742559"
Message-Id: <20070424061038.389587000@intel.com>
References: <20070424060259.426374000@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 23:03:07 -0700
From: Ashok Raj <ashok.raj@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       anil.s.keshavamurthy@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, shaohua.li@intel.com
Subject: [Intel IOMMU][patch 8/8] Preserve some Virtual Address when devices cannot address entire range.
Content-Disposition: inline; filename=iova_preserve_option.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices may not support entire 64bit DMA. In a situation where such 
devices are co-located in a shared domain, we need to ensure there is some 
address space reserved for such devices without the low addresses getting
depleted by other devices capable of handling high dma addresses.

Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Index: linux-2.6.21-rc5/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.21-rc5.orig/Documentation/kernel-parameters.txt	2007-04-17 06:02:24.000000000 -0700
+++ linux-2.6.21-rc5/Documentation/kernel-parameters.txt	2007-04-17 06:02:33.000000000 -0700
@@ -735,6 +735,11 @@
 			first 16M. The floppy disk could be modified to use
 			the DMA api's but thats a lot of pain for very small
 			gain. This option is turned on by default.
+		preserve_{1g/2g/4g/512m/256m/16m}
+			If a device is sharing a domain with other devices
+			and the device mask doesnt cover the 64bit range,
+			use this option to let the iommu code preserve some
+			virtual addr for such devices.
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
 			arch/alpha/kernel/core_marvel.c.
Index: linux-2.6.21-rc5/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/pci/intel-iommu.c	2007-04-17 06:02:24.000000000 -0700
+++ linux-2.6.21-rc5/drivers/pci/intel-iommu.c	2007-04-17 06:05:49.000000000 -0700
@@ -90,6 +90,7 @@
 static int dmar_disabled, dmar_force_rw;
 static int dmar_map_gfx = 1, dmar_no_gfx_identity_map = 1;
 static int dmar_fix_isa = 1;
+static u64 dmar_preserve_iova_mask;
 
 static char *get_fault_reason(u8 fault_reason)
 {
@@ -119,6 +120,32 @@
 		} else if (!strncmp(str, "noisamap", 8)) {
 			dmar_fix_isa = 0;
 			printk (KERN_INFO"Intel-IOMMU: Turning off 16M unity map for LPC\n");
+ 		} else if (!strncmp(str, "preserve_", 9)) {
+ 			if (!strncmp(str + 9, "4g", 2) ||
+ 			    !strncmp(str + 9, "4G", 2))
+ 				dmar_preserve_iova_mask = DMA_32BIT_MASK;
+ 			else if (!strncmp(str + 9, "2g", 2) ||
+ 				!strncmp(str + 9, "2G", 2))
+ 				dmar_preserve_iova_mask = DMA_31BIT_MASK;
+ 			else if (!strncmp(str + 9, "1g", 2) ||
+ 			         !strncmp(str + 9, "1G", 2))
+ 				dmar_preserve_iova_mask = DMA_30BIT_MASK;
+ 			else if (!strncmp(str + 9, "512m", 2) ||
+ 			         !strncmp(str + 9, "512M", 2))
+ 				dmar_preserve_iova_mask = DMA_29BIT_MASK;
+ 			else if (!strncmp(str + 9, "256m", 4) ||
+ 			         !strncmp(str + 9, "256M", 4))
+ 				dmar_preserve_iova_mask = DMA_28BIT_MASK;
+ 			else if (!strncmp(str + 9, "16m", 3) ||
+ 			         !strncmp(str + 9, "16M", 3))
+ 				dmar_preserve_iova_mask = DMA_24BIT_MASK;
+			if (dmar_preserve_iova_mask)
+				printk(KERN_INFO
+				"DMAR: Preserved IOVA mask 0x%Lx for devices "
+				"sharing domain\n", dmar_preserve_iova_mask);
+			else
+				printk(KERN_ERR"DMAR: Unsuppored preserve mask"
+					" provided");
 		}
 
 		str += strcspn(str, ",");
@@ -1723,7 +1750,6 @@
 			last_addr : IOVA_START_ADDR);
 	}
 	return last_addr;
-
 }
 #endif
 
@@ -1751,13 +1777,14 @@
 
 	/*
 	 * If the device shares a domain with other devices and the device can
-	 * handle > 4G DMA, let the device use DMA address started from 4G, so to
-	 * leave rooms for other devices
+	 * can handle higher address, leave rooms for devices that cant
+	 * address high address ranges.
 	 */
 	if ((domain->flags & DOMAIN_FLAG_MULTIPLE_DEVICES) &&
-			pdev->dma_mask > DMA_32BIT_MASK)
+ 			dmar_preserve_iova_mask &&
+ 			(pdev->dma_mask > dmar_preserve_iova_mask))
 		iova = alloc_iova(domain, addr, size,
-				DMA_32BIT_MASK + 1, pdev->dma_mask);
+ 				dmar_preserve_iova_mask + 1, pdev->dma_mask);
 	else {
 #ifndef CONFIG_IOVA_NEXT_CONTIG
 		iova = alloc_iova(domain, addr, size,

-- 
