Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZJSMma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZJSMma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZJSMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:42:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:31851 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZJSMm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:42:27 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Cc: sameo@linux.intel.com, tony@atomide.com,
       broonie@opensource.wolfsonmicro.com
Subject: [PATCH 1/4] MFD: twl4030: add twl4030_codec MFD as a new child to the core
Date: Mon, 19 Oct 2009 15:42:17 +0300
Message-Id: <1255956140-4829-2-git-send-email-peter.ujfalusi@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
References: <1255956140-4829-1-git-send-email-peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 19 Oct 2009 12:42:22.0666 (UTC) FILETIME=[9A9D6AA0:01CA50B9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New MFD child to twl4030 MFD device.
This MFD device will be used by the drivers, which needs resources
from the twl4030 codec like audio and vibra.

The platform specific configuration data is passed along to the
child drivers (audio, vibra).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>
---
 drivers/mfd/Kconfig               |   13 ++
 drivers/mfd/Makefile              |    1 +
 drivers/mfd/twl4030-codec.c       |  245 ++++++++++++++++++++++++++++++++++
 drivers/mfd/twl4030-core.c        |   14 ++
 include/linux/i2c/twl4030.h       |   18 +++
 include/linux/mfd/twl4030-codec.h |  261 +++++++++++++++++++++++++++++++++++++
 6 files changed, 552 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 include/linux/mfd/twl4030-codec.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 570be13..08e4aa6 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -121,6 +121,19 @@ config TWL4030_POWER
 	  and load scripts controling which resources are switched off/on
 	  or reset when a sleep, wakeup or warm reset event occurs.
 
+config TWL4030_CODEC
+	bool "Support codec part of the TWL4030 family chips"
+	depends on TWL4030_CORE
+	help
+	  Say yes here if you want to use the codec resources on the
+	  TWL4030 family chips. The codec in TWL4030 provides the audio
+	  functionality and also has the vibrator controls.
+
+	  This driver provides MFD device to be used for drivers, which needs
+	  access to the codec part, the board-specific data is passed from this
+	  driver to the childs as platform data with the board specific
+	  configuration.
+
 config MFD_TMIO
 	bool
 	default n
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f3b277b..af0fc90 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_MENELAUS)		+= menelaus.o
 
 obj-$(CONFIG_TWL4030_CORE)	+= twl4030-core.o twl4030-irq.o
 obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
+obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
 
 obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
 
