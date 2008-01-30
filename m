Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbYA3Kgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbYA3Kgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYA3Kgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:36:45 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:24216 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYA3Kgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:36:44 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="61207710"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [Blackfin] char driver for Blackfin on-chip OTP memory
Date: Wed, 30 Jan 2008 18:36:41 +0800
Message-Id: <1201689401-2892-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

initial char driver for otp memory
(only read supported atm ... needs real examples/docs for write support)

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/char/Kconfig    |   28 +++++++
 drivers/char/Makefile   |    1 +
 drivers/char/bfin-otp.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 232 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/bfin-otp.c

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 4666295..2a426db 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -492,6 +492,34 @@ config BRIQ_PANEL
 
 	  It's safe to say N here.
 
+config BFIN_OTP
+	tristate "Blackfin On-Chip OTP Memory Support"
+	depends on BLACKFIN && (BF52x || BF54x)
+	default y
+	help
+	  If you say Y here, you will get support for a character device
+	  interface into the One Time Programmable memory pages that are
+	  stored on the Blackfin processor.  This will not get you access
+	  to the secure memory pages however.  You will need to write your
+	  own secure code and reader for that.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called bfin-otp.
+
+	  If unsure, it is safe to say Y.
+
+config BFIN_OTP_WRITE_ENABLE
+	bool "Enable writing support of OTP pages"
+	depends on BFIN_OTP
+	default n
+	help
+	  If you say Y here, you will enable support for writing of the
+	  OTP pages.  This is dangerous by nature as you can only program
+	  the pages once, so only enable this option when you actually
+	  need it so as to not inadvertently clobber data.
+
+	  If unsure, say N.
+
 config PRINTER
 	tristate "Parallel printer support"
 	depends on PARPORT
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 96fc01e..b2f1c77 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_VIOTAPE)		+= viotape.o
 obj-$(CONFIG_HVCS)		+= hvcs.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
+obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
 obj-$(CONFIG_TIPAR)		+= tipar.o
