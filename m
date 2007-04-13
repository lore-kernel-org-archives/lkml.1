Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXDMNxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXDMNxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbXDMNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:53:14 -0400
Received: from mx34.mail.ru ([194.67.23.200]:12104 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753996AbXDMNxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:53:12 -0400
Date: Fri, 13 Apr 2007 17:49:47 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org
Subject: Re: [PATCH 1/7] [RFC] External power framework
Message-ID: <20070413134947.GB20618@zarina>
Reply-To: cbou@mail.ru
References: <20070411232446.GA20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232446.GA20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:24:46AM +0400, Anton Vorontsov wrote:
> External power framework - power supplies and power supplicants.
> 
> Supplicants (batteries so far) may ask to notify they when power supply
> arrive/gone. This framework used by battery class (next patches).
> 
> It's permitted for supply to be bound to several supplicants (think main
> and backup batteries).
> 
> It's also permitted for supplicants to consume power from several
> external supplies (say AC and USB).
> 
> Here is how it look like from userspace:
> 
> 	# pwd
> 	/sys/class/power_supply
> 	# ls
> 	ac  usb
> 	# cat ac/online usb/online
> 	1
> 	0

Cleaned up version based on comments from Randy Dunlap.

Subject: [PATCH] [take2] External power framework


Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/Kconfig                |    2 +
 drivers/Makefile               |    1 +
 drivers/power/Kconfig          |   13 ++
 drivers/power/Makefile         |    1 +
 drivers/power/external_power.c |  326 ++++++++++++++++++++++++++++++++++++++++
 include/linux/external_power.h |   54 +++++++
 6 files changed, 397 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/Kconfig
 create mode 100644 drivers/power/Makefile
 create mode 100644 drivers/power/external_power.c
 create mode 100644 include/linux/external_power.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 050323f..c546de3 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -54,6 +54,8 @@ source "drivers/spi/Kconfig"
 
 source "drivers/w1/Kconfig"
 
+source "drivers/power/Kconfig"
+
 source "drivers/hwmon/Kconfig"
 
 source "drivers/mfd/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 3a718f5..2bdaae7 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-$(CONFIG_I2C)		+= i2c/
 obj-$(CONFIG_W1)		+= w1/
