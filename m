Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbXLPQ3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbXLPQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:29:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762209AbXLPQ3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:29:02 -0500
Received: from lec.cs.unibo.it ([130.136.1.103]:33347 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754860AbXLPQ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:29:00 -0500
Date: Sun, 16 Dec 2007 17:28:59 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH] misc driver: eliminate 256 minor limit & deprecated call register_chrdev
Message-ID: <20071216162859.GA26191@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I already posted this patch on September 9th but nobody cared.

Is anybody interested in knowing that there is an old limit for
misc device minors to 256, that we are terminating the minor numbers,
and that there is a deprecated call in this code?

drivers/char/misc.c: the deprecated call is 
register_chrdev and it limits the number of minors to 256.

I propose this patch that eliminate both problems. With this patch 
misc allocates the entire major 10.

This patch was designed for a previous version of the kernel code
(2.6.22?), I have tested it today and applies to 2.6.24-rc5 with -12
lines offset.

	renzo

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>

--- a/drivers/char/misc.c	2007-08-05 16:56:59.000000000 +0200
+++ b/drivers/char/misc.c	2007-09-06 11:07:51.000000000 +0200
@@ -56,6 +56,8 @@
 static LIST_HEAD(misc_list);
 static DEFINE_MUTEX(misc_mtx);
 
+static struct cdev misc_cdev;
+
 /*
  * Assigned numbers, used for dynamic minors
  */
@@ -273,6 +275,31 @@
 EXPORT_SYMBOL(misc_register);
 EXPORT_SYMBOL(misc_deregister);
 
+static int misc_register_chrdev(void)
+{
+	dev_t from=MKDEV(MISC_MAJOR,0);
+	int rv;
+	int err = -ENOMEM;
+	char *s;
+
+	if ((rv=register_chrdev_region(from,MINORMASK,"misc")) != 0)
+		return rv;
+
+	cdev_init(&misc_cdev, &misc_fops);
+	misc_cdev.owner=misc_fops.owner;
+	kobject_set_name(&misc_cdev.kobj, "%s", "misc");
+	for (s = strchr(kobject_name(&misc_cdev.kobj),'/'); s; s = strchr(s, '/'))
+		    *s = '!';
+	err = cdev_add(&misc_cdev, from, MINORMASK);
+	if (err)
+		goto out;
+	return 0;
+out:
+	kobject_put(&misc_cdev.kobj);
+	unregister_chrdev_region(from,MINORMASK);
+  return err;
+}
+
 static int __init misc_init(void)
 {
 #ifdef CONFIG_PROC_FS
@@ -286,7 +313,7 @@
 	if (IS_ERR(misc_class))
 		return PTR_ERR(misc_class);
 
-	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops)) {
+	if (misc_register_chrdev()) {
 		printk("unable to get major %d for misc devices\n",
 		       MISC_MAJOR);
 		class_destroy(misc_class);
