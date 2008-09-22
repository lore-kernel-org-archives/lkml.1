Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYIVSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYIVSYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYIVSVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:48 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:31798 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYIVSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:42 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7M0BG-04-6F2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/9] x86/iommu: add necessary types for stackable dma_ops
Date: Mon, 22 Sep 2008 20:21:13 +0200
Message-ID: <1222107681-8185-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0243 (UTC) FILETIME=[036BFAB0:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the x86 dma_ops structure so that we can queue it
into a list. It also adds a device_supported callback. It can be used to
find out if a registered dma_ops implementation can handle a given
device. Further it adds an enum with dma_ops implementation types
possible in the future.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-x86/dma-mapping.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index f408e6d..59d1101 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -17,6 +17,8 @@ extern struct device x86_dma_fallback_dev;
 extern int panic_on_overflow;
 
 struct dma_mapping_ops {
+	struct		list_head list; /* for stacking dma_ops */
+
 	int             (*mapping_error)(struct device *dev,
 					 dma_addr_t dma_addr);
 	void*           (*alloc_coherent)(struct device *dev, size_t size,
@@ -51,9 +53,33 @@ struct dma_mapping_ops {
 				struct scatterlist *sg, int nents,
 				int direction);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
+	int		(*device_supported)(struct device *hwdev);
 	int		is_phys;
 };
 
+/*
+ * This are the supported types of dma_ops implementations on x86. The
+ * different types mean different priority:
+ *
+ *   DMA_OPS_TYPE_PV   - paravirtualized dma_ops implementation
+ *   DMA_OPS_TYPE_HW   - dma_ops implementation using some kind of hardware
+ *                       support
+ *   DMA_OPS_TYPE_SOFT - a software only dma_ops implementation
+ *
+ * When a device issues its first request to the DMA layer the available
+ * implementations are asked if they support the device by calling the specific
+ * dma_supported callback. The implementations are checked in order, first the
+ * DMA_OPS_TYPE_PV, then the DMA_OPS_TYPE_HW and at the end the
+ * DMA_OPS_TYPE_SOFT implementations. Within the implementation types they are
+ * called in registration order.
+ */
+enum dma_ops_driver_type {
+	DMA_OPS_TYPE_PV,
+	DMA_OPS_TYPE_HW,
+	DMA_OPS_TYPE_SOFT,
+	DMA_OPS_TYPE_MAX,
+};
+
 extern struct dma_mapping_ops *dma_ops;
 
 static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
-- 
1.5.6.4


