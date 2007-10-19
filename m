Return-Path: <linux-kernel-owner+w=401wt.eu-S1764079AbXJSB0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764079AbXJSB0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 21:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbXJSB0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 21:26:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbXJSBZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 21:25:59 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710181549040.2779-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0710181549040.2779-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 19 Oct 2007 03:27:16 +0200
Message-Id: <1192757236.3308.3.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19JxmU0G6XtMG19SsRFOWKSe+pwipoEA/2Q+t+
 gJ6YpAPKPFBD+wVaG1usN0xpsa3yP3Bbuh4EeC+08MdjmvBNmy
 Y3CZOZg2fzKWGl70exP+QDEAjM9Rw8j
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-10-18 at 16:08 -0400, Alan Stern wrote:
> On Thu, 18 Oct 2007, Kay Sievers wrote:
> 
> > On Thu, 2007-10-18 at 15:23 -0400, Alan Stern wrote:
> > > This patch (as1004) fixes a refcounting bug in the development version
> > > of the block-device core.
> > > 
> > > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > > 
> > > ---
> > > 
> > > Kay, you have got to start testing your patches better!
> > 
> > That leaves references around for SCSI target devices. There must be a
> > bug somewhere else, if the patch isn't correct.
> > 
> > > Finding and
> > > fixing refcount errors is _not_ one of my favorite ways to pass the
> > > time.  For example, you could see what happens when you insert and
> > > unplug a USB flash disk a few times.
> > 
> > What do you see with the original version?
> 
> Note that a USB drive is treated as a SCSI device.
> 
> With the original code, I see the following sequence of events when 
> add_disk() is first called.  Values in parentheses are 
> atomic_read(disk->dev.kobj.kref.refcount) after each stage runs:
> 
> 	Entry to add_disk		(1)
> 	Call to register_disk
> 	device_add			(3)
> 	CONFIG_SYSFS_DEPRECATED is not set
> 	Call disk_sysfs_add_subdirs
> 	add disk->holder_dir		(4)
> 	add disk->slave_dir		(5)
> 	Return to register_disk
> 	get_capacity			(5)
> 	bdget_disk			(5)
> 	blkdev_get (partitions)		(8)
> 	blkdev_put			(7)
> 	Return to add_disk
> 	blk_register_queue		(9)
> 
> You can see how many references each stage takes.  Now here's the
> equivalent list for del_gendisk():
> 
> 	Entry to del_gendisk		(9)
> 	invalidate_ and delete_partition loop	(7)
> 	invalidate_partition 0		(7)
> 	Call unlink_gendisk
> 	blk_unregister_queue		(5)
> 	Return to del_gendisk
> 	unregister disk->holder_dir	(4)
> 	unregister disk->slave_dir	(3)
> 	CONFIG_SYSFS_DEPRECATED is not set
> 	device_del			(1)
> 	put_device			(0) -- oops!
> 
> Matching things up we have:
> 
> 	device_add/device_del		2 refs
> 	reg/unreg subdirs		2 refs
> 	subpartitions			2 refs
> 	reg/unreg block queue		2 refs
> 
> This accounts for everything in del_gendisk except the final
> put_device.  Evidently it doesn't belong there.  There's no matching 
> get_device in add_disk or register_disk.

Hmm, do you have kobject debugging enabled? Do you ever see something
like: "kobject sdb: cleaning up" when you remove the put_device()?

Kay

