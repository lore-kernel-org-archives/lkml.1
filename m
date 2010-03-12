Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0CLKXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:23:47 -0500
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:46913 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932515Ab0CLKXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:23:37 -0500
Date: Fri, 12 Mar 2010 11:02:41 +0100
From: Benjamin Valentin <benpicco@zedat.fu-berlin.de>
To: linux-kernel@vger.kernel.org
Cc: dinuxbg@gmail.com, linux-arm-kernel@lists.infradead.org,
       alsa-devel@alsa-project.org, tiwai@suse.de
Subject: [PATCH 2/2] Quick fix for the audio clocks on SAM9-L9261
Message-ID: <20100312110241.3d97237b@rechenknecht2k7>
In-Reply-To: <20100312110032.2e57fdce@rechenknecht2k7>
References: <20100312105817.4392b594@rechenknecht2k7>
	<20100312110032.2e57fdce@rechenknecht2k7>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Originating-IP: 87.123.81.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dimitar Dimitrov <dimitar@olimex.com>

>From 10a85229b2357c89d5170efde5ac0e1cba4c9f9e Mon Sep 17 00:00:00 2001
From: Dimitar Dimitrov <dimitar@olimex.com>
Date: Wed, 27 May 2009 08:11:37 +0300
Subject: [PATCH] Quick fix for the audio clocks on SAM9-L9261

This patch together with support from SAM9-L9261 hardware fix an issue with
audio clocks. AT73C213 needs MCLK and BCLK with equal phase. The MCLK from
AT91SAM9XXX clock output and BCLK from the SSC TK clock output are not
phase-synchronized. Thus the SAM9-L9261 board provides external hardware
divison by 8 from MCLK to BCLK, ensuring zero phase difference.

See: http://www.at91.com/phpbb/viewtopic.php?t=2633
---
 sound/spi/at73c213.c |   54 ++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 4c7b051..325e534 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -29,6 +29,8 @@
 
 #include <linux/atmel-ssc.h>
 
+#include <asm/mach-types.h>
+
 #include <linux/spi/spi.h>
 #include <linux/spi/at73c213.h>
 
@@ -114,7 +116,11 @@ snd_at73c213_write_reg(struct snd_at73c213 *chip, u8 reg, u8 val)
 static struct snd_pcm_hardware snd_at73c213_playback_hw = {
 	.info		= SNDRV_PCM_INFO_INTERLEAVED |
 			  SNDRV_PCM_INFO_BLOCK_TRANSFER,
+#ifdef __BIG_ENDIAN
 	.formats	= SNDRV_PCM_FMTBIT_S16_BE,
+#else
+	.formats	= SNDRV_PCM_FMTBIT_S16_LE,
+#endif
 	.rates		= SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min	= 8000,  /* Replaced by chip->bitrate later. */
 	.rate_max	= 50000, /* Replaced by chip->bitrate later. */
@@ -144,7 +150,8 @@ static int snd_at73c213_set_bitrate(struct snd_at73c213 *chip)
 	 * as practical to the desired target rate.
 	 *
 	 * The DAC master clock (MCLK) is programmable, and is either 256
-	 * or (not here) 384 times the I2S output clock (BCLK).
+	 * or (not here) 384 times the I2S frame clock (LRC), that is
+	 * 8 or 12 times the output bit clock (BCLK).
 	 */
 
 	/* SSC clock / (bitrate * stereo * 16-bit). */
@@ -747,17 +754,40 @@ cleanup:
  */
 static int __devinit snd_at73c213_ssc_init(struct snd_at73c213 *chip)
 {
-	/*
-	 * Continuous clock output.
-	 * Starts on falling TF.
-	 * Delay 1 cycle (1 bit).
-	 * Periode is 16 bit (16 - 1).
-	 */
-	ssc_writel(chip->ssc->regs, TCMR,
-			SSC_BF(TCMR_CKO, 1)
-			| SSC_BF(TCMR_START, 4)
-			| SSC_BF(TCMR_STTDLY, 1)
-			| SSC_BF(TCMR_PERIOD, 16 - 1));
+	if (machine_is_sam9_l9261()) {
+		/*
+		 * dimitar@olimex.com : AT73C213 needs MCLK and BCLK with equal
+		 * phase. The MCLK from AT91SAM9XXX clock output and BCLK from
+		 * the SSC TK clock output are not phase-synchronized. Thus
+		 * the SAM9-L9261 board provides external hardware divison by
+		 * 8 from MCLK to BCLK, ensuring zero phase difference.
+		 * See: http://www.at91.com/phpbb/viewtopic.php?t=2633
+		 *
+		 * TK is clock input.
+		 * Clock source is TK pin.
+		 * Starts on falling TF.
+		 * Delay 1 cycle (1 bit).
+		 * Period is 16 bit (16 - 1).
+		 */
+		ssc_writel(chip->ssc->regs, TCMR,
+				SSC_BF(TCMR_CKS, 2)
+				| SSC_BF(TCMR_CKO, 0)
+				| SSC_BF(TCMR_START, 4)
+				| SSC_BF(TCMR_STTDLY, 1)
+				| SSC_BF(TCMR_PERIOD, 16 - 1));
+	} else {
+		/*
+		 * Continuous clock output.
+		 * Starts on falling TF.
+		 * Delay 1 cycle (1 bit).
+		 * Period is 16 bit (16 - 1).
+		 */
+		ssc_writel(chip->ssc->regs, TCMR,
+				SSC_BF(TCMR_CKO, 1)
+				| SSC_BF(TCMR_START, 4)
+				| SSC_BF(TCMR_STTDLY, 1)
+				| SSC_BF(TCMR_PERIOD, 16 - 1));
+	}
 	/*
 	 * Data length is 16 bit (16 - 1).
 	 * Transmit MSB first.
-- 
1.5.6.1

