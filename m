Return-Path: <linux-kernel-owner+w=401wt.eu-S1761479AbYCGKCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761479AbYCGKCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYCGKCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:02:37 -0500
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:26818 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbYCGKCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:02:36 -0500
Date: Fri, 07 Mar 2008 19:02:34 +0900 (JST)
Message-Id: <20080307.190234.55730878.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [PATCH] at73c213: Monaural support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for monaural playback to at73c213 driver.  The
sound will be apear on L-channel.  Tested on AT91SAM9260-EK.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 89d6e9c..a7839cc 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -118,7 +118,7 @@ static struct snd_pcm_hardware snd_at73c213_playback_hw = {
 	.rates		= SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min	= 8000,  /* Replaced by chip->bitrate later. */
 	.rate_max	= 50000, /* Replaced by chip->bitrate later. */
-	.channels_min	= 2,
+	.channels_min	= 1,
 	.channels_max	= 2,
 	.buffer_bytes_max = 64 * 1024 - 1,
 	.period_bytes_min = 512,
@@ -228,6 +228,14 @@ static int snd_at73c213_pcm_close(struct snd_pcm_substream *substream)
 static int snd_at73c213_pcm_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *hw_params)
 {
+	struct snd_at73c213 *chip = snd_pcm_substream_chip(substream);
+	int channels = params_channels(hw_params);
+	int val;
+
+	val = ssc_readl(chip->ssc->regs, TFMR);
+	val = SSC_BFINS(TFMR_DATNB, channels - 1, val);
+	ssc_writel(chip->ssc->regs, TFMR, val);
+
 	return snd_pcm_lib_malloc_pages(substream,
 					params_buffer_bytes(hw_params));
 }
@@ -249,10 +257,12 @@ static int snd_at73c213_pcm_prepare(struct snd_pcm_substream *substream)
 
 	ssc_writel(chip->ssc->regs, PDC_TPR,
 			(long)runtime->dma_addr);
-	ssc_writel(chip->ssc->regs, PDC_TCR, runtime->period_size * 2);
+	ssc_writel(chip->ssc->regs, PDC_TCR,
+			runtime->period_size * runtime->channels);
 	ssc_writel(chip->ssc->regs, PDC_TNPR,
 			(long)runtime->dma_addr + block_size);
-	ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
+	ssc_writel(chip->ssc->regs, PDC_TNCR,
+			runtime->period_size * runtime->channels);
 
 	return 0;
 }
@@ -375,7 +385,8 @@ static irqreturn_t snd_at73c213_interrupt(int irq, void *dev_id)
 
 		ssc_writel(chip->ssc->regs, PDC_TNPR,
 				(long)runtime->dma_addr + offset);
-		ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
+		ssc_writel(chip->ssc->regs, PDC_TNCR,
+				runtime->period_size * runtime->channels);
 		retval = IRQ_HANDLED;
 	}
 
