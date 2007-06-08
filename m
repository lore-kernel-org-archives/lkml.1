Return-Path: <linux-kernel-owner+w=401wt.eu-S938764AbXFHHiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938764AbXFHHiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965255AbXFHHXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58423 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967721AbXFHHXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:45 -0400
Message-Id: <20070608072154.738002000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/54] ALSA: hda-intel - Probe additional slots only if necessary
Content-Disposition: inline; filename=alsa-hda-intel-probe-additional-slots-only-if-necessary.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Takashi Iwai <tiwai@suse.de>

Probing the codec slots on ATI controller causes problems on some
devices like Acer laptops.  On these devices, reading from codec
slot 3 results in the communication failure with the codec chip.
Meanwhile, some laptops (e.g. Gateway) have the codec connection
only on slot 3, and probing this slot is mandatory for them.
The patch improves the probing robustness.  The additional slots
are now checked only when no codecs are found in the primary three
slots.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/hda_intel.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/sound/pci/hda/hda_intel.c
+++ linux-2.6.21.4/sound/pci/hda/hda_intel.c
@@ -198,6 +198,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 #define RIRB_INT_MASK		0x05
 
 /* STATESTS int mask: SD2,SD1,SD0 */
+#define AZX_MAX_CODECS		3
 #define STATESTS_INT_MASK	0x07
 
 /* SD_CTL bits */
@@ -991,7 +992,7 @@ static int __devinit azx_codec_create(st
 		return err;
 
 	codecs = 0;
-	for (c = 0; c < azx_max_codecs[chip->driver_type]; c++) {
+	for (c = 0; c < AZX_MAX_CODECS; c++) {
 		if ((chip->codec_mask & (1 << c)) & probe_mask) {
 			err = snd_hda_codec_new(chip->bus, c, NULL);
 			if (err < 0)
@@ -999,7 +1000,18 @@ static int __devinit azx_codec_create(st
 			codecs++;
 		}
 	}
-	if (! codecs) {
+	if (!codecs) {
+		/* probe additional slots if no codec is found */
+		for (; c < azx_max_codecs[chip->driver_type]; c++) {
+			if ((chip->codec_mask & (1 << c)) & probe_mask) {
+				err = snd_hda_codec_new(chip->bus, c, NULL);
+				if (err < 0)
+					continue;
+				codecs++;
+			}
+		}
+	}
+	if (!codecs) {
 		snd_printk(KERN_ERR SFX "no codecs initialized\n");
 		return -ENXIO;
 	}

-- 
