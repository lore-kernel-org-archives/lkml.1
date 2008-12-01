Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbYLAVzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbYLAVzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYLAVyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:54:47 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:40247 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751922AbYLAVyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:54:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FXlKy0AVPZg0ZaUmd/ZCgUmmAglb/D9MQN3KXb3bXszRqquC7cLEMqOLJYaYFHSzwcRQTBVa3Zp4QlQk6Q6o2xeHho9aCKlw2NCO8UD2b6RonjI7XMJjnUPddEy/OU/ObIoSBzt99ruE8TM1W10faRCooJyxrf6UNqygyRat54M=  ;
X-YMail-OSG: c5Uvw3IVM1mIihZKDK6aQ3SFWA9R_yP_MiqQw8bxI3lWtWoTL9dYBW2lT5SdG36lZ0UNe1ezWu2_zNclz1cCXW0xwunuh6vxlG_1LQmVfhKlIrTZz0tHqDOI0ZbBeuU_QFwUrnUlQKqzJ5wFFNz2cmdgniFHtkP.2r_uGiJhb1b_Zbno3SL1exvbKWlV
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>, lrg@slimlogic.co.uk
Subject: [patch 2.6.28-rc6+] regulator: bugfixes and messaging cleanup
Date: Mon, 1 Dec 2008 13:35:43 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011335.43551.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Regulator core bugfixes:
  * Move regulator earlier in link sequence.
       It initializes as a core_initcall() to be available early ...
       but links way late, so a regulator that's at subsys_initcall()
       is unavailable to subsystems which need it to initialize.
  * Prevent registration of duplicate "struct regulator" names.
       They'd be unavailable, and clearly indicate something wrong.
  * Some debug messages were wrongly at the KERN_ERR level
       Callers of regulator_get() have a fault code; messages for
       invalid parameters are thus more than usually superfluous.

And messaging updates;
  * Add debug messages when regulators get named and unnamed.
       Otherwise there's no way to trace what's happening until
       maybe a regulator_get() fails ... MUCH later.
  * Ditto when they get enabled and disabled.
       Same reasons.
  * Make some message used dev_err() not printk(KERN_ERR ...)
       Bare printk isn't as informative.  (Also got rid of two
       copies of one message...)

There are still messaging issues that deserve fixing:  printks outside
the enable/disable paths should also use driver model calls; and more
KERN_ERR messages that should really be dev_dbg().

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Presumably needs to go over the previous enable/disable updates.

 drivers/Makefile         |    4 ++-
 drivers/regulator/core.c |   59 +++++++++++++++++++++++++++++----------------
 2 files changed, 42 insertions(+), 21 deletions(-)

--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -18,6 +18,9 @@ obj-$(CONFIG_ARM_AMBA)		+= amba/
 
 obj-$(CONFIG_XEN)		+= xen/
 
+# regulators early, since some subsystems rely on them to initialize
+obj-$(CONFIG_REGULATOR)		+= regulator/
+
 # char/ comes before serial/ etc so that the VT console is the boot-time
 # default.
 obj-y				+= char/
@@ -101,5 +104,4 @@ obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
 obj-$(CONFIG_VIRTIO)		+= virtio/
