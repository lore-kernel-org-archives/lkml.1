Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZFIK2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZFIK2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760751AbZFIKUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:11 -0400
Received: from kroah.org ([198.145.64.141]:55039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760762AbZFIKUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:08 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:03 2009
Message-Id: <20090609094103.315637657@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 48/87] iwlwifi: update key flags at time key is set
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=iwlwifi-update-key-flags-at-time-key-is-set.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Reinette Chatre <reinette.chatre@intel.com>

commit 299f5462087f3bc2141e6bc83ba7e2b15d8a07d2 upstream.

We need to be symmetrical in what is done when key is set and cleared.
This is important wrt the key flags as they are used during key
clearing and if they are not set when the key is set the key cannot be
cleared completely.

This addresses the many occurences of the WARN found in
iwl_set_tkip_dynamic_key_info() and tracked in
http://www.kerneloops.org/searchweek.php?search=iwl_set_dynamic_key

If calling iwl_set_tkip_dynamic_key_info()/iwl_remove_dynamic_key()
pair a few times in a row will cause that we run out of key space.
This is because the index stored in the key flags is used by
iwl_remove_dynamic_key() to decide if it should remove the key.
Unfortunately the key flags, and hence the key index is currently only
set at the time the key is written to the device (in
iwl_update_tkip_key()) and _not_ in iwl_set_tkip_dynamic_key_info().
Fix this by setting flags in iwl_set_tkip_dynamic_key_info().

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -708,6 +708,14 @@ static int iwl_set_tkip_dynamic_key_info
 {
 	unsigned long flags;
 	int ret = 0;
+	__le16 key_flags = 0;
+
+	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
+	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
+	key_flags &= ~STA_KEY_FLG_INVALID;
+
+	if (sta_id == priv->hw_params.bcast_sta_id)
+		key_flags |= STA_KEY_MULTICAST_MSK;
 
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 	keyconf->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
@@ -727,6 +735,9 @@ static int iwl_set_tkip_dynamic_key_info
 	WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
 		"no space for new kew");
 
+	priv->stations[sta_id].sta.key.key_flags = key_flags;
+
+
 	/* This copy is acutally not needed: we get the key with each TX */
 	memcpy(priv->stations[sta_id].keyinfo.key, keyconf->key, 16);
 
@@ -743,9 +754,7 @@ void iwl_update_tkip_key(struct iwl_priv
 {
 	u8 sta_id = IWL_INVALID_STATION;
 	unsigned long flags;
-	__le16 key_flags = 0;
 	int i;
-	DECLARE_MAC_BUF(mac);
 
 	sta_id = iwl_find_station(priv, addr);
 	if (sta_id == IWL_INVALID_STATION) {
@@ -760,16 +769,8 @@ void iwl_update_tkip_key(struct iwl_priv
 		return;
 	}
 
-	key_flags |= (STA_KEY_FLG_TKIP | STA_KEY_FLG_MAP_KEY_MSK);
-	key_flags |= cpu_to_le16(keyconf->keyidx << STA_KEY_FLG_KEYID_POS);
-	key_flags &= ~STA_KEY_FLG_INVALID;
-
-	if (sta_id == priv->hw_params.bcast_sta_id)
-		key_flags |= STA_KEY_MULTICAST_MSK;
-
 	spin_lock_irqsave(&priv->sta_lock, flags);
 
-	priv->stations[sta_id].sta.key.key_flags = key_flags;
 	priv->stations[sta_id].sta.key.tkip_rx_tsc_byte2 = (u8) iv32;
 
 	for (i = 0; i < 5; i++)


