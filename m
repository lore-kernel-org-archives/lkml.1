Return-Path: <linux-kernel-owner+w=401wt.eu-S1031129AbXDYPyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031129AbXDYPyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031126AbXDYPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:53:46 -0400
Received: from mx34.mail.ru ([194.67.23.200]:11839 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031150AbXDYPxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:53:37 -0400
Date: Wed, 25 Apr 2007 19:50:48 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 3/7] Universal battery class
Message-ID: <20070425155048.GC4117@zarina>
References: <20070425154820.GA27300@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425154820.GA27300@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Battery class used to export battery properties to userspace in consistent
manner.

It defines core set of battery attributes, available via sysfs, which
should be applicable to (almost) every battery out there. Each attribute
has well defined meaning, up to unit of measure used. While the attributes
provided are believed to be universally applicable to any battery,
specific monitoring hardware may not be able to provide them all, so
any of them may be skipped.

Battery class is extensible, and allows to define drivers own attributes.
The core attribute set is subject to the standard Linux evolution (i.e.
if it will be found that some attribute is applicable to many batteries
or their drivers, it can be added to the core set).

Battery class integrates with External Power framework, for the purpose of
notification battery drivers when charging power is available. Note that
specific charge control is left to the battery drivers.

It also integrates with LED framework, for the purpose of providing
typically expected (at least for portable devices) feedback of battery
status (charging/fully charged) via LEDs. (Note that specific details of
the indication (including whether to use it at all) are fully controllable
by user and/or specific machine defaults, per design principles of LED
framework).

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 Documentation/battery-class.txt |  150 +++++++++++++++++++++++++++++++++++++++
 drivers/Kconfig                 |    2 +
 drivers/Makefile                |    1 +
 drivers/battery/Kconfig         |   12 +++
 drivers/battery/Makefile        |    9 +++
 drivers/battery/battery.c       |  138 +++++++++++++++++++++++++++++++++++
 drivers/battery/battery.h       |   37 ++++++++++
 drivers/battery/battery_leds.c  |  106 +++++++++++++++++++++++++++
 drivers/battery/battery_sysfs.c |  122 +++++++++++++++++++++++++++++++
 include/linux/battery.h         |  127 +++++++++++++++++++++++++++++++++
 10 files changed, 704 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/battery-class.txt
 create mode 100644 drivers/battery/Kconfig
 create mode 100644 drivers/battery/Makefile
 create mode 100644 drivers/battery/battery.c
 create mode 100644 drivers/battery/battery.h
 create mode 100644 drivers/battery/battery_leds.c
 create mode 100644 drivers/battery/battery_sysfs.c
 create mode 100644 include/linux/battery.h

