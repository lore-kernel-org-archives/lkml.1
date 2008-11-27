Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYK0Pl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYK0Pl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYK0PlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:41:09 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:14800 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYK0PlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:41:08 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KB00W4-04-B7P-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: avi@redhat.com, weidong.han@intel.com, mingo@redhat.com,
       dwmw2@infradead.org, amit.shah@redhat.com,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] VT-d: add domain init and destroy functions for IOMMU API
Date: Thu, 27 Nov 2008 16:40:50 +0100
Message-ID: <1227800454-9555-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
References: <1227800454-9555-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Nov 2008 15:40:54.0890 (UTC) FILETIME=[88EE94A0:01C950A6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/pci/intel-iommu.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5c8baa4..b958b6f 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -35,6 +35,7 @@
 #include <linux/mempool.h>
 #include <linux/timer.h>
 #include <linux/iova.h>
+#include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
@@ -2436,3 +2437,26 @@ u64 intel_iommu_iova_to_pfn(struct dmar_domain *domain, u64 iova)
 	return pfn >> VTD_PAGE_SHIFT;
 }
 EXPORT_SYMBOL_GPL(intel_iommu_iova_to_pfn);
+
+static int intel_iommu_domain_init(struct iommu_domain *domain,
+				   struct device *dev)
+{
+	struct dmar_domain *dmar_domain;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (!pdev)
+		return -EINVAL;
+
+	dmar_domain = intel_iommu_domain_alloc(pdev);
+	domain->priv = dmar_domain;
+
+	return 0;
+}
+
+static void intel_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct dmar_domain *dmar_domain = domain->priv;
+
+	intel_iommu_domain_exit(dmar_domain);
+	domain->priv = NULL;
+}
-- 
1.5.6.4


