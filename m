Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbZEGEf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbZEGEf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZEGEfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:35:42 -0400
Received: from sh.osrg.net ([192.16.179.4]:55105 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZEGEfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:35:41 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH -tip 4/5] ia64: add CONFIG_DMA_API_DEBUG support
Date: Thu,  7 May 2009 13:35:47 +0900
Message-Id: <1241670948-5818-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 13:35:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/Kconfig                   |    1 +
 arch/ia64/include/asm/dma-mapping.h |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 294a3b1..170042b 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -28,6 +28,7 @@ config IA64
 	select HAVE_DMA_ATTRS
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DMA_API_DEBUG
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
index bc462e1..3176204 100644
--- a/arch/ia64/include/asm/dma-mapping.h
+++ b/arch/ia64/include/asm/dma-mapping.h
@@ -8,6 +8,7 @@
 #include <asm/machvec.h>
 #include <linux/scatterlist.h>
 #include <asm/swiotlb.h>
+#include <linux/dma-debug.h>
 
 #define ARCH_HAS_DMA_GET_REQUIRED_MASK
 
@@ -24,13 +25,18 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *daddr, gfp_t gfp)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
-	return ops->alloc_coherent(dev, size, daddr, gfp);
+	void *caddr;
+
+	caddr = ops->alloc_coherent(dev, size, daddr, gfp);
+	debug_dma_alloc_coherent(dev, size, *daddr, caddr);
+	return caddr;
 }
 
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *caddr, dma_addr_t daddr)
 {
 	struct dma_map_ops *ops = platform_dma_get_ops(dev);
+	debug_dma_free_coherent(dev, size, caddr, daddr);
 	ops->free_coherent(dev, size, caddr, daddr);
 }
 
-- 
1.6.0.6

