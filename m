Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbZFSJ0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbZFSJ0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZFSJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:26:42 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:41357 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZFSJ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:26:39 -0400
X-IronPort-AV: E=Sophos;i="4.42,251,1243828800"; 
   d="scan'208";a="364133"
From: Barry Song <21cnbao@gmail.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       alsa-devel@alsa-project.org
CC: linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>
Subject: [PATCH] New ASoC Drivers for ADI AD1938 codec
Date: Fri, 19 Jun 2009 17:28:15 +0800
Message-ID: <1245403695-20537-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. add AD1938 codec driver                   (codec)
2. add blackfin SPORT-TDM DAI and PCM driver (platform)
3. add bf5xx board with AD1938 driver        (machine)
Signed-off-by: Barry Song <21cnbao@gmail.com>
---
 include/sound/soc-dai.h            |    1 +
 sound/soc/blackfin/Kconfig         |   46 +++-
 sound/soc/blackfin/Makefile        |    6 +
 sound/soc/blackfin/bf5xx-ad1938.c  |  178 ++++++++++++
 sound/soc/blackfin/bf5xx-tdm-pcm.c |  330 ++++++++++++++++++++++
 sound/soc/blackfin/bf5xx-tdm-pcm.h |   21 ++
 sound/soc/blackfin/bf5xx-tdm.c     |  295 +++++++++++++++++++
 sound/soc/blackfin/bf5xx-tdm.h     |   14 +
 sound/soc/codecs/Kconfig           |    4 +
 sound/soc/codecs/Makefile          |    2 +
 sound/soc/codecs/ad1938.c          |  548 ++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ad1938.h          |   68 +++++
 12 files changed, 1512 insertions(+), 1 deletions(-)
 create mode 100644 sound/soc/blackfin/bf5xx-ad1938.c
 create mode 100644 sound/soc/blackfin/bf5xx-tdm-pcm.c
 create mode 100644 sound/soc/blackfin/bf5xx-tdm-pcm.h
 create mode 100644 sound/soc/blackfin/bf5xx-tdm.c
 create mode 100644 sound/soc/blackfin/bf5xx-tdm.h
 create mode 100644 sound/soc/codecs/ad1938.c
 create mode 100644 sound/soc/codecs/ad1938.h

diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index 352d7ee..069e1a9 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -30,6 +30,7 @@ struct snd_pcm_substream;
 #define SND_SOC_DAIFMT_DSP_A		3 /* L data msb after FRM LRC */
 #define SND_SOC_DAIFMT_DSP_B		4 /* L data msb during FRM LRC */
 #define SND_SOC_DAIFMT_AC97		5 /* AC97 */
+#define SND_SOC_DAIFMT_SPORT_TDM	6 /* SPORT TDM for ADI parts */
 
 /* left and right justified also known as MSB and LSB respectively */
 #define SND_SOC_DAIFMT_MSB		SND_SOC_DAIFMT_LEFT_J
diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
index 811596f..c35cc72 100644
--- a/sound/soc/blackfin/Kconfig
+++ b/sound/soc/blackfin/Kconfig
@@ -7,6 +7,15 @@ config SND_BF5XX_I2S
 	  mode (supports single stereo In/Out).
 	  You will also need to select the audio interfaces to support below.
 
+config SND_BF5XX_TDM
+	tristate "SoC TDM Audio for the ADI BF5xx chip"
+	depends on BLACKFIN && SND_SOC
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the Blackfin SPORT (synchronous serial ports) interface in TDM
+	  mode.
+	  You will also need to select the audio interfaces to support below.
+
 config SND_BF5XX_SOC_SSM2602
 	tristate "SoC SSM2602 Audio support for BF52x ezkit"
 	depends on SND_BF5XX_I2S
@@ -69,6 +78,10 @@ config SND_BF5XX_SOC_I2S
 	tristate
 	select SND_BF5XX_SOC_SPORT
 
+config SND_BF5XX_SOC_TDM
+	tristate
+	select SND_BF5XX_SOC_SPORT
+
 config SND_BF5XX_SOC_AC97
 	tristate
 	select AC97_BUS
@@ -83,9 +96,40 @@ config SND_BF5XX_SOC_AD1980
 	help
 	  Say Y if you want to add support for SoC audio on BF5xx STAMP/EZKIT.
 
+config SND_BF5XX_SOC_AD1938
+	tristate "SoC AD1938 Audio support for Blackfin"
+	depends on (SND_BF5XX_TDM || SND_BF5XX_I2S)
+	select SND_BF5XX_SOC_TDM
+	select SND_BF5XX_SOC_I2S
+	select SND_SOC_AD1938
+	help
+	  Say Y if you want to add support for AD1938 codec on Blackfin.
+choice
+	prompt "Interface between Blackfin and AD1938"
+	depends on SND_BF5XX_SOC_AD1938
+	default SND_BF5XX_AD1938_TDM
+	help
+	  There are two types of interface can be supportted on Blackfin
+	  Stamp: TDM and I2S. TDM support 8 channels. I2S only support 2 channels.
+
+config SND_BF5XX_AD1938_TDM
+	boolean "TDM interface"
+	depends on SND_BF5XX_TDM
+	help
+	  TDM supports 8 channels ouput
+	  If unsure, say Y.
+
+config SND_BF5XX_AD1938_I2S
+	boolean "I2S interface"
+	depends on SND_BF5XX_I2S
+	help
+	  I2S support 2 channels ouput
+	  If unsure, say N.
+endchoice
+
 config SND_BF5XX_SPORT_NUM
 	int "Set a SPORT for Sound chip"
-	depends on (SND_BF5XX_I2S || SND_BF5XX_AC97)
+	depends on (SND_BF5XX_I2S || SND_BF5XX_AC97 || SND_BF5XX_TDM)
 	range 0 3 if BF54x
 	range 0 1 if !BF54x
 	default 0
diff --git a/sound/soc/blackfin/Makefile b/sound/soc/blackfin/Makefile
index 97bb37a..f4d7607 100644
--- a/sound/soc/blackfin/Makefile
+++ b/sound/soc/blackfin/Makefile
@@ -1,21 +1,27 @@
 # Blackfin Platform Support
 snd-bf5xx-ac97-objs := bf5xx-ac97-pcm.o
 snd-bf5xx-i2s-objs := bf5xx-i2s-pcm.o
