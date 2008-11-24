Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbYKXTkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbYKXTkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYKXTkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:40:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:39648 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYKXTkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:40:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 24 Nov 2008 20:40:00 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fix small memory leak at module removal
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.d0220c9ae409a998@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c      |    2 +-
 drivers/firewire/fw-device.h      |    2 ++
 drivers/firewire/fw-transaction.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -619,7 +619,7 @@ static int shutdown_unit(struct device *
  */
 DECLARE_RWSEM(fw_device_rwsem);
 
-static DEFINE_IDR(fw_device_idr);
+DEFINE_IDR(fw_device_idr);
 int fw_cdev_major;
 
 struct fw_device *fw_device_get_by_devt(dev_t devt)
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -21,6 +21,7 @@
 
 #include <linux/fs.h>
 #include <linux/cdev.h>
+#include <linux/idr.h>
 #include <linux/rwsem.h>
 #include <linux/mutex.h>
 #include <asm/atomic.h>
@@ -103,6 +104,7 @@ void fw_device_cdev_update(struct fw_dev
 void fw_device_cdev_remove(struct fw_device *device);
 
 extern struct rw_semaphore fw_device_rwsem;
+extern struct idr fw_device_idr;
 extern int fw_cdev_major;
 
 /*
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/completion.h>
+#include <linux/idr.h>
 #include <linux/kernel.h>
 #include <linux/kref.h>
 #include <linux/module.h>
@@ -968,6 +969,7 @@ static void __exit fw_core_cleanup(void)
 {
 	unregister_chrdev(fw_cdev_major, "firewire");
 	bus_unregister(&fw_bus_type);
+	idr_destroy(&fw_device_idr);
 }
 
 module_init(fw_core_init);

-- 
Stefan Richter
-=====-==--- =-== ==---
http://arcgraph.de/sr/

