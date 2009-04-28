Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZD1I4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZD1I4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZD1Iz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:55:28 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41695 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZD1Iz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:55:26 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 3/3] w1: ds2760_battery: add support for sleep mode feature
Date: Tue, 28 Apr 2009 10:55:02 +0200
Message-Id: <1240908902-24646-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1240908902-24646-2-git-send-email-daniel@caiaq.de>
References: <1240908902-24646-1-git-send-email-daniel@caiaq.de>
 <1240908902-24646-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for ds2760's sleep mode feature. With this feature
enabled, the chip enters a deep sleep mode and disconnects from the
battery when the w1 line is held down for more than 2 seconds.

This new behaviour can be switched on and off using a new module
parameter.

Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/power/ds2760_battery.c |   26 ++++++++++++++++++++++++++
 drivers/w1/slaves/w1_ds2760.h  |    5 +++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 9331009..520b5c4 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -62,6 +62,10 @@ static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
 
+static unsigned int pmod_enabled;
+module_param(pmod_enabled, bool, 0644);
+MODULE_PARM_DESC(pmod_enabled, "PMOD enable bit");
+
 /* Some batteries have their rated capacity stored a N * 10 mAh, while
  * others use an index into this table. */
 static int rated_capacities[] = {
@@ -259,6 +263,17 @@ static void ds2760_battery_update_status(struct ds2760_device_info *di)
 		power_supply_changed(&di->bat);
 }
 
+static void ds2760_battery_write_status(struct ds2760_device_info *di,
+					char status)
+{
+	if (status == di->raw[DS2760_STATUS_REG])
+		return;
+
+	w1_ds2760_write(di->w1_dev, &status, DS2760_STATUS_WRITE_REG, 1);
+	w1_ds2760_store_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+}
+
 static void ds2760_battery_work(struct work_struct *work)
 {
 	struct ds2760_device_info *di = container_of(work,
@@ -342,6 +357,7 @@ static enum power_supply_property ds2760_battery_props[] = {
 
 static int ds2760_battery_probe(struct platform_device *pdev)
 {
+	char status;
 	int retval = 0;
 	struct ds2760_device_info *di;
 
@@ -371,6 +387,16 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 		goto batt_failed;
 	}
 
+	/* enable sleep mode feature */
+	ds2760_battery_read_status(di);
+	status = di->raw[DS2760_STATUS_REG];
+	if (pmod_enabled)
+		status |= DS2760_STATUS_PMOD;
+	else
+		status &= ~DS2760_STATUS_PMOD;
+
+	ds2760_battery_write_status(di, status);
+
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
 	di->monitor_wqueue = create_singlethread_workqueue(dev_name(&pdev->dev));
 	if (!di->monitor_wqueue) {
diff --git a/drivers/w1/slaves/w1_ds2760.h b/drivers/w1/slaves/w1_ds2760.h
index ea39419..58e7741 100644
--- a/drivers/w1/slaves/w1_ds2760.h
+++ b/drivers/w1/slaves/w1_ds2760.h
@@ -25,6 +25,10 @@
 
 #define DS2760_PROTECTION_REG		0x00
 #define DS2760_STATUS_REG		0x01
+	#define DS2760_STATUS_IE	(1 << 2)
+	#define DS2760_STATUS_SWEN	(1 << 3)
+	#define DS2760_STATUS_RNAOP	(1 << 4)
+	#define DS2760_STATUS_PMOD	(1 << 5)
 #define DS2760_EEPROM_REG		0x07
 #define DS2760_SPECIAL_FEATURE_REG	0x08
 #define DS2760_VOLTAGE_MSB		0x0c
@@ -38,6 +42,7 @@
 #define DS2760_EEPROM_BLOCK0		0x20
 #define DS2760_ACTIVE_FULL		0x20
 #define DS2760_EEPROM_BLOCK1		0x30
+#define DS2760_STATUS_WRITE_REG		0x31
 #define DS2760_RATED_CAPACITY		0x32
 #define DS2760_CURRENT_OFFSET_BIAS	0x33
 #define DS2760_ACTIVE_EMPTY		0x3b
-- 
1.6.2.1

