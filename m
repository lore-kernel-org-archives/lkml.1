Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYIHJMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYIHJMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYIHJMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:12:19 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48089 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYIHJMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:12:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, joerg.roedel@amd.com, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 1/5] ia64: dma_alloc_coherent always use GFP_DMA
Date: Mon,  8 Sep 2008 18:10:10 +0900
Message-Id: <1220865014-1169-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220865014-1169-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes dma_alloc_coherent use GFP_DMA at all times. This is
necessary for swiotlb, which requires the callers to set up the gfp
flags properly.

swiotlb_alloc_coherent tries to allocate pages with the gfp flags. If
the allocated memory isn't fit for dev->coherent_dma_mask,
swiotlb_alloc_coherent reserves some of the swiotlb memory area, which
is precious resource. So the callers need to set up the gfp flags
properly.

This patch means that other IA64 IOMMUs' dma_alloc_coherent also use
GFP_DMA. These IOMMUs (e.g. SBA IOMMU) don't need GFP_DMA since they
can map a memory to any address. But IA64's GFP_DMA is large,
generally drivers allocate small memory with dma_alloc_coherent only
at startup. So I chose the simplest way to set up the gfp flags for
swiotlb.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/include/asm/dma-mapping.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index 9f0df9b..06ff1ba 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -8,7 +8,9 @@
 #include <asm/machvec.h>
 #include <linux/scatterlist.h>
 
-#define dma_alloc_coherent	platform_dma_alloc_coherent
+#define dma_alloc_coherent(dev, size, handle, gfp)	\
+	platform_dma_alloc_coherent(dev, size, handle, (gfp) | GFP_DMA)
+
 /* coherent mem. is cheap */
 static inline void *
 dma_alloc_noncoherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
-- 
1.5.5.GIT

