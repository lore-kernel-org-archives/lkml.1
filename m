Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYKLAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYKLAhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYKLA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:42 -0500
Received: from kroah.org ([198.145.64.141]:42466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753721AbYKLA0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:40 -0500
Date: Tue, 11 Nov 2008 16:23:56 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
       Zhu Yi <yi.zhu@intel.com>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 30/49] iwlwifi: remove HT flags from RXON when not in HT
	anymore
Message-ID: <20081112002356.GE10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-remove-ht-flags-from-rxon-when-not-in-ht-anymore.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 42eb7c644afcdbcd7eac4d862046230856fbf531 upstream.

This patch removes the HT flags from RXON when moving from HT to legacy.
This avoids keeping those flags set and possibly miss configuring firmware.

If we are configured in HT, fat channel: channel 1 above, and move later
to legacy channel 11, we need to clear the FAT channel control flags in
RXON. If we don't, the firmware will understand this as channel 11 above
which is not possible due to regulatory constraints, leading to firmware
crash.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    3 +--
 drivers/net/wireless/iwlwifi/iwl-core.c |    8 +++++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2504,8 +2504,7 @@ static void iwl4965_post_associate(struc
 
 	priv->staging_rxon.filter_flags |= RXON_FILTER_ASSOC_MSK;
 
-	if (priv->current_ht_config.is_ht)
-		iwl_set_rxon_ht(priv, &priv->current_ht_config);
+	iwl_set_rxon_ht(priv, &priv->current_ht_config);
 
 	iwl_set_rxon_chain(priv);
 	priv->staging_rxon.assoc_id = cpu_to_le16(priv->assoc_id);
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -646,8 +646,14 @@ void iwl_set_rxon_ht(struct iwl_priv *pr
 	struct iwl_rxon_cmd *rxon = &priv->staging_rxon;
 	u32 val;
 
-	if (!ht_info->is_ht)
+	if (!ht_info->is_ht) {
+		rxon->flags &= ~(RXON_FLG_CHANNEL_MODE_MIXED_MSK |
+			RXON_FLG_CHANNEL_MODE_PURE_40_MSK |
+			RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK |
+			RXON_FLG_FAT_PROT_MSK |
+			RXON_FLG_HT_PROT_MSK);
 		return;
+	}
 
 	/* Set up channel bandwidth:  20 MHz only, or 20/40 mixed if fat ok */
 	if (iwl_is_fat_tx_allowed(priv, NULL))

-- 
