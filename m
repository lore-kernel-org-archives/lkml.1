Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXD0S62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXD0S62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbXD0S57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:59 -0400
Received: from mail.suse.de ([195.135.220.2]:50679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbXD0S5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@insightbb.com>, Dmitry Torokhov <dtor@mail.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/46] Input: serio - do not touch bus's rwsem
Date: Fri, 27 Apr 2007 11:53:38 -0700
Message-Id: <1177700125350-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001222882-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@insightbb.com>

The subsystem rwsem is not used by the driver core at all, so there is
no point in trying to access it.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/serio/serio.c |   41 +++++++++++++++--------------------------
 1 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index a15e531..5895202 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -115,18 +115,18 @@ static int serio_match_port(const struct serio_device_id *ids, struct serio *ser
  * Basic serio -> driver core mappings
  */
 
-static void serio_bind_driver(struct serio *serio, struct serio_driver *drv)
+static int serio_bind_driver(struct serio *serio, struct serio_driver *drv)
 {
 	int error;
 
-	down_write(&serio_bus.subsys.rwsem);
-
 	if (serio_match_port(drv->id_table, serio)) {
+
 		serio->dev.driver = &drv->driver;
 		if (serio_connect_driver(serio, drv)) {
 			serio->dev.driver = NULL;
-			goto out;
+			return -ENODEV;
 		}
+
 		error = device_bind_driver(&serio->dev);
 		if (error) {
 			printk(KERN_WARNING
@@ -136,31 +136,21 @@ static void serio_bind_driver(struct serio *serio, struct serio_driver *drv)
 				drv->description, error);
 			serio_disconnect_driver(serio);
 			serio->dev.driver = NULL;
-			goto out;
+			return error;
 		}
 	}
- out:
-	up_write(&serio_bus.subsys.rwsem);
-}
-
-static void serio_release_driver(struct serio *serio)
-{
-	down_write(&serio_bus.subsys.rwsem);
-	device_release_driver(&serio->dev);
-	up_write(&serio_bus.subsys.rwsem);
+	return 0;
 }
 
 static void serio_find_driver(struct serio *serio)
 {
 	int error;
 
-	down_write(&serio_bus.subsys.rwsem);
 	error = device_attach(&serio->dev);
 	if (error < 0)
 		printk(KERN_WARNING
 			"serio: device_attach() failed for %s (%s), error: %d\n",
 			serio->phys, serio->name, error);
-	up_write(&serio_bus.subsys.rwsem);
 }
 
 
@@ -470,13 +460,12 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
 {
 	struct serio *serio = to_serio_port(dev);
 	struct device_driver *drv;
-	int retval;
+	int error;
 
-	retval = mutex_lock_interruptible(&serio_mutex);
-	if (retval)
-		return retval;
+	error = mutex_lock_interruptible(&serio_mutex);
+	if (error)
+		return error;
 
-	retval = count;
 	if (!strncmp(buf, "none", count)) {
 		serio_disconnect_port(serio);
 	} else if (!strncmp(buf, "reconnect", count)) {
@@ -486,15 +475,15 @@ static ssize_t serio_rebind_driver(struct device *dev, struct device_attribute *
 		serio_find_driver(serio);
 	} else if ((drv = driver_find(buf, &serio_bus)) != NULL) {
 		serio_disconnect_port(serio);
-		serio_bind_driver(serio, to_serio_driver(drv));
+		error = serio_bind_driver(serio, to_serio_driver(drv));
 		put_driver(drv);
 	} else {
-		retval = -EINVAL;
+		error = -EINVAL;
 	}
 
 	mutex_unlock(&serio_mutex);
 
-	return retval;
+	return error ? error : count;
 }
 
 static ssize_t serio_show_bind_mode(struct device *dev, struct device_attribute *attr, char *buf)
@@ -665,7 +654,7 @@ static void serio_disconnect_port(struct serio *serio)
 		do {
 			parent = s->parent;
 
-			serio_release_driver(s);
+			device_release_driver(&s->dev);
 			serio_destroy_port(s);
 		} while ((s = parent) != serio);
 	}
@@ -673,7 +662,7 @@ static void serio_disconnect_port(struct serio *serio)
 	/*
 	 * Ok, no children left, now disconnect this port
 	 */
-	serio_release_driver(serio);
+	device_release_driver(&serio->dev);
 }
 
 void serio_rescan(struct serio *serio)
-- 
1.5.1.2

