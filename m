Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZG1X7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZG1X7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZG1X7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:59:38 -0400
Received: from kroah.org ([198.145.64.141]:35732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZG1Xtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:55 2009
Message-Id: <20090728234154.869808497@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 24/71] ALSA: hda - Fix mute control with some ALC262 models
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-fix-mute-control-with-some-alc262-models.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8de56b7deb2534a586839eda52843c1dae680dc5 upstream.

The master mute switch is wrongly implemented as checking the pointer
instead of its value, thus it can be never muted.  This patch fixes
the issue.

Reference: Novell bnc#404873
	https://bugzilla.novell.com/show_bug.cgi?id=404873

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10204,6 +10204,18 @@ static void alc262_lenovo_3000_unsol_eve
 	alc262_lenovo_3000_automute(codec, 1);
 }
 
+static int amp_stereo_mute_update(struct hda_codec *codec, hda_nid_t nid,
+				  int dir, int idx, long *valp)
+{
+	int i, change = 0;
+
+	for (i = 0; i < 2; i++, valp++)
+		change |= snd_hda_codec_amp_update(codec, nid, i, dir, idx,
+						   HDA_AMP_MUTE,
+						   *valp ? 0 : HDA_AMP_MUTE);
+	return change;
+}
+
 /* bind hp and internal speaker mute (with plug check) */
 static int alc262_fujitsu_master_sw_put(struct snd_kcontrol *kcontrol,
 					 struct snd_ctl_elem_value *ucontrol)
@@ -10212,13 +10224,8 @@ static int alc262_fujitsu_master_sw_put(
 	long *valp = ucontrol->value.integer.value;
 	int change;
 
-	change = snd_hda_codec_amp_stereo(codec, 0x14, HDA_OUTPUT, 0,
-						 HDA_AMP_MUTE,
-						 valp ? 0 : HDA_AMP_MUTE);
-	change |= snd_hda_codec_amp_stereo(codec, 0x1b, HDA_OUTPUT, 0,
-						 HDA_AMP_MUTE,
-						 valp ? 0 : HDA_AMP_MUTE);
-
+	change = amp_stereo_mute_update(codec, 0x14, HDA_OUTPUT, 0, valp);
+	change |= amp_stereo_mute_update(codec, 0x1b, HDA_OUTPUT, 0, valp);
 	if (change)
 		alc262_fujitsu_automute(codec, 0);
 	return change;
@@ -10253,10 +10260,7 @@ static int alc262_lenovo_3000_master_sw_
 	long *valp = ucontrol->value.integer.value;
 	int change;
 
-	change = snd_hda_codec_amp_stereo(codec, 0x1b, HDA_OUTPUT, 0,
-						 HDA_AMP_MUTE,
-						 valp ? 0 : HDA_AMP_MUTE);
-
+	change = amp_stereo_mute_update(codec, 0x1b, HDA_OUTPUT, 0, valp);
 	if (change)
 		alc262_lenovo_3000_automute(codec, 0);
 	return change;
@@ -11377,12 +11381,7 @@ static int alc268_acer_master_sw_put(str
 	long *valp = ucontrol->value.integer.value;
 	int change;
 
-	change = snd_hda_codec_amp_update(codec, 0x14, 0, HDA_OUTPUT, 0,
-					  HDA_AMP_MUTE,
-					  valp[0] ? 0 : HDA_AMP_MUTE);
-	change |= snd_hda_codec_amp_update(codec, 0x14, 1, HDA_OUTPUT, 0,
-					   HDA_AMP_MUTE,
-					   valp[1] ? 0 : HDA_AMP_MUTE);
+	change = amp_stereo_mute_update(codec, 0x14, HDA_OUTPUT, 0, valp);
 	if (change)
 		alc268_acer_automute(codec, 0);
 	return change;


