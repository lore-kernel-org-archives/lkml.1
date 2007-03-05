Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbXCEWnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbXCEWnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXCEWnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:43:15 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:56270 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbXCEWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:42:33 -0500
Date: Mon, 5 Mar 2007 23:42:31 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Use path verification to check for path state.
Message-ID: <20070305224231.GJ22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Use path verification to check for path state.

After I/O has been killed by the common I/O layer, trigger path
verification which will queue cio_device_nopath_notify itself if it
finds a device to be without paths.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |   46 +++++-------------------------------------
 1 files changed, 6 insertions(+), 40 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/device_fsm.c linux-2.6-patched/drivers/s390/cio/device_fsm.c
--- linux-2.6/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:57.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:57.000000000 +0100
@@ -996,18 +996,12 @@ ccw_device_killing_irq(struct ccw_device
 
 	sch = to_subchannel(cdev->dev.parent);
 	ccw_device_set_timeout(cdev, 0);
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	/* OK, i/o is dead now. Call interrupt handler. */
-	cdev->private->state = DEV_STATE_ONLINE;
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
-	if (!sch->lpm) {
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-	} else if (cdev->private->flags.doverify)
-		/* Start delayed path verification. */
-		ccw_device_online_verify(cdev, 0);
 }
 
 static void
@@ -1020,21 +1014,8 @@ ccw_device_killing_timeout(struct ccw_de
 		ccw_device_set_timeout(cdev, 3*HZ);
 		return;
 	}
-	if (ret == -ENODEV) {
-		struct subchannel *sch;
-
-		sch = to_subchannel(cdev->dev.parent);
-		if (!sch->lpm) {
-			PREPARE_WORK(&cdev->private->kick_work,
-				     ccw_device_nopath_notify);
-			queue_work(ccw_device_notify_work,
-				   &cdev->private->kick_work);
-		} else
-			dev_fsm_event(cdev, DEV_EVENT_NOTOPER);
-		return;
-	}
-	//FIXME: Can we get here?
-	cdev->private->state = DEV_STATE_ONLINE;
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
@@ -1052,26 +1033,11 @@ void device_kill_io(struct subchannel *s
 		cdev->private->state = DEV_STATE_TIMEOUT_KILL;
 		return;
 	}
-	if (ret == -ENODEV) {
-		if (!sch->lpm) {
-			PREPARE_WORK(&cdev->private->kick_work,
-				     ccw_device_nopath_notify);
-			queue_work(ccw_device_notify_work,
-				   &cdev->private->kick_work);
-		} else
-			dev_fsm_event(cdev, DEV_EVENT_NOTOPER);
-		return;
-	}
+	/* Start delayed path verification. */
+	ccw_device_online_verify(cdev, 0);
 	if (cdev->handler)
 		cdev->handler(cdev, cdev->private->intparm,
 			      ERR_PTR(-EIO));
-	if (!sch->lpm) {
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-	} else
-		/* Start delayed path verification. */
-		ccw_device_online_verify(cdev, 0);
 }
 
 static void
