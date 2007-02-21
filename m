Return-Path: <linux-kernel-owner+w=401wt.eu-S1751031AbXBUBkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031AbXBUBkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXBUBkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:40:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:34667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXBUBjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:40 -0500
Date: Tue, 20 Feb 2007 17:38:18 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gregor Jasny <gjasny@web.de>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [patch 15/21] usbaudio - Fix Oops with broken usb descriptors
Message-ID: <20070221013818.GP30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usbaudio-fix-oops-with-broken-usb-descriptors.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
[PATCH] usbaudio - Fix Oops with broken usb descriptors

This is a patch for ALSA Bug #2724. Some webcams provide bogus
settings with no valid rates. With this patch those are skipped.

Signed-off-by: Gregor Jasny <gjasny@web.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.19.4.orig/sound/usb/usbaudio.c
+++ linux-2.6.19.4/sound/usb/usbaudio.c
@@ -2456,6 +2456,7 @@ static int parse_audio_format_rates(stru
 		 * build the rate table and bitmap flags
 		 */
 		int r, idx, c;
+		unsigned int nonzero_rates = 0;
 		/* this table corresponds to the SNDRV_PCM_RATE_XXX bit */
 		static unsigned int conv_rates[] = {
 			5512, 8000, 11025, 16000, 22050, 32000, 44100, 48000,
@@ -2478,6 +2479,7 @@ static int parse_audio_format_rates(stru
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;
 			fp->rate_table[r] = rate;
+			nonzero_rates |= rate;
 			if (rate < fp->rate_min)
 				fp->rate_min = rate;
 			else if (rate > fp->rate_max)
@@ -2493,6 +2495,10 @@ static int parse_audio_format_rates(stru
 			if (!found)
 				fp->needs_knot = 1;
 		}
+		if (!nonzero_rates) {
+			hwc_debug("All rates were zero. Skipping format!\n");
+			return -1;
+		}
 		if (fp->needs_knot)
 			fp->rates |= SNDRV_PCM_RATE_KNOT;
 	} else {

--
