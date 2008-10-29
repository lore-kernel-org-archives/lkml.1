Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYJ2Wrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYJ2Wrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbYJ2WoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:25 -0400
Received: from kroah.org ([198.145.64.141]:43760 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755652AbYJ2WoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:16 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/49] Staging: w35und: wb35_probe() cleanup
Date: Wed, 29 Oct 2008 15:39:39 -0700
Message-Id: <1225320016-21803-12-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fix error handling in wb35_probe() function and clean it up a bit.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c |  102 ++++++++++++++------------------
 1 files changed, 45 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 5f09fd4..c1c2642 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -191,26 +191,33 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	PWBUSB		pWbUsb;
         struct usb_host_interface *interface;
 	struct usb_endpoint_descriptor *endpoint;
-	int	ret = -1;
 	u32	ltmp;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	struct wbsoft_priv *priv;
+	struct ieee80211_hw *dev;
+	static struct ieee80211_supported_band band;
+	int err;
 
 	usb_get_dev(udev);
 
-	printk("[w35und]wb35_probe ->\n");
-
 	// 20060630.2 Check the device if it already be opened
-	ret = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
+	err = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
 			      0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
 			      0x0, 0x400, &ltmp, 4, HZ*100 );
-	if (ret < 0)
+	if (err)
 		goto error;
 
 	ltmp = cpu_to_le32(ltmp);
-	if (ltmp)  // Is already initialized?
+	if (ltmp) {  // Is already initialized?
+		err = -EBUSY;
 		goto error;
+	}
 
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	if (!adapter) {
+		err = -ENOMEM;
+		goto error;
+	}
 
 	my_adapter = adapter;
 	pWbUsb = &adapter->sHwData.WbUsb;
@@ -225,69 +232,50 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	if (!WbWLanInitialize(adapter)) {
-		printk("[w35und]WbWLanInitialize fail\n");
-		goto error;
+		err = -EINVAL;
+		goto error_free_adapter;
 	}
 
-	{
-		struct wbsoft_priv *priv;
-		struct ieee80211_hw *dev;
-		static struct ieee80211_supported_band band;
-		int res;
-
-		dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
-
-		if (!dev) {
-			printk("w35und: ieee80211 alloc failed\n" );
-			BUG();
-		}
-
-		my_dev = dev;
-
-		SET_IEEE80211_DEV(dev, &udev->dev);
-		{
-			phw_data_t pHwData = &adapter->sHwData;
-			unsigned char		dev_addr[MAX_ADDR_LEN];
-			hal_get_permanent_address(pHwData, dev_addr);
-			SET_IEEE80211_PERM_ADDR(dev, dev_addr);
-		}
-
-
-		dev->extra_tx_headroom = 12;	/* FIXME */
-		dev->flags = 0;
+	dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
+	if (!dev)
+		goto error_free_adapter;
 
-		dev->channel_change_time = 1000;
-//		dev->max_rssi = 100;
+	my_dev = dev;
 
-		dev->queues = 1;
+	SET_IEEE80211_DEV(dev, &udev->dev);
+	{
+		phw_data_t pHwData = &adapter->sHwData;
+		unsigned char dev_addr[MAX_ADDR_LEN];
+		hal_get_permanent_address(pHwData, dev_addr);
+		SET_IEEE80211_PERM_ADDR(dev, dev_addr);
+	}
 
-		band.channels = wbsoft_channels;
-		band.n_channels = ARRAY_SIZE(wbsoft_channels);
-		band.bitrates = wbsoft_rates;
-		band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
+	dev->extra_tx_headroom = 12;	/* FIXME */
+	dev->flags = 0;
 
-		dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
-#if 0
-		wbsoft_modes[0].num_channels = 1;
-		wbsoft_modes[0].channels = wbsoft_channels;
-		wbsoft_modes[0].mode = MODE_IEEE80211B;
-		wbsoft_modes[0].num_rates = ARRAY_SIZE(wbsoft_rates);
-		wbsoft_modes[0].rates = wbsoft_rates;
+	dev->channel_change_time = 1000;
+	dev->queues = 1;
 
-		res = ieee80211_register_hwmode(dev, &wbsoft_modes[0]);
-		BUG_ON(res);
-#endif
+	band.channels = wbsoft_channels;
+	band.n_channels = ARRAY_SIZE(wbsoft_channels);
+	band.bitrates = wbsoft_rates;
+	band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
 
-		res = ieee80211_register_hw(dev);
-		BUG_ON(res);
-	}
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
+	err = ieee80211_register_hw(dev);
+	if (err)
+		goto error_free_hw;
 
-	usb_set_intfdata( intf, adapter );
+	usb_set_intfdata(intf, adapter);
 
-	printk("[w35und] _probe OK\n");
 	return 0;
+
+error_free_hw:
+	ieee80211_free_hw(dev);
+error_free_adapter:
+	kfree(adapter);
 error:
-	return -ENOMEM;
+	return err;
 }
 
 void packet_came(char *pRxBufferAddress, int PacketSize)
-- 
1.6.0.2

