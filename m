Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbYL2KW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbYL2KW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYL2KV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:21:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59530 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbYL2KVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:21:55 -0500
Date: Mon, 29 Dec 2008 11:21:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 8/13] drivers/staging/rspiusb: use USB API functions rather
 than constants
Message-ID: <Pine.LNX.4.64.0812291121350.9555@pc-004.diku.dk>
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
 drivers/staging/rspiusb/rspiusb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rspiusb/rspiusb.c b/drivers/staging/rspiusb/rspiusb.c
index ca281d6..ecaffb5 100644
--- a/drivers/staging/rspiusb/rspiusb.c
+++ b/drivers/staging/rspiusb/rspiusb.c
@@ -781,9 +781,8 @@ static int piusb_probe(struct usb_interface *interface,
 			dbg("Endpoint[%d]->MaxPacketSize = %d\n", i,
 			    endpoint->wMaxPacketSize);
 		}
-		if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-		    USB_ENDPOINT_XFER_BULK) {
-			if (endpoint->bEndpointAddress & USB_DIR_IN)
+		if (usb_endpoint_xfer_bulk(endpoint)) {
+			if (usb_endpoint_dir_in(endpoint))
 				pdx->hEP[i] =
 				    usb_rcvbulkpipe(pdx->udev,
 						    endpoint->bEndpointAddress);
