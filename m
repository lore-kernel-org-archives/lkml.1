Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYHSOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYHSOfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYHSOdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:33:12 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:55685 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYHSOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:33:07 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0K5UR2K-03-AJ2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/8] x86: add alloc_coherent dma_ops callback to GART driver
Date: Tue, 19 Aug 2008 16:32:39 +0200
Message-ID: <1219156366-32498-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Aug 2008 14:32:46.0515 (UTC) FILETIME=[72C31030:01C90208]
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
index 4d8efb0..44a75a6 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -506,6 +506,26 @@ error:
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
@@ -708,6 +728,7 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.sync_sg_for_device		= NULL,
 	.map_sg				= gart_map_sg,
 	.unmap_sg			= gart_unmap_sg,
+	.alloc_coherent			= gart_alloc_coherent,
 };
 
 void gart_iommu_shutdown(void)
-- 
1.5.3.7


