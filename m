Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbYGKN41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbYGKN41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYGKNsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:21 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34977 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759399AbYGKNry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:54 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 15/30] W1: w1_int.c use first available master number
Date: Fri, 11 Jul 2008 17:51:30 +0400
Message-Id: <12157843062359-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Follow the example of other devices (like the joystick device).  Pick
the first available id for each detected device.  Currently for USB
devices, suspending and resuming would cause the number to increment.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/w1_int.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 3fd6e66..a3a5456 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -29,7 +29,6 @@
 #include "w1_netlink.h"
 #include "w1_int.h"
 
-static u32 w1_ids = 1;
 static int w1_search_count = -1; /* Default is continual scan */
 module_param_named(search_count, w1_search_count, int, 0);
 
@@ -102,9 +101,10 @@ static void w1_free_dev(struct w1_master *dev)
 
 int w1_add_master_device(struct w1_bus_master *master)
 {
-	struct w1_master *dev;
+	struct w1_master *dev, *entry;
 	int retval = 0;
 	struct w1_netlink_msg msg;
+	int id, found;
 
         /* validate minimum functionality */
         if (!(master->touch_bit && master->reset_bus) &&
@@ -126,13 +126,33 @@ int w1_add_master_device(struct w1_bus_master *master)
 		master->set_pullup = NULL;
 	}
 
-	dev = w1_alloc_dev(w1_ids++, w1_max_slave_count, w1_max_slave_ttl, &w1_master_driver, &w1_master_device);
-	if (!dev)
+	/* Lock until the device is added (or not) to w1_masters. */
+	mutex_lock(&w1_mlock);
+	/* Search for the first available id (starting at 1). */
+	id = 0;
+	do {
+		++id;
+		found = 0;
+		list_for_each_entry(entry, &w1_masters, w1_master_entry) {
+			if (entry->id == id) {
+				found = 1;
+				break;
+			}
+		}
+	} while (found);
+
+	dev = w1_alloc_dev(id, w1_max_slave_count, w1_max_slave_ttl,
+		&w1_master_driver, &w1_master_device);
+	if (!dev) {
+		mutex_unlock(&w1_mlock);
 		return -ENOMEM;
+	}
 
 	retval =  w1_create_master_attributes(dev);
-	if (retval)
+	if (retval) {
+		mutex_unlock(&w1_mlock);
 		goto err_out_free_dev;
+	}
 
 	memcpy(dev->bus_master, master, sizeof(struct w1_bus_master));
 
@@ -144,10 +164,10 @@ int w1_add_master_device(struct w1_bus_master *master)
 		dev_err(&dev->dev,
 			 "Failed to create new kernel thread. err=%d\n",
 			 retval);
+		mutex_unlock(&w1_mlock);
 		goto err_out_rm_attr;
 	}
 
-	mutex_lock(&w1_mlock);
 	list_add(&dev->w1_master_entry, &w1_masters);
 	mutex_unlock(&w1_mlock);
 
-- 
1.4.4.4

