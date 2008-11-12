Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYKLAmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYKLAmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYKLA1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:01 -0500
Received: from kroah.org ([198.145.64.141]:42633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753899AbYKLA07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:59 -0500
Date: Tue, 11 Nov 2008 16:24:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
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
       alan@lxorguk.ukuu.org.uk,
       Matthew Ranostay <mranostay@embeddedalley.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 43/49] ALSA: hda: make a STAC_DELL_EQ option
Message-ID: <20081112002425.GR10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-make-a-stac_dell_eq-option.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Ranostay <mranostay@embeddedalley.com>

commit 6b3ab21ef1ac15db4b053ce0ba8eae0ef9361c8a upstream.

Add support for explicitly enabling the EQ distortion hack for
systems without software biquad support.

Signed-off-by: Matthew Ranostay <mranostay@embeddedalley.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -67,6 +67,7 @@ enum {
 enum {
 	STAC_92HD73XX_REF,
 	STAC_DELL_M6,
+	STAC_DELL_EQ,
 	STAC_92HD73XX_MODELS
 };
 
@@ -560,9 +561,7 @@ static struct hda_verb dell_eq_core_init
 };
 
 static struct hda_verb dell_m6_core_init[] = {
-	/* set master volume to max value without distortion
-	 * and direct control */
-	{ 0x1f, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xec},
+	{ 0x1f, AC_VERB_SET_VOLUME_KNOB_CONTROL, 0xff},
 	/* setup audio connections */
 	{ 0x0d, AC_VERB_SET_CONNECT_SEL, 0x00},
 	{ 0x0a, AC_VERB_SET_CONNECT_SEL, 0x01},
@@ -1297,11 +1296,13 @@ static unsigned int dell_m6_pin_configs[
 static unsigned int *stac92hd73xx_brd_tbl[STAC_92HD73XX_MODELS] = {
 	[STAC_92HD73XX_REF]	= ref92hd73xx_pin_configs,
 	[STAC_DELL_M6]	= dell_m6_pin_configs,
+	[STAC_DELL_EQ]	= dell_m6_pin_configs,
 };
 
 static const char *stac92hd73xx_models[STAC_92HD73XX_MODELS] = {
 	[STAC_92HD73XX_REF] = "ref",
 	[STAC_DELL_M6] = "dell-m6",
+	[STAC_DELL_EQ] = "dell-eq",
 };
 
 static struct snd_pci_quirk stac92hd73xx_cfg_tbl[] = {
@@ -3560,8 +3561,12 @@ again:
 	spec->gpio_data = 0x01;
 
 	switch (spec->board_config) {
-	case STAC_DELL_M6:
+	case STAC_DELL_EQ:
 		spec->init = dell_eq_core_init;
+		/* fallthru */
+	case STAC_DELL_M6:
+		if (!spec->init)
+			spec->init = dell_m6_core_init;
 		switch (codec->subsystem_id) {
 		case 0x1028025e: /* Analog Mics */
 		case 0x1028025f:
@@ -3570,8 +3575,6 @@ again:
 			break;
 		case 0x10280271: /* Digital Mics */
 		case 0x10280272:
-			spec->init = dell_m6_core_init;
-			/* fall-through */
 		case 0x10280254:
 		case 0x10280255:
 			stac92xx_set_config_reg(codec, 0x13, 0x90A60160);

-- 
