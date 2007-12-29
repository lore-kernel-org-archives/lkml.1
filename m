Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXL2BLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXL2BLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbXL2BLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:11:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25238 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbXL2BLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=izOrOISN+lBnhrhQnzXeYCOm3cga2Jlk+K/bbaTTgkzhF11qZNaM0+5/3qkfrPf+RSmyirIfdkIgWJEgcDcZips75MM5S8UgqL55Ui0XOf7O5koqvJrTV4sNYT3I1v4C0lm50a/y4ZVllNUAXeS3KoXNhF7v6swRf2zH9wSLd+M=
Date: Sat, 29 Dec 2007 09:14:48 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 08/12] power supply : Use mutex instead of semaphore in
	driver core
Message-ID: <20071229011448.GI2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/power/apm_power.c         |    6 +++---
drivers/power/power_supply_core.c |    8 ++++----
2 files changed, 7 insertions(+), 7 deletions(-)

diff -upr linux/drivers/power/apm_power.c linux.new/drivers/power/apm_power.c
--- linux/drivers/power/apm_power.c	2007-12-28 10:36:26.000000000 +0800
+++ linux.new/drivers/power/apm_power.c	2007-12-28 10:38:03.000000000 +0800
@@ -207,10 +207,10 @@ static void apm_battery_apm_get_power_st
 	union power_supply_propval status;
 	union power_supply_propval capacity, time_to_full, time_to_empty;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&power_supply_class->mutex);
 	find_main_battery();
 	if (!main_battery) {
-		up(&power_supply_class->sem);
+		mutex_unlock(&power_supply_class->mutex);
 		return;
 	}
 
@@ -278,7 +278,7 @@ static void apm_battery_apm_get_power_st
 		}
 	}
 
-	up(&power_supply_class->sem);
+	mutex_unlock(&power_supply_class->mutex);
 }
 
 static int __init apm_battery_init(void)
diff -upr linux/drivers/power/power_supply_core.c linux.new/drivers/power/power_supply_core.c
--- linux/drivers/power/power_supply_core.c	2007-12-28 10:36:49.000000000 +0800
+++ linux.new/drivers/power/power_supply_core.c	2007-12-28 10:38:55.000000000 +0800
@@ -31,7 +31,7 @@ static void power_supply_changed_work(st
 	for (i = 0; i < psy->num_supplicants; i++) {
 		struct device *dev;
 
-		down(&power_supply_class->sem);
+		mutex_lock(&power_supply_class->mutex);
 		list_for_each_entry(dev, &power_supply_class->devices, node) {
 			struct power_supply *pst = dev_get_drvdata(dev);
 
@@ -40,7 +40,7 @@ static void power_supply_changed_work(st
 					pst->external_power_changed(pst);
 			}
 		}
-		up(&power_supply_class->sem);
+		mutex_unlock(&power_supply_class->mutex);
 	}
 
 	power_supply_update_leds(psy);
@@ -60,7 +60,7 @@ int power_supply_am_i_supplied(struct po
 	union power_supply_propval ret = {0,};
 	struct device *dev;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&power_supply_class->mutex);
 	list_for_each_entry(dev, &power_supply_class->devices, node) {
 		struct power_supply *epsy = dev_get_drvdata(dev);
 		int i;
@@ -76,7 +76,7 @@ int power_supply_am_i_supplied(struct po
 		}
 	}
 out:
-	up(&power_supply_class->sem);
+	mutex_unlock(&power_supply_class->mutex);
 
 	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
 
