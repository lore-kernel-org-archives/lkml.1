Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYJPXr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYJPXr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYJPXp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:45:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:41674 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbYJPXp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:45:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,427,1220252400"; 
   d="scan'208";a="61107942"
Message-Id: <20081016234118.687527000@linux-os.sc.intel.com>
References: <20081016233153.093366000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 16 Oct 2008 16:31:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, jbarnes@virtuousgeek.org
Cc: youquan.song@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 4/4] dmar: remove the quirk which disables dma-remapping when intr-remapping enabled
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

Index: linux-2.6.git/drivers/pci/dmar.c
===================================================================
--- linux-2.6.git.orig/drivers/pci/dmar.c	2008-10-16 15:53:31.000000000 -0700
+++ linux-2.6.git/drivers/pci/dmar.c	2008-10-16 15:55:44.000000000 -0700
@@ -455,8 +455,8 @@
 
 	ret = early_dmar_detect();
 
-#ifdef CONFIG_DMAR
 	{
+#ifdef CONFIG_INTR_REMAP
 		struct acpi_table_dmar *dmar;
 		/*
 		 * for now we will disable dma-remapping when interrupt
@@ -465,28 +465,18 @@
 		 * is added, we will not need this any more.
 		 */
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
-			return;
-		}
+#endif
 
+#ifdef CONFIG_DMAR
 		if (ret && !no_iommu && !iommu_detected && !swiotlb &&
 		    !dmar_disabled)
 			iommu_detected = 1;
-	}
 #endif
+	}
 }
 
 

-- 

