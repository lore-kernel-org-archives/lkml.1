Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYL2KYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYL2KYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbYL2KXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:23:51 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59586 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285AbYL2KXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:23:50 -0500
Date: Mon, 29 Dec 2008 11:23:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: wim@iguana.be, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 13/13] drivers/watchdog: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291123240.9555@pc-004.diku.dk>
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
 drivers/watchdog/pcwd_usb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index afb0896..b5320a8 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -609,9 +609,7 @@ static int usb_pcwd_probe(struct usb_interface *interface, const struct usb_devi
 	/* check out the endpoint: it has to be Interrupt & IN */
 	endpoint = &iface_desc->endpoint[0].desc;
 
-	if (!((endpoint->bEndpointAddress & USB_DIR_IN) &&
-	     ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
-				== USB_ENDPOINT_XFER_INT))) {
+	if (!usb_endpoint_is_int_in(endpoint)) {
 		/* we didn't find a Interrupt endpoint with direction IN */
 		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
 		return -ENODEV;
