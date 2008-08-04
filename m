Return-Path: <linux-kernel-owner+w=401wt.eu-S1770637AbYHDVlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1770637AbYHDVlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1769951AbYHDVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:40:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422644AbYHDVko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:40:44 -0400
Date: Mon, 4 Aug 2008 14:30:38 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [patch 19/25] ALSA: hda - Fix wrong volumes in AD1988 auto-probe
	mode
Message-ID: <20080804213038.GS8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-wrong-volumes-in-ad1988-auto-probe-mode.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 43785eaeb1cfb8aed3cf8027f298b242f88fdc45 upstream

Don't create mixer volume elements for Headphone and Speaker if they
use the same DAC as normal line-outs on AD1988.  Otherwise the amp
value gets screwed up, e.g.
	https://bugzilla.novell.com/show_bug.cgi?id=398255

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_analog.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -2623,7 +2623,7 @@ static int ad1988_auto_create_extra_out(
 {
 	struct ad198x_spec *spec = codec->spec;
 	hda_nid_t nid;
-	int idx, err;
+	int i, idx, err;
 	char name[32];
 
 	if (! pin)
@@ -2631,16 +2631,26 @@ static int ad1988_auto_create_extra_out(
 
 	idx = ad1988_pin_idx(pin);
 	nid = ad1988_idx_to_dac(codec, idx);
-	/* specify the DAC as the extra output */
-	if (! spec->multiout.hp_nid)
-		spec->multiout.hp_nid = nid;
-	else
-		spec->multiout.extra_out_nid[0] = nid;
-	/* control HP volume/switch on the output mixer amp */
-	sprintf(name, "%s Playback Volume", pfx);
-	if ((err = add_control(spec, AD_CTL_WIDGET_VOL, name,
-			       HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_OUTPUT))) < 0)
-		return err;
+	/* check whether the corresponding DAC was already taken */
+	for (i = 0; i < spec->autocfg.line_outs; i++) {
+		hda_nid_t pin = spec->autocfg.line_out_pins[i];
+		hda_nid_t dac = ad1988_idx_to_dac(codec, ad1988_pin_idx(pin));
+		if (dac == nid)
+			break;
+	}
+	if (i >= spec->autocfg.line_outs) {
+		/* specify the DAC as the extra output */
+		if (!spec->multiout.hp_nid)
+			spec->multiout.hp_nid = nid;
+		else
+			spec->multiout.extra_out_nid[0] = nid;
+		/* control HP volume/switch on the output mixer amp */
+		sprintf(name, "%s Playback Volume", pfx);
+		err = add_control(spec, AD_CTL_WIDGET_VOL, name,
+				  HDA_COMPOSE_AMP_VAL(nid, 3, 0, HDA_OUTPUT));
+		if (err < 0)
+			return err;
+	}
 	nid = ad1988_mixer_nids[idx];
 	sprintf(name, "%s Playback Switch", pfx);
 	if ((err = add_control(spec, AD_CTL_BIND_MUTE, name,

-- 
