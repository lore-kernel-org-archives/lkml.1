Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbXGXM0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbXGXM0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbXGXM0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:26:39 -0400
Received: from seanodes.co.fr.clara.net ([212.43.220.11]:33252 "EHLO
	seanodes.co.fr.clara.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbXGXM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:26:38 -0400
X-Greylist: delayed 1629 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 08:26:37 EDT
Date: Tue, 24 Jul 2007 13:57:53 +0200
From: Alban Crequy <alban.crequy@seanodes.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] error management in add_disk()
Message-ID: <20070724135753.18fccf4f@alban>
Organization: Seanodes
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with the error management of add_disk() and del_gendisk().

add_disk() adds an entry in /sys/block/<name>. The filename in /sys/block is
not (struct gen_disk)->disk_name but more or less the first KOBJ_NAME_LEN
characters of (struct gen_disk)->disk_name.

#define KOBJ_NAME_LEN                   20

My problem occurs when we try to add 2 disks with different names, but when
the KOBJ_NAME_LEN first characters are the same.

It is not allowed to have several files in /sys/block/ with the same name. It
does not prevent the disk to work, but the creation of the file in /sys/block
will silently fail. See the call chain:

add_disk() -> register_disk() -> kobject_add(&disk->kobj)
del_gendisk() -> kobject_del(&disk->kobj)

add_disk() and register_disk() return void, so the caller cannot know that
there is a problem. kobject_add() returns an error but register_disk() ignores
the error.

The disk driver is unaware of the failure of disk_add(), and may call
del_gendisk(). It deletes an object in /sys/block/ that was not added (bug!).
The disk driver cannot check that, so the reference counter of /sys/block is
decremented on kobject_del().

If the user run add_disk() and del_gendisk() a lot of times with different
names having the same 20-characters beginning, the reference counter of the
/sys/block directory will reach 0 (and it will be freed) although it still
contains files.

The attached test module triggers the problem. You can try something like:
for i in $(seq 1 100) ; do insmod ./adddiskbug.ko ; rmmod adddiskbug ; done

The attached patch fixes the problem by changing the prototype of add_disk() and
register_disk() to return errors.


Index: linux-2.6.23-rc1/block/genhd.c
===================================================================
--- linux-2.6.23-rc1.orig/block/genhd.c	2007-07-23 14:52:11.000000000 +0200
+++ linux-2.6.23-rc1/block/genhd.c	2007-07-23 18:08:58.000000000 +0200
@@ -175,13 +175,22 @@
  * This function registers the partitioning information in @disk
  * with the kernel.
  */
-void add_disk(struct gendisk *disk)
+int add_disk(struct gendisk *disk)
 {
+	int ret;
+
 	disk->flags |= GENHD_FL_UP;
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
 			    disk->minors, NULL, exact_match, exact_lock, disk);
-	register_disk(disk);
+	ret = register_disk(disk);
+	if (ret) {
+		blk_unregister_region(MKDEV(disk->major, disk->first_minor),
+				      disk->minors);
+		return ret;
+	}
 	blk_register_queue(disk);
+
+	return 0;
 }
 
 EXPORT_SYMBOL(add_disk);
Index: linux-2.6.23-rc1/include/linux/genhd.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/genhd.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/genhd.h	2007-07-23 15:12:53.000000000 +0200
@@ -235,7 +235,7 @@
 
 /* drivers/block/genhd.c */
 extern int get_blkdev_list(char *, int);
-extern void add_disk(struct gendisk *disk);
+extern int add_disk(struct gendisk *disk);
 extern void del_gendisk(struct gendisk *gp);
 extern void unlink_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *part);
Index: linux-2.6.23-rc1/fs/partitions/check.c
===================================================================
--- linux-2.6.23-rc1.orig/fs/partitions/check.c	2007-07-23 14:52:13.000000000 +0200
+++ linux-2.6.23-rc1/fs/partitions/check.c	2007-07-23 15:53:04.000000000 +0200
@@ -469,7 +469,7 @@
 }
 
 /* Not exported, helper to add_disk(). */
-void register_disk(struct gendisk *disk)
+int register_disk(struct gendisk *disk)
 {
 	struct block_device *bdev;
 	char *s;
@@ -483,11 +483,11 @@
 	if (s)
 		*s = '!';
 	if ((err = kobject_add(&disk->kobj)))
-		return;
+		return -EEXIST;
 	err = disk_sysfs_symlinks(disk);
 	if (err) {
 		kobject_del(&disk->kobj);
-		return;
+		return -EEXIST;
 	}
  	disk_sysfs_add_subdirs(disk);
 
@@ -523,6 +523,8 @@
 			continue;
 		kobject_uevent(&p->kobj, KOBJ_ADD);
 	}
