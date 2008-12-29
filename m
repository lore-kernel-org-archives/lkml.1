Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYL2KU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYL2KU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYL2KUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:20:45 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51655 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbYL2KUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:20:44 -0500
Date: Mon, 29 Dec 2008 11:20:42 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/13] drivers/mtd/nand: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291120220.9555@pc-004.diku.dk>
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
 drivers/mtd/nand/alauda.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/alauda.c b/drivers/mtd/nand/alauda.c
index 9623803..6d96491 100644
--- a/drivers/mtd/nand/alauda.c
+++ b/drivers/mtd/nand/alauda.c
@@ -676,11 +676,11 @@ static int alauda_probe(struct usb_interface *interface,
 		goto error;
 
 	al->write_out = usb_sndbulkpipe(al->dev,
-			ep_wr->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+			usb_endpoint_num(ep_wr));
 	al->bulk_in = usb_rcvbulkpipe(al->dev,
-			ep_in->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+			usb_endpoint_num(ep_in));
 	al->bulk_out = usb_sndbulkpipe(al->dev,
-			ep_out->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+			usb_endpoint_num(ep_out));
 
 	/* second device is identical up to now */
 	memcpy(al+1, al, sizeof(*al));
