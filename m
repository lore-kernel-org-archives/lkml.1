Return-Path: <linux-kernel-owner+w=401wt.eu-S936548AbZDCUA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936548AbZDCUA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbZDCUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:00:49 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:35725 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZDCUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:00:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E7r6KTHtk0xDo74MQX8izXUUTQXxtPapBtifFk5XWTuvX5LyBtAK0KvTmCgwIxTBV4
         qw4raSWSNab2WerLEpNZrCep2lqrtu9gS1/RQIYonyM3WWnd1/SFA91yAy4buACO24Ty
         F6IaFrlbGsq4stMz/EizaTnV9oZyclR4zJIkc=
MIME-Version: 1.0
In-Reply-To: <1238742215.20906.99.camel@localhost.localdomain>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
	 <1238742215.20906.99.camel@localhost.localdomain>
Date: Fri, 3 Apr 2009 13:00:45 -0700
Message-ID: <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
Subject: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: dedekind@infradead.org, David Brownell <david-b@pacbell.net>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       Linux MTD <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on: http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html

My only change from the previous posting
(http://lists.infradead.org/pipermail/linux-mtd/2009-April/025121.html)
was to remove the "mtd_" prefix on the device attributes.

David's 2/2 patch
(http://lists.infradead.org/pipermail/linux-mtd/2009-March/025011.html)
may still be used as-is.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |    1 +
 drivers/mtd/mtdchar.c     |   47 ++----------
 drivers/mtd/mtdcore.c     |  184 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/mtdpart.c     |    9 ++-
 include/linux/mtd/mtd.h   |    7 ++
 5 files changed, 206 insertions(+), 42 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 4109e0b..a49a9c8 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -286,6 +286,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	gd->private_data = new;
 	new->blkcore_priv = gd;
 	gd->queue = tr->blkcore_priv->rq;
+	gd->driverfs_dev = new->mtd->dev.parent;

 	if (new->readonly)
 		set_disk_ro(gd, 1);
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index f478f1f..763d3f0 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -20,33 +20,6 @@

 #include <asm/uaccess.h>

-static struct class *mtd_class;
-
-static void mtd_notify_add(struct mtd_info* mtd)
-{
-	if (!mtd)
-		return;
-
-	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
-		      NULL, "mtd%d", mtd->index);
-
-	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
-		      NULL, "mtd%dro", mtd->index);
-}
-
-static void mtd_notify_remove(struct mtd_info* mtd)
-{
-	if (!mtd)
-		return;
-
-	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2));
-	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1));
-}
-
-static struct mtd_notifier notifier = {
-	.add	= mtd_notify_add,
-	.remove	= mtd_notify_remove,
-};

 /*
  * Data structure to hold the pointer to the mtd device as well
@@ -854,34 +827,26 @@ static const struct file_operations mtd_fops = {

 static int __init init_mtdchar(void)
 {
-	if (register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops)) {
+	int status;
+
+	status = register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops);
+	if (status < 0) {
 		printk(KERN_NOTICE "Can't allocate major number %d for Memory
Technology Devices.\n",
 		       MTD_CHAR_MAJOR);
-		return -EAGAIN;
-	}
-
-	mtd_class = class_create(THIS_MODULE, "mtd");
-
-	if (IS_ERR(mtd_class)) {
-		printk(KERN_ERR "Error creating mtd class.\n");
-		unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
-		return PTR_ERR(mtd_class);
 	}

-	register_mtd_user(&notifier);
-	return 0;
+	return status;
 }

 static void __exit cleanup_mtdchar(void)
 {
-	unregister_mtd_user(&notifier);
-	class_destroy(mtd_class);
 	unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
 }

 module_init(init_mtdchar);
 module_exit(cleanup_mtdchar);

+MODULE_ALIAS_CHARDEV_MAJOR(MTD_CHAR_MAJOR);

 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 65a7f37..89c1e5d 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -23,6 +23,9 @@

 #include "mtdcore.h"

+
+static struct class *mtd_class;
+
 /* These are exported solely for the purpose of mtd_blkdevs.c. You
    should not use them for _anything_ else */
 DEFINE_MUTEX(mtd_table_mutex);
