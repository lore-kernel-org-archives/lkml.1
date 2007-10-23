Return-Path: <linux-kernel-owner+w=401wt.eu-S1752448AbXJWL0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbXJWL0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXJWL0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:26:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbXJWL0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:26:31 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>
In-Reply-To: <Pine.LNX.4.44L0.0710230001560.13902-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0710230001560.13902-100000@netrider.rowland.org>
Content-Type: multipart/mixed; boundary="=-eBrn8utCVnnjNZnrza9u"
Date: Tue, 23 Oct 2007 13:27:49 +0200
Message-Id: <1193138869.2239.12.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Provags-ID: V01U2FsdGVkX18lIL/voNMYqaeq10cF83fTFMCloUgdM/cyF1K
 RT1bYSAsGdvA5GIfUfwf3kvAEL5iWjSW/gmdJJvcBBrCxiAcFk
 SoiBIqRhPwAA64pBve1A028RAsPkx/o
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eBrn8utCVnnjNZnrza9u
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-10-23 at 00:14 -0400, Alan Stern wrote:
> On Tue, 23 Oct 2007, Kay Sievers wrote:
> 
> > There is definitely something wrong, I tried all sorts of options now,
> > and a second machine, and I can never get the behavior you see. I even
> > booted with init=/bin/sh.
> > But true, looking at the kobject debugging for loop devices, and usb
> > storage driven by the ub driver, all looks fine without the additional
> > put.
> 
> Yes; I haven't been able to figure out why we get different results.
> 
> > There must be something going wrong with the block patch in conjunction
> > with the crazy SCSI release logic.
> 
> I don't know -- there's nothing obviously wrong with the block patch 
> except the extra put_device.  But you're right that the SCSI logic is 
> crazy.  The scsi_device is the parent of the gendisk, which is the 
> parent of the request_queue.  But the scsi_device holds a reference to 
> the request_queue, which is dropped in the scsi_device's release 
> routine!

That's the thing. We see a circular reference when we use the SCSI LUN
as the parent.
The sysfs relationship is: scsi_device -> genhd -> queue, while the
queue holds a ref to to the blockdev (parent), the blockdev to the
scsi_device (parent) and the scsi_devices to the queue (SCSI). All
waiting for their release functions to be called, to release the other
refs.

The scsi_device needs to drop the queue reference while the device is
removed, not when it's data is released. Hannes came up with the
attached patch, which seems to work fine here.

> That doesn't make much sense to me, and it is complicated by 
> the fact that deleting a kobject doesn't drop the kobject's reference 
> to its parent -- only releasing the kobject does.

Right, that makes things very complicated.

> In fact, for my development work I normally use a patch which makes 
> kobjects behave better: They do drop the reference to their parent when 
> they are deleted.  This actually is nothing more than a reversion of a 
> patch added several years ago to try and cover up some of the 
> weaknesses of the SCSI stack!  Now that the SCSI stack is in better 
> shape, maybe my patch should be included in the mainstream kernel.  The 
> patch is below; see what you think.

Sounds good to me, to disconnect a dead object from its parent when it's
deleted. We only need to protect for "use after free" but not lock the
parent, I guess. We should give it a try.

Thanks,
Kay

--=-eBrn8utCVnnjNZnrza9u
Content-Disposition: inline; filename=scsi-sysfs-drop-queue-ref-on-remove.patch
Content-Type: text/x-patch; name=scsi-sysfs-drop-queue-ref-on-remove.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index daed37d..577bbf3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -280,15 +280,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	list_del(&sdev->starved_entry);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
-	if (sdev->request_queue) {
-		sdev->request_queue->queuedata = NULL;
-		/* user context needed to free queue */
-		scsi_free_queue(sdev->request_queue);
-		/* temporary expedient, try to catch use of queue lock
-		 * after free of sdev */
-		sdev->request_queue = NULL;
-	}
-
 	scsi_target_reap(scsi_target(sdev));
 
 	kfree(sdev->inquiry);
@@ -799,6 +790,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
+
+	if (sdev->request_queue) {
+		sdev->request_queue->queuedata = NULL;
+		/* user context needed to free queue */
+		scsi_free_queue(sdev->request_queue);
+		/* temporary expedient, try to catch use of queue lock
+		 * after free of sdev */
+		sdev->request_queue = NULL;
+	}
+
 	put_device(dev);
 }
 

--=-eBrn8utCVnnjNZnrza9u--

