Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbZKDH66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbZKDH66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZKDH65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:58:57 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43271 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbZKDH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:58:41 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 4/4 v2] ASoC: TWL4030: Do not modify the APLL_CTL register
Date: Wed,  4 Nov 2009 09:58:20 +0200
Message-Id: <1257321500-27049-5-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257321500-27049-4-git-send-email-peter.ujfalusi@nokia.com>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-4-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 04 Nov 2009 07:58:34.0956 (UTC) FILETIME=[9BEB10C0:01CA5D24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APLL_CTL register is configured by the twl4030-codec MFD
driver.
Remove code, which makes changes in the APLL_CTL register,
and replace those with checks against the configured
audio_mclk configuration done in the MFD driver.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 sound/soc/codecs/twl4030.c |   76 ++++++++++++++++++--------------------------
 1 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index c0b47df..bd8ea35 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -214,7 +214,8 @@ static void twl4030_init_chip(struct snd_soc_codec *codec)

 	/* set all audio section registers to reasonable defaults */
 	for (i = TWL4030_REG_OPTION; i <= TWL4030_REG_MISC_SET_2; i++)
-		twl4030_write(codec, i,	cache[i]);
+		if (i != TWL4030_REG_APLL_CTL)
+			twl4030_write(codec, i,	cache[i]);

 }

@@ -1753,30 +1754,23 @@ static int twl4030_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct twl4030_priv *twl4030 = codec->private_data;
-	u8 apll_ctrl;

-	apll_ctrl = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
-	apll_ctrl &= ~TWL4030_APLL_INFREQ;
 	switch (freq) {
 	case 19200000:
-		apll_ctrl |= TWL4030_APLL_INFREQ_19200KHZ;
-		twl4030->sysclk = 19200;
-		break;
 	case 26000000:
-		apll_ctrl |= TWL4030_APLL_INFREQ_26000KHZ;
-		twl4030->sysclk = 26000;
-		break;
 	case 38400000:
-		apll_ctrl |= TWL4030_APLL_INFREQ_38400KHZ;
-		twl4030->sysclk = 38400;
 		break;
 	default:
-		printk(KERN_ERR "TWL4030 set sysclk: unknown rate %d\n",
-			freq);
+		dev_err(codec->dev, "Unsupported APLL mclk: %u\n", freq);
 		return -EINVAL;
 	}

-	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
+	if ((freq / 1000) != twl4030->sysclk) {
+		dev_err(codec->dev,
+			"Mismatch in APLL mclk: %u (configured: %u)\n",
+			freq, twl4030->sysclk * 1000);
+		return -EINVAL;
+	}

 	return 0;
 }
@@ -1874,18 +1868,16 @@ static int twl4030_voice_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_pcm_runtime *rtd = substream->private_data;
 	struct snd_soc_device *socdev = rtd->socdev;
 	struct snd_soc_codec *codec = socdev->card->codec;
-	u8 infreq;
+	struct twl4030_priv *twl4030 = codec->private_data;
 	u8 mode;

 	/* If the system master clock is not 26MHz, the voice PCM interface is
 	 * not avilable.
 	 */
-	infreq = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL)
-		& TWL4030_APLL_INFREQ;
-
-	if (infreq != TWL4030_APLL_INFREQ_26000KHZ) {
-		printk(KERN_ERR "TWL4030 voice startup: "
-			"MCLK is not 26MHz, call set_sysclk() on init\n");
+	if (twl4030->sysclk != 26000) {
+		dev_err(codec->dev, "The board is configured for %u Hz, while"
+			"the Voice interface needs 26MHz APLL mclk\n",
+			twl4030->sysclk * 1000);
 		return -EINVAL;
 	}

@@ -1958,22 +1950,19 @@ static int twl4030_voice_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 		int clk_id, unsigned int freq, int dir)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
-	u8 apll_ctrl;
+	struct twl4030_priv *twl4030 = codec->private_data;

-	apll_ctrl = twl4030_read_reg_cache(codec, TWL4030_REG_APLL_CTL);
-	apll_ctrl &= ~TWL4030_APLL_INFREQ;
-	switch (freq) {
-	case 26000000:
-		apll_ctrl |= TWL4030_APLL_INFREQ_26000KHZ;
-		break;
-	default:
-		printk(KERN_ERR "TWL4030 voice set sysclk: unknown rate %d\n",
-			freq);
+	if (freq != 26000000) {
+		dev_err(codec->dev, "Unsupported APLL mclk: %u, the Voice"
+			"interface needs 26MHz APLL mclk\n", freq);
+		return -EINVAL;
+	}
+	if ((freq / 1000) != twl4030->sysclk) {
+		dev_err(codec->dev,
+			"Mismatch in APLL mclk: %u (configured: %u)\n",
+			freq, twl4030->sysclk * 1000);
 		return -EINVAL;
 	}
-
-	twl4030_write(codec, TWL4030_REG_APLL_CTL, apll_ctrl);
-
 	return 0;
 }

@@ -2131,17 +2120,15 @@ static int twl4030_soc_probe(struct platform_device *pdev)
 	if (setup) {
 		unsigned char hs_pop;

-		if (setup->sysclk)
-			twl4030->sysclk = setup->sysclk;
-		else
-			twl4030->sysclk = 26000;
+		if (setup->sysclk != twl4030->sysclk)
+			dev_warn(&pdev->dev,
+				 "Mismatch in APLL mclk: %u (configured: %u)\n",
+				 setup->sysclk, twl4030->sysclk);

 		hs_pop = twl4030_read_reg_cache(codec, TWL4030_REG_HS_POPN_SET);
 		hs_pop &= ~TWL4030_RAMP_DELAY;
 		hs_pop |= (setup->ramp_delay_value << 2);
 		twl4030_write_reg_cache(codec, TWL4030_REG_HS_POPN_SET, hs_pop);
-	} else {
-		twl4030->sysclk = 26000;
 	}

 	/* register pcms */
@@ -2191,10 +2178,8 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	struct twl4030_priv *twl4030;
 	int ret;

-	if (!pdata || !(pdata->audio_mclk == 19200000 ||
-			pdata->audio_mclk == 26000000 ||
-			pdata->audio_mclk == 38400000)) {
-		dev_err(&pdev->dev, "Invalid platform_data\n");
+	if (!pdata) {
+		dev_err(&pdev->dev, "platform_data is missing\n");
 		return -EINVAL;
 	}

@@ -2233,6 +2218,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 	twl4030_codec = codec;

 	/* Set the defaults, and power up the codec */
+	twl4030->sysclk = twl4030_codec_get_mclk() / 1000;
 	twl4030_init_chip(codec);
 	codec->bias_level = SND_SOC_BIAS_OFF;
 	twl4030_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
--
1.6.5.2

