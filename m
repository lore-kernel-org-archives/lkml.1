Return-Path: <linux-kernel-owner+w=401wt.eu-S935148AbXLQCY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935148AbXLQCY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbXLQCYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:24:49 -0500
Received: from mail.queued.net ([207.210.101.209]:2431 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbXLQCYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:24:48 -0500
Date: Sun, 16 Dec 2007 21:24:43 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, cbou@mail.ru,
       akpm@linux-foundation.org
Subject: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071216212443.4a1fff3d@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This API has the power_supply drivers device their own device_attribute
list; I find this to be a lot more flexible and cleaner.  For example,
rather than having a function with a huge switch statement (as olpc_battery
currently has), we have separate callback functions.  We're not limited
to drivers only being able to pass 'int' and 'char*'s in sysfs, we're
not forced to keep a global string around in memory (as is again the
case for olpc_battery's serial number code), we don't have ordering
restrictions w/ the return value being interpreted based upon where it's
located in the array... etc.  The other API seems to encourage driver
authors to get their custom sysfs knobs into the list of sysfs knobs, and
this one doesn't.

If there is interest in this API, I'll convert the rest of the power_supply
drivers over to it and resubmit patches.

Ignore the psy->num_properties indentation below; that was done so patch #4
wasn't stupidly large.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/power_supply_core.c  |    9 +++
 drivers/power/power_supply_leds.c  |   18 +++++
 drivers/power/power_supply_sysfs.c |  123 ++++++++++++++++++++++++++++++++++++
 include/linux/power_supply.h       |   96 ++++++++++++++++++++++++++++
 4 files changed, 246 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index a63b75c..09013e8 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -67,9 +67,18 @@ int power_supply_am_i_supplied(struct power_supply *psy)
 
 		for (i = 0; i < epsy->num_supplicants; i++) {
 			if (!strcmp(epsy->supplied_to[i], psy->name)) {
+				if (epsy->num_properties) {
 				if (epsy->get_property(epsy,
 					  POWER_SUPPLY_PROP_ONLINE, &ret))
 					continue;
+				} else {
+					/* new API */
+				struct device_attribute *attr;
+				attr = power_supply_find_attr(epsy, "online");
+				if (!attr || power_supply_attr_run(epsy, attr,
+						str_to_int, &ret.intval))
+					continue;
+				}
 				if (ret.intval)
 					goto out;
 			}
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 7f8f359..45539b7 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -17,9 +17,18 @@
 static void power_supply_update_bat_leds(struct power_supply *psy)
 {
 	union power_supply_propval status;
+	struct device_attribute *attr;
 
+	if (psy->num_properties) {
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
 		return;
+	} else {
+		/* new API */
+	attr = power_supply_find_attr(psy, "status");
+	if (!attr || power_supply_attr_run(psy, attr, str_to_int,
+			&status.intval))
+		return;
+	}
 
 	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, status.intval);
 
@@ -102,9 +111,18 @@ static void power_supply_remove_bat_triggers(struct power_supply *psy)
 static void power_supply_update_gen_leds(struct power_supply *psy)
 {
 	union power_supply_propval online;
+	struct device_attribute *attr;
 
+	if (psy->num_properties) {
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_ONLINE, &online))
 		return;
+	} else {
+		/* new API */
+	attr = power_supply_find_attr(psy, "online");
+	if (!attr || power_supply_attr_run(psy, attr, str_to_int,
+			&online.intval))
+		return;
+	}
 
 	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, online.intval);
 
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 8efedba..3e44d16 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -138,19 +138,34 @@ int power_supply_create_attrs(struct power_supply *psy)
 			goto statics_failed;
 	}
 
+	if (psy->num_properties) {
 	for (j = 0; j < psy->num_properties; j++) {
 		rc = device_create_file(psy->dev,
 			    &power_supply_attrs[psy->properties[j]]);
 		if (rc)
 			goto dynamics_failed;
 	}
+	} else {
+		/* new API */
+	for (j = 0; psy->props[j]; j++) {
+		rc = device_create_file(psy->dev, psy->props[j]);
+		if (rc)
+			goto dynamics_failed;
+	}
+	}
 
 	goto succeed;
 
 dynamics_failed:
+	if (psy->num_properties) {
 	while (j--)
 		device_remove_file(psy->dev,
 			   &power_supply_attrs[psy->properties[j]]);
+	} else {
+		/* new API */
+	while (j--)
+		device_remove_file(psy->dev, psy->props[j]);
+	}
 statics_failed:
 	while (i--)
 		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
@@ -165,9 +180,56 @@ void power_supply_remove_attrs(struct power_supply *psy)
 	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
 		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
 
