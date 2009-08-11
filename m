Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbZHKTpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbZHKTpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZHKTpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:45:20 -0400
Received: from d1.icnet.pl ([212.160.220.21]:47611 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZHKTpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:45:18 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: [PATCH 3/3 v3] ASoC: OMAP: Enhance OMAP1510 DMA progress software counter
Date: Tue, 11 Aug 2009 21:44:29 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200908101050.08074.jkrzyszt@tis.icnet.pl> <200908110107.11485.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200908110107.11485.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908112144.30731.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance period_index accuracy, particularly just before buffer rewind, by
making use of DMA interrupt status flags in addition to simply counting up
interrupts.

Changes since v2:
> > > -   }
> > > +   } else if (stat == OMAP_DMA_LAST_IRQ)
> > > +           return;
> >
> > Is this test needed? This interrupt is set only for playback on
> > omap1510 so this looks null-op.
>
> You're right, I have put it here before limiting the flag request to
> playback on OMAP1510 only. So it can be omitted...

> > > +           omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
> > > +                                                   OMAP_DMA_LAST_IRQ);
> >
> > Indent OMAP_DMA_LAST_IRQ with tab(s) and spaces to the same column
> > than OMAP_DMA_FRAME_IRQ. Looks nicer then.
>
> OK, will fix it.
>
> > Should the
> > OMAP_DMA_BLOCK_IRQ to be set since it is handled in omap_pcm_dma_irq?
>
> This one is already requested from inside omap_request_dma() and used
> inside omap1_dma_handle_ch() in addition to passing it to us.
But for less confusion, it'll be better if requested from here too.

Changes since v1:
1. Fix buggy DMA interrupt handling in case of multiple status flags set in
   parallel.
2. Enable OMAP_DMA_LAST_IRQ only for playback on OMAP1510.

This patch applies on top of patch 2 from this series:
[RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
--- linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c.orig	2009-08-11 21:13:22.000000000 +0200
+++ linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c	2009-08-11 21:34:34.000000000 +0200
@@ -68,8 +68,21 @@ static void omap_pcm_dma_irq(int ch, u16
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
@@ -175,7 +188,12 @@ static int omap_pcm_prepare(struct snd_p
 	dma_params.frame_count	= runtime->periods;
 	omap_set_dma_params(prtd->dma_ch, &dma_params);
 
-	omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
+	if ((cpu_is_omap1510()) &&
+			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK))
+		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ |
+			      OMAP_DMA_LAST_IRQ | OMAP_DMA_BLOCK_IRQ);
+	else
+		omap_enable_dma_irq(prtd->dma_ch, OMAP_DMA_FRAME_IRQ);
 
 	return 0;
 }
