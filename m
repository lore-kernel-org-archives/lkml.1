Return-Path: <linux-kernel-owner+w=401wt.eu-S1752249AbZIWPdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbZIWPdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZIWPdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:33:11 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41162 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbZIWPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:33:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH v2] backlight: new driver for ADP5520/ADP5501 MFD PMICs
Date: Wed, 23 Sep 2009 11:33:12 -0400
Message-Id: <1253719992-2339-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253212192-29571-1-git-send-email-vapier@gentoo.org>
References: <1253212192-29571-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v2
	- fix unbalanced paren in BL_CTRL_VAL() call

 drivers/video/backlight/Kconfig      |   10 +
 drivers/video/backlight/Makefile     |    2 +-
 drivers/video/backlight/adp5520_bl.c |  377 ++++++++++++++++++++++++++++++++++
 3 files changed, 388 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/backlight/adp5520_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 90861cd..fa0fc87 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -229,3 +229,13 @@ config BACKLIGHT_SAHARA
 	help
 	  If you have a Tabletkiosk Sahara Touch-iT, say y to enable the
 	  backlight driver.
+
+config BACKLIGHT_ADP5520
+	tristate "Backlight Driver for ADP5520/ADP5501 using WLED"
+	depends on BACKLIGHT_CLASS_DEVICE && PMIC_ADP5520
+	help
+	  If you have a LCD backlight connected to the BST/BL_SNK output of
+	  ADP5520 or ADP5501, say Y here to enable this driver.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called adp5520_bl.
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 4eb178c..1977663 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -24,4 +24,4 @@ obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
 obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
 obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
