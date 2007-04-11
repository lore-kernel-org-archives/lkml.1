Return-Path: <linux-kernel-owner+w=401wt.eu-S1161440AbXDKX27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161440AbXDKX27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161431AbXDKX2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:28:42 -0400
Received: from fallback.mail.ru ([194.67.57.14]:16207 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbXDKX2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:28:30 -0400
Date: Thu, 12 Apr 2007 03:25:03 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is battery monitor class. According to first copyright string, we're
maintaining it since 2003. I've took few days and cleaned it up to be
more suitable for mainline inclusion.

It differs from battery class at git://git.infradead.org/battery-2.6.git:

* It's using external power kernel interface, i.e. does not fake external
  powers as batteries. (Same thing David Woodhouse planed last year).

* It have predefined set of attributes, this eliminates code duplication
  by battery drivers. And also gives opportunity to write emulation drivers
  for legacy stuff (APM emulation driver follow).

  If driver can't afford some attribute, it will not appear in sysfs.

* It insists on reusing its predefined attributes *and* their units.
  So, userspace getting expected values for any battery.
  
  Also common units is required for APM/ACPI emulation.
  
  Though our battery class insisting on re-usage, but not forces it. If some
  battery driver can't convert its own raw values (can't imagine why), then
  driver is free to implement its own attributes *and* additional _units
  attribute. Though, this scheme is discouraged.

* LEDs support. Each battery register its trigger, and gadgets with LEDs
  can quickly bind to battery-charging / battery-full triggers.

Here how it looks like from user space:

# ls /sys/class/battery/main-battery/
capacity  max_capacity  max_voltage   min_current  power   subsystem  uevent
current   max_current   min_capacity  min_voltage  status  temp       voltage
# cat /sys/class/battery/main-battery/status
Full
# cat /sys/class/leds/h5400\:green-right/trigger
none h5400-radio timer hwtimer main-battery-charging [main-battery-full]
# cat /sys/class/leds/h5400\:green-right/brightness
255

---
 drivers/Kconfig           |    2 +
 drivers/Makefile          |    1 +
 drivers/battery/Kconfig   |   11 ++
 drivers/battery/Makefile  |    1 +
 drivers/battery/battery.c |  303 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/battery.h   |   98 +++++++++++++++
 6 files changed, 416 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/Kconfig
 create mode 100644 drivers/battery/Makefile
 create mode 100644 drivers/battery/battery.c
 create mode 100644 include/linux/battery.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index c546de3..c3a0038 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -56,6 +56,8 @@ source "drivers/w1/Kconfig"
 
 source "drivers/power/Kconfig"
 
+source "drivers/battery/Kconfig"
+
 source "drivers/hwmon/Kconfig"
 
 source "drivers/mfd/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 2bdaae7..7cbfd37 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -61,6 +61,7 @@ obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-$(CONFIG_I2C)		+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_EXTERNAL_POWER)	+= power/
+obj-$(CONFIG_BATTERY)		+= battery/
 obj-$(CONFIG_HWMON)		+= hwmon/
 obj-$(CONFIG_PHONE)		+= telephony/
 obj-$(CONFIG_MD)		+= md/
diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
new file mode 100644
index 0000000..c386593
--- /dev/null
+++ b/drivers/battery/Kconfig
@@ -0,0 +1,11 @@
+
+menu "Battery support"
+
+config BATTERY
+	tristate "Battery monitoring support"
+	select EXTERNAL_POWER
+	help
+	  Say Y here to enable generic battery status reporting in
+	  the /sys filesystem.
+
+endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
new file mode 100644
index 0000000..a2239cb
--- /dev/null
+++ b/drivers/battery/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_BATTERY)              += battery.o
diff --git a/drivers/battery/battery.c b/drivers/battery/battery.c
new file mode 100644
index 0000000..32b8288
--- /dev/null
+++ b/drivers/battery/battery.c
@@ -0,0 +1,303 @@
+/*
+ *  Universal battery monitor class
+ *
+ *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *  Copyright (c) 2004  Szabolcs Gyurko
+ *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
+ *
+ *  Modified: 2004, Oct     Szabolcs Gyurko
+ *
+ *  You may use this code as per GPL version 2
+ *
+ * All voltages, currents, capacities and temperatures in mV, mA, mAh and
+ * tenths of a degree unless otherwise stated. It's driver's job to convert
+ * its raw values to which this class operates. If for some reason driver
+ * can't afford this requirement, then it have to create its own attributes,
+ * plus additional "XYZ_units" for each of them.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/battery.h>
+
+/* If we have hwtimer trigger, then use it to blink charging LED */
+#if defined(CONFIG_LEDS_TRIGGER_HWTIMER) || \
+    defined(CONFIG_LEDS_TRIGGER_HWTIMER_MODULE)
+	#define led_trigger_register_charging led_trigger_register_hwtimer
+	#define led_trigger_unregister_charging led_trigger_unregister_hwtimer
+#else
+	#define led_trigger_register_charging led_trigger_register_simple
+	#define led_trigger_unregister_charging led_trigger_unregister_simple
+#endif
+
+struct class *battery_class;
+
+static void battery_external_power_changed(struct power_supplicant *pst,
+                                           struct power_supply *psy)
+{
+	struct battery *bat = container_of(pst, struct battery, pst);
+	pr_debug("%s\n", __FUNCTION__);
+	if (bat->external_power_changed)
+		bat->external_power_changed(bat);
+	return;
+}
+
+int battery_is_external_power_supplied(struct battery *bat)
+{
+	pr_debug("%s\n", __FUNCTION__);
+	return power_supplicant_am_i_supplied(&bat->pst);
+}
+
+void battery_status_changed(struct battery *bat)
+{
+	pr_debug("%s\n", __FUNCTION__);
+	#ifdef CONFIG_LEDS_TRIGGERS
+	switch(bat->get_status(bat))
+	{
+		case BATTERY_STATUS_FULL:
+			led_trigger_event(bat->charging_trig, LED_OFF);
+			led_trigger_event(bat->full_trig, LED_FULL);
+			break;
+		case BATTERY_STATUS_CHARGING:
+			led_trigger_event(bat->charging_trig, LED_FULL);
+			led_trigger_event(bat->full_trig, LED_OFF);
+			break;
+		default:
+			led_trigger_event(bat->charging_trig, LED_OFF);
+			led_trigger_event(bat->full_trig, LED_OFF);
+			break;
+	}
+	#endif /* CONFIG_LEDS_TRIGGERS */
+	return;
+}
+
+static char *status_text[] = {
+	"Unknown", "Charging", "Discharging", "Not charging", "Full"
+};
+
+static ssize_t battery_show_status(struct device *dev,
+                                   struct device_attribute *attr, char *buf)
+{
+	struct battery *bat = dev_get_drvdata(dev);
+	int status = 0;
+	if (bat->get_status) {
+		status = bat->get_status(bat);
+		if (status > 4)
+			status = 0;
+		return sprintf(buf, "%s\n", status_text[status]);
+	}
+	return 0;
+}
+
+/*
+ * This is because the name "current" breaks the device attr macro.
+ * The "current" word resolvs to "(get_current())" so instead of
+ * "current" "(get_current())" appears in the sysfs.
+ *
+ * The source of this definition is the device.h which calls __ATTR
+ * macro in sysfs.h which calls the __stringify macro.
+ *
+ * Only modification that the name is not tried to be resolved
+ * (as a macro let's say).
+ */
+
+#define BATTERY_INT_ATTR(_name)                                         \
+static ssize_t battery_show_##_name(struct device *dev,                 \
+                                   struct device_attribute *attr,       \
+                                   char *buf) {                         \
+	struct battery *bat = dev_get_drvdata(dev);                     \
+	return sprintf(buf, "%d\n", bat->get_##_name(bat));             \
+}                                                                       \
+static struct device_attribute dev_attr_##_name = {                     \
+	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \
+	.show = battery_show_##_name,                                   \
+	.store = NULL,                                                  \
+}
+
+static DEVICE_ATTR(status, 0444, battery_show_status, NULL);
+BATTERY_INT_ATTR(min_voltage);
+BATTERY_INT_ATTR(min_current);
+BATTERY_INT_ATTR(min_capacity);
+BATTERY_INT_ATTR(max_voltage);
+BATTERY_INT_ATTR(max_current);
+BATTERY_INT_ATTR(max_capacity);
+BATTERY_INT_ATTR(temp);
+BATTERY_INT_ATTR(voltage);
+BATTERY_INT_ATTR(current);
+BATTERY_INT_ATTR(capacity);
+
+static int battery_create_attrs(struct battery *bat)
+{
+	int rc;
+
+	#define create_bat_attr_conditional(name)                    \
+	if(bat->get_##name) {                                        \
+		rc = device_create_file(bat->dev, &dev_attr_##name); \
+		if (rc) goto name##_failed;                          \
+	}
+
+	create_bat_attr_conditional(status);
+	create_bat_attr_conditional(min_voltage);
+	create_bat_attr_conditional(min_current);
+	create_bat_attr_conditional(min_capacity);
+	create_bat_attr_conditional(max_voltage);
+	create_bat_attr_conditional(max_current);
+	create_bat_attr_conditional(max_capacity);
+	create_bat_attr_conditional(temp);
+	create_bat_attr_conditional(voltage);
+	create_bat_attr_conditional(current);
+	create_bat_attr_conditional(capacity);
+
+	#define remove_bat_attr_conditional(name)               \
+	if(bat->get_##name)                                     \
+		device_remove_file(bat->dev, &dev_attr_##name);
+
+	goto success;
+
+capacity_failed:     remove_bat_attr_conditional(current);
+current_failed:      remove_bat_attr_conditional(voltage);
+voltage_failed:      remove_bat_attr_conditional(temp);
+temp_failed:         remove_bat_attr_conditional(max_capacity);
+max_capacity_failed: remove_bat_attr_conditional(max_current);
+max_current_failed:  remove_bat_attr_conditional(max_voltage);
+max_voltage_failed:  remove_bat_attr_conditional(min_capacity);
+min_capacity_failed: remove_bat_attr_conditional(min_current);
+min_current_failed:  remove_bat_attr_conditional(min_voltage);
+min_voltage_failed:  remove_bat_attr_conditional(status);
+status_failed:
+success:
+	return rc;
+}
+
+static void battery_remove_attrs(struct battery *bat)
+{
+	remove_bat_attr_conditional(capacity);
+	remove_bat_attr_conditional(current);
+	remove_bat_attr_conditional(voltage);
+	remove_bat_attr_conditional(temp);
+	remove_bat_attr_conditional(max_capacity);
+	remove_bat_attr_conditional(max_current);
+	remove_bat_attr_conditional(max_voltage);
+	remove_bat_attr_conditional(min_capacity);
+	remove_bat_attr_conditional(min_current);
+	remove_bat_attr_conditional(min_voltage);
+	remove_bat_attr_conditional(status);
+	return;
+}
+
+int battery_register(struct device *parent, struct battery *bat)
+{
+	int rc = 0;
+
+	bat->dev = device_create(battery_class, parent, 0, "%s", bat->name);
+	if(IS_ERR(bat->dev)) {
+		rc = PTR_ERR(bat->dev);
+		goto dev_create_failed;
+	}
+
+	dev_set_drvdata(bat->dev, bat);
+
+	rc = battery_create_attrs(bat);
+	if (rc)
+		goto create_bat_attrs_failed;
+
+	bat->pst.name = bat->name;
+	bat->pst.power_supply_changed = battery_external_power_changed;
+	rc = power_supplicant_register(&bat->pst);
+	if (rc)
+		goto power_supplicant_failed;
+
+	#ifdef CONFIG_LEDS_TRIGGERS
+	bat->charging_trig_name = kmalloc(strlen(bat->name) +
+	                                  sizeof("-charging"), GFP_KERNEL);
+	if (!bat->charging_trig_name) {
+		rc = -ENOMEM;
+		goto charging_trig_name_failed;
+	}
+
+	bat->full_trig_name = kmalloc(strlen(bat->name) +
+	                              sizeof("-full"), GFP_KERNEL);
+	if (!bat->full_trig_name) {
+		rc = -ENOMEM;
+		goto full_trig_name_failed;
+	}
+
+	strcpy(bat->charging_trig_name, bat->name);
+	strcat(bat->charging_trig_name, "-charging");
+	strcpy(bat->full_trig_name, bat->name);
+	strcat(bat->full_trig_name, "-full");
+
+	led_trigger_register_charging(bat->charging_trig_name,
+	                              &bat->charging_trig);
+	led_trigger_register_simple(bat->full_trig_name,
+	                            &bat->full_trig);
+	#endif /* CONFIG_LEDS_TRIGGERS */
+
+	goto success;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+full_trig_name_failed:
+	kfree(bat->charging_trig_name);
+charging_trig_name_failed:
+#endif
+	power_supplicant_unregister(&bat->pst);
+power_supplicant_failed:
+	battery_remove_attrs(bat);
+create_bat_attrs_failed:
+	device_unregister(bat->dev);
+dev_create_failed:
+success:
+	return rc;
+}
+
+void battery_unregister(struct battery *bat)
+{
+	power_supplicant_unregister(&bat->pst);
+	battery_remove_attrs(bat);
+	device_unregister(bat->dev);
+
+	#ifdef CONFIG_LEDS_TRIGGERS
+	led_trigger_unregister_charging(bat->charging_trig);
+	led_trigger_unregister_simple(bat->full_trig);
+	kfree(bat->full_trig_name);
+	kfree(bat->charging_trig_name);
+	#endif
+
+	return;
+}
+
+static int __init battery_class_init(void)
+{
+	battery_class = class_create(THIS_MODULE, "battery");
+
+	if (IS_ERR(battery_class))
+		return PTR_ERR(battery_class);
+
+	return 0;
+}
+
+static void __exit battery_class_exit(void)
+{
+	class_destroy(battery_class);
+	return;
+}
+
+EXPORT_SYMBOL_GPL(battery_register);
+EXPORT_SYMBOL_GPL(battery_unregister);
+EXPORT_SYMBOL_GPL(battery_status_changed);
+EXPORT_SYMBOL_GPL(battery_is_external_power_supplied);
+
+/* exported for the APM Power driver, APM emulation */
+EXPORT_SYMBOL_GPL(battery_class);
+
+subsys_initcall(battery_class_init);
+module_exit(battery_class_exit);
+
+MODULE_DESCRIPTION("Universal battery monitor class");
+MODULE_AUTHOR("Ian Molton <spyro@f2s.com>, "
+              "Szabolcs Gyurko, "
+              "Anton Vorontsov <cbou@mail.ru>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/battery.h b/include/linux/battery.h
new file mode 100644
index 0000000..a687781
--- /dev/null
+++ b/include/linux/battery.h
@@ -0,0 +1,98 @@
+/*
+ *  Universal battery monitor class
+ *
+ *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *  Copyright (c) 2004  Szabolcs Gyurko
+ *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
+ *
+ *  Modified: 2004, Oct     Szabolcs Gyurko
+ *
+ *  You may use this code as per GPL version 2
+ *
+ * All voltages, currents, capacities and temperatures in mV, mA, mAh and
+ * tenths of a degree unless otherwise stated. It's driver's job to convert
+ * its raw values to which this class operates. If for some reason driver
+ * can't afford this requirement, then it have to create its own attributes,
+ * plus additional "XYZ_units" for each of them.
+ */
+
+#ifndef _LINUX_BATTERY_H
+#define _LINUX_BATTERY_H
+
+#include <linux/device.h>
+#include <linux/external_power.h>
+#include <linux/leds.h>
+
+#define BATTERY_STATUS_UNKNOWN      0
+#define BATTERY_STATUS_CHARGING     1
+#define BATTERY_STATUS_DISCHARGING  2
+#define BATTERY_STATUS_NOT_CHARGING 3
+#define BATTERY_STATUS_FULL         4
+
+/* 
+ * For systems where the charger determines the maximum battery capacity
+ * the min and max fields should be used to present these values to user
+ * space. Unused/uknown fields can be NULL and will not appear in sysfs.
+ */
+
+struct battery {
+	struct device *dev;
+	char *name;
+
+	/* For APM emulation, think legacy userspace. */
+	int main_battery;
+
+	/* executed in userspace, feel free to sleep */
+	int (*get_min_voltage)(struct battery *bat);
+	int (*get_min_current)(struct battery *bat);
+	int (*get_min_capacity)(struct battery *bat);
+	int (*get_max_voltage)(struct battery *bat);
+	int (*get_max_current)(struct battery *bat);
+	int (*get_max_capacity)(struct battery *bat);
+	int (*get_temp)(struct battery *bat);
+	int (*get_voltage)(struct battery *bat);
+	int (*get_current)(struct battery *bat);
+	int (*get_capacity)(struct battery *bat);
+	int (*get_status)(struct battery *bat);
+
+	/* drivers should not sleep inside it, you'll get there from ISRs */
+	void (*external_power_changed)(struct battery *bat);
+
+	/* private */
+	struct power_supplicant pst;
+
+	#ifdef CONFIG_LEDS_TRIGGERS
+	struct led_trigger *charging_trig;
+	char *charging_trig_name;
+	struct led_trigger *full_trig;
+	char *full_trig_name;
+	#endif
+};
+
+/* 
+ * This is recommended structure to specify static battery parameters.
+ * Generic one, parametrizable for different batteries. Battery device
+ * itself does bot use it, but that's what implementing most drivers,
+ * should try reuse for consistency.
+ */
+
+struct battery_info {
+	char *name;
+	int min_voltage;
+	int max_voltage;
+	int min_current;
+	int max_current;
+	int min_capacity;
+	int max_capacity;
+	int main_battery;
+};
+
+extern void battery_status_changed(struct battery *bat);
+extern int battery_is_external_power_supplied(struct battery *bat);
+extern int battery_register(struct device *parent, struct battery *bat);
+extern void battery_unregister(struct battery *bat);
+
+/* For APM emulation, think legacy userspace. */
+extern struct class *battery_class;
+
+#endif
-- 
1.5.0.5-dirty
