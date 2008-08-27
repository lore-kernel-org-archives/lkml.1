Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYH0JkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYH0JkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755302AbYH0JjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:39:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36019 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbYH0JjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:39:21 -0400
X-IronPort-AV: E=Sophos;i="4.32,278,1217822400"; 
   d="scan'208";a="74159089"
From: Bryan Wu <cooloney@kernel.org>
To: perex@perex.cz, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/4] ASOC codec: add support for SSM2602 audio codec in ALSA SoC framework
Date: Wed, 27 Aug 2008 17:39:26 +0800
Message-Id: <1219829968-6431-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 include/linux/i2c-id.h     |    1 +
 sound/soc/codecs/Kconfig   |    3 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/ssm2602.c |  837 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ssm2602.h |  132 +++++++
 5 files changed, 975 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/ssm2602.c
 create mode 100644 sound/soc/codecs/ssm2602.h

diff --git a/include/linux/i2c-id.h b/include/linux/i2c-id.h
index e1b46bc..aeb221b 100644
--- a/include/linux/i2c-id.h
+++ b/include/linux/i2c-id.h
@@ -82,6 +82,7 @@
 #define I2C_DRIVERID_CS4270	94	/* Cirrus Logic 4270 audio codec */
 #define I2C_DRIVERID_M52790 	95      /* Mitsubishi M52790SP/FP AV switch */
 #define I2C_DRIVERID_CS5345	96	/* cs5345 audio processor	*/
+#define I2C_DRIVERID_SSM2602	97	/* BF52xC built in audio codec */
 
 #define I2C_DRIVERID_OV7670 1048	/* Omnivision 7670 camera */
 #define I2C_DRIVERID_AD5252 1049
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 221e1da..67ed3f2 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -15,6 +15,9 @@ config SND_SOC_AD1980
 	tristate
 	depends on SND_SOC
 
+config SND_SOC_SSM2602
+	tristate
+
 config SND_SOC_WM8731
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 65e2a7d..29bcea6 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -1,6 +1,7 @@
 snd-soc-ac97-objs := ac97.o
 snd-soc-ad1980-objs := ad1980.o
 snd-soc-ak4535-objs := ak4535.o
+snd-soc-ssm2602-objs := ssm2602.o
 snd-soc-uda1380-objs := uda1380.o
 snd-soc-wm8510-objs := wm8510.o
 snd-soc-wm8731-objs := wm8731.o
@@ -15,6 +16,7 @@ snd-soc-tlv320aic3x-objs := tlv320aic3x.o
 obj-$(CONFIG_SND_SOC_AC97_CODEC)	+= snd-soc-ac97.o
 obj-$(CONFIG_SND_SOC_AD1980)	+= snd-soc-ad1980.o
 obj-$(CONFIG_SND_SOC_AK4535)	+= snd-soc-ak4535.o
+obj-$(CONFIG_SND_SOC_SSM2602)	+= snd-soc-ssm2602.o
 obj-$(CONFIG_SND_SOC_UDA1380)	+= snd-soc-uda1380.o
 obj-$(CONFIG_SND_SOC_WM8510)	+= snd-soc-wm8510.o
 obj-$(CONFIG_SND_SOC_WM8731)	+= snd-soc-wm8731.o
diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
new file mode 100644
index 0000000..8dc22a1
--- /dev/null
+++ b/sound/soc/codecs/ssm2602.c
@@ -0,0 +1,837 @@
+/*
+ * File:         sound/soc/codecs/ssm2602.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for ssm2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: ssm2602.c 4104 2008-06-06 06:51:48Z cliff $
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
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/initval.h>
+
+#include "ssm2602.h"
+
+#define AUDIO_NAME "ssm2602"
+#define SSM2602_VERSION "0.1"
+
+/*
+ * Debug
+ */
+
+#define SSM2602_DEBUG 0
+
+#ifdef SSM2602_DEBUG
+#define dbg(format, arg...) \
+	printk(KERN_DEBUG AUDIO_NAME ": " format "\n" , ## arg)
+#else
+#define dbg(format, arg...) do {} while (0)
+#endif
+#define err(format, arg...) \
+	printk(KERN_ERR AUDIO_NAME ": " format "\n" , ## arg)
+#define info(format, arg...) \
+	printk(KERN_INFO AUDIO_NAME ": " format "\n" , ## arg)
+#define warn(format, arg...) \
+	printk(KERN_WARNING AUDIO_NAME ": " format "\n" , ## arg)
+
+struct snd_soc_codec_device soc_codec_dev_ssm2602;
+
+/* codec private data */
+struct ssm2602_priv {
+	unsigned int sysclk;
+};
+
+/*
+ * ssm2602 register cache
+ * We can't read the ssm2602 register space when we are
+ * using 2 wire for device control, so we cache them instead.
+ * There is no point in caching the reset register
+ */
+static const u16 ssm2602_reg[SSM2602_CACHEREGNUM] = {
+    0x0017, 0x0017, 0x0079, 0x0079,
+    0x0000, 0x0000, 0x0000, 0x000a,
+    0x0000, 0x0000
+};
+
+/*
+ * read ssm2602 register cache
+ */
+static inline unsigned int ssm2602_read_reg_cache(struct snd_soc_codec *codec,
+	unsigned int reg)
+{
+	u16 *cache = codec->reg_cache;
+	if (reg == SSM2602_RESET)
+		return 0;
+	if (reg >= SSM2602_CACHEREGNUM)
+		return -1;
+	return cache[reg];
+}
+
+/*
+ * write ssm2602 register cache
+ */
+static inline void ssm2602_write_reg_cache(struct snd_soc_codec *codec,
+	u16 reg, unsigned int value)
+{
+	u16 *cache = codec->reg_cache;
+	if (reg >= SSM2602_CACHEREGNUM)
+		return;
+	cache[reg] = value;
+}
+
+/*
+ * write to the ssm2602 register space
+ */
+static int ssm2602_write(struct snd_soc_codec *codec, unsigned int reg,
+	unsigned int value)
+{
+	u8 data[2];
+
+	/* data is
+	 *   D15..D9 ssm2602 register offset
+	 *   D8...D0 register data
+	 */
+	data[0] = (reg << 1) | ((value >> 8) & 0x0001);
+	data[1] = value & 0x00ff;
+
+	ssm2602_write_reg_cache(codec, reg, value);
+	if (codec->hw_write(codec->control_data, data, 2) == 2)
+		return 0;
+	else
+		return -EIO;
+}
+
+#define ssm2602_reset(c)	ssm2602_write(c, SSM2602_RESET, 0)
+/*Appending several "None"s just for OSS mixer use*/
+static const char *ssm2602_input_select[] = {"Line", "Mic", "None", "None", "None",
+		"None", "None", "None"};
+static const char *ssm2602_deemph[] = {"None", "32Khz", "44.1Khz", "48Khz"};
+
+static const struct soc_enum ssm2602_enum[] = {
+	SOC_ENUM_SINGLE(SSM2602_APANA, 2, 2, ssm2602_input_select),
+	SOC_ENUM_SINGLE(SSM2602_APDIGI, 1, 4, ssm2602_deemph),
+};
+
+static const struct snd_kcontrol_new ssm2602_snd_controls[] = {
+
+SOC_DOUBLE_R("Master Playback Volume", SSM2602_LOUT1V, SSM2602_ROUT1V,
+	0, 127, 0),
+SOC_DOUBLE_R("Master Playback ZC Switch", SSM2602_LOUT1V, SSM2602_ROUT1V,
+	7, 1, 0),
+
+SOC_DOUBLE_R("Capture Volume", SSM2602_LINVOL, SSM2602_RINVOL, 0, 31, 0),
+SOC_DOUBLE_R("Capture Switch", SSM2602_LINVOL, SSM2602_RINVOL, 7, 1, 1),
+
+SOC_SINGLE("Mic Boost (+20dB)", SSM2602_APANA, 0, 1, 0),
+SOC_SINGLE("Mic Switch", SSM2602_APANA, 1, 1, 1),
+
+SOC_SINGLE("Sidetone Playback Volume", SSM2602_APANA, 6, 3, 1),
+
+SOC_SINGLE("ADC High Pass Filter Switch", SSM2602_APDIGI, 0, 1, 1),
+SOC_SINGLE("Store DC Offset Switch", SSM2602_APDIGI, 4, 1, 0),
+
+SOC_ENUM("Capture Source", ssm2602_enum[0]),
+
+SOC_ENUM("Playback De-emphasis", ssm2602_enum[1]),
+};
+
+/* add non dapm controls */
+static int ssm2602_add_controls(struct snd_soc_codec *codec)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(ssm2602_snd_controls); i++) {
+		err = snd_ctl_add(codec->card,
+				snd_soc_cnew(&ssm2602_snd_controls[i], codec, NULL));
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Output Mixer */
+static const struct snd_kcontrol_new ssm2602_output_mixer_controls[] = {
+SOC_DAPM_SINGLE("Line Bypass Switch", SSM2602_APANA, 3, 1, 0),
+SOC_DAPM_SINGLE("Mic Sidetone Switch", SSM2602_APANA, 5, 1, 0),
+SOC_DAPM_SINGLE("HiFi Playback Switch", SSM2602_APANA, 4, 1, 0),
+};
+
+/* Input mux */
+static const struct snd_kcontrol_new ssm2602_input_mux_controls =
+SOC_DAPM_ENUM("Input Select", ssm2602_enum[0]);
+
+static const struct snd_soc_dapm_widget ssm2602_dapm_widgets[] = {
+SND_SOC_DAPM_MIXER("Output Mixer", SSM2602_PWR, 4, 1,
+	&ssm2602_output_mixer_controls[0],
+	ARRAY_SIZE(ssm2602_output_mixer_controls)),
+SND_SOC_DAPM_DAC("DAC", "HiFi Playback", SSM2602_PWR, 3, 1),
+SND_SOC_DAPM_OUTPUT("LOUT"),
+SND_SOC_DAPM_OUTPUT("LHPOUT"),
+SND_SOC_DAPM_OUTPUT("ROUT"),
+SND_SOC_DAPM_OUTPUT("RHPOUT"),
+SND_SOC_DAPM_ADC("ADC", "HiFi Capture", SSM2602_PWR, 2, 1),
+SND_SOC_DAPM_MUX("Input Mux", SND_SOC_NOPM, 0, 0, &ssm2602_input_mux_controls),
+SND_SOC_DAPM_PGA("Line Input", SSM2602_PWR, 0, 1, NULL, 0),
+SND_SOC_DAPM_MICBIAS("Mic Bias", SSM2602_PWR, 1, 1),
+SND_SOC_DAPM_INPUT("MICIN"),
+SND_SOC_DAPM_INPUT("RLINEIN"),
+SND_SOC_DAPM_INPUT("LLINEIN"),
+};
+
+static const char *intercon[][3] = {
+	/* output mixer */
+	{"Output Mixer", "Line Bypass Switch", "Line Input"},
+	{"Output Mixer", "HiFi Playback Switch", "DAC"},
+	{"Output Mixer", "Mic Sidetone Switch", "Mic Bias"},
+
+	/* outputs */
+	{"RHPOUT", NULL, "Output Mixer"},
+	{"ROUT", NULL, "Output Mixer"},
+	{"LHPOUT", NULL, "Output Mixer"},
+	{"LOUT", NULL, "Output Mixer"},
+
+	/* input mux */
+	{"Input Mux", "Line", "Line Input"},
+	{"Input Mux", "Mic", "Mic Bias"},
+	{"ADC", NULL, "Input Mux"},
+
+	/* inputs */
+	{"Line Input", NULL, "LLINEIN"},
+	{"Line Input", NULL, "RLINEIN"},
+	{"Mic Bias", NULL, "MICIN"},
+
+	/* terminator */
+	{NULL, NULL, NULL},
+};
+
+static int ssm2602_add_widgets(struct snd_soc_codec *codec)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ssm2602_dapm_widgets); i++)
+		snd_soc_dapm_new_control(codec, &ssm2602_dapm_widgets[i]);
+	/* set up audio path interconnects */
+	for (i = 0; intercon[i][0] != NULL; i++) {
+		snd_soc_dapm_connect_input(codec, intercon[i][0],
+			intercon[i][1], intercon[i][2]);
+	}
+
+	snd_soc_dapm_new_widgets(codec);
+	return 0;
+}
+
+struct _coeff_div {
+	u32 mclk;
+	u32 rate;
+	u16 fs;
+	u8 sr:4;
+	u8 bosr:1;
+	u8 usb:1;
+};
+
+/* codec mclk clock divider coefficients */
+static const struct _coeff_div coeff_div[] = {
+	/* 48k */
+	{12288000, 48000, 256, 0x0, 0x0, 0x0},
+	{18432000, 48000, 384, 0x0, 0x1, 0x0},
+	{12000000, 48000, 250, 0x0, 0x0, 0x1},
+
+	/* 32k */
+	{12288000, 32000, 384, 0x6, 0x0, 0x0},
+	{18432000, 32000, 576, 0x6, 0x1, 0x0},
+	{12000000, 32000, 375, 0x6, 0x0, 0x1},
+
+	/* 8k */
+	{12288000, 8000, 1536, 0x3, 0x0, 0x0},
+	{18432000, 8000, 2304, 0x3, 0x1, 0x0},
+	{11289600, 8000, 1408, 0xb, 0x0, 0x0},
+	{16934400, 8000, 2112, 0xb, 0x1, 0x0},
+	{12000000, 8000, 1500, 0x3, 0x0, 0x1},
+
+	/* 96k */
+	{12288000, 96000, 128, 0x7, 0x0, 0x0},
+	{18432000, 96000, 192, 0x7, 0x1, 0x0},
+	{12000000, 96000, 125, 0x7, 0x0, 0x1},
+
+	/* 44.1k */
+	{11289600, 44100, 256, 0x8, 0x0, 0x0},
+	{16934400, 44100, 384, 0x8, 0x1, 0x0},
+	{12000000, 44100, 272, 0x8, 0x1, 0x1},
+
+	/* 88.2k */
+	{11289600, 88200, 128, 0xf, 0x0, 0x0},
+	{16934400, 88200, 192, 0xf, 0x1, 0x0},
+	{12000000, 88200, 136, 0xf, 0x1, 0x1},
+};
+
+static inline int get_coeff(int mclk, int rate)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(coeff_div); i++) {
+		if (coeff_div[i].rate == rate && coeff_div[i].mclk == mclk)
+			return i;
+	}
+	return 0;
+}
+
+static int ssm2602_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->codec;
+	struct ssm2602_priv *ssm2602 = codec->private_data;
+	u16 iface = ssm2602_read_reg_cache(codec, SSM2602_IFACE) & 0xfff3;
+	int i = get_coeff(ssm2602->sysclk, params_rate(params));
+	u16 srate = (coeff_div[i].sr << 2) |
+		(coeff_div[i].bosr << 1) | coeff_div[i].usb;
+
+	ssm2602_write(codec, SSM2602_ACTIVE, 0);
+	ssm2602_write(codec, SSM2602_SRATE, srate);
+
+	/* bit size */
+	switch (params_format(params)) {
+	case SNDRV_PCM_FORMAT_S16_LE:
+		break;
+	case SNDRV_PCM_FORMAT_S20_3LE:
+		iface |= 0x0004;
+		break;
+	case SNDRV_PCM_FORMAT_S24_LE:
+		iface |= 0x0008;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		iface |= 0x000c;
+		break;
+	}
+	ssm2602_write(codec, SSM2602_IFACE, iface);
+	ssm2602_write(codec, SSM2602_ACTIVE, ACTIVATE_CODEC);
+	return 0;
+}
+
+static int ssm2602_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->codec;
+	/* set active */
+	ssm2602_write(codec, SSM2602_ACTIVE, ACTIVATE_CODEC);
+
+	return 0;
+}
+
+static void ssm2602_shutdown(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_device *socdev = rtd->socdev;
+	struct snd_soc_codec *codec = socdev->codec;
+	/* deactivate */
+	if (!codec->active) {
+		udelay(50);
+		ssm2602_write(codec, SSM2602_ACTIVE, 0);
+	}
+}
+
+static int ssm2602_mute(struct snd_soc_codec_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	u16 mute_reg = ssm2602_read_reg_cache(codec, SSM2602_APDIGI) & 0xfff7;
+	if (mute)
+		ssm2602_write(codec, SSM2602_APDIGI, mute_reg | ENABLE_DAC_MUTE);
+	else
+		ssm2602_write(codec, SSM2602_APDIGI, mute_reg);
+	return 0;
+}
+
+static int ssm2602_set_dai_sysclk(struct snd_soc_codec_dai *codec_dai,
+		int clk_id, unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct ssm2602_priv *ssm2602 = codec->private_data;
+	switch (freq) {
+	case 11289600:
+	case 12000000:
+	case 12288000:
+	case 16934400:
+	case 18432000:
+		ssm2602->sysclk = freq;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+
+static int ssm2602_set_dai_fmt(struct snd_soc_codec_dai *codec_dai,
+		unsigned int fmt)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	u16 iface = 0;
+
+	/* set master/slave audio interface */
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBM_CFM:
+		iface |= 0x0040;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFS:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* interface format */
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		iface |= 0x0002;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		iface |= 0x0001;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		iface |= 0x0003;
+		break;
+	case SND_SOC_DAIFMT_DSP_B:
+		iface |= 0x0013;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* clock inversion */
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		break;
+	case SND_SOC_DAIFMT_IB_IF:
+		iface |= 0x0090;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		iface |= 0x0080;
+		break;
+	case SND_SOC_DAIFMT_NB_IF:
+		iface |= 0x0010;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* set iface */
+	ssm2602_write(codec, SSM2602_IFACE, iface);
+	return 0;
+}
+
+static int ssm2602_dapm_event(struct snd_soc_codec *codec, int event)
+{
+	u16 reg = ssm2602_read_reg_cache(codec, SSM2602_PWR) & 0xff7f;
+
+	switch (event) {
+	case SNDRV_CTL_POWER_D0: /* full On */
+		/* vref/mid, osc on, dac unmute */
+		ssm2602_write(codec, SSM2602_PWR, 0);
+		break;
+	case SNDRV_CTL_POWER_D1: /* partial On */
+	case SNDRV_CTL_POWER_D2: /* partial On */
+		break;
+	case SNDRV_CTL_POWER_D3hot: /* Off, with power */
+		/* everything off except vref/vmid, */
+		ssm2602_write(codec, SSM2602_PWR, reg | CLK_OUT_PDN);
+		break;
+	case SNDRV_CTL_POWER_D3cold: /* Off, without power */
+		/* everything off, dac mute, inactive */
+		ssm2602_write(codec, SSM2602_ACTIVE, 0);
+		ssm2602_write(codec, SSM2602_PWR, 0xffff);
+		break;
+	}
+	codec->dapm_state = event;
+	return 0;
+}
+
+#define SSM2602_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
+		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 |\
+		SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |\
+		SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200 |\
+		SNDRV_PCM_RATE_96000)
+
+struct snd_soc_codec_dai ssm2602_dai = {
+	.name = "SSM2602",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SSM2602_RATES,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SSM2602_RATES,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+	.ops = {
+		.prepare = ssm2602_pcm_prepare,
+		.hw_params = ssm2602_hw_params,
+		.shutdown = ssm2602_shutdown,
+	},
+	.dai_ops = {
+		.digital_mute = ssm2602_mute,
+		.set_sysclk = ssm2602_set_dai_sysclk,
+		.set_fmt = ssm2602_set_dai_fmt,
+	}
+};
+EXPORT_SYMBOL_GPL(ssm2602_dai);
+
+static int ssm2602_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->codec;
+
+	ssm2602_write(codec, SSM2602_ACTIVE, 0);
+	ssm2602_dapm_event(codec, SNDRV_CTL_POWER_D3cold);
+	return 0;
+}
+
+static int ssm2602_resume(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->codec;
+	int i;
+	u8 data[2];
+	u16 *cache = codec->reg_cache;
+
+	/* Sync reg_cache with the hardware */
+	for (i = 0; i < ARRAY_SIZE(ssm2602_reg); i++) {
+		data[0] = (i << 1) | ((cache[i] >> 8) & 0x0001);
+		data[1] = cache[i] & 0x00ff;
+		codec->hw_write(codec->control_data, data, 2);
+	}
+	ssm2602_dapm_event(codec, SNDRV_CTL_POWER_D3hot);
+	ssm2602_dapm_event(codec, codec->suspend_dapm_state);
+	return 0;
+}
+
+/*
+ * initialise the ssm2602 driver
+ * register the mixer and dsp interfaces with the kernel
+ */
+static int ssm2602_init(struct snd_soc_device *socdev)
+{
+	struct snd_soc_codec *codec = socdev->codec;
+	int reg, ret = 0;
+
+	codec->name = "SSM2602";
+	codec->owner = THIS_MODULE;
+	codec->read = ssm2602_read_reg_cache;
+	codec->write = ssm2602_write;
+	codec->dapm_event = ssm2602_dapm_event;
+	codec->dai = &ssm2602_dai;
+	codec->num_dai = 1;
+	codec->reg_cache_size = sizeof(ssm2602_reg);
+	codec->reg_cache = kmemdup(ssm2602_reg, sizeof(ssm2602_reg), GFP_KERNEL);
+	if (codec->reg_cache == NULL)
+		return -ENOMEM;
+
+	ssm2602_reset(codec);
+
+	/* register pcms */
+	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
+	if (ret < 0) {
+		printk(KERN_ERR "ssm2602: failed to create pcms\n");
+		goto pcm_err;
+	}
+	/*power on device*/
+	ssm2602_write(codec, SSM2602_ACTIVE, 0);
+	/* set the update bits */
+	reg = ssm2602_read_reg_cache(codec, SSM2602_LINVOL);
+	ssm2602_write(codec, SSM2602_LINVOL, reg | LRIN_BOTH);
+	reg = ssm2602_read_reg_cache(codec, SSM2602_RINVOL);
+	ssm2602_write(codec, SSM2602_RINVOL, reg | RLIN_BOTH);
+	reg = ssm2602_read_reg_cache(codec, SSM2602_LOUT1V);
+	ssm2602_write(codec, SSM2602_LOUT1V, reg | LRHP_BOTH);
+	reg = ssm2602_read_reg_cache(codec, SSM2602_ROUT1V);
+	ssm2602_write(codec, SSM2602_ROUT1V, reg | RLHP_BOTH);
+	/*select Line in as default input*/
+	ssm2602_write(codec, SSM2602_APANA, ENABLE_MIC_BOOST2 | SELECT_DAC | ENABLE_MIC_BOOST);
+	ssm2602_write(codec, SSM2602_PWR, 0);
+
+	ssm2602_add_controls(codec);
+	ssm2602_add_widgets(codec);
+	ret = snd_soc_register_card(socdev);
+	if (ret < 0) {
+		printk(KERN_ERR "ssm2602: failed to register card\n");
+		goto card_err;
+	}
+
+	return ret;
+
+card_err:
+	snd_soc_free_pcms(socdev);
+	snd_soc_dapm_free(socdev);
+pcm_err:
+	kfree(codec->reg_cache);
+	return ret;
+}
+
+static struct snd_soc_device *ssm2602_socdev;
+
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE) && !defined(CONFIG_SND_SOC_SSM2602_SPI)
+
+/*
+ * ssm2602 2 wire address is determined by GPIO5
+ * state during powerup.
+ *    low  = 0x1a
+ *    high = 0x1b
+ */
+static unsigned short normal_i2c[] = { 0, I2C_CLIENT_END };
+
+/* Magic definition of all other variables and things */
+I2C_CLIENT_INSMOD;
+
+static struct i2c_driver ssm2602_i2c_driver;
+static struct i2c_client client_template;
+
+/* If the i2c layer weren't so broken, we could pass this kind of data
+   around */
+
+static int ssm2602_codec_probe(struct i2c_adapter *adap, int addr, int kind)
+{
+	struct snd_soc_device *socdev = ssm2602_socdev;
+	struct ssm2602_setup_data *setup = socdev->codec_data;
+	struct snd_soc_codec *codec = socdev->codec;
+	struct i2c_client *i2c;
+	int ret;
+
+	if (addr != setup->i2c_address)
+		return -ENODEV;
+
+	client_template.adapter = adap;
+	client_template.addr = addr;
+
+	i2c = kmemdup(&client_template, sizeof(client_template), GFP_KERNEL);
+	if (i2c == NULL) {
+		kfree(codec);
+		return -ENOMEM;
+	}
+	i2c_set_clientdata(i2c, codec);
+	codec->control_data = i2c;
+
+	ret = i2c_attach_client(i2c);
+	if (ret < 0) {
+		err("failed to attach codec at addr %x\n", addr);
+		goto err;
+	}
+
+	ret = ssm2602_init(socdev);
+	if (ret < 0) {
+		err("failed to initialise ssm2602\n");
+		goto err;
+	}
+	return ret;
+
+err:
+	kfree(codec);
+	kfree(i2c);
+	return ret;
+}
+
+static int ssm2602_i2c_detach(struct i2c_client *client)
+{
+	struct snd_soc_codec *codec = i2c_get_clientdata(client);
+	i2c_detach_client(client);
+	kfree(codec->reg_cache);
+	kfree(client);
+	return 0;
+}
+
+static int ssm2602_i2c_attach(struct i2c_adapter *adap)
+{
+	return i2c_probe(adap, &addr_data, ssm2602_codec_probe);
+}
+
+/* corgi i2c codec control layer */
+static struct i2c_driver ssm2602_i2c_driver = {
+	.driver = {
+		.name = "SSM2602 I2C Codec",
+		.owner = THIS_MODULE,
+	},
+	.id =             I2C_DRIVERID_SSM2602,
+	.attach_adapter = ssm2602_i2c_attach,
+	.detach_client =  ssm2602_i2c_detach,
+	.command =        NULL,
+};
+
+static struct i2c_client client_template = {
+	.name =   "SSM2602",
+	.driver = &ssm2602_i2c_driver,
+};
+#endif
+
+#if defined(CONFIG_SPI_MASTER) && defined(CONFIG_SND_SOC_SSM2602_SPI)
+static int __devinit ssm2602_spi_probe(struct spi_device *spi)
+{
+	struct snd_soc_device *socdev = ssm2602_socdev;
+	struct snd_soc_codec *codec = socdev->codec;
+	int ret;
+
+	codec->control_data = spi;
+
+	ret = ssm2602_init(socdev);
+	if (ret < 0)
+		err("failed to initialise ssm2602\n");
+
+	return ret;
+}
+
+static int __devexit ssm2602_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+static struct spi_driver ssm2602_spi_driver = {
+	.driver = {
+		.name	= "ssm2602",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ssm2602_spi_probe,
+	.remove		= __devexit_p(ssm2602_spi_remove),
+};
+
+static int ssm2602_spi_write(struct spi_device *spi, const char *data, int len)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+	u16 msg[2];
+
+	if (len <= 0)
+		return 0;
+
+	msg[0] = (data[0] << 8) + data[1];
+
+	spi_message_init(&m);
+	memset(&t, 0, (sizeof t));
+
+	t.tx_buf = &msg[0];
+	t.len = len;
+
+	spi_message_add_tail(&t, &m);
+	spi_sync(spi, &m);
+
+	return len;
+}
+#endif /* CONFIG_SPI_MASTER */
+
+static int ssm2602_probe(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct ssm2602_setup_data *setup;
+	struct snd_soc_codec *codec;
+	struct ssm2602_priv *ssm2602;
+	int ret = 0;
+
+	printk(KERN_INFO "ssm2602 Audio Codec %s", SSM2602_VERSION);
+
+	setup = socdev->codec_data;
+	codec = kzalloc(sizeof(struct snd_soc_codec), GFP_KERNEL);
+	if (codec == NULL)
+		return -ENOMEM;
+
+	ssm2602 = kzalloc(sizeof(struct ssm2602_priv), GFP_KERNEL);
+	if (ssm2602 == NULL) {
+		kfree(codec);
+		return -ENOMEM;
+	}
+
+	codec->private_data = ssm2602;
+	socdev->codec = codec;
+	mutex_init(&codec->mutex);
+	INIT_LIST_HEAD(&codec->dapm_widgets);
+	INIT_LIST_HEAD(&codec->dapm_paths);
+
+	ssm2602_socdev = socdev;
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE) && !defined(CONFIG_SND_SOC_SSM2602_SPI)
+	if (setup->i2c_address) {
+		normal_i2c[0] = setup->i2c_address;
+		codec->hw_write = (hw_write_t)i2c_master_send;
+		ret = i2c_add_driver(&ssm2602_i2c_driver);
+		if (ret != 0)
+			printk(KERN_ERR "can't add i2c driver");
+	}
+#elif defined(CONFIG_SPI_MASTER) && defined(CONFIG_SND_SOC_SSM2602_SPI)
+	codec->hw_write = (hw_write_t)ssm2602_spi_write;
+	ret = spi_register_driver(&ssm2602_spi_driver);
+	if (ret != 0)
+		printk(KERN_ERR "can't add spi driver");
+#else
+	/* Add other interfaces here */
+
+#endif
+	return ret;
+}
+
+/* power down chip */
+static int ssm2602_remove(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->codec;
+
+	if (codec->control_data)
+		ssm2602_dapm_event(codec, SNDRV_CTL_POWER_D3cold);
+
+	snd_soc_free_pcms(socdev);
+	snd_soc_dapm_free(socdev);
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE) && !defined(CONFIG_SND_SOC_SSM2602_SPI)
+	i2c_del_driver(&ssm2602_i2c_driver);
+#elif defined(CONFIG_SPI_MASTER) && defined(CONFIG_SND_SOC_SSM2602_SPI)
+	spi_unregister_driver(&ssm2602_spi_driver);
+#endif
+	kfree(codec->private_data);
+	kfree(codec);
+
+	return 0;
+}
+
+struct snd_soc_codec_device soc_codec_dev_ssm2602 = {
+	.probe = 	ssm2602_probe,
+	.remove = 	ssm2602_remove,
+	.suspend = 	ssm2602_suspend,
+	.resume =	ssm2602_resume,
+};
+EXPORT_SYMBOL_GPL(soc_codec_dev_ssm2602);
+
+MODULE_DESCRIPTION("ASoC ssm2602 driver");
+MODULE_AUTHOR("Cliff Cai");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ssm2602.h b/sound/soc/codecs/ssm2602.h
new file mode 100644
index 0000000..f7064a7
--- /dev/null
+++ b/sound/soc/codecs/ssm2602.h
@@ -0,0 +1,132 @@
+/*
+ * File:         sound/soc/codecs/ssm2602.h
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: ssm2602.c 4104 2008-06-06 06:51:48Z cliff $
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
+#ifndef _SSM2602_H
+#define _SSM2602_H
+
+/* SSM2602 Codec Register definitions */
+
+#define SSM2602_LINVOL   0x00
+#define SSM2602_RINVOL   0x01
+#define SSM2602_LOUT1V   0x02
+#define SSM2602_ROUT1V   0x03
+#define SSM2602_APANA    0x04
+#define SSM2602_APDIGI   0x05
+#define SSM2602_PWR      0x06
+#define SSM2602_IFACE    0x07
+#define SSM2602_SRATE    0x08
+#define SSM2602_ACTIVE   0x09
+#define SSM2602_RESET	 0x0f
+
+/*SSM2602 Codec Register Field definitions
+ *(Mask value to extract the corresponding Register field)
+ */
+
+/*Left ADC Volume Control (SSM2602_REG_LEFT_ADC_VOL)*/
+#define     LIN_VOL                0x01F   /* Left Channel PGA Volume control                      */
+#define     LIN_ENABLE_MUTE        0x080   /* Left Channel Input Mute                              */
+#define     LRIN_BOTH              0x100   /* Left Channel Line Input Volume update                */
+
+/*Right ADC Volume Control (SSM2602_REG_RIGHT_ADC_VOL)*/
+#define     RIN_VOL                0x01F   /* Right Channel PGA Volume control                     */
+#define     RIN_ENABLE_MUTE        0x080   /* Right Channel Input Mute                             */
+#define     RLIN_BOTH              0x100   /* Right Channel Line Input Volume update               */
+
+/*Left DAC Volume Control (SSM2602_REG_LEFT_DAC_VOL)*/
+#define     LHP_VOL                0x07F   /* Left Channel Headphone volume control                */
+#define     ENABLE_LZC             0x080   /* Left Channel Zero cross detect enable                */
+#define     LRHP_BOTH              0x100   /* Left Channel Headphone volume update                 */
+
+/*Right DAC Volume Control (SSM2602_REG_RIGHT_DAC_VOL)*/
+#define     RHP_VOL                0x07F   /* Right Channel Headphone volume control               */
+#define     ENABLE_RZC             0x080   /* Right Channel Zero cross detect enable               */
+#define     RLHP_BOTH              0x100   /* Right Channel Headphone volume update                */
+
+/*Analogue Audio Path Control (SSM2602_REG_ANALOGUE_PATH)*/
+#define     ENABLE_MIC_BOOST       0x001   /* Primary Microphone Amplifier gain booster control    */
+#define     ENABLE_MIC_MUTE        0x002   /* Microphone Mute Control                              */
+#define     ADC_IN_SELECT          0x004   /* Microphone/Line IN select to ADC (1=MIC, 0=Line In)  */
+#define     ENABLE_BYPASS          0x008   /* Line input bypass to line output                     */
+#define     SELECT_DAC             0x010   /* Select DAC (1=Select DAC, 0=Don't Select DAC)        */
+#define     ENABLE_SIDETONE        0x020   /* Enable/Disable Side Tone                             */
+#define     SIDETONE_ATTN          0x0C0   /* Side Tone Attenuation                                */
+#define     ENABLE_MIC_BOOST2      0x100   /* Secondary Microphone Amplifier gain booster control  */
+
+/*Digital Audio Path Control (SSM2602_REG_DIGITAL_PATH)*/
+#define     ENABLE_ADC_HPF         0x001   /* Enable/Disable ADC Highpass Filter                   */
+#define     DE_EMPHASIS            0x006   /* De-Emphasis Control                                  */
+#define     ENABLE_DAC_MUTE        0x008   /* DAC Mute Control                                     */
+#define     STORE_OFFSET           0x010   /* Store/Clear DC offset when HPF is disabled           */
+
+/*Power Down Control (SSM2602_REG_POWER)
+ *(1=Enable PowerDown, 0=Disable PowerDown)
+ */
+#define     LINE_IN_PDN            0x001   /* Line Input Power Down                                */
+#define     MIC_PDN                0x002   /* Microphone Input & Bias Power Down                   */
+#define     ADC_PDN                0x004   /* ADC Power Down                                       */
+#define     DAC_PDN                0x008   /* DAC Power Down                                       */
+#define     OUT_PDN                0x010   /* Outputs Power Down                                   */
+#define     OSC_PDN                0x020   /* Oscillator Power Down                                */
+#define     CLK_OUT_PDN            0x040   /* CLKOUT Power Down                                    */
+#define     POWER_OFF              0x080   /* POWEROFF Mode                                        */
+
+/*Digital Audio Interface Format (SSM2602_REG_DIGITAL_IFACE)*/
+#define     IFACE_FORMAT           0x003   /* Digital Audio input format control                   */
+#define     AUDIO_DATA_LEN         0x00C   /* Audio Data word length control                       */
+#define     DAC_LR_POLARITY        0x010   /* Polarity Control for clocks in RJ,LJ and I2S modes   */
+#define     DAC_LR_SWAP            0x020   /* Swap DAC data control                                */
+#define     ENABLE_MASTER          0x040   /* Enable/Disable Master Mode                           */
+#define     BCLK_INVERT            0x080   /* Bit Clock Inversion control                          */
+
+/*Sampling Control (SSM2602_REG_SAMPLING_CTRL)*/
+#define     ENABLE_USB_MODE        0x001   /* Enable/Disable USB Mode                              */
+#define     BOS_RATE               0x002   /* Base Over-Sampling rate                              */
+#define     SAMPLE_RATE            0x03C   /* Clock setting condition (Sampling rate control)      */
+#define     CORECLK_DIV2           0x040   /* Core Clock divider select                            */
+#define     CLKOUT_DIV2            0x080   /* Clock Out divider select                             */
+
+/*Active Control (SSM2602_REG_ACTIVE_CTRL)*/
+#define     ACTIVATE_CODEC         0x001   /* Activate Codec Digital Audio Interface               */
+
+/*********************************************************************/
+
+#define SSM2602_CACHEREGNUM 	10
+
+#define SSM2602_SYSCLK	0
+#define SSM2602_DAI		0
+
+struct ssm2602_setup_data {
+	unsigned short i2c_address;
+};
+
+extern struct snd_soc_codec_dai ssm2602_dai;
+extern struct snd_soc_codec_device soc_codec_dev_ssm2602;
+
+#endif
-- 
1.5.6
