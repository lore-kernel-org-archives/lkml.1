Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbYHRTvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbYHRTvC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:51:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbYHRTqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:46:06 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43696 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbYHRTqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:46:02 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 1/2] Ath5k: lock beacons
Date: Mon, 18 Aug 2008 21:45:27 +0200
Message-Id: <1219088728-10363-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beacons setup and config was racy with beacon send. Ensure that
ISR and reset functions see consistent state of bbuf.

Use also dev_kfree_skb_any in ath5k_txbuf_free since we call it
from atomic now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |   15 ++++++++++++---
 drivers/net/wireless/ath5k/base.h |    1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index fdfa4b8..b8178c7 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -253,7 +253,7 @@ static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 		return;
 	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
 			PCI_DMA_TODEVICE);
-	dev_kfree_skb(bf->skb);
+	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
 }
 
@@ -468,6 +468,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	mutex_init(&sc->lock);
 	spin_lock_init(&sc->rxbuflock);
 	spin_lock_init(&sc->txbuflock);
+	spin_lock_init(&sc->block);
 
 	/* Set private data */
 	pci_set_drvdata(pdev, hw);
@@ -2148,8 +2149,11 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 		sc->imask |= AR5K_INT_SWBA;
 
-		if (ath5k_hw_hasveol(ah))
+		if (ath5k_hw_hasveol(ah)) {
+			spin_lock(&sc->block);
 			ath5k_beacon_send(sc);
+			spin_unlock(&sc->block);
+		}
 	}
 	/* TODO else AP */
 
@@ -2349,7 +2353,9 @@ ath5k_intr(int irq, void *dev_id)
 						  TSF_TO_TU(tsf),
 						  (unsigned long long) tsf);
 				} else {
+					spin_lock(&sc->block);
 					ath5k_beacon_send(sc);
+					spin_unlock(&sc->block);
 				}
 			}
 			if (status & AR5K_INT_RXEOL) {
@@ -3015,6 +3021,7 @@ static int
 ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct ath5k_softc *sc = hw->priv;
+	unsigned long flags;
 	int ret;
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
@@ -3024,12 +3031,14 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 		goto end;
 	}
 
+	spin_lock_irqsave(&sc->block, flags);
 	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)
 		sc->bbuf->skb = NULL;
-	else {
+	spin_unlock_irqrestore(&sc->block, flags);
+	if (!ret) {
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index d7e03e6..7ec2f37 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -172,6 +172,7 @@ struct ath5k_softc {
 	struct tasklet_struct	txtq;		/* tx intr tasklet */
 	struct ath5k_led	tx_led;		/* tx led */
 
+	spinlock_t		block;		/* protects beacon */
 	struct ath5k_buf	*bbuf;		/* beacon buffer */
 	unsigned int		bhalq,		/* SW q for outgoing beacons */
 				bmisscount,	/* missed beacon transmits */
-- 
1.5.6.5

