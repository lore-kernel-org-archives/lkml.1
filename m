Return-Path: <linux-kernel-owner+w=401wt.eu-S1761601AbZB0Wwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761601AbZB0Wwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbZB0WvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:51:24 -0500
Received: from kroah.org ([198.145.64.141]:53527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758833AbZB0WvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:51:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 5/5] Staging: w35und: fix usb_control_msg() error handling in wb35_probe()
Date: Fri, 27 Feb 2009 14:49:22 -0800
Message-Id: <1235774963-19732-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090227224555.GB19545@kroah.com>
References: <20090227224555.GB19545@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If successful, the usb_control_msg() function returns the number of
bytes transferred. Fix up wb35_probe() to only bail out if the function returns
a negative number. Also, fix up ieee80211_alloc_hw() error code to ENOMEM;
otherwise GCC complains that err might be undefined (and is right about that).

Acked-by: Pavel Machek <pavel@suse.cz>
Reported-and-tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/wbusb.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 49f1bf0..f716b2e 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -319,16 +319,18 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct wbsoft_priv *priv;
 	struct ieee80211_hw *dev;
-	int err;
+	int nr, err;
 
 	usb_get_dev(udev);
 
 	// 20060630.2 Check the device if it already be opened
-	err = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
-			      0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
-			      0x0, 0x400, &ltmp, 4, HZ*100 );
-	if (err)
+	nr = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
+			     0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
+			     0x0, 0x400, &ltmp, 4, HZ*100 );
+	if (nr < 0) {
+		err = nr;
 		goto error;
+	}
 
 	ltmp = cpu_to_le32(ltmp);
 	if (ltmp) {  // Is already initialized?
@@ -337,8 +339,10 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &wbsoft_ops);
-	if (!dev)
+	if (!dev) {
+		err = -ENOMEM;
 		goto error;
+	}
 
 	priv = dev->priv;
 
-- 
1.6.0.2

