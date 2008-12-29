Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbYL2KUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbYL2KUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYL2KT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:19:58 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54475 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYL2KT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:19:57 -0500
Date: Mon, 29 Dec 2008 11:19:55 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: hjlipp@web.de, tilman@imap.cc, gigaset307x-common@lists.sourceforge.net,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/13] drivers/isdn/gigaset: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291119340.9555@pc-004.diku.dk>
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
 drivers/isdn/gigaset/usb-gigaset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index e847c6e..16399fb 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -783,7 +783,7 @@ static int gigaset_probe(struct usb_interface *interface,
 	/* Fill the interrupt urb and send it to the core */
 	usb_fill_int_urb(ucs->read_urb, udev,
 			 usb_rcvintpipe(udev,
-					endpoint->bEndpointAddress & 0x0f),
+					usb_endpoint_num(endpoint)),
 			 cs->inbuf[0].rcvbuf, buffer_size,
 			 gigaset_read_int_callback,
 			 cs->inbuf + 0, endpoint->bInterval);
