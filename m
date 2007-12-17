Return-Path: <linux-kernel-owner+w=401wt.eu-S934469AbXLQC3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbXLQC3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935347AbXLQC3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:29:37 -0500
Received: from mail.queued.net ([207.210.101.209]:4537 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935255AbXLQC3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:29:35 -0500
Date: Sun, 16 Dec 2007 21:29:32 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 4/5] power: drop support for old API
Message-ID: <20071216212932.66edf769@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/power_supply_core.c  |   17 +---
 drivers/power/power_supply_leds.c  |   30 ++-----
 drivers/power/power_supply_sysfs.c |  158 +-----------------------------------
 include/linux/power_supply.h       |   47 -----------
 4 files changed, 17 insertions(+), 235 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 09013e8..f5bf67b 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -57,8 +57,8 @@ void power_supply_changed(struct power_supply *psy)
 
 int power_supply_am_i_supplied(struct power_supply *psy)
 {
-	union power_supply_propval ret = {0,};
 	struct device *dev;
+	int ret;
 
 	down(&power_supply_class->sem);
 	list_for_each_entry(dev, &power_supply_class->devices, node) {
@@ -67,19 +67,12 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 
 		for (i = 0; i < epsy->num_supplicants; i++) {
 			if (!strcmp(epsy->supplied_to[i], psy->name)) {
-				if (epsy->num_properties) {
-				if (epsy->get_property(epsy,
-					  POWER_SUPPLY_PROP_ONLINE, &ret))
-					continue;
-				} else {
-					/* new API */
 				struct device_attribute *attr;
 				attr = power_supply_find_attr(epsy, "online");
 				if (!attr || power_supply_attr_run(epsy, attr,
-						str_to_int, &ret.intval))
+						str_to_int, &ret))
 					continue;
-				}
-				if (ret.intval)
+				if (ret)
 					goto out;
 			}
 		}
@@ -87,9 +80,9 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 out:
 	up(&power_supply_class->sem);
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
+	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret);
 
-	return ret.intval;
+	return ret;
 }
 
 int power_supply_register(struct device *parent, struct power_supply *psy)
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 45539b7..b71c583 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -16,23 +16,16 @@
 
 static void power_supply_update_bat_leds(struct power_supply *psy)
 {
-	union power_supply_propval status;
 	struct device_attribute *attr;
+	int status;
 
-	if (psy->num_properties) {
-	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
-		return;
-	} else {
-		/* new API */
 	attr = power_supply_find_attr(psy, "status");
-	if (!attr || power_supply_attr_run(psy, attr, str_to_int,
-			&status.intval))
+	if (!attr || power_supply_attr_run(psy, attr, str_to_int, &status))
 		return;
-	}
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, status.intval);
+	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, status);
 
