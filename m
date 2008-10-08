Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbYJHViI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbYJHViI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYJHVgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:36:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:10731 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbYJHVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,380,1220252400"; 
   d="scan'208";a="624900634"
Message-Id: <20081008210526.258371000@linux-os.sc.intel.com>
References: <20081008210101.487661000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 08 Oct 2008 14:01:05 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, youquan.song@intel.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 4/4] tip, dmar: remove the quirk which disables dma-remapping when intr-remapping enabled
Content-Disposition: inline; filename=enable_dmar.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Youquan Song <youquan.song@intel.com>
Subject: remove the quirk which disables dma-remapping when intr-remapping enabled

Now that we have DMA-remapping support for queued invalidation, we
can enable both DMA-remapping and interrupt-remapping at the same time.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/dmar.c
===================================================================
--- tip.orig/drivers/pci/dmar.c	2008-10-08 09:49:30.000000000 -0700
+++ tip/drivers/pci/dmar.c	2008-10-08 10:13:36.000000000 -0700
@@ -462,39 +462,22 @@
 
 	ret = dmar_table_detect();
 
-#ifdef CONFIG_DMAR
 	{
+#ifdef CONFIG_INTR_REMAP
 		struct acpi_table_dmar *dmar;
-		/*
-		 * for now we will disable dma-remapping when interrupt
-		 * remapping is enabled.
-		 * When support for queued invalidation for IOTLB invalidation
-		 * is added, we will not need this any more.
-		 */
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
-		if (ret && cpu_has_x2apic && dmar->flags & 0x1) {
+		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
 			printk(KERN_INFO
 			       "Queued invalidation will be enabled to support "
 			       "x2apic and Intr-remapping.\n");
-			printk(KERN_INFO
-			       "Disabling IOMMU detection, because of missing "
-			       "queued invalidation support for IOTLB "
-			       "invalidation\n");
-			printk(KERN_INFO
-			       "Use \"nox2apic\", if you want to use Intel "
-			       " IOMMU for DMA-remapping and don't care about "
-			       " x2apic support\n");
-
-			dmar_disabled = 1;
-			goto end;
-		}
+#endif
 
+#ifdef CONFIG_DMAR
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 		    !dmar_disabled)
 			iommu_detected = 1;
-	}
-end:
 #endif
+	}
 	if (dmar_tbl)
 		early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 

-- 

