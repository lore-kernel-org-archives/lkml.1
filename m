Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab0BWJTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:19:53 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:61859 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0BWJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:19:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Wbd6BlKrH55ZxvBxACTn1gfc6cI4ZiuyqW4Ag50e4nglnVdpgp9Ql3ZAUUc08Tk6gK
         P79+RmPtWzev4nDfURfIbqXnMi2AemPA9IqlGOvpToPlpztg+3DjQENmd5d88sEX+SqI
         FQGK4rrnECrCfOsvhTFVOPsRpDWDBU55/Xzmc=
Subject: [PATCH] ALSA: add support for Macbook Air 2,1 internal speaker.
From: Reimundo Heluani <rheluani@gmail.com>
To: alsa-devel <alsa-devel@alsa-project.org>
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 23 Feb 2010 01:19:51 -0800
Message-ID: <1266916791.4582.19.camel@vino>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Reimundo Heluani <rheluani@gmail.com>

Add support for Macbook Air 2,1 (late 2008) internal speaker and 
headphones. Create a "mba21" model for snd-hda-intel.

Signed-off-by: Reimundo Heluani <rheluani@gmail.com>

---
Still missing internal microphone support

--- linux-2.6/sound/pci/hda/patch_realtek.c.orig	2010-02-23
00:36:16.000000000 -0800
+++ linux-2.6/sound/pci/hda/patch_realtek.c	2010-02-23
00:44:35.000000000 -0800
@@ -207,6 +207,7 @@ enum {
 	ALC882_ASUS_A7J,
 	ALC882_ASUS_A7M,
 	ALC885_MACPRO,
+	ALC885_MBA21,
 	ALC885_MBP3,
 	ALC885_MB5,
 	ALC885_IMAC24,
@@ -6852,6 +6853,13 @@ static struct hda_channel_mode alc882_si
 	{ 8, alc882_sixstack_ch8_init },
 };
 
+
+/* Macbook Air 2,1 */
+
+static struct hda_channel_mode alc885_mba21_ch_modes[1] = {
+      { 2, NULL },
+};
+
 /*
  * macbook pro ALC885 can switch LineIn to LineOut without losing Mic
  */
@@ -7123,6 +7131,15 @@ static struct snd_kcontrol_new alc882_ba
 	{ } /* end */
 };
 
+/* Macbook Air 2,1 same control for HP and internal Speaker */
+
+static struct snd_kcontrol_new alc885_mba21_mixer[] = {
+      HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00,
HDA_OUTPUT),
+      HDA_BIND_MUTE("Speaker Playback Switch", 0x0c, 0x02, HDA_OUTPUT),
+     { }
+};
+
+
 static struct snd_kcontrol_new alc885_mbp3_mixer[] = {
 	HDA_CODEC_VOLUME("Speaker Playback Volume", 0x0c, 0x00, HDA_OUTPUT),
 	HDA_BIND_MUTE   ("Speaker Playback Switch", 0x0c, 0x02, HDA_INPUT),
@@ -7562,6 +7579,29 @@ static struct hda_verb alc885_mb5_init_v
 	{ }
 };
 
+
+static struct hda_verb alc885_mba21_init_verbs[] = {
+	/*Internal and HP Speaker Mixer*/
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_ZERO},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(0)},
+	{0x0c, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
+	/*Internal Speaker Pin (0x0c)*/
+	{0x18, AC_VERB_SET_PIN_WIDGET_CONTROL, (PIN_OUT |
AC_PINCTL_VREF_50) },
+	{0x18, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x18, AC_VERB_SET_CONNECT_SEL, 0x00},
+	/* HP Pin: output 0 (0x0e) */
+	{0x14, AC_VERB_SET_PIN_WIDGET_CONTROL, 0xc4},
+	{0x14, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+	{0x14, AC_VERB_SET_CONNECT_SEL, 0x00},
+	{0x14, AC_VERB_SET_UNSOLICITED_ENABLE, (ALC880_HP_EVENT |
AC_USRSP_EN)},
+	/* Line in (is hp when jack connected)*/
+	{0x19, AC_VERB_SET_PIN_WIDGET_CONTROL, AC_PINCTL_VREF_50},
+	{0x19, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_MUTE},
+
+	{ }
+ };
+
+
 /* Macbook Pro rev3 */
 static struct hda_verb alc885_mbp3_init_verbs[] = {
 	/* Front mixer: unmute input/output amp left and right (volume = 0) */
@@ -7724,6 +7764,17 @@ static void alc885_imac24_setup(struct h
 	spec->autocfg.speaker_pins[1] = 0x1a;
 }
 
+/* Macbook Air 2,1 */
+static void alc885_mba21_setup(struct hda_codec *codec)
+{
+       struct alc_spec *spec = codec->spec;
+
+       spec->autocfg.hp_pins[0] = 0x14;
+       spec->autocfg.speaker_pins[0] = 0x18;
+}
+
+
+
 static void alc885_mbp3_setup(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -8938,6 +8989,7 @@ static const char *alc882_models[ALC882_
 	[ALC882_ASUS_A7M]	= "asus-a7m",
 	[ALC885_MACPRO]		= "macpro",
 	[ALC885_MB5]		= "mb5",
+	[ALC885_MBA21]		= "mba21",
 	[ALC885_MBP3]		= "mbp3",
 	[ALC885_IMAC24]		= "imac24",
 	[ALC885_IMAC91]		= "imac91",
@@ -9172,6 +9224,18 @@ static struct alc_config_preset alc882_p
 		.input_mux = &alc882_capture_source,
 		.dig_out_nid = ALC882_DIGOUT_NID,
 	},
+	   [ALC885_MBA21] = {
+			.mixers = { alc885_mba21_mixer },
+			.init_verbs = { alc885_mba21_init_verbs, alc880_gpio1_init_verbs },
+			.num_dacs = 2,
+			.dac_nids = alc882_dac_nids,
+			.channel_mode = alc885_mba21_ch_modes,
+			.num_channel_mode = ARRAY_SIZE(alc885_mba21_ch_modes),
+			.input_mux = &alc882_capture_source,
+			.unsol_event = alc_automute_amp_unsol_event,
+			.setup = alc885_mba21_setup,
+			.init_hook = alc_automute_amp,
+       },
 	[ALC885_MBP3] = {
 		.mixers = { alc885_mbp3_mixer, alc882_chmode_mixer },
 		.init_verbs = { alc885_mbp3_init_verbs,


