Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbZLODp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbZLODp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 22:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZLODpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 22:45:22 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47514 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942AbZLODpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 22:45:19 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: kernel-team@lists.ubuntu.com
Cc: stable@kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
Date: Tue, 15 Dec 2009 11:45:10 +0800
Message-Id: <1260848710-5650-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch unifies setup_rxon_timing funcions
of AGN and 3945. HWs differ only in supported maximal
beacon interval. This is reflected in hw_paras.max_beacon_itrvl

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
(cherry picked from commit 2c2f3b33888419fb9e7d015b9dc67b9db4437efa)

Conflicts:

	drivers/net/wireless/iwlwifi/iwl-dev.h

CC: stable@kernel.org
Signed-off-by: Ike Panhc <ike.pan@canonical.com>

BugLink: http://bugs.launchpad.net/bugs/496496

---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   64 -----------------------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.c     |   59 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 +--------------------------
 7 files changed, 66 insertions(+), 136 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index b73ab6c..baef5a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2562,6 +2562,7 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.bcast_sta_id = IWL3945_BROADCAST_ID;
 
 	priv->hw_params.rx_wrt_ptr_reg = FH39_RSCSR_CHNL0_WPTR;
+	priv->hw_params.max_beacon_itrvl = IWL39_MAX_UCODE_BEACON_INTERVAL;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2a577ae..774f538 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -512,70 +512,6 @@ int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 	return 0;
 }
 
