Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYKYV3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYKYV3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYKYV3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:29:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:1608 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYKYV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:29:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,666,1220252400"; 
   d="scan'208";a="82644019"
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, reinette.chatre@intel.com, crmafra2@gmail.com,
       xhejtman@ics.muni.cz
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1 linux-2.6] iwlwifi: clean key table in iwl_clear_stations_table function
Date: Tue, 25 Nov 2008 23:29:03 +0200
Message-Id: <1227648543-28136-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.6.0.2.229.g1293c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans uCode key table bit map iwl_clear_stations_table
since all stations are cleared also the key table must be.

Since the keys are not removed properly on suspend by mac80211
this may result in exhausting key table on resume leading
to memory corruption during removal

This patch also fixes a memory corruption problem reported in
http://marc.info/?l=linux-wireless&m=122641417231586&w=2 and tracked in
http://bugzilla.kernel.org/show_bug.cgi?id=12040.

When the key is removed a second time the offset is set to 255 - this
index is not valid for the ucode_key_table and corrupts the eeprom pointer
(which is 255 bits from ucode_key_table).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Reported-by: Carlos R. Mafra <crmafra2@gmail.com>
Reported-by: Lukas Hejtmanek <xhejtman@ics.muni.cz>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

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
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

