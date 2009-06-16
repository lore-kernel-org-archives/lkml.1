Return-Path: <linux-kernel-owner+w=401wt.eu-S937473AbZFPGIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937473AbZFPGIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935168AbZFPFvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:15 -0400
Received: from kroah.org ([198.145.64.141]:48370 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935580AbZFPFvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:13 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/64] Driver Core: misc: add nodename support for misc devices.
Date: Mon, 15 Jun 2009 22:46:15 -0700
Message-Id: <1245131213-24168-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
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

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 9c44615..9371448 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -236,6 +236,7 @@ static const struct file_operations microcode_fops = {
 static struct miscdevice microcode_dev = {
 	.minor			= MICROCODE_MINOR,
 	.name			= "microcode",
+	.devnode		= "cpu/microcode",
 	.fops			= &microcode_fops,
 };
 
diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e5d583c..fc93e2f 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -153,6 +153,7 @@ static const struct file_operations rng_chrdev_ops = {
 static struct miscdevice rng_miscdev = {
 	.minor		= RNG_MISCDEV_MINOR,
 	.name		= RNG_MODULE_NAME,
+	.devnode	= "hwrng",
 	.fops		= &rng_chrdev_ops,
 };
 
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index a5e0db9..62c99fa 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -168,7 +168,6 @@ static const struct file_operations misc_fops = {
 	.open		= misc_open,
 };
 
-
 /**
  *	misc_register	-	register a miscellaneous device
  *	@misc: device structure
@@ -217,8 +216,8 @@ int misc_register(struct miscdevice * misc)
 		misc_minors[misc->minor >> 3] |= 1 << (misc->minor & 7);
 	dev = MKDEV(MISC_MAJOR, misc->minor);
 
-	misc->this_device = device_create(misc_class, misc->parent, dev, NULL,
-					  "%s", misc->name);
+	misc->this_device = device_create(misc_class, misc->parent, dev,
+					  misc, "%s", misc->name);
 	if (IS_ERR(misc->this_device)) {
 		err = PTR_ERR(misc->this_device);
 		goto out;
@@ -264,6 +263,15 @@ int misc_deregister(struct miscdevice *misc)
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
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 823ceba..1128d3f 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1513,6 +1513,7 @@ static const struct file_operations _ctl_fops = {
 static struct miscdevice _dm_misc = {
 	.minor 		= MISC_DYNAMIC_MINOR,
 	.name  		= DM_NAME,
+	.devnode	= "mapper/control",
 	.fops  		= &_ctl_fops
 };
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 811d351..11a0ba4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1366,6 +1366,7 @@ static const struct file_operations tun_fops = {
 static struct miscdevice tun_miscdev = {
 	.minor = TUN_MINOR,
 	.name = "tun",
+	.devnode = "net/tun",
 	.fops = &tun_fops,
 };
 
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index beb6ec9..0521177 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -41,6 +41,7 @@ struct miscdevice  {
 	struct list_head list;
 	struct device *parent;
 	struct device *this_device;
+	const char *devnode;
 };
 
 extern int misc_register(struct miscdevice * misc);
-- 
1.6.3.2