+snd-bf5xx-tdm-objs := bf5xx-tdm-pcm.o
 snd-soc-bf5xx-sport-objs := bf5xx-sport.o
 snd-soc-bf5xx-ac97-objs := bf5xx-ac97.o
 snd-soc-bf5xx-i2s-objs := bf5xx-i2s.o
+snd-soc-bf5xx-tdm-objs := bf5xx-tdm.o
 
 obj-$(CONFIG_SND_BF5XX_AC97) += snd-bf5xx-ac97.o
 obj-$(CONFIG_SND_BF5XX_I2S) += snd-bf5xx-i2s.o
+obj-$(CONFIG_SND_BF5XX_TDM) += snd-bf5xx-tdm.o
 obj-$(CONFIG_SND_BF5XX_SOC_SPORT) += snd-soc-bf5xx-sport.o
 obj-$(CONFIG_SND_BF5XX_SOC_AC97) += snd-soc-bf5xx-ac97.o
 obj-$(CONFIG_SND_BF5XX_SOC_I2S) += snd-soc-bf5xx-i2s.o
+obj-$(CONFIG_SND_BF5XX_SOC_TDM) += snd-soc-bf5xx-tdm.o
 
 # Blackfin Machine Support
 snd-ad1980-objs := bf5xx-ad1980.o
 snd-ssm2602-objs := bf5xx-ssm2602.o
 snd-ad73311-objs := bf5xx-ad73311.o
+snd-ad1938-objs := bf5xx-ad1938.o
 
 obj-$(CONFIG_SND_BF5XX_SOC_AD1980) += snd-ad1980.o
 obj-$(CONFIG_SND_BF5XX_SOC_SSM2602) += snd-ssm2602.o
 obj-$(CONFIG_SND_BF5XX_SOC_AD73311) += snd-ad73311.o
