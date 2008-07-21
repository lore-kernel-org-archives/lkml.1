Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbYGUSCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbYGUSCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYGUSCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:02:16 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37731 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYGUSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:02:15 -0400
Subject: [PATCH] pegasus: Add blacklist support to fix Belkin bluetooth
 dongle.
From: Ben Collins <ben.collins@canonical.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: linux-usb@vger.kernel.org
Content-Type: text/plain
Organization: Canonical
Date: Mon, 21 Jul 2008 14:02:16 -0400
Message-Id: <1216663336.7585.162.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reference: https://launchpad.net/bugs/140511
    
The Belkin bluetooth dongle unfortunately shares the vendor and device
id with the network adapter which causes lockups whenever the bluetooth
dongle is inserted.
    
CC: linux-usb@vger.kernel.org
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Ben Collins <ben.collins@canonical.com>

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index b588c89..a84ba48 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -1285,6 +1285,21 @@ static void check_carrier(struct work_struct *work)
 	}
 }
 
+static int pegasus_blacklisted(struct usb_device *udev)
+{
+	struct usb_device_descriptor *udd = &udev->descriptor;
+
+	/* Special quirk to keep the driver from handling the Belkin Bluetooth
+	 * dongle which happens to have the same ID.
+	 */
+	if ((udd->idVendor == VENDOR_BELKIN && udd->idProduct == 0x0121) &&
+	    (udd->bDeviceClass == USB_CLASS_WIRELESS_CONTROLLER) &&
+	    (udd->bDeviceProtocol == 1))
+		return 1;
+
+	return 0;
+}
+
 static int pegasus_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1296,6 +1311,12 @@ static int pegasus_probe(struct usb_interface *intf,
 	DECLARE_MAC_BUF(mac);
 
 	usb_get_dev(dev);
+
+	if (pegasus_blacklisted(dev)) {
+		res = -ENODEV;
+		goto out;
+	}
+
 	net = alloc_etherdev(sizeof(struct pegasus));
 	if (!net) {
 		dev_err(&intf->dev, "can't allocate %s\n", "device");


