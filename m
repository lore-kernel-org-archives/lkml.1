Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYKRISl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYKRISl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbYKRIRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:17:03 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:18386 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYKRIQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:16:58 -0500
X-IronPort-AV: E=Sophos;i="4.33,624,1220241600"; 
   d="scan'208";a="62691572"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/8] ASoC: Blackfin: add multi-channel function support
Date: Tue, 18 Nov 2008 16:18:17 +0800
Message-Id: <1226996302-10234-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
References: <1226996302-10234-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

This patch provides a option for users to enable multi-channel function support
in Blackfin ASoC driver. Because Blackfin is without MMU, it is easy for us and
the user to enable this function at compiling stage not dynamically on the fly.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/Kconfig          |   14 +++-
 sound/soc/blackfin/bf5xx-ac97-pcm.c |   80 +++++++++++-------
 sound/soc/blackfin/bf5xx-ac97.c     |  156 +++++++++++++++++++++--------------
 sound/soc/blackfin/bf5xx-ac97.h     |   35 +++++++-
 sound/soc/blackfin/bf5xx-sport.h    |    2 +-
 5 files changed, 184 insertions(+), 103 deletions(-)

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index 3fce187..43d89fc 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -47,7 +47,7 @@ config SND_BF5XX_AC97
 	  properly with this driver. This driver is known to work with the
 	  Analog Devices line of AC97 codecs.
 
-config SND_MMAP_SUPPORT
+config SND_BF5XX_MMAP_SUPPORT
 	bool "Enable MMAP Support"
 	depends on SND_BF5XX_AC97
 	default y
@@ -55,9 +55,17 @@ config SND_MMAP_SUPPORT
 	  Say y if you want AC97 driver to support mmap mode.
 	  We introduce an intermediate buffer to simulate mmap.
 
+config SND_BF5XX_MULTICHAN_SUPPORT
+	bool "Enable Multichannel Support"
+	depends on SND_BF5XX_AC97
+	default n
+	help
+	  Say y if you want AC97 driver to support up to 5.1 channel audio.
+	  this mode will consume much more memory for DMA.
+
 config SND_BF5XX_SOC_SPORT
 	tristate
-	
+
 config SND_BF5XX_SOC_I2S
 	tristate
 	select SND_BF5XX_SOC_SPORT
@@ -90,7 +98,7 @@ config SND_BF5XX_HAVE_COLD_RESET
 	depends on SND_BF5XX_AC97
 	default y if BFIN548_EZKIT
 	default n if !BFIN548_EZKIT
-	
+
 config SND_BF5XX_RESET_GPIO_NUM
 	int "Set a GPIO for cold reset"
 	depends on SND_BF5XX_HAVE_COLD_RESET
diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index 25e50d2..4be1a49 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -43,24 +43,34 @@
 #include "bf5xx-ac97.h"
 #include "bf5xx-sport.h"
 
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+static unsigned int ac97_chan_mask[] = {
+	SP_FL, /* Mono */
+	SP_STEREO, /* Stereo */
+	SP_2DOT1, /* 2.1*/
+	SP_QUAD,/*Quadraquic*/
+	SP_FL | SP_FR | SP_FC | SP_SL | SP_SR,/*5 channels */
+	SP_5DOT1, /* 5.1 */
+};
+
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 static void bf5xx_mmap_copy(struct snd_pcm_substream *substream,
 	 snd_pcm_uframes_t count)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
 	struct sport_device *sport = runtime->private_data;
