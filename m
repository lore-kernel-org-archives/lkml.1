Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXIKM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXIKM0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762919AbXIKM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 08:26:11 -0400
Received: from mail.arklinux.osuosl.org ([140.211.166.26]:48761 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbXIKM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 08:26:10 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 08:26:09 EDT
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: alsa-devel@alsa-project.org
Subject: [PARTIAL PATCH] snd-hda-intel on Medion WIM2160
Date: Tue, 11 Sep 2007 14:16:24 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709111416.24299.bero@arklinux.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Medion WIM2160 notebooks (soundchip PCI ID 8086:27d8/17c0:4071), 
snd-hda-intel loads and everything acts like it's working, but there's no 
sound. The master volume is muted and there's no way to unmute it.

The patch below fixes it, but unfortunately, Medion MD2 uses the same PCI 
(and subvendor/subdevice) ID -- so the patch quite likely breaks Medion MD2 
support.

WIM2160's soundchip has revision ID 02 - if MD2 uses something else, maybe 
that can be used to identify them and do the right thing. (I don't have an 
MD2...).

ttyl
bero

--- linux-2.6.22/sound/pci/hda/patch_realtek.c.wim2160snd~	2007-07-09 
01:32:17.000000000 +0200
+++ linux-2.6.22/sound/pci/hda/patch_realtek.c	2007-09-09 20:28:55.000000000 
+0200
@@ -159,6 +159,7 @@
 	ALC883_ACER,
 	ALC883_MEDION,
 	ALC883_MEDION_MD2,	
+	ALC883_MEDION_WIM2160,
 	ALC883_LAPTOP_EAPD,
 	ALC883_LENOVO_101E_2ch,
 	ALC883_LENOVO_NB0763,
@@ -5995,6 +5996,32 @@
 	{ } /* end */
 };	
 
+static struct snd_kcontrol_new alc883_medion_wim2160_mixer[] = {
+	HDA_CODEC_VOLUME("Master Playback Volume", 0x0c, 0x0, HDA_OUTPUT),
+	HDA_BIND_MUTE("Master Playback Switch", 0x0c, 2, HDA_INPUT),
+	HDA_CODEC_MUTE("Headphone Playback Switch", 0x14, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("CD Playback Volume", 0x0b, 0x04, HDA_INPUT),
+	HDA_CODEC_MUTE("CD Playback Switch", 0x0b, 0x04, HDA_INPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x0b, 0x0, HDA_INPUT),
+	HDA_CODEC_VOLUME("iMic Playback Volume", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_MUTE("iMic Playback Switch", 0x0b, 0x1, HDA_INPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x08, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x08, 0x0, HDA_INPUT),
+	HDA_CODEC_VOLUME_IDX("Capture Volume", 1, 0x09, 0x0, HDA_INPUT),
+	HDA_CODEC_MUTE_IDX("Capture Switch", 1, 0x09, 0x0, HDA_INPUT),
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		/* .name = "Capture Source", */
+		.name = "Input Source",
+		.count = 2,
+		.info = alc883_mux_enum_info,
+		.get = alc883_mux_enum_get,
+		.put = alc883_mux_enum_put,
+	},
+	{ } /* end */
+};	
+
 static struct snd_kcontrol_new alc883_chmode_mixer[] = {
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -6364,6 +6391,7 @@
 	[ALC883_ACER]		= "acer",
 	[ALC883_MEDION]		= "medion",
 	[ALC883_MEDION_MD2]	= "medion-md2",
+	[ALC883_MEDION_WIM2160]	= "medion-wim2160",
 	[ALC883_LAPTOP_EAPD]	= "laptop-eapd",
 	[ALC883_LENOVO_101E_2ch] = "lenovo-101e",
 	[ALC883_LENOVO_NB0763]	= "lenovo-nb0763",
@@ -6401,6 +6429,7 @@
 	SND_PCI_QUIRK(0x17aa, 0x3bfd, "Lenovo NB0763", ALC883_LENOVO_NB0763),
 	SND_PCI_QUIRK(0x17aa, 0x2085, "Lenovo NB0763", ALC883_LENOVO_NB0763),
-	SND_PCI_QUIRK(0x17c0, 0x4071, "MEDION MD2", ALC883_MEDION_MD2),
+	//SND_PCI_QUIRK(0x17c0, 0x4071, "MEDION MD2", ALC883_MEDION_MD2),
+	SND_PCI_QUIRK(0x17c0, 0x4071, "Medion WIM2160", ALC883_MEDION_WIM2160),
 	{}
 };
 
@@ -6530,6 +6559,19 @@
 		.unsol_event = alc883_medion_md2_unsol_event,
 		.init_hook = alc883_medion_md2_automute,
 	},	
+	[ALC883_MEDION_WIM2160] = {
+		.mixers = { alc883_medion_wim2160_mixer },
+		.init_verbs = { alc883_init_verbs, alc883_lenovo_nb0763_verbs},
+		.num_dacs = ARRAY_SIZE(alc883_dac_nids),
+		.dac_nids = alc883_dac_nids,
+		.num_adc_nids = ARRAY_SIZE(alc883_adc_nids),
+		.adc_nids = alc883_adc_nids,
+		.num_channel_mode = ARRAY_SIZE(alc883_3ST_2ch_modes),
+		.channel_mode = alc883_3ST_2ch_modes,
+		.input_mux = &alc883_lenovo_nb0763_capture_source,
+		.unsol_event = alc883_medion_md2_unsol_event,
+		.init_hook = alc883_medion_md2_automute,
+	},
 	[ALC883_LAPTOP_EAPD] = {
 		.mixers = { alc883_base_mixer,
 			    alc883_chmode_mixer },
