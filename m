Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbZELLXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbZELLXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbZELLX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:23:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:36168 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218AbZELLXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:23:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xEoT0NglT2hHaj/LaTD9AAl3xuIsWvIAqvnjL+cb3mXEmf8Ss3xTQCYfGXQ+byEtzW
         BauHSylHZ1uXl0g+12UYFKzzyDDQ2iU2uEGFU7pr+3UKcg6B5lGUyZHeR+KDnbJkY5f/
         1X3jLVt31S5Oj8jTr3Zz/8AR1h7oOQERaE3SQ=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: johannes@sipsolutions.net, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: agnx: switch config_interface to bss_info_changed
Date: Tue, 12 May 2009 15:23:13 +0400
Message-Id: <1242127393-4298-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/staging/agnx/pci.c: In function 'agnx_config_interface':
drivers/staging/agnx/pci.c:315: error: dereferencing pointer to incomplete type
..
drivers/staging/agnx/pci.c:424: error: unknown field 'config_interface' specified in initializer

config_interface was removed in 2d0ddec5b2b
("mac80211: unify config_interface and bss_info_changed")

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/agnx/pci.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/agnx/pci.c b/drivers/staging/agnx/pci.c
index 61b15fa..0df7d43 100644
--- a/drivers/staging/agnx/pci.c
+++ b/drivers/staging/agnx/pci.c
@@ -302,14 +302,18 @@ static int agnx_config(struct ieee80211_hw *dev, u32 changed)
 	return 0;
 }
 
-static int agnx_config_interface(struct ieee80211_hw *dev,
-				 struct ieee80211_vif *vif,
-				 struct ieee80211_if_conf *conf)
+static void agnx_bss_info_changed(struct ieee80211_hw *dev,
+				  struct ieee80211_vif *vif,
+				  struct ieee80211_bss_conf *conf,
+				  u32 changed)
 {
 	struct agnx_priv *priv = dev->priv;
 	void __iomem *ctl = priv->ctl;
 	AGNX_TRACE;
 
+	if (!(changed & BSS_CHANGED_BSSID))
+		return;
+
 	spin_lock(&priv->lock);
 
 	if (memcmp(conf->bssid, priv->bssid, ETH_ALEN)) {
@@ -322,8 +326,7 @@ static int agnx_config_interface(struct ieee80211_hw *dev,
 		agnx_write32(ctl, AGNX_BM_MTSM, 0xff & ~0x1);
 	}
 	spin_unlock(&priv->lock);
-	return 0;
-} /* agnx_config_interface */
+} /* agnx_bss_info_changed */
 
 
 static void agnx_configure_filter(struct ieee80211_hw *dev,
@@ -421,7 +424,7 @@ static struct ieee80211_ops agnx_ops = {
 	.add_interface		= agnx_add_interface,
 	.remove_interface	= agnx_remove_interface,
 	.config			= agnx_config,
-	.config_interface	= agnx_config_interface,
+	.bss_info_changed	= agnx_bss_info_changed,
 	.configure_filter	= agnx_configure_filter,
 	.get_stats		= agnx_get_stats,
 	.get_tx_stats		= agnx_get_tx_stats,
-- 
1.6.3