+	unsigned int chan_mask = ac97_chan_mask[runtime->channels - 1];
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-		bf5xx_pcm_to_ac97(
-			(struct ac97_frame *)sport->tx_dma_buf + sport->tx_pos,
-			(__u32 *)runtime->dma_area + sport->tx_pos, count);
+		bf5xx_pcm_to_ac97((struct ac97_frame *)sport->tx_dma_buf +
+		sport->tx_pos, (__u16 *)runtime->dma_area + sport->tx_pos *
+		runtime->channels, count, chan_mask);
 		sport->tx_pos += runtime->period_size;
 		if (sport->tx_pos >= runtime->buffer_size)
 			sport->tx_pos %= runtime->buffer_size;
 		sport->tx_delay_pos = sport->tx_pos;
 	} else {
-		bf5xx_ac97_to_pcm(
-			(struct ac97_frame *)sport->rx_dma_buf + sport->rx_pos,
-			(__u32 *)runtime->dma_area + sport->rx_pos, count);
+		bf5xx_ac97_to_pcm((struct ac97_frame *)sport->rx_dma_buf +
+		sport->rx_pos, (__u16 *)runtime->dma_area + sport->rx_pos *
+		runtime->channels, count);
 		sport->rx_pos += runtime->period_size;
 		if (sport->rx_pos >= runtime->buffer_size)
 			sport->rx_pos %= runtime->buffer_size;
@@ -71,7 +81,7 @@ static void bf5xx_mmap_copy(struct snd_pcm_substream *substream,
 static void bf5xx_dma_irq(void *data)
 {
 	struct snd_pcm_substream *pcm = data;
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	struct snd_pcm_runtime *runtime = pcm->runtime;
 	struct sport_device *sport = runtime->private_data;
 	bf5xx_mmap_copy(pcm, runtime->period_size);
@@ -90,7 +100,7 @@ static void bf5xx_dma_irq(void *data)
  * The total rx/tx buffer is for ac97 frame to hold all pcm data
  * is  0x20000 * sizeof(struct ac97_frame) / 4.
  */
-#ifdef CONFIG_SND_MMAP_SUPPORT
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
 	.info			= SNDRV_PCM_INFO_INTERLEAVED |
 				   SNDRV_PCM_INFO_MMAP |
@@ -123,10 +133,20 @@ static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
 
 static int bf5xx_pcm_hw_free(struct snd_pcm_substream *substream)
 {
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
 
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-	memset(runtime->dma_area, 0, runtime->buffer_size);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport->once = 0;
+		if (runtime->dma_area)
+			memset(runtime->dma_area, 0, runtime->buffer_size);
+		memset(sport->tx_dma_buf, 0, runtime->buffer_size *
+			sizeof(struct ac97_frame));
+	} else
+		memset(sport->rx_dma_buf, 0, runtime->buffer_size *
+			sizeof(struct ac97_frame));
+#endif
 	snd_pcm_lib_free_pages(substream);
 	return 0;
 }
@@ -139,7 +159,7 @@ static int bf5xx_pcm_prepare(struct snd_pcm_substream *substream)
 	/* An intermediate buffer is introduced for implementing mmap for
 	 * SPORT working in TMD mode(include AC97).
 	 */
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
 		sport_config_tx_dma(sport, sport->tx_dma_buf, runtime->periods,
@@ -174,23 +194,21 @@ static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 	case SNDRV_PCM_TRIGGER_START:
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 			bf5xx_mmap_copy(substream, runtime->period_size);
-			snd_pcm_period_elapsed(substream);
 			sport->tx_delay_pos = 0;
 			sport_tx_start(sport);
-		}
-		else
+		} else
 			sport_rx_start(sport);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 			sport->tx_pos = 0;
 #endif
 			sport_tx_stop(sport);
 		} else {
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 			sport->rx_pos = 0;
 #endif
 			sport_rx_stop(sport);
@@ -208,7 +226,7 @@ static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
 	struct sport_device *sport = runtime->private_data;
 	unsigned int curr;
 
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
 		curr = sport->tx_delay_pos;
 	else
@@ -257,14 +275,16 @@ static int bf5xx_pcm_close(struct snd_pcm_substream *substream)
 	pr_debug("%s enter\n", __func__);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		sport->once = 0;
-		memset(sport->tx_dma_buf, 0, runtime->buffer_size * sizeof(struct ac97_frame));
+		memset(sport->tx_dma_buf, 0, runtime->buffer_size *
+			sizeof(struct ac97_frame));
 	} else
-		memset(sport->rx_dma_buf, 0, runtime->buffer_size * sizeof(struct ac97_frame));
+		memset(sport->rx_dma_buf, 0, runtime->buffer_size *
+			sizeof(struct ac97_frame));
 
 	return 0;
 }
 
