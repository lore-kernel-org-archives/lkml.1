Return-Path: <linux-kernel-owner+w=401wt.eu-S1767429AbXECVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767429AbXECVgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767447AbXECVgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:36:40 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4226 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767439AbXECVgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:36:36 -0400
Date: Fri, 4 May 2007 01:33:03 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 8/8] One Laptop Per Child power/battery driver
Message-ID: <20070503213303.GH20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This probably should be marked as BROKEN because, according
to David Woodhouse, EC-acccess method will change. Plus currently
it lacks mutexes. So this driver is just for reference. Converted
from the battery-2.6 repository, 1:1.

But nevertheless it should work.

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/Kconfig        |    6 +
 drivers/power/Makefile       |    1 +
 drivers/power/olpc_battery.c |  300 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 307 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/olpc_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 051724f..3ac79c3 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -42,4 +42,10 @@ config BATTERY_PMU
 	  Say Y here to expose battery information on Apple machines
 	  through the generic battery class.
 
+config BATTERY_OLPC
+	tristate "One Laptop Per Child battery"
+	depends on X86_32
+	help
+	  Say Y to enable support for the battery on the $100 laptop.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 0ebdc6d..62b58ca 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_APM_POWER)            += apm_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
 obj-$(CONFIG_BATTERY_PMU)          += pmu_battery.o
