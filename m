Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYIEKWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYIEKWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbYIEKVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:21:32 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:36516 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYIEKV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:21:29 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59089261"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 8/9] ASoC: Blackfin: board driver for SSM2602 sound chip
Date: Fri,  5 Sep 2008 18:21:41 +0800
Message-Id: <1220610102-7716-9-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/bf5xx-ssm2602.c |  186 ++++++++++++++++++++++++++++++++++++
 1 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/bf5xx-ssm2602.c

diff --git a/sound/soc/blackfin/bf5xx-ssm2602.c b/sound/soc/blackfin/bf5xx-ssm2602.c
new file mode 100644
index 0000000..e15f67f
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ssm2602.c
@@ -0,0 +1,186 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ssm2602.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  board driver for SSM2602 sound chip
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
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/pcm_params.h>
+
+#include <asm/dma.h>
+#include <asm/portmux.h>
+#include <linux/gpio.h>
+#include "../codecs/ssm2602.h"
+#include "bf5xx-sport.h"
+#include "bf5xx-i2s-pcm.h"
+#include "bf5xx-i2s.h"
+
+static struct snd_soc_machine bf5xx_ssm2602;
+
+static int bf5xx_ssm2602_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+
+	pr_debug("%s enter\n", __func__);
+	cpu_dai->private_data = sport_handle;
+	return 0;
+}
+
+static int bf5xx_ssm2602_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->dai->codec_dai;
+	struct snd_soc_dai *cpu_dai = rtd->dai->cpu_dai;
+	unsigned int clk = 0;
+	int ret = 0;
+
+	pr_debug("%s rate %d format %x\n", __func__, params_rate(params),
+		params_format(params));
+	/*
+	 * If you are using a crystal source which frequency is not 12MHz
+	 * then modify the below case statement with frequency of the crystal.
+	 *
+	 * If you are using the SPORT to generate clocking then this is
+	 * where to do it.
+	 */
+
+	switch (params_rate(params)) {
+	case 8000:
+	case 16000:
+	case 48000:
+	case 96000:
+	case 11025:
+	case 22050:
+	case 44100:
+		clk = 12000000;
+		break;
+	}
+
+	/*
+	 * CODEC is master for BCLK and LRC in this configuration.
+	 */
+
+	/* set codec DAI configuration */
+	ret = codec_dai->dai_ops.set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+		SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+	/* set cpu DAI configuration */
+	ret = cpu_dai->dai_ops.set_fmt(cpu_dai, SND_SOC_DAIFMT_I2S |
+		SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+
+	ret = codec_dai->dai_ops.set_sysclk(codec_dai, SSM2602_SYSCLK, clk,
+		SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_ops bf5xx_ssm2602_ops = {
+	.startup = bf5xx_ssm2602_startup,
+	.hw_params = bf5xx_ssm2602_hw_params,
+};
+
+static struct snd_soc_dai_link bf5xx_ssm2602_dai = {
+	.name = "ssm2602",
+	.stream_name = "SSM2602",
+	.cpu_dai = &bf5xx_i2s_dai,
+	.codec_dai = &ssm2602_dai,
+	.ops = &bf5xx_ssm2602_ops,
+};
+
+/*
+ * SSM2602 2 wire address is determined by CSB
+ * state during powerup.
+ *    low  = 0x1a
+ *    high = 0x1b
+ */
+
+static struct ssm2602_setup_data bf5xx_ssm2602_setup = {
+	.i2c_bus = 0,
+	.i2c_address = 0x1b,
+};
+
+static struct snd_soc_machine bf5xx_ssm2602 = {
+	.name = "bf5xx_ssm2602",
+	.dai_link = &bf5xx_ssm2602_dai,
+	.num_links = 1,
+};
+
+static struct snd_soc_device bf5xx_ssm2602_snd_devdata = {
+	.machine = &bf5xx_ssm2602,
+	.platform = &bf5xx_i2s_soc_platform,
+	.codec_dev = &soc_codec_dev_ssm2602,
+	.codec_data = &bf5xx_ssm2602_setup,
+};
+
+static struct platform_device *bf52x_ssm2602_snd_device;
+
+static int __init bf5xx_ssm2602_init(void)
+{
+	int ret;
+
+	pr_debug("%s enter\n", __func__);
+	bf52x_ssm2602_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!bf52x_ssm2602_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(bf52x_ssm2602_snd_device,
+				&bf5xx_ssm2602_snd_devdata);
+	bf5xx_ssm2602_snd_devdata.dev = &bf52x_ssm2602_snd_device->dev;
+	ret = platform_device_add(bf52x_ssm2602_snd_device);
+
+	if (ret)
+		platform_device_put(bf52x_ssm2602_snd_device);
+
+	return ret;
+}
+
+static void __exit bf5xx_ssm2602_exit(void)
+{
+	pr_debug("%s enter\n", __func__);
+	platform_device_unregister(bf52x_ssm2602_snd_device);
+}
+
+module_init(bf5xx_ssm2602_init);
+module_exit(bf5xx_ssm2602_exit);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ALSA SoC SSM2602 BF527-EZKIT");
+MODULE_LICENSE("GPL");
+
-- 
1.5.6
