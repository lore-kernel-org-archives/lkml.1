Return-Path: <linux-kernel-owner+w=401wt.eu-S935420AbXLQCaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935420AbXLQCaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935443AbXLQC3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:29:50 -0500
Received: from mail.queued.net ([207.210.101.209]:4541 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935438AbXLQC3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:29:47 -0500
Date: Sun, 16 Dec 2007 21:29:46 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 5/5] power: convert power_supply static attribs to new API
Message-ID: <20071216212946.5ac4b6a0@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This allows us to share the uevent callback code w/ the dynamic attrib
stuff.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/power_supply_sysfs.c |   50 ++++++++----------------------------
 include/linux/power_supply.h       |    9 ++++++
 2 files changed, 20 insertions(+), 39 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 9091c66..7e2c9de 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -26,17 +26,16 @@
  * (as a macro let's say).
  */
 
-static ssize_t power_supply_show_static_attrs(struct device *dev,
-					      struct device_attribute *attr,
-					      char *buf) {
-	static char *type_text[] = { "Battery", "UPS", "Mains", "USB" };
+static ssize_t power_supply_show_type(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
 	struct power_supply *psy = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", type_text[psy->type]);
+	return power_supply_type_str(psy->type, buf);
 }
 
 static struct device_attribute power_supply_static_attrs[] = {
-	__ATTR(type, 0444, power_supply_show_static_attrs, NULL),
+	__ATTR(type, S_IRUGO, power_supply_show_type, NULL),
 };
 
 int power_supply_create_attrs(struct power_supply *psy)
@@ -187,9 +186,8 @@ static int add_uevent_arg_wrapper(struct power_supply *psy,
 int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct power_supply *psy = dev_get_drvdata(dev);
+	struct device_attribute *attr;
 	int ret = 0, j;
-	char *prop_buf;
-	char *attrname;
 
 	dev_dbg(dev, "uevent\n");
 
@@ -204,42 +202,18 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (ret)
 		return ret;
 
-	prop_buf = (char *)get_zeroed_page(GFP_KERNEL);
-	if (!prop_buf)
-		return -ENOMEM;
-
 	for (j = 0; j < ARRAY_SIZE(power_supply_static_attrs); j++) {
-		struct device_attribute *attr;
-		char *line;
-
 		attr = &power_supply_static_attrs[j];
-
-		ret = power_supply_show_static_attrs(dev, attr, prop_buf);
+		ret = add_uevent_arg_wrapper(psy, attr, env);
 		if (ret < 0)
 			goto out;
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
-		dev_dbg(dev, "Static prop %s=%s\n", attrname, prop_buf);
-
-		ret = add_uevent_var(env, "POWER_SUPPLY_%s=%s", attrname, prop_buf);
-		kfree(attrname);
-		if (ret)
-			goto out;
 	}
+	dev_dbg(dev, "%zd static props\n", j);
 
 	for (j = 0; psy->props[j]; j++) {
-		struct device_attribute *attr = psy->props[j];
-
+		attr = psy->props[j];
 		ret = add_uevent_arg_wrapper(psy, attr, env);
+
 		/*
 		 * When a battery is absent, we expect -ENODEV.  Don't abort;
 		 * send the uevent with at least the PRESENT=0 property.
@@ -250,7 +224,5 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 	dev_dbg(dev, "%zd dynamic props\n", j);
 
 out:
-	free_page((unsigned long)prop_buf);
-
 	return ret;
 }
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index e4db02e..2fd6739 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -146,6 +146,15 @@ enum power_supply_type {
 	POWER_SUPPLY_TYPE_USB,
 };
 
+static inline ssize_t power_supply_type_str(int type, char *buf)
+{
+	static char *type_text[] = { "Battery", "UPS", "Mains", "USB" };
+
+	BUG_ON(type < POWER_SUPPLY_TYPE_BATTERY ||
+			type > POWER_SUPPLY_TYPE_USB);
+	return sprintf(buf, "%s\n", type_text[type]);
+}
+
 struct power_supply {
 	const char *name;
 	enum power_supply_type type;
-- 
1.5.3.5

