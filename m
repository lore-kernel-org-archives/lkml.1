Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYL2KWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYL2KWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbYL2KWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:22:20 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59540 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755517AbYL2KWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:22:17 -0500
Date: Mon, 29 Dec 2008 11:22:14 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/13] drivers/usb: use USB API functions rather than constants
Message-ID: <Pine.LNX.4.64.0812291121550.9555@pc-004.diku.dk>
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
 drivers/usb/core/devices.c      |    2 +-
 drivers/usb/core/endpoint.c     |    9 ++++-----
 drivers/usb/host/r8a66597-hcd.c |   15 +++++++--------
 drivers/usb/serial/keyspan.c    |    2 +-
 drivers/usb/storage/usb.c       |    6 +++---
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 6ec3817..73c108d 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -187,7 +187,7 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 	}
 
 	/* this isn't checking for illegal values */
-	switch (desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	switch (usb_endpoint_type(desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
 		type = "Ctrl";
 		if (speed == USB_SPEED_HIGH) 	/* uframes per NAK */
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index e1710f2..40dee2a 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -66,7 +66,7 @@ static ssize_t show_ep_type(struct device *dev, struct device_attribute *attr,
 	struct ep_device *ep = to_ep_device(dev);
 	char *type = "unknown";
 
-	switch (ep->desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	switch (usb_endpoint_type(ep->desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
 		type = "Control";
 		break;
@@ -94,7 +94,7 @@ static ssize_t show_ep_interval(struct device *dev,
 
 	in = (ep->desc->bEndpointAddress & USB_DIR_IN);
 
-	switch (ep->desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	switch (usb_endpoint_type(ep->desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
 		if (ep->udev->speed == USB_SPEED_HIGH) 	/* uframes per NAK */
 			interval = ep->desc->bInterval;
@@ -131,10 +131,9 @@ static ssize_t show_ep_direction(struct device *dev,
 	struct ep_device *ep = to_ep_device(dev);
 	char *direction;
 
-	if ((ep->desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-			USB_ENDPOINT_XFER_CONTROL)
+	if (usb_endpoint_xfer_control(ep->desc))
 		direction = "both";
-	else if (ep->desc->bEndpointAddress & USB_DIR_IN)
+	else if (usb_endpoint_dir_in(ep->desc))
 		direction = "in";
 	else
 		direction = "out";
diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index 3190412..5e942d9 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -660,9 +660,9 @@ static u16 get_empty_pipenum(struct r8a66597 *r8a66597,
 	u16 array[R8A66597_MAX_NUM_PIPE], i = 0, min;
 
 	memset(array, 0, sizeof(array));
-	switch (ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	switch (usb_endpoint_type(ep)) {
 	case USB_ENDPOINT_XFER_BULK:
-		if (ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
+		if (usb_endpoint_dir_in(ep))
 			array[i++] = 4;
 		else {
 			array[i++] = 3;
@@ -670,7 +670,7 @@ static u16 get_empty_pipenum(struct r8a66597 *r8a66597,
 		}
 		break;
 	case USB_ENDPOINT_XFER_INT:
-		if (ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) {
+		if (usb_endpoint_dir_in(ep)) {
 			array[i++] = 6;
 			array[i++] = 7;
 			array[i++] = 8;
@@ -678,7 +678,7 @@ static u16 get_empty_pipenum(struct r8a66597 *r8a66597,
 			array[i++] = 9;
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
-		if (ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
+		if (usb_endpoint_dir_in(ep))
 			array[i++] = 2;
 		else
 			array[i++] = 1;
@@ -928,10 +928,9 @@ static void init_pipe_info(struct r8a66597 *r8a66597, struct urb *urb,
 
 	info.pipenum = get_empty_pipenum(r8a66597, ep);
 	info.address = get_urb_to_r8a66597_addr(r8a66597, urb);
-	info.epnum = ep->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
+	info.epnum = usb_endpoint_num(ep);
 	info.maxpacket = le16_to_cpu(ep->wMaxPacketSize);
-	info.type = get_r8a66597_type(ep->bmAttributes
-				      & USB_ENDPOINT_XFERTYPE_MASK);
+	info.type = get_r8a66597_type(usb_endpoint_type(ep));
 	info.bufnum = get_bufnum(info.pipenum);
 	info.buf_bsize = get_buf_bsize(info.pipenum);
 	if (info.type == R8A66597_BULK) {
@@ -941,7 +940,7 @@ static void init_pipe_info(struct r8a66597 *r8a66597, struct urb *urb,
 		info.interval = get_interval(urb, ep->bInterval);
 		info.timer_interval = get_timer_interval(urb, ep->bInterval);
 	}
-	if (ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK)
+	if (usb_endpoint_dir_in(ep))
 		info.dir_in = 1;
 	else
 		info.dir_in = 0;
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 9878c0f..00daa8f 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1507,7 +1507,7 @@ static struct urb *keyspan_setup_urb(struct usb_serial *serial, int endpoint,
 	} else {
 		dev_warn(&serial->interface->dev,
 			 "unsupported endpoint type %x\n",
-			 ep_desc->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK);
+			 usb_endpoint_type(ep_desc));
 		usb_free_urb(urb);
 		return NULL;
 	}
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index b25c448..a6c6a7e 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -793,12 +793,12 @@ static int get_pipes(struct us_data *us)
 	us->send_ctrl_pipe = usb_sndctrlpipe(us->pusb_dev, 0);
 	us->recv_ctrl_pipe = usb_rcvctrlpipe(us->pusb_dev, 0);
 	us->send_bulk_pipe = usb_sndbulkpipe(us->pusb_dev,
-		ep_out->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+		usb_endpoint_num(ep_out));
 	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev, 
-		ep_in->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+		usb_endpoint_num(ep_in));
 	if (ep_int) {
 		us->recv_intr_pipe = usb_rcvintpipe(us->pusb_dev,
-			ep_int->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+			usb_endpoint_num(ep_int));
 		us->ep_bInterval = ep_int->bInterval;
 	}
 	return 0;