+obj-$(CONFIG_BATTERY_OLPC)         += olpc_battery.o
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
new file mode 100644
index 0000000..40f76bb
--- /dev/null
+++ b/drivers/power/olpc_battery.c
@@ -0,0 +1,300 @@
+/*
+ * Battery driver for One Laptop Per Child ($100 laptop) board.
+ *
+ *	Copyright © 2006  David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <asm/io.h>
+
+#define wBAT_VOLTAGE     0xf900  /* *9.76/32,    mV   */
+#define wBAT_CURRENT     0xf902  /* *15.625/120, mA   */
+#define wBAT_TEMP        0xf906  /* *256/1000,   °C  */
+#define wAMB_TEMP        0xf908  /* *256/1000,   °C  */
+#define SOC              0xf910  /* percentage        */
+#define sMBAT_STATUS     0xfaa4
+#define	sBAT_PRESENT          1
+#define	sBAT_FULL             2
+#define	sBAT_DESTROY          4  /* what is this exactly? */
+#define	sBAT_LOW             32
+#define	sBAT_DISCHG          64
+#define sMCHARGE_STATUS  0xfaa5
+#define	sBAT_CHARGE           1
+#define	sBAT_OVERTEMP         4
+#define	sBAT_NiMH             8
+#define sPOWER_FLAG      0xfa40
+#define	ADAPTER_IN            1
+
+/*********************************************************************
+ *		EC locking and access
+ *********************************************************************/
+
+static int lock_ec(void)
+{
+	unsigned long timeo = jiffies + HZ / 20;
+
+	while (1) {
+		unsigned char lock = inb(0x6c) & 0x80;
+		if (!lock)
+			return 0;
+		if (time_after(jiffies, timeo)) {
+			printk(KERN_ERR "olpc_battery: failed to lock EC for "
+			       "battery access\n");
+			return 1;
+		}
+		yield();
+	}
+}
+
+static void unlock_ec(void)
+{
+	outb(0xff, 0x6c);
+	return;
+}
+
+static unsigned char read_ec_byte(unsigned short adr)
+{
+	outb(adr >> 8, 0x381);
+	outb(adr, 0x382);
+	return inb(0x383);
+}
+
+static unsigned short read_ec_word(unsigned short adr)
+{
+	return (read_ec_byte(adr) << 8) | read_ec_byte(adr + 1);
+}
+
+/*********************************************************************
+ *		Power
+ *********************************************************************/
+
+static int olpc_ac_get_prop(struct power_supply *psy,
+                            enum power_supply_property psp,
+                            union power_supply_propval *val)
+{
+	int ret = 0;
+
+	if (lock_ec())
+		return -EIO;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (!(read_ec_byte(sMBAT_STATUS) & sBAT_PRESENT)) {
+			ret = -ENODEV;
+			goto out;
+		}
+		val->intval = !!(read_ec_byte(sPOWER_FLAG) & ADAPTER_IN);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	unlock_ec();
+	return ret;
+}
+
+static enum power_supply_property olpc_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static struct power_supply olpc_ac = {
+	.name = "olpc-ac",
+	.type = POWER_SUPPLY_TYPE_AC,
+	.properties = olpc_ac_props,
+	.num_properties = ARRAY_SIZE(olpc_ac_props),
+	.get_property = olpc_ac_get_prop,
+};
+
+/*********************************************************************
+ *		Battery properties
+ *********************************************************************/
+
+static int olpc_bat_get_property(struct power_supply *psy,
+                                 enum power_supply_property psp,
+                                 union power_supply_propval *val)
+{
+	int ret = 0;
+
+	if (lock_ec())
+		return -EIO;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		{
+			int status = POWER_SUPPLY_STATUS_UNKNOWN;
+
+			val->intval = read_ec_byte(sMBAT_STATUS);
+
+			if (!(val->intval & sBAT_PRESENT)) {
+				ret = -ENODEV;
+				goto out;
+			}
+
+			if (val->intval & sBAT_DISCHG)
+				status = POWER_SUPPLY_STATUS_DISCHARGING;
+			else if (val->intval & sBAT_FULL)
+				status = POWER_SUPPLY_STATUS_FULL;
+
+			val->intval = read_ec_byte(sMCHARGE_STATUS);
+			if (val->intval & sBAT_CHARGE)
+				status = POWER_SUPPLY_STATUS_CHARGING;
+
+			val->intval = status;
+			break;
+		}
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = !!(read_ec_byte(sMBAT_STATUS) & sBAT_PRESENT);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = read_ec_byte(sMCHARGE_STATUS);
+		if (val->intval & sBAT_OVERTEMP)
+			val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		else
+			val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = read_ec_byte(sMCHARGE_STATUS);
+		if (val->intval & sBAT_NiMH)
+			val->intval = POWER_SUPPLY_TECHNOLOGY_NIMH;
+		else
+			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval = read_ec_byte(wBAT_VOLTAGE) * 9760L / 32;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = read_ec_byte(wBAT_CURRENT) * 15625L / 120;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = read_ec_byte(SOC);
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		val->intval = read_ec_byte(sMBAT_STATUS);
+		if (val->intval & sBAT_FULL)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+		else if (val->intval & sBAT_LOW)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
+		else
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+		break;
+	case POWER_SUPPLY_PROP_TEMP:
+		val->intval = read_ec_byte(wBAT_TEMP) * 256 / 100;
+		break;
+	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
+		val->intval = read_ec_byte(wAMB_TEMP) * 256 / 100;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	unlock_ec();
+	return ret;
+}
+
+static enum power_supply_property olpc_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
+	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+};
+
+/*********************************************************************
+ *		Initialisation
+ *********************************************************************/
+
+static struct platform_device *bat_pdev;
+
+static struct power_supply olpc_bat = {
+	.properties = olpc_bat_props,
+	.num_properties = ARRAY_SIZE(olpc_bat_props),
+	.get_property = olpc_bat_get_property,
+	.use_for_apm = 1,
+};
+
+static int __init olpc_bat_init(void)
+{
+	int ret = 0;
+	unsigned short tmp;
+
+	if (!request_region(0x380, 4, "olpc-battery")) {
+		ret = -EIO;
+		goto region_failed;
+	}
+
+	if (lock_ec()) {
+		ret = -EIO;
+		goto lock_failed;
+	}
+
+	tmp = read_ec_word(0xfe92);
+	unlock_ec();
+
+	if (tmp != 0x380) {
+		/* Doesn't look like OLPC EC */
+		ret = -ENODEV;
+		goto not_olpc_ec;
+	}
+
+	bat_pdev = platform_device_register_simple("olpc-battery", 0, NULL, 0);
+	if (IS_ERR(bat_pdev)) {
+		ret = PTR_ERR(bat_pdev);
+		goto pdev_failed;
+	}
+
+	ret = power_supply_register(&bat_pdev->dev, &olpc_ac);
+	if (ret)
+		goto ac_failed;
+
+	olpc_bat.name = bat_pdev->name;
+
+	ret = power_supply_register(&bat_pdev->dev, &olpc_bat);
+	if (ret)
+		goto battery_failed;
+
+	goto success;
+
+battery_failed:
+	power_supply_unregister(&olpc_ac);
+ac_failed:
+	platform_device_unregister(bat_pdev);
+pdev_failed:
+not_olpc_ec:
+lock_failed:
+	release_region(0x380, 4);
+region_failed:
+success:
+	return ret;
+}
+
+static void __exit olpc_bat_exit(void)
+{
+	power_supply_unregister(&olpc_bat);
+	power_supply_unregister(&olpc_ac);
+	platform_device_unregister(bat_pdev);
+	release_region(0x380, 4);
+	return;
+}
+
+module_init(olpc_bat_init);
+module_exit(olpc_bat_exit);
+
+MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Battery driver for One Laptop Per Child "
+                   "($100 laptop) board.");
-- 
1.5.1.1-dirty
