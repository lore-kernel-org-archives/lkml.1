Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbZCMMsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbZCMMsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZCMMrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:47:52 -0400
Received: from billgribble.com ([65.99.215.30]:49618 "EHLO
	mail.billgribble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZCMMrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:47:51 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2009 08:47:51 EDT
Subject: usbhid:  Changes since 2.6.28 in quirk handling?
From: Bill Gribble <grib@billgribble.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-H+qoA7dSWjOrnlmntHV6"
Date: Fri, 13 Mar 2009 08:39:02 -0400
Message-Id: <1236947942.9606.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Mar 13 07:40:38 2009
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 49ba544613713852521447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H+qoA7dSWjOrnlmntHV6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, I have been maintaining a patch for a quirky USB device built-in to
a UMPC, the Raon Digital Everun.  Without the patch, the builtin
keyboard, mouse, and touchscreen are useless.  I have never submitted it
for inclusion in the kernel because there are less than 5 people who
have ever even attempted to install Linux on this device, and it's
discontinued.  However, *I* use the thing daily, and its wifi device
(libertas) has continued to get better support in the recent kernels so
I port the patch forward. 

Anyway the patch adds a quirk handler that does a mandatory
initialization step to turn the USB device on at powerup or resume.  In
recent kernels (I moved from 2.6.28, which was reliable, at 2.6.29-rc5,
I believe) this has become unreliable; about half the time the device is
not enabled at boot, and about 1 time in 10 it is disabled when resuming
from suspend-to-RAM. 

I noticed that the structure of the quirk handling code has changed
somewhat; I left my patch using the "old" way of adding an entry to
hid_blacklist in hid-quirks.c.  Is there a document or email trail that
describes the new way of structuring this quirk code?  Any pitfalls to
look out for? 

Thanks,
Bill Gribble


--=-H+qoA7dSWjOrnlmntHV6
Content-Disposition: attachment; filename="everun.patch"
Content-Type: text/x-patch; name="everun.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

diff -u -r linux-2.6-stock/drivers/hid/usbhid/hid-core.c linux-2.6/drivers/hid/usbhid/hid-core.c
--- linux-2.6-stock/drivers/hid/usbhid/hid-core.c	2009-03-13 08:28:42.000000000 -0400
+++ linux-2.6/drivers/hid/usbhid/hid-core.c	2009-03-13 08:05:48.000000000 -0400
@@ -697,6 +697,35 @@
 	usb_buffer_free(dev, usbhid->bufsize, usbhid->ctrlbuf, usbhid->ctrlbuf_dma);
 }
 
+/*
+ * Sending HID_REQ_SET_REPORT changes the operation mode of the
+ * Microchip controller in the Raon Everun to "operational".  Without
+ * this, the keyboard/mouse/touchpad will not send any events
+ */
+static void hid_fixup_microchip_exphid(struct usb_device *dev, int ifnum)
+{
+       int result;
+       char *buf = kmalloc(1, GFP_KERNEL);
+
+       if (!buf)
+               return;
+
+       buf[0] = 0;
+       dbg_hid("exphid quirk, iface=%d", ifnum);
+       /* only do this for interface 0, the keyboard */
+       if (ifnum == 0) {
+               result = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+                                        HID_REQ_SET_REPORT,
+                                        USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+                                        0x0200, 0x00, buf, 1, USB_CTRL_GET_TIMEOUT);
+
+               if (result < 0)
+                       err_hid("%s failed: %d\n", __func__, result);
+       }
+
+       kfree(buf);
+}
+
 static int usbhid_parse(struct hid_device *hid)
 {
 	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
@@ -772,6 +801,7 @@
 	return ret;
 }
 
+
 static int usbhid_start(struct hid_device *hid)
 {
 	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
@@ -801,6 +831,10 @@
 		goto fail;
 	}
 
+        if (hid->quirks & HID_QUIRK_MICROCHIP_EXPHID)
+                hid_fixup_microchip_exphid(interface_to_usbdev(intf),
+                        intf->cur_altsetting->desc.bInterfaceNumber);
+
 	for (n = 0; n < interface->desc.bNumEndpoints; n++) {
 		struct usb_endpoint_descriptor *endpoint;
 		int pipe;
@@ -1075,10 +1109,16 @@
 	if (!test_bit(HID_STARTED, &usbhid->iofl))
 		return 0;
 
+        if (hid->quirks & HID_QUIRK_MICROCHIP_EXPHID)
+                hid_fixup_microchip_exphid(interface_to_usbdev(intf),
+                        intf->cur_altsetting->desc.bInterfaceNumber);
+
 	clear_bit(HID_SUSPENDED, &usbhid->iofl);
 	usbhid->retry_delay = 0;
 	status = hid_start_in(hid);
 	dev_dbg(&intf->dev, "resume status %d\n", status);
+
+
 	return status;
 }
 
diff -u -r linux-2.6-stock/drivers/hid/usbhid/hid-quirks.c linux-2.6/drivers/hid/usbhid/hid-quirks.c
--- linux-2.6-stock/drivers/hid/usbhid/hid-quirks.c	2009-03-13 08:28:42.000000000 -0400
+++ linux-2.6/drivers/hid/usbhid/hid-quirks.c	2009-03-13 08:05:48.000000000 -0400
@@ -61,6 +61,8 @@
 	{ USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 	{ USB_VENDOR_ID_WISEGROUP_LTD2, USB_DEVICE_ID_SMARTJOY_DUAL_PLUS, HID_QUIRK_NOGET | HID_QUIRK_MULTI_INPUT },
 
+        { USB_VENDOR_ID_MICROCHIP, USB_DEVICE_ID_MICROCHIP_EXPHID, HID_QUIRK_MICROCHIP_EXPHID },
+
 	{ 0, 0 }
 };
 

--=-H+qoA7dSWjOrnlmntHV6--


