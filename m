Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYHLP1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYHLP1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbYHLPZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:25:31 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47218 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175AbYHLPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:25:29 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5HUTH-03-1KX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/7] x86: add alloc_coherent dma_ops callback to GART driver
Date: Tue, 12 Aug 2008 17:24:11 +0200
Message-ID: <1218554657-16070-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 12 Aug 2008 15:24:18.0079 (UTC) FILETIME=[7C960AF0:01C8FC8F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index cdab678..55cc388 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -499,6 +499,26 @@ error:
 	return 0;
 }
 
+/* allocate and map a coherent mapping */
+static void *
+gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
+		    gfp_t flag)
+{
+	void *vaddr;
+
+	vaddr = (void *)__get_free_pages(flag, get_order(size));
+	if (!vaddr)
+		return NULL;
+
+	*dma_addr = gart_map_single(dev, __pa(vaddr), size, DMA_BIDIRECTIONAL);
+	if (*dma_addr != bad_dma_address)
+		return vaddr;
+
+	free_pages((unsigned long)vaddr, get_order(size));
+
+	return NULL;
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -701,6 +721,7 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.sync_sg_for_device		= NULL,
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+	.alloc_coherent			= gart_alloc_coherent,
 };
 
 void gart_iommu_shutdown(void)
-- 
1.5.3.7