+	if (psy->num_properties) {
 	for (i = 0; i < psy->num_properties; i++)
 		device_remove_file(psy->dev,
 			    &power_supply_attrs[psy->properties[i]]);
+	} else {
+		/* new API */
+	for (i = 0; psy->props[i]; i++)
+		device_remove_file(psy->dev, psy->props[i]);
+	}
+}
+
+struct device_attribute *power_supply_find_attr(struct power_supply *psy,
+		const char *name)
+{
+	struct device_attribute **attr;
+
+	for (attr = psy->props; *attr; attr++) {
+		if (!strcmp((*attr)->attr.name, name))
+			return *attr;
+	}
+
+	return NULL;
+}
+
+/*
+ * Attempt to provide a nice way to call device_attribute show() callbacks.
+ * Allocate the buffer, run ->show(), and then call callback() to allow the
+ * caller to parse the buffer and fill in 'arg' (without having to worry
+ * about managing the buffer).
+ */
+int power_supply_attr_run(struct power_supply *psy,
+		struct device_attribute *attr,
+		void (*callback)(const char *buf, void *arg), void *arg)
+{
+	char *buf;
+	int ret = -ENOMEM;
+
+	buf = (char *) get_zeroed_page(GFP_KERNEL);
+	if (!buf)
+		goto out;
+
+	ret = attr->show(psy->dev, attr, buf);
+	if (ret < 0)
+		goto out;
+	callback(buf, arg);
+	ret = 0;
+out:
+	if (buf)
+		free_page((unsigned long) buf);
+	return ret;
 }
 
 static char *kstruprdup(const char *str, gfp_t gfp)
@@ -187,6 +249,52 @@ static char *kstruprdup(const char *str, gfp_t gfp)
 	return ret;
 }
 
+/*
+ * This is a hack to stuff 4 args into a callback function that only
+ * takes 1 arg; add_uevent_arg_wrapper() below handles the details of it.
+ */
+struct uevent_arg {
+	struct device *dev;
+	struct kobj_uevent_env *env;
+	char *attrname;
+	int ret;
+};
+
+static void call_add_uevent_var(const char *buf, void *arg)
+{
+	struct uevent_arg *uarg = arg;
+	char *line;
+
+	line = strchr(buf, '\n');
+	if (line)
+		*line = 0;
+
+	dev_dbg(uarg->dev, "prop %s=%s\n", uarg->attrname, buf);
+	uarg->ret = add_uevent_var(uarg->env, "POWER_SUPPLY_%s=%s",
+			uarg->attrname, buf);
+}
+
+static int add_uevent_arg_wrapper(struct power_supply *psy,
+		struct device_attribute *attr, struct kobj_uevent_env *env)
+{
+	struct uevent_arg uarg = {
+		.dev = psy->dev,
+		.env = env,
+	};
+	int ret;
+
+	uarg.attrname = kstruprdup(attr->attr.name, GFP_KERNEL);
+	if (!uarg.attrname)
+		return -ENOMEM;
+
+	ret = power_supply_attr_run(psy, attr, call_add_uevent_var, &uarg);
+	if (ret >= 0)
+		ret = uarg.ret;
+
+	kfree(uarg.attrname);
+	return ret;
+}
+
 int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct power_supply *psy = dev_get_drvdata(dev);
@@ -239,6 +347,7 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 			goto out;
 	}
 
+	if (psy->num_properties) {
 	dev_dbg(dev, "%zd dynamic props\n", psy->num_properties);
 
 	for (j = 0; j < psy->num_properties; j++) {
@@ -275,6 +384,20 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 		if (ret)
 			goto out;
 	}
+	} else {
+		/* new API */
+
+	for (j = 0; psy->props[j]; j++) {
+		struct device_attribute *attr = psy->props[j];
+
+		ret = add_uevent_arg_wrapper(psy, attr, env);
+		/* When a battery is absent, we expect -ENODEV.  Don't abort;
+		 * send the uevent with at least the PRESENT=0 property. */
+		if (ret < 0 && ret != -ENODEV)
+			goto out;
+	}
+	dev_dbg(dev, "%zd dynamic props\n", j);
+	}
 
 out:
 	free_page((unsigned long)prop_buf);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 358b38d..21251a3 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -38,6 +38,17 @@ enum {
 	POWER_SUPPLY_STATUS_FULL,
 };
 
