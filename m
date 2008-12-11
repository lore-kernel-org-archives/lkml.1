Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYLKTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYLKTdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbYLKTSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:49 -0500
Received: from kroah.org ([198.145.64.141]:56303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757731AbYLKTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:47 -0500
Date: Thu, 11 Dec 2008 11:15:10 -0800
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
       alan@lxorguk.ukuu.org.uk, Pascal Terjan <pterjan@mandriva.com>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 44/83] ALSA: hda - Fix sound on NEC Versa S9100
Message-ID: <20081211191510.GR5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-sound-on-nec-versa-s9100.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pascal Terjan <pterjan@mandriva.com>

commit e8f9ae2a4a0654e7798b8c0ae956e3f0fdc23c8d upstream

This patch adds sound support for NEC Versa S9100
With it, we get sound on the internal speaker and headphone (with
automute working) while there is no sound by default.
External mic also works fine but I don't know if there is an internal
one (if there is an internal mic it does not work currently), and I
had to send back the hardware.

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |   48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -100,6 +100,7 @@ enum {
 	ALC262_BENQ_T31,
 	ALC262_ULTRA,
 	ALC262_LENOVO_3000,
+	ALC262_NEC,
 	ALC262_AUTO,
 	ALC262_MODEL_LAST /* last tag */
 };
@@ -8948,6 +8949,41 @@ static void alc262_hippo1_unsol_event(st
 }
 
 /*
+ * nec model
+ *  0x15 = headphone
+ *  0x16 = internal speaker
+ *  0x18 = external mic
+ */
+
+static struct snd_kcontrol_new alc262_nec_mixer[] = {
+	HDA_CODEC_VOLUME_MONO("Speaker Playback Volume", 0x0e, 1, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE_MONO("Speaker Playback Switch", 0x16, 0, 0x0, HDA_OUTPUT),
+
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Boost", 0x18, 0, HDA_INPUT),
+
+	HDA_CODEC_VOLUME("Headphone Playback Volume", 0x0d, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Headphone Playback Switch", 0x15, 0x0, HDA_OUTPUT),
+	{ } /* end */
+};
+
+static struct hda_verb alc262_nec_verbs[] = {
+	/* Unmute Speaker */
+	{0x16, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE},
+
+	/* Headphone */
+	{0x15, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
+	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT},
+
+	/* External mic to headphone */
+	{0x0d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
+	/* External mic to speaker */
+	{0x0e, AC_VERB_SET_AMP_GAIN_MUTE, AMP_IN_UNMUTE(1)},
+	{}
+};
+
+/*
  * fujitsu model
  *  0x14 = headphone/spdif-out, 0x15 = internal speaker,
  *  0x1b = port replicator headphone out
@@ -9731,11 +9767,13 @@ static const char *alc262_models[ALC262_
 	[ALC262_SONY_ASSAMD]	= "sony-assamd",
 	[ALC262_ULTRA]		= "ultra",
 	[ALC262_LENOVO_3000]	= "lenovo-3000",
+	[ALC262_NEC]		= "nec",
 	[ALC262_AUTO]		= "auto",
 };
 
 static struct snd_pci_quirk alc262_cfg_tbl[] = {
 	SND_PCI_QUIRK(0x1002, 0x437b, "Hippo", ALC262_HIPPO),
+	SND_PCI_QUIRK(0x1033, 0x8895, "NEC Versa S9100", ALC262_NEC),
 	SND_PCI_QUIRK(0x103c, 0x12fe, "HP xw9400", ALC262_HP_BPC),
 	SND_PCI_QUIRK(0x103c, 0x12ff, "HP xw4550", ALC262_HP_BPC),
 	SND_PCI_QUIRK(0x103c, 0x1306, "HP xw8600", ALC262_HP_BPC),
@@ -9946,6 +9984,16 @@ static struct alc_config_preset alc262_p
 		.input_mux = &alc262_fujitsu_capture_source,
 		.unsol_event = alc262_lenovo_3000_unsol_event,
 	},
+	[ALC262_NEC] = {
+		.mixers = { alc262_nec_mixer },
+		.init_verbs = { alc262_nec_verbs },
+		.num_dacs = ARRAY_SIZE(alc262_dac_nids),
+		.dac_nids = alc262_dac_nids,
+		.hp_nid = 0x03,
+		.num_channel_mode = ARRAY_SIZE(alc262_modes),
+		.channel_mode = alc262_modes,
+		.input_mux = &alc262_capture_source,
+	},
 };
 
 static int patch_alc262(struct hda_codec *codec)

