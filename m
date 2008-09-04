Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYIDIXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYIDIXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYIDIWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:22:03 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:43649 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYIDIV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:21:57 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59017794"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 6/9] ASoC: Blackfin: DMA Driver for I2S sound chip
Date: Thu,  4 Sep 2008 16:22:05 +0800
Message-Id: <1220516528-20301-7-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-i2s-pcm.c |  288 ++++++++++++++++++++++++++++++++++++
 sound/soc/blackfin/bf5xx-i2s-pcm.h |   29 ++++
 2 files changed, 317 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bf5xx-i2s-pcm.c
 create mode 100644 sound/soc/blackfin/bf5xx-i2s-pcm.h

diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
new file mode 100644
index 0000000..61fccf9
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -0,0 +1,288 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-i2s-pcm.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  DMA driver for i2s codec
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/dma.h>
+
+#include "bf5xx-i2s-pcm.h"
+#include "bf5xx-i2s.h"
+#include "bf5xx-sport.h"
+
+static void bf5xx_dma_irq(void *data)
+{
+	struct snd_pcm_substream *pcm = data;
+	snd_pcm_period_elapsed(pcm);
+}
+
+static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+				   SNDRV_PCM_INFO_MMAP |
+				   SNDRV_PCM_INFO_MMAP_VALID |
+				   SNDRV_PCM_INFO_BLOCK_TRANSFER,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
+				   SNDRV_PCM_FMTBIT_S24_LE |
+				   SNDRV_PCM_FMTBIT_S32_LE,
+	.period_bytes_min	= 32,
+	.period_bytes_max	= 0x10000,
+	.periods_min		= 1,
+	.periods_max		= PAGE_SIZE/32,
+	.buffer_bytes_max	= 0x20000, /* 128 kbytes */
+	.fifo_size		= 16,
+};
+
+static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+	snd_pcm_lib_malloc_pages(substream, size);
+
+	return 0;
+}
+
+static int bf5xx_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	snd_pcm_lib_free_pages(substream);
+
+	return 0;
+}
+
+static int bf5xx_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	int period_bytes = frames_to_bytes(runtime, runtime->period_size);
+
+	pr_debug("%s enter\n", __func__);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_tx_dma(sport, runtime->dma_area,
+			runtime->periods, period_bytes);
+	} else {
+		sport_set_rx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_rx_dma(sport, runtime->dma_area,
+			runtime->periods, period_bytes);
+	}
+
+	return 0;
+}
+
+static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	int ret = 0;
+
+	pr_debug("%s enter\n", __func__);
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			sport_tx_start(sport);
+		else
+			sport_rx_start(sport);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			sport_tx_stop(sport);
+		else
+			sport_rx_stop(sport);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	unsigned int diff;
+	snd_pcm_uframes_t frames;
+	pr_debug("%s enter\n", __func__);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		diff = sport_curr_offset_tx(sport);
+		frames = bytes_to_frames(substream->runtime, diff);
+	} else {
+		diff = sport_curr_offset_rx(sport);
+		frames = bytes_to_frames(substream->runtime, diff);
+	}
+	return frames;
+}
+
+static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int ret;
+
+	pr_debug("%s enter\n", __func__);
+	snd_soc_set_runtime_hwparams(substream, &bf5xx_pcm_hardware);
+
+	ret = snd_pcm_hw_constraint_integer(runtime, \
+			SNDRV_PCM_HW_PARAM_PERIODS);
+	if (ret < 0)
+		goto out;
+
+	if (sport_handle != NULL)
+		runtime->private_data = sport_handle;
+	else {
+		pr_err("sport_handle is NULL\n");
+		return -1;
+	}
+	return 0;
+
+ out:
+	return ret;
+}
+
+static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
+	struct vm_area_struct *vma)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	size_t size = vma->vm_end - vma->vm_start;
+	vma->vm_start = (unsigned long)runtime->dma_area;
+	vma->vm_end = vma->vm_start + size;
+	vma->vm_flags |=  VM_SHARED;
+
+	return 0 ;
+}
+
+struct snd_pcm_ops bf5xx_pcm_i2s_ops = {
+	.open		= bf5xx_pcm_open,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= bf5xx_pcm_hw_params,
+	.hw_free	= bf5xx_pcm_hw_free,
+	.prepare	= bf5xx_pcm_prepare,
+	.trigger	= bf5xx_pcm_trigger,
+	.pointer	= bf5xx_pcm_pointer,
+	.mmap		= bf5xx_pcm_mmap,
+};
+
+static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->area = dma_alloc_coherent(pcm->card->dev, size,
+			&buf->addr, GFP_KERNEL);
+	if (!buf->area) {
+		pr_err("Failed to allocate dma memory \
+			Please increase uncached DMA memory region\n");
+		return -ENOMEM;
+	}
+	buf->bytes = size;
+
+	pr_debug("%s, area:%p, size:0x%08lx\n", __func__,
+		buf->area, buf->bytes);
+
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK)
+		sport_handle->tx_buf = buf->area;
+	else
+		sport_handle->rx_buf = buf->area;
+
+	return 0;
+}
+
+static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+	int stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		substream = pcm->streams[stream].substream;
+		if (!substream)
+			continue;
+
+		buf = &substream->dma_buffer;
+		if (!buf->area)
+			continue;
+		dma_free_coherent(NULL, buf->bytes, buf->area, 0);
+		buf->area = NULL;
+	}
+	if (sport_handle)
+		sport_done(sport_handle);
+}
+
+static u64 bf5xx_pcm_dmamask = DMA_32BIT_MASK;
+
+int bf5xx_pcm_i2s_new(struct snd_card *card, struct snd_soc_dai *dai,
+	struct snd_pcm *pcm)
+{
+	int ret = 0;
+
+	pr_debug("%s enter\n", __func__);
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &bf5xx_pcm_dmamask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+
+	if (dai->playback.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_PLAYBACK);
+		if (ret)
+			goto out;
+	}
+
+	if (dai->capture.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_CAPTURE);
+		if (ret)
+			goto out;
+	}
+ out:
+	return ret;
+}
+
+struct snd_soc_platform bf5xx_i2s_soc_platform = {
+	.name		= "bf5xx-audio",
+	.pcm_ops 	= &bf5xx_pcm_i2s_ops,
+	.pcm_new	= bf5xx_pcm_i2s_new,
+	.pcm_free	= bf5xx_pcm_free_dma_buffers,
+};
+EXPORT_SYMBOL_GPL(bf5xx_i2s_soc_platform);
+
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ADI Blackfin I2S PCM DMA module");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.h b/sound/soc/blackfin/bf5xx-i2s-pcm.h
new file mode 100644
index 0000000..4d4609a
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.h
@@ -0,0 +1,29 @@
+/*
+ * linux/sound/arm/bf5xx-i2s-pcm.h -- ALSA PCM interface for the Blackfin
+ *
+ * Copyright 2007 Analog Device Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_I2S_PCM_H
+#define _BF5XX_I2S_PCM_H
+
+struct bf5xx_pcm_dma_params {
+	char *name;			/* stream identifier */
+};
+
+struct bf5xx_gpio {
+	u32 sys;
+	u32 rx;
+	u32 tx;
+	u32 clk;
+	u32 frm;
+};
+
+/* platform data */
+extern struct snd_soc_platform bf5xx_i2s_soc_platform;
+
+#endif
-- 
1.5.6
