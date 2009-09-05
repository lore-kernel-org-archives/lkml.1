Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbZIEAXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbZIEAXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbZIEAVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:34 -0400
Received: from kroah.org ([198.145.64.141]:42201 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964792AbZIEAVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:01 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:53 2009
Message-Id: <20090905001452.947592195@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 36/71] iwlagn: do not send key clear commands when rfkill enabled
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=iwlagn-do-not-send-key-clear-commands-when-rfkill-enabled.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Reinette Chatre <reinette.chatre@intel.com>

commit 99f1b01562b7dcae75b043114f76163fbf84fcab upstream.

Do all key clearing except sending sommands to device when rfkill
enabled. When rfkill enabled the interface is brought down and will
be brought back up correctly after rfkill is enabled again.

Same change is not needed for iwl3945 as it ignores return code when
sending key clearing command to device.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=13742

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Frans Pop <elendil@planet.nl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -560,6 +560,8 @@ int iwl_remove_default_wep_key(struct iw
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_lock, flags);
+	IWL_DEBUG_WEP(priv, "Removing default WEP key: idx=%d\n",
+		      keyconf->keyidx);
 
 	if (!test_and_clear_bit(keyconf->keyidx, &priv->ucode_key_table))
 		IWL_ERR(priv, "index %d not used in uCode key table.\n",
@@ -567,6 +569,11 @@ int iwl_remove_default_wep_key(struct iw
 
 	priv->default_wep_key--;
 	memset(&priv->wep_keys[keyconf->keyidx], 0, sizeof(priv->wep_keys[0]));
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_WEPKEY command due to RFKILL.\n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
 	ret = iwl_send_static_wepkey_cmd(priv, 1);
 	IWL_DEBUG_WEP(priv, "Remove default WEP key: idx=%d ret=%d\n",
 		      keyconf->keyidx, ret);
@@ -847,6 +854,11 @@ int iwl_remove_dynamic_key(struct iwl_pr
 	priv->stations[sta_id].sta.sta.modify_mask = STA_MODIFY_KEY_MASK;
 	priv->stations[sta_id].sta.mode = STA_CONTROL_MODIFY_MSK;
 
+	if (iwl_is_rfkill(priv)) {
+		IWL_DEBUG_WEP(priv, "Not sending REPLY_ADD_STA command because RFKILL enabled. \n");
+		spin_unlock_irqrestore(&priv->sta_lock, flags);
+		return 0;
+	}
 	ret =  iwl_send_add_sta(priv, &priv->stations[sta_id].sta, CMD_ASYNC);
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 	return ret;


