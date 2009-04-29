Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZD2Til@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZD2Til (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZD2Tib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:38:31 -0400
Received: from mail.tpi.com ([70.99.223.143]:1978 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbZD2Tib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:38:31 -0400
To: greg@kroah.com
Subject: [GIT]: staging - mac80211 - unify config_interface and bss_info_changed
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090429193821.305DAF88CE@sepang.rtg.net>
Date: Wed, 29 Apr 2009 13:38:21 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I did a build test to make sure things at least compile. checkpatch is fine
with these patches, but the drivers clearly have other formatting issues.

Lemme know if you have any problems.

rtg

The following changes since commit 789a03102c542f34ae831a3aa8af37c6538449e3:
  Stephen Rothwell (1):
        Add linux-next specific files for 20090429

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/linux-next staging-for-gregkh

Tim Gardner (3):
      staging: winbond: mac80211 - unify config_interface and bss_info_changed
      staging: agnx: mac80211 - unify config_interface and bss_info_changed
      staging: stlc45xx: mac80211 - unify config_interface and bss_info_changed

 drivers/staging/agnx/pci.c          |   17 +++++++++--------
 drivers/staging/stlc45xx/stlc45xx.c |   28 +++++++++-------------------
 drivers/staging/winbond/wbusb.c     |    9 ---------
 3 files changed, 18 insertions(+), 36 deletions(-)

>From a86a4c50b3ea4bfb59ef0b2b410b173f8b164e32 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 29 Apr 2009 11:43:57 -0600
Subject: [PATCH] staging: winbond: mac80211 - unify config_interface and bss_info_changed

The commit 'mac80211: unify config_interface and bss_info_changed' from
Johannes Berg <johannes@sipsolutions.net> removed the config_interface structure
tag from struct ieee80211_ops. The BSSID detection functionality migrated to
ieee80211_ops.bss_info_changed.

Since wbsoft_config_interface() was largely empty, there wasn't much to do
other then to remove the function itself. There is currently no support
for BSSID change detection.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/winbond/wbusb.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index c46ff47..745279c 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -264,14 +264,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
-static int wbsoft_config_interface(struct ieee80211_hw *dev,
-				   struct ieee80211_vif *vif,
-				   struct ieee80211_if_conf *conf)
-{
-	printk("wbsoft_config_interface called\n");
-	return 0;
-}
-
 static u64 wbsoft_get_tsf(struct ieee80211_hw *dev)
 {
 	printk("wbsoft_get_tsf called\n");
@@ -285,7 +277,6 @@ static const struct ieee80211_ops wbsoft_ops = {
 	.add_interface		= wbsoft_add_interface,
 	.remove_interface	= wbsoft_remove_interface,
 	.config			= wbsoft_config,
-	.config_interface	= wbsoft_config_interface,
 	.configure_filter	= wbsoft_configure_filter,
 	.get_stats		= wbsoft_get_stats,
 	.get_tx_stats		= wbsoft_get_tx_stats,
-- 
1.5.6.3


>From 4c018c21ce053262557d2273f6419be678e01820 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 29 Apr 2009 12:52:02 -0600
Subject: [PATCH] staging: agnx: mac80211 - unify config_interface and bss_info_changed

The commit 'mac80211: unify config_interface and bss_info_changed' from
Johannes Berg <johannes@sipsolutions.net> removed the config_interface structure
tag from struct ieee80211_ops. The BSSID detection functionality migrated to
ieee80211_ops.bss_info_changed.

Renamed agnx_config_interface() to agnc_bss_info_changed() with suitable
refactoring.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/agnx/pci.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 61b15fa..f078b98 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -302,9 +302,10 @@ static int agnx_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
-static int agnx_config_interface(struct ieee80211_hw *dev,
+static void agnx_bss_info_changed(struct ieee80211_hw *dev,
 				 struct ieee80211_vif *vif,
-				 struct ieee80211_if_conf *conf)
+				 struct ieee80211_bss_conf *info,
+				 u32 changes)
 {
 	struct agnx_priv *priv = dev->priv;
 	void __iomem *ctl = priv->ctl;
@@ -312,17 +313,17 @@ static int agnx_config_interface(struct ieee80211_hw *dev,
 
 	spin_lock(&priv->lock);
 
-	if (memcmp(conf->bssid, priv->bssid, ETH_ALEN)) {
-		agnx_set_bssid(priv, conf->bssid);
-		memcpy(priv->bssid, conf->bssid, ETH_ALEN);
-		hash_write(priv, conf->bssid, BSSID_STAID);
+	if ((changes & BSS_CHANGED_BSSID) ||
+		memcmp(info->bssid, priv->bssid, ETH_ALEN)) {
+		agnx_set_bssid(priv, info->bssid);
+		memcpy(priv->bssid, info->bssid, ETH_ALEN);
+		hash_write(priv, info->bssid, BSSID_STAID);
 		sta_init(priv, BSSID_STAID);
 		/* FIXME needed? */
 		sta_power_init(priv, BSSID_STAID);
 		agnx_write32(ctl, AGNX_BM_MTSM, 0xff & ~0x1);
 	}
 	spin_unlock(&priv->lock);
-	return 0;
 } /* agnx_config_interface */
 
 
@@ -421,7 +422,7 @@ static struct ieee80211_ops agnx_ops = {
 	.add_interface		= agnx_add_interface,
 	.remove_interface	= agnx_remove_interface,
 	.config			= agnx_config,
-	.config_interface	= agnx_config_interface,
+	.bss_info_changed	= agnx_bss_info_changed,
 	.configure_filter	= agnx_configure_filter,
 	.get_stats		= agnx_get_stats,
 	.get_tx_stats		= agnx_get_tx_stats,
-- 
1.5.6.3


>From de7452482673977c8f526997dbf033e78117ffd1 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Wed, 29 Apr 2009 13:02:18 -0600
Subject: [PATCH] staging: stlc45xx: mac80211 - unify config_interface and bss_info_changed

The commit 'mac80211: unify config_interface and bss_info_changed' from
Johannes Berg <johannes@sipsolutions.net> removed the config_interface structure
tag from struct ieee80211_ops. The BSSID detection functionality migrated to
ieee80211_ops.bss_info_changed.

Merged BSSID change detection from stlc45xx_op_config_interface()
into stlc45xx_op_bss_info_changed() and removed stlc45xx_op_config_interface().
Also added missing mutex locking to stlc45xx_op_bss_info_changed().

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/staging/stlc45xx/stlc45xx.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index cfdaac9..32b2354 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -2235,24 +2235,6 @@ static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 }
 
-static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct ieee80211_if_conf *conf)
-{
-	struct stlc45xx *stlc = hw->priv;
-
-	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
-
-	mutex_lock(&stlc->mutex);
-
-	memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
-	stlc45xx_tx_setup(stlc);
-
-	mutex_unlock(&stlc->mutex);
-
-	return 0;
-}
-
 static int stlc45xx_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct stlc45xx *stlc = hw->priv;
@@ -2295,6 +2277,8 @@ static void stlc45xx_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct stlc45xx *stlc = hw->priv;
 
+	mutex_lock(&stlc->mutex);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		stlc->associated = info->assoc;
 		if (info->assoc)
@@ -2307,6 +2291,13 @@ static void stlc45xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			stlc45xx_tx_nullfunc(stlc, stlc->psm);
 		}
 	}
+
+	if (changed & BSS_CHANGED_BSSID) {
+			memcpy(stlc->bssid, info->bssid, ETH_ALEN);
+			stlc45xx_tx_setup(stlc);
+	}
+
+	mutex_unlock(&stlc->mutex);
 }
 
 
@@ -2357,7 +2348,6 @@ static const struct ieee80211_ops stlc45xx_ops = {
 	.add_interface = stlc45xx_op_add_interface,
 	.remove_interface = stlc45xx_op_remove_interface,
 	.config = stlc45xx_op_config,
-	.config_interface = stlc45xx_op_config_interface,
 	.configure_filter = stlc45xx_op_configure_filter,
 	.tx = stlc45xx_op_tx,
 	.bss_info_changed = stlc45xx_op_bss_info_changed,
-- 
1.5.6.3