-
-/******************************************************************************
- *
- * Misc. internal state and helper functions
- *
- ******************************************************************************/
-
-#define MAX_UCODE_BEACON_INTERVAL	4096
-
-static u16 iwl_adjust_beacon_interval(u16 beacon_val)
-{
-	u16 new_val = 0;
-	u16 beacon_factor = 0;
-
-	beacon_factor = (beacon_val + MAX_UCODE_BEACON_INTERVAL)
-					/ MAX_UCODE_BEACON_INTERVAL;
-	new_val = beacon_val / beacon_factor;
-
-	if (!new_val)
-		new_val = MAX_UCODE_BEACON_INTERVAL;
-
-	return new_val;
-}
-
-static void iwl_setup_rxon_timing(struct iwl_priv *priv)
-{
-	u64 tsf;
-	s32 interval_tm, rem;
-	unsigned long flags;
-	struct ieee80211_conf *conf = NULL;
-	u16 beacon_int = 0;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
-	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
-
-	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-		beacon_int = iwl_adjust_beacon_interval(priv->beacon_int);
-		priv->rxon_timing.atim_window = 0;
-	} else {
-		beacon_int = iwl_adjust_beacon_interval(
-			priv->vif->bss_conf.beacon_int);
-
-		/* TODO: we need to get atim_window from upper stack
-		 * for now we set to 0 */
-		priv->rxon_timing.atim_window = 0;
-	}
-
-	priv->rxon_timing.beacon_interval = cpu_to_le16(beacon_int);
-
-	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
-	interval_tm = beacon_int * 1024;
-	rem = do_div(tsf, interval_tm);
-	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-	IWL_DEBUG_ASSOC(priv, "beacon interval %d beacon timer %d beacon tim %d\n",
-			le16_to_cpu(priv->rxon_timing.beacon_interval),
-			le32_to_cpu(priv->rxon_timing.beacon_init_val),
-			le16_to_cpu(priv->rxon_timing.atim_window));
-}
-
 /******************************************************************************
  *
  * Generic RX handler implementations
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 69a97c7..a61393a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -765,6 +765,8 @@ struct iwl5000_rxon_assoc_cmd {
 } __attribute__ ((packed));
 
 #define IWL_CONN_MAX_LISTEN_INTERVAL	10
+#define IWL_MAX_UCODE_BEACON_INTERVAL	4 /* 4096 */
+#define IWL39_MAX_UCODE_BEACON_INTERVAL	1 /* 1024 */
 
 /*
  * REPLY_RXON_TIMING = 0x14 (command, has simple generic response)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 18b135f..d678e6a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -635,6 +635,63 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_is_fat_tx_allowed);
 
+static u16 iwl_adjust_beacon_interval(u16 beacon_val, u16 max_beacon_val)
+{
+	u16 new_val = 0;
+	u16 beacon_factor = 0;
+
+	beacon_factor = (beacon_val + max_beacon_val) / max_beacon_val;
+	new_val = beacon_val / beacon_factor;
+
+	if (!new_val)
+		new_val = max_beacon_val;
+
+	return new_val;
+}
+
+void iwl_setup_rxon_timing(struct iwl_priv *priv)
+{
+	u64 tsf;
+	s32 interval_tm, rem;
+	unsigned long flags;
+	struct ieee80211_conf *conf = NULL;
+	u16 beacon_int;
+
+	conf = ieee80211_get_hw_conf(priv->hw);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
+	priv->rxon_timing.listen_interval = cpu_to_le16(conf->listen_interval);
+
+	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
+		beacon_int = priv->beacon_int;
+		priv->rxon_timing.atim_window = 0;
+	} else {
+		beacon_int = priv->vif->bss_conf.beacon_int;
+
+		/* TODO: we need to get atim_window from upper stack
+		 * for now we set to 0 */
+		priv->rxon_timing.atim_window = 0;
+	}
+
+	beacon_int = iwl_adjust_beacon_interval(beacon_int,
+				priv->hw_params.max_beacon_itrvl * 1024);
+	priv->rxon_timing.beacon_interval = cpu_to_le16(beacon_int);
+
+	tsf = priv->timestamp; /* tsf is modifed by do_div: copy it */
+	interval_tm = beacon_int * 1024;
+	rem = do_div(tsf, interval_tm);
+	priv->rxon_timing.beacon_init_val = cpu_to_le32(interval_tm - rem);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	IWL_DEBUG_ASSOC(priv,
+			"beacon interval %d beacon timer %d beacon tim %d\n",
+			le16_to_cpu(priv->rxon_timing.beacon_interval),
+			le32_to_cpu(priv->rxon_timing.beacon_init_val),
+			le16_to_cpu(priv->rxon_timing.atim_window));
+}
+EXPORT_SYMBOL(iwl_setup_rxon_timing);
+
 void iwl_set_rxon_hwcrypto(struct iwl_priv *priv, int hw_decrypt)
 {
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
@@ -1373,6 +1430,8 @@ int iwl_set_hw_params(struct iwl_priv *priv)
 		priv->hw_params.rx_buf_size = IWL_RX_BUF_SIZE_4K;
 	priv->hw_params.max_pkt_size = priv->hw_params.rx_buf_size - 256;
 
+	priv->hw_params.max_beacon_itrvl = IWL_MAX_UCODE_BEACON_INTERVAL;
+
 	if (priv->cfg->mod_params->disable_11n)
 		priv->cfg->sku &= ~IWL_SKU_N;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1e51891..03eef83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -572,6 +572,7 @@ extern void iwl_rx_reply_rx_phy(struct iwl_priv *priv,
 void iwl_rx_reply_compressed_ba(struct iwl_priv *priv,
 					   struct iwl_rx_mem_buffer *rxb);
 
+void iwl_setup_rxon_timing(struct iwl_priv *priv);
 static inline int iwl_send_rxon_assoc(struct iwl_priv *priv)
 {
 	return priv->cfg->ops->hcmd->rxon_assoc(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e8c8607..f9d05bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -626,6 +626,7 @@ struct iwl_hw_params {
 	u8  bcast_sta_id;
 	u8 fat_channel;
 	u8 sw_crypto;
+	u8  max_beacon_itrvl;	/* in 1024 ms */
 	u32 max_inst_size;
 	u32 max_data_size;
 	u32 max_bsm_size;
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4fac582..34f521c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -361,76 +361,6 @@ static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
-#define MAX_UCODE_BEACON_INTERVAL	1024
-#define INTEL_CONN_LISTEN_INTERVAL	cpu_to_le16(0xA)
-
-static __le16 iwl3945_adjust_beacon_interval(u16 beacon_val)
-{
-	u16 new_val = 0;
-	u16 beacon_factor = 0;
-
-	beacon_factor =
-	    (beacon_val + MAX_UCODE_BEACON_INTERVAL)
-		/ MAX_UCODE_BEACON_INTERVAL;
-	new_val = beacon_val / beacon_factor;
-
-	return cpu_to_le16(new_val);
-}
-
-static void iwl3945_setup_rxon_timing(struct iwl_priv *priv)
-{
-	u64 interval_tm_unit;
-	u64 tsf, result;
-	unsigned long flags;
-	struct ieee80211_conf *conf = NULL;
-	u16 beacon_int = 0;
-
-	conf = ieee80211_get_hw_conf(priv->hw);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->rxon_timing.timestamp = cpu_to_le64(priv->timestamp);
-	priv->rxon_timing.listen_interval = INTEL_CONN_LISTEN_INTERVAL;
-
-	tsf = priv->timestamp;
-
-	beacon_int = priv->beacon_int;
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	if (priv->iw_mode == NL80211_IFTYPE_STATION) {
-		if (beacon_int == 0) {
-			priv->rxon_timing.beacon_interval = cpu_to_le16(100);
-			priv->rxon_timing.beacon_init_val = cpu_to_le32(102400);
-		} else {
-			priv->rxon_timing.beacon_interval =
-				cpu_to_le16(beacon_int);
-			priv->rxon_timing.beacon_interval =
-			    iwl3945_adjust_beacon_interval(
-				le16_to_cpu(priv->rxon_timing.beacon_interval));
-		}
-
-		priv->rxon_timing.atim_window = 0;
-	} else {
-		priv->rxon_timing.beacon_interval =
-			iwl3945_adjust_beacon_interval(
-				priv->vif->bss_conf.beacon_int);
-		/* TODO: we need to get atim_window from upper stack
-		 * for now we set to 0 */
-		priv->rxon_timing.atim_window = 0;
-	}
-
-	interval_tm_unit =
-		(le16_to_cpu(priv->rxon_timing.beacon_interval) * 1024);
-	result = do_div(tsf, interval_tm_unit);
-	priv->rxon_timing.beacon_init_val =
-	    cpu_to_le32((u32) ((u64) interval_tm_unit - result));
-
-	IWL_DEBUG_ASSOC(priv,
-		"beacon interval %d beacon timer %d beacon tim %d\n",
-		le16_to_cpu(priv->rxon_timing.beacon_interval),
-		le32_to_cpu(priv->rxon_timing.beacon_init_val),
-		le16_to_cpu(priv->rxon_timing.atim_window));
-}
-
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
 				      struct iwl_cmd *cmd,
@@ -3084,7 +3014,7 @@ void iwl3945_post_associate(struct iwl_priv *priv)
 	iwlcore_commit_rxon(priv);
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-	iwl3945_setup_rxon_timing(priv);
+	iwl_setup_rxon_timing(priv);
 	rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (rc)
@@ -3279,7 +3209,7 @@ void iwl3945_config_ap(struct iwl_priv *priv)
 
 		/* RXON Timing */
 		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
-		iwl3945_setup_rxon_timing(priv);
+		iwl_setup_rxon_timing(priv);
 		rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 				      sizeof(priv->rxon_timing),
 				      &priv->rxon_timing);
-- 
1.6.3.3

