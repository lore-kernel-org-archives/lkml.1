Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbZA3JdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbZA3JdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZA3Jcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:32:51 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50444 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZA3Jcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:32:50 -0500
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in
	wb35_probe()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090129192423.GC31847@kroah.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
	 <20090126175115.GA29205@kroah.com> <497DFB04.1040802@cs.helsinki.fi>
	 <84144f020901261010h67958566lbd9ea240dc6d9ec@mail.gmail.com>
	 <20090129192423.GC31847@kroah.com>
Date: Fri, 30 Jan 2009 11:32:47 +0200
Message-Id: <1233307967.13655.30.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 11:24 -0800, Greg KH wrote:
> Hm, it doesn't apply to the latest -next tree, care to respin it?

Here you go:

>From 0d8febfea5c6f2a608584328771eba72df7c5806 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Fri, 30 Jan 2009 11:29:27 +0200
Subject: [PATCH] w35und: fix usb_control_msg() error handling in wb35_probe()

If successful, the usb_control_msg() function returns the number of
bytes transferred. Fix up wb35_probe() to only bail out if the function returns
a negative number. Also, fix up ieee80211_alloc_hw() error code to ENOMEM;
otherwise GCC complains that err might be undefined (and is right about that).

Acked-by: Pavel Machek <pavel@suse.cz>
Reported-and-tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 3f7d4e5..69b4ed0 100644
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
1.5.4.3



