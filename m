Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZGWSgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZGWSgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZGWSgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:36:13 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51148 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZGWSgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:36:11 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Ian Molton <spyro@f2s.com>,
       Anton Vorontsov <cbou@mail.ru>, Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 1/2] power_supply: get_by_name and set_charged functionality
Date: Thu, 23 Jul 2009 20:35:53 +0200
Message-Id: <1248374154-15606-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090723183451.GI13236@buzzloop.caiaq.de>
References: <20090723183451.GI13236@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a function to get a power_supply device from the class of
registered devices by name reference. It can be used to find a specific
battery to call power_supply_set_battery_charged() on.

Some battery drivers might need that information to calibrate
themselves.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ian Molton <spyro@f2s.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Matt Reimer <mreimer@vpop.net>
---
 drivers/power/power_supply_core.c |   28 ++++++++++++++++++++++++++++
 include/linux/power_supply.h      |    3 +++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 58f10ac..ddb4800 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -117,6 +117,34 @@ int power_supply_is_system_supplied(void)
 }
 EXPORT_SYMBOL_GPL(power_supply_is_system_supplied);
 
+int power_supply_set_battery_charged(struct power_supply *psy)
+{
+	if (psy->type == POWER_SUPPLY_TYPE_BATTERY && psy->set_charged) {
+		psy->set_charged(psy);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(power_supply_set_battery_charged);
+
+static int power_supply_match_device_by_name(struct device *dev, void *data)
+{
+	const char *name = data;
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	return strcmp(psy->name, name) == 0;
+}
+
+struct power_supply *power_supply_get_by_name(char *name)
+{
+	struct device *dev = class_find_device(power_supply_class, NULL, name,
+					power_supply_match_device_by_name);
+
+	return dev ? dev_get_drvdata(dev) : NULL;
+}
+EXPORT_SYMBOL_GPL(power_supply_get_by_name);
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 594c494..49f3296 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -126,6 +126,7 @@ struct power_supply {
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
 	void (*external_power_changed)(struct power_supply *psy);
+	void (*set_charged)(struct power_supply *psy);
 
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
@@ -165,8 +166,10 @@ struct power_supply_info {
 	int use_for_apm;
 };
 
+extern struct power_supply *power_supply_get_by_name(char *name);
 extern void power_supply_changed(struct power_supply *psy);
 extern int power_supply_am_i_supplied(struct power_supply *psy);
+extern int power_supply_set_battery_charged(struct power_supply *psy);
 
 #if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
 extern int power_supply_is_system_supplied(void);
-- 
1.6.3.1

