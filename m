Return-Path: <linux-kernel-owner+w=401wt.eu-S932564AbZACQzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbZACQzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 11:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbZACQy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 11:54:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41918 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118AbZACQy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 11:54:57 -0500
Date: Sat, 3 Jan 2009 17:54:53 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] sound/usb: Use negated usb_endpoint_xfer_control, etc
Message-ID: <Pine.LNX.4.64.0901031753120.9811@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This patch extends 42a6e66f1e40a930d093c33ba0bb9d8d8e4555ed by using
usb_endpoint_xfer_control, usb_endpoint_xfer_isoc, usb_endpoint_xfer_bulk,
and usb_endpoint_xfer_int in the negated case as well.

This patch also rewrites some calls to usb_endpoint_dir_in as negated calls
to !usb_endpoint_dir_out, and vice versa, to better correspond to the
intent of the original code.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_CONTROL\|0\))
+ !usb_endpoint_xfer_control(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_ISOC\|1\))
+ !usb_endpoint_xfer_isoc(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_BULK\|2\))
+ !usb_endpoint_xfer_bulk(epd)

@@ struct usb_endpoint_descriptor *epd; @@

- (usb_endpoint_type(epd) != \(USB_ENDPOINT_XFER_INT\|3\))
+ !usb_endpoint_xfer_int(epd)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff --git a/sound/usb/usbmidi.c b/sound/usb/usbmidi.c
index 3a9a9fe..320641a 100644
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1392,8 +1392,7 @@ static int snd_usbmidi_get_ms_info(struct snd_usb_midi* umidi,
 	for (i = 0; i < intfd->bNumEndpoints; ++i) {
 		hostep = &hostif->endpoint[i];
 		ep = get_ep_desc(hostep);
-		if (usb_endpoint_type(ep) != USB_ENDPOINT_XFER_BULK &&
-		    usb_endpoint_type(ep) != USB_ENDPOINT_XFER_INT)
+		if (!usb_endpoint_xfer_bulk(ep) && !usb_endpoint_xfer_int(ep))
 			continue;
 		ms_ep = (struct usb_ms_endpoint_descriptor*)hostep->extra;
 		if (hostep->extralen < 4 ||
@@ -1495,8 +1494,8 @@ static int snd_usbmidi_detect_endpoints(struct snd_usb_midi* umidi,
 
 	for (i = 0; i < intfd->bNumEndpoints; ++i) {
 		epd = get_endpoint(hostif, i);
-		if (usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK &&
-		    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_INT)
+		if (!usb_endpoint_xfer_bulk(epd) &&
+		    !usb_endpoint_xfer_int(epd))
 			continue;
 		if (out_eps < max_endpoints &&
 		    usb_endpoint_dir_out(epd)) {
@@ -1607,21 +1606,19 @@ static int snd_usbmidi_create_endpoints_midiman(struct snd_usb_midi* umidi,
 	}
 
 	epd = get_endpoint(hostif, 0);
-	if (usb_endpoint_dir_out(epd) ||
-	    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_INT) {
+	if (!usb_endpoint_dir_in(epd) || !usb_endpoint_xfer_int(epd)) {
 		snd_printdd(KERN_ERR "endpoint[0] isn't interrupt\n");
 		return -ENXIO;
 	}
 	epd = get_endpoint(hostif, 2);
-	if (usb_endpoint_dir_in(epd) ||
-	    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK) {
+	if (!usb_endpoint_dir_out(epd) || !usb_endpoint_xfer_bulk(epd)) {
 		snd_printdd(KERN_ERR "endpoint[2] isn't bulk output\n");
 		return -ENXIO;
 	}
 	if (endpoint->out_cables > 0x0001) {
 		epd = get_endpoint(hostif, 4);
-		if (usb_endpoint_dir_in(epd) ||
-		    usb_endpoint_type(epd) != USB_ENDPOINT_XFER_BULK) {
+		if (!usb_endpoint_dir_out(epd) ||
+		    !usb_endpoint_xfer_bulk(epd)) {
 			snd_printdd(KERN_ERR "endpoint[4] isn't bulk output\n");
 			return -ENXIO;
 		}
diff --git a/sound/usb/usbmixer.c b/sound/usb/usbmixer.c
index 9ce626f..00397c8 100644
--- a/sound/usb/usbmixer.c
+++ b/sound/usb/usbmixer.c
@@ -1755,8 +1755,7 @@ static int snd_usb_mixer_status_create(struct usb_mixer_interface *mixer)
 	if (get_iface_desc(hostif)->bNumEndpoints < 1)
 		return 0;
 	ep = get_endpoint(hostif, 0);
-	if (usb_endpoint_dir_out(ep) ||
-	    usb_endpoint_type(ep) != USB_ENDPOINT_XFER_INT)
+	if (!usb_endpoint_dir_in(ep) || !usb_endpoint_xfer_int(ep))
 		return 0;
 
 	epnum = usb_endpoint_num(ep);