@@ -33,6 +36,160 @@ EXPORT_SYMBOL_GPL(mtd_table);

 static LIST_HEAD(mtd_notifiers);

+
+#if defined(CONFIG_MTD_CHAR) || defined(CONFIG_MTD_CHAR_MODULE)
+#define MTD_DEVT(index) MKDEV(MTD_CHAR_MAJOR, (index)*2)
+#else
+#define MTD_DEVT(index) 0
+#endif
+
+/* REVISIT once MTD uses the driver model better, whoever allocates
+ * the mtd_info will probably want to use the release() hook...
+ */
+static void mtd_release(struct device *dev)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	/* remove /dev/mtdXro node if needed */
+	if (MTD_DEVT(mtd->index))
+		device_destroy(mtd_class, MTD_DEVT(mtd->index) + 1);
+}
+
+static ssize_t mtd_type_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+	char *type;
+
+	switch (mtd->type) {
+	case MTD_ABSENT:
+		type = "absent";
+		break;
+	case MTD_RAM:
+		type = "ram";
+		break;
+	case MTD_ROM:
+		type = "rom";
+		break;
+	case MTD_NORFLASH:
+		type = "nor";
+		break;
+	case MTD_NANDFLASH:
+		type = "nand";
+		break;
+	case MTD_DATAFLASH:
+		type = "dataflash";
+		break;
+	case MTD_UBIVOLUME:
+		type = "ubi";
+		break;
+	default:
+		type = "unknown";
+	}
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", type);
+}
+static DEVICE_ATTR(type, S_IRUGO, mtd_type_show, NULL);
+
+static ssize_t mtd_flags_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "0x%lx\n", (unsigned long)mtd->flags);
+
+}
+static DEVICE_ATTR(flags, S_IRUGO, mtd_flags_show, NULL);
+
+static ssize_t mtd_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%llu\n",
+		(unsigned long long)mtd->size);
+
+}
+static DEVICE_ATTR(size, S_IRUGO, mtd_size_show, NULL);
+
+static ssize_t mtd_erasesize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->erasesize);
+
+}
+static DEVICE_ATTR(erasesize, S_IRUGO, mtd_erasesize_show, NULL);
+
+static ssize_t mtd_writesize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->writesize);
+
+}
+static DEVICE_ATTR(writesize, S_IRUGO, mtd_writesize_show, NULL);
+
+static ssize_t mtd_oobsize_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", (unsigned long)mtd->oobsize);
+
+}
+static DEVICE_ATTR(oobsize, S_IRUGO, mtd_oobsize_show, NULL);
+
+static ssize_t mtd_numeraseregions_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", mtd->numeraseregions);
+
+}
+static DEVICE_ATTR(numeraseregions, S_IRUGO, mtd_numeraseregions_show,
+	NULL);
+
+static ssize_t mtd_name_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct mtd_info *mtd = dev_to_mtd(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", mtd->name);
+
+}
+static DEVICE_ATTR(name, S_IRUGO, mtd_name_show, NULL);
+
+static struct attribute *mtd_attrs[] = {
+	&dev_attr_type.attr,
+	&dev_attr_flags.attr,
+	&dev_attr_size.attr,
+	&dev_attr_erasesize.attr,
+	&dev_attr_writesize.attr,
+	&dev_attr_oobsize.attr,
+	&dev_attr_numeraseregions.attr,
+	&dev_attr_name.attr,
+	NULL,
+};
+
+struct attribute_group mtd_group = {
+	.attrs		= mtd_attrs,
+};
+
+struct attribute_group *mtd_groups[] = {
+	&mtd_group,
+	NULL,
+};
+
+static struct device_type mtd_devtype = {
+	.name		= "mtd",
+	.groups		= mtd_groups,
+	.release	= mtd_release,
+};
+
 /**
  *	add_mtd_device - register an MTD device
  *	@mtd: pointer to new MTD device info structure
@@ -41,6 +198,7 @@ static LIST_HEAD(mtd_notifiers);
  *	notify each currently active MTD 'user' of its arrival. Returns
  *	zero on success or 1 on failure, which currently will only happen
  *	if the number of present devices exceeds MAX_MTD_DEVICES (i.e. 16)
+ *	or there's a sysfs error.
  */

 int add_mtd_device(struct mtd_info *mtd)
