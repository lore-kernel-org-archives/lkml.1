Return-Path: <linux-kernel-owner+w=401wt.eu-S934409AbZDJMT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409AbZDJMT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764007AbZDJMNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:13:37 -0400
Received: from mail09.linbit.com ([212.69.161.110]:40089 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985AbZDJMNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:13:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 14/14] DRBD: final
Date: Fri, 10 Apr 2009 14:12:25 +0200
Message-Id: <1239365545-10356-15-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239365545-10356-14-git-send-email-philipp.reisner@linbit.com>
References: <1239365545-10356-1-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-2-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-3-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-4-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-5-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-6-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-7-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-8-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-9-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-10-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-11-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-12-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-13-git-send-email-philipp.reisner@linbit.com>
 <1239365545-10356-14-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig integration and Makefile

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff -uNrp linux-2.6.30-rc1/drivers/block/Kconfig linux-2.6.30-rc1-drbd/drivers/block/Kconfig
--- linux-2.6.30-rc1/drivers/block/Kconfig	2009-04-07 23:25:01.000000000 +0200
+++ linux-2.6.30-rc1-drbd/drivers/block/Kconfig	2009-04-10 13:13:43.178491859 +0200
@@ -271,6 +271,8 @@ config BLK_DEV_CRYPTOLOOP
 	  instead, which can be configured to be on-disk compatible with the
 	  cryptoloop device.
 
+source "drivers/block/drbd/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff -uNrp linux-2.6.30-rc1/drivers/block/Makefile linux-2.6.30-rc1-drbd/drivers/block/Makefile
--- linux-2.6.30-rc1/drivers/block/Makefile	2009-04-07 23:25:01.000000000 +0200
+++ linux-2.6.30-rc1-drbd/drivers/block/Makefile	2009-04-10 13:13:43.166492009 +0200
@@ -37,3 +37,4 @@ obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
 
 swim_mod-objs	:= swim.o swim_asm.o
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
diff -uNrp linux-2.6.30-rc1/drivers/block/drbd/Kconfig linux-2.6.30-rc1-drbd/drivers/block/drbd/Kconfig
--- linux-2.6.30-rc1/drivers/block/drbd/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30-rc1-drbd/drivers/block/drbd/Kconfig	2009-04-01 12:07:38.936194000 +0200
@@ -0,0 +1,37 @@
+#
+# DRBD device driver configuration
+#
+
+comment "DRBD disabled because PROC_FS, INET or CONNECTOR not selected"
+	depends on !PROC_FS || !INET || !CONNECTOR
+
+config BLK_DEV_DRBD
+	tristate "DRBD Distributed Replicated Block Device support"
+	depends on PROC_FS && INET && CONNECTOR
+	help
+
+	  NOTE: In order to authenticate connections you have to select
+	  CRYPTO_HMAC and a hash function as well.
+
+	  DRBD is a shared-nothing, synchronously replicated block device. It
+	  is designed to serve as a building block for high availability
+	  clusters and in this context, is a "drop-in" replacement for shared
+	  storage. Simplistically, you could see it as a network RAID 1.
+
+	  Each minor device has a role, which can be 'primary' or 'secondary'.
+	  On the node with the primary device the application is supposed to
+	  run and to access the device (/dev/drbdX). Every write is sent to
+	  the local 'lower level block device' and, across the network, to the
+	  node with the device in 'secondary' state.  The secondary device
+	  simply writes the data to its lower level block device.
+
+	  DRBD can also be used in dual-Primary mode (device writable on both
+	  nodes), which means it can exhibit shared disk semantics in a
+	  shared-nothing cluster.  Needless to say, on top of dual-Primary
+	  DRBD utilizing a cluster file system is necessary to maintain for
+	  cache coherency.
+
+	  For automatic failover you need a cluster manager (e.g. heartbeat).
+	  See also: http://www.drbd.org/, http://www.linux-ha.org
+
+	  If unsure, say N.
diff -uNrp linux-2.6.30-rc1/drivers/block/drbd/Makefile linux-2.6.30-rc1-drbd/drivers/block/drbd/Makefile
--- linux-2.6.30-rc1/drivers/block/drbd/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.30-rc1-drbd/drivers/block/drbd/Makefile	2009-04-10 13:13:43.058491920 +0200
@@ -0,0 +1,5 @@
+drbd-y := drbd_buildtag.o drbd_bitmap.o drbd_proc.o
+drbd-y += drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o
+drbd-y += lru_cache.o drbd_main.o drbd_strings.o drbd_nl.o
+
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
