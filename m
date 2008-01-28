Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbYA1Iz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbYA1Iz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYA1IzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:55:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:47063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYA1IzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:55:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=xstWInpGaQxACU42+g8JHw6P0IN2DsiVZnIR/nmFnqp/YZH39yENLpUcHxFx5EJfpl96Lb9s8AoMcsaq3A647iQxMPX5La5KKgRNDKNjUjdmJgbqmT3LkTmmo6SZRDBu0vWOsKg0xHIHLFnJUeU3XBOMG5jeh5hWM+q0InEB0Zw=
Date: Mon, 28 Jan 2008 16:56:11 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] driver-core : convert to use class_find_device api
Message-ID: <20080128085611.GA27570@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use class_find_device api in drivers/base/core.c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/base/core.c |   32 +++++++++++---------------------
1 file changed, 11 insertions(+), 21 deletions(-)

diff -upr a/drivers/base/core.c b/drivers/base/core.c
--- a/drivers/base/core.c	2008-01-28 16:30:20.000000000 +0800
+++ b/drivers/base/core.c	2008-01-28 16:30:20.000000000 +0800
@@ -1136,25 +1136,11 @@ error:
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
@@ -1169,9 +1155,11 @@ void device_destroy(struct class *class,
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
 
@@ -1195,9 +1183,11 @@ void destroy_suspended_device(struct cla
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
