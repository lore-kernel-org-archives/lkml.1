Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZKMPKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZKMPKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756373AbZKMPJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:09:58 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:54813 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbZKMPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:10 -0500
Message-Id: <20091113150918.296550253@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:09:14 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 50/52] [PATCH] cio: change locking in io_subchannel_remove
References: <20091113150824.351347652@de.ibm.com>
Content-Disposition: inline; filename=149-cio-subchannel-locking.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

IO subchannels are always unregistered in process context, so use
spin_lock_irq in the corresponding remove callback.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c	2009-11-13 16:08:22.000000000 +0100
+++ quilt-2.6/drivers/s390/cio/device.c	2009-11-13 16:08:23.000000000 +0100
@@ -1065,17 +1065,16 @@
 io_subchannel_remove (struct subchannel *sch)
 {
 	struct ccw_device *cdev;
-	unsigned long flags;
 
 	cdev = sch_get_cdev(sch);
 	if (!cdev)
 		goto out_free;
 	io_subchannel_quiesce(sch);
 	/* Set ccw device to not operational and drop reference. */
-	spin_lock_irqsave(cdev->ccwlock, flags);
+	spin_lock_irq(cdev->ccwlock);
 	sch_set_cdev(sch, NULL);
 	cdev->private->state = DEV_STATE_NOT_OPER;
-	spin_unlock_irqrestore(cdev->ccwlock, flags);
+	spin_unlock_irq(cdev->ccwlock);
 	ccw_device_unregister(cdev);
 out_free:
 	kfree(sch->private);

