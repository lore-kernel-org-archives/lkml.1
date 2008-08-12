Return-Path: <linux-kernel-owner+w=401wt.eu-S1753100AbYHLPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbYHLPZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYHLPZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:15 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:8726 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYHLPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:13 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HUTH-04-OI7-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/7] x86: add free_coherent dma_ops callback to Calgary IOMMU driver
Date: Tue, 12 Aug 2008 17:24:13 +0200
Message-ID: <1218554657-16070-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:20.0914 (UTC) FILETIME=[7E46A120:01C8FC8F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-calgary_64.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index b24f1e8..6b67446 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -510,8 +510,22 @@ error:
 	return ret;
 }
 
+static void calgary_free_coherent(struct device *dev, size_t size,
+				  void *vaddr, dma_addr_t dma_handle)
+{
+	unsigned int npages;
+	struct iommu_table *tbl = find_iommu_table(dev);
+
+	size = PAGE_ALIGN(size);
+	npages = size >> PAGE_SHIFT;
+
+	iommu_free(tbl, dma_handle, npages);
+	free_pages((unsigned long)vaddr, get_order(size));
+}
+
 static struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
+	.free_coherent = calgary_free_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
 	.map_sg = calgary_map_sg,
-- 
1.5.3.7


