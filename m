Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYACFy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYACFy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYACFyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:54:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:47269 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYACFyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=kDMOYNYAiF1KCnPfr/A2n6E6i/x5XhUY7E4q2gvMRRaWD4j4OEWzzcvWxomGePXg7+sr1dFuKyRwQpUhWoTpGYiPXsvGUDTcdKX162lC3kIycVUDB1uKnJieQ9mR/eX13v1HvqI79xprJ6/DJGD/9JfbtCpalDSLH70UfNgOFR0=
Date: Thu, 3 Jan 2008 13:58:23 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 4/7] power supply : convert semaphore to mutex in struct
	class
Message-ID: <20080103055823.GE4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

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
 
