Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYGOPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYGOPsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbYGOPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:47:38 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:59205 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760652AbYGOPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:47:37 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@redhat.com, rth@cygnus.com, jakub@redhat.com,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 4/5] Ath5k: fix dma operation
Date: Tue, 15 Jul 2008 17:44:43 +0200
Message-Id: <1216136683-10955-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't sync
- coherent mapping (descriptors)
- before unmap, it's useless
- (wrongly anyway -- for_cpu) beacon skb, it's just mapped,
  so by the device yet

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4874a6f..713ee99 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1705,10 +1705,6 @@ ath5k_tasklet_rx(unsigned long data)
 		skb = bf->skb;
 		ds = bf->desc;
 
-		/* TODO only one segment */
-		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
-				sc->desc_len, PCI_DMA_FROMDEVICE);
-
 		/*
 		 * last buffer must not be freed to ensure proper hardware
 		 * function. When the hardware finishes also a packet next to
@@ -1772,8 +1768,6 @@ ath5k_tasklet_rx(unsigned long data)
 				goto next;
 		}
 accept:
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr,
-				rs.rs_datalen, PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
 				PCI_DMA_FROMDEVICE);
 		bf->skb = NULL;
@@ -1861,9 +1855,6 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
 		ds = bf->desc;
 
-		/* TODO only one segment */
-		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
-				sc->desc_len, PCI_DMA_FROMDEVICE);
 		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
@@ -2036,8 +2027,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		ATH5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
-	pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
-			PCI_DMA_TODEVICE);
 
 	ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_tx_start(ah, sc->bhalq);
-- 
1.5.6.2

