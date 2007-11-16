Return-Path: <linux-kernel-owner+w=401wt.eu-S933859AbXKPXHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbXKPXHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXKPXHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:07:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:61800 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbXKPXHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HXarIZc7uidjnJrdqTeDFUfxhZcWa1/1Y5urJMdmVO2P3UkakYnSsq1BY0OlmScANAR/gwjjFhxCOqzL1Y4c2LjEzhYQ7lHEJHChCpEqLQ8X1yotP++APYTSlzFfDgtRasmUlhec+im9yfa/2sB1sSkEgqcAsWH3kgBC3ANpMOY=
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iwlwifi: add power management support -v2
Date: Sat, 17 Nov 2007 00:06:49 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711170006.49654.mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds power management support in iwl3945 and iwl4965 drivers.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9baf8de..5c7b422 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6951,6 +7187,7 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	struct iwl3945_priv *priv = hw->priv;
 	const struct iwl3945_channel_info *ch_info;
 	unsigned long flags;
+	int power_mode;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
@@ -7001,6 +7238,23 @@ static int iwl3945_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	}
 #endif
 
+	if (conf->power_management_enable)
+		power_mode = IWL_POWER_BATTERY | IWL_POWER_ENABLED;
+	else
+		power_mode = IWL_POWER_AC;
+
+	if (priv->power_mode != power_mode) {
+		int rc;
+
+		rc = iwl3945_send_power_mode(priv, power_mode);
+		if (rc) {
+			IWL_DEBUG_MAC80211("failed setting power mode.\n");
+			mutex_unlock(&priv->mutex);
+			return -EINVAL;
+		}
+		priv->power_mode = power_mode;
+	}
+
 	iwl3945_radio_kill_sw(priv, !conf->radio_enabled);
 
 	if (!conf->radio_enabled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index df011ea..8d303c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7352,6 +7352,7 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	struct iwl4965_priv *priv = hw->priv;
 	const struct iwl4965_channel_info *ch_info;
 	unsigned long flags;
+	int power_mode;
 
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
@@ -7414,6 +7415,23 @@ static int iwl4965_mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *co
 	}
 #endif
 
+	if (conf->power_management_enable)
+		power_mode = IWL_POWER_BATTERY | IWL_POWER_ENABLED;
+	else
+		power_mode = IWL_POWER_AC;
+
+	if (priv->power_mode != power_mode) {
+		int rc;
+
+		rc = iwl4965_send_power_mode(priv, power_mode);
+		if (rc) {
+			IWL_DEBUG_MAC80211("failed setting power mode.\n");
+			mutex_unlock(&priv->mutex);
+			return -EINVAL;
+		}
+		priv->power_mode = power_mode;
+	}
+
 	iwl4965_radio_kill_sw(priv, !conf->radio_enabled);
 
 	if (!conf->radio_enabled) {


-- 
	Miguel Botón
