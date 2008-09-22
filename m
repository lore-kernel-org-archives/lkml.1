Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYIVSWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYIVSWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbYIVSVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:33 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:30952 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYIVSVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:31 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7M0BH-03-3JB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:18 +0200
Message-ID: <1222107681-8185-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0347 (UTC) FILETIME=[037BD930:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-calgary_64.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fe7695e..e2f2f60 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -525,6 +525,15 @@ static void calgary_free_coherent(struct device *dev, size_t size,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static int calgary_device_supported(struct device *dev)
+{
+	struct iommu_table *tbl;
+
+	tbl = find_iommu_table(dev);
+
+	return translation_enabled(tbl);
+}
+
 static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.free_coherent = calgary_free_coherent,
@@ -532,6 +541,7 @@ static struct dma_mapping_ops calgary_dma_ops = {
 	.unmap_single = calgary_unmap_single,
 	.map_sg = calgary_map_sg,
 	.unmap_sg = calgary_unmap_sg,
+	.device_supported = calgary_device_supported,
 };
 
 static inline void __iomem * busno_to_bbar(unsigned char num)
@@ -1223,16 +1233,6 @@ static int __init calgary_init(void)
 			goto error;
 	} while (1);
 
-	dev = NULL;
-	for_each_pci_dev(dev) {
-		struct iommu_table *tbl;
-
-		tbl = find_iommu_table(&dev->dev);
-
-		if (translation_enabled(tbl))
-			dev->dev.archdata.dma_ops = &calgary_dma_ops;
-	}
-
 	return ret;
 
 error:
@@ -1535,6 +1535,7 @@ int __init calgary_iommu_init(void)
 
 	force_iommu = 1;
 	bad_dma_address = 0x0;
+	x86_register_dma_ops(&calgary_dma_ops, DMA_OPS_TYPE_HW);
 	/* dma_ops is set to swiotlb or nommu */
 	if (!dma_ops)
 		dma_ops = &nommu_dma_ops;
-- 
1.5.6.4


