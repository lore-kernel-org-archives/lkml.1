Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbXHSIDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbXHSIDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 04:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbXHSIDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 04:03:13 -0400
Received: from ag-out-0708.google.com ([72.14.246.251]:19782 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbXHSIDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 04:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YXdpyyHizZjLdwksttDfs7YDokSqe1VAf+bjeQtM7QkJCgmrDERuLE216vW1z2cC6jBMtxC1IYZWc066JtS+5fJrpGPEco9yf2rMuuqknqpueOt1QG1ANak7+lsEc6YRNUihTAhuCW8+vVG+ar9Pi5wKGYwtXGjRNDP97gg1S20=
Date: Sun, 19 Aug 2007 16:51:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] sysdev: remove global sysdev drivers list
Message-ID: <20070819075114.GA4007@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	Cornelia Huck <cornelia.huck@de.ibm.com>,
	linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070812044407.GA4573@APFDCB5C> <20070813094331.4bc53e2e@gondolin.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813094331.4bc53e2e@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 09:43:31AM +0200, Cornelia Huck wrote:
> On Sun, 12 Aug 2007 13:44:07 +0900,
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
> > No one uses sysdev_drivers. Because no one calls sysdev_driver_register
> > with NULL class.
> > 
> > And it is difficult to imagine that someone want to implement a global
> > sysdev driver which is called with all sys_device on any kind of
> > sysdev_class.
> > 
> > So this patch removes global sysdev_drivers list.
> 
> This makes sense, I guess, especially since it simplyfies the code.
> 
> Some minor comments below.

Yes. All your comments are oviously correct.
Please check updated patch.

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] sysdev: remove global sysdev drivers list

No one uses sysdev_drivers. Because no one calls sysdev_driver_register
with NULL class.

And it is difficult to imagine that someone want to implement a global
sysdev driver which is called with all sys_device on any kind of
sysdev_class.

So this patch removes global sysdev_drivers list and update comments
for this change.

Cc: Tejun Heo <htejun@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/base/sys.c |   71 ++++++++++-------------------------------------------
 1 file changed, 14 insertions(+), 57 deletions(-)

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
@@ -182,10 +179,13 @@ int sysdev_driver_register(struct sysdev
 			list_for_each_entry(dev, &cls->kset.list, kobj.entry)
 				drv->add(dev);
 		}
-	} else
-		list_add_tail(&drv->entry, &sysdev_drivers);
+	} else {
+		err = -EINVAL;
+		printk(KERN_ERR "%s: invalid device class\n", __FUNCTION__);
+		WARN_ON(1);
+	}
 	mutex_unlock(&sysdev_drivers_lock);
-	return 0;
+	return err;
 }
 
 
@@ -251,12 +251,6 @@ int sysdev_register(struct sys_device * 
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
@@ -272,11 +266,6 @@ void sysdev_unregister(struct sys_device
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
@@ -293,7 +282,7 @@ void sysdev_unregister(struct sys_device
  *
  *	Loop over each class of system devices, and the devices in each
  *	of those classes. For each device, we call the shutdown method for
- *	each driver registered for the device - the globals, the auxillaries,
+ *	each driver registered for the device - the auxillaries,
  *	and the class driver.
  *
  *	Note: The list is iterated in reverse order, so that we shut down
@@ -320,13 +309,7 @@ void sysdev_shutdown(void)
 			struct sysdev_driver * drv;
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
-			/* Call global drivers first. */
-			list_for_each_entry(drv, &sysdev_drivers, entry) {
-				if (drv->shutdown)
-					drv->shutdown(sysdev);
-			}
-
-			/* Call auxillary drivers next. */
+			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->shutdown)
 					drv->shutdown(sysdev);
@@ -354,12 +337,6 @@ static void __sysdev_resume(struct sys_d
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
@@ -393,16 +370,7 @@ int sysdev_suspend(pm_message_t state)
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
-			/* Call auxillary drivers next. */
+			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
 					ret = drv->suspend(sysdev, state);
@@ -436,18 +404,7 @@ aux_driver:
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
