Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYCQNAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYCQNAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 09:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYCQM74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:59:56 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:61357 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbYCQM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:59:55 -0400
Date: Mon, 17 Mar 2008 22:00:27 +0900 (JST)
Message-Id: <20080317.220027.01917573.anemo@mba.ocn.ne.jp>
To: tiwai@suse.de
Cc: haavard.skinnemoen@atmel.com, linux-kernel@vger.kernel.org,
       hcegtvedt@atmel.com, avictor.za@gmail.com
Subject: Re: [PATCH] at73c213: Fix DMA size at the end of DMA buffer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <s5hzlt1s9up.wl%tiwai@suse.de>
References: <20080314104445.32f4da40@hskinnemo-gx620.norway.atmel.com>
	<20080314.222932.74752532.anemo@mba.ocn.ne.jp>
	<s5hzlt1s9up.wl%tiwai@suse.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 14:39:42 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> Add the following constraint in the open callback:
> 
> 	err = snd_pcm_hw_constraint_integer(runtime,
> 					SNDRV_PCM_HW_PARAM_PERIODS);
> 	if (err < 0)
> 		return err;
> 
> This will guarantee that the period size fits with the buffer size.

Thank you!  It works fine.  Here is a new patch.


------------------------------------------------------
Subject: [PATCH] at73c213: Add constraints for periods value
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The interrupt handler always provide runtime->period_size data, so it
works correctly only if buffer_size was a multiple of period_size.

This patch fixes periodic click noise.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
This patch obsoletes a patch titled "at73c213: fix DMA size at the end
of DMA buffer" in git-alsa-tiwai.patch in mm tree.

diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 7c077c6..9a5c118 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -210,7 +210,13 @@ static int snd_at73c213_pcm_open(struct snd_pcm_substream *substream)
 {
 	struct snd_at73c213 *chip = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	int err;
 
+	/* ensure buffer_size is a multiple of period_size */
+	err = snd_pcm_hw_constraint_integer(runtime,
+					SNDRV_PCM_HW_PARAM_PERIODS);
+	if (err < 0)
+		return err;
 	snd_at73c213_playback_hw.rate_min = chip->bitrate;
 	snd_at73c213_playback_hw.rate_max = chip->bitrate;
 	runtime->hw = snd_at73c213_playback_hw;
