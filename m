Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbYL2KV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbYL2KV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYL2KVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:21:33 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59517 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbYL2KVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:21:32 -0500
Date: Mon, 29 Dec 2008 11:21:29 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: lrodriguez@atheros.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/13] drivers/staging/otus: use USB API functions rather than
 constants
Message-ID: <Pine.LNX.4.64.0812291121100.9555@pc-004.diku.dk>
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
 drivers/staging/otus/usbdrv.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 817228d..4443a2c 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -936,30 +936,26 @@ int zfLnxAllocAllUrbs(struct usbdrv_private *macp)
     for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i)
     {
         endpoint = &iface_desc->endpoint[i].desc;
-        if ((endpoint->bEndpointAddress & 0x80) &&
-            ((endpoint->bmAttributes & 3) == 0x02))
+	 if (usb_endpoint_is_bulk_in(endpoint))
         {
             /* we found a bulk in endpoint */
             printk(KERN_ERR "bulk in: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
         }
 
-        if (((endpoint->bEndpointAddress & 0x80) == 0x00) &&
-            ((endpoint->bmAttributes & 3) == 0x02))
+	 if (usb_endpoint_is_bulk_out(endpoint))
         {
             /* we found a bulk out endpoint */
             printk(KERN_ERR "bulk out: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
         }
 
-        if ((endpoint->bEndpointAddress & 0x80) &&
-            ((endpoint->bmAttributes & 3) == 0x03))
+	 if (usb_endpoint_is_int_in(endpoint))
         {
             /* we found a interrupt in endpoint */
             printk(KERN_ERR "interrupt in: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
             printk(KERN_ERR "interrupt in: int_interval = %d\n", endpoint->bInterval);
         }
 
-        if (((endpoint->bEndpointAddress & 0x80) == 0x00) &&
-            ((endpoint->bmAttributes & 3) == 0x03))
+	 if (usb_endpoint_is_int_out(endpoint))
         {
             /* we found a interrupt out endpoint */
             printk(KERN_ERR "interrupt out: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
