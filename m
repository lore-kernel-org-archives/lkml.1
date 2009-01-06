Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbZAFWVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbZAFWVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZAFWNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:43 -0500
Received: from kroah.org ([198.145.64.141]:51235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755926AbZAFWNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mark McLoughlin <markmc@redhat.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 23/60] s390: remove s390_root_dev_*()
Date: Tue,  6 Jan 2009 14:11:42 -0800
Message-Id: <1231279939-32728-23-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark McLoughlin <markmc@redhat.com>

Replace s390_root_dev_register() with root_device_register() etc.

[Includes fix from Cornelia Huck]

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/include/asm/s390_rdev.h |   15 -----------
 drivers/s390/Makefile             |    2 +-
 drivers/s390/block/dcssblk.c      |   11 +++----
 drivers/s390/crypto/ap_bus.c      |    7 ++---
 drivers/s390/kvm/kvm_virtio.c     |    5 +--
 drivers/s390/net/cu3088.c         |    7 ++---
 drivers/s390/net/qeth_core_main.c |    7 ++---
 drivers/s390/net/qeth_l2_main.c   |    2 -
 drivers/s390/net/qeth_l3_main.c   |    2 -
 drivers/s390/s390_rdev.c          |   51 -------------------------------------
 net/iucv/iucv.c                   |    7 ++---
 11 files changed, 20 insertions(+), 96 deletions(-)
 delete mode 100644 arch/s390/include/asm/s390_rdev.h
 delete mode 100644 drivers/s390/s390_rdev.c

diff --git a/arch/s390/include/asm/s390_rdev.h b/arch/s390/include/asm/s390_rdev.h
deleted file mode 100644
index 6fa2044..0000000
--- a/arch/s390/include/asm/s390_rdev.h
+++ /dev/null
@@ -1,15 +0,0 @@
-/*
- *  include/asm-s390/ccwdev.h
- *
- *    Copyright (C) 2002,2005 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *    Author(s): Cornelia Huck <cornelia.huck@de.ibm.com>
- *               Carsten Otte  <cotte@de.ibm.com>
- *
- *  Interface for s390 root device
- */
-
-#ifndef _S390_RDEV_H_
-#define _S390_RDEV_H_
-extern struct device *s390_root_dev_register(const char *);
-extern void s390_root_dev_unregister(struct device *);
-#endif /* _S390_RDEV_H_ */
diff --git a/drivers/s390/Makefile b/drivers/s390/Makefile
index 4f4e7cf..d0eae59 100644
--- a/drivers/s390/Makefile
+++ b/drivers/s390/Makefile
@@ -4,7 +4,7 @@
 
 CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 
-obj-y += s390mach.o sysinfo.o s390_rdev.o
+obj-y += s390mach.o sysinfo.o
 obj-y += cio/ block/ char/ crypto/ net/ scsi/ kvm/
 
 drivers-y += drivers/s390/built-in.o
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 26ffc6a..cfdcf1a 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -18,7 +18,6 @@
 #include <asm/io.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
-#include <asm/s390_rdev.h>
 
 #define DCSSBLK_NAME "dcssblk"
 #define DCSSBLK_MINORS_PER_DISK 1
@@ -946,7 +945,7 @@ dcssblk_check_params(void)
 static void __exit
 dcssblk_exit(void)
 {
-	s390_root_dev_unregister(dcssblk_root_dev);
+	root_device_unregister(dcssblk_root_dev);
 	unregister_blkdev(dcssblk_major, DCSSBLK_NAME);
 }
 
@@ -955,22 +954,22 @@ dcssblk_init(void)
 {
 	int rc;
 
-	dcssblk_root_dev = s390_root_dev_register("dcssblk");
+	dcssblk_root_dev = root_device_register("dcssblk");
 	if (IS_ERR(dcssblk_root_dev))
 		return PTR_ERR(dcssblk_root_dev);
 	rc = device_create_file(dcssblk_root_dev, &dev_attr_add);
 	if (rc) {
-		s390_root_dev_unregister(dcssblk_root_dev);
+		root_device_unregister(dcssblk_root_dev);
 		return rc;
 	}
 	rc = device_create_file(dcssblk_root_dev, &dev_attr_remove);
 	if (rc) {
-		s390_root_dev_unregister(dcssblk_root_dev);
+		root_device_unregister(dcssblk_root_dev);
 		return rc;
 	}
 	rc = register_blkdev(0, DCSSBLK_NAME);
 	if (rc < 0) {
-		s390_root_dev_unregister(dcssblk_root_dev);
+		root_device_unregister(dcssblk_root_dev);
 		return rc;
 	}
 	dcssblk_major = rc;
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 1f5f5d2..9c14840 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -36,7 +36,6 @@
 #include <linux/notifier.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
-#include <asm/s390_rdev.h>
 #include <asm/reset.h>
 #include <asm/airq.h>
 #include <asm/atomic.h>
@@ -1522,7 +1521,7 @@ int __init ap_module_init(void)
 	}
 
 	/* Create /sys/devices/ap. */