@@ -95,6 +253,23 @@ int add_mtd_device(struct mtd_info *mtd)
 					       mtd->name);
 			}

+			/* Caller should have set dev.parent to match the
+			 * physical device.
+			 */
+			mtd->dev.type = &mtd_devtype;
+			mtd->dev.class = mtd_class;
+			mtd->dev.devt = MTD_DEVT(i);
+			dev_set_name(&mtd->dev, "mtd%d", i);
+			if (device_register(&mtd->dev) != 0) {
+				mtd_table[i] = NULL;
+				break;
+			}
+
+			if (MTD_DEVT(i))
+				device_create(mtd_class, mtd->dev.parent,
+						MTD_DEVT(i) + 1,
+						NULL, "mtd%dro", i);
+
 			DEBUG(0, "mtd: Giving out device %d to %s\n",i, mtd->name);
 			/* No need to get a refcount on the module containing
 			   the notifier, since we hold the mtd_table_mutex */
@@ -139,6 +314,8 @@ int del_mtd_device (struct mtd_info *mtd)
 	} else {
 		struct mtd_notifier *not;

+		device_unregister(&mtd->dev);
+
 		/* No need to get a refcount on the module containing
 		   the notifier, since we hold the mtd_table_mutex */
 		list_for_each_entry(not, &mtd_notifiers, list)
@@ -413,6 +590,12 @@ done:

 static int __init init_mtd(void)
 {
+	mtd_class = class_create(THIS_MODULE, "mtd");
+
+	if (IS_ERR(mtd_class)) {
+		pr_err("Error creating mtd class.\n");
+		return PTR_ERR(mtd_class);
+	}
 	if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
 		proc_mtd->read_proc = mtd_read_proc;
 	return 0;
@@ -422,6 +605,7 @@ static void __exit cleanup_mtd(void)
 {
         if (proc_mtd)
 		remove_proc_entry( "mtd", NULL);
+	class_destroy(mtd_class);
 }

 module_init(init_mtd);
diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 06d5b9d..02ce38f 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -356,6 +356,11 @@ static struct mtd_part *add_one_partition(struct
mtd_info *master,
 	slave->mtd.owner = master->owner;
 	slave->mtd.backing_dev_info = master->backing_dev_info;

+	/* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone
+	 * to have the same data be in two different partitions.
+	 */
+	slave->mtd.dev.parent = master->dev.parent;
+
 	slave->mtd.read = part_read;
 	slave->mtd.write = part_write;

@@ -508,7 +513,9 @@ out_register:
  * This function, given a master MTD object and a partition table, creates
  * and registers slave MTD objects which are bound to the master according to
  * the partition definitions.
- * (Q: should we register the master MTD object as well?)
+ *
+ * We don't register the master, or expect the caller to have done so,
+ * for reasons of data integrity.
  */

 int add_mtd_partitions(struct mtd_info *master,
diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
index 0c079fd..5675b63 100644
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
+#include <linux/device.h>

 #include <linux/mtd/compatmac.h>
 #include <mtd/mtd-abi.h>
@@ -237,6 +238,7 @@ struct mtd_info {
 	void *priv;

 	struct module *owner;
+	struct device dev;
 	int usecount;

 	/* If the driver is something smart, like UBI, it may need to maintain
@@ -247,6 +249,11 @@ struct mtd_info {
 	void (*put_device) (struct mtd_info *mtd);
 };

+static inline struct mtd_info *dev_to_mtd(struct device *dev)
+{
+	return dev ? container_of(dev, struct mtd_info, dev) : NULL;
+}
+
 static inline uint32_t mtd_div_by_eb(uint64_t sz, struct mtd_info *mtd)
 {
 	if (mtd->erasesize_shift)
-- 
1.5.6.3