-
+obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
new file mode 100644
index 0000000..ad05da5
--- /dev/null
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -0,0 +1,377 @@
+/*
+ * Backlight driver for Analog Devices ADP5520/ADP5501 MFD PMICs
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/mfd/adp5520.h>
+
+struct adp5520_bl {
+	struct device *master;
+	struct adp5520_backlight_platfrom_data *pdata;
+	struct mutex lock;
+	unsigned long cached_daylight_max;
+	int id;
+	int current_brightness;
+};
+
+static int adp5520_bl_set(struct backlight_device *bl, int brightness)
+{
+	struct adp5520_bl *data = bl_get_data(bl);
+	struct device *master = data->master;
+	int ret = 0;
+
+	if (data->pdata->en_ambl_sens) {
+		if ((brightness > 0) && (brightness < ADP5020_MAX_BRIGHTNESS)) {
+			/* Disable Ambient Light auto adjust */
+			ret |= adp5520_clr_bits(master, BL_CONTROL,
+					BL_AUTO_ADJ);
+			ret |= adp5520_write(master, DAYLIGHT_MAX, brightness);
+		} else {
+			/*
+			 * MAX_BRIGHTNESS -> Enable Ambient Light auto adjust
+			 * restore daylight l3 sysfs brightness
+			 */
+			ret |= adp5520_write(master, DAYLIGHT_MAX,
+					 data->cached_daylight_max);
+			ret |= adp5520_set_bits(master, BL_CONTROL,
+					 BL_AUTO_ADJ);
+		}
+	} else {
+		ret |= adp5520_write(master, DAYLIGHT_MAX, brightness);
+	}
+
+	if (data->current_brightness && brightness == 0)
+		ret |= adp5520_set_bits(master,
+				MODE_STATUS, DIM_EN);
+	else if (data->current_brightness == 0 && brightness)
+		ret |= adp5520_clr_bits(master,
+				MODE_STATUS, DIM_EN);
+
+	if (!ret)
+		data->current_brightness = brightness;
+
+	return ret;
+}
+
+static int adp5520_bl_update_status(struct backlight_device *bl)
+{
+	int brightness = bl->props.brightness;
+	if (bl->props.power != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
+		brightness = 0;
+
+	return adp5520_bl_set(bl, brightness);
+}
+
+static int adp5520_bl_get_brightness(struct backlight_device *bl)
+{
+	struct adp5520_bl *data = bl_get_data(bl);
+	int error;
+	uint8_t reg_val;
+
+	error = adp5520_read(data->master, BL_VALUE, &reg_val);
+
+	return error ? data->current_brightness : reg_val;
+}
+
+static struct backlight_ops adp5520_bl_ops = {
+	.update_status	= adp5520_bl_update_status,
+	.get_brightness	= adp5520_bl_get_brightness,
+};
+
+static int adp5520_bl_setup(struct backlight_device *bl)
+{
+	struct adp5520_bl *data = bl_get_data(bl);
+	struct device *master = data->master;
+	struct adp5520_backlight_platfrom_data *pdata = data->pdata;
+	int ret = 0;
+
+	ret |= adp5520_write(master, DAYLIGHT_MAX, pdata->l1_daylight_max);
+	ret |= adp5520_write(master, DAYLIGHT_DIM, pdata->l1_daylight_dim);
+
+	if (pdata->en_ambl_sens) {
+		data->cached_daylight_max = pdata->l1_daylight_max;
+		ret |= adp5520_write(master, OFFICE_MAX, pdata->l2_office_max);
+		ret |= adp5520_write(master, OFFICE_DIM, pdata->l2_office_dim);
+		ret |= adp5520_write(master, DARK_MAX, pdata->l3_dark_max);
+		ret |= adp5520_write(master, DARK_DIM, pdata->l3_dark_dim);
+		ret |= adp5520_write(master, L2_TRIP, pdata->l2_trip);
+		ret |= adp5520_write(master, L2_HYS, pdata->l2_hyst);
+		ret |= adp5520_write(master, L3_TRIP, pdata->l3_trip);
+		ret |= adp5520_write(master, L3_HYS, pdata->l3_hyst);
+		ret |= adp5520_write(master, ALS_CMPR_CFG,
+			ALS_CMPR_CFG_VAL(pdata->abml_filt, L3_EN));
+	}
+
+	ret |= adp5520_write(master, BL_CONTROL,
+			BL_CTRL_VAL(pdata->fade_led_law, pdata->en_ambl_sens));
+
+	ret |= adp5520_write(master, BL_FADE, FADE_VAL(pdata->fade_in,
+			pdata->fade_out));
+
+	ret |= adp5520_set_bits(master, MODE_STATUS, BL_EN | DIM_EN);
+
+	return ret;
+}
+
+static ssize_t adp5520_show(struct device *dev, char *buf, int reg)
+{
+	struct adp5520_bl *data = dev_get_drvdata(dev);
+	int error;
+	uint8_t reg_val;
+
+	mutex_lock(&data->lock);
+	error = adp5520_read(data->master, reg, &reg_val);
+	mutex_unlock(&data->lock);
+
+	return sprintf(buf, "%u\n", reg_val);
+}
+
+static ssize_t adp5520_store(struct device *dev, const char *buf,
+			 size_t count, int reg)
+{
+	struct adp5520_bl *data = dev_get_drvdata(dev);
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&data->lock);
+	adp5520_write(data->master, reg, val);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t adp5520_bl_dark_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, DARK_MAX);
+}
+
+static ssize_t adp5520_bl_dark_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp5520_store(dev, buf, count, DARK_MAX);
+}
+static DEVICE_ATTR(dark_max, 0664, adp5520_bl_dark_max_show,
+			adp5520_bl_dark_max_store);
+
+static ssize_t adp5520_bl_office_max_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, OFFICE_MAX);
+}
+
+static ssize_t adp5520_bl_office_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	return adp5520_store(dev, buf, count, OFFICE_MAX);
+}
+static DEVICE_ATTR(office_max, 0664, adp5520_bl_office_max_show,
+			adp5520_bl_office_max_store);
+
+static ssize_t adp5520_bl_daylight_max_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, DAYLIGHT_MAX);
+}
+
+static ssize_t adp5520_bl_daylight_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct adp5520_bl *data = dev_get_drvdata(dev);
+
+	strict_strtoul(buf, 10, &data->cached_daylight_max);
+	return adp5520_store(dev, buf, count, DAYLIGHT_MAX);
+}
+static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
+			adp5520_bl_daylight_max_store);
+
+static ssize_t adp5520_bl_dark_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, DARK_DIM);
+}
+
+static ssize_t adp5520_bl_dark_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp5520_store(dev, buf, count, DARK_DIM);
+}
+static DEVICE_ATTR(dark_dim, 0664, adp5520_bl_dark_dim_show,
+			adp5520_bl_dark_dim_store);
+
+static ssize_t adp5520_bl_office_dim_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, OFFICE_DIM);
+}
+
+static ssize_t adp5520_bl_office_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp5520_store(dev, buf, count, OFFICE_DIM);
+}
+static DEVICE_ATTR(office_dim, 0664, adp5520_bl_office_dim_show,
+			adp5520_bl_office_dim_store);
+
+static ssize_t adp5520_bl_daylight_dim_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return adp5520_show(dev, buf, DAYLIGHT_DIM);
+}
+
+static ssize_t adp5520_bl_daylight_dim_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	return adp5520_store(dev, buf, count, DAYLIGHT_DIM);
+}
+static DEVICE_ATTR(daylight_dim, 0664, adp5520_bl_daylight_dim_show,
+			adp5520_bl_daylight_dim_store);
+
+static struct attribute *adp5520_bl_attributes[] = {
+	&dev_attr_dark_max.attr,
+	&dev_attr_dark_dim.attr,
+	&dev_attr_office_max.attr,
+	&dev_attr_office_dim.attr,
+	&dev_attr_daylight_max.attr,
+	&dev_attr_daylight_dim.attr,
+	NULL
+};
+
+static const struct attribute_group adp5520_bl_attr_group = {
+	.attrs = adp5520_bl_attributes,
+};
+
+static int __devinit adp5520_bl_probe(struct platform_device *pdev)
+{
+	struct backlight_device *bl;
+	struct adp5520_bl *data;
+	int ret = 0;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->master = pdev->dev.parent;
+	data->pdata = pdev->dev.platform_data;
+
+	if (data->pdata  == NULL) {
+		dev_err(&pdev->dev, "missing platform data\n");
+		kfree(data);
+		return -ENODEV;
+	}
+
+	data->id = pdev->id;
+	data->current_brightness = 0;
+
+	mutex_init(&data->lock);
+
+	bl = backlight_device_register(pdev->name, data->master,
+			data, &adp5520_bl_ops);
+	if (IS_ERR(bl)) {
+		dev_err(&pdev->dev, "failed to register backlight\n");
+		kfree(data);
+		return PTR_ERR(bl);
+	}
+
+	bl->props.max_brightness =
+		bl->props.brightness = ADP5020_MAX_BRIGHTNESS;
+
+	if (data->pdata->en_ambl_sens)
+		ret = sysfs_create_group(&bl->dev.kobj,
+			&adp5520_bl_attr_group);
+
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register sysfs\n");
+		backlight_device_unregister(bl);
+		kfree(data);
+	}
+
+	platform_set_drvdata(pdev, bl);
+	ret |= adp5520_bl_setup(bl);
+	backlight_update_status(bl);
+
+	return ret;
+}
+
+static int __devexit adp5520_bl_remove(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	struct adp5520_bl *data = bl_get_data(bl);
+
+	adp5520_clr_bits(data->master, MODE_STATUS, BL_EN);
+
+	if (data->pdata->en_ambl_sens)
+		sysfs_remove_group(&bl->dev.kobj,
+				&adp5520_bl_attr_group);
+
+	backlight_device_unregister(bl);
+	kfree(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int adp5520_bl_suspend(struct platform_device *pdev,
+				 pm_message_t state)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+	return adp5520_bl_set(bl, 0);
+}
+
+static int adp5520_bl_resume(struct platform_device *pdev)
+{
+	struct backlight_device *bl = platform_get_drvdata(pdev);
+
+	backlight_update_status(bl);
+	return 0;
+}
+#else
+#define adp5520_bl_suspend	NULL
+#define adp5520_bl_resume	NULL
+#endif
+
+static struct platform_driver adp5520_bl_driver = {
+	.driver		= {
+		.name	= "adp5520-backlight",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= adp5520_bl_probe,
+	.remove		= __devexit_p(adp5520_bl_remove),
+	.suspend	= adp5520_bl_suspend,
+	.resume		= adp5520_bl_resume,
+};
+
+static int __init adp5520_bl_init(void)
+{
+	return platform_driver_register(&adp5520_bl_driver);
+}
+module_init(adp5520_bl_init);
+
+static void __exit adp5520_bl_exit(void)
+{
+	platform_driver_unregister(&adp5520_bl_driver);
+}
+module_exit(adp5520_bl_exit);
+
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("ADP5520(01) Backlight Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:adp5520-backlight");
-- 
1.6.5.rc1

