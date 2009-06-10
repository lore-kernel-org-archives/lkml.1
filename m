Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbZFJDll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbZFJDll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZFJDfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:35:09 -0400
Received: from kroah.org ([198.145.64.141]:57037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbZFJDfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:35:07 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 17:23:46 2009
Message-Id: <20090610002346.623474622@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 17:13:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 30/60] sound: usb-audio: make the MotU Fastlane work again
References: <20090610001328.251476848@blue.kroah.org>
Content-Disposition: inline; filename=sound-usb-audio-make-the-motu-fastlane-work-again.patch
In-Reply-To: <20090610032135.GA19346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit 55de5ef970c680d8d75f2a9aa7e4f172140dbd9c upstream.

Kernel 2.6.18 broke the MotU Fastlane, which uses duplicate endpoint
numbers in a manner that is not only illegal but also confuses the
kernel's endpoint descriptor caching mechanism.  To work around this, we
have to add a separate usb_set_interface() call to guide the USB core to
the correct descriptors.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-and-tested-by: David Fries <david@fries.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c  |    2 +-
 sound/usb/usbaudio.h  |    2 +-
 sound/usb/usbmidi.c   |   12 +++++++++++-
 sound/usb/usbquirks.h |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -3367,7 +3367,7 @@ static int snd_usb_create_quirk(struct s
 		[QUIRK_MIDI_YAMAHA] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_MIDIMAN] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_NOVATION] = snd_usb_create_midi_interface,
-		[QUIRK_MIDI_RAW] = snd_usb_create_midi_interface,
+		[QUIRK_MIDI_FASTLANE] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_EMAGIC] = snd_usb_create_midi_interface,
 		[QUIRK_MIDI_CME] = snd_usb_create_midi_interface,
 		[QUIRK_AUDIO_STANDARD_INTERFACE] = create_standard_audio_quirk,
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -153,7 +153,7 @@ enum quirk_type {
 	QUIRK_MIDI_YAMAHA,
 	QUIRK_MIDI_MIDIMAN,
 	QUIRK_MIDI_NOVATION,
-	QUIRK_MIDI_RAW,
+	QUIRK_MIDI_FASTLANE,
 	QUIRK_MIDI_EMAGIC,
 	QUIRK_MIDI_CME,
 	QUIRK_AUDIO_STANDARD_INTERFACE,
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1733,8 +1733,18 @@ int snd_usb_create_midi_interface(struct
 		umidi->usb_protocol_ops = &snd_usbmidi_novation_ops;
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
-	case QUIRK_MIDI_RAW:
+	case QUIRK_MIDI_FASTLANE:
 		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
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
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
 	case QUIRK_MIDI_EMAGIC:
--- a/sound/usb/usbquirks.h
+++ b/sound/usb/usbquirks.h
@@ -1756,7 +1756,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		.data = & (const struct snd_usb_audio_quirk[]) {
 			{
 				.ifnum = 0,
-				.type = QUIRK_MIDI_RAW
+				.type = QUIRK_MIDI_FASTLANE
 			},
 			{
 				.ifnum = 1,


