Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZCYAtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZCYAtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756981AbZCYAal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:30:41 -0400
Received: from kroah.org ([198.145.64.141]:54197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756883AbZCYAa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:30:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/61] Driver core: implement uevent suppress in kobject
Date: Tue, 24 Mar 2009 17:26:56 -0700
Message-Id: <1237940825-22904-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

This patch implements uevent suppress in kobject and removes it
from struct device, based on the following ideas:

1,Uevent sending should be one attribute of kobject, so suppressing it
in kobject layer is more natural than in device layer. By this way,
we can do it for other objects embedded with kobject.

2,It may save several bytes for each instance of struct device.(On my
omap3(32bit ARM) based box, can save 8bytes per device object)

This patch also introduces dev_set|get_uevent_suppress() helpers to
set and query uevent_suppress attribute in case to help kobject
as private part of struct device in future.

[This version is against the latest driver-core patch set of Greg,please
ignore the last version.]

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/dock.c           |    2 +-
 drivers/base/core.c           |    2 --
 drivers/base/firmware_class.c |    4 ++--
 drivers/i2c/i2c-core.c        |    2 +-
 drivers/s390/cio/chsc_sch.c   |    4 ++--
 drivers/s390/cio/css.c        |    4 ++--
 drivers/s390/cio/device.c     |    4 ++--
 fs/partitions/check.c         |   10 +++++-----
 include/linux/device.h        |   11 ++++++++++-
 include/linux/kobject.h       |    1 +
 lib/kobject_uevent.c          |    7 +++++++
 11 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 35094f2..7af7db1 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -977,7 +977,7 @@ static int dock_add(acpi_handle handle)
 		sizeof(struct dock_station *));
 
 	/* we want the dock device to send uevents */
