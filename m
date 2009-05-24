Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZEXQto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZEXQto (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZEXQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 12:49:37 -0400
Received: from luminismail.carleton.ca ([134.117.2.27]:35212 "EHLO
	luminismail.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZEXQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 12:49:36 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 12:49:36 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Message-id: <4A196C8D.10200@superonline.com>
Date: Sun, 24 May 2009 11:49:33 -0400
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
To: linux-kernel@vger.kernel.org
Subject: [Bisected regression] Microphone no longer works on Toshiba Satellite
 A100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After testing 2.6.30-rc6, I noticed that microphone input on my Toshiba Satellite
A100 laptop is no longer working; that is, my microphone input longer captures sound.
This laptop's sound card has a Realtek ALC 861 codec, and by default the auto probe
mechanism is used; I am not using a "model=..." argument. The sound input works
properly in 2.6.29 (and before.)

After bisecting the differences between 2.6.29 and 2.6.30-rc6, I found the commit
which causes this regression:

=== 8< ===
23f0c048ba59ad5c2f3fd85ed98360b631dbf6f8 is first bad commit
commit 23f0c048ba59ad5c2f3fd85ed98360b631dbf6f8
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Feb 26 13:03:58 2009 +0100

    ALSA: hda - Clean up the input pin setup in automatic mode

    Clean up the input-pin setup in automatic mode in patch_realtek.c.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>
=== >8 ===

A look at the changes introduced by this commit gave more information about the
cause of this regression. Below are the new function introduced and two diff
blocks from this commit. [1] As you can see, the original code for ALC /861/
does not have the "reading pincap, shifting it and checking whether it has a
certain bit set" kind of algorithm. This comment applies to most other codecs
modified by this commit too.

Judging from the code that was in the tree before the mentioned commit, only
ALC /882/ needed the "checking whether pincap has a certain bit set" algorithm.
I believe that the inclusion of the "checking whether pincap has..." algorithm
to the codecs /other/ than the ALC 882 broke the other codecs. Unfortunately,
since I don't have the any hardware other than ALC 861, I cannot say whether
this commit broke the sound input on other codecs.

For the record, I applied the following patch to the kernel source,

=== 8< ===
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b340630..0d0957e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -772,6 +772,7 @@ static void alc_set_input_pin(struct hda_codec *codec, hda_nid_t nid,
 		unsigned int pincap;
 		pincap = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
 		pincap = (pincap & AC_PINCAP_VREF) >> AC_PINCAP_VREF_SHIFT;
+		printk(KERN_INFO "pincap: 0x%x, AC_PINCAP_VREF_80: 0x%x\n", pincap, AC_PINCAP_VREF_80);
 		if (pincap & AC_PINCAP_VREF_80)
 			val = PIN_VREF80;
 	}
=== >8 ===

and here's the output I get:

=== 8< ===
pincap: 0x3, AC_PINCAP_VREF_80: 0x10
=== >8 ===

As you can see, my pincap value does not have the necessary bit set to meet the
requirements of ALC 882's algorithm.

I also hoped that this problem had already been noticed and fixed. With this
hope, I cloned the sound-2.6 tree by Takashi Iwai; however, while I didn't
compile and test it, I didn't see any changes related to this problem in the
log of sound-2.6 tree. (I also looked at sound-2.6 tree's
"sound/pci/hda/patch_realtek.c" file.)

I believe that this is a regression which breaks an important functionality.
I am willing to do testing, etc. to help in resolving this problem.

Regards,

M. Vefa Bicakci

[1] Appended is the mentioned code, which is a part of the mentioned commit,
with only the parts related to this regression kept.

=== 8< ===
 /*
+ * set up the input pin config (depending on the given auto-pin type)
+ */
+static void alc_set_input_pin(struct hda_codec *codec, hda_nid_t nid,
+			      int auto_pin_type)
+{
+	unsigned int val = PIN_IN;
+
+	if (auto_pin_type <= AUTO_PIN_FRONT_MIC) {
+		unsigned int pincap;
+		pincap = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
+		pincap = (pincap & AC_PINCAP_VREF) >> AC_PINCAP_VREF_SHIFT;
+		if (pincap & AC_PINCAP_VREF_80)
+			val = PIN_VREF80;
+	}
+	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, val);
+}
+
+/*
  */
 static void add_mixer(struct alc_spec *spec, struct snd_kcontrol_new *mix)
 {

[snip]

@@ -7006,16 +7018,7 @@ static void alc882_auto_init_analog_input(struct hda_codec *codec)
 		unsigned int vref;
 		if (!nid)
 			continue;
-		vref = PIN_IN;
-		if (1 /*i <= AUTO_PIN_FRONT_MIC*/) {
-			unsigned int pincap;
-			pincap = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
-			if ((pincap >> AC_PINCAP_VREF_SHIFT) &
-			    AC_PINCAP_VREF_80)
-				vref = PIN_VREF80;
-		}
-		snd_hda_codec_write(codec, nid, 0,
-				    AC_VERB_SET_PIN_WIDGET_CONTROL, vref);
+		alc_set_input_pin(codec, nid, AUTO_PIN_FRONT_MIC /*i*/);
 		if (get_wcaps(codec, nid) & AC_WCAP_OUT_AMP)
 			snd_hda_codec_write(codec, nid, 0,
 					    AC_VERB_SET_AMP_GAIN_MUTE,

[snip]

@@ -13831,12 +13831,8 @@ static void alc861_auto_init_analog_input(struct hda_codec *codec)
 
 	for (i = 0; i < AUTO_PIN_LAST; i++) {
 		hda_nid_t nid = spec->autocfg.input_pins[i];
-		if (nid >= 0x0c && nid <= 0x11) {
-			snd_hda_codec_write(codec, nid, 0,
-					    AC_VERB_SET_PIN_WIDGET_CONTROL,
-					    i <= AUTO_PIN_FRONT_MIC ?
-					    PIN_VREF80 : PIN_IN);
-		}
+		if (nid >= 0x0c && nid <= 0x11)
+			alc_set_input_pin(codec, nid, i);
 	}
 }
 
=== >8 ===

