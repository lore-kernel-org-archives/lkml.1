Return-Path: <linux-kernel-owner+w=401wt.eu-S1422782AbXCGROH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbXCGROH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422780AbXCGROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:05 -0500
Received: from ns1.suse.de ([195.135.220.2]:43487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743AbXCGRNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:48 -0500
Message-Id: <20070307171205.495245606@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 015/101] USB audio fixes 2
Content-Disposition: inline; filename=usb-audio-fixes-2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[PATCH] usbaudio - Fix Oops with unconventional sample rates

The patch fixes the memory corruption by the support of unconventional
sample rates.  Also, it avoids the too restrictive constraints if
any of usb descriptions contain continuous rates.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbaudio.c |   43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

--- linux-2.6.20.1.orig/sound/usb/usbaudio.c
+++ linux-2.6.20.1/sound/usb/usbaudio.c
@@ -186,6 +186,7 @@ struct snd_usb_substream {
 	u64 formats;			/* format bitmasks (all or'ed) */
 	unsigned int num_formats;		/* number of supported audio formats (list) */
 	struct list_head fmt_list;	/* format list */
+	struct snd_pcm_hw_constraint_list rate_list;	/* limited rates */
 	spinlock_t lock;
 
 	struct snd_urb_ops ops;		/* callbacks (must be filled at init) */
@@ -1810,28 +1811,33 @@ static int check_hw_params_convention(st
 static int snd_usb_pcm_check_knot(struct snd_pcm_runtime *runtime,
 				  struct snd_usb_substream *subs)
 {
-	struct list_head *p;
-	struct snd_pcm_hw_constraint_list constraints_rates;
+	struct audioformat *fp;
+	int count = 0, needs_knot = 0;
 	int err;
 
-	list_for_each(p, &subs->fmt_list) {
-		struct audioformat *fp;
-		fp = list_entry(p, struct audioformat, list);
-
-		if (!fp->needs_knot)
-			continue;
-
-		constraints_rates.count = fp->nr_rates;
-		constraints_rates.list = fp->rate_table;
-		constraints_rates.mask = 0;
-
-		err = snd_pcm_hw_constraint_list(runtime, 0,
-			SNDRV_PCM_HW_PARAM_RATE,
-			&constraints_rates);
+	list_for_each_entry(fp, &subs->fmt_list, list) {
+		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
+			return 0;
+		count += fp->nr_rates;
+		if (fp->needs_knot)
+			needs_knot = 1;
+	}
+	if (!needs_knot)
+		return 0;
 
-		if (err < 0)
-			return err;
+	subs->rate_list.count = count;
+	subs->rate_list.list = kmalloc(sizeof(int) * count, GFP_KERNEL);
+	subs->rate_list.mask = 0;
+	count = 0;
+	list_for_each_entry(fp, &subs->fmt_list, list) {
+		int i;
+		for (i = 0; i < fp->nr_rates; i++)
+			subs->rate_list.list[count++] = fp->rate_table[i];
 	}
+	err = snd_pcm_hw_constraint_list(runtime, 0, SNDRV_PCM_HW_PARAM_RATE,
+					 &subs->rate_list);
+	if (err < 0)
+		return err;
 
 	return 0;
 }
@@ -2231,6 +2237,7 @@ static void free_substream(struct snd_us
 		kfree(fp->rate_table);
 		kfree(fp);
 	}
+	kfree(subs->rate_list.list);
 }
 
 

--
