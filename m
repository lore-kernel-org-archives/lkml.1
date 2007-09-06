Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbXIFKNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbXIFKNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbXIFKNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:13:39 -0400
Received: from lec.cs.unibo.it ([130.136.1.103]:53222 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXIFKNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:13:39 -0400
Date: Thu, 6 Sep 2007 11:38:44 +0200
To: linux-kernel@vger.kernel.org
Cc: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
Subject: [PATCH] drivers/char/misc.c: deprecated call register_chrdev, and 256 minor limit eliminated
Message-ID: <20070906093844.GC8222@cs.unibo.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5QAgd0e35j3NYeGe"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Dear Kernel Developers,

I have seen that drivers/char/misc.c already used the deprecated 
register_chrdev call and this limited the number of minors to 256.

I recetly asked for a misc minor number attribution for View-OS/kmview
and Torben Mathiasen told me about this issue.

I propose this patch that eliminate both problems. With this patch 
misc allocates the entire major 10 and avoids the deprecated call.

These are just my 2 (euro) cents, I hope it can be useful.

	renzo
-- 
============================================================================
Renzo Davoli				| Dept. of Computer Science
(NIC rd235, HAM IZ4DJE)                 | University of Bologna	
Tel. +39 051 2094501			| Mura Anteo Zamboni, 7
Fax. +39 051 2094510			| I-40127 Bologna  ITALY
Key fingerprint = A019 17E2 5562 06F6 77BB  2E93 1A01 F646 30EA B487
============================================================================

--5QAgd0e35j3NYeGe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="drivers_char_misc.patch"

--- drivers/char/misc.orig.c	2007-08-05 16:56:59.000000000 +0200
+++ drivers/char/misc.c	2007-09-06 11:07:51.000000000 +0200
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

--5QAgd0e35j3NYeGe--
