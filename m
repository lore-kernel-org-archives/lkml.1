Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYJWXfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYJWXfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYJWXfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:35:04 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:44693 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbYJWXfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:35:03 -0400
Message-ID: <49010A25.6020702@lwfinger.net>
Date: Thu, 23 Oct 2008 16:35:01 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] usbcore: Limit number of 'unable to enumerate USB device'
 messages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my system, a number of messages that state "unable to enumerate USB device"
are logged. These are intermittent and likely due to some race condition
at bootup.

Some of these happen when the EHCI driver is loaded after UHCI or OHCI, which
causes the device to be switched away from the other controller that's trying
to enumerate it, at least momentarily. This type of message is logged at most
once for each hub and occurs in about 70% of my reboots.

A more insidious form of the message occurs hundreds of times in about 10% of
reboots. They continue until the system is rebooted. This patch limits the
number of these messages to 20. Once the actual cause of this message is
located, this patch can be reverted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hub.c
+++ linux-2.6/drivers/usb/core/hub.c
@@ -2746,6 +2746,7 @@ static void hub_port_connect_change(stru
 			le16_to_cpu(hub->descriptor->wHubCharacteristics);
 	struct usb_device *udev;
 	int status, i;
+	static int enum_count;

 	dev_dbg (hub_dev,
 		"port %d, status %04x, change %04x, %s\n",
@@ -2945,8 +2946,9 @@ loop:
 	if (hub->hdev->parent ||
 			!hcd->driver->port_handed_over ||
 			!(hcd->driver->port_handed_over)(hcd, port1))
-		dev_err(hub_dev, "unable to enumerate USB device on port %d\n",
-				port1);
+		if (enum_count++ < 20)
+			dev_err(hub_dev, "unable to enumerate USB device on "
+				"port %d\n", port1);

 done:
 	hub_port_disable(hub, port1, 1);


