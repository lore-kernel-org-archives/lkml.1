Return-Path: <linux-kernel-owner+w=401wt.eu-S935807AbYBCAAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935807AbYBCAAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935195AbYBBX6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:58:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:37533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbYBBX6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:58:17 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/10] driver core: convert to use class_find_device api
Date: Sat,  2 Feb 2008 15:56:02 -0800
Message-Id: <1201996564-21951-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Convert to use class_find_device api in drivers/base/core.c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b172787..a0cfda5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1144,25 +1144,11 @@ error:
 }
 EXPORT_SYMBOL_GPL(device_create);
 
-/**
- * find_device - finds a device that was created with device_create()
- * @class: pointer to the struct class that this device was registered with
- * @devt: the dev_t of the device that was previously registered
- */
-static struct device *find_device(struct class *class, dev_t devt)
+static int __match_devt(struct device *dev, void *data)
 {
-	struct device *dev = NULL;
-	struct device *dev_tmp;
+	dev_t *devt = data;
 
-	down(&class->sem);
-	list_for_each_entry(dev_tmp, &class->devices, node) {
-		if (dev_tmp->devt == devt) {
-			dev = dev_tmp;
-			break;
-		}
-	}
-	up(&class->sem);
-	return dev;
+	return dev->devt == *devt;
 }
 
 /**
@@ -1177,9 +1163,11 @@ void device_destroy(struct class *class, dev_t devt)
 {
 	struct device *dev;
 
-	dev = find_device(class, devt);
-	if (dev)
+	dev = class_find_device(class, &devt, __match_devt);
+	if (dev) {
+		put_device(dev);
 		device_unregister(dev);
+	}
 }
 EXPORT_SYMBOL_GPL(device_destroy);
 
@@ -1203,9 +1191,11 @@ void destroy_suspended_device(struct class *class, dev_t devt)
 {
 	struct device *dev;
 
-	dev = find_device(class, devt);
-	if (dev)
+	dev = class_find_device(class, &devt, __match_devt);
+	if (dev) {
 		device_pm_schedule_removal(dev);
+		put_device(dev);
+	}
 }
 EXPORT_SYMBOL_GPL(destroy_suspended_device);
 #endif /* CONFIG_PM_SLEEP */
-- 
1.5.3.8

