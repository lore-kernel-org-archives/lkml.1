Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZC3QxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZC3QxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZC3Qsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:48:36 -0400
Received: from mail09.linbit.com ([212.69.161.110]:46740 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbZC3QsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:48:12 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, jens.axboe@oracle.com, nab@risingtidestorage.com,
       andi@firstfloor.org, Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 12/12] DRBD: final
Date: Mon, 30 Mar 2009 18:47:21 +0200
Message-Id: <1238431643-19433-14-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1238431643-19433-13-git-send-email-philipp.reisner@linbit.com>
References: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-2-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-3-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-4-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-5-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-6-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-7-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-8-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-9-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-10-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-11-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-12-git-send-email-philipp.reisner@linbit.com>
 <1238431643-19433-13-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig integration, Makefile and major.h

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff -uNrp linux-2.6.29/include/linux/major.h linux-2.6.29-drbd/include/linux/major.h
--- linux-2.6.29/include/linux/major.h	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-drbd/include/linux/major.h	2009-03-30 18:03:13.964468716 +0200
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
/home/phil/src/drbdXX/scripts
diff -uNrp linux-2.6.29/drivers/block/Kconfig linux-2.6.29-drbd/drivers/block/Kconfig
--- linux-2.6.29/drivers/block/Kconfig	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-drbd/drivers/block/Kconfig	2009-03-30 18:03:13.959968212 +0200
@@ -264,6 +264,8 @@ config BLK_DEV_CRYPTOLOOP
 	  instead, which can be configured to be on-disk compatible with the
 	  cryptoloop device.
 
+source "drivers/block/drbd/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff -uNrp linux-2.6.29/drivers/block/Makefile linux-2.6.29-drbd/drivers/block/Makefile
--- linux-2.6.29/drivers/block/Makefile	2009-03-24 00:12:14.000000000 +0100
+++ linux-2.6.29-drbd/drivers/block/Makefile	2009-03-30 18:03:13.951968507 +0200
@@ -33,3 +33,4 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
diff -uNrp linux-2.6.29/drivers/block/drbd/Kconfig linux-2.6.29-drbd/drivers/block/drbd/Kconfig
--- linux-2.6.29/drivers/block/drbd/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-drbd/drivers/block/drbd/Kconfig	2007-11-09 16:07:31.952864000 +0100
@@ -0,0 +1,32 @@
+#
+# DRBD device driver configuration
+#
+config BLK_DEV_DRBD
+	tristate "DRBD Distributed Replicated Block Device support"
+	select INET
+	select PROC_FS
+	select CONNECTOR
+	select CRYPTO
+	select CRYPTO_HMAC
+	---help---
+	  DRBD is a block device which is designed to build high availability
+	  clusters.  This is done by mirroring a whole block device via (a
+	  dedicated) network.  You could see it as a network RAID 1.
+
+	  Each minor device has a state, which can be 'primary' or 'secondary'.
+	  On the node with the primary device the application is supposed to
+	  run and to access the device (/dev/drbdX). Every write is sent to the
+	  local 'lower level block device' and via network to the node with the
+	  device in 'secondary' state.
+	  The secondary device simply writes the data to its lower level block
+	  device. Currently no read-balancing via the network is done.
+
+	  DRBD can also be used with "shared-disk semantics" (primary-primary),
+	  even though it is a "shared-nothing cluster".  You'd need to use a
+	  cluster file system on top of that for cache coherency.
+
+	  DRBD management is done through user-space tools.
+	  For automatic failover you need a cluster manager (e.g. heartbeat).
+	  See also: http://www.drbd.org/, http://www.linux-ha.org
+
+	  If unsure, say N.
diff -uNrp linux-2.6.29/drivers/block/drbd/Makefile linux-2.6.29-drbd/drivers/block/drbd/Makefile
--- linux-2.6.29/drivers/block/drbd/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-drbd/drivers/block/drbd/Makefile	2009-03-30 18:03:13.903968678 +0200
@@ -0,0 +1,7 @@
+#CFLAGS_drbd_sizeof_sanity_check.o = -Wpadded # -Werror
+
+drbd-objs  :=	drbd_buildtag.o drbd_bitmap.o drbd_proc.o \
+		drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o \
+		lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o
+
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
