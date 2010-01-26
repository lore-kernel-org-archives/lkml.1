Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317Ab0AZXte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0AZXte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052Ab0AZXtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:49:21 -0500
Received: from kroah.org ([198.145.64.141]:35460 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab0AZXoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233930.711402542@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [75/98] [S390] cio: fix double free in case of probe failure
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

commit 48e4c385c5f54626651cca027afe242439281899 upstream.

io_subchannel_probe() frees memory for sch->private which is later
freed again when io_subchannel_remove() is called. Fix this problem
by removing the cleanup in io_subchannel_probe().

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/cio/device.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -1292,7 +1292,7 @@ static int io_subchannel_probe(struct su
 	sch->private = kzalloc(sizeof(struct io_subchannel_private),
 			       GFP_KERNEL | GFP_DMA);
 	if (!sch->private)
-		goto out_err;
+		goto out_schedule;
 	/*
 	 * First check if a fitting device may be found amongst the
 	 * disconnected devices or in the orphanage.
@@ -1317,7 +1317,7 @@ static int io_subchannel_probe(struct su
 	}
 	cdev = io_subchannel_create_ccwdev(sch);
 	if (IS_ERR(cdev))
-		goto out_err;
+		goto out_schedule;
 	rc = io_subchannel_recog(cdev, sch);
 	if (rc) {
 		spin_lock_irqsave(sch->lock, flags);
@@ -1325,9 +1325,7 @@ static int io_subchannel_probe(struct su
 		spin_unlock_irqrestore(sch->lock, flags);
 	}
 	return 0;
-out_err:
-	kfree(sch->private);
-	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
+
 out_schedule:
 	io_subchannel_schedule_removal(sch);
 	return 0;
@@ -1341,13 +1339,14 @@ io_subchannel_remove (struct subchannel 
 
 	cdev = sch_get_cdev(sch);
 	if (!cdev)
-		return 0;
+		goto out_free;
 	/* Set ccw device to not operational and drop reference. */
 	spin_lock_irqsave(cdev->ccwlock, flags);
 	sch_set_cdev(sch, NULL);
 	cdev->private->state = DEV_STATE_NOT_OPER;
 	spin_unlock_irqrestore(cdev->ccwlock, flags);
 	ccw_device_unregister(cdev);
+out_free:
 	kfree(sch->private);
 	sysfs_remove_group(&sch->dev.kobj, &io_subchannel_attr_group);
 	return 0;


