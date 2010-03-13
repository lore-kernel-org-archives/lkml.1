Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936458Ab0CMB1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:27:45 -0500
Received: from kroah.org ([198.145.64.141]:60728 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934826Ab0CMAUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:07 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:09 2010
Message-Id: <20100313001509.107183568@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 045/123] ALSA: usb-audio: reduce MIDI packet size to work around broken firmware
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Clemens Ladisch <clemens@ladisch.de>

commit f167e1d073278fe231bbdd5d6c24fb9d091aa544 upstream.

Extend the list of devices whose firmware does not expect more than one
USB MIDI packet in one USB packet.

bug report: https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3752

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbmidi.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1162,10 +1162,22 @@ static int snd_usbmidi_out_endpoint_crea
 		pipe = usb_sndintpipe(umidi->dev, ep_info->out_ep);
 	else
 		pipe = usb_sndbulkpipe(umidi->dev, ep_info->out_ep);
-	if (umidi->usb_id == USB_ID(0x0a92, 0x1020)) /* ESI M4U */
-		ep->max_transfer = 4;
-	else
+	switch (umidi->usb_id) {
+	default:
 		ep->max_transfer = usb_maxpacket(umidi->dev, pipe, 1);
+		break;
+		/*
+		 * Various chips declare a packet size larger than 4 bytes, but
+		 * do not actually work with larger packets:
+		 */
+	case USB_ID(0x0a92, 0x1020): /* ESI M4U */
+	case USB_ID(0x1430, 0x474b): /* RedOctane GH MIDI INTERFACE */
+	case USB_ID(0x15ca, 0x0101): /* Textech USB Midi Cable */
+	case USB_ID(0x15ca, 0x1806): /* Textech USB Midi Cable */
+	case USB_ID(0x1a86, 0x752d): /* QinHeng CH345 "USB2.0-MIDI" */
+		ep->max_transfer = 4;
+		break;
+	}
 	for (i = 0; i < OUTPUT_URBS; ++i) {
 		buffer = usb_buffer_alloc(umidi->dev,
 					  ep->max_transfer, GFP_KERNEL,