+static inline ssize_t power_supply_status_str(int status, char *buf)
+{
+	static char *status_text[] = {
+		"Unknown", "Charging", "Discharging", "Not charging", "Full"
+	};
+
+	BUG_ON(status < POWER_SUPPLY_STATUS_UNKNOWN ||
+			status > POWER_SUPPLY_STATUS_FULL);
+	return sprintf(buf, "%s\n", status_text[status]);
+}
+
 enum {
 	POWER_SUPPLY_HEALTH_UNKNOWN = 0,
 	POWER_SUPPLY_HEALTH_GOOD,
@@ -47,6 +58,18 @@ enum {
 	POWER_SUPPLY_HEALTH_UNSPEC_FAILURE,
 };
 
+static inline ssize_t power_supply_health_str(int health, char *buf)
+{
+	static char *health_text[] = {
+		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
+		"Unspecified failure"
+	};
+
+	BUG_ON(health < POWER_SUPPLY_HEALTH_UNKNOWN ||
+			health > POWER_SUPPLY_HEALTH_UNSPEC_FAILURE);
+	return sprintf(buf, "%s\n", health_text[health]);
+}
+
 enum {
 	POWER_SUPPLY_TECHNOLOGY_UNKNOWN = 0,
 	POWER_SUPPLY_TECHNOLOGY_NiMH,
@@ -56,6 +79,66 @@ enum {
 	POWER_SUPPLY_TECHNOLOGY_NiCd,
 };
 
+static inline ssize_t power_supply_technology_str(int tech, char *buf)
+{
+	static char *technology_text[] = {
+		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
+	};
+
+	BUG_ON(tech < POWER_SUPPLY_TECHNOLOGY_UNKNOWN ||
+			tech > POWER_SUPPLY_TECHNOLOGY_NiCd);
+	return sprintf(buf, "%s\n", technology_text[tech]);
+}
+
+/* suggested fields to support */
+#define POWER_SUPPLY_STATUS(cb)     __ATTR(status, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_HEALTH(cb)     __ATTR(health, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_PRESENT(cb)    __ATTR(present, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ONLINE(cb)     __ATTR(online, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_TECHNOLOGY(cb) __ATTR(technology, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_VOLT_MAX(cb)   __ATTR(voltage_max_design, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_VOLT_MIN(cb)   __ATTR(voltage_min_design, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_VOLT_NOW(cb)   __ATTR(voltage_now, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_VOLT_AVG(cb)   __ATTR(voltage_avg, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CURR_NOW(cb)   __ATTR(current_now, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CURR_AVG(cb)   __ATTR(current_avg, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CHG_FULL_DESIGN(cb) __ATTR(charge_full_design, \
+						S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CHG_EMPTY_DESIGN(cb) __ATTR(charge_empty_, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_CHG_FULL(cb)   __ATTR(charge_full, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CHG_EMPTY(cb)  __ATTR(charge_empty, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CHG_NOW(cb)    __ATTR(charge_now, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_CHG_AVG(cb)    __ATTR(charge_empty, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ENERGY_FULL_DESIGN(cb) __ATTR(energy_full_design, \
+						S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ENERGY_EMPTY_DESIGN(cb) __ATTR(energy_empty_design, \
+						S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ENERGY_FULL(cb) __ATTR(energy_full, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ENERGY_EMPTY(cb) __ATTR(energy_empty, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_ENERGY_NOW(cb) __ATTR(energy_now, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_ENERGY_AVG(cb) __ATTR(energy_avg, S_IRUGO, cb, NULL)
+/* capacity is in percents! */
+#define POWER_SUPPLY_CAPACITY(cb)   __ATTR(capacity, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_TEMP(cb)       __ATTR(temp, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_TEMP_AMB(cb)   __ATTR(temp_ambient, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_TTE_NOW(cb)    __ATTR(time_to_empty_now, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_TTE_AVG(cb)    __ATTR(time_to_empty_avg, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_TTF_NOW(cb)    __ATTR(time_to_full_now, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_TTF_AVG(cb)    __ATTR(time_to_full_avg, S_IRUGO, \
+						cb, NULL)
+#define POWER_SUPPLY_MODEL(cb)      __ATTR(model_name, S_IRUGO, cb, NULL)
+#define POWER_SUPPLY_MFR(cb)        __ATTR(manufacturer, S_IRUGO, cb, NULL)
+
+/* be sure to end the property list with this! */
+#define POWER_SUPPLY_END            __ATTR_NULL
+
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
@@ -110,6 +193,7 @@ struct power_supply {
 	enum power_supply_type type;
 	enum power_supply_property *properties;
 	size_t num_properties;
+	struct device_attribute **props;
 
 	char **supplied_to;
 	size_t num_supplicants;
@@ -164,6 +248,18 @@ extern int power_supply_register(struct device *parent,
 				 struct power_supply *psy);
 extern void power_supply_unregister(struct power_supply *psy);
 
+extern struct device_attribute *power_supply_find_attr(struct power_supply *psy,
+		const char *name);
+extern int power_supply_attr_run(struct power_supply *psy,
+		struct device_attribute *attr,
+		void (*callback)(const char *buf, void *arg), void *arg);
+
+/* helper function for power_supply_attr_run() */
+static inline void str_to_int(const char *buf, void *arg)
+{
+	*(int *)arg = simple_strtol(buf, NULL, 0);
+}
+
 /* For APM emulation, think legacy userspace. */
 extern struct class *power_supply_class;
 
-- 
1.5.3.5

