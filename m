Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZHJIvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZHJIvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZHJIvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:51:45 -0400
Received: from d1.icnet.pl ([212.160.220.21]:52775 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZHJIvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:51:44 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: [RFC] [PATCH 3/3] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter
Date: Mon, 10 Aug 2009 10:50:06 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101050.08074.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance period index accuracy, particularly just before buffer rewind, by
making use of DMA interrupt status flags in addition to simply counting
interrupts

This patch applies on top of patch 2 from this series:
[RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
--- linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c.orig	2009-08-10 08:31:08.000000000 +0200
+++ linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c	2009-08-10 08:55:09.000000000 +0200
@@ -68,13 +68,28 @@ static void omap_pcm_dma_irq(int ch, u16
 		 * that can be used by omap_pcm_pointer() instead.
 		 */
 		spin_lock_irqsave(&prtd->lock, flags);
-		if (prtd->period_index >= 0) {
-			if (++prtd->period_index == runtime->periods) {
+		if (stat & OMAP_DMA_LAST_IRQ) {
+			/* last period of a buffer has been started */
+			if (prtd->period_index == (runtime->periods - 1)) {
+				/* we are in sync, do nothing */
+				spin_unlock_irqrestore(&prtd->lock, flags);
+				return;
+			} else if (prtd->period_index >= 0) {
+				/* possible IRQ loss, update the pointer */
+				prtd->period_index = runtime->periods - 1;
+			}
+		} else if (prtd->period_index >= 0) {
+			/* playback in progress - increment the counter,
+			 * check for end of buffer */
+			if ((++prtd->period_index >= runtime->periods) ||
+						(stat & OMAP_DMA_BLOCK_IRQ)) {
+				/* end of buffer reached, loop back */
 				prtd->period_index = 0;
 			}
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
-	}
+	} else if (stat & OMAP_DMA_LAST_IRQ)
+		return;
 
 	snd_pcm_period_elapsed(substream);
 }
@@ -175,7 +190,8 @@ static int omap_pcm_prepare(struct snd_p
 	dma_params.frame_count	= runtime->periods;
 	omap_set_dma_params(prtd->dma_ch, &dma_params);
 
-	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
+	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
+				(cpu_is_omap1510() ? OMAP_DMA_LAST_IRQ : 0));
 
 	return 0;
 }
