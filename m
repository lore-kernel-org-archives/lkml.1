Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbXKGOWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbXKGOWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbXKGOUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:20:46 -0500
Received: from il.qumranet.com ([82.166.9.18]:50642 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbXKGOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:20:42 -0500
From: Amit Shah <amit.shah@qumranet.com>
To: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 5/8] KVM: PVDMA: Update dma_alloc_coherent to make it paravirt-aware
Date: Wed,  7 Nov 2007 16:21:06 +0200
Message-Id: <1194445269469-git-send-email-amit.shah@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1194445269859-git-send-email-amit.shah@qumranet.com>
References: <1194445269752-git-send-email-amit.shah@qumranet.com>
 <11944452691714-git-send-email-amit.shah@qumranet.com>
 <11944452692774-git-send-email-amit.shah@qumranet.com>
 <11944452694052-git-send-email-amit.shah@qumranet.com>
 <1194445269859-git-send-email-amit.shah@qumranet.com>
Message-Id: <e2f5f0c08d08cf66a39c8b452410078617e611f7.1194445109.git.amit.shah@qumranet.com>
In-Reply-To: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
References: <d1c72ce6e3a0e73c18993c3f066d1350b147f726.1194445109.git.amit.shah@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Of all the DMA calls, only dma_alloc_coherent might not actually
call dma_ops->alloc_coherent. We make sure that gets called
if the device that's being worked on is a PV device

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
---
 arch/x86/kernel/pci-dma_64.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_64.c b/arch/x86/kernel/pci-dma_64.c
index aa805b1..d4b1713 100644
--- a/arch/x86/kernel/pci-dma_64.c
+++ b/arch/x86/kernel/pci-dma_64.c
@@ -11,6 +11,7 @@
 #include <asm/io.h>
 #include <asm/gart.h>
 #include <asm/calgary.h>
+#include <linux/kvm_para.h>
 
 int iommu_merge __read_mostly = 1;
 EXPORT_SYMBOL(iommu_merge);
@@ -134,6 +135,18 @@ dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
 		memset(memory, 0, size);
 		if (!mmu) {
 			*dma_handle = virt_to_bus(memory);
+			if (unlikely(dma_ops->is_pv_device)
+			    && unlikely(dma_ops->is_pv_device(dev, dev->bus_id))) {
+				void *r;
+				r = dma_ops->alloc_coherent(dev, size,
+							    dma_handle,
+							    gfp);
+				if (r == NULL) {
+					free_pages((unsigned long)memory,
+						   get_order(size));
+					memory = NULL;
+				}
+			}
 			return memory;
 		}
 	}
-- 
1.5.3

