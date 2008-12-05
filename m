Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYLERAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYLERAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 12:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYLERAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 12:00:15 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46523 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbYLERAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 12:00:11 -0500
Date: Fri, 5 Dec 2008 11:55:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2008-12-05
Message-ID: <20081205165506.GA18988@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here are a few more fixes intended for 2.6.28.  You are probably
familiar with the ones from Shaddy Baddah.  The ipw2200 one fixes an
oops reported in Novell's bugzilla, and the iwlwifi one fixes a problem
tracked at bugzilla.kernel.org -- both changelogs have more information.

Please let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit f706644d55f90e8306d87060168fef33804d6dd9:
  Oliver Hartkopp (1):
        can: omit received RTR frames for single ID filter lists

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Shaddy Baddah (2):
      mac80211: use unaligned safe memcmp() in-place of compare_ether_addr()
      zd1211rw: use unaligned safe memcmp() in-place of compare_ether_addr()

Tomas Winkler (1):
      iwlwifi: clean key table in iwl_clear_stations_table function

Zhu Yi (1):
      ipw2200: fix netif_*_queue() removal regression

 drivers/net/wireless/ipw2200.c          |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   24 +++++++++++++++++++++---
 drivers/net/wireless/zd1211rw/zd_mac.c  |    2 +-
 net/mac80211/sta_info.c                 |    2 +-
 5 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..7a9f901 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -3897,6 +3897,7 @@ static int ipw_disassociate(void *data)
 	if (!(priv->status & (STATUS_ASSOCIATED | STATUS_ASSOCIATING)))
 		return 0;
 	ipw_send_disassociate(data, 0);
+	netif_carrier_off(priv->net_dev);
 	return 1;
 }
 
@@ -10190,6 +10191,9 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 	u16 remaining_bytes;
 	int fc;
 
+	if (!(priv->status & STATUS_ASSOCIATED))
+		goto drop;
+
 	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 	switch (priv->ieee->iw_mode) {
 	case IW_MODE_ADHOC:
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4c312c5..01a8458 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -290,6 +290,9 @@ void iwl_clear_stations_table(struct iwl_priv *priv)
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
 
+	/* clean ucode key table bit map */
+	priv->ucode_key_table = 0;
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 61797f3..26f7084 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -475,7 +475,7 @@ static int iwl_get_free_ucode_key_index(struct iwl_priv *priv)
 		if (!test_and_set_bit(i, &priv->ucode_key_table))
 			return i;
 
-	return -1;
+	return WEP_INVALID_OFFSET;
 }
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
@@ -620,6 +620,9 @@ static int iwl_set_wep_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -637,6 +640,7 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
+	int ret;
 
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -664,14 +668,18 @@ static int iwl_set_ccmp_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
+	ret = iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
-	IWL_DEBUG_INFO("hwcrypto: modify ucode station key info\n");
-	return iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
+	return ret;
 }
 
 static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
@@ -696,6 +704,9 @@ static int iwl_set_tkip_dynamic_key_info(struct iwl_priv *priv,
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -734,6 +745,13 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
 		return 0;
 	}
 
+	if (priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET) {
+		IWL_WARNING("Removing wrong key %d 0x%x\n",
+			    keyconf->keyidx, key_flags);
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
+
 	if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
 		&priv->ucode_key_table))
 		IWL_ERROR("index %d not used in uCode key table.\n",
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index fe1867b..cac732f 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -615,7 +615,7 @@ static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 		struct ieee80211_hdr *tx_hdr;
 
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
-		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
+		if (likely(!memcmp(tx_hdr->addr2, rx_hdr->addr1, ETH_ALEN)))
 		{
 			__skb_unlink(skb, q);
 			tx_status(hw, skb, IEEE80211_TX_STAT_ACK, stats->signal, 1);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7fef8ea..d254446 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -99,7 +99,7 @@ struct sta_info *sta_info_get(struct ieee80211_local *local, const u8 *addr)
 
 	sta = rcu_dereference(local->sta_hash[STA_HASH(addr)]);
 	while (sta) {
-		if (compare_ether_addr(sta->sta.addr, addr) == 0)
+		if (memcmp(sta->sta.addr, addr, ETH_ALEN) == 0)
 			break;
 		sta = rcu_dereference(sta->hnext);
 	}
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
