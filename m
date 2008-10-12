Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYJLUy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYJLUy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbYJLUyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:54:49 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:60211 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJLUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:54:48 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 1/1] Ath5k: add AP mode
Date: Sun, 12 Oct 2008 22:54:10 +0200
Message-Id: <1223844850-26551-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for AP mode. This involves:
- enablement in ath5k_beacon_config -- initialize beacon timer
- add AP to the supported modes in ath5k_add_interface
- handle beacon change even for AP in ath5k_config_interface
- remove useless test for IBSS in ath5k_beacon_update

Note that it doesn't enable the AP mode for the driver. It must
be enabled by NL80211_IFTYPE_AP bit added to interface_modes.

v2:
Fixed opmode constant (IEEE80211_ to NL80211_)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |   42 +++++++++++++++----------------------
 1 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 9b95c40..72b5e47 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -238,8 +238,7 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 		struct ieee80211_tx_queue_stats *stats);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
-static int ath5k_beacon_update(struct ieee80211_hw *hw,
-		struct sk_buff *skb);
+static int ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb);
 
 static struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -2157,8 +2156,6 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
  *
  * In IBSS mode we use a self-linked tx descriptor if possible. We enable SWBA
  * interrupts to detect TSF updates only.
- *
- * AP mode is missing.
  */
 static void
 ath5k_beacon_config(struct ath5k_softc *sc)
@@ -2171,7 +2168,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 	if (sc->opmode == NL80211_IFTYPE_STATION) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
+			sc->opmode == NL80211_IFTYPE_AP) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2183,13 +2181,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 		sc->imask |= AR5K_INT_SWBA;
 
-		if (ath5k_hw_hasveol(ah)) {
-			spin_lock(&sc->block);
-			ath5k_beacon_send(sc);
-			spin_unlock(&sc->block);
-		}
+		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+			if (ath5k_hw_hasveol(ah)) {
+				spin_lock(&sc->block);
+				ath5k_beacon_send(sc);
+				spin_unlock(&sc->block);
+			}
+		} else
+			ath5k_beacon_update_timers(sc, -1);
 	}
-	/* TODO else AP */
 
 	ath5k_hw_set_imr(ah, sc->imask);
 }
@@ -2741,6 +2741,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	sc->vif = conf->vif;
 
 	switch (conf->type) {
+	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MONITOR:
@@ -2804,7 +2805,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ret = -EIO;
 		goto unlock;
 	}
-	if (conf->bssid) {
+	if (conf->changed & IEEE80211_IFCC_BSSID && conf->bssid) {
 		/* Cache for later use during resets */
 		memcpy(ah->ah_bssid, conf->bssid, ETH_ALEN);
 		/* XXX: assoc id is set to 0 for now, mac80211 doesn't have
@@ -2812,18 +2813,16 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
 		mmiowb();
 	}
-
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+			(vif->type == NL80211_IFTYPE_ADHOC ||
+			 vif->type == NL80211_IFTYPE_AP)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
 			goto unlock;
 		}
-		/* call old handler for now */
-		ath5k_beacon_update(hw, beacon);
+		ath5k_beacon_update(sc, beacon);
 	}
-
 	mutex_unlock(&sc->lock);
 
 	return ath5k_reset_wake(sc);
@@ -3055,19 +3054,13 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 }
 
 static int
-ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
+ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb)
 {
-	struct ath5k_softc *sc = hw->priv;
 	unsigned long flags;
 	int ret;
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	if (sc->opmode != NL80211_IFTYPE_ADHOC) {
-		ret = -EIO;
-		goto end;
-	}
-
 	spin_lock_irqsave(&sc->block, flags);
 	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
@@ -3080,7 +3073,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 		mmiowb();
 	}
 
-end:
 	return ret;
 }
 
-- 
1.6.0.2

