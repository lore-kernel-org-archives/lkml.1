Return-Path: <linux-kernel-owner+w=401wt.eu-S1763850AbYAYH6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763850AbYAYH6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761605AbYAYHhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:37:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:55459 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759957AbYAYHhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:37:05 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [PATCH 107/196] UIO: fix kobject usage
Date: Thu, 24 Jan 2008 23:32:16 -0800
Message-Id: <1201246425-5058-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uio kobject code is "wierd".  This patch should hopefully fix it up
to be sane and not leak memory anymore.


Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c          |   91 +++++++++++++++++++++++---------------------
 include/linux/uio_driver.h |    6 ++-
 2 files changed, 52 insertions(+), 45 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 606aae7..acc387d 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -34,7 +34,7 @@ struct uio_device {
 	wait_queue_head_t	wait;
 	int			vma_count;
 	struct uio_info		*info;
-	struct kset 		map_attr_kset;
+	struct kobject		*map_dir;
 };
 
 static int uio_major;
@@ -51,47 +51,48 @@ static struct uio_class {
  * attributes
  */
 
-static struct attribute attr_addr = {
-	.name  = "addr",
-	.mode  = S_IRUGO,
+struct uio_map {
+	struct kobject kobj;
+	struct uio_mem *mem;
 };
+#define to_map(map) container_of(map, struct uio_map, kobj)
 
-static struct attribute attr_size = {
-	.name  = "size",
-	.mode  = S_IRUGO,
-};
 
-static struct attribute* map_attrs[] = {
-	&attr_addr, &attr_size, NULL
-};
-
-static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
+static ssize_t map_attr_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	struct uio_mem *mem = container_of(kobj, struct uio_mem, kobj);
+	struct uio_map *map = to_map(kobj);
+	struct uio_mem *mem = map->mem;
 
-	if (strncmp(attr->name,"addr",4) == 0)
+	if (strncmp(attr->attr.name, "addr", 4) == 0)
 		return sprintf(buf, "0x%lx\n", mem->addr);
 
-	if (strncmp(attr->name,"size",4) == 0)
+	if (strncmp(attr->attr.name, "size", 4) == 0)
 		return sprintf(buf, "0x%lx\n", mem->size);
 
 	return -ENODEV;
 }
 
-static void map_attr_release(struct kobject *kobj)
-{
-	/* TODO ??? */
-}
+static struct kobj_attribute attr_attribute =
+	__ATTR(addr, S_IRUGO, map_attr_show, NULL);
+static struct kobj_attribute size_attribute =
+	__ATTR(size, S_IRUGO, map_attr_show, NULL);
 
-static struct sysfs_ops map_attr_ops = {
-	.show  = map_attr_show,
+static struct attribute *attrs[] = {
+	&attr_attribute.attr,
+	&size_attribute.attr,
+	NULL,	/* need to NULL terminate the list of attributes */
 };
 
+static void map_release(struct kobject *kobj)
+{
+	struct uio_map *map = to_map(kobj);
+	kfree(map);
+}
+
 static struct kobj_type map_attr_type = {
-	.release	= map_attr_release,
-	.sysfs_ops	= &map_attr_ops,
-	.default_attrs	= map_attrs,
+	.release	= map_release,
+	.default_attrs	= attrs,
 };
 
 static ssize_t show_name(struct device *dev,
@@ -148,6 +149,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 	int mi;
 	int map_found = 0;
 	struct uio_mem *mem;
+	struct uio_map *map;
 
 	ret = sysfs_create_group(&idev->dev->kobj, &uio_attr_grp);
 	if (ret)
@@ -159,31 +161,34 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 			break;
 		if (!map_found) {
 			map_found = 1;
-			kobject_set_name(&idev->map_attr_kset.kobj,"maps");
-			idev->map_attr_kset.kobj.ktype = &map_attr_type;
-			idev->map_attr_kset.kobj.parent = &idev->dev->kobj;
-			ret = kset_register(&idev->map_attr_kset);
-			if (ret)
-				goto err_remove_group;
+			idev->map_dir = kobject_create_and_add("maps",
+							&idev->dev->kobj);
+			if (!idev->map_dir)
+				goto err;
 		}
-		kobject_init(&mem->kobj);
-		kobject_set_name(&mem->kobj,"map%d",mi);
-		mem->kobj.parent = &idev->map_attr_kset.kobj;
-		mem->kobj.kset = &idev->map_attr_kset;
-		ret = kobject_add(&mem->kobj);
+		map = kzalloc(sizeof(*map), GFP_KERNEL);
+		if (!map)
+			goto err;
+		kobject_init_ng(&map->kobj, &map_attr_type);
+		map->mem = mem;
+		mem->map = map;
+		ret = kobject_add_ng(&map->kobj, idev->map_dir, "map%d", mi);
+		if (ret)
+			goto err;
+		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
 		if (ret)
-			goto err_remove_maps;
+			goto err;
 	}
 
 	return 0;
 
-err_remove_maps:
+err:
 	for (mi--; mi>=0; mi--) {
 		mem = &idev->info->mem[mi];
-		kobject_unregister(&mem->kobj);
+		map = mem->map;
+		kobject_unregister(&map->kobj);
 	}
-	kset_unregister(&idev->map_attr_kset); /* Needed ? */
-err_remove_group:
+	kobject_unregister(idev->map_dir);
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 err_group:
 	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
@@ -198,9 +203,9 @@ static void uio_dev_del_attributes(struct uio_device *idev)
 		mem = &idev->info->mem[mi];
 		if (mem->size == 0)
 			break;
-		kobject_unregister(&mem->kobj);
+		kobject_unregister(&mem->map->kobj);
 	}
-	kset_unregister(&idev->map_attr_kset);
+	kobject_unregister(idev->map_dir);
 	sysfs_remove_group(&idev->dev->kobj, &uio_attr_grp);
 }
 
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 44c28e9..973386d 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -18,20 +18,22 @@
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 
+struct uio_map;
+
 /**
  * struct uio_mem - description of a UIO memory region
- * @kobj:		kobject for this mapping
  * @addr:		address of the device's memory
  * @size:		size of IO
  * @memtype:		type of memory addr points to
  * @internal_addr:	ioremap-ped version of addr, for driver internal use
+ * @map:		for use by the UIO core only.
  */
 struct uio_mem {
-	struct kobject		kobj;
 	unsigned long		addr;
 	unsigned long		size;
 	int			memtype;
 	void __iomem		*internal_addr;
+	struct uio_map		*map;
 };
 
 #define MAX_UIO_MAPS 	5
-- 
1.5.3.8