-obj-$(CONFIG_REGULATOR)		+= regulator/
 obj-$(CONFIG_STAGING)		+= staging/
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -775,6 +775,20 @@ static int set_consumer_device_supply(st
 	if (supply == NULL)
 		return -EINVAL;
 
+	list_for_each_entry(node, &regulator_map_list, list) {
+		if (consumer_dev != node->dev)
+			continue;
+		if (strcmp(node->supply, supply) != 0)
+			continue;
+
+		dev_dbg(consumer_dev, "%s/%s is '%s' supply; fail %s/%s\n",
+				dev_name(&node->regulator->dev),
+				node->regulator->desc->name,
+				supply,
+				dev_name(&rdev->dev), rdev->desc->name);
+		return -EBUSY;
+	}
+
 	node = kmalloc(sizeof(struct regulator_map), GFP_KERNEL);
 	if (node == NULL)
 		return -ENOMEM;
@@ -783,6 +797,10 @@ static int set_consumer_device_supply(st
 	node->dev = consumer_dev;
 	node->supply = supply;
 
+	dev_dbg(consumer_dev, "setting up %s/%s as '%s' supply\n",
+			dev_name(&rdev->dev),
+			rdev->desc->name, supply);
+
 	list_add(&node->list, &regulator_map_list);
 	return 0;
 }
@@ -793,8 +811,11 @@ static void unset_consumer_device_supply
 	struct regulator_map *node, *n;
 
 	list_for_each_entry_safe(node, n, &regulator_map_list, list) {
-		if (rdev == node->regulator &&
-			consumer_dev == node->dev) {
+		if (rdev == node->regulator && consumer_dev == node->dev) {
+			dev_dbg(consumer_dev,
+					"removing %s/%s as '%s' supply\n",
+					dev_name(&rdev->dev),
+					rdev->desc->name, node->supply);
 			list_del(&node->list);
 			kfree(node);
 			return;
@@ -894,7 +915,7 @@ struct regulator *regulator_get(struct d
 	struct regulator *regulator = ERR_PTR(-ENODEV);
 
 	if (id == NULL) {
-		printk(KERN_ERR "regulator: get() with no identifier\n");
+		dev_dbg(dev, "regulator_get with no identifier\n");
 		return regulator;
 	}
 
@@ -907,8 +928,7 @@ struct regulator *regulator_get(struct d
 			goto found;
 		}
 	}
-	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
-	       id);
+	dev_dbg(dev, "Unable to find regulator: %s\n", id);
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
 
@@ -971,19 +991,16 @@ static int _regulator_enable(struct regu
 	int ret = -EINVAL;
 
 	if (!rdev->constraints) {
-		printk(KERN_ERR "%s: %s has no constraints\n",
-		       __func__, rdev->desc->name);
+		dev_err(&rdev->dev, "%s has no constraints\n",
+		       rdev->desc->name);
 		return ret;
 	}
 
 	/* do we need to enable the supply regulator first */
 	if (rdev->supply) {
 		ret = _regulator_enable(rdev->supply);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev->desc->name, ret);
-			return ret;
-		}
+		if (ret < 0)
+			goto fail;
 	}
 
 	/* check voltage and requested load before enabling */
@@ -995,15 +1012,16 @@ static int _regulator_enable(struct regu
 			drms_uA_update(rdev);
 
 		ret = rdev->desc->ops->enable(rdev);
-		if (ret < 0) {
-			printk(KERN_ERR "%s: failed to enable %s: %d\n",
-			       __func__, rdev->desc->name, ret);
-			return ret;
+		if (ret >= 0) {
+			dev_dbg(&rdev->dev, "enabled %s\n", rdev->desc->name);
+			rdev->use_count++;
 		}
-		rdev->use_count++;
-		return ret;
 	}
 
+fail:
+	if (ret < 0)
+		dev_err(&rdev->dev, "can't enable %s: %d\n",
+		       rdev->desc->name, ret);
 	return ret;
 }
 
@@ -1046,10 +1064,11 @@ static int _regulator_disable(struct reg
 		if (rdev->desc->ops->disable) {
 			ret = rdev->desc->ops->disable(rdev);
 			if (ret < 0) {
-				printk(KERN_ERR "%s: failed to disable %s\n",
-				       __func__, rdev->desc->name);
+				dev_err(&rdev->dev, "failed disabling %s: %d\n",
+				       rdev->desc->name, ret);
 				return ret;
 			}
+			dev_dbg(&rdev->dev, "disabled %s\n", rdev->desc->name);
 		}
 
 		/* decrease our supplies ref count and disable if required */
