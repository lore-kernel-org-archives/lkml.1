Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZHEGgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZHEGgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755644AbZHEGgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:36:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:32909 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634AbZHEGgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:36:14 -0400
Message-ID: <4A79283E.7030202@kernel.org>
Date: Wed, 05 Aug 2009 15:35:42 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: cguthrie@mandriva.org
Subject: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 06:35:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[un]register_chrdev() assume minor range 0-255.  This patch adds __
prefixed versions which take @minorbase and @count explicitly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
Hello,

These two patches make sound_core grabbing OSS device number optional.
If there's no objection, I think it would be easiest to push this
through Takashi's tree.

Thanks.

 fs/char_dev.c      |   63 +++++++++++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h |   11 ++++++---
 2 files changed, 60 insertions(+), 14 deletions(-)

Index: work/fs/char_dev.c
===================================================================
--- work.orig/fs/char_dev.c
+++ work/fs/char_dev.c
@@ -237,8 +237,10 @@ int alloc_chrdev_region(dev_t *dev, unsi
 }

 /**
- * register_chrdev() - Register a major number for character devices.
+ * __register_chrdev() - create and register a cdev occupying a range of minors
  * @major: major device number or 0 for dynamic allocation
+ * @baseminor: first of the requested range of minor numbers
+ * @count: the number of minor numbers required
  * @name: name of this range of devices
  * @fops: file operations associated with this devices
  *
@@ -254,19 +256,17 @@ int alloc_chrdev_region(dev_t *dev, unsi
  * /dev. It only helps to keep track of the different owners of devices. If
  * your module name has only one type of devices it's ok to use e.g. the name
  * of the module here.
- *
- * This function registers a range of 256 minor numbers. The first minor number
- * is 0.
  */
-int register_chrdev(unsigned int major, const char *name,
-		    const struct file_operations *fops)
+int __register_chrdev(unsigned int major, unsigned int baseminor,
+		      unsigned int count, const char *name,
+		      const struct file_operations *fops)
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
 	char *s;
 	int err = -ENOMEM;

-	cd = __register_chrdev_region(major, 0, 256, name);
+	cd = __register_chrdev_region(major, baseminor, count, name);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
 	
@@ -280,7 +280,7 @@ int register_chrdev(unsigned int major,
 	for (s = strchr(kobject_name(&cdev->kobj),'/'); s; s = strchr(s, '/'))
 		*s = '!';
 		
-	err = cdev_add(cdev, MKDEV(cd->major, 0), 256);
+	err = cdev_add(cdev, MKDEV(cd->major, baseminor), count);
 	if (err)
 		goto out;

@@ -290,11 +290,26 @@ int register_chrdev(unsigned int major,
 out:
 	kobject_put(&cdev->kobj);
 out2:
-	kfree(__unregister_chrdev_region(cd->major, 0, 256));
+	kfree(__unregister_chrdev_region(cd->major, baseminor, count));
 	return err;
 }

 /**
+ * register_chrdev() - create and register a cdev occupying a full major
+ * @major: major device number or 0 for dynamic allocation
+ * @name: name of this range of devices
+ * @fops: file operations associated with this devices
+ *
+ * Wrapper around __register_chrdev() which always allocates full
+ * minor range from 0 to 256.
+ */
+int register_chrdev(unsigned int major, const char *name,
+		    const struct file_operations *fops)
+{
+	return __register_chrdev(major, 0, 256, name, fops);
+}
+
+/**
  * unregister_chrdev_region() - return a range of device numbers
  * @from: the first in the range of numbers to unregister
  * @count: the number of device numbers to unregister
@@ -316,15 +331,41 @@ void unregister_chrdev_region(dev_t from
 	}
 }

-void unregister_chrdev(unsigned int major, const char *name)
+/**
+ * __unregister_chrdev - unregister and destroy a cdev
+ * @major: major device number
+ * @baseminor: first of the range of minor numbers
+ * @count: the number of minor numbers this cdev is occupying
+ * @name: name of this range of devices
+ *
+ * Unregister and destroy the cdev occupying the region described by
+ * @major, @baseminor and @count.  This function undoes what
+ * __register_chrdev() did.
+ */
+void __unregister_chrdev(unsigned int major, unsigned int baseminor,
+			 unsigned int count, const char *name)
 {
 	struct char_device_struct *cd;
-	cd = __unregister_chrdev_region(major, 0, 256);
+
+	cd = __unregister_chrdev_region(major, baseminor, count);
 	if (cd && cd->cdev)
 		cdev_del(cd->cdev);
 	kfree(cd);
 }

+/**
+ * unregister_chrdev - unregister and destroy a cdev
+ * @major: major device number
+ * @name: name of this range of devices
+ *
+ * Wrapper around __unregister_chrdev() which assumes full minor range
+ * from 0 to 256.
+ */
+void unregister_chrdev(unsigned int major, const char *name)
+{
+	__unregister_chrdev(major, 0, 256, name);
+}
+
 static DEFINE_SPINLOCK(cdev_lock);

 static struct kobject *cdev_get(struct cdev *p)
Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -1998,9 +1998,14 @@ extern void bd_release_from_disk(struct
 #define CHRDEV_MAJOR_HASH_SIZE	255
 extern int alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
 extern int register_chrdev_region(dev_t, unsigned, const char *);
-extern int register_chrdev(unsigned int, const char *,
-			   const struct file_operations *);
-extern void unregister_chrdev(unsigned int, const char *);
+extern int __register_chrdev(unsigned int major, unsigned int baseminor,
+			     unsigned int count, const char *name,
+			     const struct file_operations *fops);
+extern int register_chrdev(unsigned int major, const char *name,
+			   const struct file_operations *fops);
+extern void __unregister_chrdev(unsigned int major, unsigned int baseminor,
+				unsigned int count, const char *name);
+extern void unregister_chrdev(unsigned int major, const char *name);
 extern void unregister_chrdev_region(dev_t, unsigned);
 extern void chrdev_show(struct seq_file *,off_t);

