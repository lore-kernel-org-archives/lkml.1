Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab0BDDPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:15:23 -0500
Received: from sh.osrg.net ([192.16.179.4]:55524 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0BDDPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:15:22 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH -mm 1/4] DMA-API.txt: add dma_sync_single/sg API description
Date: Thu,  4 Feb 2010 12:13:22 +0900
Message-Id: <1265253206-17744-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 04 Feb 2010 12:14:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the description of the following eight function:

dma_sync_single_for_cpu
pci_dma_sync_single_for_cpuvoid
dma_sync_single_for_device
pci_dma_sync_single_for_device
dma_sync_sg_for_cpu
pci_dma_sync_sg_for_cpu
dma_sync_sg_for_device
pci_dma_sync_sg_for_device

It was unclear that the API permits a partial sync (some network
drivers already do though). I made it clear that the sync_single API
can do a partial sync but the sync_sg API can't.

We could do a partial sync with the sync_sg too, however, it's
difficult for driver writers to correctly use the sync_sg API for a
partial sync since the scatterlists passed in to the mapping API can
be modified. It's unlikely that driver writers want to do a partial
sync with the sync_sg API (because the sync_sg API are usually used
for block drivers). So I think that it's better to forbid a partial
sync with the sync_sg API.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 Documentation/DMA-API.txt |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index bb0e75e..c8db3d0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -364,6 +364,48 @@ API.
 Note: <nents> must be the number you passed in, *not* the number of
 physical entries returned.
 
+void
+dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			enum dma_data_direction direction)
+void
+pci_dma_sync_single_for_cpu(struct pci_dev *hwdev, dma_addr_t dma_handle,
+			    size_t size, int direction)
+void
+dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
+			   enum dma_data_direction direction)
+void
+pci_dma_sync_single_for_device(struct pci_dev *hwdev, dma_addr_t dma_handle,
+			       size_t size, int direction)
+void
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+		    enum dma_data_direction direction)
+void
+pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sg,
+		        int nelems, int direction)
+void
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+		       enum dma_data_direction direction)
+void
+pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg,
+		           int nelems, int direction)
+
+Synchronise a single contiguous or scatter/gather mapping for the cpu
+and device. With the sync_sg API, all the parameters must be the same
+as those passed into the single mapping API. With the sync_single API,
+you can use dma_handle and size parameters that aren't identical to
+those passed into the single mapping API to do a partial sync.
+
+Notes:  You must do this:
+
+- Before reading values that have been written by DMA from the device
+  (use the DMA_FROM_DEVICE direction)
+- After writing values that will be written to the device using DMA
+  (use the DMA_TO_DEVICE) direction
+- before *and* after handing memory to the device if the memory is
+  DMA_BIDIRECTIONAL
+
+See also dma_map_single().
+
 dma_addr_t
 dma_map_single_attrs(struct device *dev, void *cpu_addr, size_t size,
 		     enum dma_data_direction dir,
-- 
1.5.6.5

