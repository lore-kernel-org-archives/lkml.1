Return-Path: <linux-kernel-owner+w=401wt.eu-S1758065AbYIDIZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbYIDIZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757530AbYIDIWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:22:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:30867 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbYIDIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:22:04 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59017798"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
Date: Thu,  4 Sep 2008 16:22:06 +0800
Message-Id: <1220516528-20301-8-git-send-email-cooloney@kernel.org>
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
 sound/soc/blackfin/bf5xx-i2s.c |  273 ++++++++++++++++++++++++++++++++++++++++
 sound/soc/blackfin/bf5xx-i2s.h |   14 ++
 2 files changed, 287 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bf5xx-i2s.c
 create mode 100644 sound/soc/blackfin/bf5xx-i2s.h

diff --git a/sound/soc/blackfin/bf5xx-i2s.c b/sound/soc/blackfin/bf5xx-i2s.c
new file mode 100644
index 0000000..2a87fff
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -0,0 +1,273 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-i2s.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Blackfin I2S CPU DAI driver
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/delay.h>
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
+#include "bf5xx-i2s.h"
+
+struct bf5xx_i2s_port {
+	u16 tcr1;
+	u16 rcr1;
+	u16 tcr2;
+	u16 rcr2;
+	unsigned int master;
+	
+};
+static struct bf5xx_i2s_port bf5xx_i2s;
+
+
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
+static int bf5xx_i2s_set_dai_fmt(struct snd_soc_dai *cpu_dai,
+		unsigned int fmt)
+{
+	int ret = 0;
+	
+	/* interface format:support I2S,slave mode */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		ret = -EINVAL;
+		break;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		ret = -EINVAL;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		ret = -EINVAL;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		ret = -EINVAL;
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static int bf5xx_i2s_hw_params(struct snd_pcm_substream *substream,
+				struct snd_pcm_hw_params *params)
+{
+	int ret = 0;
+
+	bf5xx_i2s.tcr2 &= ~0x1f;
+	bf5xx_i2s.rcr2 &= ~0x1f;
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		bf5xx_i2s.tcr2 |= 15;
+		bf5xx_i2s.rcr2 |= 15;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		bf5xx_i2s.tcr2 |= 23;
+		bf5xx_i2s.rcr2 |= 23;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		bf5xx_i2s.tcr2 |= 31;
+		bf5xx_i2s.rcr2 |= 31;
+		break;
+	}
+
+	if (!bf5xx_i2s.master) {
+	/*
+	 * TX and RX are not independent,they are enabled at the same time,
+	 * even if only one side is running.So,we need to configure both of
+	 * them in advance.
+	 *
+	 * CPU DAI format:I2S, slave mode.
+	 */
+		ret = sport_config_rx(sport_handle, RFSR | RCKFE, RSFSE|bf5xx_i2s.rcr2, 0, 0);
+		if (ret) {
+			pr_err("SPORT is busy!\n");
+			return -EBUSY;
+		}
+
+		ret = sport_config_tx(sport_handle, TFSR | TCKFE, TSFSE|bf5xx_i2s.tcr2, 0, 0);
+		if (ret) {
+			pr_err("SPORT is busy!\n");
+			return -EBUSY;
+		}
+
+		bf5xx_i2s.master = 1;
+	}
+	
+	return 0;
+}
+
+static int bf5xx_i2s_probe(struct platform_device *pdev,
+			   struct snd_soc_dai *dai)
+{
+	u16 sport_req[][7] = {
+		{ P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS,
+		  P_SPORT0_DRPRI, P_SPORT0_RSCLK, 0},
+		{ P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS,
+		  P_SPORT1_DRPRI, P_SPORT1_RSCLK, 0},
+	};
+
+	if (peripheral_request_list(&sport_req[sport_num][0], "soc-audio")) {
+		pr_err("Requesting Peripherals failed\n");
+		return -EFAULT;
+	}
+
+	pr_debug("%s enter\n", __func__);
+
+	/* request DMA for SPORT */
+	sport_handle = sport_init(&sport_params[sport_num], 4, \
+			2 * sizeof(u32), NULL);
+	if (!sport_handle) {
+		peripheral_free_list(&sport_req[sport_num][0]);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bf5xx_i2s_suspend(struct platform_device *dev,
+			     struct snd_soc_dai *dai)
+{
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+	if (dai->capture.active)
+		sport_rx_stop(sport);
+	if (dai->playback.active)
+		sport_tx_stop(sport);
+	return 0;
+}
+
+static int bf5xx_i2s_resume(struct platform_device *pdev,
+			    struct snd_soc_dai *dai)
+{
+	int ret;
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+
+	ret = sport_config_rx(sport_handle, RFSR | RCKFE, RSFSE|0x1f, 0, 0);
+	if (ret) {
+		pr_err("SPORT is busy!\n");
+		return -EBUSY;
+	}
+
+	ret = sport_config_tx(sport_handle, TFSR | TCKFE, TSFSE|0x1f, 0, 0);
+	if (ret) {
+		pr_err("SPORT is busy!\n");
+		return -EBUSY;
+	}
+
+	if (dai->capture.active)
+		sport_rx_start(sport);
+	if (dai->playback.active)
+		sport_tx_start(sport);
+	return 0;
+}
+
+#else
+#define bf5xx_i2s_suspend	NULL
+#define bf5xx_i2s_resume	NULL
+#endif
+
+#define BF5XX_I2S_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
+		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 | \
+		SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 | \
+		SNDRV_PCM_RATE_96000)
+
+#define BF5XX_I2S_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE |\
+	SNDRV_PCM_FMTBIT_S32_LE)
+
+struct snd_soc_dai bf5xx_i2s_dai = {
+	.name = "bf5xx-i2s",
+	.id = 0,
+	.type = SND_SOC_DAI_I2S,
+	.probe = bf5xx_i2s_probe,
+	.suspend = bf5xx_i2s_suspend,
+	.resume = bf5xx_i2s_resume,
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = BF5XX_I2S_RATES,
+		.formats = BF5XX_I2S_FORMATS,},
+	.capture = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = BF5XX_I2S_RATES,
+		.formats = BF5XX_I2S_FORMATS,},
+	.ops = {
+		.hw_params = bf5xx_i2s_hw_params,},
+	.dai_ops = {
+		.set_fmt = bf5xx_i2s_set_dai_fmt,
+	},
+};
+EXPORT_SYMBOL_GPL(bf5xx_i2s_dai);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("I2S driver for ADI Blackfin");
+MODULE_LICENSE("GPL");
+
diff --git a/sound/soc/blackfin/bf5xx-i2s.h b/sound/soc/blackfin/bf5xx-i2s.h
new file mode 100644
index 0000000..7107d1a
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s.h
@@ -0,0 +1,14 @@
+/*
+ * linux/sound/arm/bf5xx-i2s.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_I2S_H
+#define _BF5XX_I2S_H
+
+extern struct snd_soc_dai bf5xx_i2s_dai;
+
+#endif
-- 
1.5.6
