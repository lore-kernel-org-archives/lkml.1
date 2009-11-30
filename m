Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZK3Mq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZK3Mq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbZK3MqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:46:20 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:48587 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZK3MqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:46:17 -0500
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 2/3] [resend] usbtouchscreen: find input endpoint automatically
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <zary@gsystems.sk>
Date: Mon, 30 Nov 2009 13:06:55 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911301306.56545.zary@gsystems.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find input enpoint automatically instead of assuming that the first one is OK.
This is needed for devices with multiple endpoints such as iNexio where the
first endpoint might be output.


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c.1	2009-11-23 10:30:14.000000000 +0100
+++ linux-source-2.6.31/drivers/input/touchscreen/usbtouchscreen.c	2009-11-23 10:57:14.000000000 +0100
@@ -882,17 +882,25 @@ static int usbtouch_probe(struct usb_int
 	struct usbtouch_usb *usbtouch;
 	struct input_dev *input_dev;
 	struct usb_host_interface *interface;
-	struct usb_endpoint_descriptor *endpoint;
+	struct usb_endpoint_descriptor *endpoint = NULL;
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usbtouch_device_info *type;
 	int err = -ENOMEM;
+	int i;
 
 	/* some devices are ignored */
 	if (id->driver_info == DEVTYPE_IGNORE)
 		return -ENODEV;
 
 	interface = intf->cur_altsetting;
-	endpoint = &interface->endpoint[0].desc;
+	/* find first input endpoint */
+	for (i = 0; i < interface->desc.bNumEndpoints; i++)
+		if (usb_endpoint_dir_in(&interface->endpoint[i].desc)) {
+			endpoint = &interface->endpoint[i].desc;
+			break;
+		}
+	if (!endpoint)
+		return -ENXIO;
 
 	usbtouch = kzalloc(sizeof(struct usbtouch_usb), GFP_KERNEL);
 	input_dev = input_allocate_device();


-- 
Ondrej Zary
