Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbXJWGC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbXJWGC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXJWGCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:02:20 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:51094 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXJWGCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:02:19 -0400
To: jens.axboe@oracle.com
Cc: torvalds@linux-foundation.org, kyle@parisc-linux.org,
       linux-kernel@vger.kernel.org, tomof@acm.org
Subject: [PATCH] parisc: fix sg_page() fallout
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071023150017P.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 23 Oct 2007 15:00:17 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_map_sg':
arch/parisc/kernel/pci-dma.c:487: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_unmap_sg':
arch/parisc/kernel/pci-dma.c:508: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c:508: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_sync_sg_for_cpu':
arch/parisc/kernel/pci-dma.c:535: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c:535: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c: In function 'pa11_dma_sync_sg_for_device':
arch/parisc/kernel/pci-dma.c:545: error: 'struct scatterlist' has no member named 'page'
arch/parisc/kernel/pci-dma.c:545: error: 'struct scatterlist' has no member named 'page'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/parisc/kernel/pci-dma.c     |    1 +
 drivers/parisc/ccio-dma.c        |    1 +
 drivers/parisc/sba_iommu.c       |    1 +
 include/asm-parisc/scatterlist.h |    2 +-
 4 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 41f8e32..9448d4e 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cacheflush.h>
 #include <asm/dma.h>    /* for DMA_CHUNK_SIZE */
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index b3c4dbf..7c60cbd 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -42,6 +42,7 @@
 #include <linux/reboot.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/cache.h>		/* for L1_CACHE_BYTES */
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e5c3239..e527a0e 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
index cd3cfdf..62269b3 100644
--- a/include/asm-parisc/scatterlist.h
+++ b/include/asm-parisc/scatterlist.h
@@ -18,7 +18,7 @@ struct scatterlist {
 	__u32      iova_length; /* bytes mapped */
 };
 
-#define sg_virt_addr(sg) ((unsigned long)(page_address(sg->page) + sg->offset))
+#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
 #define sg_dma_address(sg) ((sg)->iova)
 #define sg_dma_len(sg)     ((sg)->iova_length)
 
-- 
1.5.2.4

