Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbZKDH6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbZKDH6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbZKDH6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:58:36 -0500
Received: from smtp.nokia.com ([192.100.122.230]:43235 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZKDH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:58:36 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
       sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 3/4 v2] MFD: twl4030-codec: APLL_INFREQ handling in the MFD driver
Date: Wed,  4 Nov 2009 09:58:19 +0200
Message-Id: <1257321500-27049-4-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
References: <1257321500-27049-1-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-2-git-send-email-peter.ujfalusi@nokia.com>
 <1257321500-27049-3-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 04 Nov 2009 07:58:32.0792 (UTC) FILETIME=[9AA0DD80:01CA5D24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure the APLL_INFREQ field in the APLL_CTL register
based on the platform data.
Provide also a function for childs to query the audio_mclk
frequency.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 drivers/mfd/twl4030-codec.c       |   35 +++++++++++++++++++++++++++++++++++
 include/linux/mfd/twl4030-codec.h |    1 +
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
index 9710307..77b9149 100644
--- a/drivers/mfd/twl4030-codec.c
+++ b/drivers/mfd/twl4030-codec.c
@@ -41,6 +41,7 @@ struct twl4030_codec_resource {
 };

 struct twl4030_codec {
+	unsigned int audio_mclk;
 	struct mutex mutex;
 	struct twl4030_codec_resource resource[TWL4030_CODEC_RES_MAX];
 	struct mfd_cell cells[TWL4030_CODEC_CELLS];
@@ -145,12 +146,45 @@ int twl4030_codec_disable_resource(unsigned id)
 }
 EXPORT_SYMBOL_GPL(twl4030_codec_disable_resource);

+unsigned int twl4030_codec_get_mclk(void)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+
+	return codec->audio_mclk;
+}
+EXPORT_SYMBOL_GPL(twl4030_codec_get_mclk);
+
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
 	struct twl4030_codec *codec;
 	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
 	struct mfd_cell *cell = NULL;
 	int ret, childs = 0;
+	u8 val;
+
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data is missing\n");
+		return -EINVAL;
+	}
+
+	/* Configure APLL_INFREQ and disable APLL if enabled */
+	val = 0;
+	switch (pdata->audio_mclk) {
+	case 19200000:
+		val |= TWL4030_APLL_INFREQ_19200KHZ;
+		break;
+	case 26000000:
+		val |= TWL4030_APLL_INFREQ_26000KHZ;
+		break;
+	case 38400000:
+		val |= TWL4030_APLL_INFREQ_38400KHZ;
+		break;
+	default:
+		dev_err(&pdev->dev, "Invalid audio_mclk\n");
+		return -EINVAL;
+	}
+	twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+					val, TWL4030_REG_APLL_CTL);

 	codec = kzalloc(sizeof(struct twl4030_codec), GFP_KERNEL);
 	if (!codec)
@@ -160,6 +194,7 @@ static int __devinit twl4030_codec_probe(struct platform_device *pdev)

 	twl4030_codec_dev = pdev;
 	mutex_init(&codec->mutex);
+	codec->audio_mclk = pdata->audio_mclk;

 	/* Codec power */
 	codec->resource[TWL4030_CODEC_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
diff --git a/include/linux/mfd/twl4030-codec.h b/include/linux/mfd/twl4030-codec.h
index ef0a304..2ec317c 100644
--- a/include/linux/mfd/twl4030-codec.h
+++ b/include/linux/mfd/twl4030-codec.h
@@ -267,5 +267,6 @@ enum twl4030_codec_res {

 int twl4030_codec_disable_resource(enum twl4030_codec_res id);
 int twl4030_codec_enable_resource(enum twl4030_codec_res id);
+unsigned int twl4030_codec_get_mclk(void);

 #endif	/* End of __TWL4030_CODEC_H__ */
--
1.6.5.2

