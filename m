Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYIVSWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYIVSWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYIVSVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:42 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:50803 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYIVSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:37 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7M0BH-04-6F6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] x86/iommu: change GART to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:17 +0200
Message-ID: <1222107681-8185-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0336 (UTC) FILETIME=[037A2B80:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 508ef47..c5891c9 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -533,6 +533,12 @@ gart_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static int gart_device_supported(struct device *dev)
+{
+	/* GART remaps _everything_ (including CPU memory accesses) */
+	return 1;
+}
+
 static int no_agp;
 
 static __init unsigned long check_iommu_size(unsigned long aper, u64 aper_size)
@@ -736,6 +742,7 @@ static struct dma_mapping_ops gart_dma_ops = {
 	.unmap_sg			= gart_unmap_sg,
 	.alloc_coherent			= gart_alloc_coherent,
 	.free_coherent			= gart_free_coherent,
+	.device_supported		= gart_device_supported,
 };
 
 void gart_iommu_shutdown(void)
@@ -874,6 +881,8 @@ void __init gart_iommu_init(void)
 		iommu_gatt_base[i] = gart_unmapped_entry;
 
 	flush_gart();
+
+	x86_register_dma_ops(&gart_dma_ops, DMA_OPS_TYPE_HW);
 	dma_ops = &gart_dma_ops;
 }
 
-- 
1.5.6.4


