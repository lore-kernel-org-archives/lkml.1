Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZJVK1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZJVK1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 06:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZJVK1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 06:27:05 -0400
Received: from smtp.nokia.com ([192.100.122.230]:47933 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbZJVK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 06:27:00 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 4/4 v2] ASoC: TWL4030: Driver registration via twl4030_codec MFD
Date: Thu, 22 Oct 2009 13:26:48 +0300
Message-Id: <1256207208-25010-5-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1256207208-25010-4-git-send-email-peter.ujfalusi@nokia.com>
References: <1256207208-25010-1-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-2-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-3-git-send-email-peter.ujfalusi@nokia.com>
 <1256207208-25010-4-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 22 Oct 2009 10:26:57.0836 (UTC) FILETIME=[2F13FEC0:01CA5302]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the way how the twl4030 soc codec driver is
loaded/probed.
Use the device probing via tlw4030_codec MFD device.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/Kconfig   |    1 +
 sound/soc/codecs/twl4030.c |  203 +++++++++++++++++++++++++++-----------------
 2 files changed, 127 insertions(+), 77 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index d30fce7..3df3497 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -147,6 +147,7 @@ config SND_SOC_TLV320DAC33
 	tristate

 config SND_SOC_TWL4030
+	select TWL4030_CODEC
 	tristate

 config SND_SOC_UDA134X
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 559e9b2..5c5a4c0 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -120,6 +120,8 @@ static const u8 twl4030_reg[TWL4030_CACHEREGNUM] = {

 /* codec private data */
 struct twl4030_priv {
+	struct snd_soc_codec codec;
+
 	unsigned int bypass_state;
 	unsigned int codec_powered;
 	unsigned int codec_muted;
@@ -183,19 +185,20 @@ static int twl4030_write(struct snd_soc_codec *codec,
 static void twl4030_codec_enable(struct snd_soc_codec *codec, int enable)
 {
 	struct twl4030_priv *twl4030 = codec->private_data;
-	u8 mode;
+	int mode;

 	if (enable == twl4030->codec_powered)
 		return;

-	mode = twl4030_read_reg_cache(codec, TWL4030_REG_CODEC_MODE);
 	if (enable)
-		mode |= TWL4030_CODECPDZ;
+		mode = twl4030_codec_enable_resource(TWL4030_CODEC_RES_POWER);
 	else
-		mode &= ~TWL4030_CODECPDZ;
+		mode = twl4030_codec_disable_resource(TWL4030_CODEC_RES_POWER);

-	twl4030_write(codec, TWL4030_REG_CODEC_MODE, mode);
-	twl4030->codec_powered = enable;
+	if (mode >= 0) {
+		twl4030_write_reg_cache(codec, TWL4030_REG_CODEC_MODE, mode);
+		twl4030->codec_powered = enable;
+	}

 	/* REVISIT: this delay is present in TI sample drivers */
 	/* but there seems to be no TRM requirement for it     */
@@ -219,22 +222,20 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)
 static void twl4030_codec_mute(struct snd_soc_codec *codec, int mute)
 {
 	struct twl4030_priv *twl4030 = codec->private_data;
-	u8 reg_val;
+	int status;

 	if (mute == twl4030->codec_muted)
 		return;

-	if (mute) {
+	if (mute)
 		/* Disable PLL */
-		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
-		reg_val &= ~TWL4030_APLL_EN;
-		twl4030_write(codec, TWL4030_REG_APLL_CTL, reg_val);
-	} else {
+		status = twl4030_codec_disable_resource(TWL4030_CODEC_RES_APLL);
+	else
 		/* Enable PLL */
-		reg_val = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
-		reg_val |= TWL4030_APLL_EN;
-		twl4030_write(codec, TWL4030_REG_APLL_CTL, reg_val);
-	}
+		status = twl4030_codec_enable_resource(TWL4030_CODEC_RES_APLL);
+
+	if (status >= 0)
+		twl4030_write_reg_cache(codec, TWL4030_REG_APLL_CTL, status);

 	twl4030->codec_muted = mute;
 }
@@ -2123,7 +2124,7 @@ struct snd_soc_dai twl4030_dai[] = {
 };
 EXPORT_SYMBOL_GPL(twl4030_dai);

-static int twl4030_suspend(struct platform_device *pdev, pm_message_t state)
+static int twl4030_soc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
 	struct snd_soc_codec *codec = socdev->card->codec;
@@ -2133,7 +2134,7 @@ static int twl4030_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }

-static int twl4030_resume(struct platform_device *pdev)
+static int twl4030_soc_resume(struct platform_device *pdev)
 {
 	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
 	struct snd_soc_codec *codec = socdev->card->codec;
@@ -2143,32 +2144,21 @@ static int twl4030_resume(struct platform_device *pdev)
 	return 0;
 }

-/*
- * initialize the driver
- * register the mixer and dsp interfaces with the kernel
- */
+static struct snd_soc_codec *twl4030_codec;

-static int twl4030_init(struct snd_soc_device *socdev)
+static int twl4030_soc_probe(struct platform_device *pdev)
 {
-	struct snd_soc_codec *codec = socdev->card->codec;
+	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
 	struct twl4030_setup_data *setup = socdev->codec_data;
-	struct twl4030_priv *twl4030 = codec->private_data;
-	int ret = 0;
+	struct snd_soc_codec *codec;
+	struct twl4030_priv *twl4030;
+	int ret;

-	printk(KERN_INFO "TWL4030 Audio Codec init \n");
+	BUG_ON(!twl4030_codec);

-	codec->name = "twl4030";
-	codec->owner = THIS_MODULE;
-	codec->read = twl4030_read_reg_cache;
-	codec->write = twl4030_write;
-	codec->set_bias_level = twl4030_set_bias_level;
-	codec->dai = twl4030_dai;
-	codec->num_dai = ARRAY_SIZE(twl4030_dai),
-	codec->reg_cache_size = sizeof(twl4030_reg);
-	codec->reg_cache = kmemdup(twl4030_reg, sizeof(twl4030_reg),
-					GFP_KERNEL);
-	if (codec->reg_cache == NULL)
-		return -ENOMEM;
+	codec = twl4030_codec;
+	twl4030 = codec->private_data;
+	socdev->card->codec = codec;

 	/* Configuration for headset ramp delay from setup data */
 	if (setup) {
@@ -2190,100 +2180,159 @@ static int twl4030_init(struct snd_soc_device *socdev)
 	/* register pcms */
 	ret = snd_soc_new_pcms(socdev, SNDRV_DEFAULT_IDX1, SNDRV_DEFAULT_STR1);
 	if (ret < 0) {
-		printk(KERN_ERR "twl4030: failed to create pcms\n");
-		goto pcm_err;
+		dev_err(&pdev->dev, "failed to create pcms\n");
+		return ret;
 	}

-	twl4030_init_chip(codec);
-
-	/* power on device */
-	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
-
 	snd_soc_add_controls(codec, twl4030_snd_controls,
 				ARRAY_SIZE(twl4030_snd_controls));
 	twl4030_add_widgets(codec);

 	ret = snd_soc_init_card(socdev);
 	if (ret < 0) {
-		printk(KERN_ERR "twl4030: failed to register card\n");
+		dev_err(&pdev->dev, "failed to register card\n");
 		goto card_err;
 	}

-	return ret;
+	return 0;

 card_err:
 	snd_soc_free_pcms(socdev);
 	snd_soc_dapm_free(socdev);
-pcm_err:
-	kfree(codec->reg_cache);
+
 	return ret;
 }

-static struct snd_soc_device *twl4030_socdev;
-
-static int twl4030_probe(struct platform_device *pdev)
+static int twl4030_soc_remove(struct platform_device *pdev)
 {
 	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
+	struct snd_soc_codec *codec = socdev->card->codec;
+
+	twl4030_set_bias_level(codec, SND_SOC_BIAS_OFF);
+	snd_soc_free_pcms(socdev);
+	snd_soc_dapm_free(socdev);
+	kfree(codec->private_data);
+	kfree(codec);
+
+	return 0;
+}
+
+static int __devinit twl4030_codec_probe(struct platform_device *pdev)
+{
+	struct twl4030_codec_audio_data *pdata = pdev->dev.platform_data;
 	struct snd_soc_codec *codec;
 	struct twl4030_priv *twl4030;
+	int ret;

-	codec = kzalloc(sizeof(struct snd_soc_codec), GFP_KERNEL);
-	if (codec == NULL)
-		return -ENOMEM;
+	if (!pdata || !(pdata->audio_mclk == 19200000 ||
+			pdata->audio_mclk == 26000000 ||
+			pdata->audio_mclk == 38400000)) {
+		dev_err(&pdev->dev, "Invalid platform_data\n");
+		return -EINVAL;
+	}

 	twl4030 = kzalloc(sizeof(struct twl4030_priv), GFP_KERNEL);
 	if (twl4030 == NULL) {
-		kfree(codec);
+		dev_err(&pdev->dev, "Can not allocate memroy\n");
 		return -ENOMEM;
 	}

+	codec = &twl4030->codec;
 	codec->private_data = twl4030;
-	socdev->card->codec = codec;
+	codec->dev = &pdev->dev;
+	twl4030_dai[0].dev = &pdev->dev;
+	twl4030_dai[1].dev = &pdev->dev;
+
 	mutex_init(&codec->mutex);
 	INIT_LIST_HEAD(&codec->dapm_widgets);
 	INIT_LIST_HEAD(&codec->dapm_paths);

-	twl4030_socdev = socdev;
-	twl4030_init(socdev);
+	codec->name = "twl4030";
+	codec->owner = THIS_MODULE;
+	codec->read = twl4030_read_reg_cache;
+	codec->write = twl4030_write;
+	codec->set_bias_level = twl4030_set_bias_level;
+	codec->dai = twl4030_dai;
+	codec->num_dai = ARRAY_SIZE(twl4030_dai),
+	codec->reg_cache_size = sizeof(twl4030_reg);
+	codec->reg_cache = kmemdup(twl4030_reg, sizeof(twl4030_reg),
+					GFP_KERNEL);
+	if (codec->reg_cache == NULL) {
+		ret = -ENOMEM;
+		goto error_cache;
+	}
+
+	platform_set_drvdata(pdev, twl4030);
+	twl4030_codec = codec;
+
+	/* Set the defaults, and power up the codec */
+	twl4030_init_chip(codec);
+	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
+	ret = snd_soc_register_codec(codec);
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to register codec: %d\n", ret);
+		goto error_codec;
+	}
+
+	ret = snd_soc_register_dais(&twl4030_dai[0], ARRAY_SIZE(twl4030_dai));
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to register DAIs: %d\n", ret);
+		snd_soc_unregister_codec(codec);
+		goto error_codec;
+	}

 	return 0;
+
+error_codec:
+	twl4030_power_down(codec);
+	kfree(codec->reg_cache);
+error_cache:
+	kfree(twl4030);
+	return ret;
 }

-static int twl4030_remove(struct platform_device *pdev)
+static int __devexit twl4030_codec_remove(struct platform_device *pdev)
 {
-	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
-	struct snd_soc_codec *codec = socdev->card->codec;
+	struct twl4030_priv *twl4030 = platform_get_drvdata(pdev);

-	printk(KERN_INFO "TWL4030 Audio Codec remove\n");
-	twl4030_set_bias_level(codec, SND_SOC_BIAS_OFF);
-	snd_soc_free_pcms(socdev);
-	snd_soc_dapm_free(socdev);
-	kfree(codec->private_data);
-	kfree(codec);
+	kfree(twl4030);

+	twl4030_codec = NULL;
 	return 0;
 }

-struct snd_soc_codec_device soc_codec_dev_twl4030 = {
-	.probe = twl4030_probe,
-	.remove = twl4030_remove,
-	.suspend = twl4030_suspend,
-	.resume = twl4030_resume,
+MODULE_ALIAS("platform:twl4030_codec_audio");
+
+static struct platform_driver twl4030_codec_driver = {
+	.probe		= twl4030_codec_probe,
+	.remove		= __devexit_p(twl4030_codec_remove),
+	.driver		= {
+		.name	= "twl4030_codec_audio",
+		.owner	= THIS_MODULE,
+	},
 };
-EXPORT_SYMBOL_GPL(soc_codec_dev_twl4030);

 static int __init twl4030_modinit(void)
 {
-	return snd_soc_register_dais(&twl4030_dai[0], ARRAY_SIZE(twl4030_dai));
+	return platform_driver_register(&twl4030_codec_driver);
 }
 module_init(twl4030_modinit);

 static void __exit twl4030_exit(void)
 {
-	snd_soc_unregister_dais(&twl4030_dai[0], ARRAY_SIZE(twl4030_dai));
+	platform_driver_unregister(&twl4030_codec_driver);
 }
 module_exit(twl4030_exit);

+struct snd_soc_codec_device soc_codec_dev_twl4030 = {
+	.probe = twl4030_soc_probe,
+	.remove = twl4030_soc_remove,
+	.suspend = twl4030_soc_suspend,
+	.resume = twl4030_soc_resume,
+};
+EXPORT_SYMBOL_GPL(soc_codec_dev_twl4030);
+
 MODULE_DESCRIPTION("ASoC TWL4030 codec driver");
 MODULE_AUTHOR("Steve Sakoman");
 MODULE_LICENSE("GPL");
--
1.6.5.1

