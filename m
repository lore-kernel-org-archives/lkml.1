Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXHBSVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXHBSVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXHBSVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:21:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbXHBSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:21:37 -0400
Date: Thu, 2 Aug 2007 19:21:30 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix s2io regression
Message-ID: <20070802182130.GM21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	* wrong argument passed to pci_unmap_single() on failure
exit paths
	* leak in the same area
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 2be0a0f..24feb00 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -2430,7 +2430,7 @@ static int fill_rx_buffers(struct s2io_nic *nic, int ring_no)
 					(rxdp3->Buffer1_ptr == DMA_ERROR_CODE)) {
 					pci_unmap_single
 						(nic->pdev,
-						(dma_addr_t)skb->data,
+						(dma_addr_t)rxdp3->Buffer2_ptr,
 						dev->mtu + 4,
 						PCI_DMA_FROMDEVICE);
 					goto pci_map_failed;
@@ -6211,7 +6211,7 @@ static int set_rxd_buffer_pointer(struct s2io_nic *sp, struct RxD_t *rxdp,
 			if( (rxdp3->Buffer0_ptr == 0) ||
 				(rxdp3->Buffer0_ptr == DMA_ERROR_CODE)) {
 				pci_unmap_single (sp->pdev,
-					(dma_addr_t)(*skb)->data,
+					(dma_addr_t)rxdp3->Buffer2_ptr,
 					dev->mtu + 4, PCI_DMA_FROMDEVICE);
 				goto memalloc_failed;
 			}
@@ -6224,7 +6224,10 @@ static int set_rxd_buffer_pointer(struct s2io_nic *sp, struct RxD_t *rxdp,
 			if( (rxdp3->Buffer1_ptr == 0) ||
 				(rxdp3->Buffer1_ptr == DMA_ERROR_CODE)) {
 				pci_unmap_single (sp->pdev,
-					(dma_addr_t)(*skb)->data,
+					(dma_addr_t)rxdp3->Buffer0_ptr,
+					BUF0_LEN, PCI_DMA_FROMDEVICE);
+				pci_unmap_single (sp->pdev,
+					(dma_addr_t)rxdp3->Buffer2_ptr,
 					dev->mtu + 4, PCI_DMA_FROMDEVICE);
 				goto memalloc_failed;
 			}
