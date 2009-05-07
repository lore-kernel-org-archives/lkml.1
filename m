Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbZEGHYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbZEGHYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:24:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZEGHXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:23:54 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44470 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZEGHXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:23:54 -0400
Date: Thu, 7 May 2009 09:23:53 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090507072352.GA6513@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de> <20090424142113.GA18668@dose.home.local> <s5hskjy5d2t.wl%tiwai@suse.de> <20090428002309.GA29572@x61> <20090506222753.GA6728@mac.home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20090506222753.GA6728@mac.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 07, 2009 at 00:27:53 +0200, Tino Keitel wrote:
> On Tue, Apr 28, 2009 at 02:23:09 +0200, Tino Keitel wrote:
> 
> [...]
> 
> > I just saw another, major problem: line in doesn't work anymore with
> > 2.6.29 and also 2.6.30-rc3 (no usable input level). It works with
> > 2.6.27.20.
> 
> FYI: I just tried 2.6.28 and line-in was still broken. So the last
> working kernel is 2.6.27.

I tried this:

git bisect start v2.6.28 v2.6.27 sound/pci/hda/patch_sigmatel.c

The result is commit 4f1e6bc3646ab50b8181555ab7e6eeab68b8632a.

I can't use git revert because of conflicts, so I crafted the attached
patch against 2.6.30-rc4-00288-g413f81e, and now line-in works.

Regards,
Tino

--VS++wcV0S1rZb1Fb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="fix-mac-mini-line-in.patch"

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 917bc5d..8846a3b 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4070,21 +4070,19 @@ static int stac92xx_init(struct hda_codec *codec)
 		hda_nid_t nid = cfg->input_pins[i];
 		if (nid) {
 			unsigned int pinctl, conf;
-			if (i == AUTO_PIN_MIC || i == AUTO_PIN_FRONT_MIC) {
-				/* for mic pins, force to initialize */
-				pinctl = stac92xx_get_vref(codec, nid);
-				pinctl |= AC_PINCTL_IN_EN;
-				stac92xx_auto_set_pinctl(codec, nid, pinctl);
-			} else {
-				pinctl = snd_hda_codec_read(codec, nid, 0,
-					AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
-				/* if PINCTL already set then skip */
-				if (!(pinctl & AC_PINCTL_IN_EN)) {
-					pinctl |= AC_PINCTL_IN_EN;
-					stac92xx_auto_set_pinctl(codec, nid,
-								 pinctl);
-				}
-			}
+			pinctl = snd_hda_codec_read(codec, nid,
+						    0, AC_VERB_GET_PIN_WIDGET_CONTROL, 0);
+			/* if PINCTL already set then skip */
+			if (pinctl & AC_PINCAP_IN)
+				continue;
+			pinctl = AC_PINCTL_IN_EN;
+			if (i == AUTO_PIN_MIC || i == AUTO_PIN_FRONT_MIC)
+				pinctl |= stac92xx_get_vref(codec, nid);
+			stac92xx_auto_set_pinctl(codec, nid, pinctl);
+
+
+
+
 			conf = snd_hda_codec_get_pincfg(codec, nid);
 			if (get_defcfg_connect(conf) != AC_JACK_PORT_FIXED) {
 				enable_pin_detect(codec, nid,

--VS++wcV0S1rZb1Fb--
