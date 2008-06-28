Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbYF1Bh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbYF1Bh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 21:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYF1Bhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 21:37:47 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:54846 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYF1Bhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 21:37:46 -0400
Date: Fri, 27 Jun 2008 21:36:47 -0400
From: Alastair Bridgewater <nyef@lisphacker.com>
Subject: [PATCH] input: Add support for eGalax TouchKit USB touchscreen used on
 HP tx1305us
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <486595AF.7040103@lisphacker.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.12 (X11/20080320)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The eGalax touchscreen used in the HP tx1305us tablet PC (and presumably 
the rest of the tx1000 series) uses a different format for events from 
the device than the existing driver supports.

Add a new device description and interrupt packet handler for the 
touchscreen used in the tx1305us, claiming the USB device ID for the 
device that this patch was tested with from the older eGalax device code.

Signed-off-by: Alastair Bridgewater <nyef@lisphacker.com>

---

Applies clean with linux-2.6.25 and linux-2.6.26-rc6.

--- linux-2.6.26-rc6/drivers/input/touchscreen/usbtouchscreen.c   
 2008-06-27 20:34:34.886969800 -0400
+++ linux-2.6.25/drivers/input/touchscreen/usbtouchscreen.c   
 2008-06-06 12:19:16.460568440 -0400
@@ -103,6 +103,7 @@ struct usbtouch_usb {
 enum {
     DEVTPYE_DUMMY = -1,
     DEVTYPE_EGALAX,
+    DEVTYPE_EGALAX2,
     DEVTYPE_PANJIT,
     DEVTYPE_3M,
     DEVTYPE_ITM,
@@ -120,7 +121,7 @@ static struct usb_device_id usbtouch_dev
     {USB_DEVICE(0x3823, 0x0001), .driver_info = DEVTYPE_EGALAX},
     {USB_DEVICE(0x3823, 0x0002), .driver_info = DEVTYPE_EGALAX},
     {USB_DEVICE(0x0123, 0x0001), .driver_info = DEVTYPE_EGALAX},
-    {USB_DEVICE(0x0eef, 0x0001), .driver_info = DEVTYPE_EGALAX},
+    {USB_DEVICE(0x0eef, 0x0001), .driver_info = DEVTYPE_EGALAX2},
     {USB_DEVICE(0x0eef, 0x0002), .driver_info = DEVTYPE_EGALAX},
     {USB_DEVICE(0x1234, 0x0001), .driver_info = DEVTYPE_EGALAX},
     {USB_DEVICE(0x1234, 0x0002), .driver_info = DEVTYPE_EGALAX},
@@ -217,6 +218,15 @@ static int egalax_get_pkt_len(unsigned c
 
     return 0;
 }
+
+static int egalax2_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
+{
+    dev->x = ((pkt[3] & 0x0F) << 8) | pkt[2];
+    dev->y = ((pkt[5] & 0x0F) << 8) | pkt[4];
+    dev->touch = pkt[1] & 0x01;
+
+    return 1;
+}
 #endif
 
 
@@ -555,6 +565,15 @@ static struct usbtouch_device_info usbto
         .get_pkt_len    = egalax_get_pkt_len,
         .read_data    = egalax_read_data,
     },
+
+    [DEVTYPE_EGALAX2] = {
+        .min_xc        = 0x0,
+        .max_xc        = 0x0fff,
+        .min_yc        = 0x0,
+        .max_yc        = 0x0fff,
+        .rept_size    = 8,
+        .read_data    = egalax2_read_data,
+    },
 #endif
 
 #ifdef CONFIG_TOUCHSCREEN_USB_PANJIT

