Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYJ2WvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYJ2WvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756062AbYJ2Woe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:34 -0400
Received: from kroah.org ([198.145.64.141]:43788 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756052AbYJ2Woa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:30 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/49] Staging: w35und: move supported band initialization out of wb35_probe()
Date: Wed, 29 Oct 2008 15:39:48 -0700
Message-Id: <1225320016-21803-21-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch moves the static struct ieee80211_supported_band initialization out
of w35_probe() because it's really global read-only configuration data.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 75213b5..bd708a2 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -32,6 +32,13 @@ static struct ieee80211_channel wbsoft_channels[] = {
 	{ .center_freq = 2412},
 };
 
+static struct ieee80211_supported_band wbsoft_band_2GHz = {
+	.channels	= wbsoft_channels,
+	.n_channels	= ARRAY_SIZE(wbsoft_channels),
+	.bitrates	= wbsoft_rates,
+	.n_bitrates	= ARRAY_SIZE(wbsoft_rates),
+};
+
 int wbsoft_enabled;
 struct ieee80211_hw *my_dev;
 struct wb35_adapter * my_adapter;
@@ -192,7 +199,6 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct wbsoft_priv *priv;
 	struct ieee80211_hw *dev;
-	static struct ieee80211_supported_band band;
 	int err;
 
 	usb_get_dev(udev);
@@ -253,12 +259,8 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	dev->channel_change_time = 1000;
 	dev->queues = 1;
 
-	band.channels = wbsoft_channels;
-	band.n_channels = ARRAY_SIZE(wbsoft_channels);
-	band.bitrates = wbsoft_rates;
-	band.n_bitrates = ARRAY_SIZE(wbsoft_rates);
+	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &wbsoft_band_2GHz;
 
-	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &band;
 	err = ieee80211_register_hw(dev);
 	if (err)
 		goto error_free_hw;
-- 
1.6.0.2

