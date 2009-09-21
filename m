Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZIUJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZIUJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZIUJwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:52:14 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59758 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIUJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:52:13 -0400
Subject: [PATCH 1/2] w35und: Fix ->beacon_int breakage
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, jbenc@suse.cz, jkosina@suse.cz, johannes@sipsolutions.net,
       pavel@ucw.cz, sandro.bonazzola@gmail.com
Date: Mon, 21 Sep 2009 12:52:15 +0300
Message-Id: <1253526735.5216.7.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Commit f424afa17899408cbd267a4c4534ca6fc9d8f71c ("mac80211: remove
deprecated API") removed ->beacon_int from struct ieee80211_conf. Fix
breakage in w35und by setting beacon period in ->add_interface to
bss_conf.beacon_int.

Cc: Greg KH <greg@kroah.com>
Cc: Jiri Benc <jbenc@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 8950724..ee6425e 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -51,10 +51,26 @@ static struct ieee80211_supported_band wbsoft_band_2GHz = {
 	.n_bitrates	= ARRAY_SIZE(wbsoft_rates),
 };
 
+static void hal_set_beacon_period(struct hw_data *pHwData, u16 beacon_period)
+{
+	u32 tmp;
+
+	if (pHwData->SurpriseRemove)
+		return;
+
+	pHwData->BeaconPeriod = beacon_period;
+	tmp = pHwData->BeaconPeriod << 16;
+	tmp |= pHwData->ProbeDelay;
+	Wb35Reg_Write(pHwData, 0x0848, tmp);
+}
+
 static int wbsoft_add_interface(struct ieee80211_hw *dev,
 				struct ieee80211_if_init_conf *conf)
 {
-	printk("wbsoft_add interface called\n");
+	struct wbsoft_priv *priv = dev->priv;
+
+	hal_set_beacon_period(&priv->sHwData, conf->vif->bss_conf.beacon_int);
+
 	return 0;
 }
 
@@ -138,19 +154,6 @@ static void hal_set_radio_mode(struct hw_data *pHwData, unsigned char radio_off)
 	Wb35Reg_Write(pHwData, 0x0824, reg->M24_MacControl);
 }
 
-static void hal_set_beacon_period(struct hw_data *pHwData, u16 beacon_period)
-{
-	u32 tmp;
-
-	if (pHwData->SurpriseRemove)
-		return;
-
-	pHwData->BeaconPeriod = beacon_period;
-	tmp = pHwData->BeaconPeriod << 16;
-	tmp |= pHwData->ProbeDelay;
-	Wb35Reg_Write(pHwData, 0x0848, tmp);
-}
-
 static void
 hal_set_current_channel_ex(struct hw_data *pHwData, ChanInfo channel)
 {
@@ -244,7 +247,6 @@ static void hal_set_accept_beacon(struct hw_data *pHwData, u8 enable)
 static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct wbsoft_priv *priv = dev->priv;
-	struct ieee80211_conf *conf = &dev->conf;
 	ChanInfo ch;
 
 	printk("wbsoft_config called\n");
@@ -254,7 +256,6 @@ static int wbsoft_config(struct ieee80211_hw *dev, u32 changed)
 	ch.ChanNo = 1;
 
 	hal_set_current_channel(&priv->sHwData, ch);
-	hal_set_beacon_period(&priv->sHwData, conf->beacon_int);
 	hal_set_accept_broadcast(&priv->sHwData, 1);
 	hal_set_accept_promiscuous(&priv->sHwData, 1);
 	hal_set_accept_multicast(&priv->sHwData, 1);
-- 
1.5.6.3



