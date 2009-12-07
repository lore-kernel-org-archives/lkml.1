Return-Path: <linux-kernel-owner+w=401wt.eu-S932787AbZLGANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbZLGANZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZLGANW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:22 -0500
Received: from kroah.org ([198.145.64.141]:34449 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758495AbZLGANO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:14 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:50 2009
Message-Id: <20091207000650.041769656@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [056/119] mac80211: fix spurious delBA handling
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=mac80211-fix-spurious-delba-handling.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Johannes Berg <johannes@sipsolutions.net>

commit 827d42c9ac91ddd728e4f4a31fefb906ef2ceff7 upstream.

Lennert Buytenhek noticed that delBA handling in mac80211
was broken and has remotely triggerable problems, some of
which are due to some code shuffling I did that ended up
changing the order in which things were done -- this was

  commit d75636ef9c1af224f1097941879d5a8db7cd04e5
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Feb 10 21:25:53 2009 +0100

    mac80211: RX aggregation: clean up stop session

and other parts were already present in the original

  commit d92684e66091c0f0101819619b315b4bb8b5bcc5
  Author: Ron Rindjunsky <ron.rindjunsky@intel.com>
  Date:   Mon Jan 28 14:07:22 2008 +0200

      mac80211: A-MPDU Tx add delBA from recipient support

The first problem is that I moved a BUG_ON before various
checks -- thereby making it possible to hit. As the comment
indicates, the BUG_ON can be removed since the ampdu_action
callback must already exist when the state is != IDLE.

The second problem isn't easily exploitable but there's a
race condition due to unconditionally setting the state to
OPERATIONAL when a delBA frame is received, even when no
aggregation session was ever initiated. All the drivers
accept stopping the session even then, but that opens a
race window where crashes could happen before the driver
accepts it. Right now, a WARN_ON may happen with non-HT
drivers, while the race opens only for HT drivers.

For this case, there are two things necessary to fix it:
 1) don't process spurious delBA frames, and be more careful
    about the session state; don't drop the lock

 2) HT drivers need to be prepared to handle a session stop
    even before the session was really started -- this is
    true for all drivers (that support aggregation) but
    iwlwifi which can be fixed easily. The other HT drivers
    (ath9k and ar9170) are behaving properly already.

Reported-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   10 +++++++++-
 include/net/mac80211.h                |    6 ++++++
 net/mac80211/agg-tx.c                 |   15 +++++++--------
 net/mac80211/ht.c                     |    8 +++-----
 net/mac80211/ieee80211_i.h            |    2 ++
 5 files changed, 27 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1233,8 +1233,16 @@ int iwl_tx_agg_stop(struct iwl_priv *pri
 		return -ENXIO;
 	}
 
+	if (priv->stations[sta_id].tid[tid].agg.state ==
+				IWL_EMPTYING_HW_QUEUE_ADDBA) {
+		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
+		ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
+		return 0;
+	}
+
 	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_ON)
-		IWL_WARN(priv, "Stopping AGG while state not IWL_AGG_ON\n");
+		IWL_WARN(priv, "Stopping AGG while state not ON or starting\n");
 
 	tid_data = &priv->stations[sta_id].tid[tid];
 	ssn = (tid_data->seq_number & IEEE80211_SCTL_SEQ) >> 4;
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1244,6 +1244,12 @@ enum ieee80211_filter_flags {
  *
  * These flags are used with the ampdu_action() callback in
  * &struct ieee80211_ops to indicate which action is needed.
+ *
+ * Note that drivers MUST be able to deal with a TX aggregation
+ * session being stopped even before they OK'ed starting it by
+ * calling ieee80211_start_tx_ba_cb(_irqsafe), because the peer
+ * might receive the addBA frame and send a delBA right away!
+ *
  * @IEEE80211_AMPDU_RX_START: start Rx aggregation
  * @IEEE80211_AMPDU_RX_STOP: stop Rx aggregation
  * @IEEE80211_AMPDU_TX_START: start Tx aggregation
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -123,13 +123,18 @@ void ieee80211_send_bar(struct ieee80211
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
-static int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
-					   enum ieee80211_back_parties initiator)
+int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				    enum ieee80211_back_parties initiator)
 {
 	struct ieee80211_local *local = sta->local;
 	int ret;
 	u8 *state;
 
+#ifdef CONFIG_MAC80211_HT_DEBUG
+	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
+	       sta->sta.addr, tid);
+#endif /* CONFIG_MAC80211_HT_DEBUG */
+
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
 	if (*state == HT_AGG_STATE_OPERATIONAL)
@@ -143,7 +148,6 @@ static int ___ieee80211_stop_tx_ba_sessi
 
 	/* HW shall not deny going back to legacy */
 	if (WARN_ON(ret)) {
-		*state = HT_AGG_STATE_OPERATIONAL;
 		/*
 		 * We may have pending packets get stuck in this case...
 		 * Not bothering with a workaround for now.
@@ -526,11 +530,6 @@ int __ieee80211_stop_tx_ba_session(struc
 		goto unlock;
 	}
 
-#ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Tx BA session stop requested for %pM tid %u\n",
-	       sta->sta.addr, tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-
 	ret = ___ieee80211_stop_tx_ba_session(sta, tid, initiator);
 
  unlock:
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -141,7 +141,6 @@ void ieee80211_process_delba(struct ieee
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_local *local = sdata->local;
 	u16 tid, params;
 	u16 initiator;
 
@@ -161,10 +160,9 @@ void ieee80211_process_delba(struct ieee
 						 WLAN_BACK_INITIATOR, 0);
 	else { /* WLAN_BACK_RECIPIENT */
 		spin_lock_bh(&sta->lock);
-		sta->ampdu_mlme.tid_state_tx[tid] =
-				HT_AGG_STATE_OPERATIONAL;
+		if (sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK)
+			___ieee80211_stop_tx_ba_session(sta, tid,
+							WLAN_BACK_RECIPIENT);
 		spin_unlock_bh(&sta->lock);
-		ieee80211_stop_tx_ba_session(&local->hw, sta->sta.addr, tid,
-					     WLAN_BACK_RECIPIENT);
 	}
 }
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1057,6 +1057,8 @@ void ieee80211_process_addba_request(str
 
 int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				   enum ieee80211_back_parties initiator);
+int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
+				    enum ieee80211_back_parties initiator);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,


