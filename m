Return-Path: <linux-kernel-owner+w=401wt.eu-S1030667AbXCSVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030667AbXCSVnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030632AbXCSVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:43:15 -0400
Received: from ns1.suse.de ([195.135.220.2]:55998 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965059AbXCSVmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:35 -0400
Date: Mon, 19 Mar 2007 14:40:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [patch 26/31] hda-intel - Fix codec probe with ATI controllers
Message-ID: <20070319214047.GB9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hda-intel-fix-codec-probe-with-ati-controllers.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ALSA] hda-intel - Fix codec probe with ATI contorllers

ATI controllers may have up to 4 codecs while ICH up to 3.
Thus the earlier fix to change AZX_MAX_CODECS to 3 cause a regression
on some devices that have the audio codec at bit#3.
Now max codecs is defined according to the driver type, either 3 or 4.
Currently 4 is set only to ATI chips.  Other might need the same
change, too.

Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>

---
 sound/pci/hda/hda_intel.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -199,7 +199,6 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 
 /* STATESTS int mask: SD2,SD1,SD0 */
 #define STATESTS_INT_MASK	0x07
-#define AZX_MAX_CODECS		3
 
 /* SD_CTL bits */
 #define SD_CTL_STREAM_RESET	0x01	/* stream reset bit */
@@ -966,6 +965,16 @@ static int azx_setup_controller(struct a
  * Codec initialization
  */
 
+static unsigned int azx_max_codecs[] __devinitdata = {
+	[AZX_DRIVER_ICH] = 3,
+	[AZX_DRIVER_ATI] = 4,
+	[AZX_DRIVER_ATIHDMI] = 4,
+	[AZX_DRIVER_VIA] = 3,		/* FIXME: correct? */
+	[AZX_DRIVER_SIS] = 3,		/* FIXME: correct? */
+	[AZX_DRIVER_ULI] = 3,		/* FIXME: correct? */
+	[AZX_DRIVER_NVIDIA] = 3,	/* FIXME: correct? */
+};
+
 static int __devinit azx_codec_create(struct azx *chip, const char *model)
 {
 	struct hda_bus_template bus_temp;
@@ -982,7 +991,7 @@ static int __devinit azx_codec_create(st
 		return err;
 
 	codecs = 0;
-	for (c = 0; c < AZX_MAX_CODECS; c++) {
+	for (c = 0; c < azx_max_codecs[chip->driver_type]; c++) {
 		if ((chip->codec_mask & (1 << c)) & probe_mask) {
 			err = snd_hda_codec_new(chip->bus, c, NULL);
 			if (err < 0)

-- 
