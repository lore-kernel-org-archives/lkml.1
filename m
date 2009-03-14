Return-Path: <linux-kernel-owner+w=401wt.eu-S1763095AbZCNBcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763095AbZCNBcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbZCNBUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:30 -0400
Received: from kroah.org ([198.145.64.141]:35052 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753317AbZCNBUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:15 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:36 2009
Message-Id: <20090314011036.269661844@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:10 -0700
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
Subject: [patch 033/114] ALSA: usb-audio - Fix non-continuous rate detection
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=alsa-usb-audio-fix-non-continuous-rate-detection.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0412558c873f716efe902b397af0653a550f7341 upstream.

The detection of non-continuous rates (given via rate tables) isn't
processed properly (e.g. for type II).

This patch fixes and simplifies the detection code.

Tested-by: Joris van Rantwijk <jorispubl@xs4all.nl>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -2524,7 +2524,6 @@ static int parse_audio_format_rates(stru
 		 * build the rate table and bitmap flags
 		 */
 		int r, idx;
-		unsigned int nonzero_rates = 0;
 
 		fp->rate_table = kmalloc(sizeof(int) * nr_rates, GFP_KERNEL);
 		if (fp->rate_table == NULL) {
@@ -2532,24 +2531,26 @@ static int parse_audio_format_rates(stru
 			return -1;
 		}
 
-		fp->nr_rates = nr_rates;
-		fp->rate_min = fp->rate_max = combine_triple(&fmt[8]);
+		fp->nr_rates = 0;
+		fp->rate_min = fp->rate_max = 0;
 		for (r = 0, idx = offset + 1; r < nr_rates; r++, idx += 3) {
 			unsigned int rate = combine_triple(&fmt[idx]);
+			if (!rate)
+				continue;
 			/* C-Media CM6501 mislabels its 96 kHz altsetting */
 			if (rate == 48000 && nr_rates == 1 &&
 			    chip->usb_id == USB_ID(0x0d8c, 0x0201) &&
 			    fp->altsetting == 5 && fp->maxpacksize == 392)
 				rate = 96000;
-			fp->rate_table[r] = rate;
-			nonzero_rates |= rate;
-			if (rate < fp->rate_min)
+			fp->rate_table[fp->nr_rates] = rate;
+			if (!fp->rate_min || rate < fp->rate_min)
 				fp->rate_min = rate;
-			else if (rate > fp->rate_max)
+			if (!fp->rate_max || rate > fp->rate_max)
 				fp->rate_max = rate;
 			fp->rates |= snd_pcm_rate_to_rate_bit(rate);
+			fp->nr_rates++;
 		}
-		if (!nonzero_rates) {
+		if (!fp->nr_rates) {
 			hwc_debug("All rates were zero. Skipping format!\n");
 			return -1;
 		}


