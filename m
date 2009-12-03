Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZLCJIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZLCJIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZLCJIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:08:43 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54973 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbZLCJIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:08:42 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3 -next] usbtouchscreen: find input endpoint automatically
Date: Thu, 3 Dec 2009 10:08:45 +0100
User-Agent: KMail/1.9.10
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org
References: <200911301306.43364.zary@gsystems.sk> <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
In-Reply-To: <20091202134053.4eb5f8dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912031008.46738.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find input enpoint automatically instead of assuming that the first one is OK.
This is needed for devices with multiple endpoints such as iNexio where the
first endpoint might be output.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/usbtouchscreen.1	2009-12-03 09:23:34.000000000 +0100
+++ linux-2.6.32-rc8-next-20091202/drivers/input/touchscreen/usbtouchscreen.c	2009-12-03 09:23:41.000000000 +0100
@@ -1057,17 +1057,25 @@ static int usbtouch_probe(struct usb_int
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
