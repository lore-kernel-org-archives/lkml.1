Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbYJVRr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbYJVRr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758094AbYJVRgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:36:40 -0400
Received: from kroah.org ([198.145.64.141]:50462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758089AbYJVRgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:36:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/42] Staging: w35und: module init cleanup
Date: Wed, 22 Oct 2008 10:29:20 -0700
Message-Id: <1224696563-5170-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081022172203.GA4000@kroah.com>
References: <20081022172203.GA4000@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch cleans up the module init functions a bit and removes the redundant
device ID check from wb35_probe() function.

Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c |   87 ++++++++++++---------------------
 1 files changed, 31 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index e09b272..fb216de 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -6,36 +6,23 @@
 #include "sysdef.h"
 #include <net/mac80211.h>
 
-
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.1");
 
-
-//============================================================
-// vendor ID and product ID can into here for others
-//============================================================
-static struct usb_device_id Id_Table[] =
-{
-  {USB_DEVICE( 0x0416, 0x0035 )},
-  {USB_DEVICE( 0x18E8, 0x6201 )},
-  {USB_DEVICE( 0x18E8, 0x6206 )},
-  {USB_DEVICE( 0x18E8, 0x6217 )},
-  {USB_DEVICE( 0x18E8, 0x6230 )},
-  {USB_DEVICE( 0x18E8, 0x6233 )},
-  {USB_DEVICE( 0x1131, 0x2035 )},
-  {  }
+static struct usb_device_id wb35_table[] __devinitdata = {
+	{USB_DEVICE(0x0416, 0x0035)},
+	{USB_DEVICE(0x18E8, 0x6201)},
+	{USB_DEVICE(0x18E8, 0x6206)},
+	{USB_DEVICE(0x18E8, 0x6217)},
+	{USB_DEVICE(0x18E8, 0x6230)},
+	{USB_DEVICE(0x18E8, 0x6233)},
+	{USB_DEVICE(0x1131, 0x2035)},
+	{}
 };
 
-MODULE_DEVICE_TABLE(usb, Id_Table);
-
-static struct usb_driver wb35_driver = {
-	.name =		"w35und",
-	.probe =	wb35_probe,
-	.disconnect = wb35_disconnect,
-	.id_table = Id_Table,
-};
+MODULE_DEVICE_TABLE(usb, wb35_table);
 
 static const struct ieee80211_rate wbsoft_rates[] = {
 	{ .bitrate = 10, .flags = IEEE80211_RATE_SHORT_PREAMBLE },
@@ -187,21 +174,6 @@ struct wbsoft_priv {
 };
 
 
-int __init wb35_init(void)
-{
-	printk("[w35und]driver init\n");
-	return usb_register(&wb35_driver);
-}
-
-void __exit wb35_exit(void)
-{
-	printk("[w35und]driver exit\n");
-	usb_deregister( &wb35_driver );
-}
-
-module_init(wb35_init);
-module_exit(wb35_exit);
-
 // Usb kernel subsystem will call this function when a new device is plugged into.
 int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 {
@@ -210,7 +182,7 @@ int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 	PWBUSB		pWbUsb;
         struct usb_host_interface *interface;
 	struct usb_endpoint_descriptor *endpoint;
-	int	i, ret = -1;
+	int	ret = -1;
 	u32	ltmp;
 	struct usb_device *udev = interface_to_usbdev(intf);
 
@@ -218,21 +190,6 @@ int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id_table)
 
 	printk("[w35und]wb35_probe ->\n");
 
-	for (i=0; i<(sizeof(Id_Table)/sizeof(struct usb_device_id)); i++ ) {
-		if ((udev->descriptor.idVendor == Id_Table[i].idVendor) &&
-			(udev->descriptor.idProduct == Id_Table[i].idProduct)) {
-			printk("[w35und]Found supported hardware\n");
-			break;
-		}
-	}
-
-	if ((i == (sizeof(Id_Table)/sizeof(struct usb_device_id)))) {
-		#ifdef _PE_USB_INI_DUMP_
-		WBDEBUG(("[w35und] This is not the one we are interested about\n"));
-		#endif
-		return -ENODEV;
-	}
-
 	// 20060630.2 Check the device if it already be opened
 	ret = usb_control_msg(udev, usb_rcvctrlpipe( udev, 0 ),
 			      0x01, USB_TYPE_VENDOR|USB_RECIP_DEVICE|USB_DIR_IN,
@@ -398,4 +355,22 @@ void wb35_disconnect(struct usb_interface *intf)
 
 }
 
+static struct usb_driver wb35_driver = {
+	.name		= "w35und",
+	.id_table	= wb35_table,
+	.probe		= wb35_probe,
+	.disconnect	= wb35_disconnect,
+};
+
+static int __init wb35_init(void)
+{
+	return usb_register(&wb35_driver);
+}
+
+static void __exit wb35_exit(void)
+{
+	usb_deregister(&wb35_driver);
+}
 
+module_init(wb35_init);
+module_exit(wb35_exit);
-- 
1.6.0.2

