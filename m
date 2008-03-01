Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYCAPHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYCAPHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbYCAPH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:07:26 -0500
Received: from psa.adit.fi ([217.112.250.17]:42367 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbYCAPHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:07:25 -0500
X-Greylist: delayed 797 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2008 10:07:23 EST
Message-ID: <47C96DEB.5070304@adit.fi>
Date: Sat, 01 Mar 2008 16:53:31 +0200
From: Pekka Sarnila <sarnila@adit.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.11) Gecko/20070217 Iceape/1.0.8 (Debian-1.0.8-4)
MIME-Version: 1.0
To: jkosina@suse.cz
CC: linux-kernel@vger.kernel.org
Subject: [patch] hid: quirk to fixup fullspeed interval on highspeed devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Sarnila <sarnila@adit.fi>

Many vendors highspeed devices give erroneously fullspeed interval value in endpoint descriptor for interrupt endpoints. This quirk fixes up that by recalculating the right value for highspeed device.

---

This patch is against jikos/hid.git.

At the time of hid configuration this quirk calculates which highspeed interval value gives same interval delay as, or next smaller then, what it would be if the original value would be interpreted as fullspeed value. In subsequent urbs that new value is used instead.

Forming the 'hid->name' in usb_hid_config() was moved up to accommodate more descriptive printk reporting the fixup.

In this patch the quirk is set for one such device: Afatech DVB-T 2 infrared HID-keyboard. It reports value 16 which means 4,069s in highspeed while obviously 16ms was intended. In this case quirk calculates new value to be 8 which gives when interpreted as highspeed value 16ms as wanted. The behavior of the device was verified to be what expected both before and after the patch.

Actually better place for this fixup would be in the usb/core/config.c:usb_parse_endpoint(), but usb subsystem provides no quirk system, and there is no way for the parser to generally know that the value is wrong (except if the value is out of range; then fix is done there).

Signed-off-by: Pekka Sarnila <sarnila@adit.fi>


diff -uprN -X hid.orig/Documentation/dontdiff hid.orig/drivers/hid/usbhid/hid-core.c hid/drivers/hid/usbhid/hid-core.c
--- hid.orig/drivers/hid/usbhid/hid-core.c	2008-02-29 19:35:24.000000000 +0200
+++ hid/drivers/hid/usbhid/hid-core.c	2008-03-01 14:18:13.000000000 +0200
@@ -800,6 +800,22 @@ static struct hid_device *usb_hid_config
 		goto fail;
 	}
 
+	hid->name[0] = 0;
+
+	if (dev->manufacturer)
+		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
+
+	if (dev->product) {
+		if (dev->manufacturer)
+			strlcat(hid->name, " ", sizeof(hid->name));
+		strlcat(hid->name, dev->product, sizeof(hid->name));
+	}
+
+	if (!strlen(hid->name))
+		snprintf(hid->name, sizeof(hid->name), "HID %04x:%04x",
+			 le16_to_cpu(dev->descriptor.idVendor),
+			 le16_to_cpu(dev->descriptor.idProduct));
+
 	for (n = 0; n < interface->desc.bNumEndpoints; n++) {
 
 		struct usb_endpoint_descriptor *endpoint;
@@ -812,6 +828,14 @@ static struct hid_device *usb_hid_config
 
 		interval = endpoint->bInterval;
 
+		/* Some vendors give fullspeed interval on highspeed devides */
+		if (quirks & HID_QUIRK_FULLSPEED_INTERVAL  &&
+		    dev->speed == USB_SPEED_HIGH) {
+			interval = fls(endpoint->bInterval*8);
+			printk(KERN_INFO "%s: Fixing fullspeed to highspeed interval: %d -> %d\n",
+			       hid->name, endpoint->bInterval, interval);
+		}
+
 		/* Change the polling interval of mice. */
 		if (hid->collection->usage == HID_GD_MOUSE && hid_mousepoll_interval > 0)
 			interval = hid_mousepoll_interval;
@@ -859,22 +883,6 @@ static struct hid_device *usb_hid_config
 	usbhid->intf = intf;
 	usbhid->ifnum = interface->desc.bInterfaceNumber;
 
-	hid->name[0] = 0;
-
-	if (dev->manufacturer)
-		strlcpy(hid->name, dev->manufacturer, sizeof(hid->name));
-
-	if (dev->product) {
-		if (dev->manufacturer)
-			strlcat(hid->name, " ", sizeof(hid->name));
-		strlcat(hid->name, dev->product, sizeof(hid->name));
-	}
-
-	if (!strlen(hid->name))
-		snprintf(hid->name, sizeof(hid->name), "HID %04x:%04x",
-			 le16_to_cpu(dev->descriptor.idVendor),
-			 le16_to_cpu(dev->descriptor.idProduct));
-
 	hid->bus = BUS_USB;
 	hid->vendor = le16_to_cpu(dev->descriptor.idVendor);
 	hid->product = le16_to_cpu(dev->descriptor.idProduct);
diff -uprN -X hid.orig/Documentation/dontdiff hid.orig/drivers/hid/usbhid/hid-quirks.c hid/drivers/hid/usbhid/hid-quirks.c
--- hid.orig/drivers/hid/usbhid/hid-quirks.c	2008-02-29 19:35:24.000000000 +0200
+++ hid/drivers/hid/usbhid/hid-quirks.c	2008-02-29 19:49:28.000000000 +0200
@@ -32,6 +32,9 @@
 #define USB_VENDOR_ID_ADS_TECH 		0x06e1
 #define USB_DEVICE_ID_ADS_TECH_RADIO_SI470X	0xa155
 
+#define USB_VENDOR_ID_AFATECH		0x15a4
+#define USB_DEVICE_ID_AFATECH_AF9016	0x9016
+
 #define USB_VENDOR_ID_AIPTEK		0x08ca
 #define USB_DEVICE_ID_AIPTEK_01		0x0001
 #define USB_DEVICE_ID_AIPTEK_10		0x0010
@@ -414,6 +417,8 @@ static const struct hid_blacklist {
 	
 	{ USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_DINOVO_EDGE, HID_QUIRK_DUPLICATE_USAGES },
 
+	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
+
 	{ USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM, HID_QUIRK_HIDDEV },
 	{ USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4, HID_QUIRK_HIDDEV | HID_QUIRK_IGNORE_HIDINPUT },
 	{ USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV, HID_QUIRK_HIDINPUT },
diff -uprN -X hid.orig/Documentation/dontdiff hid.orig/include/linux/hid.h hid/include/linux/hid.h
--- hid.orig/include/linux/hid.h	2008-02-29 19:35:29.000000000 +0200
+++ hid/include/linux/hid.h	2008-02-29 20:07:15.000000000 +0200
@@ -284,6 +284,7 @@ struct hid_item {
 #define HID_QUIRK_2WHEEL_MOUSE_HACK_B8		0x02000000
 #define HID_QUIRK_HWHEEL_WHEEL_INVERT		0x04000000
 #define HID_QUIRK_MICROSOFT_KEYS		0x08000000
+#define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
 
 /*
  * Separate quirks for runtime report descriptor fixup

