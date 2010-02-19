Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab0BSRB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:01:27 -0500
Received: from kroah.org ([198.145.64.141]:57707 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936Ab0BSRA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:58 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:48 2010
Message-Id: <20100219163248.481541935@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Murray <murray.alex@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [65/93] ALSA: hda - Improved MacBook (Pro) 5,1 / 5,2 support
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Murray <murray.alex@gmail.com>

commit a76221d47ef2b73ff16c0fef00a784026308ea02 upstream.

This patch adds support for automatically muting the speakers when headphones
are inserted, as well as relabelling the headphone widgets from the
non-standard "HP" to the standard "Headphone" for the mb5 model.

Signed-off-by: Alex Murray <murray.alex@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7042,8 +7042,8 @@ static struct snd_kcontrol_new alc885_mb
 	HDA_BIND_MUTE   ("Surround Playback Switch", 0x0d, 0x02, HDA_INPUT),
 	HDA_CODEC_VOLUME("LFE Playback Volume", 0x0e, 0x00, HDA_OUTPUT),
 	HDA_BIND_MUTE   ("LFE Playback Switch", 0x0e, 0x02, HDA_INPUT),
-	HDA_CODEC_VOLUME("HP Playback Volume", 0x0f, 0x00, HDA_OUTPUT),
-	HDA_BIND_MUTE   ("HP Playback Switch", 0x0f, 0x02, HDA_INPUT),
+	HDA_CODEC_VOLUME("Headphone Playback Volume", 0x0f, 0x00, HDA_OUTPUT),
+	HDA_BIND_MUTE   ("Headphone Playback Switch", 0x0f, 0x02, HDA_INPUT),
 	HDA_CODEC_VOLUME("Line Playback Volume", 0x0b, 0x02, HDA_INPUT),
 	HDA_CODEC_MUTE  ("Line Playback Switch", 0x0b, 0x02, HDA_INPUT),
 	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x01, HDA_INPUT),
@@ -7430,6 +7430,7 @@ static struct hda_verb alc885_mb5_init_v
 	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
 	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
 	{0x14, AC_VERB_SET_CONNECT_SEL, 0x03},
+	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, ALC880_HP_EVENT | AC_USRSP_EN},
 	/* Front Mic pin: input vref at 80% */
 	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_VREF80},
 	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
@@ -7554,6 +7555,27 @@ static void alc885_mbp3_setup(struct hda
 	spec->autocfg.speaker_pins[0] = 0x14;
 }
 
+static void alc885_mb5_automute(struct hda_codec *codec)
+{
+	unsigned int present;
+
+	present = snd_hda_codec_read(codec, 0x14, 0,
+				     AC_VERB_GET_PIN_SENSE, 0) & 0x80000000;
+	snd_hda_codec_amp_stereo(codec, 0x18, HDA_OUTPUT, 0,
+				 HDA_AMP_MUTE, present ? HDA_AMP_MUTE : 0);
+	snd_hda_codec_amp_stereo(codec, 0x1a, HDA_OUTPUT, 0,
+				 HDA_AMP_MUTE, present ? HDA_AMP_MUTE : 0);
+
+}
+
+static void alc885_mb5_unsol_event(struct hda_codec *codec,
+				    unsigned int res)
+{
+	/* Headphone insertion or removal. */
+	if ((res >> 26) == ALC880_HP_EVENT)
+		alc885_mb5_automute(codec);
+}
+
 
 static struct hda_verb alc882_targa_verbs[] = {
 	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
@@ -8996,6 +9018,8 @@ static struct alc_config_preset alc882_p
 		.input_mux = &mb5_capture_source,
 		.dig_out_nid = ALC882_DIGOUT_NID,
 		.dig_in_nid = ALC882_DIGIN_NID,
+		.unsol_event = alc885_mb5_unsol_event,
+		.init_hook = alc885_mb5_automute,
 	},
 	[ALC885_MACPRO] = {
 		.mixers = { alc882_macpro_mixer },


