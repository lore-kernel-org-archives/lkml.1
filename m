Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZJSMmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZJSMmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbZJSMml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:42:41 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31909 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZJSMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:42:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: sameo@linux.intel.com, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 4/4] ASoC: TWL4030: Driver registration via twl4030_codec MFD
Date: Mon, 19 Oct 2009 15:42:20 +0300
Message-Id: <1255956140-4829-5-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255956140-4829-4-git-send-email-peter.ujfalusi@nokia.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-3-git-send-email-peter.ujfalusi@nokia.com>
 <1255956140-4829-4-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 19 Oct 2009 12:42:26.0972 (UTC) FILETIME=[9D2E75C0:01CA50B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL4030 codec is now using the device registration via
tlw4030_codec MFD device.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/Kconfig   |    2 +-
 sound/soc/codecs/twl4030.c |  203 +++++++++++++++++++++++--------------
 sound/soc/codecs/twl4030.h |  242 +------------------------------------------
 3 files changed, 133 insertions(+), 314 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index d30fce7..3d3ae0a 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -31,7 +31,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TLV320AIC3X if I2C
 	select SND_SOC_TPA6130A2 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
-	select SND_SOC_TWL4030 if TWL4030_CORE
+	select SND_SOC_TWL4030 if TWL4030_CODEC
 	select SND_SOC_UDA134X
 	select SND_SOC_UDA1380 if I2C
 	select SND_SOC_WM8350 if MFD_WM8350
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 559e9b2..78dde5d 100644
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
@@ -2187,103 +2177,162 @@ static int twl4030_init(struct snd_soc_device *socdev)
 		twl4030->sysclk = 26000;
 	}
 
+	twl4030_init_chip(codec);
+
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
 
+	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
+
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
+	printk(KERN_INFO "TWL4030 Audio Codec remove\n");
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
+MODULE_ALIAS("platform:twl4030_codec:audio");
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
diff --git a/sound/soc/codecs/twl4030.h b/sound/soc/codecs/twl4030.h
index 2b4bfa2..dd6396e 100644
--- a/sound/soc/codecs/twl4030.h
+++ b/sound/soc/codecs/twl4030.h
@@ -22,245 +22,13 @@
 #ifndef __TWL4030_AUDIO_H__
 #define __TWL4030_AUDIO_H__
 
