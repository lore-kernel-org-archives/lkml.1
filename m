Return-Path: <linux-kernel-owner+w=401wt.eu-S1762965AbYHDUbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762965AbYHDUbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763793AbYHDUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:30:36 -0400
Received: from mx1.suse.de ([195.135.220.2]:49425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763471AbYHDUad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:30:33 -0400
Date: Mon, 4 Aug 2008 13:16:16 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 27/33] ALSA: ac97 - Fix ASUS A9T laptop output
Message-ID: <20080804201616.GB1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-ac97-fix-asus-a9t-laptop-output.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e48d6d97bb6bd8c008045ea0522ea8278fdccc55 upstream

ASUS A9T laptop uses line-out pin as the real front-output while
other devices use it as the surround.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/sound/ac97_codec.h  |    1 
 sound/pci/ac97/ac97_patch.c |   48 +++++++++++++++++++++++++++++++-------------
 2 files changed, 35 insertions(+), 14 deletions(-)

--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -504,6 +504,7 @@ struct snd_ac97 {
 			unsigned short pcmreg[3];	// PCM registers
 			unsigned short codec_cfg[3];	// CODEC_CFG bits
 			unsigned char swap_mic_linein;	// AD1986/AD1986A only
+			unsigned char lo_as_master;	/* LO as master */
 		} ad18xx;
 		unsigned int dev_flags;		/* device specific */
 	} spec;
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -1960,6 +1960,9 @@ static int snd_ac97_ad1888_lohpsel_get(s
 
 	val = ac97->regs[AC97_AD_MISC];
 	ucontrol->value.integer.value[0] = !(val & AC97_AD198X_LOSEL);
+	if (ac97->spec.ad18xx.lo_as_master)
+		ucontrol->value.integer.value[0] =
+			!ucontrol->value.integer.value[0];
 	return 0;
 }
 
@@ -1968,8 +1971,10 @@ static int snd_ac97_ad1888_lohpsel_put(s
 	struct snd_ac97 *ac97 = snd_kcontrol_chip(kcontrol);
 	unsigned short val;
 
-	val = !ucontrol->value.integer.value[0]
-		? (AC97_AD198X_LOSEL | AC97_AD198X_HPSEL) : 0;
+	val = !ucontrol->value.integer.value[0];
+	if (ac97->spec.ad18xx.lo_as_master)
+		val = !val;
+	val = val ? (AC97_AD198X_LOSEL | AC97_AD198X_HPSEL) : 0;
 	return snd_ac97_update_bits(ac97, AC97_AD_MISC,
 				    AC97_AD198X_LOSEL | AC97_AD198X_HPSEL, val);
 }
@@ -2020,7 +2025,7 @@ static void ad1888_update_jacks(struct s
 {
 	unsigned short val = 0;
 	/* clear LODIS if shared jack is to be used for Surround out */
-	if (is_shared_linein(ac97))
+	if (!ac97->spec.ad18xx.lo_as_master && is_shared_linein(ac97))
 		val |= (1 << 12);
 	/* clear CLDIS if shared jack is to be used for C/LFE out */
 	if (is_shared_micin(ac97))
@@ -2056,9 +2061,13 @@ static const struct snd_kcontrol_new snd
 
 static int patch_ad1888_specific(struct snd_ac97 *ac97)
 {
-	/* rename 0x04 as "Master" and 0x02 as "Master Surround" */
-	snd_ac97_rename_vol_ctl(ac97, "Master Playback", "Master Surround Playback");
-	snd_ac97_rename_vol_ctl(ac97, "Headphone Playback", "Master Playback");
+	if (!ac97->spec.ad18xx.lo_as_master) {
+		/* rename 0x04 as "Master" and 0x02 as "Master Surround" */
+		snd_ac97_rename_vol_ctl(ac97, "Master Playback",
+					"Master Surround Playback");
+		snd_ac97_rename_vol_ctl(ac97, "Headphone Playback",
+					"Master Playback");
+	}
 	return patch_build_controls(ac97, snd_ac97_ad1888_controls, ARRAY_SIZE(snd_ac97_ad1888_controls));
 }
 
@@ -2077,16 +2086,27 @@ static int patch_ad1888(struct snd_ac97 
 	
 	patch_ad1881(ac97);
 	ac97->build_ops = &patch_ad1888_build_ops;
-	/* Switch FRONT/SURROUND LINE-OUT/HP-OUT default connection */
-	/* it seems that most vendors connect line-out connector to headphone out of AC'97 */
+
+	/*
+	 * LO can be used as a real line-out on some devices,
+	 * and we need to revert the front/surround mixer switches
+	 */
+	if (ac97->subsystem_vendor == 0x1043 &&
+	    ac97->subsystem_device == 0x1193) /* ASUS A9T laptop */
+		ac97->spec.ad18xx.lo_as_master = 1;
+
+	misc = snd_ac97_read(ac97, AC97_AD_MISC);
 	/* AD-compatible mode */
 	/* Stereo mutes enabled */
-	misc = snd_ac97_read(ac97, AC97_AD_MISC);
-	snd_ac97_write_cache(ac97, AC97_AD_MISC, misc |
-			     AC97_AD198X_LOSEL |
-			     AC97_AD198X_HPSEL |
-			     AC97_AD198X_MSPLT |
-			     AC97_AD198X_AC97NC);
+	misc |= AC97_AD198X_MSPLT | AC97_AD198X_AC97NC;
+	if (!ac97->spec.ad18xx.lo_as_master)
+		/* Switch FRONT/SURROUND LINE-OUT/HP-OUT default connection */
+		/* it seems that most vendors connect line-out connector to
+		 * headphone out of AC'97
+		 */
+		misc |= AC97_AD198X_LOSEL | AC97_AD198X_HPSEL;
+
+	snd_ac97_write_cache(ac97, AC97_AD_MISC, misc);
 	ac97->flags |= AC97_STEREO_MUTES;
 	return 0;
 }

-- 
