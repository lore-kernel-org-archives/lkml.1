Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYD2Kh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYD2Kh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbYD2Khe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:37:34 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:10891
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbYD2Khc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:37:32 -0400
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: virtualization@lists.linux-foundation.org, muli@il.ibm.com,
       BENAMI@il.ibm.com, gcosta@redhat.com, chrisw@redhat.com,
       dor.laor@qumranet.com, allen.m.kay@intel.com, avi@qumranet.com,
       linux-kernel@vger.kernel.org, Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH] x86 DMA: Handle devices assigned to the guest by the host
Date: Tue, 29 Apr 2008 13:37:29 +0300
Message-Id: <1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_alloc_coherent() doesn't call dma_ops->alloc_coherent in case no IOMMU
translations are necessary. However, if the device doing the DMA is a
physical device assigned to the guest OS by the host, we need to map
all the DMA addresses to the host machine addresses. This is done via
hypercalls to the host.

In KVM, with pci passthrough support, we can assign actual devices to the
guest OS which need this functionality.

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 arch/x86/kernel/pci-dma.c     |   11 +++++++++++
 include/asm-x86/dma-mapping.h |    2 ++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 388b113..678cafb 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -443,6 +443,17 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		memset(memory, 0, size);
 		if (!mmu) {
 			*dma_handle = bus;
+			if (unlikely(dma_ops->is_pv_device) &&
+			    unlikely(dma_ops->is_pv_device(dev, dev->bus_id))) {
+				void *r;
+				r = dma_ops->alloc_coherent(dev, size,
+							    dma_handle, gfp);
+				if (r == NULL) {
+					free_pages((unsigned long)memory,
+						   get_order(size));
+					memory = NULL;
+				}
+			}
 			return memory;
 		}
 	}
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..b9c6a39 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -55,6 +55,8 @@ struct dma_mapping_ops {
 				int direction);
 	int             (*dma_supported)(struct device *hwdev, u64 mask);
 	int		is_phys;
+	/* Is this a physical device in a paravirtualized guest? */
+	int		(*is_pv_device)(struct device *hwdev, const char *name);
 };
 
 extern const struct dma_mapping_ops *dma_ops;
-- 
1.5.4.3