-#define TWL4030_REG_CODEC_MODE		0x1
-#define TWL4030_REG_OPTION		0x2
-#define TWL4030_REG_UNKNOWN		0x3
-#define TWL4030_REG_MICBIAS_CTL		0x4
-#define TWL4030_REG_ANAMICL		0x5
-#define TWL4030_REG_ANAMICR		0x6
-#define TWL4030_REG_AVADC_CTL		0x7
-#define TWL4030_REG_ADCMICSEL		0x8
-#define TWL4030_REG_DIGMIXING		0x9
-#define TWL4030_REG_ATXL1PGA		0xA
-#define TWL4030_REG_ATXR1PGA		0xB
-#define TWL4030_REG_AVTXL2PGA		0xC
-#define TWL4030_REG_AVTXR2PGA		0xD
-#define TWL4030_REG_AUDIO_IF		0xE
-#define TWL4030_REG_VOICE_IF		0xF
-#define TWL4030_REG_ARXR1PGA		0x10
-#define TWL4030_REG_ARXL1PGA		0x11
-#define TWL4030_REG_ARXR2PGA		0x12
-#define TWL4030_REG_ARXL2PGA		0x13
-#define TWL4030_REG_VRXPGA		0x14
-#define TWL4030_REG_VSTPGA		0x15
-#define TWL4030_REG_VRX2ARXPGA		0x16
-#define TWL4030_REG_AVDAC_CTL		0x17
-#define TWL4030_REG_ARX2VTXPGA		0x18
-#define TWL4030_REG_ARXL1_APGA_CTL	0x19
-#define TWL4030_REG_ARXR1_APGA_CTL	0x1A
-#define TWL4030_REG_ARXL2_APGA_CTL	0x1B
-#define TWL4030_REG_ARXR2_APGA_CTL	0x1C
-#define TWL4030_REG_ATX2ARXPGA		0x1D
-#define TWL4030_REG_BT_IF		0x1E
-#define TWL4030_REG_BTPGA		0x1F
-#define TWL4030_REG_BTSTPGA		0x20
-#define TWL4030_REG_EAR_CTL		0x21
-#define TWL4030_REG_HS_SEL		0x22
-#define TWL4030_REG_HS_GAIN_SET		0x23
-#define TWL4030_REG_HS_POPN_SET		0x24
-#define TWL4030_REG_PREDL_CTL		0x25
-#define TWL4030_REG_PREDR_CTL		0x26
-#define TWL4030_REG_PRECKL_CTL		0x27
-#define TWL4030_REG_PRECKR_CTL		0x28
-#define TWL4030_REG_HFL_CTL		0x29
-#define TWL4030_REG_HFR_CTL		0x2A
-#define TWL4030_REG_ALC_CTL		0x2B
-#define TWL4030_REG_ALC_SET1		0x2C
-#define TWL4030_REG_ALC_SET2		0x2D
-#define TWL4030_REG_BOOST_CTL		0x2E
-#define TWL4030_REG_SOFTVOL_CTL		0x2F
-#define TWL4030_REG_DTMF_FREQSEL	0x30
-#define TWL4030_REG_DTMF_TONEXT1H	0x31
-#define TWL4030_REG_DTMF_TONEXT1L	0x32
-#define TWL4030_REG_DTMF_TONEXT2H	0x33
-#define TWL4030_REG_DTMF_TONEXT2L	0x34
-#define TWL4030_REG_DTMF_TONOFF		0x35
-#define TWL4030_REG_DTMF_WANONOFF	0x36
-#define TWL4030_REG_I2S_RX_SCRAMBLE_H	0x37
-#define TWL4030_REG_I2S_RX_SCRAMBLE_M	0x38
-#define TWL4030_REG_I2S_RX_SCRAMBLE_L	0x39
-#define TWL4030_REG_APLL_CTL		0x3A
-#define TWL4030_REG_DTMF_CTL		0x3B
-#define TWL4030_REG_DTMF_PGA_CTL2	0x3C
-#define TWL4030_REG_DTMF_PGA_CTL1	0x3D
-#define TWL4030_REG_MISC_SET_1		0x3E
-#define TWL4030_REG_PCMBTMUX		0x3F
-#define TWL4030_REG_RX_PATH_SEL		0x43
-#define TWL4030_REG_VDL_APGA_CTL	0x44
-#define TWL4030_REG_VIBRA_CTL		0x45
-#define TWL4030_REG_VIBRA_SET		0x46
-#define TWL4030_REG_VIBRA_PWM_SET	0x47
-#define TWL4030_REG_ANAMIC_GAIN		0x48
-#define TWL4030_REG_MISC_SET_2		0x49
-#define TWL4030_REG_SW_SHADOW		0x4A
+/* Register descriptions are here */
+#include <linux/mfd/twl4030-codec.h>
 
+/* Sgadow register used by the audio driver */
+#define TWL4030_REG_SW_SHADOW		0x4A
 #define TWL4030_CACHEREGNUM	(TWL4030_REG_SW_SHADOW + 1)
 
