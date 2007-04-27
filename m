Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbXD0S7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbXD0S7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbXD0S6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:58:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:50691 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbXD0S5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:49 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@insightbb.com>, Dmitry Torokhov <dtor@mail.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/46] Input: gameport - do not touch bus's rwsem
Date: Fri, 27 Apr 2007 11:53:39 -0700
Message-Id: <11777001301175-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1177700125350-git-send-email-gregkh@suse.de>
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
 <1177700125350-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@insightbb.com>

The subsystem rwsem is not used by the driver core at all, so there is
no point in trying to access it.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/input/gameport/gameport.c |   39 ++++++++++++------------------------
 1 files changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index a00fe47..bd686a2 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -190,16 +190,14 @@ static void gameport_run_poll_handler(unsigned long d)
  * Basic gameport -> driver core mappings
  */
 
-static void gameport_bind_driver(struct gameport *gameport, struct gameport_driver *drv)
+static int gameport_bind_driver(struct gameport *gameport, struct gameport_driver *drv)
 {
 	int error;
 
-	down_write(&gameport_bus.subsys.rwsem);
-
 	gameport->dev.driver = &drv->driver;
 	if (drv->connect(gameport, drv)) {
 		gameport->dev.driver = NULL;
-		goto out;
+		return -ENODEV;
 	}
 
 	error = device_bind_driver(&gameport->dev);
@@ -211,31 +209,21 @@ static void gameport_bind_driver(struct gameport *gameport, struct gameport_driv
 			drv->description, error);
 		drv->disconnect(gameport);
 		gameport->dev.driver = NULL;
-		goto out;
+		return error;
 	}
 
- out:
-	up_write(&gameport_bus.subsys.rwsem);
-}
-
-static void gameport_release_driver(struct gameport *gameport)
-{
-	down_write(&gameport_bus.subsys.rwsem);
-	device_release_driver(&gameport->dev);
-	up_write(&gameport_bus.subsys.rwsem);
+	return 0;
 }
 
 static void gameport_find_driver(struct gameport *gameport)
 {
 	int error;
 
-	down_write(&gameport_bus.subsys.rwsem);
 	error = device_attach(&gameport->dev);
 	if (error < 0)
 		printk(KERN_WARNING
 			"gameport: device_attach() failed for %s (%s), error: %d\n",
 			gameport->phys, gameport->name, error);
-	up_write(&gameport_bus.subsys.rwsem);
 }
 
 
@@ -483,13 +471,12 @@ static ssize_t gameport_rebind_driver(struct device *dev, struct device_attribut
 {
 	struct gameport *gameport = to_gameport_port(dev);
 	struct device_driver *drv;
-	int retval;
+	int error;
 
-	retval = mutex_lock_interruptible(&gameport_mutex);
-	if (retval)
-		return retval;
+	error = mutex_lock_interruptible(&gameport_mutex);
+	if (error)
+		return error;
 
-	retval = count;
 	if (!strncmp(buf, "none", count)) {
 		gameport_disconnect_port(gameport);
 	} else if (!strncmp(buf, "reconnect", count)) {
@@ -499,15 +486,15 @@ static ssize_t gameport_rebind_driver(struct device *dev, struct device_attribut
 		gameport_find_driver(gameport);
 	} else if ((drv = driver_find(buf, &gameport_bus)) != NULL) {
 		gameport_disconnect_port(gameport);
-		gameport_bind_driver(gameport, to_gameport_driver(drv));
+		error = gameport_bind_driver(gameport, to_gameport_driver(drv));
 		put_driver(drv);
 	} else {
-		retval = -EINVAL;
+		error = -EINVAL;
 	}
 
 	mutex_unlock(&gameport_mutex);
 
-	return retval;
+	return error ? error : count;
 }
 
 static struct device_attribute gameport_device_attrs[] = {
@@ -655,7 +642,7 @@ static void gameport_disconnect_port(struct gameport *gameport)
 		do {
 			parent = s->parent;
 
-			gameport_release_driver(s);
+			device_release_driver(&s->dev);
 			gameport_destroy_port(s);
 		} while ((s = parent) != gameport);
 	}
@@ -663,7 +650,7 @@ static void gameport_disconnect_port(struct gameport *gameport)
 	/*
 	 * Ok, no children left, now disconnect this port
 	 */
-	gameport_release_driver(gameport);
+	device_release_driver(&gameport->dev);
 }
 
 void gameport_rescan(struct gameport *gameport)
-- 
1.5.1.2

