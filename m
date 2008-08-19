Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbYHSOey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbYHSOey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYHSOdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:41818 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYHSOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:07 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2J-04-SOR-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/8] x86: add free_coherent dma_ops callback to Calgary IOMMU driver
Date: Tue, 19 Aug 2008 16:32:41 +0200
Message-ID: <1219156366-32498-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0567 (UTC) FILETIME=[72CAFF70:01C90208]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86/kernel/pci-calgary_64.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 8e41d42..ea6a0c8 100644
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


