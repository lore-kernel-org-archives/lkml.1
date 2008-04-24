Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbYDXUVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbYDXUVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 16:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761468AbYDXUVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 16:21:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52501 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbYDXUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 16:21:36 -0400
Date: Thu, 24 Apr 2008 23:21:32 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
cc: dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no
Subject: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Message-ID: <Pine.LNX.4.64.0804242320190.30047@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
wait until background scanning of USB mass storage devices is complete before
attempting to mount the root filesystem.

The config option is an alternative to the root_delay= kernel parameter
solution people currently use to boot from USB mass storage devices.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: <linux-usb@vger.kernel.org>
Tested-by: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/usb/storage/usb.c |    3 +++
 include/linux/init.h      |   12 ++++++++++++
 init/Kconfig              |    5 +++++
 init/do_mounts.c          |   32 ++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+)

Index: linux-2.6/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.orig/drivers/usb/storage/usb.c
+++ linux-2.6/drivers/usb/storage/usb.c
@@ -928,6 +928,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	complete_root_scan();
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -1007,12 +1008,14 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	begin_root_scan();
 	/* Start up the thread for delayed SCSI-device scanning */
 	th = kthread_create(usb_stor_scan_thread, us, "usb-stor-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_WARNING USB_STORAGE 
 		       "Unable to start the device-scanning thread\n");
 		quiesce_and_remove_host(us);
+		complete_root_scan();
 		result = PTR_ERR(th);
 		goto BadDevice;
 	}
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -147,6 +147,18 @@ extern unsigned int reset_devices;
 void setup_arch(char **);
 void prepare_namespace(void);
 
+#ifdef CONFIG_LATE_ROOT_MOUNT
+void begin_root_scan(void);
+void complete_root_scan(void);
+#else /* !CONFIG_LATE_ROOT_MOUNT */
+static inline void begin_root_scan(void)
+{
+}
+static inline void complete_root_scan(void)
+{
+}
+#endif /* CONFIG_LATE_ROOT_MOUNT */
+
 #endif
   
 #ifndef MODULE
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -473,6 +473,11 @@ config PID_NS
 	  Unless you want to work with an experimental feature
 	  say N here.
 
+config LATE_ROOT_MOUNT
+	bool "Wait for devices that do background scanning before mounting root"
+	help
+	  Say Y here if your root partition is, for example, on an USB disk.
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
Index: linux-2.6/init/do_mounts.c
===================================================================
--- linux-2.6.orig/init/do_mounts.c
+++ linux-2.6/init/do_mounts.c
@@ -326,6 +326,36 @@ void __init mount_root(void)
 #endif
 }
 
+#ifdef CONFIG_LATE_ROOT_MOUNT
+/*
+ * Late root mounting for devices that need background scanning.
+ */
+static DECLARE_COMPLETION(root_scan_done);
+static atomic_t nr_root_scans;
+
+void begin_root_scan(void)
+{
+	atomic_inc(&nr_root_scans);
+}
+
+void complete_root_scan(void)
+{
+	if (atomic_dec_and_test(&nr_root_scans))
+		complete(&root_scan_done);
+}
+
+static void __init wait_for_root_scan(void)
+{
+	if (atomic_read(&nr_root_scans))
+		wait_for_completion(&root_scan_done);
+}
+#else /* !CONFIG_LATE_ROOT_MOUNT */
+
+static inline void wait_for_root_scan(void)
+{
+}
+#endif /* CONFIG_LATE_ROOT_MOUNT */
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -339,6 +369,8 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+	wait_for_root_scan();
+
 	/* wait for the known devices to complete their probing */
 	while (driver_probe_done() != 0)
 		msleep(100);
