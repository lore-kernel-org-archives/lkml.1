Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYJ3OOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYJ3OOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYJ3OOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:14:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:31037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbYJ3OOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=LVabXy6YK8c74Hh9VIAbBtUM/5tcSBu4e/Z2kqqBBifmsmCgHXlfZssEG7f0uWwZgd
         5/RXoTHARFFv9G01bKRJzGJNYFC2gF2xwTgB4kJj3fbmEPJ5dY0u06zNupmNcsvdMCfF
         0CVbiSaxj6yENZ6ua3yrHnoS567g4LiFuDPFM=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH] w35und: move struct wbsoft_priv to core.h and use it
Date: Thu, 30 Oct 2008 16:14:35 +0200
Message-Id: <1225376079-9592-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes my_adapter global variable from wbusb.c by adding a
->adapter member to struct wbsoft_priv.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h  |   10 ++++++++++
 drivers/staging/winbond/wbusb.c |   33 ++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 15 deletions(-)
 create mode 100644 drivers/staging/winbond/core.h

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
new file mode 100644
index 0000000..62ad954
--- /dev/null
+++ b/drivers/staging/winbond/core.h
@@ -0,0 +1,10 @@
+#ifndef __WINBOND_CORE_H
+#define __WINBOND_CORE_H
+
+#include "adapter.h"
+
+struct wbsoft_priv {
+	struct wb35_adapter *adapter;
+};
+
+#endif /* __WINBOND_CORE_H */
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 4af13a0..d8fa9e5 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -6,6 +6,7 @@
 #include <net/mac80211.h>
 #include <linux/usb.h>
 
+#include "core.h"
 #include "mlmetxrx_f.h"
 #include "wbhal_f.h"
 #include "wblinux_f.h"
@@ -45,7 +46,6 @@ static struct ieee80211_supported_band wbsoft_band_2GHz = {
 
 int wbsoft_enabled;
 struct ieee80211_hw *my_dev;
-struct wb35_adapter * my_adapter;
 
 static int wbsoft_add_interface(struct ieee80211_hw *dev,
 				 struct ieee80211_if_init_conf *conf)
@@ -118,7 +118,9 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 
 static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	MLMESendFrame(my_adapter, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
+	struct wbsoft_priv *priv = dev->priv;
+
+	MLMESendFrame(priv->adapter, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
 
 	return NETDEV_TX_OK;
 }
@@ -133,6 +135,8 @@ static int wbsoft_start(struct ieee80211_hw *dev)
 
 static int wbsoft_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
+	struct wbsoft_priv *priv = dev->priv;
+
 	ChanInfo ch;
 	printk("wbsoft_config called\n");
 
@@ -140,20 +144,20 @@ static int wbsoft_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 	ch.ChanNo = 1;	/* Should use channel_num, or something, as that is already pre-translated */
 
 
-	hal_set_current_channel(&my_adapter->sHwData, ch);
-	hal_set_beacon_period(&my_adapter->sHwData, conf->beacon_int);
-//	hal_set_cap_info(&my_adapter->sHwData, ?? );
+	hal_set_current_channel(&priv->adapter->sHwData, ch);
+	hal_set_beacon_period(&priv->adapter->sHwData, conf->beacon_int);
+//	hal_set_cap_info(&priv->adapter->sHwData, ?? );
 // hal_set_ssid(phw_data_t pHwData,  u8 * pssid,  u8 ssid_len); ??
-	hal_set_accept_broadcast(&my_adapter->sHwData, 1);
-	hal_set_accept_promiscuous(&my_adapter->sHwData,  1);
-	hal_set_accept_multicast(&my_adapter->sHwData,  1);
-	hal_set_accept_beacon(&my_adapter->sHwData,  1);
-	hal_set_radio_mode(&my_adapter->sHwData,  0);
+	hal_set_accept_broadcast(&priv->adapter->sHwData, 1);
+	hal_set_accept_promiscuous(&priv->adapter->sHwData,  1);
+	hal_set_accept_multicast(&priv->adapter->sHwData,  1);
+	hal_set_accept_beacon(&priv->adapter->sHwData,  1);
+	hal_set_radio_mode(&priv->adapter->sHwData,  0);
 	//hal_set_antenna_number(  phw_data_t pHwData, u8 number )
 	//hal_set_rf_power(phw_data_t pHwData, u8 PowerIndex)
 
 
-//	hal_start_bss(&my_adapter->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);	??
+//	hal_start_bss(&priv->adapter->sHwData, WLAN_BSSTYPE_INFRASTRUCTURE);	??
 
 //void hal_set_rates(phw_data_t pHwData, u8 * pbss_rates,
 //		   u8 length, unsigned char basic_rate_set)
@@ -190,9 +194,6 @@ static const struct ieee80211_ops wbsoft_ops = {
 // conf_tx: hal_set_cwmin()/hal_set_cwmax;
 };
 
-struct wbsoft_priv {
-};
-
 static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 {
 	struct wb35_adapter *adapter;
@@ -226,7 +227,6 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 		goto error;
 	}
 
-	my_adapter = adapter;
 	pWbUsb = &adapter->sHwData.WbUsb;
 	pWbUsb->udev = udev;
 
@@ -247,6 +247,9 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (!dev)
 		goto error_free_adapter;
 
+	priv = dev->priv;
+	priv->adapter = adapter;
+
 	my_dev = dev;
 
 	SET_IEEE80211_DEV(dev, &udev->dev);
-- 
1.5.3.7

