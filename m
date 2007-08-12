Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXHLEzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXHLEzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 00:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXHLEzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 00:55:45 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:31841 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXHLEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 00:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=V+eMEJyWIrh51bb60HzmXJPRlbEJSKreapqlvH68J28+AnWLpRCjFUleEntiWVExH4+nOq4aAJk5EttI225rRBbKCa83BDjqSdFpCIY9K8eS7SJyUxJSbOEmXUpG1dSWvtbZBuFO7fEYSLYP9iR1U0XHIl38235zASEB3zD+pYw=
Date: Sun, 12 Aug 2007 13:44:07 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] sysdev: remove global sysdev drivers list
Message-ID: <20070812044407.GA4573@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	Cornelia Huck <cornelia.huck@de.ibm.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No one uses sysdev_drivers. Because no one calls sysdev_driver_register
with NULL class.

And it is difficult to imagine that someone want to implement a global
sysdev driver which is called with all sys_device on any kind of
sysdev_class.

So this patch removes global sysdev_drivers list.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/base/sys.c |   66 +++++++++--------------------------------------------
 1 file changed, 12 insertions(+), 54 deletions(-)

Index: 2.6-git/drivers/base/sys.c
===================================================================
--- 2.6-git.orig/drivers/base/sys.c
+++ 2.6-git/drivers/base/sys.c
@@ -153,25 +153,22 @@ void sysdev_class_unregister(struct sysd
 EXPORT_SYMBOL_GPL(sysdev_class_register);
 EXPORT_SYMBOL_GPL(sysdev_class_unregister);
 
-
-static LIST_HEAD(sysdev_drivers);
 static DEFINE_MUTEX(sysdev_drivers_lock);
 
 /**
  *	sysdev_driver_register - Register auxillary driver
- * 	@cls:	Device class driver belongs to.
+ *	@cls:	Device class driver belongs to.
  *	@drv:	Driver.
  *
- *	If @cls is valid, then @drv is inserted into @cls->drivers to be
+ *	@drv is inserted into @cls->drivers to be
  *	called on each operation on devices of that class. The refcount
  *	of @cls is incremented.
- *	Otherwise, @drv is inserted into sysdev_drivers, and called for
- *	each device.
  */
 
-int sysdev_driver_register(struct sysdev_class * cls,
-			   struct sysdev_driver * drv)
+int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 {
+	int err = 0;
+
 	mutex_lock(&sysdev_drivers_lock);
 	if (cls && kset_get(&cls->kset)) {
 		list_add_tail(&drv->entry, &cls->drivers);
@@ -182,10 +179,12 @@ int sysdev_driver_register(struct sysdev
 			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
 				drv->add(dev);
 		}
-	} else
-		list_add_tail(&drv->entry, &sysdev_drivers);
+	} else {
+		err = -EINVAL;
+		WARN_ON(1);
+	}
 	mutex_unlock(&sysdev_drivers_lock);
-	return 0;
+	return err;
 }
 
 
@@ -206,6 +205,8 @@ void sysdev_driver_unregister(struct sys
 				drv->remove(dev);
 		}
 		kset_put(&cls->kset);
+	} else {
+		WARN_ON(1);
 	}
 	mutex_unlock(&sysdev_drivers_lock);
 }
@@ -251,12 +252,6 @@ int sysdev_register(struct sys_device * 
 		 * code that should have called us.
 		 */
 
-		/* Notify global drivers */
-		list_for_each_entry(drv, &sysdev_drivers, entry) {
-			if (drv->add)
-				drv->add(sysdev);
-		}
-
 		/* Notify class auxillary drivers */
 		list_for_each_entry(drv, &cls->drivers, entry) {
 			if (drv->add)
@@ -272,11 +267,6 @@ void sysdev_unregister(struct sys_device
 	struct sysdev_driver * drv;
 
 	mutex_lock(&sysdev_drivers_lock);
-	list_for_each_entry(drv, &sysdev_drivers, entry) {
-		if (drv->remove)
-			drv->remove(sysdev);
-	}
-
 	list_for_each_entry(drv, &sysdev->cls->drivers, entry) {
 		if (drv->remove)
 			drv->remove(sysdev);
@@ -320,12 +310,6 @@ void sysdev_shutdown(void)
 			struct sysdev_driver * drv;
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
-			/* Call global drivers first. */
-			list_for_each_entry(drv, &sysdev_drivers, entry) {
-				if (drv->shutdown)
-					drv->shutdown(sysdev);
-			}
-
 			/* Call auxillary drivers next. */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->shutdown)
@@ -354,12 +338,6 @@ static void __sysdev_resume(struct sys_d
 		if (drv->resume)
 			drv->resume(dev);
 	}
-
-	/* Call global drivers. */
-	list_for_each_entry(drv, &sysdev_drivers, entry) {
-		if (drv->resume)
-			drv->resume(dev);
-	}
 }
 
 /**
@@ -393,15 +371,6 @@ int sysdev_suspend(pm_message_t state)
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
-			/* Call global drivers first. */
-			list_for_each_entry(drv, &sysdev_drivers, entry) {
-				if (drv->suspend) {
-					ret = drv->suspend(sysdev, state);
-					if (ret)
-						goto gbl_driver;
-				}
-			}
-
 			/* Call auxillary drivers next. */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
@@ -436,18 +405,7 @@ aux_driver:
 		if (err_drv->resume)
 			err_drv->resume(sysdev);
 	}
-	drv = NULL;
 
-gbl_driver:
-	if (drv)
-		printk(KERN_ERR "sysdev driver suspend failed for %s\n",
-				kobject_name(&sysdev->kobj));
-	list_for_each_entry(err_drv, &sysdev_drivers, entry) {
-		if (err_drv == drv)
-			break;
-		if (err_drv->resume)
-			err_drv->resume(sysdev);
-	}
 	/* resume other sysdevs in current class */
 	list_for_each_entry(err_dev, &cls->kset.list, kobj.entry) {
 		if (err_dev == sysdev)
