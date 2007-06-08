Return-Path: <linux-kernel-owner+w=401wt.eu-S938316AbXFHHei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938316AbXFHHei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938364AbXFHHX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:28 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58326 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938357AbXFHHX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:27 -0400
Message-Id: <20070608072155.283117000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Dave Jones <davej@redhat.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 11/54] ALSA: hda-intel - Fix detection of audio codec on Toshiba A100
Content-Disposition: inline; filename=alsa-hda-intel-fix-detection-of-audio-codec-on-toshiba-a100.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Takashi Iwai <tiwai@suse.de>

Some boards have the audio codec on slot #3 while the modem codec
on slot #0.  The driver should continue to probe the slots when
no audio codec is found.
This fixes the problem of no device on Toshiba A100 (and some other
ATI SB450 devices).

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/hda_intel.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.21.4.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6.21.4/sound/pci/hda/hda_intel.c
@@ -979,7 +979,7 @@ static unsigned int azx_max_codecs[] __d
 static int __devinit azx_codec_create(struct azx *chip, const char *model)
 {
 	struct hda_bus_template bus_temp;
-	int c, codecs, err;
+	int c, codecs, audio_codecs, err;
 
 	memset(&bus_temp, 0, sizeof(bus_temp));
 	bus_temp.private_data = chip;
@@ -991,16 +991,19 @@ static int __devinit azx_codec_create(st
 	if ((err = snd_hda_bus_new(chip->card, &bus_temp, &chip->bus)) < 0)
 		return err;
 
-	codecs = 0;
+	codecs = audio_codecs = 0;
 	for (c = 0; c < AZX_MAX_CODECS; c++) {
 		if ((chip->codec_mask & (1 << c)) & probe_mask) {
-			err = snd_hda_codec_new(chip->bus, c, NULL);
+			struct hda_codec *codec;
+			err = snd_hda_codec_new(chip->bus, c, &codec);
 			if (err < 0)
 				continue;
 			codecs++;
+			if (codec->afg)
+				audio_codecs++;
 		}
 	}
-	if (!codecs) {
+	if (!audio_codecs) {
 		/* probe additional slots if no codec is found */
 		for (; c < azx_max_codecs[chip->driver_type]; c++) {
 			if ((chip->codec_mask & (1 << c)) & probe_mask) {

-- 
