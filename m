Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbYL2KTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbYL2KTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYL2KTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:19:37 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54464 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbYL2KTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:19:35 -0500
Date: Mon, 29 Dec 2008 11:19:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dmitry.torokhov@gmail.com, dtor@mail.ru, linux-input@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/13] drivers/input/tablet: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291119120.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This set of patches introduces calls to the following set of functions:

usb_endpoint_dir_in(epd)
usb_endpoint_dir_out(epd)
usb_endpoint_is_bulk_in(epd)
usb_endpoint_is_bulk_out(epd)
usb_endpoint_is_int_in(epd)
usb_endpoint_is_int_out(epd)
usb_endpoint_num(epd)
usb_endpoint_type(epd)
usb_endpoint_xfer_bulk(epd)
usb_endpoint_xfer_control(epd)
usb_endpoint_xfer_int(epd)
usb_endpoint_xfer_isoc(epd)

In some cases, introducing one of these functions is not possible, and it
just replaces an explicit integer value by one of the following constants:

USB_ENDPOINT_XFER_BULK
USB_ENDPOINT_XFER_CONTROL
USB_ENDPOINT_XFER_INT
USB_ENDPOINT_XFER_ISOC

An extract of the semantic patch that makes these changes is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r1@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bmAttributes & \(USB_ENDPOINT_XFERTYPE_MASK\|3\)) ==
- \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ usb_endpoint_xfer_control(epd)

@r5@ struct usb_endpoint_descriptor *epd; @@

- ((epd->bEndpointAddress & \(USB_ENDPOINT_DIR_MASK\|0x80\)) ==
-  \(USB_DIR_IN\|0x80\))
+ usb_endpoint_dir_in(epd)

@inc@
@@

#include <linux/usb.h>

@depends on !inc && (r1||r5)@
@@

+ #include <linux/usb.h>
  #include <linux/usb/...>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/input/tablet/gtco.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tablet/gtco.c b/drivers/input/tablet/gtco.c
index 5524e01..2e18a1c 100644
--- a/drivers/input/tablet/gtco.c
+++ b/drivers/input/tablet/gtco.c
@@ -877,7 +877,7 @@ static int gtco_probe(struct usb_interface *usbinterface,
 	dbg("num endpoints:     %d", usbinterface->cur_altsetting->desc.bNumEndpoints);
 	dbg("interface class:   %d", usbinterface->cur_altsetting->desc.bInterfaceClass);
 	dbg("endpoint: attribute:0x%x type:0x%x", endpoint->bmAttributes, endpoint->bDescriptorType);
-	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+	if (usb_endpoint_xfer_int(endpoint))
 		dbg("endpoint: we have interrupt endpoint\n");
 
 	dbg("endpoint extra len:%d ", usbinterface->altsetting[0].extralen);
