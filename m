Return-Path: <linux-kernel-owner+w=401wt.eu-S932528AbZGPPoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528AbZGPPoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbZGPPoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:44:24 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:46052 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbZGPPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:44:23 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 1/3] pda-power: add set_charged functionaltity
Date: Thu, 16 Jul 2009 17:44:02 +0200
Message-Id: <1247759044-4747-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a function to let the power supply core know that the battery
is fully charged now. This can be done by watching a GPIO line, for
example.

Some battery drivers might need that information to calibrate
themselves.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ian Molton <spyro@f2s.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Matt Reimer <mreimer@vpop.net>
---
 drivers/power/power_supply_core.c |   16 ++++++++++++++++
 include/linux/power_supply.h      |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index 5520040..7303c45 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -111,6 +111,22 @@ int power_supply_is_system_supplied(void)
 	return error;
 }
 
+static int __power_supply_set_battery_charged(struct device *dev, void *data)
+{
+	struct power_supply *psy = dev_get_drvdata(dev);
+
+	if (psy->type == POWER_SUPPLY_TYPE_BATTERY && psy->set_charged)
+		psy->set_charged(psy);
+
+	return 0;
+}
+
+void power_supply_set_battery_charged(void)
+{
+	class_for_each_device(power_supply_class, NULL, NULL,
+				__power_supply_set_battery_charged);
+}
+
 int power_supply_register(struct device *parent, struct power_supply *psy)
 {
 	int rc = 0;
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 594c494..b2b39e2 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -126,6 +126,7 @@ struct power_supply {
 			    enum power_supply_property psp,
 			    union power_supply_propval *val);
 	void (*external_power_changed)(struct power_supply *psy);
+	void (*set_charged)(struct power_supply *psy);
 
 	/* For APM emulation, think legacy userspace. */
 	int use_for_apm;
@@ -170,8 +171,10 @@ extern int power_supply_am_i_supplied(struct power_supply *psy);
 
 #if defined(CONFIG_POWER_SUPPLY) || defined(CONFIG_POWER_SUPPLY_MODULE)
 extern int power_supply_is_system_supplied(void);
+extern void power_supply_set_battery_charged(void);
 #else
 static inline int power_supply_is_system_supplied(void) { return -ENOSYS; }
+static inline void power_supply_set_battery_charged(void) {}
 #endif
 
 extern int power_supply_register(struct device *parent,
-- 
1.6.3.1

