Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbYF3UNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbYF3UNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbYF3UNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:13:43 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:65399 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbYF3UNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:13:42 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: Add support for eGalax TouchKit USB touchscreen used on HP tx1305us
Date: Mon, 30 Jun 2008 22:18:36 +0200
User-Agent: KMail/1.9.6
Cc: Alastair Bridgewater <nyef_sbcl@lisphacker.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <200806281719.16837.daniel.ritz-ml@swissonline.ch> <48668070.3040902@lisphacker.com> <20080630112020.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080630112020.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806302218.37165.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 June 2008 17:23:35 Dmitry Torokhov wrote:
> Hi Alastair,
> 
> On Sat, Jun 28, 2008 at 02:18:24PM -0400, Alastair Bridgewater wrote:
> >       bInterfaceClass         3 Human Interface Devices
> >       bInterfaceSubClass      1 Boot Interface Subclass
> >       bInterfaceProtocol      2 Mouse
> 
> I think we can try to make usbtouchscreen ignore eGalaxes with
> interface class set to HID?
> 

yeah, i was thinking of that too...something like the attached?
it's completely untested, so no signed-off-by yet...

rgds
-daniel

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 3a0a8ca..c5b18e6 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -49,6 +49,7 @@
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
+#include <linux/hid.h>
 
 
 #define DRIVER_VERSION		"v0.6"
@@ -101,7 +102,7 @@ struct usbtouch_usb {
 
 /* device types */
 enum {
-	DEVTPYE_DUMMY = -1,
+	DEVTYPE_IGNORE = -1,
 	DEVTYPE_EGALAX,
 	DEVTYPE_PANJIT,
 	DEVTYPE_3M,
@@ -115,8 +116,21 @@ enum {
 	DEVTYPE_GOTOP,
 };
 
+#define USB_DEVICE_HID_CLASS(vend, prod) \
+	.match_flags = USB_DEVICE_ID_MATCH_INT_CLASS \
+		| USB_DEVICE_ID_MATCH_DEVICE, \
+	.idVendor = (vend), \
+	.idProduct = (prod), \
+	.bInterfaceClass = USB_INTERFACE_CLASS_HID, \
+	.bInterfaceProtocol = USB_INTERFACE_PROTOCOL_MOUSE
+
 static struct usb_device_id usbtouch_devices[] = {
 #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
+	/* ignore the HID capable devices, handled by usbhid */
+	{USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info = DEVTYPE_IGNORE},
+	{USB_DEVICE_HID_CLASS(0x0eef, 0x0002), .driver_info = DEVTYPE_IGNORE},
+
+	/* normal device IDs */
 	{USB_DEVICE(0x3823, 0x0001), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x3823, 0x0002), .driver_info = DEVTYPE_EGALAX},
 	{USB_DEVICE(0x0123, 0x0001), .driver_info = DEVTYPE_EGALAX},
@@ -857,6 +871,10 @@ static int usbtouch_probe(struct usb_interface *intf,
 	struct usbtouch_device_info *type;
 	int err = -ENOMEM;
 
+	/* some devices are ignored */
+	if (id->driver_info == DEVTYPE_IGNORE)
+		return -ENODEV;
+
 	interface = intf->cur_altsetting;
 	endpoint = &interface->endpoint[0].desc;
 

