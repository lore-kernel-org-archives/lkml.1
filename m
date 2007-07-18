Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXGRFyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXGRFyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 01:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXGRFxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 01:53:51 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38118 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXGRFxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 01:53:50 -0400
Date: Wed, 18 Jul 2007 01:53:48 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] drivers/base/core: improve device_add() error
	handling, fix bugs
Message-ID: <20070718055348.GA5734@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following change was checked into 'warnings' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

commit 5330916f5a11d8b7def46a6b3e14a831684032f5
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Jul 18 01:41:29 2007 -0400

    drivers/base/core: improve device_add() error handling, fix bugs
    
    * silence several warnings by handling sysfs_create_link() failure
    
    * re-order some operations in error handling, to precisely reverse
      the order of operations, i.e. unwind properly.
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/base/core.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

5330916f5a11d8b7def46a6b3e14a831684032f5
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 0455aa7..f26c005 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -698,16 +698,26 @@ int device_add(struct device *dev)
 	}
 
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
-				  "subsystem");
+		error = sysfs_create_link(&dev->kobj, &dev->class->subsys.kobj,
+					  "subsystem");
+		if (error)
+			goto ClassSubsysError;
+
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_create_link(&dev->class->subsys.kobj,
-					  &dev->kobj, dev->bus_id);
+		if (dev->kobj.parent != &dev->class->subsys.kobj) {
+			error = sysfs_create_link(&dev->class->subsys.kobj,
+						  &dev->kobj, dev->bus_id);
+			if (error)
+				goto ClassDevLinkError;
+		}
+
 		if (parent) {
-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
+			error = sysfs_create_link(&dev->kobj,&dev->parent->kobj,
+						  "device");
+			if (error)
+				goto ParentDevLinkError;
+
 #ifdef CONFIG_SYSFS_DEPRECATED
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
@@ -755,16 +765,7 @@ int device_add(struct device *dev)
 					     BUS_NOTIFY_DEL_DEVICE, dev);
 	device_remove_attrs(dev);
  AttrsError:
-	if (MAJOR(dev->devt))
-		device_remove_file(dev, &devt_attr);
-
 	if (dev->class) {
-		sysfs_remove_link(&dev->kobj, "subsystem");
-		/* If this is not a "fake" compatible device, remove the
-		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kobj)
-			sysfs_remove_link(&dev->class->subsys.kobj,
-					  dev->bus_id);
 		if (parent) {
 #ifdef CONFIG_SYSFS_DEPRECATED
 			char *class_name = make_class_name(dev->class->name,
@@ -776,7 +777,20 @@ int device_add(struct device *dev)
 #endif
 			sysfs_remove_link(&dev->kobj, "device");
 		}
+
+ ParentDevLinkError:
+		/* If this is not a "fake" compatible device, remove the
+		 * symlink from the class to the device. */
+		if (dev->kobj.parent != &dev->class->subsys.kobj)
+			sysfs_remove_link(&dev->class->subsys.kobj,
+					  dev->bus_id);
+
+ ClassDevLinkError:
+		sysfs_remove_link(&dev->kobj, "subsystem");
 	}
+ ClassSubsysError:
+	if (MAJOR(dev->devt))
+		device_remove_file(dev, &devt_attr);
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
  attrError:
