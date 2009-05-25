Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZEYIUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZEYIUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 04:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbZEYIUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 04:20:46 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60333 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbZEYIUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 04:20:45 -0400
X-Sasl-enc: mQZxBL0AwSGnesHlVEetO3awrpvNSvBlhIX0Lq+hJulG 1243239645
Message-ID: <4A1A54DB.3090902@ladisch.de>
Date: Mon, 25 May 2009 10:20:43 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: David Fries <david@fries.net>
CC: David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: bad endpoint address, MOTU FastLane
References: <20090511221203.GB4300@spacedout.fries.net> <4A092B5C.603@ladisch.de> <20090524220756.GC4300@spacedout.fries.net>
In-Reply-To: <20090524220756.GC4300@spacedout.fries.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Fries wrote:
> On Tue, May 12, 2009 at 09:55:08AM +0200, Clemens Ladisch wrote:
> > The driver could call usb_set_interface() again for the first interface
> > so that the USB core takes notice of the first set of endpoints again.
> > Please try the patch below.
> > 
> > I guess I'll have to write another quirk for this.
> 
> Adding usb_set_interface lets the device work again, ...
> 
> The MOTU Fastlane device is the only one using QUIRK_MIDI_RAW.  How about
> changing the name to QUIRK_MIDI_FASTLANE to imply it isn't completely
> generic anymore and adding a comment?

And while we're at it, the driver should claim interface 1 to prevent
anyone else from using it.

New patch below.

Are you okay with the tested-by tag?

===========

sound: usb-audio: make the MotU Fastlane work again

Kernel 2.6.18 broke the MotU Fastlane, which uses duplicate endpoint
numbers in a manner that is not only illegal but also confuses the
kernel's endpoint descriptor caching mechanism.  To work around this, we
have to add a separate usb_set_interface() call to guide the USB core to
the correct descriptors.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: David Fries <david@fries.net>

--- linux/sound/usb/usbaudio.h
+++ linux/sound/usb/usbaudio.h
@@ -153,7 +153,7 @@ enum quirk_type {
 	QUIRK_MIDI_YAMAHA,
 	QUIRK_MIDI_MIDIMAN,
 	QUIRK_MIDI_NOVATION,
-	QUIRK_MIDI_RAW,
+	QUIRK_MIDI_FASTLANE,
 	QUIRK_MIDI_EMAGIC,
 	QUIRK_MIDI_CME,
 	QUIRK_MIDI_US122L,
--- linux/sound/usb/usbquirks.h
+++ linux/sound/usb/usbquirks.h
@@ -1868,11 +1868,11 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.data = & (const struct snd_usb_audio_quirk[]) {
 			{
 				.ifnum = 0,
-				.type = QUIRK_MIDI_RAW
+				.type = QUIRK_MIDI_FASTLANE
 			},
 			{
 				.ifnum = 1,
-				.type = QUIRK_IGNORE_INTERFACE
+				.type = QUIRK_MIDI_FASTLANE
 			},
 			{
 				.ifnum = -1
--- linux/sound/usb/usbaudio.c
+++ linux/sound/usb/usbaudio.c
@@ -3359,7 +3359,7 @@ static int snd_usb_create_quirk(struct s
 		[QUIRK_MIDI_YAMAHA] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_MIDIMAN] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_NOVATION] = snd_usb_create_midi_interface,
-		[QUIRK_MIDI_RAW] = snd_usb_create_midi_interface,
+		[QUIRK_MIDI_FASTLANE] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_EMAGIC] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_CME] = snd_usb_create_midi_interface,
 		[QUIRK_AUDIO_STANDARD_INTERFACE] = create_standard_audio_quirk,

--- linux/sound/usb/usbmidi.c
+++ linux/sound/usb/usbmidi.c
@@ -1573,6 +1573,33 @@ static int snd_usbmidi_detect_yamaha(str
 }
 
 /*
+ * Detects the endpoints and ports of the MotU Fastlane, and handles the
+ * interfaces' configuration.
+ */
+static int snd_usbmidi_detect_fastlane(struct snd_usb_midi *umidi,
+				       struct snd_usb_midi_endpoint_info *eps)
+{
+	switch (get_iface_desc(umidi->iface->altsetting)->bInterfaceNumber) {
+	case 0:
+		/*
+		 * Interface 1 contains isochronous endpoints, but with the same
+		 * numbers as in interface 0.  Since it is interface 1 that the
+		 * USB core has most recently seen, these descriptors are now
+		 * associated with the endpoint numbers.  This will foul up our
+		 * attempts to submit bulk/interrupt URBs to the endpoints in
+		 * interface 0, so we have to make sure that the USB core looks
+		 * again at interface 0 by calling usb_set_interface() on it.
+		 */
+		usb_set_interface(umidi->chip->dev, 0, 0);
+		return snd_usbmidi_detect_per_port_endpoints(umidi, eps);
+	case 1:
+		return 1; /* no MIDI device for this interface, just claim it */
+	default:
+		return -ENXIO;
+	}
+}
+
+/*
  * Creates the endpoints and their ports for Midiman devices.
  */
 static int snd_usbmidi_create_endpoints_midiman(struct snd_usb_midi* umidi,
@@ -1778,9 +1805,13 @@ int snd_usb_create_midi_interface(struct
 		umidi->usb_protocol_ops = &snd_usbmidi_novation_ops;
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
-	case QUIRK_MIDI_RAW:
+	case QUIRK_MIDI_FASTLANE:
 		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
-		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
+		err = snd_usbmidi_detect_fastlane(umidi, endpoints);
+		if (err == 1) {
+			kfree(umidi);
+			return 0;
+		}
 		break;
 	case QUIRK_MIDI_EMAGIC:
 		umidi->usb_protocol_ops = &snd_usbmidi_emagic_ops;
