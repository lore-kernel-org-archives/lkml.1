Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZHJIvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZHJIvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZHJIvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:51:37 -0400
Received: from d1.icnet.pl ([212.160.220.21]:52714 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZHJIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:51:35 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>
Subject: [RFC][PATCH 2/3] ASoC: OMAP: Make use of DMA channel self linking on OMAP1510
Date: Mon, 10 Aug 2009 10:50:04 +0200
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
Message-Id: <200908101050.05314.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use newly implemented DMA channel self linking on OMAP1510 like on other OMAP
models. Remove unnecessary DMA transfer restart from interrupt handler
routine.

The interrupt routine used to maintain a period index, originally needed for
counting up periods up to a full buffer in order to restart the DMA transfer.
For some time, this counter is also used as a replacement for hardware DMA
progress counter that has been found unusable on OMAP1510 in case of playback.
Thus, the period index calculation cannot be omitted completely. However, the
accuracy of this counter can still suffer from missing DMA interrupts.

In order to work correctly, it requires patch 1 from this series also applied:
[RFC][PATCH 1/3] ARM: OMAP: DMA: Add support for DMA channel self linking on OMAP1510

Created against linux-2.6.31-rc5.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

---
--- linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c.orig	2009-08-07 13:38:23.000000000 +0200
+++ linux-2.6.31-rc5/sound/soc/omap/omap-pcm.c	2009-08-10 08:31:08.000000000 +0200
@@ -59,16 +59,18 @@ static void omap_pcm_dma_irq(int ch, u16
 	struct omap_runtime_data *prtd = runtime->private_data;
 	unsigned long flags;
 
-	if (cpu_is_omap1510()) {
+	if ((cpu_is_omap1510()) &&
+			(substream->stream == SNDRV_PCM_STREAM_PLAYBACK)) {
 		/*
-		 * OMAP1510 doesn't support DMA chaining so have to restart
-		 * the transfer after all periods are transferred
+		 * OMAP1510 doesn't fully support DMA progress counter
+		 * and there is no software emulation implemented yet,
+		 * so have to maintain our own playback progress counter
+		 * that can be used by omap_pcm_pointer() instead.
 		 */
 		spin_lock_irqsave(&prtd->lock, flags);
 		if (prtd->period_index >= 0) {
 			if (++prtd->period_index == runtime->periods) {
 				prtd->period_index = 0;
-				omap_start_dma(prtd->dma_ch);
 			}
 		}
 		spin_unlock_irqrestore(&prtd->lock, flags);
@@ -100,7 +102,7 @@ static int omap_pcm_hw_params(struct snd
 	prtd->dma_data = dma_data;
 	err = omap_request_dma(dma_data->dma_req, dma_data->name,
 			       omap_pcm_dma_irq, substream, &prtd->dma_ch);
-	if (!err && !cpu_is_omap1510()) {
+	if (!err) {
 		/*
 		 * Link channel with itself so DMA doesn't need any
 		 * reprogramming while looping the buffer
@@ -119,8 +121,7 @@ static int omap_pcm_hw_free(struct snd_p
 	if (prtd->dma_data == NULL)
 		return 0;
 
-	if (!cpu_is_omap1510())
-		omap_dma_unlink_lch(prtd->dma_ch, prtd->dma_ch);
+	omap_dma_unlink_lch(prtd->dma_ch, prtd->dma_ch);
 	omap_free_dma(prtd->dma_ch);
 	prtd->dma_data = NULL;
 
