Return-Path: <linux-kernel-owner+w=401wt.eu-S934488AbZLGA2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488AbZLGA2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934465AbZLGA2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:28:36 -0500
Received: from kroah.org ([198.145.64.141]:34400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758375AbZLGANG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:48 2009
Message-Id: <20091207000648.772808584@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>, wey-yi.w.guy@intel.com,
       linville@tuxdriver.com
Subject: [048/119] iwlwifi: Use RTS/CTS as the preferred protection mechanism for 6000 series
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-use-rts-cts-as-the-preferred-protection-mechanism-for-6000-series.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 73871f7181a1406c67e93c8c83f5edb26057a2a6 upstream

When 802.11g was introduced, we had RTS/CTS and CTS-to-Self protection
mechanisms. In an HT Beacon, HT stations use the "Operating Mode" field
in the HT Information Element to determine whether or not to use
protection.

The Operating Mode field has 4 possible settings: 0-3:
Mode 0: If all stations in the BSS are 20/40 MHz HT capable, or if the
BSS is 20/40 MHz capable, or if all stations in the BSS are 20 MHz HT
stations in a 20 MHz BSS
Mode 1: used if there are non-HT stations or APs using the primary or
secondary channels
Mode 2: if only HT stations are associated in the BSS and at least one
20 MHz HT station is associated.
Mode 3: used if one or more non-HT stations are associated in the BSS.

When in operating modes 1 or 3, and the Use_Protection field is 1 in the
Beacon's ERP IE, all HT transmissions must be protected using RTS/CTS or
CTS-to-Self.

By default, CTS-to-self is the preferred protection mechanism for less
overhead and higher throughput; but using the full RTS/CTS will better
protect the inner exchange from interference, especially in
highly-congested environment.

For 6000 series WIFI NIC, RTS/CTS protection mechanism is the
recommended choice for HT traffic based on the HW design.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |   10 +++++++---
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 ++
 4 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -109,6 +109,7 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.need_pll_cfg = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -127,6 +128,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.need_pll_cfg = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -145,6 +147,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.need_pll_cfg = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -163,6 +166,7 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.need_pll_cfg = false,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
 	.shadow_ram_support = true,
+	.use_rts_for_ht = true, /* use rts/cts protection */
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -115,9 +115,6 @@ int iwl_commit_rxon(struct iwl_priv *pri
 
 	/* always get timestamp with Rx frame */
 	priv->staging_rxon.flags |= RXON_FLG_TSF2HOST_MSK;
-	/* allow CTS-to-self if possible. this is relevant only for
-	 * 5000, but will not damage 4965 */
-	priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
 
 	ret = iwl_check_rxon_cmd(priv);
 	if (ret) {
@@ -217,6 +214,13 @@ int iwl_commit_rxon(struct iwl_priv *pri
 					"Could not send WEP static key.\n");
 		}
 
+		/*
+		 * allow CTS-to-self if possible for new association.
+		 * this is relevant only for 5000 series and up,
+		 * but will not damage 4965
+		 */
+		priv->staging_rxon.flags |= RXON_FLG_SELF_CTS_EN;
+
 		/* Apply the new configuration
 		 * RXON assoc doesn't clear the station table in uCode,
 		 */
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -415,6 +415,15 @@ static void rs_tl_turn_on_agg(struct iwl
 	else if (tid == IWL_AGG_ALL_TID)
 		for (tid = 0; tid < TID_MAX_LOAD_COUNT; tid++)
 			rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
+	if (priv->cfg->use_rts_for_ht) {
+		/*
+		 * switch to RTS/CTS if it is the prefer protection method
+		 * for HT traffic
+		 */
+		IWL_DEBUG_HT(priv, "use RTS/CTS protection for HT\n");
+		priv->staging_rxon.flags &= ~RXON_FLG_SELF_CTS_EN;
+		iwlcore_commit_rxon(priv);
+	}
 }
 
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -209,6 +209,7 @@ struct iwl_mod_params {
  * @ucode_api_min: Lowest version of uCode API supported by driver.
  * @max_ll_items: max number of OTP blocks
  * @shadow_ram_support: shadow support for OTP memory
+ * @use_rts_for_ht: use rts/cts protection for HT traffic
  *
  * We enable the driver to be backward compatible wrt API version. The
  * driver specifies which APIs it supports (with @ucode_api_max being the
@@ -247,6 +248,7 @@ struct iwl_cfg {
 	bool use_isr_legacy;
 	const u16 max_ll_items;
 	const bool shadow_ram_support;
+	bool use_rts_for_ht;
 };
 
 /***************************


