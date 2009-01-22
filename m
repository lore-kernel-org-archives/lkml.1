Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbZAVKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbZAVKGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZAVKGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:06:36 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52504 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZAVKGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:06:35 -0500
Date: Thu, 22 Jan 2009 12:06:33 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] w35und: fix usb_control_msg() error handling in wb35_probe()
Message-ID: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

If successful, the usb_control_msg() function returns the number of
bytes transferred. Fix up wb35_probe() to only bail out if the function
returns a negative number.

Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbusb.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index fd5c8eb..7ced028 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -302,17 +302,19 @@ static int wb35_probe(struct usb_interface *intf,
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct wbsoft_priv *priv;
 	struct ieee80211_hw *dev;
-	int err;
+	int err, nr;
 
 	usb_get_dev(udev);
 
 	/* Check if the device has already been opened */
-	err = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			      0x01,
-			      USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
-			      0x0, 0x400, &ltmp, 4, HZ * 100);
-	if (err)
+	nr = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			     0x01,
+			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+			     0x0, 0x400, &ltmp, 4, HZ * 100);
+	if (nr < 0) {
+		err = nr;
 		goto error;
+	}
 
 	/* Is already initialized? */
 	ltmp = cpu_to_le32(ltmp);
-- 
1.5.6.4