-	dock_device->dev.uevent_suppress = 0;
+	dev_set_uevent_suppress(&dock_device->dev, 0);
 
 	if (is_dock(handle))
 		dock_station->flags |= DOCK_IS_DOCK;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a90f56f..95c67ff 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -136,8 +136,6 @@ static int dev_uevent_filter(struct kset *kset, struct kobject *kobj)
 
 	if (ktype == &device_ktype) {
 		struct device *dev = to_dev(kobj);
-		if (dev->uevent_suppress)
-			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 44699d9..d3a59c6 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -319,7 +319,7 @@ static int fw_register_device(struct device **dev_p, const char *fw_name,
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
-	f_dev->uevent_suppress = 1;
+	dev_set_uevent_suppress(f_dev, 1);
 	retval = device_register(f_dev);
 	if (retval) {
 		dev_err(device, "%s: device_register failed\n", __func__);
@@ -366,7 +366,7 @@ static int fw_setup_device(struct firmware *fw, struct device **dev_p,
 	}
 
 	if (uevent)
-		f_dev->uevent_suppress = 0;
+		dev_set_uevent_suppress(f_dev, 0);
 	*dev_p = f_dev;
 	goto out;
 
diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index e7d9848..fbb9030 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -841,7 +841,7 @@ int i2c_attach_client(struct i2c_client *client)
 
 	if (client->driver && !is_newstyle_driver(client->driver)) {
 		client->dev.release = i2c_client_release;
-		client->dev.uevent_suppress = 1;
+		dev_set_uevent_suppress(&client->dev, 1);
 	} else
 		client->dev.release = i2c_client_dev_release;
 
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 0a2f2ed..93eca17 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -84,8 +84,8 @@ static int chsc_subchannel_probe(struct subchannel *sch)
 		kfree(private);
 	} else {
 		sch->private = private;
-		if (sch->dev.uevent_suppress) {
-			sch->dev.uevent_suppress = 0;
+		if (dev_get_uevent_suppress(&sch->dev)) {
+			dev_set_uevent_suppress(&sch->dev, 0);
 			kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 		}
 	}
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 8019288..427d11d 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -272,7 +272,7 @@ static int css_register_subchannel(struct subchannel *sch)
 	 * the subchannel driver can decide itself when it wants to inform
 	 * userspace of its existence.
 	 */
-	sch->dev.uevent_suppress = 1;
+	dev_set_uevent_suppress(&sch->dev, 1);
 	css_update_ssd_info(sch);
 	/* make it known to the system */
 	ret = css_sch_device_register(sch);
@@ -287,7 +287,7 @@ static int css_register_subchannel(struct subchannel *sch)
 		 * a fitting driver module may be loaded based on the
 		 * modalias.
 		 */
-		sch->dev.uevent_suppress = 0;
+		dev_set_uevent_suppress(&sch->dev, 0);
 		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 	}
 	return ret;
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 23d5752..611d2e0 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -981,7 +981,7 @@ io_subchannel_register(struct work_struct *work)
 	 * Now we know this subchannel will stay, we can throw
 	 * our delayed uevent.
 	 */
-	sch->dev.uevent_suppress = 0;
+	dev_set_uevent_suppress(&sch->dev, 0);
 	kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 	/* make it known to the system */
 	ret = ccw_device_register(cdev);
@@ -1243,7 +1243,7 @@ static int io_subchannel_probe(struct subchannel *sch)
 		 * the ccw_device and exit. This happens for all early
 		 * devices, e.g. the console.
 		 */
-		sch->dev.uevent_suppress = 0;
+		dev_set_uevent_suppress(&sch->dev, 0);
 		kobject_uevent(&sch->dev.kobj, KOBJ_ADD);
 		cdev->dev.groups = ccwdev_attr_groups;
 		device_initialize(&cdev->dev);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d72024..38e337d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -400,7 +400,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
-	pdev->uevent_suppress = 1;
+	dev_set_uevent_suppress(pdev, 1);
 	err = device_add(pdev);
 	if (err)
 		goto out_put;
@@ -410,7 +410,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	if (!p->holder_dir)
 		goto out_del;
 
-	pdev->uevent_suppress = 0;
+	dev_set_uevent_suppress(pdev, 0);
 	if (flags & ADDPART_FLAG_WHOLEDISK) {
 		err = device_create_file(pdev, &dev_attr_whole_disk);
 		if (err)
@@ -422,7 +422,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
-	if (!ddev->uevent_suppress)
+	if (!dev_get_uevent_suppress(pdev))
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 
 	return p;
@@ -455,7 +455,7 @@ void register_disk(struct gendisk *disk)
 	dev_set_name(ddev, disk->disk_name);
 
 	/* delay uevents, until we scanned partition table */
-	ddev->uevent_suppress = 1;
+	dev_set_uevent_suppress(ddev, 1);
 
 	if (device_add(ddev))
 		return;
@@ -490,7 +490,7 @@ void register_disk(struct gendisk *disk)
 
 exit:
 	/* announce disk after possible partitions are created */
-	ddev->uevent_suppress = 0;
+	dev_set_uevent_suppress(ddev, 0);
 	kobject_uevent(&ddev->kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
diff --git a/include/linux/device.h b/include/linux/device.h
index 4bea53f..914c101 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -373,7 +373,6 @@ struct device {
 	struct device_private	*p;
 
 	struct kobject kobj;
-	unsigned		uevent_suppress:1;
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
 
@@ -465,6 +464,16 @@ static inline void dev_set_drvdata(struct device *dev, void *data)
 	dev->driver_data = data;
 }
 
+static inline unsigned int dev_get_uevent_suppress(const struct device *dev)
+{
+	return dev->kobj.uevent_suppress;
+}
+
+static inline void dev_set_uevent_suppress(struct device *dev, int val)
+{
+	dev->kobj.uevent_suppress = val;
+}
+
 static inline int device_is_registered(struct device *dev)
 {
 	return dev->kobj.state_in_sysfs;
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index c9c214d..58ae8e0 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -68,6 +68,7 @@ struct kobject {
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
 	unsigned int state_remove_uevent_sent:1;
+	unsigned int uevent_suppress:1;
 };
 
 extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 318328d..b2181cc 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -118,6 +118,13 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	kset = top_kobj->kset;
 	uevent_ops = kset->uevent_ops;
 
+	/* skip the event, if uevent_suppress is set*/
+	if (kobj->uevent_suppress) {
+		pr_debug("kobject: '%s' (%p): %s: uevent_suppress "
+				 "caused the event to drop!\n",
+				 kobject_name(kobj), kobj, __func__);
+		return 0;
+	}
 	/* skip the event, if the filter returns zero. */
 	if (uevent_ops && uevent_ops->filter)
 		if (!uevent_ops->filter(kset, kobj)) {
-- 
1.6.2