-/* Bitfield Definitions */
-
-/* TWL4030_CODEC_MODE (0x01) Fields */
-
-#define TWL4030_APLL_RATE		0xF0
-#define TWL4030_APLL_RATE_8000		0x00
-#define TWL4030_APLL_RATE_11025		0x10
-#define TWL4030_APLL_RATE_12000		0x20
-#define TWL4030_APLL_RATE_16000		0x40
-#define TWL4030_APLL_RATE_22050		0x50
-#define TWL4030_APLL_RATE_24000		0x60
-#define TWL4030_APLL_RATE_32000		0x80
-#define TWL4030_APLL_RATE_44100		0x90
-#define TWL4030_APLL_RATE_48000		0xA0
-#define TWL4030_APLL_RATE_96000		0xE0
-#define TWL4030_SEL_16K			0x08
-#define TWL4030_CODECPDZ		0x02
-#define TWL4030_OPT_MODE		0x01
-#define TWL4030_OPTION_1		(1 << 0)
-#define TWL4030_OPTION_2		(0 << 0)
-
-/* TWL4030_OPTION (0x02) Fields */
-
-#define TWL4030_ATXL1_EN		(1 << 0)
-#define TWL4030_ATXR1_EN		(1 << 1)
-#define TWL4030_ATXL2_VTXL_EN		(1 << 2)
-#define TWL4030_ATXR2_VTXR_EN		(1 << 3)
-#define TWL4030_ARXL1_VRX_EN		(1 << 4)
-#define TWL4030_ARXR1_EN		(1 << 5)
-#define TWL4030_ARXL2_EN		(1 << 6)
-#define TWL4030_ARXR2_EN		(1 << 7)
-
-/* TWL4030_REG_MICBIAS_CTL (0x04) Fields */
-
-#define TWL4030_MICBIAS2_CTL		0x40
-#define TWL4030_MICBIAS1_CTL		0x20
-#define TWL4030_HSMICBIAS_EN		0x04
-#define TWL4030_MICBIAS2_EN		0x02
-#define TWL4030_MICBIAS1_EN		0x01
-
-/* ANAMICL (0x05) Fields */
-
-#define TWL4030_CNCL_OFFSET_START	0x80
-#define TWL4030_OFFSET_CNCL_SEL		0x60
-#define TWL4030_OFFSET_CNCL_SEL_ARX1	0x00
-#define TWL4030_OFFSET_CNCL_SEL_ARX2	0x20
-#define TWL4030_OFFSET_CNCL_SEL_VRX	0x40
-#define TWL4030_OFFSET_CNCL_SEL_ALL	0x60
-#define TWL4030_MICAMPL_EN		0x10
-#define TWL4030_CKMIC_EN		0x08
-#define TWL4030_AUXL_EN			0x04
-#define TWL4030_HSMIC_EN		0x02
-#define TWL4030_MAINMIC_EN		0x01
-
-/* ANAMICR (0x06) Fields */
-
-#define TWL4030_MICAMPR_EN		0x10
-#define TWL4030_AUXR_EN			0x04
-#define TWL4030_SUBMIC_EN		0x01
-
-/* AVADC_CTL (0x07) Fields */
-
-#define TWL4030_ADCL_EN			0x08
-#define TWL4030_AVADC_CLK_PRIORITY	0x04
-#define TWL4030_ADCR_EN			0x02
-
-/* TWL4030_REG_ADCMICSEL (0x08) Fields */
-
-#define TWL4030_DIGMIC1_EN		0x08
-#define TWL4030_TX2IN_SEL		0x04
-#define TWL4030_DIGMIC0_EN		0x02
-#define TWL4030_TX1IN_SEL		0x01
-
-/* AUDIO_IF (0x0E) Fields */
-
-#define TWL4030_AIF_SLAVE_EN		0x80
-#define TWL4030_DATA_WIDTH		0x60
-#define TWL4030_DATA_WIDTH_16S_16W	0x00
-#define TWL4030_DATA_WIDTH_32S_16W	0x40
-#define TWL4030_DATA_WIDTH_32S_24W	0x60
-#define TWL4030_AIF_FORMAT		0x18
-#define TWL4030_AIF_FORMAT_CODEC	0x00
-#define TWL4030_AIF_FORMAT_LEFT		0x08
-#define TWL4030_AIF_FORMAT_RIGHT	0x10
-#define TWL4030_AIF_FORMAT_TDM		0x18
-#define TWL4030_AIF_TRI_EN		0x04
-#define TWL4030_CLK256FS_EN		0x02
-#define TWL4030_AIF_EN			0x01
-
-/* VOICE_IF (0x0F) Fields */
-
-#define TWL4030_VIF_SLAVE_EN		0x80
-#define TWL4030_VIF_DIN_EN		0x40
-#define TWL4030_VIF_DOUT_EN		0x20
-#define TWL4030_VIF_SWAP		0x10
-#define TWL4030_VIF_FORMAT		0x08
-#define TWL4030_VIF_TRI_EN		0x04
-#define TWL4030_VIF_SUB_EN		0x02
-#define TWL4030_VIF_EN			0x01
-
-/* EAR_CTL (0x21) */
-#define TWL4030_EAR_GAIN		0x30
-
-/* HS_GAIN_SET (0x23) Fields */
-
-#define TWL4030_HSR_GAIN		0x0C
-#define TWL4030_HSR_GAIN_PWR_DOWN	0x00
-#define TWL4030_HSR_GAIN_PLUS_6DB	0x04
-#define TWL4030_HSR_GAIN_0DB		0x08
-#define TWL4030_HSR_GAIN_MINUS_6DB	0x0C
-#define TWL4030_HSL_GAIN		0x03
-#define TWL4030_HSL_GAIN_PWR_DOWN	0x00
-#define TWL4030_HSL_GAIN_PLUS_6DB	0x01
-#define TWL4030_HSL_GAIN_0DB		0x02
-#define TWL4030_HSL_GAIN_MINUS_6DB	0x03
-
-/* HS_POPN_SET (0x24) Fields */
-
-#define TWL4030_VMID_EN			0x40
-#define	TWL4030_EXTMUTE			0x20
-#define TWL4030_RAMP_DELAY		0x1C
-#define TWL4030_RAMP_DELAY_20MS		0x00
-#define TWL4030_RAMP_DELAY_40MS		0x04
-#define TWL4030_RAMP_DELAY_81MS		0x08
-#define TWL4030_RAMP_DELAY_161MS	0x0C
-#define TWL4030_RAMP_DELAY_323MS	0x10
-#define TWL4030_RAMP_DELAY_645MS	0x14
-#define TWL4030_RAMP_DELAY_1291MS	0x18
-#define TWL4030_RAMP_DELAY_2581MS	0x1C
-#define TWL4030_RAMP_EN			0x02
-
-/* PREDL_CTL (0x25) */
-#define TWL4030_PREDL_GAIN		0x30
-
-/* PREDR_CTL (0x26) */
-#define TWL4030_PREDR_GAIN		0x30
-
-/* PRECKL_CTL (0x27) */
-#define TWL4030_PRECKL_GAIN		0x30
-
-/* PRECKR_CTL (0x28) */
-#define TWL4030_PRECKR_GAIN		0x30
-
-/* HFL_CTL (0x29, 0x2A) Fields */
-#define TWL4030_HF_CTL_HB_EN		0x04
-#define TWL4030_HF_CTL_LOOP_EN		0x08
-#define TWL4030_HF_CTL_RAMP_EN		0x10
-#define TWL4030_HF_CTL_REF_EN		0x20
-
-/* APLL_CTL (0x3A) Fields */
-
-#define TWL4030_APLL_EN			0x10
-#define TWL4030_APLL_INFREQ		0x0F
-#define TWL4030_APLL_INFREQ_19200KHZ	0x05
-#define TWL4030_APLL_INFREQ_26000KHZ	0x06
-#define TWL4030_APLL_INFREQ_38400KHZ	0x0F
-
-/* REG_MISC_SET_1 (0x3E) Fields */
-
-#define TWL4030_CLK64_EN		0x80
-#define TWL4030_SCRAMBLE_EN		0x40
-#define TWL4030_FMLOOP_EN		0x20
-#define TWL4030_SMOOTH_ANAVOL_EN	0x02
-#define TWL4030_DIGMIC_LR_SWAP_EN	0x01
-
 /* TWL4030_REG_SW_SHADOW (0x4A) Fields */
 #define TWL4030_HFL_EN			0x01
 #define TWL4030_HFR_EN			0x02
@@ -279,3 +47,5 @@ struct twl4030_setup_data {
 };
 
 #endif	/* End of __TWL4030_AUDIO_H__ */
+
+
-- 
1.6.5.1

