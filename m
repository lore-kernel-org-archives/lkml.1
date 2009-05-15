Return-Path: <linux-kernel-owner+w=401wt.eu-S1762943AbZEOMRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762943AbZEOMRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760096AbZEOML6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:11:58 -0400
Received: from mail09.linbit.com ([212.69.161.110]:47291 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977AbZEOMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:11:48 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 16/16] DRBD: final
Date: Fri, 15 May 2009 14:10:43 +0200
Message-Id: <1242389443-3470-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242389443-3470-16-git-send-email-philipp.reisner@linbit.com>
References: <1242389443-3470-1-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-2-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-3-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-4-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-5-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-6-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-7-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-8-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-9-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-10-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-11-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-12-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-13-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-14-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-15-git-send-email-philipp.reisner@linbit.com>
 <1242389443-3470-16-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig integration and Makefile

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

---
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index ddea8e4..e8db999 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -271,6 +271,8 @@ config BLK_DEV_CRYPTOLOOP
 	  instead, which can be configured to be on-disk compatible with the
 	  cryptoloop device.
 
+source "drivers/block/drbd/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 7755a5e..33f0046 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -35,5 +35,6 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 
 swim_mod-objs	:= swim.o swim_asm.o
diff --git a/drivers/block/drbd/Kconfig b/drivers/block/drbd/Kconfig
new file mode 100644
index 0000000..b367677
--- /dev/null
+++ b/drivers/block/drbd/Kconfig
@@ -0,0 +1,48 @@
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
+	select LRU_CACHE
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
+
+config DRBD_TRACE
+	tristate "DRBD tracing"
+	depends on BLK_DEV_DRBD
+	select TRACEPOINTS
+	help
+
+	  Say Y here if you want to be able to trace various events in DRBD.
+
+	  If unsure, say N.
diff --git a/drivers/block/drbd/Makefile b/drivers/block/drbd/Makefile
new file mode 100644
index 0000000..9dd069b
--- /dev/null
+++ b/drivers/block/drbd/Makefile
@@ -0,0 +1,8 @@
+drbd-y := drbd_buildtag.o drbd_bitmap.o drbd_proc.o
+drbd-y += drbd_worker.o drbd_receiver.o drbd_req.o drbd_actlog.o
+drbd-y += drbd_main.o drbd_strings.o drbd_nl.o
+
+drbd_trace-y := drbd_tracing.o drbd_strings.o
+
+obj-$(CONFIG_BLK_DEV_DRBD)     += drbd.o
+obj-$(CONFIG_DRBD_TRACE)       += drbd_trace.o
