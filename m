Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZHNL1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZHNL1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932313AbZHNL1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:27:02 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:52578 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbZHNL07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:59 -0400
Message-Id: <20090814112613.237354848@de.ibm.com>
References: <20090814112517.982007860@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 13:25:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/34] cio: consolidate subchannel intparm reset
Content-Disposition: inline; filename=102-cio-intparm-reset.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Ensure that the hardware interruption parameter for a subchannel is
reset when the associated subchannel data structure is freed.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.c    |    3 +++
 drivers/s390/cio/device.c |   10 ----------
 2 files changed, 3 insertions(+), 10 deletions(-)

Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -170,6 +170,9 @@ css_subchannel_release(struct device *de
 
 	sch = to_subchannel(dev);
 	if (!cio_is_console(sch->schid)) {
+		/* Reset intparm to zeroes. */
+		sch->config.intparm = 0;
+		cio_commit_config(sch);
 		kfree(sch->lock);
 		kfree(sch);
 	}
Index: quilt-2.6/drivers/s390/cio/device.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device.c
+++ quilt-2.6/drivers/s390/cio/device.c
@@ -1026,9 +1026,6 @@ static void ccw_device_call_sch_unregist
 		return;
 	sch = to_subchannel(cdev->dev.parent);
 	css_sch_device_unregister(sch);
-	/* Reset intparm to zeroes. */
-	sch->config.intparm = 0;
-	cio_commit_config(sch);
 	/* Release cdev reference for workqueue processing.*/
 	put_device(&cdev->dev);
 	/* Release subchannel reference for local processing. */
@@ -1212,9 +1209,6 @@ static void io_subchannel_do_unreg(struc
 
 	sch = container_of(work, struct subchannel, work);
 	css_sch_device_unregister(sch);
-	/* Reset intparm to zeroes. */
-	sch->config.intparm = 0;
-	cio_commit_config(sch);
 	put_device(&sch->dev);
 }
 
@@ -1690,10 +1684,6 @@ static int io_subchannel_sch_event(struc
 		spin_unlock_irqrestore(sch->lock, flags);
 		css_sch_device_unregister(sch);
 		spin_lock_irqsave(sch->lock, flags);
-
-		/* Reset intparm to zeroes. */
-		sch->config.intparm = 0;
-		cio_commit_config(sch);
 		break;
 	case REPROBE:
 		ccw_device_trigger_reprobe(cdev);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