-#ifdef CONFIG_SND_MMAP_SUPPORT
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
 	struct vm_area_struct *vma)
 {
@@ -286,13 +306,11 @@ static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
 			substream->stream ? "Capture" : "Playback", pos, count);
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		bf5xx_pcm_to_ac97(
-				(struct ac97_frame *)runtime->dma_area + pos,
-				buf, count);
+		bf5xx_pcm_to_ac97((struct ac97_frame *)runtime->dma_area + pos,
+			(__u16 *)buf, count, chan_mask);
 	else
-		bf5xx_ac97_to_pcm(
-				(struct ac97_frame *)runtime->dma_area + pos,
-				buf, count);
+		bf5xx_ac97_to_pcm((struct ac97_frame *)runtime->dma_area + pos,
+			(__u16 *)buf, count);
 	return 0;
 }
 #endif
@@ -306,7 +324,7 @@ struct snd_pcm_ops bf5xx_pcm_ac97_ops = {
 	.prepare	= bf5xx_pcm_prepare,
 	.trigger	= bf5xx_pcm_trigger,
 	.pointer	= bf5xx_pcm_pointer,
-#ifdef CONFIG_SND_MMAP_SUPPORT
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	.mmap		= bf5xx_pcm_mmap,
 #else
 	.copy		= bf5xx_pcm_copy,
@@ -344,7 +362,7 @@ static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
  * Need to allocate local buffer when enable
  * MMAP for SPORT working in TMD mode (include AC97).
  */
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		if (!sport_handle->tx_dma_buf) {
 			sport_handle->tx_dma_buf = dma_alloc_coherent(NULL, \
@@ -381,7 +399,7 @@ static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
 	struct snd_pcm_substream *substream;
 	struct snd_dma_buffer *buf;
 	int stream;
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	size_t size = bf5xx_pcm_hardware.buffer_bytes_max *
 		sizeof(struct ac97_frame) / 4;
 #endif
@@ -395,7 +413,7 @@ static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
 			continue;
 		dma_free_coherent(NULL, buf->bytes, buf->area, 0);
 		buf->area = NULL;
-#if defined(CONFIG_SND_MMAP_SUPPORT)
+#if defined(CONFIG_SND_BF5XX_MMAP_SUPPORT)
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		if (sport_handle->tx_dma_buf)
 			dma_free_coherent(NULL, size, \
diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
index 5e5aafb..65c162c 100644
--- a/sound/soc/blackfin/bf5xx-ac97.c
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -54,71 +54,103 @@
 static int *cmd_count;
 static int sport_num = CONFIG_SND_BF5XX_SPORT_NUM;
 
-#if defined(CONFIG_BF54x)
+static u16 sport_req[][7] = {
+		PIN_REQ_SPORT_0,
+#ifdef PIN_REQ_SPORT_1
+		PIN_REQ_SPORT_1,
+#endif
+#ifdef PIN_REQ_SPORT_2
+		PIN_REQ_SPORT_2,
+#endif
+#ifdef PIN_REQ_SPORT_3
+		PIN_REQ_SPORT_3,
+#endif
+	};
+
 static struct sport_param sport_params[4] = {
 	{
 		.dma_rx_chan	= CH_SPORT0_RX,
 		.dma_tx_chan	= CH_SPORT0_TX,
-		.err_irq	= IRQ_SPORT0_ERR,
+		.err_irq	= IRQ_SPORT0_ERROR,
 		.regs		= (struct sport_register *)SPORT0_TCR1,
 	},
+#ifdef PIN_REQ_SPORT_1
 	{
 		.dma_rx_chan	= CH_SPORT1_RX,
 		.dma_tx_chan	= CH_SPORT1_TX,
-		.err_irq	= IRQ_SPORT1_ERR,
+		.err_irq	= IRQ_SPORT1_ERROR,
 		.regs		= (struct sport_register *)SPORT1_TCR1,
 	},
+#endif
+#ifdef PIN_REQ_SPORT_2
 	{
 		.dma_rx_chan	= CH_SPORT2_RX,
 		.dma_tx_chan	= CH_SPORT2_TX,
-		.err_irq	= IRQ_SPORT2_ERR,
+		.err_irq	= IRQ_SPORT2_ERROR,
 		.regs		= (struct sport_register *)SPORT2_TCR1,
 	},
+#endif
+#ifdef PIN_REQ_SPORT_3
 	{
 		.dma_rx_chan	= CH_SPORT3_RX,
 		.dma_tx_chan	= CH_SPORT3_TX,
-		.err_irq	= IRQ_SPORT3_ERR,
+		.err_irq	= IRQ_SPORT3_ERROR,
 		.regs		= (struct sport_register *)SPORT3_TCR1,
 	}
-};
-#else
-static struct sport_param sport_params[2] = {
-	{
-		.dma_rx_chan	= CH_SPORT0_RX,
-		.dma_tx_chan	= CH_SPORT0_TX,
-		.err_irq	= IRQ_SPORT0_ERROR,
-		.regs		= (struct sport_register *)SPORT0_TCR1,
-	},
-	{
-		.dma_rx_chan	= CH_SPORT1_RX,
-		.dma_tx_chan	= CH_SPORT1_TX,
-		.err_irq	= IRQ_SPORT1_ERROR,
-		.regs		= (struct sport_register *)SPORT1_TCR1,
-	}
-};
 #endif
+};
 
-void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u32 *src, \
-		size_t count)
+void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u16 *src,
+		size_t count, unsigned int chan_mask)
 {
 	while (count--) {
-		dst->ac97_tag = TAG_VALID | TAG_PCM;
-		(dst++)->ac97_pcm = *src++;
+		dst->ac97_tag = TAG_VALID;
+		if (chan_mask & SP_FL) {
+			dst->ac97_pcm_r = *src++;
+			dst->ac97_tag |= TAG_PCM_RIGHT;
+		}
+		if (chan_mask & SP_FR) {
+			dst->ac97_pcm_l = *src++;
+			dst->ac97_tag |= TAG_PCM_LEFT;
+
+		}
+#if defined(CONFIG_SND_BF5XX_MULTICHAN_SUPPORT)
+		if (chan_mask & SP_SR) {
+			dst->ac97_sl = *src++;
+			dst->ac97_tag |= TAG_PCM_SL;
+		}
+		if (chan_mask & SP_SL) {
+			dst->ac97_sr = *src++;
+			dst->ac97_tag |= TAG_PCM_SR;
+		}
+		if (chan_mask & SP_LFE) {
+			dst->ac97_lfe = *src++;
+			dst->ac97_tag |= TAG_PCM_LFE;
+		}
+		if (chan_mask & SP_FC) {
+			dst->ac97_center = *src++;
+			dst->ac97_tag |= TAG_PCM_CENTER;
+		}
+#endif
+		dst++;
 	}
 }
 EXPORT_SYMBOL(bf5xx_pcm_to_ac97);
 
-void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u32 *dst, \
+void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u16 *dst,
 		size_t count)
 {
-	while (count--)
-		*(dst++) = (src++)->ac97_pcm;
+	while (count--) {
+		*(dst++) = src->ac97_pcm_l;
+		*(dst++) = src->ac97_pcm_r;
+		src++;
+	}
 }
 EXPORT_SYMBOL(bf5xx_ac97_to_pcm);
 
 static unsigned int sport_tx_curr_frag(struct sport_device *sport)
 {
-	return sport->tx_curr_frag = sport_curr_offset_tx(sport) / \
+	return sport->tx_curr_frag = sport_curr_offset_tx(sport) /
 			sport->tx_fragsize;
 }
 
