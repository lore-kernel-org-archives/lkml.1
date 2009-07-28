Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbZG1Xtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbZG1Xtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZG1Xty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:54 -0400
Received: from kroah.org ([198.145.64.141]:35721 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZG1Xtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:52 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:54 2009
Message-Id: <20090728234154.560168803@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 22/71] ALSA: hda - Fix pin-setup for Sony VAIO with STAC9872 codecs
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-pin-setup-for-sony-vaio-with-stac9872-codecs.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit b04add956616b6d89ff21da749b46ad2bd58ef32 upstream.

The recent rewrite of the codec parser for STAC9872 caused a regression
for some Sony VAIO models that don't give proper pin default configs
by BIOS.  Even using model=vaio doesn't work because the pin definitions
are set after the pin overrides.

This patch fixes the pin definitions in patch_stac9872() to be put
in the right place before the pin overrides.  Also the patch adds the
new quirk entry for VAIO F/S to have the correct pin default configs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -5661,6 +5661,8 @@ static unsigned int *stac9872_brd_tbl[ST
 };
 
 static struct snd_pci_quirk stac9872_cfg_tbl[] = {
+	SND_PCI_QUIRK_MASK(0x104d, 0xfff0, 0x81e0,
+			   "Sony VAIO F/S", STAC_9872_VAIO),
 	{} /* terminator */
 };
 
@@ -5673,6 +5675,8 @@ static int patch_stac9872(struct hda_cod
 	if (spec == NULL)
 		return -ENOMEM;
 	codec->spec = spec;
+	spec->num_pins = ARRAY_SIZE(stac9872_pin_nids);
+	spec->pin_nids = stac9872_pin_nids;
 
 	spec->board_config = snd_hda_check_board_config(codec, STAC_9872_MODELS,
 							stac9872_models,
@@ -5684,8 +5688,6 @@ static int patch_stac9872(struct hda_cod
 		stac92xx_set_config_regs(codec,
 					 stac9872_brd_tbl[spec->board_config]);
 
-	spec->num_pins = ARRAY_SIZE(stac9872_pin_nids);
-	spec->pin_nids = stac9872_pin_nids;
 	spec->multiout.dac_nids = spec->dac_nids;
 	spec->num_adcs = ARRAY_SIZE(stac9872_adc_nids);
 	spec->adc_nids = stac9872_adc_nids;


