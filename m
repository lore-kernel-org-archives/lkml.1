Return-Path: <linux-kernel-owner+w=401wt.eu-S1761200AbYELKp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761200AbYELKp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbYELKpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:45:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:5104 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYELKpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:45:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=pzxJXzckebaO3rj3OmIl+os5OyWA6K4kHVp3TgAXJk6DjFKHl+TpzqXYiBmlLvQ2J2Qc8yvKLRi/5izKuol3nMpJ/KkkkBWGHQGh0qkEUpCwrzeeL89J13xcos6Qe5HqaAjP5OLwidampCan3aQpb2qq2ckP3gCClyULKdDlJqw=
From: Bryan Wu <cooloney@kernel.org>
To: liam.girdwood@wolfsonmicro.com, linux-kernel@vger.kernel.org
Cc: Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [ASOC]: AD1980 audio codec ASOC driver
Date: Mon, 12 May 2008 18:45:12 +0800
Message-Id: <1210589112-12208-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/codecs/Kconfig  |    4 +
 sound/soc/codecs/Makefile |    2 +
 sound/soc/codecs/ad1980.c |  322 +++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/ad1980.h |   23 ++++
 4 files changed, 351 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/codecs/ad1980.c
 create mode 100644 sound/soc/codecs/ad1980.h

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 3903ab7..62ef183 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -2,6 +2,10 @@ config SND_SOC_AC97_CODEC
 	tristate
 	depends on SND_SOC
 
+config SND_SOC_AD1980
+	tristate
+	depends on SND_SOC
+
 config SND_SOC_WM8731
 	tristate
 	depends on SND_SOC
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 4e1314c..0568d32 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -1,4 +1,5 @@
 snd-soc-ac97-objs := ac97.o
+snd-soc-ad1980-objs := ad1980.o
 snd-soc-wm8731-objs := wm8731.o
 snd-soc-wm8750-objs := wm8750.o
 snd-soc-wm8753-objs := wm8753.o
@@ -8,6 +9,7 @@ snd-soc-cs4270-objs := cs4270.o
 snd-soc-tlv320aic3x-objs := tlv320aic3x.o
 
 obj-$(CONFIG_SND_SOC_AC97_CODEC)	+= snd-soc-ac97.o
+obj-$(CONFIG_SND_SOC_AD1980)	+= snd-soc-ad1980.o
 obj-$(CONFIG_SND_SOC_WM8731)	+= snd-soc-wm8731.o
 obj-$(CONFIG_SND_SOC_WM8750)	+= snd-soc-wm8750.o
 obj-$(CONFIG_SND_SOC_WM8753)	+= snd-soc-wm8753.o
diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
new file mode 100644
index 0000000..dab1904
--- /dev/null
+++ b/sound/soc/codecs/ad1980.c
@@ -0,0 +1,322 @@
+/*
+ * ad1980.c  --  ALSA Soc AD1980 codec support
+ *
+ * Copyright:	Analog Device Inc.
+ * Author:	Roy Huang <roy.huang@analog.com>
+ * 		Cliff Cai <cliff.cai@analog.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  Revision history
+ *    1st July 2007   Initial version.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/ac97_codec.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+
+#include "ad1980.h"
+
+static unsigned int ac97_read(struct snd_soc_codec *codec,
+	unsigned int reg);
+static int ac97_write(struct snd_soc_codec *codec,
+	unsigned int reg, unsigned int val);
+
+/*
+ * AD1980 register cache
+ */
+static const u16 ad1980_reg[] = {
+	0x0090, 0x8000, 0x8000, 0x8000, /* 0 - 6  */
+	0x0000, 0x0000, 0x8008, 0x8008, /* 8 - e  */
+	0x8808, 0x8808, 0x0000, 0x8808, /* 10 - 16 */
+	0x8808, 0x0000, 0x8000, 0x0000, /* 18 - 1e */
+	0x0000, 0x0000, 0x0000, 0x0000, /* 20 - 26 */
+	0x03c7, 0x0000, 0xbb80, 0xbb80, /* 28 - 2e */
+	0xbb80, 0xbb80, 0x0000, 0x8080, /* 30 - 36 */
+	0x8080, 0x2000, 0x0000, 0x0000, /* 38 - 3e */
+	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
+	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
+	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
+	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
+	0x8080, 0x0000, 0x0000, 0x0000, /* 60 - 66 */
+	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
+	0x0000, 0x0000, 0x1001, 0x0000, /* 70 - 76 */
+	0x0000, 0x0000, 0x4144, 0x5370  /* 78 - 7e */
+};
+
+static const char *ad1980_rec_sel[] = {"Mic", "CD", "NC", "AUX", "Line",
+		"Stereo Mix", "Mono Mix", "Phone"};
+
+static const struct soc_enum ad1980_cap_src =
+	SOC_ENUM_DOUBLE(AC97_REC_SEL, 8, 0, 7, ad1980_rec_sel);
+
+static const struct snd_kcontrol_new ad1980_snd_ac97_controls[] = {
+SOC_DOUBLE("Master Playback Volume", AC97_MASTER, 8, 0, 31, 1),
+SOC_SINGLE("Master Playback Switch", AC97_MASTER, 15, 1, 1),
+
+SOC_DOUBLE("Headphone Playback Volume", AC97_HEADPHONE, 8, 0, 31, 1),
+SOC_SINGLE("Headphone Playback Switch", AC97_HEADPHONE, 15, 1, 1),
+
+SOC_DOUBLE("PCM Playback Volume", AC97_PCM, 8, 0, 31, 1),
+SOC_SINGLE("PCM Playback Switch", AC97_PCM, 15, 1, 1),
+
+SOC_DOUBLE("PCM Capture Volume", AC97_REC_GAIN, 8, 0, 31, 0),
+SOC_SINGLE("PCM Capture Switch", AC97_REC_GAIN, 15, 1, 1),
+
+SOC_SINGLE("Mono Playback Volume", AC97_MASTER_MONO, 0, 31, 1),
+SOC_SINGLE("Mono Playback Switch", AC97_MASTER_MONO, 15, 1, 1),
+
+SOC_SINGLE("Phone Capture Volume", AC97_PHONE, 0, 31, 1),
+SOC_SINGLE("Phone Capture Switch", AC97_PHONE, 15, 1, 1),
+
+SOC_SINGLE("Mic Volume", AC97_MIC, 0, 31, 1),
+SOC_SINGLE("Mic Switch", AC97_MIC, 15, 1, 1),
+
+SOC_SINGLE("Stereo Mic Switch", AC97_AD_MISC, 6, 1, 0),
+SOC_DOUBLE("Line HP Swap Switch", AC97_AD_MISC, 10, 5, 1, 0),
+
+SOC_DOUBLE("Surround Playback Volume", AC97_SURROUND_MASTER, 8, 0, 31, 1),
+SOC_DOUBLE("Surround Playback Switch", AC97_SURROUND_MASTER, 15, 7, 1, 1),
+
+SOC_ENUM("Capture Source", ad1980_cap_src),
+
+SOC_SINGLE("Mic Boost Switch", AC97_MIC, 6, 1, 0),
+};
+
+/* add non dapm controls */
+static int ad1980_add_controls(struct snd_soc_codec *codec)
+{
+	int err, i;
+
+	for (i = 0; i < ARRAY_SIZE(ad1980_snd_ac97_controls); i++) {
+		err = snd_ctl_add(codec->card, snd_soc_cnew( \
+				&ad1980_snd_ac97_controls[i], codec, NULL));
+		if (err < 0)
+			return err;
+	}
+	return 0;
+}
+
+static unsigned int ac97_read(struct snd_soc_codec *codec,
+	unsigned int reg)
+{
+	u16 *cache = codec->reg_cache;
+
+	if (reg == AC97_RESET || reg == AC97_INT_PAGING || \
+			reg == AC97_POWERDOWN || reg == AC97_EXTENDED_STATUS  \
+			|| reg == AC97_VENDOR_ID1 || reg == AC97_VENDOR_ID2)
+		return soc_ac97_ops.read(codec->ac97, reg);
+	else {
+		reg = reg >> 1;
+
+		if (reg > (ARRAY_SIZE(ad1980_reg)))
+			return -EINVAL;
+
+		return cache[reg];
+	}
+}
+
+static int ac97_write(struct snd_soc_codec *codec, unsigned int reg,
+	unsigned int val)
+{
+	u16 *cache = codec->reg_cache;
+
+	soc_ac97_ops.write(codec->ac97, reg, val);
+	reg = reg >> 1;
+	if (reg <= (ARRAY_SIZE(ad1980_reg)))
+		cache[reg] = val;
+
+	return 0;
+}
+
+struct snd_soc_codec_dai ad1980_dai = {
+	.name = "AC97",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
+};
+EXPORT_SYMBOL_GPL(ad1980_dai);
+
+static int ad1980_reset(struct snd_soc_codec *codec, int try_warm)
+{
+	u16 retry_cnt = 0;
+
+retry:
+	if (try_warm && soc_ac97_ops.warm_reset) {
+		soc_ac97_ops.warm_reset(codec->ac97);
+		if (ac97_read(codec, AC97_RESET) == 0x0090)
+			return 1;
+	}
+
+	soc_ac97_ops.reset(codec->ac97);
+	/* Set bit 16slot in register 74h, then every slot will has only 16
+	 * bits. This command is sent out in 20bit mode, in which case the
+	 * first nibble of data is eaten by the addr. (Tag is always 16 bit)*/
+	ac97_write(codec, AC97_AD_SERIAL_CFG, 0x9900);
+
+	if (ac97_read(codec, AC97_RESET)  != 0x0090)
+		goto err;
+	return 0;
+
+err:
+	while (retry_cnt++ < 10)
+		goto retry;
+
+	printk(KERN_ERR "AD1980 AC97 reset failed\n");
+	return -EIO;
+}
+
+static int ad1980_soc_suspend(struct platform_device *pdev,
+	pm_message_t state)
+{
+	return 0;
+}
+
+static int ad1980_soc_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int ad1980_soc_probe(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec;
+	int ret = 0;
+	u16 vendor_id2;
+
+	printk(KERN_INFO "AD1980 SoC Audio Codec\n");
+
+	socdev->codec = kzalloc(sizeof(struct snd_soc_codec), GFP_KERNEL);
+	if (socdev->codec == NULL)
+		return -ENOMEM;
+	codec = socdev->codec;
+	mutex_init(&codec->mutex);
+
+	codec->reg_cache =
+		kzalloc(sizeof(u16) * ARRAY_SIZE(ad1980_reg), GFP_KERNEL);
+	if (codec->reg_cache == NULL) {
+		ret = -ENOMEM;
+		goto cache_err;
+	}
+	memcpy(codec->reg_cache, ad1980_reg, sizeof(u16) * \
+			ARRAY_SIZE(ad1980_reg));
+	codec->reg_cache_size = sizeof(u16) * ARRAY_SIZE(ad1980_reg);
+	codec->reg_cache_step = 2;
+	codec->name = "AD1980";
+	codec->owner = THIS_MODULE;
+	codec->dai = &ad1980_dai;
+	codec->num_dai = 1;
+	codec->write = ac97_write;
+	codec->read = ac97_read;
+	INIT_LIST_HEAD(&codec->dapm_widgets);
+	INIT_LIST_HEAD(&codec->dapm_paths);
+
+	ret = snd_soc_new_ac97_codec(codec, &soc_ac97_ops, 0);
+	if (ret < 0) {
+		printk(KERN_ERR "ad1980: failed to register AC97 codec\n");
+		goto codec_err;
+	}
+
+	/* register pcms */
+	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
+	if (ret < 0)
+		goto pcm_err;
+
+
+	ret = ad1980_reset(codec, 0);
+	if (ret < 0) {
+		printk(KERN_ERR "AC97 link error\n");
+		goto reset_err;
+	}
+
+	/* Read out vendor ID to make sure it is ad1980 */
+	if (ac97_read(codec, AC97_VENDOR_ID1) != 0x4144)
+		goto reset_err;
+
+	vendor_id2 = ac97_read(codec, AC97_VENDOR_ID2);
+
+	if (vendor_id2 != 0x5370) {
+		if (vendor_id2 != 0x5374)
+			goto reset_err;
+		else
+			printk(KERN_WARNING "ad1980: "
+				"Found AD1981 - only 2/2 IN/OUT Channels "
+				"supported\n");
+	}
+
+	ac97_write(codec, AC97_MASTER, 0x0000); /* unmute line out volume */
+	ac97_write(codec, AC97_PCM, 0x0000);	/* unmute PCM out volume */
+	ac97_write(codec, AC97_REC_GAIN, 0x0000);/* unmute record volume */
+
+	ad1980_add_controls(codec);
+	ret = snd_soc_register_card(socdev);
+	if (ret < 0) {
+		printk(KERN_ERR "ad1980: failed to register card\n");
+		goto reset_err;
+	}
+
+	return 0;
+
+reset_err:
+	snd_soc_free_pcms(socdev);
+
+pcm_err:
+	snd_soc_free_ac97_codec(codec);
+
+codec_err:
+	kfree(codec->reg_cache);
+
+cache_err:
+	kfree(socdev->codec);
+	socdev->codec = NULL;
+	return ret;
+}
+
+static int ad1980_soc_remove(struct platform_device *pdev)
+{
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->codec;
+
+	if (codec == NULL)
+		return 0;
+
+	snd_soc_dapm_free(socdev);
+	snd_soc_free_pcms(socdev);
+	snd_soc_free_ac97_codec(codec);
+	kfree(codec->reg_cache);
+	kfree(codec);
+	return 0;
+}
+
+struct snd_soc_codec_device soc_codec_dev_ad1980 = {
+	.probe = 	ad1980_soc_probe,
+	.remove = 	ad1980_soc_remove,
+	.suspend =	ad1980_soc_suspend,
+	.resume =	ad1980_soc_resume,
+};
+EXPORT_SYMBOL_GPL(soc_codec_dev_ad1980);
+
+MODULE_DESCRIPTION("ASoC ad1980 driver");
+MODULE_AUTHOR("Roy Huang, Cliff Cai");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/ad1980.h b/sound/soc/codecs/ad1980.h
new file mode 100644
index 0000000..5d4710d
--- /dev/null
+++ b/sound/soc/codecs/ad1980.h
@@ -0,0 +1,23 @@
+/*
+ * ad1980.h  --  ad1980 Soc Audio driver
+ */
+
+#ifndef _AD1980_H
+#define _AD1980_H
+/* Bit definition of Power-Down Control/Status Register */
+#define ADC		0x0001
+#define DAC		0x0002
+#define ANL		0x0004
+#define REF		0x0008
+#define PR0		0x0100
+#define PR1		0x0200
+#define PR2		0x0400
+#define PR3		0x0800
+#define PR4		0x1000
+#define PR5		0x2000
+#define PR6		0x4000
+
+extern struct snd_soc_codec_dai ad1980_dai;
+extern struct snd_soc_codec_device soc_codec_dev_ad1980;
+
+#endif
-- 
1.5.5

