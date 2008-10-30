Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYJ3TMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYJ3TMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbYJ3TMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:12:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:53267 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbYJ3TMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:12:21 -0400
Subject: w1: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 20:12:22 +0100
Message-Id: <1225393942.21973.41.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: w1: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 3b615d4..acc7e3b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -197,7 +197,7 @@ struct device_driver w1_master_driver = {
 struct device w1_master_device = {
 	.parent = NULL,
 	.bus = &w1_bus_type,
-	.bus_id = "w1 bus master",
+	.init_name = "w1 bus master",
 	.driver = &w1_master_driver,
 	.release = &w1_master_release
 };
@@ -211,7 +211,7 @@ static struct device_driver w1_slave_driver = {
 struct device w1_slave_device = {
 	.parent = NULL,
 	.bus = &w1_bus_type,
-	.bus_id = "w1 bus slave",
+	.init_name = "w1 bus slave",
 	.driver = &w1_slave_driver,
 	.release = &w1_slave_release
 };
@@ -573,7 +573,7 @@ static int w1_uevent(struct device *dev, struct kobj_uevent_env *env)
 	}
 
 	dev_dbg(dev, "Hotplug event for %s %s, bus_id=%s.\n",
-			event_owner, name, dev->bus_id);
+			event_owner, name, dev_name(dev));
 
 	if (dev->driver != &w1_slave_driver || !sl)
 		return 0;
@@ -605,8 +605,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	sl->dev.bus = &w1_bus_type;
 	sl->dev.release = &w1_slave_release;
 
-	snprintf(&sl->dev.bus_id[0], sizeof(sl->dev.bus_id),
-		 "%02x-%012llx",
+	dev_set_name(&sl->dev, "%02x-%012llx",
 		 (unsigned int) sl->reg_num.family,
 		 (unsigned long long) sl->reg_num.id);
 	snprintf(&sl->name[0], sizeof(sl->name),
@@ -615,13 +614,13 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 		 (unsigned long long) sl->reg_num.id);
 
 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
-		&sl->dev.bus_id[0], sl);
+		dev_name(&sl->dev), sl);
 
 	err = device_register(&sl->dev);
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"Device registration [%s] failed. err=%d\n",
-			sl->dev.bus_id, err);
+			dev_name(&sl->dev), err);
 		return err;
 	}
 
@@ -630,7 +629,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
-			sl->dev.bus_id, err);
+			dev_name(&sl->dev), err);
 		goto out_unreg;
 	}
 
@@ -639,7 +638,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	if (err < 0) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
-			sl->dev.bus_id, err);
+			dev_name(&sl->dev), err);
 		goto out_rem1;
 	}
 
@@ -648,7 +647,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 	    ((err = sl->family->fops->add_slave(sl)) < 0)) {
 		dev_err(&sl->dev,
 			"sysfs file creation for [%s] failed. err=%d\n",
-			sl->dev.bus_id, err);
+			dev_name(&sl->dev), err);
 		goto out_rem2;
 	}
 
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index a3a5456..4a46ed5 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -75,8 +75,7 @@ static struct w1_master * w1_alloc_dev(u32 id, int slave_count, int slave_ttl,
 	mutex_init(&dev->mutex);
 
 	memcpy(&dev->dev, device, sizeof(struct device));
-	snprintf(dev->dev.bus_id, sizeof(dev->dev.bus_id),
-		  "w1_bus_master%u", dev->id);
+	dev_set_name(&dev->dev, "w1_bus_master%u", dev->id);
 	snprintf(dev->name, sizeof(dev->name), "w1_bus_master%u", dev->id);
 
 	dev->driver = driver;


