Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYIVSWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYIVSWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYIVSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:36 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36628 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYIVSVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:34 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7M0BG-03-3J8-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] x86/iommu: add stackable dma_ops registration interface
Date: Mon, 22 Sep 2008 20:21:14 +0200
Message-ID: <1222107681-8185-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0254 (UTC) FILETIME=[036DA860:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the function x86_register_dma_ops which drivers can use
to register their specific dma_ops implementations. The patch also adds
the data structures necessary for registration and the initializtion of
them.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c     |   31 +++++++++++++++++++++++++++++++
 include/asm-x86/dma-mapping.h |    3 +++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d2f2c01..c783b73 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -47,6 +47,11 @@ EXPORT_SYMBOL(iommu_bio_merge);
 dma_addr_t bad_dma_address __read_mostly = 0;
 EXPORT_SYMBOL(bad_dma_address);
 
+/* The lists for stacking dma_ops and its lock */
+static DEFINE_RWLOCK(dma_ops_list_lock);
+
+static struct list_head dma_ops_list[DMA_OPS_TYPE_MAX];
+
 /* Dummy device used for NULL arguments (normally ISA). Better would
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to older i386. */
@@ -57,6 +62,26 @@ struct device x86_dma_fallback_dev = {
 };
 EXPORT_SYMBOL(x86_dma_fallback_dev);
 
+static void __init init_dma_ops_list(void)
+{
+	int i;
+
+	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
+		INIT_LIST_HEAD(&dma_ops_list[i]);
+}
+
+void x86_register_dma_ops(struct dma_mapping_ops *ops,
+			  enum dma_ops_driver_type type)
+{
+	unsigned long flags;
+
+	BUG_ON(type < DMA_OPS_TYPE_PV || type >= DMA_OPS_TYPE_MAX);
+
+	write_lock_irqsave(&dma_ops_list_lock, flags);
+	list_add_tail(&ops->list, &dma_ops_list[type]);
+	write_unlock_irqrestore(&dma_ops_list_lock, flags);
+}
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
@@ -257,6 +282,12 @@ EXPORT_SYMBOL(dma_supported);
 
 static int __init pci_iommu_init(void)
 {
+	/*
+	 * initialize dma_ops_list so that drivers can register their
+	 * implementations
+	 */
+	init_dma_ops_list();
+
 	calgary_iommu_init();
 
 	intel_iommu_init();
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 59d1101..128786b 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -80,6 +80,9 @@ enum dma_ops_driver_type {
 	DMA_OPS_TYPE_MAX,
 };
 
+extern void x86_register_dma_ops(struct dma_mapping_ops *ops,
+				 enum dma_ops_driver_type type);
+
 extern struct dma_mapping_ops *dma_ops;
 
 static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
-- 
1.5.6.4


