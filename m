Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0BJHlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:41:05 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:58866 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab0BJHlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CiB9duMv9T3dCw5u9jDs+epl5fgcIMu/GjQacOKnsJ3z0RwCuQ+miyfxoP1NDK/v32
         ta0kMDx2LE9xpTBaHLXWMKy97veBnCS8up5ZTD1K4GVK53OakS0Docw0pSwuxTxTOKAe
         Yp3DZqYQ8QL/2jmfkiZP/1VniExZOqPy9m8Xc=
Message-ID: <4B726306.8070506@gmail.com>
Date: Wed, 10 Feb 2010 08:40:54 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH][ALSA] usbmidi support for Access Music synths.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

here's a patch that adds MIDI support through USB for one of the Access Music synths, the VirusTI. 

The synth uses standard USBMIDI protocol on its USB interface 3, although it does signal "vendor specific" class. A magic string has to be sent on interface 3 to enable the sending of MIDI from the synth (this string was found by sniffing usb communication of the Windows driver). This is all my patch does, and it works on my computer.

Please note that the synth can also do standard usb audio I/O on its interfaces 2&3, which already works with the current snd-usb-audio driver, except for the audio input from the synth. I'm going to work on it when I have some time.


Regards,
Sebastien Alaiwan



Signed-off-by: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
--------------
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 9edef46..bb82ee9 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -3327,6 +3327,26 @@ static int snd_usb_cm6206_boot_quirk(struct usb_device *dev)
 }
 
 /*
+ * This call will put the synth in "USB send" mode, i.e it will send MIDI
+ * messages through USB (this is disabled at startup). The synth will aknowledge
+ * by sending a sysex on endpoint 0x85 and by displaying a USB sign on its LCD.
+ * Values here are chosen based on sniffing USB traffic under Windows.
+ */
+static int snd_usb_accessmusic_boot_quirk(struct usb_device* dev)
+{
+	int err, actual_length;
+	u8 seq[] = { 0x4e, 0x73, 0x52, 0x01 }; // "midi send" enable
+
+	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x05), seq,
+			ARRAY_SIZE(seq), &actual_length, 1000);
+	if(err < 0) {
+		return err;
+	}
+
+	return 0;
+}
+
+/*
  * Setup quirks
  */
 #define AUDIOPHILE_SET			0x01 /* if set, parse device_setup */
@@ -3403,6 +3423,7 @@ static int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_MIDI_FASTLANE] = create_any_midi_quirk,
 		[QUIRK_MIDI_EMAGIC] = create_any_midi_quirk,
 		[QUIRK_MIDI_CME] = create_any_midi_quirk,
+ 		[QUIRK_MIDI_ACCESSMUSIC] = create_any_midi_quirk,
 		[QUIRK_AUDIO_STANDARD_INTERFACE] = create_standard_audio_quirk,
 		[QUIRK_AUDIO_FIXED_ENDPOINT] = create_fixed_stream_quirk,
 		[QUIRK_AUDIO_EDIROL_UA1000] = create_ua1000_quirk,
@@ -3624,6 +3645,12 @@ static void *snd_usb_audio_probe(struct usb_device *dev,
 			goto __err_val;
 	}
 
+	/* Access Music VirusTI Desktop */
+	if (id == USB_ID(0x133e, 0x0815)) {
+		if (snd_usb_accessmusic_boot_quirk(dev) < 0)
+			goto __err_val;
+	}
+
 	/*
 	 * found a config.  now register to ALSA
 	 */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 40ba811..b69b5bf 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -156,6 +156,7 @@ enum quirk_type {
 	QUIRK_MIDI_EMAGIC,
 	QUIRK_MIDI_CME,
 	QUIRK_MIDI_US122L,
+	QUIRK_MIDI_ACCESSMUSIC,
 	QUIRK_AUDIO_STANDARD_INTERFACE,
 	QUIRK_AUDIO_FIXED_ENDPOINT,
 	QUIRK_AUDIO_EDIROL_UA1000,
diff --git a/sound/usb/usbmidi.c b/sound/usb/usbmidi.c
index 6e89b83..3db92e0 100644
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1724,6 +1724,28 @@ static int snd_usbmidi_detect_per_port_endpoints(struct snd_usb_midi* umidi,
 }
 
 /*
+ * Detects the endpoints for Access Music Virus TI
+ */
+static int snd_usbmidi_detect_two_cables_per_endpoint(struct snd_usb_midi* umidi,
+    struct snd_usb_midi_endpoint_info* endpoints)
+{
+	int err, i;
+
+	err = snd_usbmidi_detect_endpoints(umidi, endpoints, MIDI_MAX_ENDPOINTS);
+	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
+		if (endpoints[i].in_ep) {
+			printk("Creating two in cables for input EP 0x%.2X\n", endpoints[i].in_ep);
+			endpoints[i].in_cables = 0x0003;
+		}
+		if (endpoints[i].out_ep) {
+			printk("Creating two out cables for output EP 0x%.2X\n", endpoints[i].out_ep);
+			endpoints[i].out_cables = 0x0003;
+		}
+	}
+	return err;
+}
+
+/*
  * Detects the endpoints and ports of Yamaha devices.
  */
 static int snd_usbmidi_detect_yamaha(struct snd_usb_midi* umidi,
@@ -2002,6 +2024,9 @@ int snd_usbmidi_create(struct snd_card *card,
 		umidi->usb_protocol_ops = &snd_usbmidi_cme_ops;
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
+	case QUIRK_MIDI_ACCESSMUSIC:
+		err = snd_usbmidi_detect_two_cables_per_endpoint(umidi, endpoints);
+		break;
 	default:
 		snd_printd(KERN_ERR "invalid quirk type %d\n", quirk->type);
 		err = -ENXIO;
diff --git a/sound/usb/usbquirks.h b/sound/usb/usbquirks.h
index a892bda..709e076 100644
--- a/sound/usb/usbquirks.h
+++ b/sound/usb/usbquirks.h
@@ -2105,6 +2105,28 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Access Music devices */
+{
+	/* VirusTI Desktop */
+	USB_DEVICE_VENDOR_SPEC(0x133e, 0x0815),
+	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
+		.vendor_name = "AccessMusic",
+		.product_name = "Virus TI",
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = & (const struct snd_usb_audio_quirk[]) {
+			{
+				// "Virus TI MIDI" and "Virus TI Synth"
+				.ifnum = 3,
+				.type = QUIRK_MIDI_ACCESSMUSIC,
+			},
+			{
+				.ifnum = -1
+			}
+		}
+	}
+},
+
 {
 	/*
 	 * Some USB MIDI devices don't have an audio control interface,

