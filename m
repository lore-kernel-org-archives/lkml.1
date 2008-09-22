Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYIVSXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYIVSXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYIVSVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:21:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:37050 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYIVSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:21:39 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0K7M0BJ-04-6F9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org
CC: David Woodhouse <dwmw2@infradead.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Date: Mon, 22 Sep 2008 20:21:21 +0200
Message-ID: <1222107681-8185-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Sep 2008 18:21:21.0394 (UTC) FILETIME=[03830520:01C91CE0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables stackable dma_ops on x86. To do this, it also enables
the per-device dma_ops on i386.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-dma.c     |   26 ++++++++++++++++++++++++++
 include/asm-x86/device.h      |    6 +++---
 include/asm-x86/dma-mapping.h |   14 +++++++-------
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b990fb6..2e517c2 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -82,6 +82,32 @@ void x86_register_dma_ops(struct dma_mapping_ops *ops,
 	write_unlock_irqrestore(&dma_ops_list_lock, flags);
 }
 
+struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev)
+{
+	int i;
+	unsigned long flags;
+	struct dma_mapping_ops *entry, *ops = NULL;
+
+	read_lock_irqsave(&dma_ops_list_lock, flags);
+
+	for (i = 0; i < DMA_OPS_TYPE_MAX; ++i)
+		list_for_each_entry(entry, &dma_ops_list[i], list) {
+			if (!entry->device_supported)
+				continue;
+			if (entry->device_supported(dev)) {
+				ops = entry;
+				goto out;
+			}
+		}
+out:
+	read_unlock_irqrestore(&dma_ops_list_lock, flags);
+
+	BUG_ON(ops == NULL);
+
+	return ops;
+}
+EXPORT_SYMBOL(find_dma_ops_for_device);
+
 int dma_set_mask(struct device *dev, u64 mask)
 {
 	if (!dev->dma_mask || !dma_supported(dev, mask))
diff --git a/include/asm-x86/device.h b/include/asm-x86/device.h
index 3c034f4..9ed12e3 100644
--- a/include/asm-x86/device.h
+++ b/include/asm-x86/device.h
@@ -5,9 +5,9 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
-#ifdef CONFIG_X86_64
-struct dma_mapping_ops *dma_ops;
-#endif
+
+	struct dma_mapping_ops *dma_ops;
+
 #ifdef CONFIG_DMAR
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 128786b..83d6d7f 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -82,19 +82,19 @@ enum dma_ops_driver_type {
 
 extern void x86_register_dma_ops(struct dma_mapping_ops *ops,
 				 enum dma_ops_driver_type type);
+extern struct dma_mapping_ops *find_dma_ops_for_device(struct device *dev);
 
 extern struct dma_mapping_ops *dma_ops;
 
 static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 {
-#ifdef CONFIG_X86_32
-	return dma_ops;
-#else
-	if (unlikely(!dev) || !dev->archdata.dma_ops)
+	if (unlikely(!dev))
 		return dma_ops;
-	else
-		return dev->archdata.dma_ops;
-#endif
+
+	if (unlikely(!dev->archdata.dma_ops))
+		dev->archdata.dma_ops = find_dma_ops_for_device(dev);
+
+	return dev->archdata.dma_ops;
 }
 
 /* Make sure we keep the same behaviour */
-- 
1.5.6.4


