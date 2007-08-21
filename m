Return-Path: <linux-kernel-owner+w=401wt.eu-S1761999AbXHUQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761999AbXHUQwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 12:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761806AbXHUQvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 12:51:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:8556 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759810AbXHUQvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 12:51:54 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 12:51:54 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,290,1183359600"; 
   d="scan'208";a="285911770"
From: Shannon Nelson <shannon.nelson@intel.com>
Subject: [PATCH -mm] IOAT: Fix ioat_dma descriptor cache miss (in -mm)
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: shannon.nelson@intel.com, dan.j.williams@intel.com
Date: Tue, 21 Aug 2007 09:42:06 -0700
Message-ID: <20070821164206.21821.27046.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(we've fixed it in 2.6.23-rc3, let's get the same fix into -mm)

The layout for struct ioat_desc_sw is non-optimal and causes an extra
cache hit for every descriptor processed.  By tightening up the struct
layout and removing one item, we pull in the fields that get used in
the speedpath and get a little better performance.


Before:
-------
struct ioat_desc_sw {
	struct ioat_dma_descriptor * hw;                 /*     0     8 */
	struct list_head           node;                 /*     8    16 */
	int                        tx_cnt;               /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	dma_addr_t                 src;                  /*    32     8 */
	__u32                      src_len;              /*    40     4 */

	/* XXX 4 bytes hole, try to pack */

	dma_addr_t                 dst;                  /*    48     8 */
	__u32                      dst_len;              /*    56     4 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 1 boundary (64 bytes) --- */
	struct dma_async_tx_descriptor async_tx;         /*    64   144 */
	/* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */

	/* size: 208, cachelines: 4 */
	/* sum members: 196, holes: 3, sum holes: 12 */
	/* last cacheline: 16 bytes */
};	/* definitions: 1 */


After:
------

struct ioat_desc_sw {
	struct ioat_dma_descriptor * hw;                 /*     0     8 */
	struct list_head           node;                 /*     8    16 */
	int                        tx_cnt;               /*    24     4 */
	__u32                      len;                  /*    28     4 */
	dma_addr_t                 src;                  /*    32     8 */
	dma_addr_t                 dst;                  /*    40     8 */
	struct dma_async_tx_descriptor async_tx;         /*    48   144 */
	/* --- cacheline 3 boundary (192 bytes) --- */

	/* size: 192, cachelines: 3 */
};	/* definitions: 1 */


Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
---

 drivers/dma/ioat_dma.c |    9 ++++-----
 drivers/dma/ioatdma.h  |    3 +--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index 55f4179..c4c7343 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -432,9 +432,8 @@ static struct dma_async_tx_descriptor *ioat_dma_prep_memcpy(
 	new->async_tx.ack = 0; /* client is in control of this ack */
 	new->async_tx.cookie = -EBUSY;
 
-	pci_unmap_len_set(new, src_len, orig_len);
-	pci_unmap_len_set(new, dst_len, orig_len);
-	spin_unlock_bh(&ioat_chan->desc_lock);
+	pci_unmap_len_set(new, len, orig_len);
+	spin_unlock_bh(&ioat_chan->desc_lock);:w
 
 	return new ? &new->async_tx : NULL;
 }
@@ -518,11 +517,11 @@ static void ioat_dma_memcpy_cleanup(struct ioat_dma_chan *ioat_chan)
 			 */
 			pci_unmap_page(ioat_chan->device->pdev,
 					pci_unmap_addr(desc, dst),
-					pci_unmap_len(desc, dst_len),
+					pci_unmap_len(desc, len),
 					PCI_DMA_FROMDEVICE);
 			pci_unmap_page(ioat_chan->device->pdev,
 					pci_unmap_addr(desc, src),
-					pci_unmap_len(desc, src_len),
+					pci_unmap_len(desc, len),
 					PCI_DMA_TODEVICE);
 		}
 
diff --git a/drivers/dma/ioatdma.h b/drivers/dma/ioatdma.h
index bab2a72..d59c90b 100644
--- a/drivers/dma/ioatdma.h
+++ b/drivers/dma/ioatdma.h
@@ -123,10 +123,9 @@ struct ioat_desc_sw {
 	struct ioat_dma_descriptor *hw;
 	struct list_head node;
 	int tx_cnt;
+	DECLARE_PCI_UNMAP_LEN(len)
 	DECLARE_PCI_UNMAP_ADDR(src)
-	DECLARE_PCI_UNMAP_LEN(src_len)
 	DECLARE_PCI_UNMAP_ADDR(dst)
-	DECLARE_PCI_UNMAP_LEN(dst_len)
 	struct dma_async_tx_descriptor async_tx;
 };
 
