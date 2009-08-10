Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZHJXIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZHJXIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 19:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZHJXIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 19:08:48 -0400
Received: from d1.icnet.pl ([212.160.220.21]:38589 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbZHJXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 19:08:47 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: [RFC][PATCH 3/3 v2] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter
Date: Tue, 11 Aug 2009 01:07:10 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200908101050.08074.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908110107.11485.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance period index accuracy, particularly just before buffer rewind, by
making use of DMA interrupt status flags in addition to simply counting up
interrupts.

Corrections since v1:
1. Fix buggy DMA interrupt handling in case of multiple status flags set in
   parallel.
2. Enable OMAP_DMA_LAST_IRQ only for playback on OMAP1510.

This patch applies on top of patch 2 from this series:
[RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
--- linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c.orig	2009-08-10 22:41:25.000000000 +0200
+++ linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c	2009-08-10 23:15:46.000000000 +0200
@@ -68,13 +68,27 @@ static void omap_pcm_dma_irq(int ch, u16
 		 * that can be used by omap_pcm_pointer() instead.
 		 */
 		spin_lock_irqsave(&prtd->lock, flags);
+		if ((stat == OMAP_DMA_LAST_IRQ) &&
+				(prtd->period_index == runtime->periods - 1)) {
+			/* we are in sync, do nothing */
+			spin_unlock_irqrestore(&prtd->lock, flags);
+			return;
+		}
 		if (prtd->period_index >= 0) {
-			if (++prtd->period_index == runtime->periods) {
+			if (stat & OMAP_DMA_BLOCK_IRQ) {
+				/* end of buffer reached, loop back */
+				prtd->period_index = 0;
+			} else if (stat & OMAP_DMA_LAST_IRQ) {
+				/* update the counter for the last period */
+				prtd->period_index = runtime->periods - 1;
+			} else if (++prtd->period_index >= runtime->periods) {
+				/* end of buffer missed? loop back */
 				prtd->period_index = 0;
 			}
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
-	}
+	} else if (stat == OMAP_DMA_LAST_IRQ)
+		return;
 
 	snd_pcm_period_elapsed(substream);
 }
@@ -175,7 +189,12 @@ static int omap_pcm_prepare(struct snd_p
 	dma_params.frame_count	= runtime->periods;
 	omap_set_dma_params(prtd->dma_ch, &dma_params);
 
-	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
+	if ((cpu_is_omap1510()) &&
+			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK))
+		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
+							OMAP_DMA_LAST_IRQ);
+	else
+		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
 
 	return 0;
 }
