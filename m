Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab0BPHkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 02:40:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:51287 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab0BPHkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 02:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gn5ET9/AVJmnj9QzZ2cdGuZB79kq6HGdwoLey0epuyvId7hA+EyxL9ivFSd/2QYYp8
         AbTHiauij+cgvzkwuSVpyMv3VGHYbbkj3uvG3KYssRnIrN68d0MvnjCmf7dG3pA160Dw
         k8Pn3DkLPcwEGlNfFinU5CaeWlhZgS5EOvx8A=
Message-ID: <4B7A4BEF.1030005@gmail.com>
Date: Tue, 16 Feb 2010 08:40:31 +0100
From: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH][ALSA] usbmidi support for Access Music synths.
References: <4B726306.8070506@gmail.com> <4B7274BA.3040801@ladisch.de> <4B73B96A.9040006@gmail.com> <4B73C3EC.2040606@ladisch.de> <4B745D00.5060201@gmail.com> <4B751E34.1000703@ladisch.de>
In-Reply-To: <4B751E34.1000703@ladisch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Sebastien Alaiwan wrote:
>> I've replaced the QUIRK_COMPOSITE by a QUIRK_MIDI_FIXED_ENDPOINT, the
>> module also probes (and fails) the USB interface 4 (I don't know
>> what this interface is for on this device) which results in the
>> printing of an error in the kernel log. How can I inform the
>> snd-usb-audio driver that the USB interface 4 should be left alone?
> 
> With a QUIRK_IGNORE_INTERFACE for that interface.  This means you need
> QUIRK_COMPOSITE again.
> 
> 
> HTH
> Clemens

Ok, this is done.
Here's an updated patch.

Thank you for your help!
Sebastien Alaiwan


---
Signed-off-by: Sebastien Alaiwan <sebastien.alaiwan@gmail.com>
diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 9edef46..aaf8f7c 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -3327,6 +3327,31 @@ static int snd_usb_cm6206_boot_quirk(struct usb_device *dev)
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
+
+	/* "midi send" enable */
+	static const u8 seq[] = { 0x4e, 0x73, 0x52, 0x01 };
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
@@ -3624,6 +3649,12 @@ static void *snd_usb_audio_probe(struct usb_device *dev,
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
diff --git a/sound/usb/usbmidi.c b/sound/usb/usbmidi.c
index 6e89b83..8f5bc1e 100644
--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1407,6 +1407,12 @@ static struct port_info {
 	EXTERNAL_PORT(0x086a, 0x0001, 8, "%s Broadcast"),
 	EXTERNAL_PORT(0x086a, 0x0002, 8, "%s Broadcast"),
 	EXTERNAL_PORT(0x086a, 0x0003, 4, "%s Broadcast"),
+	/* Access Music Virus TI */
+	EXTERNAL_PORT(0x133e, 0x0815, 0, "%s MIDI"),
+	PORT_INFO(0x133e, 0x0815, 1, "%s Synth", 0,
+		SNDRV_SEQ_PORT_TYPE_MIDI_GENERIC |
+		SNDRV_SEQ_PORT_TYPE_HARDWARE |
+		SNDRV_SEQ_PORT_TYPE_SYNTHESIZER),
 };
 
 static struct port_info *find_port_info(struct snd_usb_midi* umidi, int number)
diff --git a/sound/usb/usbquirks.h b/sound/usb/usbquirks.h
index a892bda..ef8f96c 100644
--- a/sound/usb/usbquirks.h
+++ b/sound/usb/usbquirks.h
@@ -2073,6 +2073,31 @@ YAMAHA_DEVICE(0x7010, "UB99"),
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
+				.ifnum = 3,
+				.type = QUIRK_MIDI_FIXED_ENDPOINT,
+				.data = &(const struct
+						snd_usb_midi_endpoint_info) {
+						.out_cables = 0x0003,
+						.in_cables  = 0x0003
+					}
+			},
+			{
+				.ifnum = 4,
+				.type = QUIRK_IGNORE_INTERFACE
+			},
+		}
+	}
+},
+
 /* */
 {
 	/* aka. Serato Scratch Live DJ Box */
