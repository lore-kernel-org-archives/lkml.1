Return-Path: <linux-kernel-owner+w=401wt.eu-S1760996AbYJGBEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760996AbYJGBEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbYJGAqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044AbYJGAqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:35 -0400
Date: Mon, 6 Oct 2008 17:40:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Risto Suominen <Risto.Suominen@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 67/71] ALSA: snd-powermac: HP detection for 1st iMac G3 SL
Message-ID: <20081007004022.GP3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-snd-powermac-hp-detection-for-1st-imac-g3-sl.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Risto Suominen <Risto.Suominen@gmail.com>

commit 030b655b062fe5190fc490e0091ea50307d7a86f upstream

Correct headphone detection for 1st generation iMac G3 Slot-loading (Screamer).

This patch fixes the regression in the recent snd-powermac which
doesn't support some G3/G4 PowerMacs:
    http://lkml.org/lkml/2008/10/1/220

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Tested-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/ppc/awacs.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/sound/ppc/awacs.c
+++ b/sound/ppc/awacs.c
@@ -695,7 +695,10 @@ static struct snd_kcontrol_new snd_pmac_
 static struct snd_kcontrol_new snd_pmac_awacs_speaker_sw __initdata =
 AWACS_SWITCH("PC Speaker Playback Switch", 1, SHIFT_SPKMUTE, 1);
 
-static struct snd_kcontrol_new snd_pmac_awacs_speaker_sw_imac __initdata =
+static struct snd_kcontrol_new snd_pmac_awacs_speaker_sw_imac1 __initdata =
+AWACS_SWITCH("PC Speaker Playback Switch", 1, SHIFT_PAROUT1, 1);
+
+static struct snd_kcontrol_new snd_pmac_awacs_speaker_sw_imac2 __initdata =
 AWACS_SWITCH("PC Speaker Playback Switch", 1, SHIFT_PAROUT1, 0);
 
 
@@ -772,12 +775,12 @@ static void snd_pmac_awacs_resume(struct
 
 #define IS_PM7500 (machine_is_compatible("AAPL,7500"))
 #define IS_BEIGE (machine_is_compatible("AAPL,Gossamer"))
-#define IS_IMAC (machine_is_compatible("PowerMac2,1") \
-		|| machine_is_compatible("PowerMac2,2") \
+#define IS_IMAC1 (machine_is_compatible("PowerMac2,1"))
+#define IS_IMAC2 (machine_is_compatible("PowerMac2,2") \
 		|| machine_is_compatible("PowerMac4,1"))
 #define IS_G4AGP (machine_is_compatible("PowerMac3,1"))
 
-static int imac;
+static int imac1, imac2;
 
 #ifdef PMAC_SUPPORT_AUTOMUTE
 /*
@@ -823,13 +826,18 @@ static void snd_pmac_awacs_update_automu
 		{
 			int reg = chip->awacs_reg[1]
 				| (MASK_HDMUTE | MASK_SPKMUTE);
-			if (imac) {
+			if (imac1) {
+				reg &= ~MASK_SPKMUTE;
+				reg |= MASK_PAROUT1;
+			} else if (imac2) {
 				reg &= ~MASK_SPKMUTE;
 				reg &= ~MASK_PAROUT1;
 			}
 			if (snd_pmac_awacs_detect_headphone(chip))
 				reg &= ~MASK_HDMUTE;
-			else if (imac)
+			else if (imac1)
+				reg &= ~MASK_PAROUT1;
+			else if (imac2)
 				reg |= MASK_PAROUT1;
 			else
 				reg &= ~MASK_SPKMUTE;
@@ -859,9 +867,12 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 	int pm7500 = IS_PM7500;
 	int beige = IS_BEIGE;
 	int g4agp = IS_G4AGP;
+	int imac;
 	int err, vol;
 
-	imac = IS_IMAC;
+	imac1 = IS_IMAC1;
+	imac2 = IS_IMAC2;
+	imac = imac1 || imac2;
 	/* looks like MASK_GAINLINE triggers something, so we set here
 	 * as start-up
 	 */
@@ -1017,8 +1028,10 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 					snd_pmac_awacs_speaker_vol);
 		if (err < 0)
 			return err;
-		chip->speaker_sw_ctl = snd_ctl_new1(imac
-				? &snd_pmac_awacs_speaker_sw_imac
+		chip->speaker_sw_ctl = snd_ctl_new1(imac1
+				? &snd_pmac_awacs_speaker_sw_imac1
+				: imac2
+				? &snd_pmac_awacs_speaker_sw_imac2
 				: &snd_pmac_awacs_speaker_sw, chip);
 		err = snd_ctl_add(chip->card, chip->speaker_sw_ctl);
 		if (err < 0)

-- 
