Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbXITJZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbXITJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXITJZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:25:17 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:25090 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXITJZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:25:15 -0400
Date: Thu, 20 Sep 2007 11:24:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 4/4] sysfs: make suicidal nodes just do it directly
Message-ID: <20070920112440.6216644b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11902731751771-git-send-email-htejun@gmail.com>
References: <11902731752407-git-send-email-htejun@gmail.com>
	<11902731751771-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 16:26:15 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Sysfs now allows direct suicide.  Make suicidial sysfs nodes to use
> it and remove now unncessary callback mechanism.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  drivers/base/core.c         |   33 ----------------------
>  drivers/s390/cio/ccwgroup.c |   25 +++-------------
>  drivers/scsi/scsi_sysfs.c   |   13 +--------
>  fs/sysfs/file.c             |   63 -------------------------------------------
>  include/linux/device.h      |    6 ----
>  include/linux/sysfs.h       |    9 ------
>  6 files changed, 6 insertions(+), 143 deletions(-)
> 

Just browsing through this (I'll review and do some tests later), but
you missed drivers/s390/cio/device.c::ccw_device_remove_disconnected().

Following (not event compile tested) patch (which is basically a revert
of 59a8a6e227cf0bc42e5be741ebfea97c222ab9ef) should take care of it.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/s390/cio/device.c |   51 +++++++++-------------------------------------
 1 files changed, 10 insertions(+), 41 deletions(-)

--- linux-2.6.orig/drivers/s390/cio/device.c
+++ linux-2.6/drivers/s390/cio/device.c
@@ -288,62 +288,31 @@ static void ccw_device_unregister(struct
 		device_del(&cdev->dev);
 }
 
-static void ccw_device_remove_orphan_cb(struct device *dev)
-{
-	struct ccw_device *cdev = to_ccwdev(dev);
-
-	ccw_device_unregister(cdev);
-	put_device(&cdev->dev);
-}
-
-static void ccw_device_remove_sch_cb(struct device *dev)
-{
-	struct subchannel *sch;
-
-	sch = to_subchannel(dev);
-	css_sch_device_unregister(sch);
-	/* Reset intparm to zeroes. */
-	sch->schib.pmcw.intparm = 0;
-	cio_modify(sch);
-	put_device(&sch->dev);
-}
-
 static void
 ccw_device_remove_disconnected(struct ccw_device *cdev)
 {
+	struct subchannel *sch;
 	unsigned long flags;
-	int rc;
 
 	/*
 	 * Forced offline in disconnected state means
 	 * 'throw away device'.
 	 */
 	if (ccw_device_is_orphan(cdev)) {
-		/*
-		 * Deregister ccw device.
-		 * Unfortunately, we cannot do this directly from the
-		 * attribute method.
-		 */
+		/* Deregister ccw device. */
 		spin_lock_irqsave(cdev->ccwlock, flags);
 		cdev->private->state = DEV_STATE_NOT_OPER;
 		spin_unlock_irqrestore(cdev->ccwlock, flags);
-		rc = device_schedule_callback(&cdev->dev,
-					      ccw_device_remove_orphan_cb);
-		if (rc)
-			CIO_MSG_EVENT(2, "Couldn't unregister orphan "
-				      "0.%x.%04x\n",
-				      cdev->private->dev_id.ssid,
-				      cdev->private->dev_id.devno);
+		ccw_device_unregister(cdev);
+		put_device(&cdev->dev);
 		return;
 	}
-	/* Deregister subchannel, which will kill the ccw device. */
-	rc = device_schedule_callback(cdev->dev.parent,
-				      ccw_device_remove_sch_cb);
-	if (rc)
-		CIO_MSG_EVENT(2, "Couldn't unregister disconnected device "
-			      "0.%x.%04x\n",
-			      cdev->private->dev_id.ssid,
-			      cdev->private->dev_id.devno);
+	sch = to_subchannel(cdev->dev.parent);
+	css_sch_device_unregister(sch);
+	/* Reset intparm to zeroes. */
+	sch->schib.pmcw.intparm = 0;
+	cio_modify(sch);
+	put_device(&sch->dev);
 }
 
 /**