+obj-$(CONFIG_EXTERNAL_POWER)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
new file mode 100644
index 0000000..17349c1
--- /dev/null
+++ b/drivers/power/Kconfig
@@ -0,0 +1,13 @@
+
+menu "External power support"
+
+config EXTERNAL_POWER
+	tristate "External power kernel interface"
+	help
+	  Say Y here to enable kernel external power detection interface,
+	  like AC or USB. Information also will exported to userspace via
+	  /sys/class/external_power/ directory.
+
+	  This interface is mandatory for battery class support.
+
+endmenu
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
new file mode 100644
index 0000000..c303b45
--- /dev/null
+++ b/drivers/power/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_EXTERNAL_POWER)  += external_power.o
diff --git a/drivers/power/external_power.c b/drivers/power/external_power.c
new file mode 100644
index 0000000..310ea4b
--- /dev/null
+++ b/drivers/power/external_power.c
@@ -0,0 +1,326 @@
+/*
+ * Linux kernel interface for external power suppliers/supplicants
+ *
+ * Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/device.h>
+#include <linux/rwsem.h>
+#include <linux/external_power.h>
+
+static struct class *power_supply_class;
+
+static LIST_HEAD(supplicants);
+static struct rw_semaphore supplicants_sem;
+
+struct bound_supply {
+	struct power_supply *psy;
+	struct list_head node;
+};
+
+struct bound_supplicant {
+	struct power_supplicant *pst;
+	struct list_head node;
+};
+
+int power_supplicant_am_i_supplied(struct power_supplicant *pst)
+{
+	int ret = 0;
+	struct bound_supply *bpsy;
+
+	pr_debug("%s\n", __FUNCTION__);
+	down(&power_supply_class->sem);
+	list_for_each_entry(bpsy, &pst->bound_supplies, node) {
+		if (bpsy->psy->is_online(bpsy->psy)) {
+			ret = 1;
+			goto out;
+		}
+	}
+out:
+	up(&power_supply_class->sem);
+
+	return ret;
+}
+
+static void unbind_pst_from_psys(struct power_supplicant *pst)
+{
+	struct bound_supply *bpsy, *bpsy_tmp;
+	struct bound_supplicant *bpst, *bpst_tmp;
+
+	list_for_each_entry_safe(bpsy, bpsy_tmp, &pst->bound_supplies, node) {
+		list_for_each_entry_safe(bpst, bpst_tmp,
+		                &bpsy->psy->bound_supplicants, node) {
+			if (bpst->pst == pst) {
+				list_del(&bpst->node);
+				kfree(bpst);
+				break;
+			}
+		}
+		list_del(&bpsy->node);
+		kfree(bpsy);
+	}
+
+	return;
+}
+
+static void unbind_psy_from_psts(struct power_supply *psy)
+{
+	struct bound_supply *bpsy, *bpsy_tmp;
+	struct bound_supplicant *bpst, *bpst_tmp;
+
+	list_for_each_entry_safe(bpst, bpst_tmp, &psy->bound_supplicants,
+	                                                              node) {
+		list_for_each_entry_safe(bpsy, bpsy_tmp,
+		                &bpst->pst->bound_supplies, node) {
+			if (bpsy->psy == psy) {
+				list_del(&bpsy->node);
+				kfree(bpsy);
+				break;
+			}
+		}
+		list_del(&bpst->node);
+		kfree(bpst);
+	}
+
+	return;
+}
+
+static int bind_pst_to_psy(struct power_supplicant *pst,
+                           struct power_supply *psy)
+{
+	struct bound_supplicant *bpst = kmalloc(sizeof(*bpst), GFP_KERNEL);
+	if (!bpst)
+		return -ENOMEM;
+	bpst->pst = pst;
+	list_add_tail(&bpst->node, &psy->bound_supplicants);
+	pr_debug("power: bound pst %s to psy %s\n", pst->name, psy->name);
+	return 0;
+}
+
+static int bind_psy_to_pst(struct power_supply *psy,
+                           struct power_supplicant *pst)
+{
+	struct bound_supply *bpsy = kmalloc(sizeof(*bpsy), GFP_KERNEL);
+	if (!bpsy)
+		return -ENOMEM;
+	bpsy->psy = psy;
+	list_add_tail(&bpsy->node, &pst->bound_supplies);
+	pr_debug("power: bound psy %s to pst %s\n", psy->name, pst->name);
+	return 0;
+}
+
+int power_supplicant_register(struct power_supplicant *pst)
+{
+	int ret = 0;
+	size_t i;
+	struct device *dev;
+	struct power_supply *psy;
+
+	INIT_LIST_HEAD(&pst->bound_supplies);
+
+	down_write(&supplicants_sem);
+	down(&power_supply_class->sem);
+
+	list_for_each_entry(dev, &power_supply_class->devices, node) {
+		psy = dev_get_drvdata(dev);
+		for (i = 0; i < psy->num_supplicants; i++) {
+			if (!strcmp(pst->name, psy->supplied_to[i])) {
+				ret = bind_pst_to_psy(pst, psy);
+				if (ret)
+					goto binding_failed;
+				ret = bind_psy_to_pst(psy, pst);
+				if (ret)
+					goto binding_failed;
+				break;
+			}
+		}
+	}
+
+	list_add_tail(&pst->node, &supplicants);
+
+	goto succeed;
+
+binding_failed:
+	unbind_pst_from_psys(pst);
+succeed:
+	up(&power_supply_class->sem);
+	up_write(&supplicants_sem);
+
+	return ret;
+}
+
+void power_supplicant_unregister(struct power_supplicant *pst)
+{
+	down_write(&supplicants_sem);
+	list_del(&pst->node);
+	up_write(&supplicants_sem);
+
+	down(&power_supply_class->sem);
+	unbind_pst_from_psys(pst);
+	up(&power_supply_class->sem);
+	return;
+}
+
+void power_supply_changed(struct power_supply *psy)
+{
+	struct bound_supplicant *bpst;
+
+	pr_debug("%s\n", __FUNCTION__);
+
+	list_for_each_entry(bpst, &psy->bound_supplicants, node)
+		bpst->pst->power_supply_changed(bpst->pst, psy);
+
+	return;
+}
+
+static ssize_t power_supply_show_online(struct device *dev,
+                                        struct device_attribute *attr,
+                                        char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", psy->is_online(psy));
+}
+
+static ssize_t power_supply_show_type(struct device *dev,
+                                      struct device_attribute *attr, char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	return sprintf(buf, "%s\n", psy->type ? psy->type : "unknown");
+}
+
+static ssize_t power_supply_show_nominal_voltage(struct device *dev,
+                                                 struct device_attribute *attr,
+                                                 char *buf)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+	return sprintf(buf, "%d\n", psy->nominal_voltage);
+}
+
+static DEVICE_ATTR(online, 0444, power_supply_show_online, NULL);
+static DEVICE_ATTR(type, 0444, power_supply_show_type, NULL);
+static DEVICE_ATTR(nominal_voltage, 0444, power_supply_show_nominal_voltage,
+                   NULL);
+
+int power_supply_register(struct device *parent,
+                            struct power_supply *psy)
+{
+	int ret = 0;
+	struct power_supplicant *pst;
+	size_t i;
+
+	INIT_LIST_HEAD(&psy->bound_supplicants);
+
+	psy->dev = device_create(power_supply_class, parent, 0, "%s",
+	                         psy->name);
+	if (IS_ERR(psy->dev)) {
+		ret = PTR_ERR(psy->dev);
+		goto dev_create_failed;
+	}
+
+	dev_set_drvdata(psy->dev, psy);
+
+	ret = device_create_file(psy->dev, &dev_attr_online);
+	if (ret)
+		goto create_online_failed;
+
+	ret = device_create_file(psy->dev, &dev_attr_type);
+	if (ret)
+		goto create_type_failed;
+
+	ret = device_create_file(psy->dev, &dev_attr_nominal_voltage);
+	if (ret)
+		goto create_nominal_voltage_failed;
+
+	down_write(&supplicants_sem);
+	list_for_each_entry(pst, &supplicants, node) {
+		for (i = 0; i < psy->num_supplicants; i++) {
+			if (!strcmp(pst->name, psy->supplied_to[i])) {
+				ret = bind_psy_to_pst(psy, pst);
+				if (ret)
+					goto binding_failed;
+				ret = bind_pst_to_psy(pst, psy);
+				if (ret)
+					goto binding_failed;
+				break;
+			}
+		}
+	}
+	up_write(&supplicants_sem);
+
+	/* notify supplicants that supply registred */
+	power_supply_changed(psy);
+
+	goto success;
+
+binding_failed:
+	unbind_psy_from_psts(psy);
+	device_remove_file(psy->dev, &dev_attr_nominal_voltage);
+create_nominal_voltage_failed:
+	device_remove_file(psy->dev, &dev_attr_type);
+create_type_failed:
+	device_remove_file(psy->dev, &dev_attr_online);
+create_online_failed:
+	device_unregister(psy->dev);
+dev_create_failed:
+success:
+	return ret;
+}
+
+void power_supply_unregister(struct power_supply *psy)
+{
+	down_write(&supplicants_sem);
+	unbind_psy_from_psts(psy);
+	up_write(&supplicants_sem);
+
+	device_unregister(psy->dev);
+
+	return;
+}
+
+static int __init external_power_init(void)
+{
+	int ret = 0;
+
+	power_supply_class = class_create(THIS_MODULE, "power_supply");
+	if (IS_ERR(power_supply_class)) {
+		printk(KERN_ERR "external_power: failed to create "
+		       "power_supply class\n");
+		ret = PTR_ERR(power_supply_class);
+		goto class_create_failed;
+	}
+
+	init_rwsem(&supplicants_sem);
+
+	goto success;
+
+class_create_failed:
+success:
+	return ret;
+}
+
+static void __exit external_power_exit(void)
+{
+	class_destroy(power_supply_class);
+	return;
+}
+
+EXPORT_SYMBOL_GPL(power_supplicant_am_i_supplied);
+EXPORT_SYMBOL_GPL(power_supplicant_register);
+EXPORT_SYMBOL_GPL(power_supplicant_unregister);
+
+EXPORT_SYMBOL_GPL(power_supply_changed);
+EXPORT_SYMBOL_GPL(power_supply_register);
+EXPORT_SYMBOL_GPL(power_supply_unregister);
+
+subsys_initcall(external_power_init);
+module_exit(external_power_exit);
+
+MODULE_DESCRIPTION("Linux kernel interface for external power");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Anton Vorontsov <cbou@mail.ru>");
diff --git a/include/linux/external_power.h b/include/linux/external_power.h
new file mode 100644
index 0000000..f297fce
--- /dev/null
+++ b/include/linux/external_power.h
@@ -0,0 +1,54 @@
+/*
+ * Linux kernel interface for external power suppliers/supplicants
+ *
+ * Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXTERNAL_POWER_H__
+#define __EXTERNAL_POWER_H__
+
+#include <linux/list.h>
+
+/* kernel interface for external power suppliers, like AC or USB */
+
+struct power_supply {
+	char *name;
+	char *type;
+	int nominal_voltage;
+	int (*is_online)(struct power_supply *psy);
+	char **supplied_to;
+	size_t num_supplicants;
+
+	/* private */
+	struct list_head bound_supplicants;
+	struct device *dev;
+};
+
+extern void power_supply_changed(struct power_supply *psy);
+extern int power_supply_register(struct device *parent,
+                                 struct power_supply *psy);
+extern void power_supply_unregister(struct power_supply *psy);
+
+/* kernel interface for external power supplicants (batteries so far) */
+
+struct power_supplicant {
+	char *name;
+	/* used to notify supplicant about external power arrival/outage,
+	 * do not sleep there, this is called from irq, most probably */
+	void (*power_supply_changed)(struct power_supplicant *pst,
+	                             struct power_supply *psy);
+
+	/* private */
+	struct list_head bound_supplies;
+	struct list_head node;
+};
+
+extern int power_supplicant_am_i_supplied(struct power_supplicant *pst);
+extern int power_supplicant_register(struct power_supplicant *pst);
+extern void power_supplicant_unregister(struct power_supplicant *pst);
+
+#endif /* __EXTERNAL_POWER_H__ */
-- 
1.5.0.5-dirty

