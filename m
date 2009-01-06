Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZAFWWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZAFWWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbZAFWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:45 -0500
Received: from kroah.org ([198.145.64.141]:51242 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753612AbZAFWNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:43 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/60] w1: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue,  6 Jan 2009 14:11:44 -0800
Message-Id: <1231279939-32728-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/w1/w1.c     |   19 +++++++++----------
 drivers/w1/w1_int.c |    3 +--
 2 files changed, 10 insertions(+), 12 deletions(-)

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
-- 
1.6.0.4

