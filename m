Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYAZAQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYAZAQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbYAZAP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:15:27 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:18152 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbYAZAPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:15:24 -0500
X-Greylist: delayed 3114 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 19:15:24 EST
Date: Sat, 26 Jan 2008 00:23:18 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Alexander van Heukelum <heukelum@fastmail.fm>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 158/196] Driver core: convert block from raw kobjects
Message-ID: <20080125232317.GA7131@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Sat, 26 Jan 2008 00:23:20 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.56; VDF: 7.0.2.50; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build with CONFIG_BLOCK off.

Building git-2d94dfc with CONFIG_BLOCK turned off gives me:

drivers/base/core.c: In function 'device_add_class_symlinks':
drivers/base/core.c:704: error: 'part_type' undeclared (first use in this function)
drivers/base/core.c:704: error: (Each undeclared identifier is reported only once
drivers/base/core.c:704: error: for each function it appears in.)
drivers/base/core.c: In function 'device_remove_class_symlinks':
drivers/base/core.c:743: error: 'part_type' undeclared (first use in this function)

git-blame points to Kay Sievers.

The problem is obvious. I think te solution is too ;).

Tested with a silly configuration that contains just enough wits to boot
and get to the prompt of klibc-dash on the built-in initramfs using:
   qemu -m 8 -cpu pentium -serial stdio -cdrom arch/x86/boot/image.iso

Compile-tested i386-defconfig.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

Oh, and the compile-problem still exists in git-99f1c97. The git-tree is
changing faster than I can test the patch and write an e-mail :-/.

diff --git a/drivers/base/core.c b/drivers/base/core.c
index edf3bbe..3751843 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -75,6 +75,15 @@ static ssize_t dev_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+static int dev_needs_link(struct device *dev)
+{
+#ifdef CONFIG_BLOCK
+	return dev->type != &part_type;
+#else
+	return 1;
+#endif
+}
+
 static struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
@@ -652,14 +661,14 @@ static int device_add_class_symlinks(struct device *dev)
 #ifdef CONFIG_SYSFS_DEPRECATED
 	/* stacked class devices need a symlink in the class directory */
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type) {
+	    dev_needs_link(dev)) {
 		error = sysfs_create_link(&dev->class->subsys.kobj, &dev->kobj,
 					  dev->bus_id);
 		if (error)
 			goto out_subsys;
 	}
 
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && dev_needs_link(dev)) {
 		struct device *parent = dev->parent;
 		char *class_name;
 
@@ -688,11 +697,11 @@ static int device_add_class_symlinks(struct device *dev)
 	return 0;
 
 out_device:
-	if (dev->parent && dev->type != &part_type)
+	if (dev->parent && dev_needs_link(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 out_busid:
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type)
+	    dev_needs_link(dev))
 		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 #else
 	/* link in the class directory pointing to the device */
@@ -701,7 +710,7 @@ out_busid:
 	if (error)
 		goto out_subsys;
 
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && dev_needs_link(dev)) {
 		error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
 					  "device");
 		if (error)
@@ -725,7 +734,7 @@ static void device_remove_class_symlinks(struct device *dev)
 		return;
 
 #ifdef CONFIG_SYSFS_DEPRECATED
-	if (dev->parent && dev->type != &part_type) {
+	if (dev->parent && dev_needs_link(dev)) {
 		char *class_name;
 
 		class_name = make_class_name(dev->class->name, &dev->kobj);
@@ -737,10 +746,10 @@ static void device_remove_class_symlinks(struct device *dev)
 	}
 
 	if (dev->kobj.parent != &dev->class->subsys.kobj &&
-	    dev->type != &part_type)
+	    dev_needs_link(dev))
 		sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
 #else
-	if (dev->parent && dev->type != &part_type)
+	if (dev->parent && dev_needs_link(dev))
 		sysfs_remove_link(&dev->kobj, "device");
 
 	sysfs_remove_link(&dev->class->subsys.kobj, dev->bus_id);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
