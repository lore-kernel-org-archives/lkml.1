Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZKWKEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZKWKEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZKWKEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:04:41 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58855 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756113AbZKWKEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:04:40 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 2/3] usbtouchscreen: find input endpoint automatically
Date: Mon, 23 Nov 2009 11:04:40 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911202341.31496.linux@rainbow-software.org> <200911211017.58399.oliver@neukum.org>
In-Reply-To: <200911211017.58399.oliver@neukum.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2426
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231104.42154.linux@rainbow-software.org>
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
