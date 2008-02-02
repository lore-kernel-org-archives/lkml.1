Return-Path: <linux-kernel-owner+w=401wt.eu-S935905AbYBCABv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935905AbYBCABv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766010AbYBBX6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:58:30 -0500
Received: from ns2.suse.de ([195.135.220.15]:40287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198AbYBBX63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:58:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] Driver core: Remove unneeded get_{device,driver}() calls.
Date: Sat,  2 Feb 2008 15:56:04 -0800
Message-Id: <1201996564-21951-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Driver core: Remove unneeded get_{device,driver}() calls.

Code trying to add/remove attributes must hold a reference to
the device resp. driver anyway, so let's remove those reference
count games.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c   |    8 ++------
 drivers/base/driver.c |    9 +++------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a0cfda5..9c0070b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -423,10 +423,8 @@ struct kset *devices_kset;
 int device_create_file(struct device *dev, struct device_attribute *attr)
 {
 	int error = 0;
-	if (get_device(dev)) {
+	if (dev)
 		error = sysfs_create_file(&dev->kobj, &attr->attr);
-		put_device(dev);
-	}
 	return error;
 }
 
@@ -437,10 +435,8 @@ int device_create_file(struct device *dev, struct device_attribute *attr)
  */
 void device_remove_file(struct device *dev, struct device_attribute *attr)
 {
-	if (get_device(dev)) {
+	if (dev)
 		sysfs_remove_file(&dev->kobj, &attr->attr);
-		put_device(dev);
-	}
 }
 
 /**
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index a35f041..ba75184 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -97,10 +97,9 @@ int driver_create_file(struct device_driver *drv,
 		       struct driver_attribute *attr)
 {
 	int error;
-	if (get_driver(drv)) {
+	if (drv)
 		error = sysfs_create_file(&drv->p->kobj, &attr->attr);
-		put_driver(drv);
-	} else
+	else
 		error = -EINVAL;
 	return error;
 }
@@ -114,10 +113,8 @@ EXPORT_SYMBOL_GPL(driver_create_file);
 void driver_remove_file(struct device_driver *drv,
 			struct driver_attribute *attr)
 {
-	if (get_driver(drv)) {
+	if (drv)
 		sysfs_remove_file(&drv->p->kobj, &attr->attr);
-		put_driver(drv);
-	}
 }
 EXPORT_SYMBOL_GPL(driver_remove_file);
 
-- 
1.5.3.8

