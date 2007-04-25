Return-Path: <linux-kernel-owner+w=401wt.eu-S1031152AbXDYPxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031152AbXDYPxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031108AbXDYPxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:53:35 -0400
Received: from mx3.mail.ru ([194.67.23.149]:9395 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031150AbXDYPxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:53:30 -0400
Date: Wed, 25 Apr 2007 19:50:36 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 2/7] pda power driver
Message-ID: <20070425155036.GB4117@zarina>
References: <20070425154820.GA27300@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425154820.GA27300@zarina>
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

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/Kconfig     |    8 ++
 drivers/power/Makefile    |    1 +
 drivers/power/pda_power.c |  239 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pda_power.h |   28 +++++
 4 files changed, 276 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/pda_power.c
 create mode 100644 include/linux/pda_power.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 17349c1..b87779e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -10,4 +10,12 @@ config EXTERNAL_POWER
 
 	  This interface is mandatory for battery class support.
 
+config PDA_POWER
+	tristate "Generic PDA/phone power driver"
+	depends on EXTERNAL_POWER
+	help
+	  Say Y here to enable generic power driver for PDAs and phones with
+	  one or two external power supplies (AC/USB) connected to main and
+	  backup batteries, and optional builtin charger.
+
 endmenu
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index c303b45..6f084e7 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_EXTERNAL_POWER)  += external_power.o
+obj-$(CONFIG_PDA_POWER)       += pda_power.o
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
new file mode 100644
index 0000000..2a22687
--- /dev/null
+++ b/drivers/power/pda_power.c
@@ -0,0 +1,239 @@
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
+#include <linux/external_power.h>
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
+static int pda_power_is_ac_online(struct power_supply *psy)
+{
+	return pdata->is_ac_online ? pdata->is_ac_online() : 0;
+}
+
+static int pda_power_is_usb_online(struct power_supply *psy)
+{
+	return pdata->is_usb_online ? pdata->is_usb_online() : 0;
+}
+
+static char *pda_power_supplied_to[] = {
+	"main-battery",
+	"backup-battery",
+};
+
+static struct power_supply pda_power_supplies[] = {
+	{
+		.name = "ac",
+		.type = "ac",
+		.supplied_to = pda_power_supplied_to,
+		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+		.is_online = pda_power_is_ac_online,
+	},
+	{
+		.name = "usb",
+		.type = "dc",
+		.supplied_to = pda_power_supplied_to,
+		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
+		.is_online = pda_power_is_usb_online,
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
+		pdata->wait_for_status = 500;
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

