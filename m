Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYFCRHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYFCRHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYFCRFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:05:50 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:64570 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbYFCRFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:05:48 -0400
Message-Id: <20080603170520.988639783@de.ibm.com>
References: <20080603165859.107949986@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 18:59:10 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/14] cio: remove lock from ccw_device_oper_notify.
Content-Disposition: inline; filename=110-cio-locking.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

Remove unnecessary ccw device locking inside ccw_device_oper_notify.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>        
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>        
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: quilt-2.6/drivers/s390/cio/device_fsm.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device_fsm.c
+++ quilt-2.6/drivers/s390/cio/device_fsm.c
@@ -346,21 +346,15 @@ ccw_device_oper_notify(struct work_struc
 	struct ccw_device_private *priv;
 	struct ccw_device *cdev;
 	int ret;
-	unsigned long flags;
 
 	priv = container_of(work, struct ccw_device_private, kick_work);
 	cdev = priv->cdev;
 	ret = ccw_device_notify(cdev, CIO_OPER);
-	spin_lock_irqsave(cdev->ccwlock, flags);
 	if (ret) {
 		/* Reenable channel measurements, if needed. */
-		spin_unlock_irqrestore(cdev->ccwlock, flags);
 		cmf_reenable(cdev);
-		spin_lock_irqsave(cdev->ccwlock, flags);
 		wake_up(&cdev->private->wait_q);
-	}
-	spin_unlock_irqrestore(cdev->ccwlock, flags);
-	if (!ret)
+	} else
 		/* Driver doesn't want device back. */
 		ccw_device_do_unreg_rereg(work);
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

