Return-Path: <linux-kernel-owner+w=401wt.eu-S938316AbXFHHkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938316AbXFHHkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938170AbXFHHYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:15 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55155 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935571AbXFHHYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:12 -0400
Message-Id: <20070608072222.066056000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Salyzyn <mark_salyzyn@adaptec.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mark Salyzyn <aacraid@adaptec.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 37/54] SCSI: aacraid: Correct sa platform support. (Was: [Bug 8469] Bad EIP value on pentium3 SMP kernel-2.6.21.1)
Content-Disposition: inline; filename=aacraid-correct-sa-platform-support.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Mark Salyzyn <mark_salyzyn@adaptec.com>

As discussed in the bugzilla outlined below, we have an sa based
(Mustang) RAID adapter on the system, a Dell PERC2/QC. Affected
controllers are HP NetRAID, Adaptec AAC-364, Dell PERC2/QC or Adaptec
5400S. This problem  coincides with the introduction of the adapter_comm
and adapter_deliver platform functions (Message [PATCH 1/4] aacraid:
rework communication support code, January 23 2007, which initially
migrated to 2.6.21)

The panic occurs with an uninitialized adapter_deliver platform function
pointer. The enclosed patch, unmodified as tested by Rainer, solves the
problem.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/scsi/aacraid/aacraid.h |    1 +
 drivers/scsi/aacraid/rx.c      |    2 +-
 drivers/scsi/aacraid/sa.c      |    9 ++++++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/drivers/scsi/aacraid/aacraid.h
+++ linux-2.6.21.4/drivers/scsi/aacraid/aacraid.h
@@ -1840,6 +1840,7 @@ struct aac_driver_ident* aac_get_driver_
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
 int aac_probe_container(struct aac_dev *dev, int cid);
+int aac_rx_deliver_producer(struct fib * fib);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
--- linux-2.6.21.4.orig/drivers/scsi/aacraid/rx.c
+++ linux-2.6.21.4/drivers/scsi/aacraid/rx.c
@@ -378,7 +378,7 @@ static int aac_rx_check_health(struct aa
  *
  *	Will send a fib, returning 0 if successful.
  */
-static int aac_rx_deliver_producer(struct fib * fib)
+int aac_rx_deliver_producer(struct fib * fib)
 {
 	struct aac_dev *dev = fib->dev;
 	struct aac_queue *q = &dev->queues->queue[AdapNormCmdQueue];
--- linux-2.6.21.4.orig/drivers/scsi/aacraid/sa.c
+++ linux-2.6.21.4/drivers/scsi/aacraid/sa.c
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -258,6 +258,11 @@ static void aac_sa_start_adapter(struct 
 			NULL, NULL, NULL, NULL, NULL);
 }
 
+static int aac_sa_restart_adapter(struct aac_dev *dev, int bled)
+{
+	return -EINVAL;
+}
+
 /**
  *	aac_sa_check_health
  *	@dev: device to check if healthy
@@ -367,7 +372,9 @@ int aac_sa_init(struct aac_dev *dev)
 	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_sa_check_health;
+	dev->a_ops.adapter_restart = aac_sa_restart_adapter;
 	dev->a_ops.adapter_intr = aac_sa_intr;
+	dev->a_ops.adapter_deliver = aac_rx_deliver_producer;
 	dev->a_ops.adapter_ioremap = aac_sa_ioremap;
 
 	/*

-- 
