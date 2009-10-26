Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZJZX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZJZX3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZJZX3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:17 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:34715 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZJZX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:29:13 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 3/5] intel-iommu: Use max_pfn to determine whether a device
	can passthrough
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:25:09 -0600
Message-ID: <20091026232508.9646.19296.stgit@nehalem.aw>
In-Reply-To: <20091026232401.9646.90540.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A dma_mask that's greater than 32-bit does not imply the device
can DMA anywhere in physical memory.

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 drivers/pci/intel-iommu.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 40be49a..19f10ae 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -39,6 +39,7 @@
 #include <linux/sysdev.h>
 #include <linux/tboot.h>
 #include <linux/dmi.h>
+#include <linux/bootmem.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 #include "pci.h"
@@ -2196,7 +2197,8 @@ static int iommu_should_identity_map(struct pci_dev *pdev, int startup)
 	 * take them out of the 1:1 domain later.
 	 */
 	if (!startup)
-		return pdev->dma_mask > DMA_BIT_MASK(32);
+		return (pdev->dma_mask & (max_pfn << PAGE_SHIFT)) ==
+						(max_pfn << PAGE_SHIFT);
 
 	return 1;
 }
@@ -2537,11 +2539,12 @@ static int iommu_no_mapping(struct device *dev)
 			return 1;
 		else {
 			/*
-			 * 32 bit DMA is removed from si_domain and fall back
-			 * to non-identity mapping.
+			 * Devices that cannot support identity mapping
+			 * are removed from si_domain and fall back to
+			 * non-identity mapping.
 			 */
 			domain_remove_one_dev_info(si_domain, pdev);
-			printk(KERN_INFO "32bit %s uses non-identity mapping\n",
+			printk(KERN_INFO "%s uses non-identity mapping\n",
 			       pci_name(pdev));
 			return 0;
 		}

