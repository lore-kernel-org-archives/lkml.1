Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbYJGBEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbYJGBEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbYJGAqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:32 -0400
Received: from ns.suse.de ([195.135.220.2]:47288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757803AbYJGAqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:31 -0400
Date: Mon, 6 Oct 2008 17:40:19 -0700
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
Subject: [patch 66/71] ALSA: snd-powermac: mixers for PowerMac G4 AGP
Message-ID: <20081007004019.GO3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-snd-powermac-mixers-for-powermac-g4-agp.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Risto Suominen <Risto.Suominen@gmail.com>

commit 4dbf95ba6c344186ec6d38ff514dc675da464bec upstream

Add mixer controls for PowerMac G4 AGP (Screamer).

This patch fixes the regression in the recent snd-powermac which
doesn't support some G3/G4 PowerMacs:
    http://lkml.org/lkml/2008/10/1/220

Signed-off-by: Risto Suominen <Risto.Suominen@gmail.com>
Tested-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/ppc/awacs.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/sound/ppc/awacs.c
+++ b/sound/ppc/awacs.c
@@ -621,6 +621,13 @@ static struct snd_kcontrol_new snd_pmac_
 	AWACS_SWITCH("CD Capture Switch", 0, SHIFT_MUX_CD, 0),
 };
 
+static struct snd_kcontrol_new snd_pmac_screamer_mixers_g4agp[] __initdata = {
+	AWACS_VOLUME("Line out Playback Volume", 2, 6, 1),
+	AWACS_VOLUME("Master Playback Volume", 5, 6, 1),
+	AWACS_SWITCH("CD Capture Switch", 0, SHIFT_MUX_CD, 0),
+	AWACS_SWITCH("Line Capture Switch", 0, SHIFT_MUX_MIC, 0),
+};
+
 static struct snd_kcontrol_new snd_pmac_awacs_mixers_pmac7500[] __initdata = {
 	AWACS_VOLUME("Line out Playback Volume", 2, 6, 1),
 	AWACS_SWITCH("CD Capture Switch", 0, SHIFT_MUX_CD, 0),
@@ -768,6 +775,7 @@ static void snd_pmac_awacs_resume(struct
 #define IS_IMAC (machine_is_compatible("PowerMac2,1") \
 		|| machine_is_compatible("PowerMac2,2") \
 		|| machine_is_compatible("PowerMac4,1"))
+#define IS_G4AGP (machine_is_compatible("PowerMac3,1"))
 
 static int imac;
 
@@ -850,6 +858,7 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 {
 	int pm7500 = IS_PM7500;
 	int beige = IS_BEIGE;
+	int g4agp = IS_G4AGP;
 	int err, vol;
 
 	imac = IS_IMAC;
@@ -939,7 +948,7 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 				snd_pmac_awacs_mixers);
 	if (err < 0)
 		return err;
-	if (beige)
+	if (beige || g4agp)
 		;
 	else if (chip->model == PMAC_SCREAMER)
 		err = build_mixers(chip, ARRAY_SIZE(snd_pmac_screamer_mixers2),
@@ -961,13 +970,17 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 		err = build_mixers(chip,
 				   ARRAY_SIZE(snd_pmac_screamer_mixers_imac),
 				   snd_pmac_screamer_mixers_imac);
+	else if (g4agp)
+		err = build_mixers(chip,
+				   ARRAY_SIZE(snd_pmac_screamer_mixers_g4agp),
+				   snd_pmac_screamer_mixers_g4agp);
 	else
 		err = build_mixers(chip,
 				   ARRAY_SIZE(snd_pmac_awacs_mixers_pmac),
 				   snd_pmac_awacs_mixers_pmac);
 	if (err < 0)
 		return err;
-	chip->master_sw_ctl = snd_ctl_new1((pm7500 || imac)
+	chip->master_sw_ctl = snd_ctl_new1((pm7500 || imac || g4agp)
 			? &snd_pmac_awacs_master_sw_imac
 			: &snd_pmac_awacs_master_sw, chip);
 	err = snd_ctl_add(chip->card, chip->master_sw_ctl);
@@ -1012,7 +1025,7 @@ snd_pmac_awacs_init(struct snd_pmac *chi
 			return err;
 	}
 
-	if (beige)
+	if (beige || g4agp)
 		err = build_mixers(chip,
 				ARRAY_SIZE(snd_pmac_screamer_mic_boost_beige),
 				snd_pmac_screamer_mic_boost_beige);

-- 
