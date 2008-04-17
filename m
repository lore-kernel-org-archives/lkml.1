Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYDQBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYDQBJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbYDQBGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:06:53 -0400
Received: from sous-sol.org ([216.99.217.87]:58768 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbYDQBGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:06:52 -0400
Message-Id: <20080417010315.860547821@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:30 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: USB: new quirk flag to avoid Set-Interface
Content-Disposition: inline; filename=usb-new-quirk-flag-to-avoid-set-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alan Stern <stern@rowland.harvard.edu>

upstream commit: 392e1d9817d0024c96aae237c3c4349e47c976fd

This patch (as1057) fixes a problem with the X-Rite/Gretag-Macbeth
Eye-One Pro display colorimeter; the device crashes when it receives a
Set-Interface request.  A new quirk (USB_QUIRK_NO_SET_INTF) is
introduced and a quirks entry is created for this device.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[chrisw@sous-sol.org: backport to 2.6.24.4]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/core/message.c |    5 ++++-
 drivers/usb/core/quirks.c  |    3 +++
 include/linux/usb/quirks.h |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1189,7 +1189,10 @@ int usb_set_interface(struct usb_device 
 		return -EINVAL;
 	}
 
-	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+	if (dev->quirks & USB_QUIRK_NO_SET_INTF)
+		ret = -EPIPE;
+	else
+		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 				   USB_REQ_SET_INTERFACE, USB_RECIP_INTERFACE,
 				   alternate, interface, NULL, 0, 5000);
 
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -39,6 +39,9 @@ static const struct usb_device_id usb_qu
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* X-Rite/Gretag-Macbeth Eye-One Pro display colorimeter */
+	{ USB_DEVICE(0x0971, 0x2000), .driver_info = USB_QUIRK_NO_SET_INTF },
+
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -9,3 +9,6 @@
 
 /* device can't resume correctly so reset it instead */
 #define USB_QUIRK_RESET_RESUME		0x00000002
+
+/* device can't handle Set-Interface requests */
+#define USB_QUIRK_NO_SET_INTF		0x00000004

-- 
