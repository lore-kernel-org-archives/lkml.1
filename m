Return-Path: <linux-kernel-owner+w=401wt.eu-S1767432AbXECVgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767432AbXECVgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767429AbXECVgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:36:02 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4206 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767438AbXECVf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:35:59 -0400
Date: Fri, 4 May 2007 01:32:09 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 4/8] pda power driver
Message-ID: <20070503213145.GD20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Common power driver for PDAs and phones with one or two external
power supplies (AC/USB) connected to main and backup batteries,
and optional builtin charger.

It's used to stop logic duplication through different embedded
devices. So, power supply *logic* is here. pda_power register
power supplies, and will take care about notifying batteries
about power changes through external power interface.

AC/USB power consumption issues should be handled by platform
code, inside set_charge function.

Signed-off-by: Roman Moravcik <roman.moravcik@gmail.com>
Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/Kconfig     |    7 ++
 drivers/power/Makefile    |    2 +
 drivers/power/pda_power.c |  256 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pda_power.h |   28 +++++
 4 files changed, 293 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/pda_power.c
 create mode 100644 include/linux/pda_power.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7811fa6..cc70644 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -14,4 +14,11 @@ config POWER_SUPPLY_DEBUG
 	  Say Y here to enable debugging messages for power supply class
 	  and drivers.
 
+config PDA_POWER
+	tristate "Generic PDA/phone power driver"
+	help
+	  Say Y here to enable generic power driver for PDAs and phones with
+	  one or two external power supplies (AC/USB) connected to main and
+	  backup batteries, and optional builtin charger.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 95085ba..1808b69 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -13,3 +13,5 @@ EXTRA_CFLAGS += -DDEBUG
 endif
 
 obj-$(CONFIG_POWER_SUPPLY)         += power_supply.o
