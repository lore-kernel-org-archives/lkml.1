Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760547AbYLQAK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbYLQAK4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759691AbYLQAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:07 -0500
Received: from kroah.org ([198.145.64.141]:41285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759659AbYLQAGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:06:02 -0500
Date: Tue, 16 Dec 2008 16:04:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomas Winkler <tomas.winkler@intel.com>,
        Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 10/22] iwlwifi: clean key table in iwl_clear_stations_table
	function
Message-ID: <20081217000419.GK4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-clean-key-table-in-iwl_clear_stations_table-function.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 40a9a8299116297429298e8fcee08235134883f7 upstream.

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-core.c |    3 +++
 drivers/net/wireless/iwlwifi/iwl-sta.c  |   24 +++++++++++++++++++++---
 2 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -290,6 +290,9 @@ void iwl_clear_stations_table(struct iwl
 	priv->num_stations = 0;
 	memset(priv->stations, 0, sizeof(priv->stations));
 
+	/* clean ucode key table bit map */
+	priv->ucode_key_table = 0;
+
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 }
 EXPORT_SYMBOL(iwl_clear_stations_table);
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -475,7 +475,7 @@ static int iwl_get_free_ucode_key_index(
 		if (!test_and_set_bit(i, &priv->ucode_key_table))
 			return i;
 
-	return -1;
+	return WEP_INVALID_OFFSET;
 }
 
 int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
@@ -620,6 +620,9 @@ static int iwl_set_wep_dynamic_key_info(
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
@@ -637,6 +640,7 @@ static int iwl_set_ccmp_dynamic_key_info
 {
 	unsigned long flags;
 	__le16 key_flags = 0;
+	int ret;
 
 	key_flags |= (STA_KEY_FLG_CCMP | STA_KEY_FLG_MAP_KEY_MSK);
 	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
@@ -664,14 +668,18 @@ static int iwl_set_ccmp_dynamic_key_info
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
@@ -696,6 +704,9 @@ static int iwl_set_tkip_dynamic_key_info
 	/* else, we are overriding an existing key => no need to allocated room
 	 * in uCode. */
 
+	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
+		"no space for new kew");
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -734,6 +745,13 @@ int iwl_remove_dynamic_key(struct iwl_pr
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

