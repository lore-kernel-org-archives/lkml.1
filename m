Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYIVSWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYIVSWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYIVSVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:37 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36717 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYIVSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:35 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7M0BG-04-6F1-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] x86/iommu: change PCI-NOMMU to use dma_ops register interface
Date: Mon, 22 Sep 2008 20:21:15 +0200
Message-ID: <1222107681-8185-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0301 (UTC) FILETIME=[0374D450:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-nommu.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index 1c1c98a..0cbecb9 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -115,16 +115,28 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
 	free_pages((unsigned long)vaddr, get_order(size));
 }
 
+static int nommu_device_supported(struct device *dev)
+{
+	return 1;
+}
+
 struct dma_mapping_ops nommu_dma_ops = {
 	.alloc_coherent = nommu_alloc_coherent,
 	.free_coherent = nommu_free_coherent,
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
+	.device_supported = nommu_device_supported,
 	.is_phys = 1,
 };
 
 void __init no_iommu_init(void)
 {
+	/*
+	 * we always want nommu to be the last fallback if no
+	 * other dma_ops implementation feels responsible
+	 */
+	x86_register_dma_ops(&nommu_dma_ops, DMA_OPS_TYPE_SOFT);
+
 	if (dma_ops)
 		return;
 
-- 
1.5.6.4


