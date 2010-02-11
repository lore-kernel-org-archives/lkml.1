Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab0BKIBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 03:01:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:54269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0BKIBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 03:01:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=A3rv8MJnF+740RpJ+PInOMUnnX019rRPKVmFM1iIv8JNeYc+aSGALQhA/WgjbTR0O+
         1jHyrMZasu3Nz3SWYQrO4XlzUpX0HIFcyroEvYzj4BYbYiqvCbtEiWYl1fOjdc5a9mwP
         6ganS14Xr0pV7uAIygajrBTQ9t6Yb1d8lp7mU=
Message-ID: <4B73B96A.9040006@gmail.com>
Date: Thu, 11 Feb 2010 09:01:46 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH][ALSA] usbmidi support for Access Music synths.
References: <4B726306.8070506@gmail.com> <4B7274BA.3040801@ladisch.de>
In-Reply-To: <4B7274BA.3040801@ladisch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Sebastien Alaiwan wrote:
>> here's a patch that adds MIDI support through USB for one of the
>> Access Music synths, the VirusTI. 
> 
> Thanks!
> 
> Please run the checkpatch script on your patch.

Done!
I did not know such a tool did exist, thank you for pointing this out. Is there
a document I could read about such rules of thumb?

>> +			endpoints[i].in_cables = 0x0003;
>> +		}
>> +		if (endpoints[i].out_ep) {
>> +			printk("Creating two out cables for output EP 0x%.2X\n", endpoints[i].out_ep);
>> +			endpoints[i].out_cables = 0x0003;
>> +		}
>> +	}
>> +	return err;
>> +}
> 
> Does this device use more than one endpoint per direction?  If not, this
> could be done with QUIRK_MIDI_FIXED_ENDPOINT.

There's only one endpoint per direction, but there are two cables per endpoint:
endpoint 0x05, cable 0 : physical MIDI output port of the device.
endpoint 0x05, cable 1 : synth (output: send note-on, etc...)
endpoint 0x85, cable 0 : physical MIDI input port of the device.
endpoint 0x85, cable 1 : synth (input: recv sysex, controller changes)

Please correct me if I'm wrong, but it seems QUIRK_MIDI_FIXED_ENDPOINT would not
do the job, otherwise where do I signal the number of cables?

Here's an updated patch below.

Regards,
Sebastien Alaiwan


-------------
Signed-off-by: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 9edef46..0e54e93 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -3327,6 +3327,29 @@ static int snd_usb_cm6206_boot_quirk(struct usb_device *dev)
 }
 
 /*
+ * This call will put the synth in "USB send" mode, i.e it will send MIDI
+ * messages through USB (this is disabled at startup). The synth will aknowledge
+ * by sending a sysex on endpoint 0x85 and by displaying a USB sign on its LCD.
+ * Values here are chosen based on sniffing USB traffic under Windows.
+ */
+static int snd_usb_accessmusic_boot_quirk(struct usb_device *dev)
+{
+	int err, actual_length;
+	u8 seq[] = { 0x4e, 0x73, 0x52, 0x01 }; /* "midi send" enable */
+
+	void *buf = kmemdup(seq, ARRAY_SIZE(seq), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	err = usb_interrupt_msg(dev, usb_sndintpipe(dev, 0x05), buf,
+			ARRAY_SIZE(seq), &actual_length, 1000);
+	kfree(buf);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+/*
  * Setup quirks
  */
 #define AUDIOPHILE_SET			0x01 /* if set, parse device_setup */
@@ -3403,6 +3426,7 @@ static int snd_usb_create_quirk(struct snd_usb_audio *chip,
 		[QUIRK_MIDI_FASTLANE] = create_any_midi_quirk,
 		[QUIRK_MIDI_EMAGIC] = create_any_midi_quirk,
 		[QUIRK_MIDI_CME] = create_any_midi_quirk,
+		[QUIRK_MIDI_ACCESSMUSIC] = create_any_midi_quirk,
 		[QUIRK_AUDIO_STANDARD_INTERFACE] = create_standard_audio_quirk,
 		[QUIRK_AUDIO_FIXED_ENDPOINT] = create_fixed_stream_quirk,
 		[QUIRK_AUDIO_EDIROL_UA1000] = create_ua1000_quirk,
@@ -3624,6 +3648,12 @@ static void *snd_usb_audio_probe(struct usb_device *dev,
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
index 6e89b83..6e48606 100644
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1407,6 +1407,9 @@ static struct port_info {
 	EXTERNAL_PORT(0x086a, 0x0001, 8, "%s Broadcast"),
 	EXTERNAL_PORT(0x086a, 0x0002, 8, "%s Broadcast"),
 	EXTERNAL_PORT(0x086a, 0x0003, 4, "%s Broadcast"),
+	/* Access Music Virus TI */
+	EXTERNAL_PORT(0x133e, 0x0815, 0, "%s MIDI"),
+	CONTROL_PORT(0x133e, 0x0815, 1, "%s Control"),
 };
 
 static struct port_info *find_port_info(struct snd_usb_midi* umidi, int number)
@@ -1724,6 +1727,32 @@ static int snd_usbmidi_detect_per_port_endpoints(struct snd_usb_midi* umidi,
 }
 
 /*
+ * Detects the endpoints for Access Music Virus TI
+ */
+static int snd_usbmidi_detect_two_cables_per_endpoint(
+    struct snd_usb_midi *umidi,
+    struct snd_usb_midi_endpoint_info *endpoints)
+{
+	int err, i;
+
+	err = snd_usbmidi_detect_endpoints(umidi, endpoints,
+			MIDI_MAX_ENDPOINTS);
+	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
+		if (endpoints[i].in_ep) {
+			snd_printdd("Creating 2 cables for input EP 0x%.2X\n",
+					endpoints[i].in_ep);
+			endpoints[i].in_cables = 0x0003;
+		}
+		if (endpoints[i].out_ep) {
+			snd_printdd("Creating 2 cables for output EP 0x%.2X\n",
+					endpoints[i].out_ep);
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
@@ -2002,6 +2031,10 @@ int snd_usbmidi_create(struct snd_card *card,
 		umidi->usb_protocol_ops = &snd_usbmidi_cme_ops;
 		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
 		break;
+	case QUIRK_MIDI_ACCESSMUSIC:
+		err = snd_usbmidi_detect_two_cables_per_endpoint(umidi,
+				endpoints);
+		break;
 	default:
 		snd_printd(KERN_ERR "invalid quirk type %d\n", quirk->type);
 		err = -ENXIO;
diff --git a/sound/usb/usbquirks.h b/sound/usb/usbquirks.h
index a892bda..759f824 100644
--- a/sound/usb/usbquirks.h
+++ b/sound/usb/usbquirks.h
@@ -2073,6 +2073,26 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 	}
 },
 
+/* Access Music devices */
+{
+	/* VirusTI Desktop */
+	USB_DEVICE_VENDOR_SPEC(0x133e, 0x0815),
+	.driver_info = (unsigned long) &(const struct snd_usb_audio_quirk) {
+		.ifnum = QUIRK_ANY_INTERFACE,
+		.type = QUIRK_COMPOSITE,
+		.data = &(const struct snd_usb_audio_quirk[]) {
+			{
+				/* "Virus TI MIDI" and "Virus TI Synth" */
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
 /* */
 {
 	/* aka. Serato Scratch Live DJ Box */
