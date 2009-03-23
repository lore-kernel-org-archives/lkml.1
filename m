Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbZCWQBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbZCWQBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759387AbZCWQAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:00:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52240 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZCWQAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:00:51 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: philipp.reisner@linbit.com, gregkh@suse.de
Subject: [PATCH 12/12] DRBD: final
Date: Mon, 23 Mar 2009 16:48:07 +0100
Message-Id: <1237823287-12734-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237823287-12734-12-git-send-email-philipp.reisner@linbit.com>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-3-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-4-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-5-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-6-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-7-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-8-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-9-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-10-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-11-git-send-email-philipp.reisner@linbit.com>
 <1237823287-12734-12-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig integration, Makefile and major.h

---
diff -uNrp linux-2.6.29-rc8/include/linux/major.h linux-2.6.29-rc8-drbd/include/linux/major.h
--- linux-2.6.29-rc8/include/linux/major.h	2009-03-13 03:39:28.000000000 +0100
+++ linux-2.6.29-rc8-drbd/include/linux/major.h	2009-03-23 12:45:27.894029774 +0100
@@ -145,6 +145,7 @@
 #define UNIX98_PTY_MAJOR_COUNT	8
 #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
 
+#define DRBD_MAJOR		147
 #define RTF_MAJOR		150
 #define RAW_MAJOR		162
 
/home/phil/src/drbd83/scripts
diff -uNrp linux-2.6.29-rc8/drivers/block/Kconfig linux-2.6.29-rc8-drbd/drivers/block/Kconfig
--- linux-2.6.29-rc8/drivers/block/Kconfig	2009-03-13 03:39:28.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/Kconfig	2009-03-23 12:45:27.885529728 +0100
@@ -264,6 +264,8 @@ config BLK_DEV_CRYPTOLOOP
 	  instead, which can be configured to be on-disk compatible with the
 	  cryptoloop device.
 
+source "drivers/block/drbd/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff -uNrp linux-2.6.29-rc8/drivers/block/Makefile linux-2.6.29-rc8-drbd/drivers/block/Makefile
--- linux-2.6.29-rc8/drivers/block/Makefile	2009-03-13 03:39:28.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/Makefile	2009-03-23 12:45:27.877529782 +0100
@@ -32,3 +32,4 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
diff -uNrp linux-2.6.29-rc8/drivers/block/drbd/Kconfig linux-2.6.29-rc8-drbd/drivers/block/drbd/Kconfig
--- linux-2.6.29-rc8/drivers/block/drbd/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/drbd/Kconfig	2008-11-24 11:43:33.016969000 +0100
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
diff -uNrp linux-2.6.29-rc8/drivers/block/drbd/Makefile linux-2.6.29-rc8-drbd/drivers/block/drbd/Makefile
--- linux-2.6.29-rc8/drivers/block/drbd/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.29-rc8-drbd/drivers/block/drbd/Makefile	2009-03-23 12:45:27.829529747 +0100
@@ -0,0 +1,7 @@
+#CFLAGS_drbd_sizeof_sanity_check.o = -Wpadded # -Werror
+
+drbd-objs  :=	drbd_buildtag.o drbd_bitmap.o drbd_proc.o \
+		drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o \
+		lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o
+
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
