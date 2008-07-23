Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYGWLVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYGWLVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbYGWLUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:20:37 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45054 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYGWLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:20:35 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 3/3] Ath5k: unify resets
Date: Wed, 23 Jul 2008 13:17:35 +0200
Message-Id: <1216811855-9387-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
References: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were 3 code copy and pastes of reset. Unify the resets and place
in separate function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |  124 +++++++++++++------------------------
 1 files changed, 42 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e636863..9eb0796 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -165,7 +165,8 @@ static struct pci_driver ath5k_pci_driver = {
  * Prototypes - MAC 802.11 stack related functions
  */
 static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
-static int ath5k_reset(struct ieee80211_hw *hw);
+static int ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel);
+static int ath5k_reset_wake(struct ath5k_softc *sc);
 static int ath5k_start(struct ieee80211_hw *hw);
 static void ath5k_stop(struct ieee80211_hw *hw);
 static int ath5k_add_interface(struct ieee80211_hw *hw,
@@ -989,9 +990,6 @@ ath5k_getchannels(struct ieee80211_hw *hw)
 static int
 ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 {
-	struct ath5k_hw *ah = sc->ah;
-	int ret;
-
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "(%u MHz) -> (%u MHz)\n",
 		sc->curchan->center_freq, chan->center_freq);
 
@@ -1007,41 +1005,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		 * hardware at the new frequency, and then re-enable
 		 * the relevant bits of the h/w.
 		 */
-		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
-		ath5k_txq_cleanup(sc);		/* clear pending tx frames */
-		ath5k_rx_stop(sc);		/* turn off frame recv */
-		ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
-		if (ret) {
-			ATH5K_ERR(sc, "%s: unable to reset channel "
-				"(%u Mhz)\n", __func__, chan->center_freq);
-			return ret;
-		}
-
-		ath5k_hw_set_txpower_limit(sc->ah, 0);
-
-		/*
-		 * Re-enable rx framework.
-		 */
-		ret = ath5k_rx_start(sc);
-		if (ret) {
-			ATH5K_ERR(sc, "%s: unable to restart recv logic\n",
-					__func__);
-			return ret;
-		}
-
-		/*
-		 * Change channels and update the h/w rate map
-		 * if we're switching; e.g. 11a to 11b/g.
-		 *
-		 * XXX needed?
-		 */
-/*		ath5k_chan_change(sc, chan); */
-
-		ath5k_beacon_config(sc);
-		/*
-		 * Re-enable interrupts.
-		 */
-		ath5k_hw_set_intr(ah, sc->imask);
+		return ath5k_reset(sc, true, true);
 	}
 
 	return 0;
@@ -2228,36 +2192,13 @@ ath5k_init(struct ath5k_softc *sc)
 	 */
 	sc->curchan = sc->hw->conf.channel;
 	sc->curband = &sc->sbands[sc->curchan->band];
-	ret = ath5k_hw_reset(sc->ah, sc->opmode, sc->curchan, false);
-	if (ret) {
-		ATH5K_ERR(sc, "unable to reset hardware: %d\n", ret);
-		goto done;
-	}
-	/*
-	 * This is needed only to setup initial state
-	 * but it's best done after a reset.
-	 */
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
-
-	/*
-	 * Setup the hardware after reset: the key cache
-	 * is filled as needed and the receive engine is
-	 * set going.  Frame transmit is handled entirely
-	 * in the frame output path; there's nothing to do
-	 * here except setup the interrupt mask.
-	 */
-	ret = ath5k_rx_start(sc);
-	if (ret)
-		goto done;
-
-	/*
-	 * Enable interrupts.
-	 */
 	sc->imask = AR5K_INT_RX | AR5K_INT_TX | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_FATAL | AR5K_INT_GLOBAL |
 		AR5K_INT_MIB;
+	ret = ath5k_reset(sc, false, false);
+	if (ret)
+		goto done;
 
-	ath5k_hw_set_intr(sc->ah, sc->imask);
 	/* Set ack to be sent at low bit-rates */
 	ath5k_hw_set_ack_bitrate_high(sc->ah, false);
 
@@ -2457,7 +2398,7 @@ ath5k_tasklet_reset(unsigned long data)
 {
 	struct ath5k_softc *sc = (void *)data;
 
-	ath5k_reset(sc->hw);
+	ath5k_reset_wake(sc);
 }
 
 /*
@@ -2480,7 +2421,7 @@ ath5k_calibrate(unsigned long data)
 		 * to load new gain values.
 		 */
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
-		ath5k_reset(sc->hw);
+		ath5k_reset_wake(sc);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
@@ -2681,48 +2622,67 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 }
 
 static int
-ath5k_reset(struct ieee80211_hw *hw)
+ath5k_reset(struct ath5k_softc *sc, bool stop, bool change_channel)
 {
-	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
-	ath5k_hw_set_intr(ah, 0);
-	ath5k_txq_cleanup(sc);
-	ath5k_rx_stop(sc);
-
+	if (stop) {
+		ath5k_hw_set_intr(ah, 0);
+		ath5k_txq_cleanup(sc);
+		ath5k_rx_stop(sc);
+	}
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
-	if (unlikely(ret)) {
+	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
 	}
+
+	/*
+	 * This is needed only to setup initial state
+	 * but it's best done after a reset.
+	 */
 	ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 	ret = ath5k_rx_start(sc);
-	if (unlikely(ret)) {
+	if (ret) {
 		ATH5K_ERR(sc, "can't start recv logic\n");
 		goto err;
 	}
+
 	/*
-	 * We may be doing a reset in response to an ioctl
-	 * that changes the channel so update any state that
-	 * might change as a result.
+	 * Change channels and update the h/w rate map if we're switching;
+	 * e.g. 11a to 11b/g.
+	 *
+	 * We may be doing a reset in response to an ioctl that changes the
+	 * channel so update any state that might change as a result.
 	 *
 	 * XXX needed?
 	 */
 /*	ath5k_chan_change(sc, c); */
-	ath5k_beacon_config(sc);
-	/* intrs are started by ath5k_beacon_config */
 
-	ieee80211_wake_queues(hw);
+	ath5k_beacon_config(sc);
+	/* intrs are enabled by ath5k_beacon_config */
 
 	return 0;
 err:
 	return ret;
 }
 
+static int
+ath5k_reset_wake(struct ath5k_softc *sc)
+{
+	int ret;
+
+	ret = ath5k_reset(sc, true, true);
+	if (!ret)
+		ieee80211_wake_queues(sc->hw);
+
+	return ret;
+}
+
 static int ath5k_start(struct ieee80211_hw *hw)
 {
 	return ath5k_init(hw->priv);
@@ -2831,7 +2791,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_unlock(&sc->lock);
 
-	return ath5k_reset(hw);
+	return ath5k_reset_wake(sc);
 unlock:
 	mutex_unlock(&sc->lock);
 	return ret;
-- 
1.5.6.2

