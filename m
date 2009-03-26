Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbZCZHwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbZCZHwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZCZHwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:52:15 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35510 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751291AbZCZHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:52:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=nbBKconXJYhE5gUzgvWf8OHwLQA/KB/gpaCjfEZ3Au48PYC9+hLvVt0S+FcaQmBGWYqDn8xhpqPszrGBun+Nx5Z4HXyPoLcK6Ku8+OwRl/oTR+GlY+DUWBTj5gkFSst8SgA876LR+OVzovQWJ7jv2aldLM7gqHAGybLWfHZjS08=  ;
X-YMail-OSG: iBVeXCEVM1mJ6xOVl7NZ00sBceWR9zAw.zUxjoWSjF7TOXpNpdiWsTRt6zeqsLmee0I1k0.w_ReRDWya5cQ.OxhJ8Lltn_8t.SJHY_1Qg8cpLZ_eFw.JiJMIEvgZlXrwdNTp7XP.bOzsUg0DOIcAKQSv12Ys_aUbiq_RCZN7N7RO0xN9N8tyusQCOjlLMd2N650yUBy8YBaKQAMLyS1SDFzapfwJCQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Linux MTD <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.29 1/2] MTD: driver model updates
Date: Thu, 26 Mar 2009 00:42:41 -0700
User-Agent: KMail/1.9.10
Cc: Kay Sievers <kay.sievers@vrfy.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903260042.42091.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Update driver model support in the MTD framework, so it fits
better into the current udev-based hotplug framework:

 - Each mtd_info now has a device node.  MTD drivers should set
   the dev.parent field to point to the physical device, before
   setting up partitions or otherwise declaring MTDs.

 - Those device nodes always map to /sys/class/mtdX device nodes,
   which no longer depend on MTD_CHARDEV.

 - Those mtdX sysfs nodes have a "starter set" of attributes;
   it's not yet sufficient to replace /proc/mtd.

 - Enabling MTD_CHARDEV provides /sys/class/mtdXro/ nodes and the
   /sys/class/mtd*/dev attributes (for udev, mdev, etc).

 - Include a MODULE_ALIAS_CHARDEV_MAJOR macro.  It'll work with
   udev creating the /dev/mtd* nodes, not just a static rootfs.

So the sysfs structure is pretty much what you'd expect, except
that readonly chardev nodes are a bit quirky.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Sanity tested with NOR (physmap, omap_nor, m25p80), DataFlash,
NAND (davinci, omap), OneNand (omap); with and without mtdblock.
With converted MTD drivers, /sys/devices/virtual/mtd/* are gone.
Didn't test modular configs.

 drivers/mtd/mtd_blkdevs.c |    1 
 drivers/mtd/mtdchar.c     |   47 ++---------------
 drivers/mtd/mtdcore.c     |  115 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/mtdpart.c     |    9 +++
 include/linux/mtd/mtd.h   |    7 ++
 5 files changed, 137 insertions(+), 42 deletions(-)

--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -286,6 +286,7 @@ int add_mtd_blktrans_dev(struct mtd_blkt
 	gd->private_data = new;
 	new->blkcore_priv = gd;
 	gd->queue = tr->blkcore_priv->rq;
+	gd->driverfs_dev = new->mtd->dev.parent;
 
 	if (new->readonly)
 		set_disk_ro(gd, 1);
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -19,33 +19,6 @@
 
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
@@ -793,34 +766,26 @@ static const struct file_operations mtd_
 
 static int __init init_mtdchar(void)
 {
-	if (register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops)) {
+	int status;
+
+	status = register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops);
+	if (status < 0) {
 		printk(KERN_NOTICE "Can't allocate major number %d for Memory Technology Devices.\n",
 		       MTD_CHAR_MAJOR);
-		return -EAGAIN;
 	}
 
-	mtd_class = class_create(THIS_MODULE, "mtd");
-
-	if (IS_ERR(mtd_class)) {
-		printk(KERN_ERR "Error creating mtd class.\n");
-		unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
-		return PTR_ERR(mtd_class);
-	}
-
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
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -22,6 +22,9 @@
 
 #include "mtdcore.h"
 
+
+static struct class *mtd_class;
+
 /* These are exported solely for the purpose of mtd_blkdevs.c. You
    should not use them for _anything_ else */
 DEFINE_MUTEX(mtd_table_mutex);
@@ -32,6 +35,82 @@ EXPORT_SYMBOL_GPL(mtd_table);
 
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
+static DEVICE_ATTR(mtd_type, S_IRUGO, mtd_type_show, NULL);
+
+static struct attribute *mtd_attrs[] = {
+	&dev_attr_mtd_type.attr,
+	/* FIXME provide a /proc/mtd superset */
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
@@ -40,6 +119,7 @@ static LIST_HEAD(mtd_notifiers);
  *	notify each currently active MTD 'user' of its arrival. Returns
  *	zero on success or 1 on failure, which currently will only happen
  *	if the number of present devices exceeds MAX_MTD_DEVICES (i.e. 16)
+ *	or there's a sysfs error.
  */
 
 int add_mtd_device(struct mtd_info *mtd)
@@ -80,6 +160,23 @@ int add_mtd_device(struct mtd_info *mtd)
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
@@ -343,6 +440,24 @@ EXPORT_SYMBOL_GPL(register_mtd_user);
 EXPORT_SYMBOL_GPL(unregister_mtd_user);
 EXPORT_SYMBOL_GPL(default_mtd_writev);
 
+static int __init mtd_setup(void)
+{
+	mtd_class = class_create(THIS_MODULE, "mtd");
+
+	if (IS_ERR(mtd_class)) {
+		pr_err("Error creating mtd class.\n");
+		return PTR_ERR(mtd_class);
+	}
+	return 0;
+}
+core_initcall(mtd_setup);
+
+static void __exit mtd_teardown(void)
+{
+	class_destroy(mtd_class);
+}
+__exitcall(mtd_teardown);
+
 #ifdef CONFIG_PROC_FS
 
 /*====================================================================*/
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -343,6 +343,11 @@ static struct mtd_part *add_one_partitio
 	slave->mtd.name = part->name;
 	slave->mtd.owner = master->owner;
 
+	/* NOTE:  we don't arrange MTDs as a tree; it'd be error-prone
+	 * to have the same data be in two different partitions.
+	 */
+	slave->mtd.dev.parent = master->dev.parent;
+
 	slave->mtd.read = part_read;
 	slave->mtd.write = part_write;
 
@@ -493,7 +498,9 @@ out_register:
  * This function, given a master MTD object and a partition table, creates
  * and registers slave MTD objects which are bound to the master according to
  * the partition definitions.
- * (Q: should we register the master MTD object as well?)
+ *
+ * We don't register the master, or expect the caller to have done so,
+ * for reasons of data integrity.
  */
 
 int add_mtd_partitions(struct mtd_info *master,
--- a/include/linux/mtd/mtd.h
+++ b/include/linux/mtd/mtd.h
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
+#include <linux/device.h>
 
 #include <linux/mtd/compatmac.h>
 #include <mtd/mtd-abi.h>
@@ -223,6 +224,7 @@ struct mtd_info {
 	void *priv;
 
 	struct module *owner;
+	struct device dev;
 	int usecount;
 
 	/* If the driver is something smart, like UBI, it may need to maintain
@@ -233,6 +235,11 @@ struct mtd_info {
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
