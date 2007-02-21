Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbXBUBkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbXBUBkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXBUBkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:40:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:34647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXBUBjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:39:36 -0500
Date: Tue, 20 Feb 2007 17:38:11 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 14/21] usb-audio: work around wrong frequency in CM6501 descriptors
Message-ID: <20070221013811.GO30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-audio-work-around-wrong-frequency-in-cm6501-descriptors.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

[PATCH] usb-audio: work around wrong frequency in CM6501 descriptors

The C-Media CM6501 chip's descriptors say that altsetting 5 supports
48 kHz, but it actually plays at 96 kHz.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6.19.4.orig/sound/usb/usbaudio.c
+++ linux-2.6.19.4/sound/usb/usbaudio.c
@@ -2471,7 +2471,13 @@ static int parse_audio_format_rates(stru
 		fp->nr_rates = nr_rates;
 		fp->rate_min = fp->rate_max = combine_triple(&fmt[8]);
 		for (r = 0, idx = offset + 1; r < nr_rates; r++, idx += 3) {
-			unsigned int rate = fp->rate_table[r] = combine_triple(&fmt[idx]);
+			unsigned int rate = combine_triple(&fmt[idx]);
+			/* C-Media CM6501 mislabels its 96 kHz altsetting */
+			if (rate == 48000 && nr_rates == 1 &&
+			    chip->usb_id == USB_ID(0x0d8c, 0x0201) &&
+			    fp->altsetting == 5 && fp->maxpacksize == 392)
+				rate = 96000;
+			fp->rate_table[r] = rate;
 			if (rate < fp->rate_min)
 				fp->rate_min = rate;
 			else if (rate > fp->rate_max)

--
