Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYL2KXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYL2KXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbYL2KXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:23:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:54544 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbYL2KXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:23:07 -0500
Date: Mon, 29 Dec 2008 11:23:02 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 11/13] sound/usb: use USB API functions rather than constants
Message-ID: <Pine.LNX.4.64.0812291122420.9555@pc-004.diku.dk>
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
 sound/usb/usbmidi.c  |   42 +++++++++++++++++++++---------------------
 sound/usb/usbmixer.c |    6 +++---
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/sound/usb/usbmidi.c b/sound/usb/usbmidi.c
index 6d9f9b1..3a9a9fe 100644
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1392,8 +1392,8 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi* umidi,
 	for (i = 0; i < intfd->bNumEndpoints; ++i) {
 		hostep = &hostif->endpoint[i];
 		ep = get_ep_desc(hostep);
-		if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_BULK &&
-		    (ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_INT)
+		if (usb_endpoint_type(ep) != USB_ENDPOINT_XFER_BULK &&
+		    usb_endpoint_type(ep) != USB_ENDPOINT_XFER_INT)
 			continue;
 		ms_ep = (struct usb_ms_endpoint_descriptor*)hostep->extra;
 		if (hostep->extralen < 4 ||
@@ -1401,15 +1401,15 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi* umidi,
 		    ms_ep->bDescriptorType != USB_DT_CS_ENDPOINT ||
 		    ms_ep->bDescriptorSubtype != MS_GENERAL)
 			continue;
-		if ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT) {
+		if (usb_endpoint_dir_out(ep)) {
 			if (endpoints[epidx].out_ep) {
 				if (++epidx >= MIDI_MAX_ENDPOINTS) {
 					snd_printk(KERN_WARNING "too many endpoints\n");
 					break;
 				}
 			}
-			endpoints[epidx].out_ep = ep->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+			endpoints[epidx].out_ep = usb_endpoint_num(ep);
+			if (usb_endpoint_xfer_int(ep))
 				endpoints[epidx].out_interval = ep->bInterval;
 			else if (snd_usb_get_speed(umidi->chip->dev) == USB_SPEED_LOW)
 				/*
@@ -1428,8 +1428,8 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi* umidi,
 					break;
 				}
 			}
-			endpoints[epidx].in_ep = ep->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-			if ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+			endpoints[epidx].in_ep = usb_endpoint_num(ep);
+			if (usb_endpoint_xfer_int(ep))
 				endpoints[epidx].in_interval = ep->bInterval;
 			else if (snd_usb_get_speed(umidi->chip->dev) == USB_SPEED_LOW)
 				endpoints[epidx].in_interval = 1;
@@ -1495,20 +1495,20 @@ static int snd_usbmidi_detect_endpoints(struct snd_usb_midi* umidi,
 
 	for (i = 0; i < intfd->bNumEndpoints; ++i) {
 		epd = get_endpoint(hostif, i);
-		if ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_BULK &&
-		    (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_INT)
+		if (usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK &&
+		    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_INT)
 			continue;
 		if (out_eps < max_endpoints &&
-		    (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_OUT) {
-			endpoint[out_eps].out_ep = epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-			if ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+		    usb_endpoint_dir_out(epd)) {
+			endpoint[out_eps].out_ep = usb_endpoint_num(epd);
+			if (usb_endpoint_xfer_int(epd))
 				endpoint[out_eps].out_interval = epd->bInterval;
 			++out_eps;
 		}
 		if (in_eps < max_endpoints &&
-		    (epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) == USB_DIR_IN) {
-			endpoint[in_eps].in_ep = epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
-			if ((epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) == USB_ENDPOINT_XFER_INT)
+		    usb_endpoint_dir_in(epd)) {
+			endpoint[in_eps].in_ep = usb_endpoint_num(epd);
+			if (usb_endpoint_xfer_int(epd))
 				endpoint[in_eps].in_interval = epd->bInterval;
 			++in_eps;
 		}
@@ -1607,21 +1607,21 @@ static int snd_usbmidi_create_endpoints_midiman(struct snd_usb_midi* umidi,
 	}
 
 	epd = get_endpoint(hostif, 0);
-	if ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) != USB_DIR_IN ||
-	    (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_INT) {
+	if (usb_endpoint_dir_out(epd) ||
+	    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_INT) {
 		snd_printdd(KERN_ERR "endpoint[0] isn't interrupt\n");
 		return -ENXIO;
 	}
 	epd = get_endpoint(hostif, 2);
-	if ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) != USB_DIR_OUT ||
-	    (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_BULK) {
+	if (usb_endpoint_dir_in(epd) ||
+	    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK) {
 		snd_printdd(KERN_ERR "endpoint[2] isn't bulk output\n");
 		return -ENXIO;
 	}
 	if (endpoint->out_cables > 0x0001) {
 		epd = get_endpoint(hostif, 4);
-		if ((epd->bEndpointAddress & USB_ENDPOINT_DIR_MASK) != USB_DIR_OUT ||
-		    (epd->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_BULK) {
+		if (usb_endpoint_dir_in(epd) ||
+		    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK) {
 			snd_printdd(KERN_ERR "endpoint[4] isn't bulk output\n");
 			return -ENXIO;
 		}
diff --git a/sound/usb/usbmixer.c b/sound/usb/usbmixer.c
index a492461..9ce626f 100644
--- a/sound/usb/usbmixer.c
+++ b/sound/usb/usbmixer.c
@@ -1755,11 +1755,11 @@ static int snd_usb_mixer_status_create(struct usb_mixer_interface *mixer)
 	if (get_iface_desc(hostif)->bNumEndpoints < 1)
 		return 0;
 	ep = get_endpoint(hostif, 0);
-	if ((ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK) != USB_DIR_IN ||
-	    (ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) != USB_ENDPOINT_XFER_INT)
+	if (usb_endpoint_dir_out(ep) ||
+	    usb_endpoint_type(ep) != USB_ENDPOINT_XFER_INT)
 		return 0;
 
-	epnum = ep->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
+	epnum = usb_endpoint_num(ep);
 	buffer_length = le16_to_cpu(ep->wMaxPacketSize);
 	transfer_buffer = kmalloc(buffer_length, GFP_KERNEL);
 	if (!transfer_buffer)