diff --git a/drivers/mfd/twl4030-codec.c b/drivers/mfd/twl4030-codec.c
new file mode 100644
index 0000000..a459052
--- /dev/null
+++ b/drivers/mfd/twl4030-codec.c
@@ -0,0 +1,245 @@
+/*
+ * MFD driver for twl4030 codec submodule
+ *
+ * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ *
+ * Copyright:   (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/i2c/twl4030.h>
+#include <linux/mfd/twl4030-codec.h>
+
+static struct platform_device *twl4030_codec_dev;
+
+struct twl4030_codec_resource {
+	int request_count;
+	u8 reg;
+	u8 mask;
+};
+
+struct twl4030_codec {
+	struct mutex mutex;
+	struct twl4030_codec_resource resource[TWL4030_CODEC_RES_MAX];
+};
+
+/*
+ * Modify the resource, the function returns the content of the register
+ * after the modification.
+ */
+static int twl4030_codec_set_resource(enum twl4030_codec_res id, int enable)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	u8 val;
+
+	twl4030_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
+			codec->resource[id].reg);
+
+	if (enable)
+		val |= codec->resource[id].mask;
+	else
+		val &= ~codec->resource[id].mask;
+
+	twl4030_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE,
+					val, codec->resource[id].reg);
+
+	return val;
+}
+
+static inline int twl4030_codec_get_resource(enum twl4030_codec_res id)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	u8 val;
+
+	twl4030_i2c_read_u8(TWL4030_MODULE_AUDIO_VOICE, &val,
+			codec->resource[id].reg);
+
+	return val;
+}
+
+/*
+ * Enable the resource.
+ * The function returns with error or the content of the register
+ */
+int twl4030_codec_enable_resource(enum twl4030_codec_res id)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	int val;
+
+	if (id >= TWL4030_CODEC_RES_MAX) {
+		dev_err(&twl4030_codec_dev->dev,
+				"Invalid resource ID (%u)\n", id);
+		return -EINVAL;
+	}
+
+	mutex_lock(&codec->mutex);
+	if (!codec->resource[id].request_count)
+		/* Resource was disabled, enable it */
+		val = twl4030_codec_set_resource(id, 1);
+	else
+		val = twl4030_codec_get_resource(id);
+
+	codec->resource[id].request_count++;
+	mutex_unlock(&codec->mutex);
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(twl4030_codec_enable_resource);
+
+/*
+ * Disable the resource.
+ * The function returns with error or the content of the register
+ */
+int twl4030_codec_disable_resource(unsigned id)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(twl4030_codec_dev);
+	int val;
+
+	if (id >= TWL4030_CODEC_RES_MAX) {
+		dev_err(&twl4030_codec_dev->dev,
+				"Invalid resource ID (%u)\n", id);
+		return -EINVAL;
+	}
+
+	mutex_lock(&codec->mutex);
+	if (!codec->resource[id].request_count) {
+		dev_err(&twl4030_codec_dev->dev,
+			"Resource has been disabled already (%u)\n", id);
+		mutex_unlock(&codec->mutex);
+		return -EPERM;
+	}
+	codec->resource[id].request_count--;
+
+	if (!codec->resource[id].request_count)
+		/* Resource can be disabled now */
+		val = twl4030_codec_set_resource(id, 0);
+	else
+		val = twl4030_codec_get_resource(id);
+
+	mutex_unlock(&codec->mutex);
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(twl4030_codec_disable_resource);
+
+static struct device *
+twl4030_codec_new_child(const char *name, void *pdata, unsigned pdata_len)
+{
+	struct platform_device	*pdev;
+	int			status = 0;
+
+	pdev = platform_device_alloc(name, -1);
+	if (!pdev) {
+		dev_dbg(&twl4030_codec_dev->dev, "can't alloc dev (%s)\n",
+									name);
+		return ERR_PTR(-ENOMEM);
+	}
+	pdev->dev.parent = &twl4030_codec_dev->dev;
+
+	if (pdata) {
+		status = platform_device_add_data(pdev, pdata, pdata_len);
+		if (status < 0) {
+			dev_dbg(&pdev->dev, "can't add platform_data\n");
+			goto err;
+		}
+	}
+	status = platform_device_add(pdev);
+	if (status < 0) {
+		dev_dbg(&pdev->dev, "Adding platform device failed\n");
+		goto err;
+	}
+
+	return &pdev->dev;
+err:
+	platform_device_put(pdev);
+	dev_err(&twl4030_codec_dev->dev, "can't add %s dev\n", name);
+	return ERR_PTR(status);
+}
+
+static int __devinit twl4030_codec_probe(struct platform_device *pdev)
+{
+	struct twl4030_codec *codec;
+	struct twl4030_codec_data	*pdata = pdev->dev.platform_data;
+
+	codec = kzalloc(sizeof(struct twl4030_codec), GFP_KERNEL);
+	if (!codec)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, codec);
+
+	twl4030_codec_dev = pdev;
+	mutex_init(&codec->mutex);
+
+	/* Codec power */
+	codec->resource[TWL4030_CODEC_RES_POWER].reg = TWL4030_REG_CODEC_MODE;
+	codec->resource[TWL4030_CODEC_RES_POWER].mask = TWL4030_CODECPDZ;
+
+	/* PLL */
+	codec->resource[TWL4030_CODEC_RES_APLL].reg = TWL4030_REG_APLL_CTL;
+	codec->resource[TWL4030_CODEC_RES_APLL].mask = TWL4030_APLL_EN;
+
+	if (pdata->audio)
+		twl4030_codec_new_child("twl4030_codec_audio", pdata->audio,
+					sizeof(*pdata->audio));
+	if (pdata->vibra)
+		twl4030_codec_new_child("twl4030_codec_vibra", pdata->vibra,
+					sizeof(*pdata->vibra));
+	return 0;
+}
+
+static int __devexit twl4030_codec_remove(struct platform_device *pdev)
+{
+	struct twl4030_codec *codec = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(codec);
+	twl4030_codec_dev = NULL;
+
+	return 0;
+}
+
+MODULE_ALIAS("platform:twl4030_codec");
+
+static struct platform_driver twl4030_codec_driver = {
+	.probe		= twl4030_codec_probe,
+	.remove		= __devexit_p(twl4030_codec_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "twl4030_codec",
+	},
+};
+
+static int __devinit twl4030_codec_init(void)
+{
+	return platform_driver_register(&twl4030_codec_driver);
+}
+module_init(twl4030_codec_init);
+
+static void __devexit twl4030_codec_exit(void)
+{
+	platform_driver_unregister(&twl4030_codec_driver);
+}
+module_exit(twl4030_codec_exit);
+
+MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@nokia.com>");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index e424cf6..0ee81e4 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -114,6 +114,12 @@
 #define twl_has_watchdog()        false
 #endif
 
