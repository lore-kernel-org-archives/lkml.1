Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYL2KT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYL2KT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYL2KTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:19:15 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54448 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbYL2KTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:19:13 -0500
Date: Mon, 29 Dec 2008 11:19:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: axboe@kernel.dk, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/13] drivers/block: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291118520.9555@pc-004.diku.dk>
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
 drivers/block/ub.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 12fb816..b36b84f 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2146,10 +2146,9 @@ static int ub_get_pipes(struct ub_dev *sc, struct usb_device *dev,
 		ep = &altsetting->endpoint[i].desc;
 
 		/* Is it a BULK endpoint? */
-		if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-				== USB_ENDPOINT_XFER_BULK) {
+		if (usb_endpoint_xfer_bulk(ep)) {
 			/* BULK in or out? */
-			if (ep->bEndpointAddress & USB_DIR_IN) {
+			if (usb_endpoint_dir_in(ep)) {
 				if (ep_in == NULL)
 					ep_in = ep;
 			} else {
@@ -2168,9 +2167,9 @@ static int ub_get_pipes(struct ub_dev *sc, struct usb_device *dev,
 	sc->send_ctrl_pipe = usb_sndctrlpipe(dev, 0);
 	sc->recv_ctrl_pipe = usb_rcvctrlpipe(dev, 0);
 	sc->send_bulk_pipe = usb_sndbulkpipe(dev,
-		ep_out->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+		usb_endpoint_num(ep_out));
 	sc->recv_bulk_pipe = usb_rcvbulkpipe(dev, 
-		ep_in->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+		usb_endpoint_num(ep_in));
 
 	return 0;
 }
