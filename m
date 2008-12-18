Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753471AbYLRF60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYLRF60 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 00:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbYLRF6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 00:58:00 -0500
Received: from mail.openmoko.org ([88.198.124.205]:51647 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbYLRF56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 00:57:58 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH V2 5/7] power_supply: PCF50633 battery charger driver
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>
Date: Thu, 18 Dec 2008 11:27:45 +0530
Message-ID: <20081218055744.31696.14523.stgit@cff.thadambail>
In-Reply-To: <20081218055618.31696.65002.stgit@cff.thadambail>
References: <20081218055618.31696.65002.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/Kconfig            |    6 +
 drivers/power/Makefile           |    2 
 drivers/power/pcf50633-charger.c |  358 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/mbc.h |  134 ++++++++++++++
 4 files changed, 500 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/pcf50633-charger.c
 create mode 100644 include/linux/mfd/pcf50633/mbc.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 52f8676..04f6316 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -75,4 +75,10 @@ config BATTERY_BQ27x00
 	help
 	  Say Y here to enable support for batteries with BQ27200(I2C) chip.
 
+config CHARGER_PCF50633
+	tristate "NXP PCF50633 MBC"
+	depends on MFD_PCF50633
+	help
+	 Say Y to include support for NXP PCF50633 Main Battery Charger.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index e6f6865..62bcb76 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -24,3 +24,5 @@ obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
 obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