+
+obj-$(CONFIG_PDA_POWER)            += pda_power.o
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
new file mode 100644
index 0000000..a36936e
--- /dev/null
+++ b/drivers/power/pda_power.c
@@ -0,0 +1,256 @@
+/*
+ * Common power driver for PDAs and phones with one or two external
+ * power supplies (AC/USB) connected to main and backup batteries,
+ * and optional builtin charger.
+ *
+ * Copyright 2007 Anton Vorontsov <cbou@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/power_supply.h>
+#include <linux/pda_power.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+
+static inline unsigned int get_irq_flags(struct resource *res)
+{
+	unsigned int flags = IRQF_DISABLED | IRQF_SHARED;
+
+	flags |= res->flags & IRQF_TRIGGER_MASK;
+
+	return flags;
+}
+
+static struct device *dev;
+static struct pda_power_pdata *pdata;
+static struct resource *ac_irq, *usb_irq;
+static struct timer_list charger_timer;
+static struct timer_list supply_timer;
+
+static int pda_power_get_property(struct power_supply *psy,
+                                  enum power_supply_property psp,
+                                  union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (psy->type == POWER_SUPPLY_TYPE_AC)
+			val->intval = pdata->is_ac_online ?
+			              pdata->is_ac_online() : 0;
+		else
+			val->intval = pdata->is_usb_online ?
+			              pdata->is_usb_online() : 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static enum power_supply_property pda_power_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static char *pda_power_supplied_to[] = {
+	"main-battery",
+	"backup-battery",
+};
+
+static struct power_supply pda_power_supplies[] = {
+	{
+		.name = "ac",
+		.type = POWER_SUPPLY_TYPE_AC,
+		.supplied_to = pda_power_supplied_to,
+		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+		.properties = pda_power_props,
+		.num_properties = ARRAY_SIZE(pda_power_props),
+		.get_property = pda_power_get_property,
+	},
+	{
+		.name = "usb",
+		.type = POWER_SUPPLY_TYPE_USB,
+		.supplied_to = pda_power_supplied_to,
+		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+		.properties = pda_power_props,
+		.num_properties = ARRAY_SIZE(pda_power_props),
+		.get_property = pda_power_get_property,
+	},
+};
+
+static void update_charger(void)
+{
+	if (!pdata->set_charge)
+		return;
+
+	if (pdata->is_ac_online && pdata->is_ac_online()) {
+		dev_dbg(dev, "charger on (AC)\n");
+		pdata->set_charge(PDA_POWER_CHARGE_AC);
+	}
+	else if (pdata->is_usb_online && pdata->is_usb_online()) {
+		dev_dbg(dev, "charger on (USB)\n");
+		pdata->set_charge(PDA_POWER_CHARGE_USB);
+	}
+	else {
+		dev_dbg(dev, "charger off\n");
+		pdata->set_charge(0);
+	}
+
+	return;
+}
+
+static void supply_timer_func(unsigned long irq)
+{
+	if (ac_irq && irq == ac_irq->start)
+		power_supply_changed(&pda_power_supplies[0]);
+	else if (usb_irq && irq == usb_irq->start)
+		power_supply_changed(&pda_power_supplies[1]);
+	return;
+}
+
+static void charger_timer_func(unsigned long irq)
+{
+	update_charger();
+
+	/* Okay, charger set. Now wait a bit before notifying supplicants,
+	 * charge power should stabilize. */
+	supply_timer.data = irq;
+	mod_timer(&supply_timer,
+	          jiffies + msecs_to_jiffies(pdata->wait_for_charger));
+	return;
+}
+
+static irqreturn_t power_changed_isr(int irq, void *unused)
+{
+	/* Wait a bit before reading ac/usb line status and setting charger,
+	 * because ac/usb status readings may lag from irq. */
+	charger_timer.data = irq;
+	mod_timer(&charger_timer,
+	          jiffies + msecs_to_jiffies(pdata->wait_for_status));
+	return IRQ_HANDLED;
+}
+
+static int pda_power_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	dev = &pdev->dev;
+
+	if (pdev->id != -1) {
+		dev_err(dev, "it's meaningless to register several "
+		        "pda_powers, use id = -1\n");
+		ret = -EINVAL;
+		goto wrongid;
+	}
+
+	pdata = pdev->dev.platform_data;
+
+	update_charger();
+
+	if (!pdata->wait_for_status)
+		pdata->wait_for_status = 500;
+
+	if (!pdata->wait_for_charger)
+		pdata->wait_for_charger = 500;
+
+	setup_timer(&charger_timer, charger_timer_func, 0);
+	setup_timer(&supply_timer, supply_timer_func, 0);
+
+	ac_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "ac");
+	usb_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "usb");
+	if (!ac_irq && !usb_irq) {
+		dev_err(dev, "no ac/usb irq specified\n");
+		ret = -ENODEV;
+		goto noirqs;
+	}
+
+	ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
+	if (ret) {
+		dev_err(dev, "failed to register %s power supply\n",
+		        pda_power_supplies[0].name);
+		goto supply0_failed;
+	}
+
+	ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
+	if (ret) {
+		dev_err(dev, "failed to register %s power supply\n",
+		        pda_power_supplies[1].name);
+		goto supply1_failed;
+	}
+
+	if (ac_irq) {
+		ret = request_irq(ac_irq->start, power_changed_isr,
+		                  get_irq_flags(ac_irq), ac_irq->name,
+		                  &pda_power_supplies[0]);
+		if (ret) {
+			dev_err(dev, "request ac irq failed\n");
+			goto ac_irq_failed;
+		}
+	}
+
+	if (usb_irq) {
+		ret = request_irq(usb_irq->start, power_changed_isr,
+		                  get_irq_flags(usb_irq), usb_irq->name,
+		                  &pda_power_supplies[1]);
+		if (ret) {
+			dev_err(dev, "request usb irq failed\n");
+			goto usb_irq_failed;
+		}
+	}
+
+	goto success;
+
+usb_irq_failed:
+	if (ac_irq)
+		free_irq(ac_irq->start, &pda_power_supplies[0]);
+ac_irq_failed:
+	power_supply_unregister(&pda_power_supplies[1]);
+supply1_failed:
+	power_supply_unregister(&pda_power_supplies[0]);
+supply0_failed:
+noirqs:
+wrongid:
+success:
+	return ret;
+}
+
+static int pda_power_remove(struct platform_device *pdev)
+{
+	if (usb_irq)
+		free_irq(usb_irq->start, &pda_power_supplies[1]);
+	if (ac_irq)
+		free_irq(ac_irq->start, &pda_power_supplies[0]);
+	del_timer_sync(&charger_timer);
+	del_timer_sync(&supply_timer);
+	power_supply_unregister(&pda_power_supplies[1]);
+	power_supply_unregister(&pda_power_supplies[0]);
+	return 0;
+}
+
+static struct platform_driver pda_power_pdrv = {
+	.driver = {
+		.name = "pda-power",
+	},
+	.probe = pda_power_probe,
+	.remove = pda_power_remove,
+};
+
+static int __init pda_power_init(void)
+{
+	return platform_driver_register(&pda_power_pdrv);
+}
+
+static void __exit pda_power_exit(void)
+{
+	platform_driver_unregister(&pda_power_pdrv);
+	return;
+}
+
+module_init(pda_power_init);
+module_exit(pda_power_exit);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Anton Vorontsov <cbou@mail.ru>");
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
new file mode 100644
index 0000000..77e673c
--- /dev/null
+++ b/include/linux/pda_power.h
@@ -0,0 +1,28 @@
+/*
+ * Common power driver for PDAs and phones with one or two external
+ * power supplies (AC/USB) connected to main and backup batteries,
+ * and optional builtin charger.
+ *
+ * Copyright 2007 Anton Vorontsov <cbou@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PDA_POWER_H__
+#define __PDA_POWER_H__
+
+#define PDA_POWER_CHARGE_AC  (1 << 0)
+#define PDA_POWER_CHARGE_USB (1 << 1)
+
+struct pda_power_pdata {
+	int (*is_ac_online)(void);
+	int (*is_usb_online)(void);
+	void (*set_charge)(int flags);
+
+	unsigned int wait_for_status; /* msecs, default is 500 */
+	unsigned int wait_for_charger; /* msecs, default is 500 */
+};
+
+#endif /* __PDA_POWER_H__ */
-- 
1.5.1.1-dirty

