Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZF0WWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZF0WWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 18:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZF0WWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 18:22:04 -0400
Received: from d1.icnet.pl ([212.160.220.21]:60953 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbZF0WWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 18:22:02 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Jarkko Nikula <jhnikula@gmail.com>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer callback
Date: Sun, 28 Jun 2009 00:21:05 +0200
User-Agent: KMail/1.9.10
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906280021.05931.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to work around the problem of broken OMAP1510 PCM playback 
pointer calculation by replacing DMA function call that incorrectly tries to 
read the value form DMA hardware with a value computed locally from an 
already maintained variable omap_runtime_data.period_index.

Tested on OMAP5910 based Amstrad Delta (E3) using work in progress ASoC 
driver.

Based on linux-2.6-asoc.git v2.6.31-rc1.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
It seems that on OMAP1510, DMA Channel Progress Counter registers 
(DMA_CPC_CH[0-8]) always contain values derived from DMA channels destination 
port address, even if constant, and there are no DMA registers available that 
would follow DMA channels source port address. Because of this limitation, 
current implementation of omap_get_dma_src_pos() for OMAP1510 is broken and 
doesn't seem to be easy correctable.

--- linux-2.6.31-rc1/sound/soc/omap/omap-pcm.c.orig	2009-06-27 
20:20:16.000000000 +0200
+++ linux-2.6.31-rc1/sound/soc/omap/omap-pcm.c	2009-06-27 23:21:42.000000000 
+0200
@@ -216,12 +216,15 @@ static snd_pcm_uframes_t omap_pcm_pointe
 	dma_addr_t ptr;
 	snd_pcm_uframes_t offset;
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		ptr = omap_get_dma_src_pos(prtd->dma_ch);
-	else
+	if (substream->stream == SNDRV_PCM_STREAM_CAPTURE) {
 		ptr = omap_get_dma_dst_pos(prtd->dma_ch);
+		offset = bytes_to_frames(runtime, ptr - runtime->dma_addr);
+	} else if (!(cpu_is_omap1510())) {
+		ptr = omap_get_dma_src_pos(prtd->dma_ch);
+		offset = bytes_to_frames(runtime, ptr - runtime->dma_addr);
+	} else
+		offset = prtd->period_index * runtime->period_size;
 
-	offset = bytes_to_frames(runtime, ptr - runtime->dma_addr);
 	if (offset >= runtime->buffer_size)
 		offset = 0;
 
