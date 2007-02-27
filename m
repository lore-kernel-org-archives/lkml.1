Return-Path: <linux-kernel-owner+w=401wt.eu-S1751594AbXB0OFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbXB0OFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXB0OFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:05:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:26100 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbXB0OFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:05:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=chUikRVPmsAofarDjEpkxD5KU83Bj68tmzb2bD07qM56eev1T2WV6WHWlx7on5z7CtImLyffR/4F0U4g5FaNFqefXIzxr0H2wEfg8Z6ahmYkXYAkaBjh0hDrK/+t417IhJmkqos3ujdE1U2KvjhjrfwvUejDmNcgcQpf1OogK58=
Message-ID: <961aa3350702270604q53df742dvda40c47efdfd1044@mail.gmail.com>
Date: Tue, 27 Feb 2007 23:04:59 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Linux Kernel List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: [PATCH 3/3] driver core: check sysfs_create_link() errors
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills __must_check warnings for missing sysfs_create_link().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |   59 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 14 deletions(-)

Index: 2.6-mm/drivers/base/core.c
===================================================================
--- 2.6-mm.orig/drivers/base/core.c
+++ 2.6-mm/drivers/base/core.c
@@ -487,31 +487,61 @@ static int setup_parent(struct device *d
 	return 0;
 }

-static void device_add_links(struct device *dev, struct device *parent)
+static int device_add_links(struct device *dev, struct device *parent)
 {
+	int err;
+
 	if (dev->class) {
-		sysfs_create_link(&dev->kobj, &dev->class->subsys.kset.kobj,
-				  "subsystem");
+		err = sysfs_create_link(&dev->kobj,
+					&dev->class->subsys.kset.kobj,
+					"subsystem");
+		if (err)
+			return err;
+
 		/* If this is not a "fake" compatible device, then create the
 		 * symlink from the class to the device. */
-		if (dev->kobj.parent != &dev->class->subsys.kset.kobj)
-			sysfs_create_link(&dev->class->subsys.kset.kobj,
-					  &dev->kobj, dev->bus_id);
+		if (dev->kobj.parent != &dev->class->subsys.kset.kobj) {
+			err = sysfs_create_link(&dev->class->subsys.kset.kobj,
+						&dev->kobj, dev->bus_id);
+			if (err)
+				goto out1;
+		}
 #ifdef CONFIG_SYSFS_DEPRECATED
 		if (parent) {
 			char *class_name = NULL;

-			sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-							"device");
+			err = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+						"device");
+			if (err)
+				goto out2;
 			class_name = make_class_name(dev->class->name,
 							&dev->kobj);
-			if (class_name)
-				sysfs_create_link(&dev->parent->kobj,
-						  &dev->kobj, class_name);
+			if (class_name) {
+				err = sysfs_create_link(&dev->parent->kobj,
+							&dev->kobj, class_name);
+				if (err) {
+					kfree(class_name);
+					goto out3;
+				}
+
+			}
 			kfree(class_name);
 		}
 #endif
 	}
+
+	return 0;
+
+#ifdef CONFIG_SYSFS_DEPRECATED
+out3:
+	sysfs_remove_link(&dev->kobj, "device");
+out2:
+#endif
+	sysfs_remove_link(&dev->class->subsys.kset.kobj, dev->bus_id);
+out1:
+	sysfs_remove_link(&dev->kobj, "subsystem");
+
+	return err;
 }

 static void device_remove_links(struct device *dev, struct device *parent)
@@ -611,8 +641,9 @@ int device_add(struct device *dev)
 		dev->devt_attr = attr;
 	}

-	device_add_links(dev, parent);
-
+	error = device_add_links(dev, parent);
+	if (error)
+		goto LinksError;
 	if ((error = device_add_attrs(dev)))
 		goto AttrsError;
 	if ((error = device_add_groups(dev)))
@@ -652,7 +683,7 @@ int device_add(struct device *dev)
 	device_remove_attrs(dev);
  AttrsError:
 	device_remove_links(dev, parent);
-
+ LinksError:
 	if (dev->devt_attr) {
 		device_remove_file(dev, dev->devt_attr);
 		kfree(dev->devt_attr);
