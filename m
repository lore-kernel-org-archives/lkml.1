Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbXDMNxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbXDMNxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXDMNxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:53:08 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:28514 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753993AbXDMNxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:53:06 -0400
Date: Fri, 13 Apr 2007 17:49:39 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Shem Multinymous <multinymous@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070413134939.GA20618@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232503.GC20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:25:03AM +0400, Anton Vorontsov wrote:
> Here is battery monitor class. According to first copyright string, we're
> maintaining it since 2003. I've took few days and cleaned it up to be
> more suitable for mainline inclusion.
> 
> It differs from battery class at git://git.infradead.org/battery-2.6.git:
> 
> * It's using external power kernel interface, i.e. does not fake external
>   powers as batteries. (Same thing David Woodhouse planed last year).
> 
> * It have predefined set of attributes, this eliminates code duplication
>   by battery drivers. And also gives opportunity to write emulation drivers
>   for legacy stuff (APM emulation driver follow).
> 
>   If driver can't afford some attribute, it will not appear in sysfs.
> 
> * It insists on reusing its predefined attributes *and* their units.
>   So, userspace getting expected values for any battery.
>   
>   Also common units is required for APM/ACPI emulation.
>   
>   Though our battery class insisting on re-usage, but not forces it. If some
>   battery driver can't convert its own raw values (can't imagine why), then
>   driver is free to implement its own attributes *and* additional _units
>   attribute. Though, this scheme is discouraged.
> 
> * LEDs support. Each battery register its trigger, and gadgets with LEDs
>   can quickly bind to battery-charging / battery-full triggers.
> 
> Here how it looks like from user space:
> 
> # ls /sys/class/battery/main-battery/
> capacity  max_capacity  max_voltage   min_current  power   subsystem  uevent
> current   max_current   min_capacity  min_voltage  status  temp       voltage
> # cat /sys/class/battery/main-battery/status
> Full
> # cat /sys/class/leds/h5400\:green-right/trigger
> none h5400-radio timer hwtimer main-battery-charging [main-battery-full]
> # cat /sys/class/leds/h5400\:green-right/brightness
> 255
> 

Changes:

- Cleanups based on comments from Randy Dunlap.

- Attribute creation scheme changed drastically. No more tons of

  macro-created functions. Compiled code should be much smaller.
  Also adding new "standard" attributes is trivial task now (matter of
  adding two lines, one in battery.c and another in battery.h).

- charge (as quantity) in mAh, energy in mWh.


I'll convert mXh to uXh a bit later, if there will no further objections
against uXh. Also I'd like to hear if there any objections on
mA/mV -> uA/uV conversion. I think we'd better keep all units at the
same order/precision.


