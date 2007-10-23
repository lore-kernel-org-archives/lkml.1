Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbXJWWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbXJWWhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbXJWWgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47353 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXJWWgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:38 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, len.brown@intel.com
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 3/12] ACPI sbs: fix retval warning
Message-Id: <20071023223636.D6D6B1F81A2@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:36 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/acpi/sbs.c: In function ‘acpi_battery_add’:
drivers/acpi/sbs.c:811: warning: ignoring return value of ‘device_create_file’, declared with attribute warn_unused_result

Additional cleanups:
* use struct acpi_battery in acpi_battery_remove() to clean up function
calls, just like acpi_battery_add() already does.

* un-indent unregister call, as it mistakenly gives the impression that
it belongs inside the 'if' test

* remove unneeded braces

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 90fd09c..c5c011b 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -113,6 +113,7 @@ struct acpi_battery {
 	u16 spec;
 	u8 id;
 	u8 present:1;
+	u8 have_sysfs:1;
 };
 
 #define to_acpi_battery(x) container_of(x, struct acpi_battery, bat);
@@ -808,7 +809,8 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 	}
 	battery->bat.get_property = acpi_sbs_battery_get_property;
 	result = power_supply_register(&sbs->device->dev, &battery->bat);
-	device_create_file(battery->bat.dev, &alarm_attr);
+	if (device_create_file(battery->bat.dev, &alarm_attr) == 0)
+		battery->have_sysfs = 1;
 	printk(KERN_INFO PREFIX "%s [%s]: Battery Slot [%s] (battery %s)\n",
 	       ACPI_SBS_DEVICE_NAME, acpi_device_bid(sbs->device),
 	       battery->name, sbs->battery->present ? "present" : "absent");
@@ -817,14 +819,16 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
-	if (sbs->battery[id].bat.dev)
-		device_remove_file(sbs->battery[id].bat.dev, &alarm_attr);
-		power_supply_unregister(&sbs->battery[id].bat);
+	struct acpi_battery *battery = &sbs->battery[id];
+
+	if (battery->have_sysfs)
+		device_remove_file(battery->bat.dev, &alarm_attr);
+
+	power_supply_unregister(&battery->bat);
+
 #ifdef CONFIG_ACPI_PROCFS
-	if (sbs->battery[id].proc_entry) {
-		acpi_sbs_remove_fs(&(sbs->battery[id].proc_entry),
-				   acpi_battery_dir);
-	}
+	if (sbs->battery[id].proc_entry)
+		acpi_sbs_remove_fs(&battery->proc_entry, acpi_battery_dir);
 #endif
 }
 
