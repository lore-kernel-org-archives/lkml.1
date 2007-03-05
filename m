Return-Path: <linux-kernel-owner+w=401wt.eu-S1751867AbXCEWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbXCEWmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbXCEWmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:42:32 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:20236 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXCEWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:42:18 -0500
Date: Mon, 5 Mar 2007 23:42:18 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: cornelia.huck@de.ibm.com
Subject: [S390] cio: Fix locking when calling notify function.
Message-ID: <20070305224218.GI22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

[S390] cio: Fix locking when calling notify function.

Make sure we hold the device lock when we modify the ccw device
structure but always call the notify function without the lock held.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |   67 +++++++++++++++++++++++++++++-------------
 1 files changed, 47 insertions(+), 20 deletions(-)

diff -urpN linux-2.6/drivers/s390/cio/device_fsm.c linux-2.6-patched/drivers/s390/cio/device_fsm.c
--- linux-2.6/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/cio/device_fsm.c	2007-03-05 22:51:56.000000000 +0100
@@ -334,20 +334,29 @@ ccw_device_oper_notify(struct work_struc
 	struct ccw_device *cdev;
 	struct subchannel *sch;
 	int ret;
+	unsigned long flags;
 
 	priv = container_of(work, struct ccw_device_private, kick_work);
 	cdev = priv->cdev;
+	spin_lock_irqsave(cdev->ccwlock, flags);
 	sch = to_subchannel(cdev->dev.parent);
-	ret = (sch->driver && sch->driver->notify) ?
-		sch->driver->notify(&sch->dev, CIO_OPER) : 0;
-	if (!ret)
-		/* Driver doesn't want device back. */
-		ccw_device_do_unreg_rereg(work);
-	else {
+	if (sch->driver && sch->driver->notify) {
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
+		ret = sch->driver->notify(&sch->dev, CIO_OPER);
+		spin_lock_irqsave(cdev->ccwlock, flags);
+	} else
+		ret = 0;
+	if (ret) {
 		/* Reenable channel measurements, if needed. */
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
 		cmf_reenable(cdev);
+		spin_lock_irqsave(cdev->ccwlock, flags);
 		wake_up(&cdev->private->wait_q);
 	}
+	spin_unlock_irqrestore(cdev->ccwlock, flags);
+	if (!ret)
+		/* Driver doesn't want device back. */
+		ccw_device_do_unreg_rereg(work);
 }
 
 /*
@@ -534,15 +543,21 @@ ccw_device_nopath_notify(struct work_str
 	struct ccw_device *cdev;
 	struct subchannel *sch;
 	int ret;
+	unsigned long flags;
 
 	priv = container_of(work, struct ccw_device_private, kick_work);
 	cdev = priv->cdev;
+	spin_lock_irqsave(cdev->ccwlock, flags);
 	sch = to_subchannel(cdev->dev.parent);
 	/* Extra sanity. */
 	if (sch->lpm)
-		return;
-	ret = (sch->driver && sch->driver->notify) ?
-		sch->driver->notify(&sch->dev, CIO_NO_PATH) : 0;
+		goto out_unlock;
+	if (sch->driver && sch->driver->notify) {
+		spin_unlock_irqrestore(cdev->ccwlock, flags);
+		ret = sch->driver->notify(&sch->dev, CIO_NO_PATH);
+		spin_lock_irqsave(cdev->ccwlock, flags);
+	} else
+		ret = 0;
 	if (!ret) {
 		if (get_device(&sch->dev)) {
 			/* Driver doesn't want to keep device. */
@@ -562,6 +577,8 @@ ccw_device_nopath_notify(struct work_str
 		cdev->private->state = DEV_STATE_DISCONNECTED;
 		wake_up(&cdev->private->wait_q);
 	}
+out_unlock:
+	spin_unlock_irqrestore(cdev->ccwlock, flags);
 }
 
 void
@@ -607,10 +624,13 @@ ccw_device_verify_done(struct ccw_device
 	default:
 		/* Reset oper notify indication after verify error. */
 		cdev->private->flags.donotify = 0;
-		PREPARE_WORK(&cdev->private->kick_work,
-			     ccw_device_nopath_notify);
-		queue_work(ccw_device_notify_work, &cdev->private->kick_work);
-		ccw_device_done(cdev, DEV_STATE_NOT_OPER);
+		if (cdev->online) {
+			PREPARE_WORK(&cdev->private->kick_work,
+				     ccw_device_nopath_notify);
+			queue_work(ccw_device_notify_work,
+				   &cdev->private->kick_work);
+		} else
+			ccw_device_done(cdev, DEV_STATE_NOT_OPER);
 		break;
 	}
 }
@@ -756,15 +776,22 @@ static void
 ccw_device_online_notoper(struct ccw_device *cdev, enum dev_event dev_event)
 {
 	struct subchannel *sch;
+	int ret;
 
 	sch = to_subchannel(cdev->dev.parent);
-	if (sch->driver->notify &&
-	    sch->driver->notify(&sch->dev, sch->lpm ? CIO_GONE : CIO_NO_PATH)) {
-			ccw_device_set_timeout(cdev, 0);
-			cdev->private->flags.fake_irb = 0;
-			cdev->private->state = DEV_STATE_DISCONNECTED;
-			wake_up(&cdev->private->wait_q);
-			return;
+	if (sch->driver->notify) {
+		spin_unlock_irq(cdev->ccwlock);
+		ret = sch->driver->notify(&sch->dev,
+					  sch->lpm ? CIO_GONE : CIO_NO_PATH);
+		spin_lock_irq(cdev->ccwlock);
+	} else
+		ret = 0;
+	if (ret) {
+		ccw_device_set_timeout(cdev, 0);
+		cdev->private->flags.fake_irb = 0;
+		cdev->private->state = DEV_STATE_DISCONNECTED;
+		wake_up(&cdev->private->wait_q);
+		return;
 	}
 	cdev->private->state = DEV_STATE_NOT_OPER;
 	cio_disable_subchannel(sch);