+
+obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
new file mode 100644
index 0000000..83fc70c
--- /dev/null
+++ b/drivers/power/pcf50633-charger.c
@@ -0,0 +1,358 @@
+/* NXP PCF50633 Main Battery Charger Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/mbc.h>
+
+struct pcf50633_mbc {
+	struct pcf50633 *pcf;
+
+	int adapter_active;
+	int adapter_online;
+	int usb_active;
+	int usb_online;
+
+	struct power_supply usb;
+	struct power_supply adapter;
+};
+
+int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma)
+{
+	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
+	int ret = 0;
+	u8 bits;
+
+	if (ma >= 1000)
+		bits = PCF50633_MBCC7_USB_1000mA;
+	else if (ma >= 500)
+		bits = PCF50633_MBCC7_USB_500mA;
+	else if (ma >= 100)
+		bits = PCF50633_MBCC7_USB_100mA;
+	else
+		bits = PCF50633_MBCC7_USB_SUSPEND;
+
+	ret = pcf50633_reg_set_bit_mask(pcf, PCF50633_REG_MBCC7,
+					PCF50633_MBCC7_USB_MASK, bits);
+	if (ret)
+		dev_err(pcf->dev, "error setting usb curlim to %d mA\n", ma);
+	else
+		dev_info(pcf->dev, "usb curlim to %d mA\n", ma);
+
+	power_supply_changed(&mbc->usb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pcf50633_mbc_usb_curlim_set);
+
+int pcf50633_mbc_get_status(struct pcf50633 *pcf)
+{
+	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
+	int status = 0;
+
+	if (mbc->usb_online)
+		status |= PCF50633_MBC_USB_ONLINE;
+	if (mbc->usb_online)
+		status |= PCF50633_MBC_USB_ACTIVE;
+	if (mbc->usb_online)
+		status |= PCF50633_MBC_ADAPTER_ONLINE;
+	if (mbc->usb_online)
+		status |= PCF50633_MBC_ADAPTER_ACTIVE;
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
+
+void pcf50633_mbc_set_status(struct pcf50633 *pcf, int what, int status)
+{
+	struct pcf50633_mbc *mbc = platform_get_drvdata(pcf->mbc_pdev);
+
+	if (what & PCF50633_MBC_USB_ONLINE)
+		mbc->usb_online = !!status;
+	if (what & PCF50633_MBC_USB_ACTIVE)
+		mbc->usb_active = !!status;
+	if (what & PCF50633_MBC_ADAPTER_ONLINE)
+		mbc->adapter_online = !!status;
+	if (what & PCF50633_MBC_ADAPTER_ACTIVE)
+		mbc->adapter_active = !!status;
+}
+EXPORT_SYMBOL_GPL(pcf50633_mbc_set_status);
+
+static ssize_t
+show_chgmode(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+
+	u8 mbcs2 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS2);
+	u8 chgmod = (mbcs2 & PCF50633_MBCS2_MBC_MASK);
+
+	return sprintf(buf, "%d\n", chgmod);
+}
+static DEVICE_ATTR(chgmode, S_IRUGO, show_chgmode, NULL);
+
+static ssize_t
+show_usblim(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+	u8 usblim = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCC7) &
+						PCF50633_MBCC7_USB_MASK;
+	unsigned int ma;
+
+	if (usblim == PCF50633_MBCC7_USB_1000mA)
+		ma = 1000;
+	else if (usblim == PCF50633_MBCC7_USB_500mA)
+		ma = 500;
+	else if (usblim == PCF50633_MBCC7_USB_100mA)
+		ma = 100;
+	else
+		ma = 0;
+
+	return sprintf(buf, "%u\n", ma);
+}
+
+static ssize_t set_usblim(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct pcf50633_mbc *mbc = dev_get_drvdata(dev);
+	unsigned long ma;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &ma);
+	if (ret)
+		return -EINVAL;
+
+	pcf50633_mbc_usb_curlim_set(mbc->pcf, ma);
+
+	return count;
+}
+
+static DEVICE_ATTR(usb_curlim, S_IRUGO | S_IWUSR, show_usblim, set_usblim);
+
+static struct attribute *pcf50633_mbc_sysfs_entries[] = {
+	&dev_attr_chgmode.attr,
+	&dev_attr_usb_curlim.attr,
+	NULL,
+};
+
+static struct attribute_group mbc_attr_group = {
+	.name	= NULL,			/* put in device directory */
+	.attrs	= pcf50633_mbc_sysfs_entries,
+};
+
+static void
+pcf50633_mbc_irq_handler(int irq, void *data)
+{
+	struct pcf50633_mbc *mbc = data;
+
+	/* USB */
+	if (irq == PCF50633_IRQ_USBINS) {
+		mbc->usb_online = 1;
+	} else if (irq == PCF50633_IRQ_USBREM) {
+		mbc->usb_online = 0;
+		mbc->usb_active = 0;
+		pcf50633_mbc_usb_curlim_set(mbc->pcf, 0);
+	}
+
+	/* Adapter */
+	if (irq == PCF50633_IRQ_ADPINS) {
+		mbc->adapter_online = 1;
+		mbc->adapter_active = 1;
+	} else if (irq == PCF50633_IRQ_ADPREM) {
+		mbc->adapter_online = 0;
+		mbc->adapter_active = 0;
+	}
+
+	if (irq == PCF50633_IRQ_BATFULL) {
+		mbc->usb_active = 0;
+		mbc->adapter_active = 0;
+	}
+
+	power_supply_changed(&mbc->usb);
+	power_supply_changed(&mbc->adapter);
+
+	if (mbc->pcf->pdata->mbc_event_callback)
+		mbc->pcf->pdata->mbc_event_callback(mbc->pcf, irq);
+}
+
+static int adapter_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval =  mbc->adapter_online;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int usb_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = mbc->usb_online;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static enum power_supply_property power_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static const u8 mbc_irq_handlers[] = {
+	PCF50633_IRQ_ADPINS,
+	PCF50633_IRQ_ADPREM,
+	PCF50633_IRQ_USBINS,
+	PCF50633_IRQ_USBREM,
+	PCF50633_IRQ_BATFULL,
+	PCF50633_IRQ_CHGHALT,
+	PCF50633_IRQ_THLIMON,
+	PCF50633_IRQ_THLIMOFF,
+	PCF50633_IRQ_USBLIMON,
+	PCF50633_IRQ_USBLIMOFF,
+	PCF50633_IRQ_LOWSYS,
+	PCF50633_IRQ_LOWBAT,
+};
+
+static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
+{
+	struct pcf50633_mbc *mbc;
+	struct pcf50633_subdev_pdata *pdata = pdev->dev.platform_data;
+	int ret;
+	int i;
+	u8 mbcs1;
+
+	mbc = kzalloc(sizeof(*mbc), GFP_KERNEL);
+	if (!mbc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, mbc);
+	mbc->pcf = pdata->pcf;
+
+	/* Set up IRQ handlers */
+	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
+		pcf50633_register_irq(mbc->pcf, mbc_irq_handlers[i],
+					pcf50633_mbc_irq_handler, mbc);
+
+	/* Create power supplies */
+	mbc->adapter.name		= "adapter";
+	mbc->adapter.type		= POWER_SUPPLY_TYPE_MAINS;
+	mbc->adapter.properties		= power_props;
+	mbc->adapter.num_properties	= ARRAY_SIZE(power_props);
+	mbc->adapter.get_property	= &adapter_get_property;
+	mbc->adapter.supplied_to	= mbc->pcf->pdata->batteries;
+	mbc->adapter.num_supplicants	= mbc->pcf->pdata->num_batteries;
+
+	mbc->usb.name			= "usb";
+	mbc->usb.type			= POWER_SUPPLY_TYPE_USB;
+	mbc->usb.properties		= power_props;
+	mbc->usb.num_properties		= ARRAY_SIZE(power_props);
+	mbc->usb.get_property		= usb_get_property;
+	mbc->usb.supplied_to		= mbc->pcf->pdata->batteries;
+	mbc->usb.num_supplicants	= mbc->pcf->pdata->num_batteries;
+
+	ret = power_supply_register(&pdev->dev, &mbc->adapter);
+	if (ret) {
+		dev_err(mbc->pcf->dev, "failed to register adapter\n");
+		kfree(mbc);
+		return ret;
+	}
+
+	ret = power_supply_register(&pdev->dev, &mbc->usb);
+	if (ret) {
+		dev_err(mbc->pcf->dev, "failed to register usb\n");
+		power_supply_unregister(&mbc->adapter);
+		kfree(mbc);
+		return ret;
+	}
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &mbc_attr_group);
+	if (ret)
+		dev_err(mbc->pcf->dev, "failed to create sysfs entries\n");
+
+	mbcs1 = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCS1);
+	if (mbcs1 & PCF50633_MBCS1_USBPRES)
+		pcf50633_mbc_irq_handler(PCF50633_IRQ_USBINS, mbc);
+	if (mbcs1 & PCF50633_MBCS1_ADAPTPRES)
+		pcf50633_mbc_irq_handler(PCF50633_IRQ_ADPINS, mbc);
+
+	return 0;
+}
+
+static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
+{
+	struct pcf50633_mbc *mbc = platform_get_drvdata(pdev);
+	int i;
+
+	/* Remove IRQ handlers */
+	for (i = 0; i < ARRAY_SIZE(mbc_irq_handlers); i++)
+		pcf50633_free_irq(mbc->pcf, mbc_irq_handlers[i]);
+
+	power_supply_unregister(&mbc->usb);
+	power_supply_unregister(&mbc->adapter);
+
+	kfree(mbc);
+
+	return 0;
+}
+
+static struct platform_driver pcf50633_mbc_driver = {
+	.driver = {
+		.name = "pcf50633-mbc",
+	},
+	.probe = pcf50633_mbc_probe,
+	.remove = __devexit_p(pcf50633_mbc_remove),
+};
+
+static int __init pcf50633_mbc_init(void)
+{
+	return platform_driver_register(&pcf50633_mbc_driver);
+}
+module_init(pcf50633_mbc_init);
+
+static void __exit pcf50633_mbc_exit(void)
+{
+	platform_driver_unregister(&pcf50633_mbc_driver);
+}
+module_exit(pcf50633_mbc_exit);
+
+MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
+MODULE_DESCRIPTION("PCF50633 mbc driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:pcf50633-mbc");
diff --git a/include/linux/mfd/pcf50633/mbc.h b/include/linux/mfd/pcf50633/mbc.h
new file mode 100644
index 0000000..6e17619
--- /dev/null
+++ b/include/linux/mfd/pcf50633/mbc.h
@@ -0,0 +1,134 @@
+/*
+ * mbc.h  -- Driver for NXP PCF50633 Main Battery Charger
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#ifndef __LINUX_MFD_PCF50633_MBC_H
+#define __LINUX_MFD_PCF50633_MBC_H
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/platform_device.h>
+
+#define PCF50633_REG_MBCC1	0x43
+#define PCF50633_REG_MBCC2	0x44
+#define PCF50633_REG_MBCC3	0x45
+#define PCF50633_REG_MBCC4	0x46
+#define PCF50633_REG_MBCC5	0x47
+#define PCF50633_REG_MBCC6	0x48
+#define PCF50633_REG_MBCC7	0x49
+#define PCF50633_REG_MBCC8	0x4a
+#define PCF50633_REG_MBCS1	0x4b
+#define PCF50633_REG_MBCS2	0x4c
+#define PCF50633_REG_MBCS3	0x4d
+
+enum pcf50633_reg_mbcc1 {
+	PCF50633_MBCC1_CHGENA		= 0x01,	/* Charger enable */
+	PCF50633_MBCC1_AUTOSTOP		= 0x02,
+	PCF50633_MBCC1_AUTORES		= 0x04, /* automatic resume */
+	PCF50633_MBCC1_RESUME		= 0x08, /* explicit resume cmd */
+	PCF50633_MBCC1_RESTART		= 0x10, /* restart charging */
+	PCF50633_MBCC1_PREWDTIME_60M	= 0x20,	/* max. precharging time */
+	PCF50633_MBCC1_WDTIME_1H	= 0x00,
+	PCF50633_MBCC1_WDTIME_2H	= 0x40,
+	PCF50633_MBCC1_WDTIME_4H	= 0x80,
+	PCF50633_MBCC1_WDTIME_6H	= 0xc0,
+};
+#define PCF50633_MBCC1_WDTIME_MASK	  0xc0
+
+enum pcf50633_reg_mbcc2 {
+	PCF50633_MBCC2_VBATCOND_2V7	= 0x00,
+	PCF50633_MBCC2_VBATCOND_2V85	= 0x01,
+	PCF50633_MBCC2_VBATCOND_3V0	= 0x02,
+	PCF50633_MBCC2_VBATCOND_3V15	= 0x03,
+	PCF50633_MBCC2_VMAX_4V		= 0x00,
+	PCF50633_MBCC2_VMAX_4V20	= 0x28,
+	PCF50633_MBCC2_VRESDEBTIME_64S	= 0x80,	/* debounce time (32/64sec) */
+};
+
+enum pcf50633_reg_mbcc7 {
+	PCF50633_MBCC7_USB_100mA	= 0x00,
+	PCF50633_MBCC7_USB_500mA	= 0x01,
+	PCF50633_MBCC7_USB_1000mA	= 0x02,
+	PCF50633_MBCC7_USB_SUSPEND	= 0x03,
+	PCF50633_MBCC7_BATTEMP_EN	= 0x04,
+	PCF50633_MBCC7_BATSYSIMAX_1A6	= 0x00,
+	PCF50633_MBCC7_BATSYSIMAX_1A8	= 0x40,
+	PCF50633_MBCC7_BATSYSIMAX_2A0	= 0x80,
+	PCF50633_MBCC7_BATSYSIMAX_2A2	= 0xc0,
+};
+#define PCF50633_MBCC7_USB_MASK 0x03
+
+enum pcf50633_reg_mbcc8 {
+	PCF50633_MBCC8_USBENASUS	= 0x10,
+};
+
+enum pcf50633_reg_mbcs1 {
+	PCF50633_MBCS1_USBPRES		= 0x01,
+	PCF50633_MBCS1_USBOK		= 0x02,
+	PCF50633_MBCS1_ADAPTPRES	= 0x04,
+	PCF50633_MBCS1_ADAPTOK		= 0x08,
+	PCF50633_MBCS1_TBAT_OK		= 0x00,
+	PCF50633_MBCS1_TBAT_ABOVE	= 0x10,
+	PCF50633_MBCS1_TBAT_BELOW	= 0x20,
+	PCF50633_MBCS1_TBAT_UNDEF	= 0x30,
+	PCF50633_MBCS1_PREWDTEXP	= 0x40,
+	PCF50633_MBCS1_WDTEXP		= 0x80,
+};
+
+enum pcf50633_reg_mbcs2_mbcmod {
+	PCF50633_MBCS2_MBC_PLAY		= 0x00,
+	PCF50633_MBCS2_MBC_USB_PRE	= 0x01,
+	PCF50633_MBCS2_MBC_USB_PRE_WAIT	= 0x02,
+	PCF50633_MBCS2_MBC_USB_FAST	= 0x03,
+	PCF50633_MBCS2_MBC_USB_FAST_WAIT = 0x04,
+	PCF50633_MBCS2_MBC_USB_SUSPEND	= 0x05,
+	PCF50633_MBCS2_MBC_ADP_PRE	= 0x06,
+	PCF50633_MBCS2_MBC_ADP_PRE_WAIT	= 0x07,
+	PCF50633_MBCS2_MBC_ADP_FAST	= 0x08,
+	PCF50633_MBCS2_MBC_ADP_FAST_WAIT = 0x09,
+	PCF50633_MBCS2_MBC_BAT_FULL	= 0x0a,
+	PCF50633_MBCS2_MBC_HALT		= 0x0b,
+};
+#define PCF50633_MBCS2_MBC_MASK		0x0f
+enum pcf50633_reg_mbcs2_chgstat {
+	PCF50633_MBCS2_CHGS_NONE	= 0x00,
+	PCF50633_MBCS2_CHGS_ADAPTER	= 0x10,
+	PCF50633_MBCS2_CHGS_USB		= 0x20,
+	PCF50633_MBCS2_CHGS_BOTH	= 0x30,
+};
+#define PCF50633_MBCS2_RESSTAT_AUTO	0x40
+
+enum pcf50633_reg_mbcs3 {
+	PCF50633_MBCS3_USBLIM_PLAY	= 0x01,
+	PCF50633_MBCS3_USBLIM_CGH	= 0x02,
+	PCF50633_MBCS3_TLIM_PLAY	= 0x04,
+	PCF50633_MBCS3_TLIM_CHG		= 0x08,
+	PCF50633_MBCS3_ILIM		= 0x10,	/* 1: Ibat > Icutoff */
+	PCF50633_MBCS3_VLIM		= 0x20,	/* 1: Vbat == Vmax */
+	PCF50633_MBCS3_VBATSTAT		= 0x40,	/* 1: Vbat > Vbatcond */
+	PCF50633_MBCS3_VRES		= 0x80, /* 1: Vbat > Vth(RES) */
+};
+
+#define PCF50633_MBCC2_VBATCOND_MASK	  0x03
+#define PCF50633_MBCC2_VMAX_MASK	  0x3c
+
+/* Charger status */
+#define PCF50633_MBC_USB_ONLINE		0x01
+#define PCF50633_MBC_USB_ACTIVE		0x02
+#define PCF50633_MBC_ADAPTER_ONLINE	0x04
+#define PCF50633_MBC_ADAPTER_ACTIVE	0x08
+
+int pcf50633_mbc_usb_curlim_set(struct pcf50633 *pcf, int ma);
+
+int pcf50633_mbc_get_status(struct pcf50633 *);
+void pcf50633_mbc_set_status(struct pcf50633 *, int what, int status);
+
+#endif
+

