Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZEIOn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZEIOn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZEIOmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:42:54 -0400
Received: from kroah.org ([198.145.64.141]:54170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbZEIOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:42:53 -0400
X-Mailbox-Line: From greg@blue.kroah.org Sat May  9 07:36:32 2009
Message-Id: <20090509143631.755885703@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Sat, 09 May 2009 07:26:03 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>
Subject: [patch 02/13] Driver Core: misc: add nodename support for misc devices.
References: <20090509142601.874865281@blue.kroah.org>
Content-Disposition: inline; filename=driver-core-misc-add-nodename-support-for-misc-devices.patch
In-Reply-To: <20090509143742.GA27663@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support for misc devices to report their requested nodename to
userspace.  It also updates a number of misc drivers to provide the
needed subdirectory and device name to be used for them.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/microcode_core.c |    1 +
 drivers/char/hw_random/core.c    |    1 +
 drivers/char/misc.c              |   15 ++++++++++++---
 drivers/md/dm-ioctl.c            |    1 +
 drivers/net/tun.c                |    1 +
 include/linux/miscdevice.h       |    1 +
 6 files changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -173,6 +173,7 @@ static const struct file_operations micr
 static struct miscdevice microcode_dev = {
 	.minor		= MICROCODE_MINOR,
 	.name		= "microcode",
+	.devnode	= "cpu/microcode",
 	.fops		= &microcode_fops,
 };
 
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -153,6 +153,7 @@ static const struct file_operations rng_
 static struct miscdevice rng_miscdev = {
 	.minor		= RNG_MISCDEV_MINOR,
 	.name		= RNG_MODULE_NAME,
+	.devnode	= "hwrng",
 	.fops		= &rng_chrdev_ops,
 };
 
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -168,7 +168,6 @@ static const struct file_operations misc
 	.open		= misc_open,
 };
 
-
 /**
  *	misc_register	-	register a miscellaneous device
  *	@misc: device structure
@@ -217,8 +216,8 @@ int misc_register(struct miscdevice * mi
 		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
-	misc->this_device = device_create(misc_class, misc->parent, dev, NULL,
-					  "%s", misc->name);
+	misc->this_device = device_create(misc_class, misc->parent, dev,
+					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
 		err = PTR_ERR(misc->this_device);
 		goto out;
@@ -264,6 +263,15 @@ int misc_deregister(struct miscdevice *m
 EXPORT_SYMBOL(misc_register);
 EXPORT_SYMBOL(misc_deregister);
 
+static char *misc_nodename(struct device *dev)
+{
+	struct miscdevice *c = dev_get_drvdata(dev);
+
+	if (c->devnode)
+		return kstrdup(c->devnode, GFP_KERNEL);
+	return NULL;
+}
+
 static int __init misc_init(void)
 {
 	int err;
@@ -279,6 +287,7 @@ static int __init misc_init(void)
 	err = -EIO;
 	if (register_chrdev(MISC_MAJOR,"misc",&misc_fops))
 		goto fail_printk;
+	misc_class->nodename = misc_nodename;
 	return 0;
 
 fail_printk:
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1513,6 +1513,7 @@ static const struct file_operations _ctl
 static struct miscdevice _dm_misc = {
 	.minor 		= MISC_DYNAMIC_MINOR,
 	.name  		= DM_NAME,
+	.devnode	= "mapper/control",
 	.fops  		= &_ctl_fops
 };
 
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1318,6 +1318,7 @@ static const struct file_operations tun_
 static struct miscdevice tun_miscdev = {
 	.minor = TUN_MINOR,
 	.name = "tun",
+	.devnode = "net/tun",
 	.fops = &tun_fops,
 };
 
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -41,6 +41,7 @@ struct miscdevice  {
 	struct list_head list;
 	struct device *parent;
 	struct device *this_device;
+	const char *devnode;
 };
 
 extern int misc_register(struct miscdevice * misc);


