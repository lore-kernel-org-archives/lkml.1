Return-Path: <linux-kernel-owner+w=401wt.eu-S1753676AbXDKX2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbXDKX2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161395AbXDKX2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:28:24 -0400
Received: from fallback.mail.ru ([194.67.57.14]:16024 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbXDKX2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:28:23 -0400
Date: Thu, 12 Apr 2007 03:24:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Message-ID: <20070411232456.GB20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This driver used to stop code/logic duplication through different
machines we porting at handhelds.org. pda_power register machs' power
supplies, and will take care about notifying batteries about power
changes through external power interface.

This driver should be suitable for almost every Linux gadget today.


Here is brief example how we use it:

static int h5000_is_ac_online(void)
{
        return !!(samcop_get_gpio_a(&h5400_samcop.dev) &
                 SAMCOP_GPIO_GPA_ADP_IN_STATUS);
}

static int h5000_is_usb_online(void)
{
        return !!(samcop_get_gpio_a(&h5400_samcop.dev) &
                 SAMCOP_GPIO_GPA_USB_DETECT);
}

static void h5000_set_charge(int flags)
{
        SET_H5400_GPIO(CHG_EN, !!flags);
        SET_H5400_GPIO(EXT_CHG_RATE, !!(flags & PDA_POWER_CHARGE_AC));
        SET_H5400_GPIO(USB_CHG_RATE, !!(flags & PDA_POWER_CHARGE_USB));
        return;
}

static struct pda_power_pdata h5000_power_pdata = {
        .is_ac_online = h5000_is_ac_online,
        .is_usb_online = h5000_is_usb_online,
        .set_charge = h5000_set_charge,
};

static struct resource h5000_power_resourses[] = {
        [0] = {
                .name = "ac",
                .flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE |
                         IORESOURCE_IRQ_LOWEDGE,
        },
        [1] = {
                .name = "usb",
                .flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE |
                         IORESOURCE_IRQ_LOWEDGE,
        },
};

static struct platform_device h5000_power_pdev = {
        .name = "pda-power",
        .id = -1,
        .resource = h5000_power_resourses,
        .num_resources = ARRAY_SIZE(h5000_power_resourses),
        .dev = {
                .platform_data = &h5000_power_pdata,
        },
};

---
 drivers/power/Kconfig     |    8 ++
 drivers/power/Makefile    |    1 +
 drivers/power/pda_power.c |  218 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pda_power.h |   27 ++++++
 4 files changed, 254 insertions(+), 0 deletions(-)
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
index 0000000..0256ee4
--- /dev/null
+++ b/drivers/power/pda_power.c
@@ -0,0 +1,218 @@
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
+#include <linux/pda_power.h>
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
+	else if (pdata->is_ac_online && pdata->is_usb_online()) {
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
+static irqreturn_t power_changed_isr(int irq, void *unused)
+{
+	if (ac_irq && irq == ac_irq->start) {
+		power_supply_changed(&pda_power_supplies[0]);
+	}
+	else if (usb_irq && irq == usb_irq->start) {
+		power_supply_changed(&pda_power_supplies[1]);
+	}
+	else {
+		printk(KERN_WARNING "pda_power: spurious irq %d", irq);
+		return IRQ_HANDLED;
+	}
+
+	update_charger();
+
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
+	pdata = pdev->dev.platform_data;
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
index 0000000..12d46dd
--- /dev/null
+++ b/include/linux/pda_power.h
@@ -0,0 +1,27 @@
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
+#include <linux/external_power.h>
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