-	switch (status.intval) {
+	switch (status) {
 	case POWER_SUPPLY_STATUS_FULL:
 		led_trigger_event(psy->charging_full_trig, LED_FULL);
 		led_trigger_event(psy->charging_trig, LED_OFF);
@@ -110,23 +103,16 @@ static void power_supply_remove_bat_triggers(struct power_supply *psy)
 
 static void power_supply_update_gen_leds(struct power_supply *psy)
 {
-	union power_supply_propval online;
 	struct device_attribute *attr;
+	int online;
 
-	if (psy->num_properties) {
-	if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
-		return;
-	} else {
-		/* new API */
 	attr = power_supply_find_attr(psy, "online");
-	if (!attr || power_supply_attr_run(psy, attr, str_to_int,
-			&online.intval))
+	if (!attr || power_supply_attr_run(psy, attr, str_to_int, &online))
 		return;
-	}
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, online.intval);
+	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, online);
 
-	if (online.intval)
+	if (online)
 		led_trigger_event(psy->online_trig, LED_FULL);
 	else
 		led_trigger_event(psy->online_trig, LED_OFF);
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 3e44d16..9091c66 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -26,93 +26,6 @@
  * (as a macro let's say).
  */
 
-#define POWER_SUPPLY_ATTR(_name)					\
-{									\
-	.attr = { .name = #_name, .mode = 0444, .owner = THIS_MODULE },	\
-	.show = power_supply_show_property,				\
-	.store = NULL,							\
-}
-
-static struct device_attribute power_supply_attrs[];
-
-static ssize_t power_supply_show_property(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf) {
-	static char *status_text[] = {
-		"Unknown", "Charging", "Discharging", "Not charging", "Full"
-	};
-	static char *health_text[] = {
-		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
-		"Unspecified failure"
-	};
-	static char *technology_text[] = {
-		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
-	};
-	ssize_t ret;
-	struct power_supply *psy = dev_get_drvdata(dev);
-	const ptrdiff_t off = attr - power_supply_attrs;
-	union power_supply_propval value;
-
-	ret = psy->get_property(psy, off, &value);
-
-	if (ret < 0) {
-		if (ret != -ENODEV)
-			dev_err(dev, "driver failed to report `%s' property\n",
-				attr->attr.name);
-		return ret;
-	}
-
-	if (off == POWER_SUPPLY_PROP_STATUS)
-		return sprintf(buf, "%s\n", status_text[value.intval]);
-	else if (off == POWER_SUPPLY_PROP_HEALTH)
-		return sprintf(buf, "%s\n", health_text[value.intval]);
-	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
-		return sprintf(buf, "%s\n", technology_text[value.intval]);
-	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
-		return sprintf(buf, "%s\n", value.strval);
-
-	return sprintf(buf, "%d\n", value.intval);
-}
-
-/* Must be in the same order as POWER_SUPPLY_PROP_* */
-static struct device_attribute power_supply_attrs[] = {
-	/* Properties of type `int' */
-	POWER_SUPPLY_ATTR(status),
-	POWER_SUPPLY_ATTR(health),
-	POWER_SUPPLY_ATTR(present),
-	POWER_SUPPLY_ATTR(online),
-	POWER_SUPPLY_ATTR(technology),
-	POWER_SUPPLY_ATTR(voltage_max_design),
-	POWER_SUPPLY_ATTR(voltage_min_design),
-	POWER_SUPPLY_ATTR(voltage_now),
-	POWER_SUPPLY_ATTR(voltage_avg),
-	POWER_SUPPLY_ATTR(current_now),
-	POWER_SUPPLY_ATTR(current_avg),
-	POWER_SUPPLY_ATTR(charge_full_design),
-	POWER_SUPPLY_ATTR(charge_empty_design),
-	POWER_SUPPLY_ATTR(charge_full),
-	POWER_SUPPLY_ATTR(charge_empty),
-	POWER_SUPPLY_ATTR(charge_now),
-	POWER_SUPPLY_ATTR(charge_avg),
-	POWER_SUPPLY_ATTR(energy_full_design),
-	POWER_SUPPLY_ATTR(energy_empty_design),
-	POWER_SUPPLY_ATTR(energy_full),
-	POWER_SUPPLY_ATTR(energy_empty),
-	POWER_SUPPLY_ATTR(energy_now),
-	POWER_SUPPLY_ATTR(energy_avg),
-	POWER_SUPPLY_ATTR(capacity),
-	POWER_SUPPLY_ATTR(capacity_level),
-	POWER_SUPPLY_ATTR(temp),
-	POWER_SUPPLY_ATTR(temp_ambient),
-	POWER_SUPPLY_ATTR(time_to_empty_now),
-	POWER_SUPPLY_ATTR(time_to_empty_avg),
-	POWER_SUPPLY_ATTR(time_to_full_now),
-	POWER_SUPPLY_ATTR(time_to_full_avg),
-	/* Properties of type `const char *' */
-	POWER_SUPPLY_ATTR(model_name),
-	POWER_SUPPLY_ATTR(manufacturer),
-};
-
 static ssize_t power_supply_show_static_attrs(struct device *dev,
 					      struct device_attribute *attr,
 					      char *buf) {
@@ -138,34 +51,17 @@ int power_supply_create_attrs(struct power_supply *psy)
 			goto statics_failed;
 	}
 
-	if (psy->num_properties) {
-	for (j = 0; j < psy->num_properties; j++) {
-		rc = device_create_file(psy->dev,
-			    &power_supply_attrs[psy->properties[j]]);
-		if (rc)
-			goto dynamics_failed;
-	}
-	} else {
-		/* new API */
 	for (j = 0; psy->props[j]; j++) {
 		rc = device_create_file(psy->dev, psy->props[j]);
 		if (rc)
 			goto dynamics_failed;
 	}
-	}
 
 	goto succeed;
 
 dynamics_failed:
-	if (psy->num_properties) {
-	while (j--)
-		device_remove_file(psy->dev,
-			   &power_supply_attrs[psy->properties[j]]);
-	} else {
-		/* new API */
 	while (j--)
 		device_remove_file(psy->dev, psy->props[j]);
-	}
 statics_failed:
 	while (i--)
 		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
@@ -180,15 +76,8 @@ void power_supply_remove_attrs(struct power_supply *psy)
 	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
 		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
 
-	if (psy->num_properties) {
-	for (i = 0; i < psy->num_properties; i++)
-		device_remove_file(psy->dev,
-			    &power_supply_attrs[psy->properties[i]]);
-	} else {
-		/* new API */
 	for (i = 0; psy->props[i]; i++)
 		device_remove_file(psy->dev, psy->props[i]);
-	}
 }
 
 struct device_attribute *power_supply_find_attr(struct power_supply *psy,
@@ -347,57 +236,18 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 			goto out;
 	}
 
-	if (psy->num_properties) {
-	dev_dbg(dev, "%zd dynamic props\n", psy->num_properties);
-
-	for (j = 0; j < psy->num_properties; j++) {
-		struct device_attribute *attr;
-		char *line;
-
-		attr = &power_supply_attrs[psy->properties[j]];
-
-		ret = power_supply_show_property(dev, attr, prop_buf);
-		if (ret == -ENODEV) {
-			/* When a battery is absent, we expect -ENODEV. Don't abort;
-			   send the uevent with at least the the PRESENT=0 property */
-			ret = 0;
-			continue;
-		}
-
-		if (ret < 0)
-			goto out;
-
-		line = strchr(prop_buf, '\n');
-		if (line)
-			*line = 0;
-
-		attrname = kstruprdup(attr->attr.name, GFP_KERNEL);
-		if (!attrname) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		dev_dbg(dev, "prop %s=%s\n", attrname, prop_buf);
-
-		ret = add_uevent_var(env, "POWER_SUPPLY_%s=%s", attrname, prop_buf);
-		kfree(attrname);
-		if (ret)
-			goto out;
-	}
-	} else {
-		/* new API */
-
 	for (j = 0; psy->props[j]; j++) {
 		struct device_attribute *attr = psy->props[j];
 
 		ret = add_uevent_arg_wrapper(psy, attr, env);
-		/* When a battery is absent, we expect -ENODEV.  Don't abort;
-		 * send the uevent with at least the PRESENT=0 property. */
+		/*
+		 * When a battery is absent, we expect -ENODEV.  Don't abort;
+		 * send the uevent with at least the PRESENT=0 property.
+		 */
 		if (ret < 0 && ret != -ENODEV)
 			goto out;
 	}
 	dev_dbg(dev, "%zd dynamic props\n", j);
-	}
 
 out:
 	free_page((unsigned long)prop_buf);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 21251a3..e4db02e 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -139,43 +139,6 @@ static inline ssize_t power_supply_technology_str(int tech, char *buf)
 /* be sure to end the property list with this! */
 #define POWER_SUPPLY_END            __ATTR_NULL
 
-enum power_supply_property {
-	/* Properties of type `int' */
-	POWER_SUPPLY_PROP_STATUS = 0,
-	POWER_SUPPLY_PROP_HEALTH,
-	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_ONLINE,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
-	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
-	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_VOLTAGE_AVG,
-	POWER_SUPPLY_PROP_CURRENT_NOW,
-	POWER_SUPPLY_PROP_CURRENT_AVG,
-	POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN,
-	POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN,
-	POWER_SUPPLY_PROP_CHARGE_FULL,
-	POWER_SUPPLY_PROP_CHARGE_EMPTY,
-	POWER_SUPPLY_PROP_CHARGE_NOW,
-	POWER_SUPPLY_PROP_CHARGE_AVG,
-	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
-	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
-	POWER_SUPPLY_PROP_ENERGY_FULL,
-	POWER_SUPPLY_PROP_ENERGY_EMPTY,
-	POWER_SUPPLY_PROP_ENERGY_NOW,
-	POWER_SUPPLY_PROP_ENERGY_AVG,
-	POWER_SUPPLY_PROP_CAPACITY, /* in percents! */
-	POWER_SUPPLY_PROP_TEMP,
-	POWER_SUPPLY_PROP_TEMP_AMBIENT,
-	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
-	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
-	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
-	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
-	/* Properties of type `const char *' */
-	POWER_SUPPLY_PROP_MODEL_NAME,
-	POWER_SUPPLY_PROP_MANUFACTURER,
-};
-
 enum power_supply_type {
 	POWER_SUPPLY_TYPE_BATTERY = 0,
 	POWER_SUPPLY_TYPE_UPS,
@@ -183,24 +146,14 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_USB,
 };
 
-union power_supply_propval {
-	int intval;
-	const char *strval;
-};
-
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
-	enum power_supply_property *properties;
-	size_t num_properties;
 	struct device_attribute **props;
 
 	char **supplied_to;
 	size_t num_supplicants;
 
-	int (*get_property)(struct power_supply *psy,
-			    enum power_supply_property psp,
-			    union power_supply_propval *val);
 	void (*external_power_changed)(struct power_supply *psy);
 
 	/* For APM emulation, think legacy userspace. */
-- 
1.5.3.5