+
+	return 0;
 }
 
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
Index: linux-2.6.23-rc1/include/linux/blkdev.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/blkdev.h	2007-07-23 14:52:14.000000000 +0200
+++ linux-2.6.23-rc1/include/linux/blkdev.h	2007-07-23 15:58:47.000000000 +0200
@@ -643,7 +643,7 @@
 
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
-extern void register_disk(struct gendisk *dev);
+extern int register_disk(struct gendisk *dev);
 extern void generic_make_request(struct bio *bio);
 extern void blk_put_request(struct request *);
 extern void __blk_put_request(request_queue_t *, struct request *);



My test module:


----->8---------->8---------->8-----
#include <linux/module.h>
#include <linux/kernel.h>

#include <linux/blkdev.h>
#include <linux/genhd.h>
#include <linux/fs.h>
#include <linux/init.h>


#define DRIVER_NAME "adddiskbug"

int adddiskbug_init(void);
void adddiskbug_exit(void);


struct block_device_operations adddiskbug_fops = {
  .owner   = THIS_MODULE,
  .open    = NULL,
  .release = NULL,
  .ioctl   = NULL,
};


int major_number;
struct gendisk *gd[256];

void
print_refcount(struct gendisk *_gd, const char *str)
{
  struct kobject *obj;

  printk("%s\n", str);
  printk("name=%s: count=%d\n",
         _gd->disk_name,
         atomic_read(& _gd->kobj.kref.refcount));

  for (obj = & _gd->kobj ; obj ; obj = obj->parent)
  {
    printk("  obj %p '%s': %p '%s' count=%d\n",
           obj, obj->name, obj->k_name, obj->k_name?obj->k_name:"",
           atomic_read(& obj->kref.refcount));
  }
}

int new_disk(const char *name, int minor)
{
  int ret = 0;

  if (strlen(name) >= 32)
  {
    printk("ERROR: Name '%s' too long\n", name);
    return -EINVAL;
  }

  gd[minor] = alloc_disk(1);
  if (!gd[minor])
    return -ENOMEM;

  print_refcount(gd[0], "After alloc_disk:\n");

  gd[minor]->major = major_number;
  gd[minor]->first_minor = minor;
  gd[minor]->fops = &adddiskbug_fops;
  strlcpy(gd[minor]->disk_name, name, sizeof(gd[minor]->disk_name));

  set_capacity(gd[minor], (sector_t) 8192); /* 4MB */

  gd[minor]->queue = blk_alloc_queue(GFP_KERNEL);
  if (! gd[minor]->queue)
  {
    put_disk(gd[minor]);
    return -ENOMEM;
  }

#ifndef KERNEL_WITH_MY_PATCH
  add_disk(gd[minor]);
#else
  ret = add_disk(gd[minor]);
  if (ret)
  {
    blk_cleanup_queue(gd[minor]->queue);
    put_disk(gd[minor]);
    return ret;
  }
#endif

  return ret;
}

void delete_disk(int minor)
{
  struct gendisk *_gd = gd[minor];
  blk_cleanup_queue(_gd->queue);
  del_gendisk(_gd);
  put_disk(_gd);
}


int
adddiskbug_init(void)
{
  int ret;

  printk(" ==== init ===== \n");

  major_number = register_blkdev(0, DRIVER_NAME);
  if (major_number < 0)
    return -EINVAL;

  ret = new_disk("my_bogus_driver_number_1", 0);
  if (ret < 0)
  {
    unregister_blkdev(major_number, DRIVER_NAME);
    return -EINVAL;
  }
  print_refcount(gd[0], "after new_disk 0");

  ret = new_disk("my_bogus_driver_number_2", 1);
  if (ret < 0)
  {
    delete_disk(0);
    unregister_blkdev(major_number, DRIVER_NAME);
    return -EINVAL;
  }
  print_refcount(gd[0], "after new_disk 1");


  return 0;
}

void
adddiskbug_exit(void)
{
  print_refcount(gd[0], "before delete_disk 0");
  delete_disk(1);

  print_refcount(gd[0], "before delete_disk 1");
  delete_disk(0);

  unregister_blkdev(major_number, DRIVER_NAME);
}


module_init(adddiskbug_init);
module_exit(adddiskbug_exit);


----->8---------->8---------->8-----

