Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbZDOGaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbZDOGaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZDOG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:28:55 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:49595 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZDOG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:28:53 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       David Kiliani <mail@davidkiliani.de>
Subject: [PATCH resend 6/8] staging: meilhaus, switch to misc device
Date: Wed, 15 Apr 2009 08:28:45 +0200
Message-Id: <1239776927-16168-6-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
References: <1239776927-16168-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to occupy one major number because of one device.

Switch to misc device, which also emits uevent, so that the dev node
is also created by udev.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: David Kiliani <mail@davidkiliani.de>
---
 drivers/staging/meilhaus/memain.c |   64 ++++++------------------------------
 1 files changed, 11 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/meilhaus/memain.c b/drivers/staging/meilhaus/memain.c
index fd9f079..d5aacdd 100644
--- a/drivers/staging/meilhaus/memain.c
+++ b/drivers/staging/meilhaus/memain.c
@@ -38,7 +38,7 @@
 //#include <linux/usb.h>
 #include <linux/errno.h>
 #include <linux/uaccess.h>
-#include <linux/cdev.h>
+#include <linux/miscdevice.h>
 #include <linux/rwsem.h>
 
 #include "medefines.h"
@@ -68,13 +68,6 @@ MODULE_PARM_DESC(me_bosch_fw,
 		 "Flags which signals the ME-4600 driver to load the bosch firmware (default = 0).");
 #endif //BOSCH
 
-static unsigned int major = 0;
-#ifdef module_param
-module_param(major, int, S_IRUGO);
-#else
-MODULE_PARM(major, "i");
-#endif
-
 /* Global Driver Lock
 */
 
@@ -100,15 +93,10 @@ static int me_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 //static int me_probe_usb(struct usb_interface *interface, const struct usb_device_id *id);
 //static void me_disconnect_usb(struct usb_interface *interface);
 
-/* Character device structure
-*/
-
-static struct cdev *cdevp;
-
 /* File operations provided by the module
 */
 
-static struct file_operations me_file_operations = {
+static const struct file_operations me_file_operations = {
 	.owner = THIS_MODULE,
 	.ioctl = me_ioctl,
 	.open = me_open,
@@ -1910,11 +1898,16 @@ static int me_ioctl(struct inode *inodep,
 	return -ENOTTY;
 }
 
+static struct miscdevice me_miscdev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = MEMAIN_NAME,
+	.fops = &me_file_operations,
+};
+
 // Init and exit of module.
 static int memain_init(void)
 {
 	int result = 0;
-	dev_t dev = MKDEV(major, 0);
 
 	PDEBUG("executed.\n");
 
@@ -1943,46 +1936,14 @@ static int memain_init(void)
 		}
 	}
 */
-	// Register the character device.
-	if (major) {
-		result = register_chrdev_region(dev, 1, MEMAIN_NAME);
-	} else {
-		result = alloc_chrdev_region(&dev, 0, 1, MEMAIN_NAME);
-		major = MAJOR(dev);
-	}
-
+	result = misc_register(&me_miscdev);
 	if (result < 0) {
-		PERROR("Can't get major driver no.\n");
+		printk(KERN_ERR MEMAIN_NAME ": can't register misc device\n");
 		goto INIT_ERROR_3;
 	}
 
-	cdevp = cdev_alloc();
-
-	if (!cdevp) {
-		PERROR("Can't get character device structure.\n");
-		result = -ENOMEM;
-		goto INIT_ERROR_4;
-	}
-
-	cdevp->ops = &me_file_operations;
-
-	cdevp->owner = THIS_MODULE;
-
-	result = cdev_add(cdevp, dev, 1);
-
-	if (result < 0) {
-		PERROR("Cannot add character device structure.\n");
-		goto INIT_ERROR_5;
-	}
-
 	return 0;
 
-      INIT_ERROR_5:
-	cdev_del(cdevp);
-
-      INIT_ERROR_4:
-	unregister_chrdev_region(dev, 1);
-
       INIT_ERROR_3:
 //      usb_deregister(&me_usb_driver);
 
@@ -1996,12 +1957,9 @@ static int memain_init(void)
 
 static void __exit memain_exit(void)
 {
-	dev_t dev = MKDEV(major, 0);
-
 	PDEBUG("executed.\n");
 
-	cdev_del(cdevp);
-	unregister_chrdev_region(dev, 1);
+	misc_deregister(&me_miscdev);
 	pci_unregister_driver(&me_pci_driver);
 //      usb_deregister(&me_usb_driver);
 	clear_device_list();
-- 
1.6.2