+#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE)
+#define twl_has_codec()	true
+#else
+#define twl_has_codec()	false
+#endif
+
 /* Triton Core internal information (BEGIN) */
 
 /* Last - for index max*/
@@ -557,6 +563,14 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
+	if (twl_has_codec() && pdata->codec) {
+		child = add_child(1, "twl4030_codec",
+				pdata->codec, sizeof(*pdata->codec),
+				false, 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 2d02dfd..42d6c72 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -401,6 +401,23 @@ struct twl4030_power_data {
 
 extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 
+struct twl4030_codec_audio_data {
+	unsigned int	audio_mclk;
+	unsigned int ramp_delay_value;
+	unsigned int hs_extmute:1;
+	void (*set_hs_extmute)(int mute);
+};
+
+struct twl4030_codec_vibra_data {
+	unsigned int	audio_mclk;
+	unsigned int	coexist;
+};
+
+struct twl4030_codec_data {
+	struct twl4030_codec_audio_data		*audio;
+	struct twl4030_codec_vibra_data		*vibra;
+};
+
 struct twl4030_platform_data {
 	unsigned				irq_base, irq_end;
 	struct twl4030_bci_platform_data	*bci;
@@ -409,6 +426,7 @@ struct twl4030_platform_data {
 	struct twl4030_keypad_data		*keypad;
 	struct twl4030_usb_data			*usb;
 	struct twl4030_power_data		*power;
+	struct twl4030_codec_data		*codec;
 
 	/* LDO regulators */
 	struct regulator_init_data		*vdac;
diff --git a/include/linux/mfd/twl4030-codec.h b/include/linux/mfd/twl4030-codec.h
new file mode 100644
index 0000000..5fec31a
--- /dev/null
+++ b/include/linux/mfd/twl4030-codec.h
@@ -0,0 +1,261 @@
+/*
+ * MFD driver for twl4030 codec submodule
+ *
+ * Author:	Peter Ujfalusi <peter.ujfalusi@nokia.com>
+ *
+ * Copyright:   (C) 2009 Nokia Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __TWL4030_CODEC_H__
+#define __TWL4030_CODEC_H__
+
+/* Codec registers */
+#define TWL4030_REG_CODEC_MODE		0x01
+#define TWL4030_REG_OPTION		0x02
+#define TWL4030_REG_UNKNOWN		0x03
+#define TWL4030_REG_MICBIAS_CTL		0x04
+#define TWL4030_REG_ANAMICL		0x05
+#define TWL4030_REG_ANAMICR		0x06
+#define TWL4030_REG_AVADC_CTL		0x07
+#define TWL4030_REG_ADCMICSEL		0x08
+#define TWL4030_REG_DIGMIXING		0x09
+#define TWL4030_REG_ATXL1PGA		0x0A
+#define TWL4030_REG_ATXR1PGA		0x0B
+#define TWL4030_REG_AVTXL2PGA		0x0C
+#define TWL4030_REG_AVTXR2PGA		0x0D
+#define TWL4030_REG_AUDIO_IF		0x0E
+#define TWL4030_REG_VOICE_IF		0x0F
+#define TWL4030_REG_ARXR1PGA		0x10
+#define TWL4030_REG_ARXL1PGA		0x11
+#define TWL4030_REG_ARXR2PGA		0x12
+#define TWL4030_REG_ARXL2PGA		0x13
+#define TWL4030_REG_VRXPGA		0x14
+#define TWL4030_REG_VSTPGA		0x15
+#define TWL4030_REG_VRX2ARXPGA		0x16
+#define TWL4030_REG_AVDAC_CTL		0x17
+#define TWL4030_REG_ARX2VTXPGA		0x18
+#define TWL4030_REG_ARXL1_APGA_CTL	0x19
+#define TWL4030_REG_ARXR1_APGA_CTL	0x1A
+#define TWL4030_REG_ARXL2_APGA_CTL	0x1B
+#define TWL4030_REG_ARXR2_APGA_CTL	0x1C
+#define TWL4030_REG_ATX2ARXPGA		0x1D
+#define TWL4030_REG_BT_IF		0x1E
+#define TWL4030_REG_BTPGA		0x1F
+#define TWL4030_REG_BTSTPGA		0x20
+#define TWL4030_REG_EAR_CTL		0x21
+#define TWL4030_REG_HS_SEL		0x22
+#define TWL4030_REG_HS_GAIN_SET		0x23
+#define TWL4030_REG_HS_POPN_SET		0x24
+#define TWL4030_REG_PREDL_CTL		0x25
+#define TWL4030_REG_PREDR_CTL		0x26
+#define TWL4030_REG_PRECKL_CTL		0x27
+#define TWL4030_REG_PRECKR_CTL		0x28
+#define TWL4030_REG_HFL_CTL		0x29
+#define TWL4030_REG_HFR_CTL		0x2A
+#define TWL4030_REG_ALC_CTL		0x2B
+#define TWL4030_REG_ALC_SET1		0x2C
+#define TWL4030_REG_ALC_SET2		0x2D
+#define TWL4030_REG_BOOST_CTL		0x2E
+#define TWL4030_REG_SOFTVOL_CTL		0x2F
+#define TWL4030_REG_DTMF_FREQSEL	0x30
+#define TWL4030_REG_DTMF_TONEXT1H	0x31
+#define TWL4030_REG_DTMF_TONEXT1L	0x32
+#define TWL4030_REG_DTMF_TONEXT2H	0x33
+#define TWL4030_REG_DTMF_TONEXT2L	0x34
+#define TWL4030_REG_DTMF_TONOFF		0x35
+#define TWL4030_REG_DTMF_WANONOFF	0x36
+#define TWL4030_REG_I2S_RX_SCRAMBLE_H	0x37
+#define TWL4030_REG_I2S_RX_SCRAMBLE_M	0x38
+#define TWL4030_REG_I2S_RX_SCRAMBLE_L	0x39
+#define TWL4030_REG_APLL_CTL		0x3A
+#define TWL4030_REG_DTMF_CTL		0x3B
+#define TWL4030_REG_DTMF_PGA_CTL2	0x3C
+#define TWL4030_REG_DTMF_PGA_CTL1	0x3D
+#define TWL4030_REG_MISC_SET_1		0x3E
+#define TWL4030_REG_PCMBTMUX		0x3F
+#define TWL4030_REG_RX_PATH_SEL		0x43
+#define TWL4030_REG_VDL_APGA_CTL	0x44
+#define TWL4030_REG_VIBRA_CTL		0x45
+#define TWL4030_REG_VIBRA_SET		0x46
+#define TWL4030_REG_VIBRA_PWM_SET	0x47
+#define TWL4030_REG_ANAMIC_GAIN		0x48
+#define TWL4030_REG_MISC_SET_2		0x49
+
+/* Bitfield Definitions */
+
+/* TWL4030_CODEC_MODE (0x01) Fields */
+#define TWL4030_APLL_RATE		0xF0
+#define TWL4030_APLL_RATE_8000		0x00
+#define TWL4030_APLL_RATE_11025		0x10
+#define TWL4030_APLL_RATE_12000		0x20
+#define TWL4030_APLL_RATE_16000		0x40
+#define TWL4030_APLL_RATE_22050		0x50
+#define TWL4030_APLL_RATE_24000		0x60
+#define TWL4030_APLL_RATE_32000		0x80
+#define TWL4030_APLL_RATE_44100		0x90
+#define TWL4030_APLL_RATE_48000		0xA0
+#define TWL4030_APLL_RATE_96000		0xE0
+#define TWL4030_SEL_16K			0x08
+#define TWL4030_CODECPDZ		0x02
+#define TWL4030_OPT_MODE		0x01
+#define TWL4030_OPTION_1		(1 << 0)
+#define TWL4030_OPTION_2		(0 << 0)
+
+/* TWL4030_OPTION (0x02) Fields */
+#define TWL4030_ATXL1_EN		(1 << 0)
+#define TWL4030_ATXR1_EN		(1 << 1)
+#define TWL4030_ATXL2_VTXL_EN		(1 << 2)
+#define TWL4030_ATXR2_VTXR_EN		(1 << 3)
+#define TWL4030_ARXL1_VRX_EN		(1 << 4)
+#define TWL4030_ARXR1_EN		(1 << 5)
+#define TWL4030_ARXL2_EN		(1 << 6)
+#define TWL4030_ARXR2_EN		(1 << 7)
+
+/* TWL4030_REG_MICBIAS_CTL (0x04) Fields */
+#define TWL4030_MICBIAS2_CTL		0x40
+#define TWL4030_MICBIAS1_CTL		0x20
+#define TWL4030_HSMICBIAS_EN		0x04
+#define TWL4030_MICBIAS2_EN		0x02
+#define TWL4030_MICBIAS1_EN		0x01
+
+/* ANAMICL (0x05) Fields */
+#define TWL4030_CNCL_OFFSET_START	0x80
+#define TWL4030_OFFSET_CNCL_SEL		0x60
+#define TWL4030_OFFSET_CNCL_SEL_ARX1	0x00
+#define TWL4030_OFFSET_CNCL_SEL_ARX2	0x20
+#define TWL4030_OFFSET_CNCL_SEL_VRX	0x40
+#define TWL4030_OFFSET_CNCL_SEL_ALL	0x60
+#define TWL4030_MICAMPL_EN		0x10
+#define TWL4030_CKMIC_EN		0x08
+#define TWL4030_AUXL_EN			0x04
+#define TWL4030_HSMIC_EN		0x02
+#define TWL4030_MAINMIC_EN		0x01
+
+/* ANAMICR (0x06) Fields */
+#define TWL4030_MICAMPR_EN		0x10
+#define TWL4030_AUXR_EN			0x04
+#define TWL4030_SUBMIC_EN		0x01
+
+/* AVADC_CTL (0x07) Fields */
+#define TWL4030_ADCL_EN			0x08
+#define TWL4030_AVADC_CLK_PRIORITY	0x04
+#define TWL4030_ADCR_EN			0x02
+
+/* TWL4030_REG_ADCMICSEL (0x08) Fields */
+#define TWL4030_DIGMIC1_EN		0x08
+#define TWL4030_TX2IN_SEL		0x04
+#define TWL4030_DIGMIC0_EN		0x02
+#define TWL4030_TX1IN_SEL		0x01
+
+/* AUDIO_IF (0x0E) Fields */
+#define TWL4030_AIF_SLAVE_EN		0x80
+#define TWL4030_DATA_WIDTH		0x60
+#define TWL4030_DATA_WIDTH_16S_16W	0x00
+#define TWL4030_DATA_WIDTH_32S_16W	0x40
+#define TWL4030_DATA_WIDTH_32S_24W	0x60
+#define TWL4030_AIF_FORMAT		0x18
+#define TWL4030_AIF_FORMAT_CODEC	0x00
+#define TWL4030_AIF_FORMAT_LEFT		0x08
+#define TWL4030_AIF_FORMAT_RIGHT	0x10
+#define TWL4030_AIF_FORMAT_TDM		0x18
+#define TWL4030_AIF_TRI_EN		0x04
+#define TWL4030_CLK256FS_EN		0x02
+#define TWL4030_AIF_EN			0x01
+
+/* VOICE_IF (0x0F) Fields */
+#define TWL4030_VIF_SLAVE_EN		0x80
+#define TWL4030_VIF_DIN_EN		0x40
+#define TWL4030_VIF_DOUT_EN		0x20
+#define TWL4030_VIF_SWAP		0x10
+#define TWL4030_VIF_FORMAT		0x08
+#define TWL4030_VIF_TRI_EN		0x04
+#define TWL4030_VIF_SUB_EN		0x02
+#define TWL4030_VIF_EN			0x01
+
+/* EAR_CTL (0x21) */
+#define TWL4030_EAR_GAIN		0x30
+
+/* HS_GAIN_SET (0x23) Fields */
+#define TWL4030_HSR_GAIN		0x0C
+#define TWL4030_HSR_GAIN_PWR_DOWN	0x00
+#define TWL4030_HSR_GAIN_PLUS_6DB	0x04
+#define TWL4030_HSR_GAIN_0DB		0x08
+#define TWL4030_HSR_GAIN_MINUS_6DB	0x0C
+#define TWL4030_HSL_GAIN		0x03
+#define TWL4030_HSL_GAIN_PWR_DOWN	0x00
+#define TWL4030_HSL_GAIN_PLUS_6DB	0x01
+#define TWL4030_HSL_GAIN_0DB		0x02
+#define TWL4030_HSL_GAIN_MINUS_6DB	0x03
+
+/* HS_POPN_SET (0x24) Fields */
+#define TWL4030_VMID_EN			0x40
+#define	TWL4030_EXTMUTE			0x20
+#define TWL4030_RAMP_DELAY		0x1C
+#define TWL4030_RAMP_DELAY_20MS		0x00
+#define TWL4030_RAMP_DELAY_40MS		0x04
+#define TWL4030_RAMP_DELAY_81MS		0x08
+#define TWL4030_RAMP_DELAY_161MS	0x0C
+#define TWL4030_RAMP_DELAY_323MS	0x10
+#define TWL4030_RAMP_DELAY_645MS	0x14
+#define TWL4030_RAMP_DELAY_1291MS	0x18
+#define TWL4030_RAMP_DELAY_2581MS	0x1C
+#define TWL4030_RAMP_EN			0x02
+
+/* PREDL_CTL (0x25) */
+#define TWL4030_PREDL_GAIN		0x30
+
+/* PREDR_CTL (0x26) */
+#define TWL4030_PREDR_GAIN		0x30
+
+/* PRECKL_CTL (0x27) */
+#define TWL4030_PRECKL_GAIN		0x30
+
+/* PRECKR_CTL (0x28) */
+#define TWL4030_PRECKR_GAIN		0x30
+
+/* HFL_CTL (0x29, 0x2A) Fields */
+#define TWL4030_HF_CTL_HB_EN		0x04
+#define TWL4030_HF_CTL_LOOP_EN		0x08
+#define TWL4030_HF_CTL_RAMP_EN		0x10
+#define TWL4030_HF_CTL_REF_EN		0x20
+
+/* APLL_CTL (0x3A) Fields */
+#define TWL4030_APLL_EN			0x10
+#define TWL4030_APLL_INFREQ		0x0F
+#define TWL4030_APLL_INFREQ_19200KHZ	0x05
+#define TWL4030_APLL_INFREQ_26000KHZ	0x06
+#define TWL4030_APLL_INFREQ_38400KHZ	0x0F
+
+/* REG_MISC_SET_1 (0x3E) Fields */
+#define TWL4030_CLK64_EN		0x80
+#define TWL4030_SCRAMBLE_EN		0x40
+#define TWL4030_FMLOOP_EN		0x20
+#define TWL4030_SMOOTH_ANAVOL_EN	0x02
+#define TWL4030_DIGMIC_LR_SWAP_EN	0x01
+
+/* TWL4030 codec resource IDs */
+enum twl4030_codec_res {
+	TWL4030_CODEC_RES_POWER = 0,
+	TWL4030_CODEC_RES_APLL,
+	TWL4030_CODEC_RES_MAX,
+};
+
+int twl4030_codec_disable_resource(enum twl4030_codec_res id);
+int twl4030_codec_enable_resource(enum twl4030_codec_res id);
+
+#endif	/* End of __TWL4030_CODEC_H__ */
-- 
1.6.5.1

