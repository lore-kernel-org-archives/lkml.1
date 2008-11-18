Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbYKRISZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbYKRISZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYKRIRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:01 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:5659 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYKRIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:58 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691573"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/8] ASoC: Blackfin: fix bug - AD1980/1 SOC Audio driver fails to build in case MMAP support is turned off
Date: Tue, 18 Nov 2008 16:18:18 +0800
Message-Id: <1226996302-10234-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

clean up redudent code and correct building problem in non-mmap mode

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ac97-pcm.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index 4be1a49..4d25f73 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -193,8 +193,10 @@ static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 			bf5xx_mmap_copy(substream, runtime->period_size);
 			sport->tx_delay_pos = 0;
+#endif
 			sport_tx_start(sport);
 		} else
 			sport_rx_start(sport);
@@ -267,23 +269,6 @@ static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
 	return ret;
 }
 
-static int bf5xx_pcm_close(struct snd_pcm_substream *substream)
-{
-	struct snd_pcm_runtime *runtime = substream->runtime;
-	struct sport_device *sport = runtime->private_data;
-
-	pr_debug("%s enter\n", __func__);
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		sport->once = 0;
-		memset(sport->tx_dma_buf, 0, runtime->buffer_size *
-			sizeof(struct ac97_frame));
-	} else
-		memset(sport->rx_dma_buf, 0, runtime->buffer_size *
-			sizeof(struct ac97_frame));
-
-	return 0;
-}
-
 #if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
 	struct vm_area_struct *vma)
@@ -301,7 +286,7 @@ static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
 		    void __user *buf, snd_pcm_uframes_t count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-
+	unsigned int chan_mask = ac97_chan_mask[runtime->channels - 1];
 	pr_debug("%s copy pos:0x%lx count:0x%lx\n",
 			substream->stream ? "Capture" : "Playback", pos, count);
 
@@ -317,7 +302,6 @@ static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
 
 struct snd_pcm_ops bf5xx_pcm_ac97_ops = {
 	.open		= bf5xx_pcm_open,
-	.close		= bf5xx_pcm_close,
 	.ioctl		= snd_pcm_lib_ioctl,
 	.hw_params	= bf5xx_pcm_hw_params,
 	.hw_free	= bf5xx_pcm_hw_free,
-- 
1.5.6.3
