Return-Path: <linux-kernel-owner+w=401wt.eu-S1761030AbYDHQel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761030AbYDHQel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbYDHQ33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:29:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228AbYDHQ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:29:28 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 26/28] x86: return conditional to mmu
Date: Tue,  8 Apr 2008 13:21:08 -0300
Message-Id: <12076718382647-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12076716702129-git-send-email-gcosta@redhat.com>
References: <12076716702129-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just return our allocation if we don't have an mmu. For i386, where this patch
is being applied, we never have. So our goal is just to have the code to look like
x86_64's.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/pci-dma_32.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma_32.c b/arch/x86/kernel/pci-dma_32.c
index 5450bd1..f134de3 100644
--- a/arch/x86/kernel/pci-dma_32.c
+++ b/arch/x86/kernel/pci-dma_32.c
@@ -116,12 +116,42 @@ again:
 				gfp = (gfp & ~GFP_DMA32) | GFP_DMA;
 				goto again;
 			}
+
+			/* Let low level make its own zone decisions */
+			gfp &= ~(GFP_DMA32|GFP_DMA);
+
+			if (dma_ops->alloc_coherent)
+				return dma_ops->alloc_coherent(dev, size,
+							   dma_handle, gfp);
+			return NULL;
+
 		}
 		memset(ret, 0, size);
-		*dma_handle = bus;
+		if (!mmu) {
+			*dma_handle = bus;
+			return ret;
+		}
+	}
+
+	if (dma_ops->alloc_coherent) {
+		free_pages((unsigned long)ret, get_order(size));
+		gfp &= ~(GFP_DMA|GFP_DMA32);
+		return dma_ops->alloc_coherent(dev, size, dma_handle, gfp);
+	}
+
+	if (dma_ops->map_simple) {
+		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(ret),
+					      size,
+					      PCI_DMA_BIDIRECTIONAL);
+		if (*dma_handle != bad_dma_address)
+			return ret;
 	}
 
-	return ret;
+	if (panic_on_overflow)
+		panic("dma_alloc_coherent: IOMMU overflow by %lu bytes\n",
+		      (unsigned long)size);
+	free_pages((unsigned long)ret, get_order(size));
+	return NULL;
 }
 EXPORT_SYMBOL(dma_alloc_coherent);
 
-- 
1.5.0.6