diff --git a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
new file mode 100644
index 0000000..896a987
--- /dev/null
+++ b/drivers/char/bfin-otp.c
@@ -0,0 +1,203 @@
+/*
+ * Blackfin On-Chip OTP Memory Interface
+ *  Supports BF52x/BF54x
+ *
+ * Copyright 2007-2008 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+
+#include <asm/blackfin.h>
+#include <asm/uaccess.h>
+
+#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
+#define stampit() stamp("here i am")
+
+#define DRIVER_NAME "bfin-otp"
+#define PFX DRIVER_NAME ": "
+
+DEFINE_MUTEX(bfin_otp_lock);
+
+/* OTP Boot ROM functions */
+#define _BOOTROM_OTP_COMMAND           0xEF000018
+#define _BOOTROM_OTP_READ              0xEF00001A
+#define _BOOTROM_OTP_WRITE             0xEF00001C
+
+static u32 (* const otp_command)(u32 command, u32 value) = (void *)_BOOTROM_OTP_COMMAND;
+static u32 (* const otp_read)(u32 page, u32 flags, u64 *page_content) = (void *)_BOOTROM_OTP_READ;
+static u32 (* const otp_write)(u32 page, u32 flags, u64 *page_content) = (void *)_BOOTROM_OTP_WRITE;
+
+/* otp_command(): defines for "command" */
+#define OTP_INIT             0x00000001
+#define OTP_CLOSE            0x00000002
+
+/* otp_{read,write}(): defines for "flags" */
+#define OTP_LOWER_HALF       0x00000000 /* select upper/lower 64-bit half (bit 0) */
+#define OTP_UPPER_HALF       0x00000001
+#define OTP_NO_ECC           0x00000010 /* do not use ECC */
+#define OTP_LOCK             0x00000020 /* sets page protection bit for page */
+#define OTP_ACCESS_READ      0x00001000
+#define OTP_ACCESS_READWRITE 0x00002000
+
+/* Return values for all functions */
+#define OTP_SUCCESS          0x00000000
+#define OTP_MASTER_ERROR     0x001
+#define OTP_WRITE_ERROR      0x003
+#define OTP_READ_ERROR       0x005
+#define OTP_ACC_VIO_ERROR    0x009
+#define OTP_DATA_MULT_ERROR  0x011
+#define OTP_ECC_MULT_ERROR   0x021
+#define OTP_PREV_WR_ERROR    0x041
+#define OTP_DATA_SB_WARN     0x100
+#define OTP_ECC_SB_WARN      0x200
+
+/**
+ *	bfin_otp_read - Read OTP pages
+ *
+ *	All reads must be in half page chunks (half page == 64 bits).
+ */
+ssize_t bfin_otp_read(struct file *file, char __user *buff, size_t count, loff_t *pos)
+{
+	ssize_t bytes_done;
+	u32 page, flags, ret;
+	u64 content;
+
+	stampit();
+
+	if (count % sizeof(u64))
+		return -EMSGSIZE;
+
+	if (mutex_lock_interruptible(&bfin_otp_lock))
+		return -ERESTARTSYS;
+
+	bytes_done = 0;
+	page = *pos / (sizeof(u64) * 2);
+	while (bytes_done < count) {
+		flags = (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
+		stamp("processing page %i (%s)", page, (flags == OTP_UPPER_HALF ? "upper" : "lower"));
+		ret = otp_read(page, flags, &content);
+		if (ret & OTP_MASTER_ERROR) {
+			bytes_done = -EIO;
+			break;
+		}
+		if (copy_to_user(buff + bytes_done, &content, sizeof(content))) {
+			bytes_done = -EFAULT;
+			break;
+		}
+		if (flags == OTP_UPPER_HALF)
+			++page;
+		bytes_done += sizeof(content);
+		*pos += sizeof(content);
+	}
+
+	mutex_unlock(&bfin_otp_lock);
+
+	return bytes_done;
+}
+
+#ifdef CONFIG_BFIN_OTP_WRITE_ENABLE
+/**
+ *	bfin_otp_write - Write OTP pages
+ *
+ *	All writes must be in half page chunks (half page == 64 bits).
+ */
+static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t count, loff_t *pos)
+{
+	stampit();
+
+	if (count % sizeof(u64))
+		return -EMSGSIZE;
+
+	if (mutex_lock_interruptible(&bfin_otp_lock))
+		return -ERESTARTSYS;
+
+	/* need otp_init() documentation before this can be implemented */
+
+	mutex_unlock(&bfin_otp_lock);
+
+	return -EINVAL;
+}
+#else
+# define bfin_otp_write NULL
+#endif
+
+static struct class *bfin_otp_class;
+static dev_t bfin_otp_dev_node;
+static struct cdev bfin_otp_cdev;
+
+static struct file_operations bfin_otp_fops = {
+	.owner    = THIS_MODULE,
+	.read     = bfin_otp_read,
+	.write    = bfin_otp_write,
+};
+
+/**
+ *	bfin_otp_init - Initialize module
+ *
+ *	Registers the device and notifier handler. Actual device
+ *	initialization is handled by bfin_otp_open().
+ */
+static int __init bfin_otp_init(void)
+{
+	int ret;
+
+	stampit();
+
+	ret = alloc_chrdev_region(&bfin_otp_dev_node, 0, 1, "otp");
+	if (ret) {
+		printk(KERN_ERR PFX "unable to get a char device\n");
+		return ret;
+	}
+
+	cdev_init(&bfin_otp_cdev, &bfin_otp_fops);
+	bfin_otp_cdev.owner = THIS_MODULE;
+	bfin_otp_cdev.ops = &bfin_otp_fops;
+
+	ret = cdev_add(&bfin_otp_cdev, bfin_otp_dev_node, 1);
+	if (ret) {
+		unregister_chrdev_region(bfin_otp_dev_node, 1);
+		printk(KERN_ERR PFX "unable to register char device\n");
+		return ret;
+	}
+
+	bfin_otp_class = class_create(THIS_MODULE, "otp");
+	device_create(bfin_otp_class, NULL, bfin_otp_dev_node, "otp");
+
+	printk(KERN_INFO PFX "initialized\n");
+
+	return 0;
+}
+
+/**
+ *	bfin_otp_exit - Deinitialize module
+ *
+ *	Unregisters the device and notifier handler. Actual device
+ *	deinitialization is handled by bfin_otp_close().
+ */
+static void __exit bfin_otp_exit(void)
+{
+	stampit();
+
+	device_destroy(bfin_otp_class, bfin_otp_dev_node);
+	class_destroy(bfin_otp_class);
+	unregister_chrdev_region(bfin_otp_dev_node, 1);
+	cdev_del(&bfin_otp_cdev);
+}
+
+module_init(bfin_otp_init);
+module_exit(bfin_otp_exit);
+
+MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
+MODULE_DESCRIPTION("Blackfin OTP Memory Interface");
+MODULE_LICENSE("GPL");
-- 
1.5.3.4