diff --git a/Documentation/battery-class.txt b/Documentation/battery-class.txt
new file mode 100644
index 0000000..6a7d591
--- /dev/null
+++ b/Documentation/battery-class.txt
@@ -0,0 +1,150 @@
+Linux battery class
+===================
+
+Synopsis
+~~~~~~~~
+Battery class used to export battery properties to userspace in consistent
+manner.
+
+It defines core set of battery attributes, available via sysfs, which
+should be applicable to (almost) every battery out there. Each attribute
+has well defined meaning, up to unit of measure used. While the attributes
+provided are believed to be universally applicable to any battery,
+specific monitoring hardware may not be able to provide them all, so
+any of them may be skipped.
+
+Battery class is extensible, and allows to define drivers own attributes.
+The core attribute set is subject to the standard Linux evolution (i.e.
+if it will be found that some attribute is applicable to many batteries
+or their drivers, it can be added to the core set).
+
+Battery class integrates with External Power framework, for the purpose of
+notification battery drivers when charging power is available. Note that
+specific charge control is left to the battery drivers.
+
+It also integrates with LED framework, for the purpose of providing
+typically expected (at least for portable devices) feedback of battery
+status (charging/fully charged) via LEDs. (Note that specific details of
+the indication (including whether to use it at all) are fully controllable
+by user and/or specific machine defaults, per design principles of LED
+framework).
+
+
+Attributes/properties
+~~~~~~~~~~~~~~~~~~~~~
+Battery class has predefined set of attributes, this eliminates code
+duplication across battery drivers. Battery class insist on reusing its
+predefined attributes *and* their units.
+
+So, userspace gets expected set of attributes and their units for
+any kind of battery, and can process/present them to a user in consistent
+manner. Results for different batteries and machines are also directly
+comparable.
+
+See drivers/battery/ds2760_battery.c for the example how to declare and
+handle attributes.
+
+
+Units
+~~~~~
+Quoting include/linux/battery.h:
+
+  All voltages, currents, charges, energies, time and temperatures in uV,
+  uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
+  stated. It's driver's job to convert its raw values to units in which
+  this class operates.
+
+
+Attributes/properties detailed
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+~ ~ ~ ~ ~ ~ ~  Charge/Energy/Capacity - how to not confuse  ~ ~ ~ ~ ~ ~ ~
+~                                                                       ~
+~ Because both "charge" (uAh) and "energy" (uWh) represents "capacity"  ~
+~ of battery, battery class distinguish these terms. Don't mix them!    ~
+~                                                                       ~
+~ CHARGE_* attributes represents capacity in uAh only.                  ~
+~ ENERGY_* attributes represents capacity in uWh only.                  ~
+~ CAPACITY attribute represents capacity in *percents*, from 0 to 100.  ~
+~                                                                       ~
+~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
+
+Postfixes:
+_AVG - *hardware* averaged value, use it if your hardware is really able to
+report averaged values.
+_NOW - momentary/instantaneous values.
+
+STATUS - this attribute represents operating status (charging, full,
+discharging (i.e. powering a load), etc.). This corresponds to
+BATTERY_STATUS_* values, as defined in battery.h.
+
+HEALTH - represents health of the battery, values corresponds to
+BATTERY_HEALTH_*, defined in battery.h.
+
+VOLTAGE_MAX_DESIGN, VOLTAGE_MIN_DESIGN - design values for maximal and
+minimal battery voltages. Maximal/minimal means values of voltages when
+battery considered "full"/"empty" at normal conditions. Yes, there is
+no direct relation between voltage and battery capacity, but some dumb
+batteries use voltage for very approximated calculation of capacity.
+Battery driver also can use this attribute just to inform userspace
+about maximal and minimal voltage thresholds of a given battery.
+
+CHARGE_FULL_DESIGN, CHARGE_EMPTY_DESIGN - design charge values, when
+battery considered full/empty.
+
+ENERGY_FULL_DESIGN, ENERGY_EMPTY_DESIGN - same as above but for energy.
+
+CHARGE_FULL, CHARGE_EMPTY - These attributes means "last remembered value
+of charge when battery became full/empty". It also could mean "value of
+charge when battery considered full/empty at given conditions (temperature,
+age)". I.e. these attributes represents real thresholds, not design values.
+
+ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
+
+CAPACITY - capacity in percents.
+
+TEMP - temperature of the battery.
+
+TIME_TO_EMPTY - seconds left for battery to be considered empty (i.e.
+while battery powers a load)
+TIME_TO_FULL - seconds left for battery to be considered full (i.e.
+while battery is charging)
+
+
+QA
+~~
+Q: Where is BATTERY_PROP_XYZ attribute?
+A: If you cannot find attribute suitable for your battery needs, feel free
+   to add it and send patch along with your battery driver.
+
+   The attributes available currently are the ones currently provided by the
+   drivers written.
+
+   Good candidates to add in future: battery technology, model/part#,
+   cycle_time, manufacturer, etc.
+
+
+Q: I have some very specific attribute (e.g. battery color), should I add
+   this attribute to standard ones?
+A: Most likely, no. Such attribute can be placed in the driver itself, if
+   it is useful. Of course, if the attribute in question applicable to
+   large set of batteries, provided by many drivers, and/or comes from
+   some general battery specification/standard, it may be a candidate to
+   be added to the core attribute set.
+
+
+Q: Suppose, my battery monitoring chip/firmware does not provides capacity
+   in percents, but provides charge_{now,full,empty}. Should I calculate
+   percentage capacity manually, inside the driver, and register CAPACITY
+   attribute? The same question about time_to_empty/time_to_full.
+A: Most likely, no. Battery class is designed to export battery properties
+   which are directly measurable by the specific hardware available.
+   Inferring not available properties using some heuristics or mathematical
+   model is not subject of work for a battery driver. Such functionality
+   should be factored out, and in fact, apm_power, the driver to serve
+   legacy APM API on top of battery class, uses a simple heuristic of
+   approximating remaining battery capacity based on its charge, current,
+   voltage and so on. But full-fledged battery model is likely not subject
+   for kernel at all, as it would require floating point calculation to deal
+   with things like differential equations and Kalman filters. This is
+   better be handled by batteryd/libbattery, yet to be written.
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
index 0000000..a66294d
--- /dev/null
+++ b/drivers/battery/Kconfig
@@ -0,0 +1,12 @@
+
+menu "Battery devices"
+
+config BATTERY
+	tristate "Battery class support"
+	select EXTERNAL_POWER
+	help
+	  Say Y here to enable battery class support. This allows battery
+	  monitoring by userspace via sysfs (if available) and/or APM
+	  kernel interface (if selected below).
+
+endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
new file mode 100644
index 0000000..1af291b
--- /dev/null
+++ b/drivers/battery/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_BATTERY)              += battery.o
+
+ifeq ($(CONFIG_SYSFS),y)
+obj-$(CONFIG_BATTERY)              += battery_sysfs.o
+endif
+
+ifeq ($(CONFIG_LEDS_TRIGGERS),y)
+obj-$(CONFIG_BATTERY)              += battery_leds.o
+endif
diff --git a/drivers/battery/battery.c b/drivers/battery/battery.c
new file mode 100644
index 0000000..265b4fe
--- /dev/null
+++ b/drivers/battery/battery.c
@@ -0,0 +1,138 @@
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
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/battery.h>
+#include "battery.h"
+
+struct class *battery_class;
+
+static void battery_external_power_changed(struct power_supplicant *pst,
+                                           struct power_supply *psy)
+{
+	struct battery *bat = container_of(pst, struct battery, pst);
+
+	dev_dbg(bat->dev, "%s by %s\n", __FUNCTION__, psy->name);
+
+	if (bat->external_power_changed)
+		bat->external_power_changed(bat);
+
+	return;
+}
+
+int battery_is_external_power_supplied(struct battery *bat)
+{
+	const int ret = power_supplicant_am_i_supplied(&bat->pst);
+
+	dev_dbg(bat->dev, "%s %d\n", __FUNCTION__, ret);
+
+	return ret;
+}
+
+void battery_status_changed(struct battery *bat)
+{
+	int *status = bat->get_property(bat, BATTERY_PROP_STATUS);
+
+	dev_dbg(bat->dev, "%s\n", __FUNCTION__);
+
+	if (!status)
+		return;
+
+	battery_update_leds(bat, *status);
+
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
+		goto create_attrs_failed;
+
+	rc = battery_create_triggers(bat);
+	if (rc)
+		goto create_triggers_failed;
+
+	bat->pst.name = bat->name;
+	bat->pst.power_supply_changed = battery_external_power_changed;
+	rc = power_supplicant_register(&bat->pst);
+	if (rc)
+		goto power_supplicant_failed;
+
+	goto success;
+
+power_supplicant_failed:
+	battery_remove_triggers(bat);
+create_triggers_failed:
+	battery_remove_attrs(bat);
+create_attrs_failed:
+	device_unregister(bat->dev);
+dev_create_failed:
+success:
+	return rc;
+}
+
+void battery_unregister(struct battery *bat)
+{
+	power_supplicant_unregister(&bat->pst);
+	battery_remove_triggers(bat);
+	battery_remove_attrs(bat);
+	device_unregister(bat->dev);
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
diff --git a/drivers/battery/battery.h b/drivers/battery/battery.h
new file mode 100644
index 0000000..25a98c6
--- /dev/null
+++ b/drivers/battery/battery.h
@@ -0,0 +1,37 @@
+/*
+ *  Functions private to battery.c
+ *
+ *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *  Copyright (c) 2004  Szabolcs Gyurko
+ *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
+ *
+ *  Modified: 2004, Oct     Szabolcs Gyurko
+ *
+ *  You may use this code as per GPL version 2
+ */
+
+#ifdef CONFIG_SYSFS
+
+extern int battery_create_attrs(struct battery *bat);
+extern void battery_remove_attrs(struct battery *bat);
+
+#else
+
+static inline int battery_create_attrs(struct battery *bat) { return 0; }
+static inline void battery_remove_attrs(struct battery *bat) {}
+
+#endif /* CONFIG_SYSFS */
+
+#ifdef CONFIG_LEDS_TRIGGERS
+
+extern void battery_update_leds(struct battery *bat, int status);
+extern int battery_create_triggers(struct battery *bat);
+extern void battery_remove_triggers(struct battery *bat);
+
+#else
+
+static inline void battery_update_leds(struct battery *bat, int status) {}
+static inline int battery_create_triggers(struct battery *bat) { return 0; }
+static inline void battery_remove_triggers(struct battery *bat) {}
+
+#endif /* CONFIG_LEDS_TRIGGERS */
diff --git a/drivers/battery/battery_leds.c b/drivers/battery/battery_leds.c
new file mode 100644
index 0000000..4306b0e
--- /dev/null
+++ b/drivers/battery/battery_leds.c
@@ -0,0 +1,106 @@
+/*
+ *  LEDs triggers for class batteries
+ *
+ *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *  Copyright (c) 2004  Szabolcs Gyurko
+ *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
+ *
+ *  Modified: 2004, Oct     Szabolcs Gyurko
+ *
+ *  You may use this code as per GPL version 2
+ */
+
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
+void battery_update_leds(struct battery *bat, int status)
+{
+	dev_dbg(bat->dev, "%s %d\n", __FUNCTION__, status);
+
+	switch(status) {
+	case BATTERY_STATUS_FULL:
+		led_trigger_event(bat->charging_full_trig, LED_FULL);
+		led_trigger_event(bat->charging_trig, LED_OFF);
+		led_trigger_event(bat->full_trig, LED_FULL);
+		break;
+	case BATTERY_STATUS_CHARGING:
+		led_trigger_event(bat->charging_full_trig, LED_FULL);
+		led_trigger_event(bat->charging_trig, LED_FULL);
+		led_trigger_event(bat->full_trig, LED_OFF);
+		break;
+	default:
+		led_trigger_event(bat->charging_full_trig, LED_OFF);
+		led_trigger_event(bat->charging_trig, LED_OFF);
+		led_trigger_event(bat->full_trig, LED_OFF);
+		break;
+	}
+
+	return;
+}
+
+int battery_create_triggers(struct battery *bat)
+{
+	int rc = 0;
+
+	bat->charging_full_trig_name = kmalloc(strlen(bat->name) +
+	                          sizeof("-charging-or-full"), GFP_KERNEL);
+	if (!bat->charging_full_trig_name)
+		goto charging_full_failed;
+
+	bat->charging_trig_name = kmalloc(strlen(bat->name) +
+	                                  sizeof("-charging"), GFP_KERNEL);
+	if (!bat->charging_trig_name)
+		goto charging_failed;
+
+	bat->full_trig_name = kmalloc(strlen(bat->name) +
+	                              sizeof("-full"), GFP_KERNEL);
+	if (!bat->full_trig_name)
+		goto full_failed;
+
+	strcpy(bat->charging_full_trig_name, bat->name);
+	strcat(bat->charging_full_trig_name, "-charging-or-full");
+	strcpy(bat->charging_trig_name, bat->name);
+	strcat(bat->charging_trig_name, "-charging");
+	strcpy(bat->full_trig_name, bat->name);
+	strcat(bat->full_trig_name, "-full");
+
+	led_trigger_register_simple(bat->charging_full_trig_name,
+	                            &bat->charging_full_trig);
+	led_trigger_register_charging(bat->charging_trig_name,
+	                              &bat->charging_trig);
+	led_trigger_register_simple(bat->full_trig_name,
+	                            &bat->full_trig);
+
+	goto success;
+
+full_failed:
+	kfree(bat->charging_trig_name);
+charging_failed:
+	kfree(bat->charging_full_trig_name);
+charging_full_failed:
+	rc = -ENOMEM;
+success:
+	return rc;
+}
+
+void battery_remove_triggers(struct battery *bat)
+{
+	led_trigger_unregister_simple(bat->charging_full_trig);
+	led_trigger_unregister_charging(bat->charging_trig);
+	led_trigger_unregister_simple(bat->full_trig);
+	kfree(bat->full_trig_name);
+	kfree(bat->charging_trig_name);
+	kfree(bat->charging_full_trig_name);
+
+	return;
+}
diff --git a/drivers/battery/battery_sysfs.c b/drivers/battery/battery_sysfs.c
new file mode 100644
index 0000000..08a9f61
--- /dev/null
+++ b/drivers/battery/battery_sysfs.c
@@ -0,0 +1,122 @@
+/*
+ *  Sysfs interface for the universal battery monitor class
+ *
+ *  Copyright (c) 2007  Anton Vorontsov <cbou@mail.ru>
+ *  Copyright (c) 2004  Szabolcs Gyurko
+ *  Copyright (c) 2003  Ian Molton <spyro@f2s.com>
+ *
+ *  Modified: 2004, Oct     Szabolcs Gyurko
+ *
+ *  You may use this code as per GPL version 2
+ */
+
+#include <linux/battery.h>
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
+	static char *health_text[] = {
+		"Unknown", "Good", "Overheat", "Dead"
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
+	else if (off == BATTERY_PROP_HEALTH)
+		return sprintf(buf, "%s\n", health_text[*(int *)value]);
+
+	return sprintf(buf, "%d\n", *(int *)value);
+}
+
+/* Must be in the same order as BATTERY_PROP_*, defined in battery.h */
+static struct device_attribute battery_attrs[] = {
+	BATTERY_ATTR(status),
+	BATTERY_ATTR(health),
+	BATTERY_ATTR(voltage_max_design),
+	BATTERY_ATTR(voltage_min_design),
+	BATTERY_ATTR(voltage_now),
+	BATTERY_ATTR(voltage_avg),
+	BATTERY_ATTR(current_now),
+	BATTERY_ATTR(current_avg),
+	BATTERY_ATTR(charge_full_design),
+	BATTERY_ATTR(charge_empty_design),
+	BATTERY_ATTR(charge_full),
+	BATTERY_ATTR(charge_empty),
+	BATTERY_ATTR(charge_now),
+	BATTERY_ATTR(charge_avg),
+	BATTERY_ATTR(energy_full_design),
+	BATTERY_ATTR(energy_empty_design),
+	BATTERY_ATTR(energy_full),
+	BATTERY_ATTR(energy_empty),
+	BATTERY_ATTR(energy_now),
+	BATTERY_ATTR(energy_avg),
+	BATTERY_ATTR(capacity),
+	BATTERY_ATTR(temp),
+	BATTERY_ATTR(time_to_empty_now),
+	BATTERY_ATTR(time_to_empty_avg),
+	BATTERY_ATTR(time_to_full_now),
+	BATTERY_ATTR(time_to_full_avg),
+};
+
+int battery_create_attrs(struct battery *bat)
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
+void battery_remove_attrs(struct battery *bat)
+{
+	int i;
+
+	for (i = 0; i < bat->num_properties; i++)
+		device_remove_file(bat->dev,
+		           &battery_attrs[bat->properties[i]]);
+
+	return;
+}
diff --git a/include/linux/battery.h b/include/linux/battery.h
new file mode 100644
index 0000000..482d747
--- /dev/null
+++ b/include/linux/battery.h
@@ -0,0 +1,127 @@
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
+ */
+
+#ifndef __LINUX_BATTERY_H__
+#define __LINUX_BATTERY_H__
+
+#include <linux/device.h>
+#include <linux/external_power.h>
+#include <linux/leds.h>
+
+/*
+ * All voltages, currents, charges, energies, time and temperatures in uV,
+ * uA, uAh, uWh, seconds and tenths of degree Celsius unless otherwise
+ * stated. It's driver's job to convert its raw values to units in which
+ * this class operates.
+ */
+
+/*
+ * For systems where the charger determines the maximum battery capacity
+ * the min and max fields should be used to present these values to user
+ * space. Unused/unknown fields will not appear in sysfs.
+ */
+
+#define BATTERY_STATUS_UNKNOWN      0
+#define BATTERY_STATUS_CHARGING     1
+#define BATTERY_STATUS_DISCHARGING  2
+#define BATTERY_STATUS_NOT_CHARGING 3
+#define BATTERY_STATUS_FULL         4
+
+#define BATTERY_HEALTH_UNKNOWN  0
+#define BATTERY_HEALTH_GOOD     1
+#define BATTERY_HEALTH_OVERHEAT 2
+#define BATTERY_HEALTH_DEAD     3
+
+enum battery_property {
+	BATTERY_PROP_STATUS = 0,
+	BATTERY_PROP_HEALTH,
+	BATTERY_PROP_VOLTAGE_MAX_DESIGN,
+	BATTERY_PROP_VOLTAGE_MIN_DESIGN,
+	BATTERY_PROP_VOLTAGE_NOW,
+	BATTERY_PROP_VOLTAGE_AVG,
+	BATTERY_PROP_CURRENT_NOW,
+	BATTERY_PROP_CURRENT_AVG,
+	BATTERY_PROP_CHARGE_FULL_DESIGN,
+	BATTERY_PROP_CHARGE_EMPTY_DESIGN,
+	BATTERY_PROP_CHARGE_FULL,
+	BATTERY_PROP_CHARGE_EMPTY,
+	BATTERY_PROP_CHARGE_NOW,
+	BATTERY_PROP_CHARGE_AVG,
+	BATTERY_PROP_ENERGY_FULL_DESIGN,
+	BATTERY_PROP_ENERGY_EMPTY_DESIGN,
+	BATTERY_PROP_ENERGY_FULL,
+	BATTERY_PROP_ENERGY_EMPTY,
+	BATTERY_PROP_ENERGY_NOW,
+	BATTERY_PROP_ENERGY_AVG,
+	BATTERY_PROP_CAPACITY, /* in percents! */
+	BATTERY_PROP_TEMP,
+	BATTERY_PROP_TIME_TO_EMPTY_NOW,
+	BATTERY_PROP_TIME_TO_EMPTY_AVG,
+	BATTERY_PROP_TIME_TO_FULL_NOW,
+	BATTERY_PROP_TIME_TO_FULL_AVG,
+};
+
+struct battery {
+	char *name;
+	enum battery_property *properties;
+	size_t num_properties;
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
+	struct device *dev;
+	struct power_supplicant pst;
+
+#ifdef CONFIG_LEDS_TRIGGERS
+	struct led_trigger *charging_full_trig;
+	char *charging_full_trig_name;
+	struct led_trigger *charging_trig;
+	char *charging_trig_name;
+	struct led_trigger *full_trig;
+	char *full_trig_name;
+#endif
+};
+
+/*
+ * This is recommended structure to specify static battery parameters.
+ * Generic one, parametrizable for different batteries. Battery class
+ * itself does not use it, but that's what implementing most drivers,
+ * should try reuse for consistency.
+ */
+
+struct battery_info {
+	char *name;
+	int voltage_max_design;
+	int voltage_min_design;
+	int charge_full_design;
+	int charge_empty_design;
+	int energy_full_design;
+	int energy_empty_design;
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
+#endif /* __LINUX_BATTERY_H__ */
-- 
1.5.1.1-dirty