-	ap_root_device = s390_root_dev_register("ap");
+	ap_root_device = root_device_register("ap");
 	rc = IS_ERR(ap_root_device) ? PTR_ERR(ap_root_device) : 0;
 	if (rc)
 		goto out_bus;
@@ -1565,7 +1564,7 @@ out_work:
 	hrtimer_cancel(&ap_poll_timer);
 	destroy_workqueue(ap_work_queue);
 out_root:
-	s390_root_dev_unregister(ap_root_device);
+	root_device_unregister(ap_root_device);
 out_bus:
 	while (i--)
 		bus_remove_file(&ap_bus_type, ap_bus_attrs[i]);
@@ -1600,7 +1599,7 @@ void ap_module_exit(void)
 	hrtimer_cancel(&ap_poll_timer);
 	destroy_workqueue(ap_work_queue);
 	tasklet_kill(&ap_tasklet);
-	s390_root_dev_unregister(ap_root_device);
+	root_device_unregister(ap_root_device);
 	while ((dev = bus_find_device(&ap_bus_type, NULL, NULL,
 		    __ap_match_all)))
 	{
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 28c90b8..cbc8566 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -24,7 +24,6 @@
 #include <asm/kvm_virtio.h>
 #include <asm/setup.h>
 #include <asm/s390_ext.h>
-#include <asm/s390_rdev.h>
 
 #define VIRTIO_SUBCODE_64 0x0D00
 
@@ -335,7 +334,7 @@ static int __init kvm_devices_init(void)
 	if (!MACHINE_IS_KVM)
 		return -ENODEV;
 
-	kvm_root = s390_root_dev_register("kvm_s390");
+	kvm_root = root_device_register("kvm_s390");
 	if (IS_ERR(kvm_root)) {
 		rc = PTR_ERR(kvm_root);
 		printk(KERN_ERR "Could not register kvm_s390 root device");
@@ -344,7 +343,7 @@ static int __init kvm_devices_init(void)
 
 	rc = vmem_add_mapping(real_memory_size, PAGE_SIZE);
 	if (rc) {
-		s390_root_dev_unregister(kvm_root);
+		root_device_unregister(kvm_root);
 		return rc;
 	}
 
diff --git a/drivers/s390/net/cu3088.c b/drivers/s390/net/cu3088.c
index f4a3237..4838345 100644
--- a/drivers/s390/net/cu3088.c
+++ b/drivers/s390/net/cu3088.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/err.h>
 
-#include <asm/s390_rdev.h>
 #include <asm/ccwdev.h>
 #include <asm/ccwgroup.h>
 
@@ -120,12 +119,12 @@ cu3088_init (void)
 {
 	int rc;
 
-	cu3088_root_dev = s390_root_dev_register("cu3088");
+	cu3088_root_dev = root_device_register("cu3088");
 	if (IS_ERR(cu3088_root_dev))
 		return PTR_ERR(cu3088_root_dev);
 	rc = ccw_driver_register(&cu3088_driver);
 	if (rc)
-		s390_root_dev_unregister(cu3088_root_dev);
+		root_device_unregister(cu3088_root_dev);
 
 	return rc;
 }
@@ -134,7 +133,7 @@ static void __exit
 cu3088_exit (void)
 {
 	ccw_driver_unregister(&cu3088_driver);
-	s390_root_dev_unregister(cu3088_root_dev);
+	root_device_unregister(cu3088_root_dev);
 }
 
 MODULE_DEVICE_TABLE(ccw,cu3088_ids);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6811dd5..d1b5beb 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -24,7 +24,6 @@
 
 #include <asm/ebcdic.h>
 #include <asm/io.h>
-#include <asm/s390_rdev.h>
 
 #include "qeth_core.h"
 #include "qeth_core_offl.h"
@@ -4525,7 +4524,7 @@ static int __init qeth_core_init(void)
 				&driver_attr_group);
 	if (rc)
 		goto driver_err;
-	qeth_core_root_dev = s390_root_dev_register("qeth");
+	qeth_core_root_dev = root_device_register("qeth");
 	rc = IS_ERR(qeth_core_root_dev) ? PTR_ERR(qeth_core_root_dev) : 0;
 	if (rc)
 		goto register_err;
@@ -4539,7 +4538,7 @@ static int __init qeth_core_init(void)
 
 	return 0;
 slab_err:
-	s390_root_dev_unregister(qeth_core_root_dev);
+	root_device_unregister(qeth_core_root_dev);
 register_err:
 	driver_remove_file(&qeth_core_ccwgroup_driver.driver,
 			   &driver_attr_group);
@@ -4557,7 +4556,7 @@ out_err:
 
 static void __exit qeth_core_exit(void)
 {
-	s390_root_dev_unregister(qeth_core_root_dev);
+	root_device_unregister(qeth_core_root_dev);
 	driver_remove_file(&qeth_core_ccwgroup_driver.driver,
 			   &driver_attr_group);
 	ccwgroup_driver_unregister(&qeth_core_ccwgroup_driver);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 21627ba..591a2b3 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -20,8 +20,6 @@
 #include <linux/mii.h>
 #include <linux/ip.h>
 
-#include <asm/s390_rdev.h>
-
 #include "qeth_core.h"
 #include "qeth_core_offl.h"
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index cfda1ec..4693ee4 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -26,8 +26,6 @@
 #include <net/ip.h>
 #include <net/arp.h>
 
-#include <asm/s390_rdev.h>
-
 #include "qeth_l3.h"
 #include "qeth_core_offl.h"
 
diff --git a/drivers/s390/s390_rdev.c b/drivers/s390/s390_rdev.c
deleted file mode 100644
index 64371c0..0000000
--- a/drivers/s390/s390_rdev.c
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- *  drivers/s390/s390_rdev.c
- *  s390 root device
- *
- *    Copyright (C) 2002, 2005 IBM Deutschland Entwicklung GmbH,
- *			 IBM Corporation
- *    Author(s): Cornelia Huck (cornelia.huck@de.ibm.com)
- *		  Carsten Otte  (cotte@de.ibm.com)
- */
-
-#include <linux/slab.h>
-#include <linux/err.h>
-#include <linux/device.h>
-#include <asm/s390_rdev.h>
-
-static void
-s390_root_dev_release(struct device *dev)
-{
-	kfree(dev);
-}
-
-struct device *
-s390_root_dev_register(const char *name)
-{
-	struct device *dev;
-	int ret;
-
-	if (!strlen(name))
-		return ERR_PTR(-EINVAL);
-	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
-	if (!dev)
-		return ERR_PTR(-ENOMEM);
-	dev_set_name(dev, name);
-	dev->release = s390_root_dev_release;
-	ret = device_register(dev);
-	if (ret) {
-		kfree(dev);
-		return ERR_PTR(ret);
-	}
-	return dev;
-}
-
-void
-s390_root_dev_unregister(struct device *dev)
-{
-	if (dev)
-		device_unregister(dev);
-}
-
-EXPORT_SYMBOL(s390_root_dev_register);
-EXPORT_SYMBOL(s390_root_dev_unregister);
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 032f61e..a35240f 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -50,7 +50,6 @@
 #include <asm/ebcdic.h>
 #include <asm/io.h>
 #include <asm/s390_ext.h>
-#include <asm/s390_rdev.h>
 #include <asm/smp.h>
 
 /*
@@ -1696,7 +1695,7 @@ static int __init iucv_init(void)
 	rc = register_external_interrupt(0x4000, iucv_external_interrupt);
 	if (rc)
 		goto out;
-	iucv_root = s390_root_dev_register("iucv");
+	iucv_root = root_device_register("iucv");
 	if (IS_ERR(iucv_root)) {
 		rc = PTR_ERR(iucv_root);
 		goto out_int;
@@ -1740,7 +1739,7 @@ out_free:
 		kfree(iucv_irq_data[cpu]);
 		iucv_irq_data[cpu] = NULL;
 	}
-	s390_root_dev_unregister(iucv_root);
+	root_device_unregister(iucv_root);
 out_int:
 	unregister_external_interrupt(0x4000, iucv_external_interrupt);
 out:
@@ -1770,7 +1769,7 @@ static void __exit iucv_exit(void)
 		kfree(iucv_irq_data[cpu]);
 		iucv_irq_data[cpu] = NULL;
 	}
-	s390_root_dev_unregister(iucv_root);
+	root_device_unregister(iucv_root);
 	bus_unregister(&iucv_bus);
 	unregister_external_interrupt(0x4000, iucv_external_interrupt);
 }
-- 
1.6.0.4

