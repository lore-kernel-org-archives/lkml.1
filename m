Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbXDMNxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbXDMNxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbXDMNxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:53:35 -0400
Received: from mx34.mail.ru ([194.67.23.200]:1193 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbXDMNxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:53:23 -0400
Date: Fri, 13 Apr 2007 17:50:01 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070413135001.GD20618@zarina>
Reply-To: cbou@mail.ru
References: <20070411232456.GB20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232456.GB20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:24:56AM +0400, Anton Vorontsov wrote:
> This driver used to stop code/logic duplication through different
> machines we porting at handhelds.org. pda_power register machs' power
> supplies, and will take care about notifying batteries about power
> changes through external power interface.
> 
> This driver should be suitable for almost every Linux gadget today.

Changes:

- implement timer, it's used for two purposes:
   1) on some machines you can't read is_{ac,usb}_online() values just
      after interrupt. Should wait a bit to read reliable values.
   2) irq debouncing

- cleanups


Subject: [PATCH] [take2] pda_power driver


Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/Kconfig     |    8 ++
 drivers/power/Makefile    |    1 +
 drivers/power/pda_power.c |  231 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pda_power.h |   25 +++++
 4 files changed, 265 insertions(+), 0 deletions(-)
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
index 0000000..ae90bd7
--- /dev/null
+++ b/drivers/power/pda_power.c
@@ -0,0 +1,231 @@
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
+
+/*
+ * include/linux/ioport.h does not provide flags for generic IRQ trigger
+ * types. So, we're using "ISA PnP IRQ specific bits", and converting them.
+ */
+static unsigned int get_irq_flags(struct resource *res)
+{
+	unsigned int flags = IRQF_DISABLED;
+
+	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
+		flags |= IRQF_TRIGGER_RISING;
+	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
+		flags |= IRQF_TRIGGER_FALLING;
+	if (res->flags & IORESOURCE_IRQ_HIGHLEVEL)
+		flags |= IRQF_TRIGGER_HIGH;
+	if (res->flags & IORESOURCE_IRQ_LOWLEVEL)
+		flags |= IRQF_TRIGGER_LOW;
+	if (res->flags & IORESOURCE_IRQ_SHAREABLE)
+		flags |= IRQF_SHARED;
+
+	return flags;
+}
+
+static struct resource *ac_irq, *usb_irq;
+static struct pda_power_pdata *pdata;
+static struct timer_list isr_timer;
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
+		pr_debug("pda_power: charger on (AC)\n");
+		pdata->set_charge(PDA_POWER_CHARGE_AC);
+	}
+	else if (pdata->is_usb_online && pdata->is_usb_online()) {
+		pr_debug("pda_power: charger on (USB)\n");
+		pdata->set_charge(PDA_POWER_CHARGE_USB);
+	}
+	else {
+		pr_debug("pda_power: charger off\n");
+		pdata->set_charge(0);
+	}
+
+	return;
+}
+
+static void isr_timer_func(unsigned long irq)
+{
+	if (ac_irq && irq == ac_irq->start) {
+		power_supply_changed(&pda_power_supplies[0]);
+	}
+	else if (usb_irq && irq == usb_irq->start) {
+		power_supply_changed(&pda_power_supplies[1]);
+	}
+	else {
+		printk(KERN_WARNING "pda_power: spurious irq %li", irq);
+		return;
+	}
+
+	update_charger();
+
+	return;
+}
+
+static irqreturn_t power_changed_isr(int irq, void *unused)
+{
+	isr_timer.data = irq;
+	mod_timer(&isr_timer, jiffies + HZ);
+	return IRQ_HANDLED;
+}
+
+static int pda_power_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	if (pdev->id != -1) {
+		printk(KERN_WARNING "pda_power: it's meaningless to "
+		       "register several pda_powers, use id = -1\n");
+		ret = -EINVAL;
+		goto wrongid;
+	}
+
+	pdata = pdev->dev.platform_data;
+
+	setup_timer(&isr_timer, isr_timer_func, 0);
+
+	ac_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "ac");
+	usb_irq = platform_get_resource_byname(pdev, IORESOURCE_IRQ, "usb");
+	if (!ac_irq && !usb_irq) {
+		printk(KERN_ERR "pda_power: no ac/usb irq specified\n");
+		ret = -ENODEV;
+		goto noirqs;
+	}
+
+	ret = power_supply_register(&pdev->dev, &pda_power_supplies[0]);
+	if (ret) {
+		printk(KERN_ERR "pda_power: failed to register %s power "
+		       "supply\n", pda_power_supplies[0].name);
+		goto supply0_failed;
+	}
+
+	ret = power_supply_register(&pdev->dev, &pda_power_supplies[1]);
+	if (ret) {
+		printk(KERN_ERR "pda_power: failed to register %s power "
+		       "supply\n", pda_power_supplies[1].name);
+		goto supply1_failed;
+	}
+
+	if (ac_irq) {
+		ret = request_irq(ac_irq->start, power_changed_isr,
+		           get_irq_flags(ac_irq), ac_irq->name, NULL);
+		if (ret) {
+			printk(KERN_ERR "pda_power: request ac irq failed\n");
+			goto ac_irq_failed;
+		}
+	}
+
+	if (usb_irq) {
+		ret = request_irq(usb_irq->start, power_changed_isr,
+		           get_irq_flags(ac_irq), usb_irq->name, NULL);
+		if (ret) {
+			printk(KERN_ERR "pda_power: request usb irq failed\n");
+			goto usb_irq_failed;
+		}
+	}
+
+	update_charger();
+
+	goto success;
+
+usb_irq_failed:
+	if (ac_irq)
+		free_irq(ac_irq->start, NULL);
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
+		free_irq(usb_irq->start, NULL);
+	if (ac_irq)
+		free_irq(ac_irq->start, NULL);
+	del_timer_sync(&isr_timer);
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
index 0000000..0d414a8
--- /dev/null
+++ b/include/linux/pda_power.h
@@ -0,0 +1,25 @@
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
+};
+
+#endif /* __PDA_POWER_H__ */
-- 
1.5.0.5-dirty