+obj-$(CONFIG_SND_BF5XX_SOC_AD1938) += snd-ad1938.o
diff --git a/sound/soc/blackfin/bf5xx-ad1938.c b/sound/soc/blackfin/bf5xx-ad1938.c
new file mode 100644
index 0000000..3eccb2f
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ad1938.c
@@ -0,0 +1,178 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ad1938.c
+ * Author:       Barry Song <Barry.Song@analog.com>
+ *
+ * Created:      Thur June 4 2009
+ * Description:  Board driver for ad1938 sound chip
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
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/pcm_params.h>
+
+#include <asm/blackfin.h>
+#include <asm/cacheflush.h>
+#include <asm/irq.h>
+#include <asm/dma.h>
+#include <asm/portmux.h>
+
+#include "../codecs/ad1938.h"
+#include "bf5xx-sport.h"
+
+#ifdef CONFIG_SND_BF5XX_AD1938_TDM
+#include "bf5xx-tdm-pcm.h"
+#include "bf5xx-tdm.h"
+#else
+#include "bf5xx-i2s-pcm.h"
+#include "bf5xx-i2s.h"
+#endif
+
+static struct snd_soc_card bf5xx_ad1938;
+
+static int bf5xx_ad1938_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+
+	cpu_dai->private_data = sport_handle;
+	return 0;
+}
+
+static int bf5xx_ad1938_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->dai->codec_dai;
+
+	/* disable the PLL */
+	return snd_soc_dai_set_pll(codec_dai, 0, 0, 0);
+}
+
+static int bf5xx_ad1938_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+	struct snd_soc_dai *codec_dai = rtd->dai->codec_dai;
+	int ret = 0;
+#ifdef CONFIG_SND_BF5XX_AD1938_TDM
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_SPORT_TDM |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_SPORT_TDM |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+#else
+	/* set cpu DAI configuration */
+	ret = snd_soc_dai_set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+
+	/* set codec DAI configuration */
+	ret = snd_soc_dai_set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+			SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+#endif
+	/* set codec DAI pll */
+	ret = snd_soc_dai_set_pll(codec_dai, 0, 12288000, 48000*512);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_ops bf5xx_ad1938_ops = {
+	.startup = bf5xx_ad1938_startup,
+	.hw_params = bf5xx_ad1938_hw_params,
+	.hw_free = bf5xx_ad1938_hw_free,
+};
+
+static struct snd_soc_dai_link bf5xx_ad1938_dai = {
+	.name = "ad1938",
+	.stream_name = "AD1938",
+#ifdef CONFIG_SND_BF5XX_AD1938_TDM
+	.cpu_dai = &bf5xx_tdm_dai,
+#else
+	.cpu_dai = &bf5xx_i2s_dai,
+#endif
+	.codec_dai = &ad1938_dai,
+	.ops = &bf5xx_ad1938_ops,
+};
+
+static struct snd_soc_card bf5xx_ad1938 = {
+	.name = "bf5xx_ad1938",
+#ifdef CONFIG_SND_BF5XX_AD1938_TDM
+	.platform = &bf5xx_tdm_soc_platform,
+#else
+	.platform = &bf5xx_i2s_soc_platform,
+#endif
+	.dai_link = &bf5xx_ad1938_dai,
+	.num_links = 1,
+};
+
+static struct snd_soc_device bf5xx_ad1938_snd_devdata = {
+	.card = &bf5xx_ad1938,
+	.codec_dev = &soc_codec_dev_ad1938,
+};
+
+static struct platform_device *bfxx_ad1938_snd_device;
+
+static int __init bf5xx_ad1938_init(void)
+{
+	int ret;
+
+	bfxx_ad1938_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!bfxx_ad1938_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(bfxx_ad1938_snd_device, &bf5xx_ad1938_snd_devdata);
+	bf5xx_ad1938_snd_devdata.dev = &bfxx_ad1938_snd_device->dev;
+	ret = platform_device_add(bfxx_ad1938_snd_device);
+
+	if (ret)
+		platform_device_put(bfxx_ad1938_snd_device);
+
+	return ret;
+}
+
+static void __exit bf5xx_ad1938_exit(void)
+{
+	platform_device_unregister(bfxx_ad1938_snd_device);
+}
+
+module_init(bf5xx_ad1938_init);
+module_exit(bf5xx_ad1938_exit);
+
+/* Module information */
+MODULE_AUTHOR("Barry Song");
+MODULE_DESCRIPTION("ALSA SoC AD1938 board driver");
+MODULE_LICENSE("GPL");
+
diff --git a/sound/soc/blackfin/bf5xx-tdm-pcm.c b/sound/soc/blackfin/bf5xx-tdm-pcm.c
new file mode 100644
index 0000000..2b0458c
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-tdm-pcm.c
@@ -0,0 +1,330 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-tdm-pcm.c
+ * Author:       Barry Song <Barry.Song@analog.com>
+ *
+ * Created:      Tue June 06 2009
+ * Description:  DMA driver for tdm codec
+ *
+ * Modified:
+ *               Copyright 2009 Analog Devices Inc.
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
+#include "bf5xx-tdm-pcm.h"
+#include "bf5xx-tdm.h"
+#include "bf5xx-sport.h"
+
+#define PCM_BUFFER_MAX  0x10000
+#define FRAGMENT_SIZE_MIN  (4*1024)
+#define FRAGMENTS_MIN  2
+#define FRAGMENTS_MAX  32
+
+static void bf5xx_dma_irq(void *data)
+{
+	struct snd_pcm_substream *pcm = data;
+	snd_pcm_period_elapsed(pcm);
+}
+
+static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
+	.info = (SNDRV_PCM_INFO_INTERLEAVED | SNDRV_PCM_INFO_BLOCK_TRANSFER | SNDRV_PCM_INFO_RESUME),
+	.formats =          SNDRV_PCM_FMTBIT_S32_LE,
+	.rates =            SNDRV_PCM_RATE_48000,
+	.channels_min =     2,
+	.channels_max =     8,
+	.buffer_bytes_max = PCM_BUFFER_MAX,
+	.period_bytes_min = FRAGMENT_SIZE_MIN,
+	.period_bytes_max = PCM_BUFFER_MAX/2,
+	.periods_min =      FRAGMENTS_MIN,
+	.periods_max =      FRAGMENTS_MAX,
+};
+
+static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params)
+{
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+	snd_pcm_lib_malloc_pages(substream, size * 4);
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
+	int fragsize_bytes = frames_to_bytes(runtime, runtime->period_size);
+
+	fragsize_bytes /= runtime->channels;
+	fragsize_bytes *= 8;/* inflate the fragsize to match */
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_tx_dma(sport, runtime->dma_area,
+				runtime->periods, fragsize_bytes);
+	} else {
+		sport_set_rx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_rx_dma(sport, runtime->dma_area,
+				runtime->periods, fragsize_bytes);
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
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		diff = sport_curr_offset_tx(sport);
+		frames = diff / (8*4); /* 32 bytes per frame */
+	} else {
+		diff = sport_curr_offset_rx(sport);
+		frames = diff / (8*4);
+	}
+	return frames;
+}
+
+static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int ret;
+
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
+static int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
+		snd_pcm_uframes_t pos, void *buf, snd_pcm_uframes_t count)
+{
+	unsigned int *src;
+	unsigned int *dst;
+	int i;
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		src = (unsigned int *)buf;
+		dst = (unsigned int *)substream->runtime->dma_area;
+
+		dst += pos * 8;
+		while (count--) {
+			for (i = 0; i < substream->runtime->channels; i++)
+				*(dst + i) = *src++;
+			dst += 8;
+		}
+	} else {
+		src = (unsigned int *)substream->runtime->dma_area;
+		dst = (unsigned int *)buf;
+
+		src += pos * 8;
+		while (count--) {
+			for (i = 0; i < substream->runtime->channels; i++)
+				*dst++ = *(src+i);
+			src += 8;
+		}
+	}
+
+	return 0;
+}
+
+static int bf5xx_pcm_silence(struct snd_pcm_substream *substream,
+		int channel, snd_pcm_uframes_t pos, snd_pcm_uframes_t count)
+{
+	unsigned char *buf = substream->runtime->dma_area;
+	buf += pos * 8 * 4;
+	memset(buf, '\0', count * 8 * 4);
+
+	return 0;
+}
+
+
+struct snd_pcm_ops bf5xx_pcm_tdm_ops = {
+	.open		= bf5xx_pcm_open,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= bf5xx_pcm_hw_params,
+	.hw_free	= bf5xx_pcm_hw_free,
+	.prepare	= bf5xx_pcm_prepare,
+	.trigger	= bf5xx_pcm_trigger,
+	.pointer	= bf5xx_pcm_pointer,
+	.copy           = bf5xx_pcm_copy,
+	.silence        = bf5xx_pcm_silence,
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
+	buf->area = dma_alloc_coherent(pcm->card->dev, size * 4,
+			&buf->addr, GFP_KERNEL);
+	if (!buf->area) {
+		pr_err("Failed to allocate dma memory \
+				Please increase uncached DMA memory region\n");
+		return -ENOMEM;
+	}
+	buf->bytes = size;
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
+int bf5xx_pcm_tdm_new(struct snd_card *card, struct snd_soc_dai *dai,
+	struct snd_pcm *pcm)
+{
+	int ret = 0;
+
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
+struct snd_soc_platform bf5xx_tdm_soc_platform = {
+	.name		= "bf5xx-audio",
+	.pcm_ops 	= &bf5xx_pcm_tdm_ops,
+	.pcm_new	= bf5xx_pcm_tdm_new,
+	.pcm_free	= bf5xx_pcm_free_dma_buffers,
+};
+EXPORT_SYMBOL_GPL(bf5xx_tdm_soc_platform);
+
+static int __init bfin_tdm_init(void)
+{
+	return snd_soc_register_platform(&bf5xx_tdm_soc_platform);
+}
+module_init(bfin_tdm_init);
+
+static void __exit bfin_tdm_exit(void)
+{
+	snd_soc_unregister_platform(&bf5xx_tdm_soc_platform);
+}
+module_exit(bfin_tdm_exit);
+
+MODULE_AUTHOR("Barry Song");
+MODULE_DESCRIPTION("ADI Blackfin TDM PCM DMA module");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-tdm-pcm.h b/sound/soc/blackfin/bf5xx-tdm-pcm.h
new file mode 100644
index 0000000..493e6df
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-tdm-pcm.h
@@ -0,0 +1,21 @@
+/*
+ * linux/sound/arm/bf5xx-tdm-pcm.h -- ALSA PCM interface for the Blackfin
+ *
+ * Copyright 2009 Analog Device Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_TDM_PCM_H
+#define _BF5XX_TDM_PCM_H
+
+struct bf5xx_pcm_dma_params {
+	char *name;			/* stream identifier */
+};
+
+/* platform data */
+extern struct snd_soc_platform bf5xx_tdm_soc_platform;
+
+#endif
diff --git a/sound/soc/blackfin/bf5xx-tdm.c b/sound/soc/blackfin/bf5xx-tdm.c
new file mode 100644
index 0000000..d44ce9d
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-tdm.c
@@ -0,0 +1,295 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-tdm.c
+ * Author:       Barry Song <Barry.Song@analog.com>
+ *
+ * Created:      Thurs June 04 2009
+ * Description:  Blackfin TDM CPU DAI driver
+ *
+ * Modified:
+ *               Copyright 2009 Analog Devices Inc.
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+
+#include <asm/irq.h>
+#include <asm/portmux.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+
+#include "bf5xx-sport.h"
+#include "bf5xx-tdm.h"
+
+struct bf5xx_tdm_port {
+	u16 tcr1;
+	u16 rcr1;
+	u16 tcr2;
+	u16 rcr2;
+	int configured;
+};
+
+static struct bf5xx_tdm_port bf5xx_tdm;
+static int sport_num = CONFIG_SND_BF5XX_SPORT_NUM;
+
+static struct sport_param sport_params[2] = {
+	{
+		.dma_rx_chan	= CH_SPORT0_RX,
+		.dma_tx_chan	= CH_SPORT0_TX,
+		.err_irq	= IRQ_SPORT0_ERROR,
+		.regs		= (struct sport_register *)SPORT0_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT1_RX,
+		.dma_tx_chan	= CH_SPORT1_TX,
+		.err_irq	= IRQ_SPORT1_ERROR,
+		.regs		= (struct sport_register *)SPORT1_TCR1,
+	}
+};
+
+/*
+ * Setting the TFS pin selector for SPORT 0 based on whether the selected
+ * port id F or G. If the port is F then no conflict should exist for the
+ * TFS. When Port G is selected and EMAC then there is a conflict between
+ * the PHY interrupt line and TFS.  Current settings prevent the conflict
+ * by ignoring the TFS pin when Port G is selected. This allows both
+ * ssm2602 using Port G and EMAC concurrently.
+ */
+#ifdef CONFIG_BF527_SPORT0_PORTF
+#define LOCAL_SPORT0_TFS (P_SPORT0_TFS)
+#else
+#define LOCAL_SPORT0_TFS (0)
+#endif
+
+static u16 sport_req[][7] = { {P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS,
+	P_SPORT0_DRPRI, P_SPORT0_RSCLK, LOCAL_SPORT0_TFS, 0},
+	   {P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, P_SPORT1_DRPRI,
+		   P_SPORT1_RSCLK, P_SPORT1_TFS, 0} };
+
+static int bf5xx_tdm_set_dai_fmt(struct snd_soc_dai *cpu_dai,
+		unsigned int fmt)
+{
+	int ret = 0;
+
+	/* interface format:support TDM,slave mode */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_SPORT_TDM:
+		break;
+	default:
+		printk(KERN_ERR "%s: Unknown DAI format type\n", __func__);
+		ret = -EINVAL;
+		break;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+	case SND_SOC_DAIFMT_CBM_CFS:
+	case SND_SOC_DAIFMT_CBS_CFM:
+		ret = -EINVAL;
+		break;
+	default:
+		printk(KERN_ERR "%s: Unknown DAI master type\n", __func__);
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int bf5xx_tdm_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *dai)
+{
+	int ret = 0;
+
+	bf5xx_tdm.tcr2 &= ~0x1f;
+	bf5xx_tdm.rcr2 &= ~0x1f;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S32_LE:
+		bf5xx_tdm.tcr2 |= 31;
+		bf5xx_tdm.rcr2 |= 31;
+		sport_handle->wdsize = 4;
+		break;
+	}
+
+	if (!bf5xx_tdm.configured) {
+		/*
+		 * TX and RX are not independent,they are enabled at the
+		 * same time, even if only one side is running. So, we
+		 * need to configure both of them at the time when the first
+		 * stream is opened.
+		 *
+		 * CPU DAI:slave mode.
+		 */
+		ret = sport_config_rx(sport_handle, bf5xx_tdm.rcr1,
+				bf5xx_tdm.rcr2, 0, 0);
+		if (ret) {
+			pr_err("SPORT is busy!\n");
+			return -EBUSY;
+		}
+
+		ret = sport_config_tx(sport_handle, bf5xx_tdm.tcr1,
+				bf5xx_tdm.tcr2, 0, 0);
+		if (ret) {
+			pr_err("SPORT is busy!\n");
+			return -EBUSY;
+		}
+		bf5xx_tdm.configured = 1;
+	}
+
+	return 0;
+}
+
+static int bf5xx_tdm_probe(struct platform_device *pdev,
+		struct snd_soc_dai *dai)
+{
+	int ret = 0;
+
+	if (peripheral_request_list(&sport_req[sport_num][0], "soc-audio")) {
+		pr_err("Requesting Peripherals failed\n");
+		return -EFAULT;
+	}
+
+	/* request DMA for SPORT */
+	sport_handle = sport_init(&sport_params[sport_num], 4, \
+			8 * sizeof(u32), NULL);
+	if (!sport_handle) {
+		peripheral_free_list(&sport_req[sport_num][0]);
+		return -ENODEV;
+	}
+
+	/* SPORT works in TDM mode */
+	ret = sport_set_multichannel(sport_handle, 8, 0xFF, 1);
+	if (ret) {
+		pr_err("SPORT is busy!\n");
+		ret = -EBUSY;
+		goto sport_config_err;
+	}
+
+	ret = sport_config_rx(sport_handle, IRFS, 0x1F, 0, 0);
+	if (ret) {
+		pr_err("SPORT is busy!\n");
+		ret = -EBUSY;
+		goto sport_config_err;
+	}
+
+	ret = sport_config_tx(sport_handle, ITFS, 0x1F, 0, 0);
+	if (ret) {
+		pr_err("SPORT is busy!\n");
+		ret = -EBUSY;
+		goto sport_config_err;
+	}
+
+sport_config_err:
+	peripheral_free_list(&sport_req[sport_num][0]);
+	return ret;
+}
+
+static void bf5xx_tdm_remove(struct platform_device *pdev,
+		struct snd_soc_dai *dai)
+{
+	peripheral_free_list(&sport_req[sport_num][0]);
+}
+
+#ifdef CONFIG_PM
+static int bf5xx_tdm_suspend(struct snd_soc_dai *dai)
+{
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	if (!dai->active)
+		return 0;
+	if (dai->capture.active)
+		sport_rx_stop(sport);
+	if (dai->playback.active)
+		sport_tx_stop(sport);
+	return 0;
+}
+
+static int bf5xx_tdm_resume(struct snd_soc_dai *dai)
+{
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	if (!dai->active)
+		return 0;
+
+	if (dai->capture.active)
+		sport_rx_start(sport);
+	if (dai->playback.active)
+		sport_tx_start(sport);
+	return 0;
+}
+
+#else
+#define bf5xx_tdm_suspend	NULL
+#define bf5xx_tdm_resume	NULL
+#endif
+
+static struct snd_soc_dai_ops bf5xx_tdm_dai_ops = {
+	.hw_params	= bf5xx_tdm_hw_params,
+	.set_fmt	= bf5xx_tdm_set_dai_fmt,
+};
+
+struct snd_soc_dai bf5xx_tdm_dai = {
+	.name = "bf5xx-tdm",
+	.id = 0,
+	.probe = bf5xx_tdm_probe,
+	.remove = bf5xx_tdm_remove,
+	.suspend = bf5xx_tdm_suspend,
+	.resume = bf5xx_tdm_resume,
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+	.capture = {
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+	.ops = &bf5xx_tdm_dai_ops,
+};
+EXPORT_SYMBOL_GPL(bf5xx_tdm_dai);
+
+static int __init bfin_tdm_init(void)
+{
+	return snd_soc_register_dai(&bf5xx_tdm_dai);
+}
+module_init(bfin_tdm_init);
+
+static void __exit bfin_tdm_exit(void)
+{
+	snd_soc_unregister_dai(&bf5xx_tdm_dai);
+}
+MODULE_EXIT(bfin_tdm_exit);
+
+/* Module information */
+MODULE_AUTHOR("Barry Song");
+MODULE_DESCRIPTION("TDM driver for ADI Blackfin");
+MODULE_LICENSE("GPL");
+
diff --git a/sound/soc/blackfin/bf5xx-tdm.h b/sound/soc/blackfin/bf5xx-tdm.h
new file mode 100644
index 0000000..e5157cd
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-tdm.h
@@ -0,0 +1,14 @@
+/*
+ * linux/sound/arm/bf5xx-i2s.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_TDM_H
+#define _BF5XX_TDM_H
+
+extern struct snd_soc_dai bf5xx_tdm_dai;
+
+#endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f049a98..ce7bcf5 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -12,6 +12,7 @@ config SND_SOC_ALL_CODECS
 	tristate "Build all ASoC CODEC drivers"
 	select SND_SOC_L3
 	select SND_SOC_AC97_CODEC if SND_SOC_AC97_BUS
+	select SND_SOC_AD1938 if SPI_MASTER
 	select SND_SOC_AD1939 if I2C
 	select SND_SOC_AD1980 if SND_SOC_AC97_BUS
 	select SND_SOC_AD73311 if I2C
@@ -70,6 +71,9 @@ config SND_SOC_ALL_CODECS
 config SND_SOC_AC97_CODEC
 	tristate
 
+config SND_SOC_AD1938
+	tristate
+
 config SND_SOC_AD1939
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 913f2fa..2dd9490 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -1,4 +1,5 @@
 snd-soc-ac97-objs := ac97.o
+snd-soc-ad1938-objs := ad1938.o
 snd-soc-ad1939-objs := ad1939.o
 snd-soc-ad1980-objs := ad1980.o
 snd-soc-ak4535-objs := ak4535.o
@@ -49,6 +50,7 @@ snd-soc-wm9712-objs := wm9712.o
 snd-soc-wm9713-objs := wm9713.o
 
 obj-$(CONFIG_SND_SOC_AC97_CODEC)	+= snd-soc-ac97.o
+obj-$(CONFIG_SND_SOC_AD1938)	+= snd-soc-ad1938.o
 obj-$(CONFIG_SND_SOC_AD1939)	+= snd-soc-ad1939.o
 obj-$(CONFIG_SND_SOC_AD1980)	+= snd-soc-ad1980.o
 obj-$(CONFIG_SND_SOC_AD73311) += snd-soc-ad73311.o
diff --git a/sound/soc/codecs/ad1938.c b/sound/soc/codecs/ad1938.c
new file mode 100644
index 0000000..9aa78e1
--- /dev/null
+++ b/sound/soc/codecs/ad1938.c
@@ -0,0 +1,548 @@
+/*
+ * ad1938.c  --  ALSA Soc AD1938 codec support
+ *
+ * Copyright:	Analog Device Inc.
+ * Author:	Barry Song <Barry.Song@analog.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  Revision history
+ *    4 June 2009   Initial version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+#include <linux/spi/spi.h>
+#include "ad1938.h"
+
+struct snd_soc_device *ad1938_socdev;
+
+/* dac de-emphasis enum control */
+static const char *ad1938_deemp[] = {"flat", "48kHz", "44.1kHz", "32kHz"};
+
+static const struct soc_enum ad1938_enum[] = {
+	SOC_ENUM_SINGLE(AD1938_DAC_CTRL2, 1, 4, ad1938_deemp),
+};
+
+/* AD1938 volume/mute/de-emphasis etc. controls */
+static const struct snd_kcontrol_new ad1938_snd_controls[] = {
+	/* DAC volume control */
+	SOC_SINGLE("DAC L1 Volume", AD1938_DAC_L1_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC R1 Volume", AD1938_DAC_R1_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC L2 Volume", AD1938_DAC_L2_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC R2 Volume", AD1938_DAC_R2_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC L3 Volume", AD1938_DAC_L3_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC R3 Volume", AD1938_DAC_R3_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC L4 Volume", AD1938_DAC_L4_VOL, 0, 0xFF, 1),
+	SOC_SINGLE("DAC R4 Volume", AD1938_DAC_R4_VOL, 0, 0xFF, 1),
+
+	/* DAC mute control */
+	SOC_SINGLE("DAC L1 Switch", AD1938_DAC_CHNL_MUTE, 0, 1, 1),
+	SOC_SINGLE("DAC R1 Switch", AD1938_DAC_CHNL_MUTE, 1, 1, 1),
+	SOC_SINGLE("DAC L2 Switch", AD1938_DAC_CHNL_MUTE, 2, 1, 1),
+	SOC_SINGLE("DAC R2 Switch", AD1938_DAC_CHNL_MUTE, 3, 1, 1),
+	SOC_SINGLE("DAC L3 Switch", AD1938_DAC_CHNL_MUTE, 4, 1, 1),
+	SOC_SINGLE("DAC R3 Switch", AD1938_DAC_CHNL_MUTE, 5, 1, 1),
+	SOC_SINGLE("DAC L4 Switch", AD1938_DAC_CHNL_MUTE, 6, 1, 1),
+	SOC_SINGLE("DAC R4 Switch", AD1938_DAC_CHNL_MUTE, 7, 1, 1),
+
+	/* ADC mute control */
+	SOC_SINGLE("ADC L1 Switch", AD1938_ADC_CTRL0, ADC0_MUTE, 1, 1),
+	SOC_SINGLE("ADC R1 Switch", AD1938_ADC_CTRL0, ADC1_MUTE, 1, 1),
+	SOC_SINGLE("ADC L2 Switch", AD1938_ADC_CTRL0, ADC2_MUTE, 1, 1),
+	SOC_SINGLE("ADC R2 Switch", AD1938_ADC_CTRL0, ADC3_MUTE, 1, 1),
+
+	/* ADC high-pass filter */
+	SOC_SINGLE("ADC High Pass Filter Switch", AD1938_ADC_CTRL0, ADC_HIGHPASS_FILTER, 1, 0),
+
+	/* DAC de-emphasis */
+	SOC_ENUM("Playback Deemphasis", ad1938_enum[0]),
+};
+
+/* add non dapm controls */
+static int ad1938_add_controls(struct snd_soc_codec *codec)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(ad1938_snd_controls); i++) {
+		err = snd_ctl_add(codec->card,
+				snd_soc_cnew(&ad1938_snd_controls[i], codec, NULL));
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+
+/* dac/adc/pll poweron/off functions */
+static int ad1938_dac_powerctrl(struct snd_soc_codec *codec, int cmd)
+{
+	int reg;
+
+	reg = codec->read(codec, AD1938_DAC_CTRL0);
+	if (cmd)
+		reg &= ~DAC_POWERDOWN;
+	else
+		reg |= DAC_POWERDOWN;
+	codec->write(codec, AD1938_DAC_CTRL0, reg);
+
+	return 0;
+
+}
+
+static int ad1938_adc_powerctrl(struct snd_soc_codec *codec, int cmd)
+{
+	int reg;
+
+	reg = codec->read(codec, AD1938_ADC_CTRL0);
+	if (cmd)
+		reg &= ~ADC_POWERDOWN;
+	else
+		reg |= ADC_POWERDOWN;
+	codec->write(codec, AD1938_ADC_CTRL0, reg);
+
+	return 0;
+}
+
+static int ad1938_pll_powerctrl(struct snd_soc_codec *codec, int cmd)
+{
+	int reg;
+
+	reg = codec->read(codec, AD1938_PLL_CLK_CTRL0);
+	if (cmd)
+		reg &= ~PLL_POWERDOWN;
+	else
+		reg |= PLL_POWERDOWN;
+	codec->write(codec, AD1938_PLL_CLK_CTRL0, reg);
+
+	return 0;
+}
+
+/*
+ * DAI ops entries
+ */
+
+static int ad1938_set_pll(struct snd_soc_dai *codec_dai,
+		int pll_id, unsigned int freq_in, unsigned int freq_out)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+
+	if (freq_out)
+		ad1938_pll_powerctrl(codec, 1);
+	else {
+		/* playing while recording, framework will poweroff-poweron pll redundantly */
+		if ((!codec_dai->capture.active) && (!codec_dai->playback.active))
+			ad1938_pll_powerctrl(codec, 0);
+	}
+
+	return 0;
+}
+
+static int ad1938_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	if (!mute)
+		codec->write(codec, AD1938_DAC_CHNL_MUTE, 0);
+	else
+		codec->write(codec, AD1938_DAC_CHNL_MUTE, 0xff);
+
+	return 0;
+}
+
+static int ad1938_tdm_set(struct snd_soc_codec *codec)
+{
+	codec->write(codec, AD1938_DAC_CTRL0, (codec->read(codec, AD1938_DAC_CTRL0) &
+				(~DAC_SERFMT_MASK)) | DAC_SERFMT_TDM);
+	codec->write(codec, AD1938_DAC_CTRL1, 0x84); /* invert bclk, 256bclk/frame, latch in mid */
+	codec->write(codec, AD1938_ADC_CTRL1, 0x43); /* sata delay=1, adc aux mode */
+	codec->write(codec, AD1938_ADC_CTRL2, 0x6F); /* left high, driver on rising edge */
+
+	return 0;
+}
+
+static int ad1938_i2s_set(struct snd_soc_codec *codec)
+{
+	codec->write(codec, AD1938_DAC_CTRL0, (codec->read(codec, AD1938_DAC_CTRL0) &
+				(~DAC_SERFMT_MASK)) | DAC_SERFMT_STEREO);
+	codec->write(codec, AD1938_DAC_CTRL1, 0x30); /* 64bclk/frame, latch in mid, left low */
+	codec->write(codec, AD1938_ADC_CTRL1, 0x3); /* sata delay=1, stereo mode */
+	codec->write(codec, AD1938_ADC_CTRL2, 0x48); /* left low, driver on falling edge */
+
+	return 0;
+}
+
+static int ad1938_set_dai_fmt(struct snd_soc_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_SPORT_TDM:
+		ad1938_tdm_set(codec);
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		ad1938_i2s_set(codec);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ad1938_pcm_prepare(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct snd_soc_dai *codec_dai = codec->dai;
+
+	/* set active */
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		/* If not poweron adc, dac can't work */
+		if (!codec_dai->capture.active)
+			ad1938_adc_powerctrl(codec, 1);
+		ad1938_dac_powerctrl(codec, 1);
+	} else {
+		/* poweron adc */
+		ad1938_adc_powerctrl(codec, 1);
+	}
+
+	return 0;
+}
+
+static int ad1938_hw_params(struct snd_pcm_substream *substream,
+		struct snd_pcm_hw_params *params,
+		struct snd_soc_dai *dai)
+{
+	int word_len = 0, reg = 0;
+
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	/* bit size */
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		word_len = 3;
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		word_len = 1;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+	case SNDRV_PCM_FORMAT_S32_LE:
+		word_len = 0;
+		break;
+	}
+
+	reg = codec->read(codec, AD1938_DAC_CTRL2);
+	reg = (reg & (~DAC_WORD_LEN_MASK)) | word_len;
+	codec->write(codec, AD1938_DAC_CTRL2, reg);
+
+	reg = codec->read(codec, AD1938_ADC_CTRL1);
+	reg = (reg & (~ADC_WORD_LEN_MASK)) | word_len;
+	codec->write(codec, AD1938_DAC_CTRL1, reg);
+
+	return 0;
+}
+
+static void ad1938_pcm_shutdown(struct snd_pcm_substream *substream,
+		struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct snd_soc_dai *codec_dai = codec->dai;
+
+	/* deactivate */
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		/* poweroff dac */
+		ad1938_dac_powerctrl(codec, 0);
+
+		/* after poweroff dac, if adc is not opened, poweroff it too */
+		if (!codec_dai->capture.active)
+			ad1938_adc_powerctrl(codec, 0);
+	} else {
+		/* if dac is still working, can't shutdown adc */
+		if (!codec_dai->playback.active)
+			ad1938_adc_powerctrl(codec, 0);
+	}
+}
+
+/*
+ * interface to read/write ad1938 register
+ */
+
+#define AD1938_SPI_ADDR    0x4
+#define AD1938_SPI_READ    0x1
+#define AD1938_SPI_BUFLEN  3
+
+/*
+ * write to the ad1938 register space
+ */
+
+static int ad1938_reg_write(struct snd_soc_codec *codec, unsigned int reg,
+		unsigned int value)
+{
+	uint8_t buf[AD1938_SPI_BUFLEN];
+	struct spi_transfer t = {
+		.tx_buf = buf,
+		.len = AD1938_SPI_BUFLEN,
+	};
+	struct spi_message m;
+
+	buf[0] = AD1938_SPI_ADDR << 1;
+	buf[1] = reg;
+	buf[2] = value;
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	return spi_sync(codec->control_data, &m);
+}
+
+/*
+ * read from the ad1938 register space
+ */
+
+static unsigned int ad1938_reg_read(struct snd_soc_codec *codec, unsigned int reg)
+{
+	char w_buf[AD1938_SPI_BUFLEN];
+	char r_buf[AD1938_SPI_BUFLEN];
+	int ret;
+
+	struct spi_transfer t = {
+		.tx_buf = w_buf,
+		.rx_buf = r_buf,
+		.len = AD1938_SPI_BUFLEN,
+	};
+	struct spi_message m;
+
+	w_buf[0] = (AD1938_SPI_ADDR << 1) | AD1938_SPI_READ;
+	w_buf[1] = reg;
+	w_buf[2] = 0;
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+	ret = spi_sync(codec->control_data, &m);
+	if (ret == 0)
+		return	r_buf[2];
+	else
+		return -EIO;
+}
+
+static int __devinit ad1938_spi_probe(struct spi_device *spi)
+{
+	spi->dev.power.power_state = PMSG_ON;
+	ad1938_socdev->card->codec->control_data = spi;
+
+	return 0;
+}
+
+static int __devexit ad1938_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+static struct spi_driver ad1938_spi_driver = {
+	.driver = {
+		.name	= "ad1938-spi",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ad1938_spi_probe,
+	.remove		= __devexit_p(ad1938_spi_remove),
+};
+
+static int ad1938_spi_init(void)
+{
+	return spi_register_driver(&ad1938_spi_driver);
+}
+
+static void ad1938_spi_done(void)
+{
+	spi_unregister_driver(&ad1938_spi_driver);
+}
+
+static struct snd_soc_dai_ops ad1938_dai_ops = {
+	.prepare = ad1938_pcm_prepare,
+	.hw_params = ad1938_hw_params,
+	.shutdown = ad1938_pcm_shutdown,
+	.digital_mute = ad1938_mute,
+	.set_pll = ad1938_set_pll,
+	.set_fmt = ad1938_set_dai_fmt,
+};
+
+/* codec DAI instance */
+struct snd_soc_dai ad1938_dai = {
+	.name = "AD1938",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE, },
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 2,
+		.channels_max = 4,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE | SNDRV_PCM_FMTBIT_S24_LE, },
+	.ops = &ad1938_dai_ops,
+};
+EXPORT_SYMBOL_GPL(ad1938_dai);
+
+static int ad1938_soc_probe(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec;
+	int ret = 0;
+
+	/* codec alloc and init */
+	codec = kzalloc(sizeof(struct snd_soc_codec), GFP_KERNEL);
+	if (codec == NULL)
+		return -ENOMEM;
+	mutex_init(&codec->mutex);
+	codec->name = "AD1938";
+	codec->owner = THIS_MODULE;
+	codec->dai = &ad1938_dai;
+	codec->num_dai = 1;
+	codec->write = ad1938_reg_write;
+	codec->read = ad1938_reg_read;
+	socdev->card->codec = codec;
+	INIT_LIST_HEAD(&codec->dapm_widgets);
+	INIT_LIST_HEAD(&codec->dapm_paths);
+
+	ad1938_socdev = socdev;
+
+	/* codec spi interface init */
+	ret = ad1938_spi_init();
+	if (ret < 0) {
+		printk(KERN_ERR "ad1938: failed to init spi interface\n");
+		goto spi_err;
+	}
+
+	/* register pcms */
+	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
+	if (ret < 0) {
+		printk(KERN_ERR "ad1938: failed to create pcms\n");
+		goto pcm_err;
+	}
+
+	ret = snd_soc_init_card(socdev);
+	if (ret < 0) {
+		printk(KERN_ERR "ad1938: failed to register card\n");
+		goto register_err;
+	}
+
+	/* register controls for ad1938 */
+	ad1938_add_controls(codec);
+
+	/* default setting for ad1938 */
+	codec->write(codec, AD1938_DAC_CHNL_MUTE, 0xFF); /* mute all dac channels */
+	codec->write(codec, AD1938_DAC_CTRL2, 0x1A); /* de-emphasis: 48kHz, powedown dac */
+	codec->write(codec, AD1938_DAC_CTRL0, 0x1); /* powerdown dac */
+	codec->write(codec, AD1938_ADC_CTRL0, 0x3); /* high-pass filter enable */
+	codec->write(codec, AD1938_PLL_CLK_CTRL0, 0x9D); /* pll input:mclki/xi */
+	codec->write(codec, AD1938_PLL_CLK_CTRL1, 0x04);
+
+	printk(KERN_INFO "Analog Devices AD1938 codec registered\n");
+	return ret;
+
+register_err:
+	snd_soc_free_pcms(socdev);
+pcm_err:
+	ad1938_spi_done();
+spi_err:
+	kfree(socdev->card->codec);
+	socdev->card->codec = NULL;
+	return ret;
+}
+
+static int ad1938_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	if (codec == NULL)
+		return 0;
+	snd_soc_free_pcms(socdev);
+	kfree(codec);
+	ad1938_spi_done();
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ad1938_soc_suspend(struct platform_device *pdev,
+		pm_message_t state)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	/* poweroff dac/adc/pll */
+	ad1938_dac_powerctrl(codec, 0);
+	ad1938_adc_powerctrl(codec, 0);
+	ad1938_pll_powerctrl(codec, 0);
+
+	return 0;
+}
+
+static int ad1938_soc_resume(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+	struct snd_soc_dai *codec_dai = codec->dai;
+
+	/* playing while recording, framework will poweroff-poweron pll redundantly */
+	if (codec_dai->capture.active || codec_dai->playback.active) {
+		ad1938_pll_powerctrl(codec, 1);
+		ad1938_adc_powerctrl(codec, 1);
+	}
+	if (codec_dai->playback.active)
+		ad1938_adc_powerctrl(codec, 1);
+
+	return 0;
+}
+#else
+#define ad1938_soc_suspend NULL
+#define ad1938_soc_resume NULL
+#endif
+
+struct snd_soc_codec_device soc_codec_dev_ad1938 = {
+	.probe = 	ad1938_soc_probe,
+	.remove = 	ad1938_soc_remove,
+	.suspend =      ad1938_soc_suspend,
+	.resume =       ad1938_soc_resume,
+};
+EXPORT_SYMBOL_GPL(soc_codec_dev_ad1938);
+
+static int __init ad1938_init(void)
+{
+	return snd_soc_register_dai(&ad1938_dai);
+}
+module_init(ad1938_init);
+
+static void __exit ad1938_exit(void)
+{
+	snd_soc_unregister_dai(&ad1938_dai);
+}
+module_exit(ad1938_exit);
+
+MODULE_DESCRIPTION("ASoC ad1938 driver");
+MODULE_AUTHOR("Barry Song ");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ad1938.h b/sound/soc/codecs/ad1938.h
new file mode 100644
index 0000000..c845916
--- /dev/null
+++ b/sound/soc/codecs/ad1938.h
@@ -0,0 +1,68 @@
+/*
+ * File:         sound/soc/codecs/ad1836.h
+ * Based on:
+ * Author:       Barry Song <Barry.Song@analog.com>
+ *
+ * Created:      May 25, 2009
+ * Description:  definitions for AD1938 registers
+ *
+ * Modified:
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
+#ifndef __AD1938_H__
+#define __AD1938_H__
+
+#define AD1938_PLL_CLK_CTRL0    0
+#define PLL_POWERDOWN           0x01
+#define AD1938_PLL_CLK_CTRL1    1
+#define AD1938_DAC_CTRL0        2
+#define DAC_POWERDOWN           0x01
+#define DAC_SERFMT_MASK		0xC0
+#define DAC_SERFMT_STEREO	(0 << 6)
+#define DAC_SERFMT_TDM		(1 << 6)
+#define AD1938_DAC_CTRL1        3
+#define AD1938_DAC_CTRL2        4
+#define DAC_WORD_LEN_MASK	0xC
+#define AD1938_DAC_CHNL_MUTE    5
+#define AD1938_DAC_L1_VOL       6
+#define AD1938_DAC_R1_VOL       7
+#define AD1938_DAC_L2_VOL       8
+#define AD1938_DAC_R2_VOL       9
+#define AD1938_DAC_L3_VOL       10
+#define AD1938_DAC_R3_VOL       11
+#define AD1938_DAC_L4_VOL       12
+#define AD1938_DAC_R4_VOL       13
+#define AD1938_ADC_CTRL0        14
+#define ADC_POWERDOWN           0x01
+#define ADC_HIGHPASS_FILTER	1
+#define ADC0_MUTE 		2
+#define ADC1_MUTE 		3
+#define ADC2_MUTE 		4
+#define ADC3_MUTE 		5
+#define AD1938_ADC_CTRL1        15
+#define ADC_SERFMT_MASK		0x60
+#define ADC_SERFMT_STEREO	(0 << 5)
+#define ADC_SERFMT_AUX		(2 << 5)
+#define ADC_WORD_LEN_MASK	0x3
+#define AD1938_ADC_CTRL2        16
+
+extern struct snd_soc_dai ad1938_dai;
+extern struct snd_soc_codec_device soc_codec_dev_ad1938;
+#endif
-- 
1.5.6.3

