Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYJ3QMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYJ3QMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbYJ3QLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:11:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:7970 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbYJ3QLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=SH06ax5RRIVwqds6aoKwsuyJnt6ZJ3LkzkhkRmime9Ciw992p3XmVhtCjcKBG9DlS6
         d7724tdxRiFwB2cO2sa746r+GJ8jT1PKn4ZxCTWPDEAbCAOg1HlbJFLghqW1u90UndUA
         33f+32Z0Ej8DxEBjdI9Sm85869SoYym9HgyQg=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 4/7] w35und: move global wbsoft_enabled to struct wbsoft_priv
Date: Thu, 30 Oct 2008 18:12:04 +0200
Message-Id: <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparational step for moving packet_came() to wb35rx.c().

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h  |    2 ++
 drivers/staging/winbond/wbusb.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 64b73bb..c6dd223 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -39,6 +39,8 @@ struct wbsoft_priv {
 	struct iw_statistics iw_stats;
 
 	u8 LinkName[WB_MAX_LINK_NAME_LEN];
+
+	bool enabled;
 };
 
 #endif /* __WINBOND_CORE_H */
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 0f70101..246f20b 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -46,8 +46,6 @@ static struct ieee80211_supported_band wbsoft_band_2GHz = {
 	.n_bitrates	= ARRAY_SIZE(wbsoft_rates),
 };
 
-int wbsoft_enabled;
-
 static int wbsoft_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_if_init_conf *conf)
 {
@@ -129,8 +127,10 @@ static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 
 static int wbsoft_start(struct ieee80211_hw *dev)
 {
-	wbsoft_enabled = 1;
-	printk("wbsoft_start called\n");
+	struct wbsoft_priv *priv = dev->priv;
+
+	priv->enabled = true;
+
 	return 0;
 }
 
@@ -393,10 +393,11 @@ error:
 
 void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
 {
+	struct wbsoft_priv *priv = hw->priv;
 	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status = {0};
 
-	if (!wbsoft_enabled)
+	if (!priv->enabled)
 		return;
 
 	skb = dev_alloc_skb(PacketSize);
-- 
1.5.3.7

