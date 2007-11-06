Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXKFTtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXKFTtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXKFTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:49:39 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754118AbXKFTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:49:38 -0500
Date: Tue, 6 Nov 2007 14:49:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
In-Reply-To: <20071105215949.GA29754@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711061419090.8694-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Greg KH wrote:

> On Mon, Nov 05, 2007 at 04:49:21PM -0500, Alan Stern wrote:
> > Greg:
> > 
> > So what's our status?  Do you think it's worthwhile adding the 
> > "drop reference to parent kobject at remove time instead of release 
> > time" patch?
> 
> No.
> 
> I still need to take the time and read this thread and find the real
> problem here.  The fact that the issue does not show up for other,
> non-scsi block devices, makes me feel this is a scsi-specific problem
> with how it deals with the driver model, but I need to take the time to
> sit down and figure it out for sure.

Here's the story as far as the SCSI stack goes.  To what extent other 
subsystems have analogous problems, I don't know.

     1. In drivers/scsi/scsi_scan.c, scsi_alloc_sdev() creates a
	scsi_device structure and calls scsi_alloc_queue(), which
	ends up calling blk_init_queue().  As the creator of the
	request_queue, the SCSI core owns the initial reference
	to q->kobj.

     2. This reference is released as part of the scsi_device's
	release routine.  In scsi_sysfs.c,
	scsi_device_dev_release_usercontext() calls scsi_free_queue(),
	which does nothing but call blk_cleanup_queue(), which
	calls blk_put_queue(), which does the final kobject_put()
	on q->kobj.

As a result of 1 and 2, the request_queue isn't released until the
scsi_device is released.

     3. In sd.c, sd_probe() does "gd = alloc_disk()" and it sets
	gd->driverfs_dev to point to the scsi_device's embedded
	struct device (named sdev_gendev).  It then calls add_disk()
	in block/genhd.c, which calls register_disk() in
	fs/partitions/check.c.  register_disk() sets disk->dev.parent
	to disk->driverfs_dev and then calls device_add(&disk->dev).

Setting disk->dev.parent and calling device_add() in this way is new to
Kay's reworking of the driver core.  Previously disk->dev.kobj had been
registered directly, as the gendisk was some sort of class device
rather than a regular device.

Anyway, the upshot of 3 is that sdev->sdev_gendev.kobj is the parent of
disk->dev.kobj, and consequently the scsi_device can't be released
until the gendisk is released.

     4. add_disk() goes on to call blk_register_queue(disk), which sets
	q->kobj.parent to disk->dev.kobj and then calls
	kobject_add(&q->kobj).

As a result of 4, the gendisk can't be released until the request_queue 
is released.

Thus we have a cycle:

	1&2: request_queue isn't released before scsi_device;

	3: scsi_device isn't released before gendisk;

	4: gendisk isn't released before request_queue.

The dependency in 1&2 is hard-coded into the SCSI core.  If I 
understand correctly, the core really does need the request_queue to 
hang around as long as the scsi_device is still present.  According to 
James Bottomley, any block device driver should be expected to have a 
similar requirement.

But the dependencies in 3 and 4 are unnecessary.  They are artifacts,
caused by the fact that a kobject doesn't drop its reference to its
parent until it is released.  If instead the reference to the parent
were dropped when the kobject was removed then 3 and 4 wouldn't apply.

Alan Stern

