Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbZAWBSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbZAWBSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760151AbZAWBOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:55 -0500
Received: from kroah.org ([198.145.64.141]:50475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760123AbZAWBOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:51 -0500
Date: Thu, 22 Jan 2009 17:11:56 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Daniel Drake <dsd@gentoo.org>
Subject: [patch 14/46] ALSA: hda - make laptop-eapd model back for AD1986A
Message-ID: <20090123011156.GO19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-make-laptop-eapd-model-back-for-ad1986a.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1725b82a6e2721612a3572d0336f51f1f1c3cf54 upstream.

The changes specific for Samsung laptops seem unapplicable to other
hardware models like ASUS.  The mic inputs are lost on such hardware
by the change 5d5d5f43f1b835c375de9bd270cce030d16e2871.

This patch adds back the old laptop-eapd model, and create a new
model "samsung" for the new one specific to Samsung laptops with
automatic mic selection feature.

Reference: kernel bugzilla #12070
	http://bugzilla.kernel.org/show_bug.cgi?id=12070

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Drake <dsd@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/sound/alsa/ALSA-Configuration.txt |    3 -
 sound/pci/hda/patch_analog.c                    |   49 ++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 4 deletions(-)

--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -979,9 +979,10 @@ Prior to version 0.9.0rc4 options had a 
 	  6stack	6-jack, separate surrounds (default)
 	  3stack	3-stack, shared surrounds
 	  laptop	2-channel only (FSC V2060, Samsung M50)
-	  laptop-eapd	2-channel with EAPD (Samsung R65, ASUS A6J)
+	  laptop-eapd	2-channel with EAPD (ASUS A6J)
 	  laptop-automute 2-channel with EAPD and HP-automute (Lenovo N100)
 	  ultra		2-channel with EAPD (Samsung Ultra tablet PC)
+	  samsung	2-channel with EAPD (Samsung R65)
 
 	AD1988/AD1988B/AD1989A/AD1989B
 	  6stack	6-jack
--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -629,6 +629,36 @@ static struct snd_kcontrol_new ad1986a_l
 	HDA_BIND_SW("Master Playback Switch", &ad1986a_laptop_master_sw),
 	HDA_CODEC_VOLUME("PCM Playback Volume", 0x03, 0x0, HDA_OUTPUT),
 	HDA_CODEC_MUTE("PCM Playback Switch", 0x03, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Internal Mic Playback Volume", 0x17, 0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Internal Mic Playback Switch", 0x17, 0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Mic Playback Volume", 0x13, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Mic Playback Switch", 0x13, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Mic Boost", 0x0f, 0x0, HDA_OUTPUT),
+	HDA_CODEC_VOLUME("Capture Volume", 0x12, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("Capture Switch", 0x12, 0x0, HDA_OUTPUT),
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "Capture Source",
+		.info = ad198x_mux_enum_info,
+		.get = ad198x_mux_enum_get,
+		.put = ad198x_mux_enum_put,
+	},
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.name = "External Amplifier",
+		.info = ad198x_eapd_info,
+		.get = ad198x_eapd_get,
+		.put = ad198x_eapd_put,
+		.private_value = 0x1b | (1 << 8), /* port-D, inversed */
+	},
+	{ } /* end */
+};
+
+static struct snd_kcontrol_new ad1986a_samsung_mixers[] = {
+	HDA_BIND_VOL("Master Playback Volume", &ad1986a_laptop_master_vol),
+	HDA_BIND_SW("Master Playback Switch", &ad1986a_laptop_master_sw),
+	HDA_CODEC_VOLUME("PCM Playback Volume", 0x03, 0x0, HDA_OUTPUT),
+	HDA_CODEC_MUTE("PCM Playback Switch", 0x03, 0x0, HDA_OUTPUT),
 	HDA_CODEC_VOLUME("Mic Playback Volume", 0x13, 0x0, HDA_OUTPUT),
 	HDA_CODEC_MUTE("Mic Playback Switch", 0x13, 0x0, HDA_OUTPUT),
 	HDA_CODEC_VOLUME("Mic Boost", 0x0f, 0x0, HDA_OUTPUT),
@@ -917,6 +947,7 @@ enum {
 	AD1986A_LAPTOP_EAPD,
 	AD1986A_LAPTOP_AUTOMUTE,
 	AD1986A_ULTRA,
+	AD1986A_SAMSUNG,
 	AD1986A_MODELS
 };
 
@@ -927,6 +958,7 @@ static const char *ad1986a_models[AD1986
 	[AD1986A_LAPTOP_EAPD]	= "laptop-eapd",
 	[AD1986A_LAPTOP_AUTOMUTE] = "laptop-automute",
 	[AD1986A_ULTRA]		= "ultra",
+	[AD1986A_SAMSUNG]	= "samsung",
 };
 
 static struct snd_pci_quirk ad1986a_cfg_tbl[] = {
@@ -949,9 +981,9 @@ static struct snd_pci_quirk ad1986a_cfg_
 	SND_PCI_QUIRK(0x1179, 0xff40, "Toshiba", AD1986A_LAPTOP_EAPD),
 	SND_PCI_QUIRK(0x144d, 0xb03c, "Samsung R55", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x144d, 0xc01e, "FSC V2060", AD1986A_LAPTOP),
-	SND_PCI_QUIRK(0x144d, 0xc023, "Samsung X60", AD1986A_LAPTOP_EAPD),
-	SND_PCI_QUIRK(0x144d, 0xc024, "Samsung R65", AD1986A_LAPTOP_EAPD),
-	SND_PCI_QUIRK(0x144d, 0xc026, "Samsung X11", AD1986A_LAPTOP_EAPD),
+	SND_PCI_QUIRK(0x144d, 0xc023, "Samsung X60", AD1986A_SAMSUNG),
+	SND_PCI_QUIRK(0x144d, 0xc024, "Samsung R65", AD1986A_SAMSUNG),
+	SND_PCI_QUIRK(0x144d, 0xc026, "Samsung X11", AD1986A_SAMSUNG),
 	SND_PCI_QUIRK(0x144d, 0xc027, "Samsung Q1", AD1986A_ULTRA),
 	SND_PCI_QUIRK(0x144d, 0xc504, "Samsung Q35", AD1986A_3STACK),
 	SND_PCI_QUIRK(0x17aa, 0x1011, "Lenovo M55", AD1986A_LAPTOP),
@@ -1033,6 +1065,17 @@ static int patch_ad1986a(struct hda_code
 		break;
 	case AD1986A_LAPTOP_EAPD:
 		spec->mixers[0] = ad1986a_laptop_eapd_mixers;
+		spec->num_init_verbs = 2;
+		spec->init_verbs[1] = ad1986a_eapd_init_verbs;
+		spec->multiout.max_channels = 2;
+		spec->multiout.num_dacs = 1;
+		spec->multiout.dac_nids = ad1986a_laptop_dac_nids;
+		if (!is_jack_available(codec, 0x25))
+			spec->multiout.dig_out_nid = 0;
+		spec->input_mux = &ad1986a_laptop_eapd_capture_source;
+		break;
+	case AD1986A_SAMSUNG:
+		spec->mixers[0] = ad1986a_samsung_mixers;
 		spec->num_init_verbs = 3;
 		spec->init_verbs[1] = ad1986a_eapd_init_verbs;
 		spec->init_verbs[2] = ad1986a_automic_verbs;

