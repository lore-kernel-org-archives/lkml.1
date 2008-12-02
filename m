Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYLBUwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYLBUwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYLBUvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:51:36 -0500
Received: from mail.atheros.com ([12.36.123.2]:24760 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbYLBUvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:51:35 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <stable@kernel.org>
CC: <ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Maciej Zenczykowski <zenczykowski@gmail.com>,
       Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Subject: [PATCH] ath9k: Fix SW-IOMMU bounce buffer starvation
Date: Tue, 2 Dec 2008 12:51:20 -0800
Message-ID: <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.5.6.rc2.15.g457bb.dirty
In-Reply-To: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the SW-IOMMU bounce buffer starvation
seen ok kernel.org bugzilla 11811:

http://bugzilla.kernel.org/show_bug.cgi?id=11811

Users on MacBook Pro 3.1/MacBook v2 would see something like:

DMA: Out of SW-IOMMU space for 4224 bytes at device 0000:0b:00.0

Unfortunately its only easy to trigger on MacBook Pro 3.1/MacBook v2
so far so its difficult to debug (even with swiotlb=force).

We were pci_unmap_single()'ing less bytes than what we called
for with pci_map_single() and as such we were starving
the swiotlb from its 64MB amount of bounce buffers. We remain
consistent and now always use sc->rxbufsize for RX. While at
it we update the beacon DMA maps as well to only use the data
portion of the skb, previous to this we were pci_map_single()'ing
more data for beaconing than what we tell the hardware it can use,
therefore pushing more iotlb abuse.

Still not sure why this is so easily triggerable on
MacBook Pro 3.1, it may be the hardware configuration
tends to use more memory > 3GB mark for DMA.

Signed-off-by: Maciej Zenczykowski <zenczykowski@gmail.com>
Signed-off-by: Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 20ddb7a..4d23827 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1011,7 +1011,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		pci_dma_sync_single_for_cpu(sc->pdev,
 					    bf->bf_buf_addr,
-					    skb_tailroom(skb),
+					    sc->sc_rxbufsize,
 					    PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev,
 				 bf->bf_buf_addr,
@@ -1303,8 +1303,7 @@ dma_addr_t ath_skb_map_single(struct ath_softc *sc,
 	 * NB: do NOT use skb->len, which is 0 on initialization.
 	 * Use skb's entire data area instead.
 	 */
-	*pa = pci_map_single(sc->pdev, skb->data,
-		skb_end_pointer(skb) - skb->head, direction);
+	*pa = pci_map_single(sc->pdev, skb->data, sc->sc_rxbufsize, direction);
 	return *pa;
 }
 
@@ -1314,6 +1313,5 @@ void ath_skb_unmap_single(struct ath_softc *sc,
 			  dma_addr_t *pa)
 {
 	/* Unmap skb's entire data area */
-	pci_unmap_single(sc->pdev, *pa,
-		skb_end_pointer(skb) - skb->head, direction);
+	pci_unmap_single(sc->pdev, *pa, sc->sc_rxbufsize, direction);
 }
-- 
1.5.6.rc2.15.g457bb.dirty

