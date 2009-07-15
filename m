Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbZGOQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbZGOQVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932165AbZGOQVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:21:17 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43774 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbZGOQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:21:00 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 3/4] ds2760: add rated_capacity module parameter
Date: Wed, 15 Jul 2009 18:20:40 +0200
Message-Id: <1247674841-9909-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247674841-9909-2-git-send-email-daniel@caiaq.de>
References: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
 <1247674841-9909-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For systems where the ds2760 is soldered directly on the PCB, the 'rated
capacity' register is not set to anything useful.

In order to allow users to bootstrap this value, introduce a new module
parameter 'rated_capacity' and use it to write the internal EEPROM in
case the value differes from what's been given.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index f439071..ed0ea5e 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -66,6 +66,10 @@ static unsigned int pmod_enabled;
 module_param(pmod_enabled, bool, 0644);
 MODULE_PARM_DESC(pmod_enabled, "PMOD enable bit");
 
+static unsigned int rated_capacity;
+module_param(rated_capacity, uint, 0644);
+MODULE_PARM_DESC(rated_capacity, "rated battery capacity, 10*mAh or index");
+
 /* Some batteries have their rated capacity stored a N * 10 mAh, while
  * others use an index into this table. */
 static int rated_capacities[] = {
@@ -274,6 +278,17 @@ static void ds2760_battery_write_status(struct ds2760_device_info *di,
 	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
 }
 
+static void ds2760_battery_write_rated_capacity(struct ds2760_device_info *di,
+						unsigned char rated_capacity)
+{
+	if (rated_capacity == di->raw[DS2760_RATED_CAPACITY])
+		return;
+
+	w1_ds2760_write(di->w1_dev, &rated_capacity, DS2760_RATED_CAPACITY, 1);
+	w1_ds2760_store_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+	w1_ds2760_recall_eeprom(di->w1_dev, DS2760_EEPROM_BLOCK1);
+}
+
 static void ds2760_battery_work(struct work_struct *work)
 {
 	struct ds2760_device_info *di = container_of(work,
@@ -399,6 +414,10 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 
 	ds2760_battery_write_status(di, status);
 
+	/* set rated capacity from module param */
+	if (rated_capacity)
+		ds2760_battery_write_rated_capacity(di, rated_capacity);
+
 	retval = power_supply_register(&pdev->dev, &di->bat);
 	if (retval) {
 		dev_err(di->dev, "failed to register battery\n");
-- 
1.6.3.1