Subject: [PATCH] [take2] Battery monitoring class


Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/Kconfig           |    2 +
 drivers/Makefile          |    1 +
 drivers/battery/Kconfig   |   11 ++
 drivers/battery/Makefile  |    1 +
 drivers/battery/battery.c |  290 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/battery.h   |  113 ++++++++++++++++++
 6 files changed, 418 insertions(+), 0 deletions(-)
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
index 0000000..6c87fe3
--- /dev/null
+++ b/drivers/battery/battery.c
@@ -0,0 +1,290 @@
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
+ * All voltages, currents, charges, energies and temperatures in mV, mA,
+ * mAh, mWh and tenths of a Celsius degree unless otherwise stated. It's
+ * driver's job to convert its raw values to which this class operates. If
+ * for some reason driver can't afford this requirement, then it have to
+ * create its own attributes, plus additional "XYZ_units" for each of them.
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
+#if defined(CONFIG_LEDS_TRIGGER_HWTIMER) ||                  \
+               (defined(CONFIG_BATTERY_MODULE) &&            \
+                defined(CONFIG_LEDS_TRIGGER_HWTIMER_MODULE))
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
+
+	pr_debug("%s\n", __FUNCTION__);
+	if (bat->external_power_changed)
+		bat->external_power_changed(bat);
+
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
+	void *value;
+
+	pr_debug("%s\n", __FUNCTION__);
+
+	value = bat->get_property(bat, BATTERY_PROP_STATUS);
+	if (!value)
+		return;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	switch(*(int *)value) {
+	case BATTERY_STATUS_FULL:
+		led_trigger_event(bat->charging_trig, LED_OFF);
+		led_trigger_event(bat->full_trig, LED_FULL);
+		break;
+	case BATTERY_STATUS_CHARGING:
+		led_trigger_event(bat->charging_trig, LED_FULL);
+		led_trigger_event(bat->full_trig, LED_OFF);
+		break;
+	default:
+		led_trigger_event(bat->charging_trig, LED_OFF);
+		led_trigger_event(bat->full_trig, LED_OFF);
+		break;
+	}
+#endif /* CONFIG_LEDS_TRIGGERS */
+	return;
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
+#define BATTERY_ATTR(_name)                                             \
+{                                                                       \
+	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE }, \
+	.show = battery_show_property,                                  \
+	.store = NULL,                                                  \
+}
+
+static struct device_attribute battery_attrs[];
+
+static ssize_t battery_show_property(struct device *dev,
+                                     struct device_attribute *attr,
+                                     char *buf) {
+	static char *status_text[] = {
+		"Unknown", "Charging", "Discharging", "Not charging", "Full"
+	};
+	struct battery *bat = dev_get_drvdata(dev);
+	const off_t off = attr - battery_attrs;
+	void *value = bat->get_property(bat, off);
+
+	if (!value)
+		return sprintf(buf, "Driver can't report this property, "
+		               "but claimed it can. Fix it.\n");
+
+	if (off == BATTERY_PROP_STATUS)
+		return sprintf(buf, "%s\n", status_text[*(int *)value]);
+	else
+		return sprintf(buf, "%d\n", *(int *)value);
+}
+
+/* Must be in the same order as BATTERY_PROP_*, defined in battery.h */
+static struct device_attribute battery_attrs[] = {
+	BATTERY_ATTR(status),
+	BATTERY_ATTR(min_voltage),
+	BATTERY_ATTR(max_voltage),
+	BATTERY_ATTR(voltage),
+	BATTERY_ATTR(min_current),
+	BATTERY_ATTR(max_current),
+	BATTERY_ATTR(current),
+	BATTERY_ATTR(design_charge),
+	BATTERY_ATTR(min_charge),
+	BATTERY_ATTR(max_charge),
+	BATTERY_ATTR(charge),
+	BATTERY_ATTR(design_energy),
+	BATTERY_ATTR(min_energy),
+	BATTERY_ATTR(max_energy),
+	BATTERY_ATTR(energy),
+	BATTERY_ATTR(temp),
+};
+
+static int battery_create_attrs(struct battery *bat)
+{
+	int rc = 0;
+	int i;
+
+	for (i = 0; i < bat->num_properties; i++) {
+		rc = device_create_file(bat->dev,
+		            &battery_attrs[bat->properties[i]]);
+		if (rc)
+			goto failed;
+	}
+
+	goto succeed;
+
+failed:
+	while (i--)
+		device_remove_file(bat->dev,
+		           &battery_attrs[bat->properties[i]]);
+succeed:
+	return rc;
+}
+
+static void battery_remove_attrs(struct battery *bat)
+{
+	int i;
+
+	for (i = 0; i < bat->num_properties; i++)
+		device_remove_file(bat->dev,
+		           &battery_attrs[bat->properties[i]]);
+	return;
+}
+
+int battery_register(struct device *parent, struct battery *bat)
+{
+	int rc = 0;
+
+	bat->dev = device_create(battery_class, parent, 0, "%s", bat->name);
+	if (IS_ERR(bat->dev)) {
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
+#ifdef CONFIG_LEDS_TRIGGERS
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
+#endif /* CONFIG_LEDS_TRIGGERS */
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
+#ifdef CONFIG_LEDS_TRIGGERS
+	led_trigger_unregister_charging(bat->charging_trig);
+	led_trigger_unregister_simple(bat->full_trig);
+	kfree(bat->full_trig_name);
+	kfree(bat->charging_trig_name);
+#endif
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
index 0000000..2dcc8ed
--- /dev/null
+++ b/include/linux/battery.h
@@ -0,0 +1,113 @@
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
+ * All voltages, currents, charges, energies and temperatures in mV, mA,
+ * mAh, mWh and tenths of a Celsius degree unless otherwise stated. It's
+ * driver's job to convert its raw values to which this class operates. If
+ * for some reason driver can't afford this requirement, then it have to
+ * create its own attributes, plus additional "XYZ_units" for each of them.
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
+ * space. Unused/unknown fields can be NULL and will not appear in sysfs.
+ */
+
+enum battery_property {
+	BATTERY_PROP_STATUS = 0,
+	BATTERY_PROP_MIN_VOLTAGE,
+	BATTERY_PROP_MAX_VOLTAGE,
+	BATTERY_PROP_VOLTAGE,
+	BATTERY_PROP_MIN_CURRENT,
+	BATTERY_PROP_MAX_CURRENT,
+	BATTERY_PROP_CURRENT,
+	BATTERY_PROP_DESIGN_CHARGE,
+	BATTERY_PROP_MIN_CHARGE,
+	BATTERY_PROP_MAX_CHARGE,
+	BATTERY_PROP_CHARGE,
+	BATTERY_PROP_DESIGN_ENERGY,
+	BATTERY_PROP_MIN_ENERGY,
+	BATTERY_PROP_MAX_ENERGY,
+	BATTERY_PROP_ENERGY,
+	BATTERY_PROP_TEMP,
+};
+
+struct battery {
+	struct device *dev;
+	char *name;
+	int *properties;
+	int num_properties;
+
+	/* For APM emulation, think legacy userspace. */
+	int main_battery;
+
+	/* executed in userspace, feel free to sleep */
+	void *(*get_property)(struct battery *bat, enum battery_property);
+
+	/* drivers should not sleep inside it, you'll get there from ISRs */
+	void (*external_power_changed)(struct battery *bat);
+
+	/* private */
+	struct power_supplicant pst;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	struct led_trigger *charging_trig;
+	char *charging_trig_name;
+	struct led_trigger *full_trig;
+	char *full_trig_name;
+#endif
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
+	int design_charge;
+	int min_charge;
+	int max_charge;
+	int design_energy;
+	int min_energy;
+	int max_energy;
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

