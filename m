Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYH0Jjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYH0Jjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYH0JjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:39:21 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27448 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYH0JjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:39:20 -0400
X-IronPort-AV: E=Sophos;i="4.32,278,1217822400"; 
   d="scan'208";a="74159091"
From: Bryan Wu <cooloney@kernel.org>
To: perex@perex.cz, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/4] ASOC: WM8731 codec: add SPI support as well as I2C
Date: Wed, 27 Aug 2008 17:39:27 +0800
Message-Id: <1219829968-6431-4-git-send-email-cooloney@kernel.org>
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
 sound/soc/codecs/Kconfig  |    5 +++
 sound/soc/codecs/wm8731.c |   71 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 67ed3f2..21bb277 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -21,6 +21,11 @@ config SND_SOC_SSM2602
 config SND_SOC_WM8731
 	tristate
 
+config SND_SOC_WM8731_SPI
+	bool "Control interface: Use SPI instead of I2C"
+	depends on SND_SOC_WM8731
+	default n
+
 config SND_SOC_WM8750
 	tristate
 
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 9402fca..56a0ff1 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/spi/spi.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -562,7 +563,7 @@ pcm_err:
 
 static struct snd_soc_device *wm8731_socdev;
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined (CONFIG_SND_SOC_WM8731_SPI)
 
 /*
  * WM8731 2 wire address is determined by GPIO5
@@ -652,6 +653,62 @@ static struct i2c_client client_template = {
 };
 #endif
 
+#if defined(CONFIG_SPI_MASTER) && defined(CONFIG_SND_SOC_WM8731_SPI)
+static int __devinit wm8731_spi_probe(struct spi_device *spi)
+{
+	struct snd_soc_device *socdev = wm8731_socdev;
+	struct snd_soc_codec *codec = socdev->codec;
+	int ret;
+
+	codec->control_data = spi;
+
+	ret = wm8731_init(socdev);
+	if (ret < 0) {
+		err("failed to initialise WM8731\n");
+	}
+
+	return ret;
+}
+
+static int __devexit wm8731_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+static struct spi_driver wm8731_spi_driver = {
+	.driver = {
+		.name	= "wm8731",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= wm8731_spi_probe,
+	.remove		= __devexit_p(wm8731_spi_remove),
+};
+
+static int wm8731_spi_write(struct spi_device *spi, const char *data, int len)
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
 static int wm8731_probe(struct platform_device *pdev)
 {
 	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
@@ -680,7 +737,7 @@ static int wm8731_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&codec->dapm_paths);
 
 	wm8731_socdev = socdev;
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined (CONFIG_SND_SOC_WM8731_SPI)
 	if (setup->i2c_address) {
 		normal_i2c[0] = setup->i2c_address;
 		codec->hw_write = (hw_write_t)i2c_master_send;
@@ -688,8 +745,14 @@ static int wm8731_probe(struct platform_device *pdev)
 		if (ret != 0)
 			printk(KERN_ERR "can't add i2c driver");
 	}
+#elif defined (CONFIG_SPI_MASTER) && defined (CONFIG_SND_SOC_WM8731_SPI)
+	codec->hw_write = (hw_write_t)wm8731_spi_write;
+	ret = spi_register_driver(&wm8731_spi_driver);
+	if (ret != 0)
+		printk(KERN_ERR "can't add spi driver");
 #else
 	/* Add other interfaces here */
+
 #endif
 
 	if (ret != 0) {
@@ -710,8 +773,10 @@ static int wm8731_remove(struct platform_device *pdev)
 
 	snd_soc_free_pcms(socdev);
 	snd_soc_dapm_free(socdev);
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if defined (CONFIG_I2C) || defined (CONFIG_I2C_MODULE) && !defined (CONFIG_SND_SOC_WM8731_SPI)
 	i2c_del_driver(&wm8731_i2c_driver);
+#elif defined (CONFIG_SPI_MASTER) && defined (CONFIG_SND_SOC_WM8731_SPI)
+	spi_unregister_driver(&wm8731_spi_driver);
 #endif
 	kfree(codec->private_data);
 	kfree(codec);
-- 
1.5.6