@@ -130,7 +162,7 @@ static void enqueue_cmd(struct snd_ac97 *ac97, __u16 addr, __u16 data)
 
 	sport_incfrag(sport, &nextfrag, 1);
 
-	nextwrite = (struct ac97_frame *)(sport->tx_buf + \
+	nextwrite = (struct ac97_frame *)(sport->tx_buf +
 			nextfrag * sport->tx_fragsize);
 	pr_debug("sport->tx_buf:%p, nextfrag:0x%x nextwrite:%p, cmd_count:%d\n",
 		sport->tx_buf, nextfrag, nextwrite, cmd_count[nextfrag]);
@@ -297,20 +329,15 @@ static int bf5xx_ac97_resume(struct platform_device *pdev,
 static int bf5xx_ac97_probe(struct platform_device *pdev,
 			    struct snd_soc_dai *dai)
 {
-	int ret;
-#if defined(CONFIG_BF54x)
-	u16 sport_req[][7] = {PIN_REQ_SPORT_0, PIN_REQ_SPORT_1,
-				 PIN_REQ_SPORT_2, PIN_REQ_SPORT_3};
-#else
-	u16 sport_req[][7] = {PIN_REQ_SPORT_0, PIN_REQ_SPORT_1};
-#endif
+	int ret = 0;
 	cmd_count = (int *)get_zeroed_page(GFP_KERNEL);
 	if (cmd_count == NULL)
 		return -ENOMEM;
 
 	if (peripheral_request_list(&sport_req[sport_num][0], "soc-audio")) {
 		pr_err("Requesting Peripherals failed\n");
-		return -EFAULT;
+		ret =  -EFAULT;
+		goto peripheral_err;
 		}
 
 #ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
@@ -318,54 +345,52 @@ static int bf5xx_ac97_probe(struct platform_device *pdev,
 	if (gpio_request(CONFIG_SND_BF5XX_RESET_GPIO_NUM, "SND_AD198x RESET")) {
 		pr_err("Failed to request GPIO_%d for reset\n",
 				CONFIG_SND_BF5XX_RESET_GPIO_NUM);
-		peripheral_free_list(&sport_req[sport_num][0]);
-		return -1;
+		ret =  -1;
+		goto gpio_err;
 	}
 	gpio_direction_output(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 1);
 #endif
 	sport_handle = sport_init(&sport_params[sport_num], 2, \
 			sizeof(struct ac97_frame), NULL);
 	if (!sport_handle) {
-		peripheral_free_list(&sport_req[sport_num][0]);
-#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
-		gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
-#endif
-		return -ENODEV;
+		ret = -ENODEV;
+		goto sport_err;
 	}
 	/*SPORT works in TDM mode to simulate AC97 transfers*/
 	ret = sport_set_multichannel(sport_handle, 16, 0x1F, 1);
 	if (ret) {
 		pr_err("SPORT is busy!\n");
-		kfree(sport_handle);
-		peripheral_free_list(&sport_req[sport_num][0]);
-#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
-		gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
-#endif
-		return -EBUSY;
+		ret = -EBUSY;
+		goto sport_config_err;
 	}
 
 	ret = sport_config_rx(sport_handle, IRFS, 0xF, 0, (16*16-1));
 	if (ret) {
 		pr_err("SPORT is busy!\n");
-		kfree(sport_handle);
-		peripheral_free_list(&sport_req[sport_num][0]);
-#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
-		gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
-#endif
-		return -EBUSY;
+		ret = -EBUSY;
+		goto sport_config_err;
 	}
 
 	ret = sport_config_tx(sport_handle, ITFS, 0xF, 0, (16*16-1));
 	if (ret) {
 		pr_err("SPORT is busy!\n");
-		kfree(sport_handle);
-		peripheral_free_list(&sport_req[sport_num][0]);
+		ret = -EBUSY;
+		goto sport_config_err;
+	}
+
+sport_config_err:
+	kfree(sport_handle);
+sport_err:
 #ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
-		gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
+	gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
 #endif
-		return -EBUSY;
-	}
-	return 0;
+gpio_err:
+	peripheral_free_list(&sport_req[sport_num][0]);
+peripheral_err:
+	free_page((unsigned long)cmd_count);
+	cmd_count = NULL;
+
+	return ret;
 }
 
 static void bf5xx_ac97_remove(struct platform_device *pdev,
@@ -373,6 +398,7 @@ static void bf5xx_ac97_remove(struct platform_device *pdev,
 {
 	free_page((unsigned long)cmd_count);
 	cmd_count = NULL;
+	peripheral_free_list(&sport_req[sport_num][0]);
 #ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
 	gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
 #endif
@@ -389,7 +415,11 @@ struct snd_soc_dai bfin_ac97_dai = {
 	.playback = {
 		.stream_name = "AC97 Playback",
 		.channels_min = 2,
+#if defined(CONFIG_SND_BF5XX_MULTICHAN_SUPPORT)
+		.channels_max = 6,
+#else
 		.channels_max = 2,
+#endif
 		.rates = SNDRV_PCM_RATE_48000,
 		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
 	.capture = {
diff --git a/sound/soc/blackfin/bf5xx-ac97.h b/sound/soc/blackfin/bf5xx-ac97.h
index 3f77cc5..3f2a911 100644
--- a/sound/soc/blackfin/bf5xx-ac97.h
+++ b/sound/soc/blackfin/bf5xx-ac97.h
@@ -16,21 +16,46 @@ struct ac97_frame {
 	u16 ac97_tag;		/* slot 0 */
 	u16 ac97_addr;		/* slot 1 */
 	u16 ac97_data;		/* slot 2 */
-	u32 ac97_pcm;		/* slot 3 and 4: left and right pcm data */
+	u16 ac97_pcm_l;		/*slot 3:front left*/
+	u16 ac97_pcm_r;		/*slot 4:front left*/
+#if defined(CONFIG_SND_BF5XX_MULTICHAN_SUPPORT)
+	u16 ac97_mdm_l1;
+	u16 ac97_center;	/*slot 6:center*/
+	u16 ac97_sl;		/*slot 7:surround left*/
+	u16 ac97_sr;		/*slot 8:surround right*/
+	u16 ac97_lfe;		/*slot 9:lfe*/
+#endif
 } __attribute__ ((packed));
 
+/* Speaker location */
+#define SP_FL		0x0001
+#define SP_FR		0x0010
+#define SP_FC		0x0002
+#define SP_LFE		0x0020
+#define SP_SL		0x0004
+#define SP_SR		0x0040
+
+#define SP_STEREO	(SP_FL | SP_FR)
+#define SP_2DOT1	(SP_FL | SP_FR | SP_LFE)
+#define SP_QUAD		(SP_FL | SP_FR | SP_SL | SP_SR)
+#define SP_5DOT1	(SP_FL | SP_FR | SP_FC | SP_LFE | SP_SL | SP_SR)
+
 #define TAG_VALID		0x8000
 #define TAG_CMD			0x6000
 #define TAG_PCM_LEFT		0x1000
 #define TAG_PCM_RIGHT		0x0800
-#define TAG_PCM			(TAG_PCM_LEFT | TAG_PCM_RIGHT)
+#define TAG_PCM_MDM_L1		0x0400
+#define TAG_PCM_CENTER		0x0200
+#define TAG_PCM_SL		0x0100
+#define TAG_PCM_SR		0x0080
+#define TAG_PCM_LFE		0x0040
 
 extern struct snd_soc_dai bfin_ac97_dai;
 
-void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u32 *src, \
-		size_t count);
+void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u16 *src, \
+		size_t count, unsigned int chan_mask);
 
-void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u32 *dst, \
+void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u16 *dst, \
 		size_t count);
 
 #endif
diff --git a/sound/soc/blackfin/bf5xx-sport.h b/sound/soc/blackfin/bf5xx-sport.h
index fcadcc0..2e63dea 100644
--- a/sound/soc/blackfin/bf5xx-sport.h
+++ b/sound/soc/blackfin/bf5xx-sport.h
@@ -116,7 +116,7 @@ struct sport_device {
 	void *err_data;
 	unsigned char *tx_dma_buf;
 	unsigned char *rx_dma_buf;
-#ifdef CONFIG_SND_MMAP_SUPPORT
+#ifdef CONFIG_SND_BF5XX_MMAP_SUPPORT
 	dma_addr_t tx_dma_phy;
 	dma_addr_t rx_dma_phy;
 	int tx_pos;/*pcm sample count*/
-- 
1.5.6.3
