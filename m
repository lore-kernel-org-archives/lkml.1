Return-Path: <linux-kernel-owner+w=401wt.eu-S1764250AbXJZSUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764250AbXJZSUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763689AbXJZSTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:19:39 -0400
Received: from mga06.intel.com ([134.134.136.21]:29222 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763217AbXJZSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:19:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,334,1188802800"; 
   d="scan'208";a="256343489"
Date: Fri, 26 Oct 2007 11:18:49 -0700
From: Mark Gross <mgross@linux.intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] iommu-PMEN_REG boot up support
Message-ID: <20071026181849.GA25256@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch clears the portect memory region enable bit at boot
time by default.  It also provides a kernel parrameter for disabling
this behavior and leave the PMEN_REG untouched if so wanted.

If the boot loader or platform has protected memory regions enabled at
boot time it could prevent DMA's from happening as drivers are loaded
and used.


Singed-off-by: mark gross <mgross@linux.intel.com>

--mgross


Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c	2007-10-24 09:31:32.000000000 -0700
+++ linux-2.6/drivers/pci/intel-iommu.c	2007-10-26 11:18:55.000000000 -0700
@@ -55,6 +55,7 @@
 static int dmar_disabled;
 static int __initdata dmar_map_gfx = 1;
 static int dmar_forcedac;
+static int clear_pmen_epm = 1;
 
 #define DUMMY_DEVICE_DOMAIN_INFO ((struct device_domain_info *)(-1))
 static DEFINE_SPINLOCK(device_domain_lock);
@@ -76,8 +77,14 @@
 			printk (KERN_INFO
 				"Intel-IOMMU: Forcing DAC for PCI devices\n");
 			dmar_forcedac = 1;
+		} else if (!strncmp(str, "no_epm_clear", 12)) {
+			printk(KERN_INFO
+				"Intel-IOMMU: subress clearing of Enable "
+				"Protected Memory bit\n");
+			clear_pmen_epm = 0;
 		}
 
+
 		str += strcspn(str, ",");
 		while (*str == ',')
 			str++;
@@ -692,6 +699,23 @@
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
+static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
+{
+	u32 pmen;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	pmen = readl(iommu->reg + DMAR_PMEN_REG);
+	pmen &= ~DMA_PMEN_EPM;
+	writel(pmen, iommu->reg + DMAR_PMEN_REG);
+
+	/* wait for the protected region status bit to clear */
+	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+		readl, (pmen & DMA_PMEN_PRS), pmen);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
@@ -1731,6 +1755,9 @@
 		iommu_flush_context_global(iommu, 0);
 		iommu_flush_iotlb_global(iommu, 0);
 
+		if (clear_pmen_epm)
+			iommu_disable_protect_mem_regions(iommu);
+
 		ret = iommu_enable_translation(iommu);
 		if (ret)
 			goto error;
Index: linux-2.6/drivers/pci/intel-iommu.h
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.h	2007-10-24 09:31:32.000000000 -0700
+++ linux-2.6/drivers/pci/intel-iommu.h	2007-10-26 11:11:44.000000000 -0700
@@ -126,6 +126,10 @@
 #define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
 #define DMA_TLB_MAX_SIZE (0x3f)
 
+/* PMEN_REG */
+#define DMA_PMEN_EPM (((u32)1)<<31)
+#define DMA_PMEN_PRS (((u32)1)<<0)
+
 /* GCMD_REG */
 #define DMA_GCMD_TE (((u32)1) << 31)
 #define DMA_GCMD_SRTP (((u32)1) << 30)
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt	2007-10-24 09:31:30.000000000 -0700
+++ linux-2.6/Documentation/kernel-parameters.txt	2007-10-26 11:11:44.000000000 -0700
@@ -789,6 +789,10 @@
 			than 32 bit addressing. The default is to look
 			for translation below 32 bit and if not available
 			then look in the higher range.
+		no_epm_clear
+			This will override the default of disabling protected
+			memory regions from DMA to leave the PMEM_REG settings
+			as they where set up by the boot loader / platform.
 
 	io7=		[HW] IO7 for Marvel based alpha systems
 			See comment before marvel_specify_io7 in
